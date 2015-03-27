From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache only)
Date: Fri, 27 Mar 2015 12:45:54 -0400
Message-ID: <CANP1eJFfwGrRNRBJqrMg2gDEepeNXBSfzMN+SwqxQME-193j_A@mail.gmail.com>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<20150327081822.GA28669@infradead.org>
	<20150327013516.8c6788be.akpm@linux-foundation.org>
	<20150327084833.GA7689@infradead.org>
	<20150327020159.eadd0ce1.akpm@linux-foundation.org>
	<20150327155854.GA5548@samba2>
	<20150327093046.53c2769a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150327093046.53c2769a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Allison <jra@samba.org>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 27, 2015 at 12:30 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 27 Mar 2015 08:58:54 -0700 Jeremy Allison <jra@samba.org> wrote:
>
>> On Fri, Mar 27, 2015 at 02:01:59AM -0700, Andrew Morton wrote:
>> > On Fri, 27 Mar 2015 01:48:33 -0700 Christoph Hellwig <hch@infradead.org> wrote:
>> >
>> > > On Fri, Mar 27, 2015 at 01:35:16AM -0700, Andrew Morton wrote:
>> > > > fincore() doesn't have to be ugly.  Please address the design issues I
>> > > > raised.  How is pread2() useful to the class of applications which
>> > > > cannot proceed until all data is available?
>> > >
>> > > It actually makes them work correctly?  preadv2( ..., DONTWAIT) will
>> > > return -EGAIN, which causes them to bounce to the threadpool where
>> > > they call preadv(...).
>> >
>> > (I assume you mean RWF_NONBLOCK)
>> >
>> > That isn't how pread2() works.  If the leading one or more pages are
>> > uptodate, pread2() will return a partial read.  Now what?  Either the
>> > application reads the same data a second time via the worker thread
>> > (dumb, but it will usually be a rare case)
>>
>> The problem with the above is that we can't tell the difference
>> between pread2() returning a short read because the pages are not
>> in cache, or because someone truncated the file. So we need some
>> way to differentiate this.
>>
>> My preference from userspace would be for pread2() to return
>> EAGAIN if *all* the data requested is not available (where
>> 'all' can be less than the size requested if the file has
>> been truncated in the meantime).
>>
>> ...
>>
>> The thing I want to avoid is the case where
>> ret < size_wanted means only part of the file
>> is in cache.
>
> From my reading of the code, pread2() will return -EAGAIN only when it
> copied zero bytes to userspace.  ie, the very first page wasn't in
> cache.  If pread2() does copy some data to userspace then it will
> return the amount of data copied.  This is traditional read()
> behaviour.
>
> Maybe there's some other code somewhere in the patch which converts
> that short read into -EAGAIN, dunno - the changelogs don't appear to
> mention it and the manpage update is ambiguous about this.
>
> But from an interface perspective the behaviour you're asking for is
> insane, frankly - if the kernel copied out 8k of data then pread2()
> should return 8k.  Otherwise there's no way for userspace to know that
> the 8k copy actually happened and we have just wasted a great pile of
> CPU doing a pointless memcpy.
>
> I expect that this situation (first part in cache, latter part not in
> cache) is rare - for reasonably small requests the common cases will be
> "all cached" and "nothing cached".  So perhaps the best approach here
> is for samba to add special handling for the short read, to work out
> the reason for its occurrence.
>
> Alternatively we could add another flag to pread2() to select this
> "throw away my data and return -EAGAIN" behaviour.  Presumably
> implemented with an i_size check, but it's gonna be racy.
>
>
>
> I take it from your comments that nobody has actually wired up pread2()
> into samba yet?  That's a bit disturbing, because if we later want to
> go and change something like this short-read behaviour, we're screwed -
> it's a non back-compat userspace-visible change.

Volker and did wired so we can use Samba as a test / use case. The
change we made was quick and dirty 9 lines of code, if you exclude the
syscall boiler plate. In fact, right now it does the stupid thing of
throwing away the partial result and enqueing in the threadpool if it
doesn't get the whole block. Volker agreed that was as much as we need
to do to get the numbers and we'll make a proper patch once it's in
upstream.

Patch to samba at end of email for reference.

>
>
> And a note on cosmetics: why are we using EAGAIN here rather than
> EWOULDBLOCK?  They have the same numerical value, but EWOULDBLOCK is a
> better name - EAGAIN says "run it again", but that won't work.

You're right. I will fix this.

diff --git a/source3/modules/vfs_default.c b/source3/modules/vfs_default.c
index 5634cc0..90348d8 100644
--- a/source3/modules/vfs_default.c
+++ b/source3/modules/vfs_default.c
@@ -34,6 +34,29 @@
 #include "lib/util/tevent_ntstatus.h"
 #include "lib/sys_rw.h"

+#include <pthread.h>
+
+#define __NR_preadv2 322
+#define __NR_pwritev2 323
+#define RWF_NONBLOCK 1
+
+#define LO_HI_LONG(val) \
+       (off_t) val, \
+       (off_t) ((((uint64_t) (val)) >> (sizeof (long) * 4)) >>
(sizeof (long) * 4))
+
+static inline
+int preadv2(int fd, const struct iovec *iov, int iovcnt, off_t
offset, int flags)
+{
+       return syscall(__NR_preadv2, fd, iov, iovcnt,
LO_HI_LONG(offset), flags);
+}
+
+static inline
+int pread2(int fd, void *data, size_t len, off_t offset, int flags)
+{
+       struct iovec iov = { data, len };
+       return preadv2(fd, &iov, 1, offset, flags);
+}
+
 #undef DBGC_CLASS
 #define DBGC_CLASS DBGC_VFS

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
