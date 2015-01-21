From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
Date: Wed, 21 Jan 2015 09:55:20 -0500
Message-ID: <CANP1eJEwYFKvCcPpzeRnXqeLTRf1qFs194ubMcQcsksCuEbpMQ@mail.gmail.com>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141125150101.9596a09e.akpm@linux-foundation.org>
	<CANP1eJEALZTwMv0Z1udmPWKhfGmpe+idtdRASp62Jm_V0N2HcQ@mail.gmail.com>
	<20141202144200.a4ca81a46a43563a8874fd8e@linux-foundation.org>
	<CANP1eJGVyBOt1rQ8jA4tMrNGX5X61-UWbVy6kKj_ByeTqAEOBQ@mail.gmail.com>
	<20141204151102.2d7e11dca39f130c2dff2294@linux-foundation.org>
	<E1Xwo5O-00GRl4-Cc@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <E1Xwo5O-00GRl4-Cc@intern.SerNet.DE>
Sender: owner-linux-aio@kvack.org
To: Volker Lendecke <Volker.Lendecke@sernet.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Dec 5, 2014 at 3:17 AM, Volker Lendecke
<Volker.Lendecke@sernet.de> wrote:
>
> On Thu, Dec 04, 2014 at 03:11:02PM -0800, Andrew Morton wrote:
> > I can see all that, but it's handwaving.  Yes, preadv2() will perform
> > better in some circumstances than fincore+pread.  But how much better?
> > Enough to justify this approach, or not?
> >
> > Alas, the only way to really settle that is to implement fincore() and
> > to subject it to a decent amount of realistic quantitative testing.
> >
> > Ho hum.
> >
> > Could you please hunt down some libuv developers, see if we can solicit
> > some quality input from them?  As I said, we really don't want to merge
> > this then find that people don't use it for some reason, or that it
> > needs changes.
>
> All I can say from a Samba perspective is that none of the ARM based
> Storage boxes I have seen so far do AIO because of the base footprint
> for every read. For sequential reads kernel-level readahead could kick
> in properly and we should be able to give them the best of both worlds:
> No context switches in the default case but also good parallel behaviour
> for other workloads.  The most important benchmark for those guys is to
> read a DVD image, whether it makes sense or not.


I just made wanted to share some progress on this. And I apologize for
for all these different threads (this, LSF/FS and then Jermey and
Volker).

I recently implemented cifs support (via libsmbcli) for FIO so I can
have some hard numbers on the benchmarks. So all you guys will be
seeing more data soon enough. It's going to take a bit of time to put
it together because it takes a lot of time to benchmark to make sure
we have correct and non-noisy numbers.

In the meantime I have some numbers from my first run here:
http://i.imgur.com/05SMu8d.jpg

Sorry for the link to the image, it was easier. The test case is a
single FIO client doing 4K random reads, on localhost smbd server, on
a fully cached file for 10 minutes with a 1 minute warm up.

Threadpool + preadv2 for fast read does much better in terms of
bandwidth and a bit better in terms of latency. Sync is still the
fastest, but the gap is narrowed. Not a bad improvement for (Volker's)
9 line change to samba code.

Also, I look into why the gap between sync and threadpool + preadv2 is
not even smaller. From my preliminary investigation it looks like the
async threadpool code path does a lot more work then the sync call...
even in the case we do the fast read. According to perf the hotest
code userspace (smbd+ library) is malloc + free. So I imagine the
optimizing the fast read case to avoid a bunch of extra request
allocations will bring us even closer to sync.

Again, I'll have and more complex test cases soon just wanted to share
progress. I imagine that they'll the gap between threadpool + preadv2
and just threadpool is going to get wider as add more blocking calls
into the queue. I'll have number on that as soon as week can.


diff --git a/source3/modules/vfs_default.c b/source3/modules/vfs_default.c
index 5634cc0..90348d8 100644
--- a/source3/modules/vfs_default.c
+++ b/source3/modules/vfs_default.c
@@ -718,6 +741,7 @@ static struct tevent_req
*vfswrap_pread_send(struct vfs_handle_struct *handle,
        struct tevent_req *req;
        struct vfswrap_asys_state *state;
        int ret;
+       ssize_t nread;

        req = tevent_req_create(mem_ctx, &state, struct vfswrap_asys_state);
        if (req == NULL) {
@@ -730,6 +754,14 @@ static struct tevent_req
*vfswrap_pread_send(struct vfs_handle_struct *handle,
        state->asys_ctx = handle->conn->sconn->asys_ctx;
        state->req = req;

+       nread = pread2(fsp->fh->fd, data, n, offset, RWF_NONBLOCK);
+       // TODO: partial reads
+       if (nread == n) {
+               state->ret = nread;
+               tevent_req_done(req);
+               return tevent_req_post(req, ev);
+       }
+
        SMBPROFILE_BYTES_ASYNC_START(syscall_asys_pread, profile_p,
                                     state->profile_bytes, n);
        ret = asys_pread(state->asys_ctx, fsp->fh->fd, data, n, offset, req);


-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
