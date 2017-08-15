From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
Date: Tue, 15 Aug 2017 10:37:32 +0200
Message-ID: <20170815083732.GB27505@quack2.suse.cz>
References: <20170805095013.GC14930@lst.de>
 <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
 <20170811104429.GA13736@lst.de>
 <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
 <20170812073349.GA12679@lst.de>
 <CAPcyv4iKG=Zoo1VXu23YBc6uWDFV4QSS+eAm9MSOynx2FjTHbw@mail.gmail.com>
 <20170813092436.GB32112@lst.de>
 <CAPcyv4ixTgSWG9K2Eg3XJmOvqJht81qL+Z3njoOjcXCD7XMpZw@mail.gmail.com>
 <20170814124059.GC17820@quack2.suse.cz>
 <CAPcyv4hi_Y5Qj=h_Qf4Bcyv+EWBosa2gQT+-8ro3hPY9VMshSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4hi_Y5Qj=h_Qf4Bcyv+EWBosa2gQT+-8ro3hPY9VMshSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon 14-08-17 09:14:42, Dan Williams wrote:
> On Mon, Aug 14, 2017 at 5:40 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> > On Sun 13-08-17 13:31:45, Dan Williams wrote:
> >> On Sun, Aug 13, 2017 at 2:24 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> >> > Thay being said I think we absolutely should support RDMA memory
> >> > registrations for DAX mappings.  I'm just not sure how S_IOMAP_IMMUTABLE
> >> > helps with that.  We'll want a MAP_SYNC | MAP_POPULATE to make sure
> >> > all the blocks are polulated and all ptes are set up.  Second we need
> >> > to make sure get_user_page works, which for now means we'll need a
> >> > struct page mapping for the region (which will be really annoying
> >> > for PCIe mappings, like the upcoming NVMe persistent memory region),
> >> > and we need to gurantee that the extent mapping won't change while
> >> > the get_user_pages holds the pages inside it.  I think that is true
> >> > due to side effects even with the current DAX code, but we'll need to
> >> > make it explicit.  And maybe that's where we need to converge -
> >> > "sealing" the extent map makes sense as such a temporary measure
> >> > that is not persisted on disk, which automatically gets released
> >> > when the holding process exits, because we sort of already do this
> >> > implicitly.  It might also make sense to have explicitl breakable
> >> > seals similar to what I do for the pNFS blocks kernel server, as
> >> > any userspace RDMA file server would also need those semantics.
> >>
> >> Ok, how about a MAP_DIRECT flag that arranges for faults to that range to:
> >>
> >>     1/ only succeed if the fault can be satisfied without page cache
> >>
> >>     2/ only install a pte for the fault if it can do so without
> >> triggering block map updates
> >>
> >> So, I think it would still end up setting an inode flag to make
> >> xfs_bmapi_write() fail while any process has a MAP_DIRECT mapping
> >> active. However, it would not record that state in the on-disk
> >> metadata and it would automatically clear at munmap time. That should
> >> be enough to support the host-persistent-memory, and
> >> NVMe-persistent-memory use cases (provided we have struct page for
> >> NVMe). Although, we need more safety infrastructure in the NVMe case
> >> where we would need to software manage I/O coherence.
> >
> > Hum, this proposal (and the problems you are trying to deal with) seem very
> > similar to Peter Zijlstra's mpin() proposal from 2014 [1], just moved to
> > the DAX area (and so additionally complicated by the fact that filesystems
> > now have to care). The patch set was not merged due to lack of interest I
> > think but it looked sensible and the proposed API would make sense for more
> > stuff than just DAX so maybe it would be better than MAP_DIRECT flag?
> 
> Interesting, but I'm not sure I see the correlation. mm_mpin() makes a
> "no-fault" guarantee and fixes the accounting of locked System RAM.
> MAP_DIRECT still allows faults, and DAX mappings don't consume System
> RAM so the accounting problem is not there for DAX. mm_pin() also does
> not appear to have a relationship to a file backed memory like mmap
> allows.

So the accounting part is probably non-interesting for DAX purposes and I
agree there are other differences as well. But mm_mpin() prevented page
migrations which is parallel to your requirement of "offset->block mapping
is permanent".  Furthermore mm_mpin() work was there for RDMA so that it
has saner interface to pin pages than get_user_pages() and you mention RDMA
and similar technologies as a usecase for your work for similar reasons.
So my thought was that possibly we should have the same API for pinning
"storage" for RDMA transfers regardless of whether the backing is page
cache or pmem and the API should be usable for in-kernel users as well?
mmap flag seems a bit clumsy in this regard so maybe a form of a separate
syscall - be it mpin(start, len) or some other name - might be more
suitable?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
