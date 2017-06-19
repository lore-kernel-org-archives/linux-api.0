From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
Date: Mon, 19 Jun 2017 23:21:07 +1000
Message-ID: <20170619132107.GG11993@dastard>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrU1Hg=q4cdQDex--3nVBfwRC1o=9pC6Ss77Z8Lxg7ZJLg@mail.gmail.com>
 <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
 <CALCETrUfv26pvmyQ1gOkKbzfSXK2DnmeBG6VmSWjFy1WBhknTw@mail.gmail.com>
 <CAPcyv4iPb69e+rE3fJUzm9U_P_dLfhantU9mvYmV-R0oQee4rA@mail.gmail.com>
 <CALCETrVY38h2ajpod2U_2pdHSp8zO4mG2p19h=OnnHmhGTairw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVY38h2ajpod2U_2pdHSp8zO4mG2p19h=OnnHmhGTairw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 17, 2017 at 10:05:45PM -0700, Andy Lutomirski wrote:
> On Sat, Jun 17, 2017 at 8:15 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > On Sat, Jun 17, 2017 at 4:50 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >> My other objection is that the syscall intentionally leaks a reference
> >> to the file.  This means it needs overflow protection and it probably
> >> shouldn't ever be allowed to use it without privilege.
> >
> > We only hold the one reference while S_DAXFILE is set, so I think the
> > protection is there, and per Dave's original proposal this requires
> > CAP_LINUX_IMMUTABLE.
> >
> >> Why can't the underlying issue be easily fixed, though?  Could
> >> .page_mkwrite just make sure that metadata is synced when the FS uses
> >> DAX?
> >
> > Yes, it most definitely could and that idea has been floated.
> >
> >> On a DAX fs, syncing metadata should be extremely fast.

<sigh>

This again....

Persistent memory means the *I/O* is fast. It does not mean that
*complex filesystem operations* are fast.

Don't forget that there's an shitload of CPU that gets burnt to make
sure that the metadata is synced correctly. Do that /synchronously/
on *every* write page fault (which, BTW, modify mtime, so will
always have dirty metadata to sync) and now you have a serious
performance problem with your "fast" DAX access method.

And that's before we even consider all the problems with running
sync operations in page fault context....

> >> This
> >> could be conditioned on an madvise or mmap flag if performance might
> >> be an issue.  As far as I know, this change alone should be
> >> sufficient.
> >
> > The hang up is that it requires per-fs enabling as it needs to be
> > careful to manage mmap_sem vs fs journal locks for example. I know the
> > in-development NOVA [1] filesystem is planning to support this out of
> > the gate. ext4 would be open to implementing it, but I think xfs is
> > cold on the idea. Christoph originally proposed it here [2], before
> > Dave went on to propose immutable semantics.
> 
> Hmm.  Given a choice between a very clean API that works without
> privilege but is awkward to implement on XFS and an awkward-to-use
> API, I'd personally choose the former.

Yup, you have the choice of a clean kernel API that will be
substantially slower than the existing "dirty page" tracking and
having the app run fsync() when necessary, or having to do a little
more work in a library routine that preallocates a file and sets a
flag on it?

The apps will use the library API, not the kernel API, so who really
cares if there's a few steps to setting up the file state
appropriately?

> Dave, even with the lock ordering issue, couldn't XFS implement
> MAP_PMEM_AWARE by having .page_mkwrite work roughly like this:
> 
> if (metadata is dirty) {
>   up_write(&mmap_sem);
>   sync the metadata;
>   down_write(&mmap_sem);
>   return 0;  /* retry the fault */
> } else {
>   return whatever success code;
> }

How do you know that there is dependent filesystem metadata that
needs syncing at a level that you can safely manipulate the
mmap_sem? And how, exactly, do you do this without races? It'd be
trivial to DOS such retryable DAX faults simply by touching the file
in a tight loop in a separate process...

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
