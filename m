From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
Date: Wed, 16 Aug 2017 15:57:58 +0200
Message-ID: <20170816135758.GD4898@quack2.suse.cz>
References: <20170811104429.GA13736@lst.de>
 <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
 <20170812073349.GA12679@lst.de>
 <CAPcyv4iKG=Zoo1VXu23YBc6uWDFV4QSS+eAm9MSOynx2FjTHbw@mail.gmail.com>
 <20170813092436.GB32112@lst.de>
 <CAPcyv4ixTgSWG9K2Eg3XJmOvqJht81qL+Z3njoOjcXCD7XMpZw@mail.gmail.com>
 <20170814124059.GC17820@quack2.suse.cz>
 <CAPcyv4hi_Y5Qj=h_Qf4Bcyv+EWBosa2gQT+-8ro3hPY9VMshSA@mail.gmail.com>
 <20170815083732.GB27505@quack2.suse.cz>
 <CAPcyv4hFTn4Fz5o+Gm857mS-RA6WAVsf4CmwiLiK2O8w2_SamQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4hFTn4Fz5o+Gm857mS-RA6WAVsf4CmwiLiK2O8w2_SamQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 15-08-17 16:50:55, Dan Williams wrote:
> On Tue, Aug 15, 2017 at 1:37 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> > On Mon 14-08-17 09:14:42, Dan Williams wrote:
> >> On Mon, Aug 14, 2017 at 5:40 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> >> > On Sun 13-08-17 13:31:45, Dan Williams wrote:
> >> >> On Sun, Aug 13, 2017 at 2:24 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> >> >> > Thay being said I think we absolutely should support RDMA memory
> >> >> > registrations for DAX mappings.  I'm just not sure how S_IOMAP_IMMUTABLE
> >> >> > helps with that.  We'll want a MAP_SYNC | MAP_POPULATE to make sure
> >> >> > all the blocks are polulated and all ptes are set up.  Second we need
> >> >> > to make sure get_user_page works, which for now means we'll need a
> >> >> > struct page mapping for the region (which will be really annoying
> >> >> > for PCIe mappings, like the upcoming NVMe persistent memory region),
> >> >> > and we need to gurantee that the extent mapping won't change while
> >> >> > the get_user_pages holds the pages inside it.  I think that is true
> >> >> > due to side effects even with the current DAX code, but we'll need to
> >> >> > make it explicit.  And maybe that's where we need to converge -
> >> >> > "sealing" the extent map makes sense as such a temporary measure
> >> >> > that is not persisted on disk, which automatically gets released
> >> >> > when the holding process exits, because we sort of already do this
> >> >> > implicitly.  It might also make sense to have explicitl breakable
> >> >> > seals similar to what I do for the pNFS blocks kernel server, as
> >> >> > any userspace RDMA file server would also need those semantics.
> >> >>
> >> >> Ok, how about a MAP_DIRECT flag that arranges for faults to that range to:
> >> >>
> >> >>     1/ only succeed if the fault can be satisfied without page cache
> >> >>
> >> >>     2/ only install a pte for the fault if it can do so without
> >> >> triggering block map updates
> >> >>
> >> >> So, I think it would still end up setting an inode flag to make
> >> >> xfs_bmapi_write() fail while any process has a MAP_DIRECT mapping
> >> >> active. However, it would not record that state in the on-disk
> >> >> metadata and it would automatically clear at munmap time. That should
> >> >> be enough to support the host-persistent-memory, and
> >> >> NVMe-persistent-memory use cases (provided we have struct page for
> >> >> NVMe). Although, we need more safety infrastructure in the NVMe case
> >> >> where we would need to software manage I/O coherence.
> >> >
> >> > Hum, this proposal (and the problems you are trying to deal with) seem very
> >> > similar to Peter Zijlstra's mpin() proposal from 2014 [1], just moved to
> >> > the DAX area (and so additionally complicated by the fact that filesystems
> >> > now have to care). The patch set was not merged due to lack of interest I
> >> > think but it looked sensible and the proposed API would make sense for more
> >> > stuff than just DAX so maybe it would be better than MAP_DIRECT flag?
> >>
> >> Interesting, but I'm not sure I see the correlation. mm_mpin() makes a
> >> "no-fault" guarantee and fixes the accounting of locked System RAM.
> >> MAP_DIRECT still allows faults, and DAX mappings don't consume System
> >> RAM so the accounting problem is not there for DAX. mm_pin() also does
> >> not appear to have a relationship to a file backed memory like mmap
> >> allows.
> >
> > So the accounting part is probably non-interesting for DAX purposes and I
> > agree there are other differences as well. But mm_mpin() prevented page
> > migrations which is parallel to your requirement of "offset->block mapping
> > is permanent".  Furthermore mm_mpin() work was there for RDMA so that it
> > has saner interface to pin pages than get_user_pages() and you mention RDMA
> > and similar technologies as a usecase for your work for similar reasons.
> > So my thought was that possibly we should have the same API for pinning
> > "storage" for RDMA transfers regardless of whether the backing is page
> > cache or pmem and the API should be usable for in-kernel users as well?
> > mmap flag seems a bit clumsy in this regard so maybe a form of a separate
> > syscall - be it mpin(start, len) or some other name - might be more
> > suitable?
> 
> Can you say about more about why an mmap flag for this feels awkward
> to you? I think there's symmetry between O_SYNC / O_DIRECT setting up
> synchronous / page-cache-bypass file descriptors and MAP_SYNC /
> MAP_DIRECT setting up synchronous and page-cache bypass mappings.

So my thinking was, that for in-kernel users it might be a bit more
difficult to use mmap flag directly as they generally won't need to setup
the mapping. But that can be certainly dealt with by proper helpers for
in-kernel users.

> "Pinning" also feels like the wrong mechanism when you consider
> hardware is moving toward eliminating the pinning requirement over
> time. SVM "Shared Virtual Memory" hardware will just operate on cpu
> virtual addresses directly and generate typical faults. On such
> hardware MAP_DIRECT would be a nop relative to MAP_SYNC, so you
> wouldn't want your application to be stuck with the legacy concept
> that pages need to be explicitly "pinned".

OK, makes sense.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
