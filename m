From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 0/5] fs, xfs: block map immutable files for dax,
 dma-to-storage, and swap
Date: Mon, 14 Aug 2017 14:40:59 +0200
Message-ID: <20170814124059.GC17820@quack2.suse.cz>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ii41F-Rj9pPGc0FHwrQ=hkSF_f0niQDn5_NjU-wcL+gg@mail.gmail.com>
 <20170805095013.GC14930@lst.de>
 <CAPcyv4jgKmakB0WRUjx=2eD3YJ1x+C8cgnR6tA+g4+m+0etawQ@mail.gmail.com>
 <20170811104429.GA13736@lst.de>
 <CAPcyv4jrZ5a+zmAehZDxfP=+6BNCFAXOFWro2L7ruLkk+cY7OQ@mail.gmail.com>
 <20170812073349.GA12679@lst.de>
 <CAPcyv4iKG=Zoo1VXu23YBc6uWDFV4QSS+eAm9MSOynx2FjTHbw@mail.gmail.com>
 <20170813092436.GB32112@lst.de>
 <CAPcyv4ixTgSWG9K2Eg3XJmOvqJht81qL+Z3njoOjcXCD7XMpZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4ixTgSWG9K2Eg3XJmOvqJht81qL+Z3njoOjcXCD7XMpZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On Sun 13-08-17 13:31:45, Dan Williams wrote:
> On Sun, Aug 13, 2017 at 2:24 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> > Thay being said I think we absolutely should support RDMA memory
> > registrations for DAX mappings.  I'm just not sure how S_IOMAP_IMMUTABLE
> > helps with that.  We'll want a MAP_SYNC | MAP_POPULATE to make sure
> > all the blocks are polulated and all ptes are set up.  Second we need
> > to make sure get_user_page works, which for now means we'll need a
> > struct page mapping for the region (which will be really annoying
> > for PCIe mappings, like the upcoming NVMe persistent memory region),
> > and we need to gurantee that the extent mapping won't change while
> > the get_user_pages holds the pages inside it.  I think that is true
> > due to side effects even with the current DAX code, but we'll need to
> > make it explicit.  And maybe that's where we need to converge -
> > "sealing" the extent map makes sense as such a temporary measure
> > that is not persisted on disk, which automatically gets released
> > when the holding process exits, because we sort of already do this
> > implicitly.  It might also make sense to have explicitl breakable
> > seals similar to what I do for the pNFS blocks kernel server, as
> > any userspace RDMA file server would also need those semantics.
> 
> Ok, how about a MAP_DIRECT flag that arranges for faults to that range to:
> 
>     1/ only succeed if the fault can be satisfied without page cache
> 
>     2/ only install a pte for the fault if it can do so without
> triggering block map updates
> 
> So, I think it would still end up setting an inode flag to make
> xfs_bmapi_write() fail while any process has a MAP_DIRECT mapping
> active. However, it would not record that state in the on-disk
> metadata and it would automatically clear at munmap time. That should
> be enough to support the host-persistent-memory, and
> NVMe-persistent-memory use cases (provided we have struct page for
> NVMe). Although, we need more safety infrastructure in the NVMe case
> where we would need to software manage I/O coherence.

Hum, this proposal (and the problems you are trying to deal with) seem very
similar to Peter Zijlstra's mpin() proposal from 2014 [1], just moved to
the DAX area (and so additionally complicated by the fact that filesystems
now have to care). The patch set was not merged due to lack of interest I
think but it looked sensible and the proposed API would make sense for more
stuff than just DAX so maybe it would be better than MAP_DIRECT flag?

[1] https://lwn.net/Articles/600502/

								Honza

-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
