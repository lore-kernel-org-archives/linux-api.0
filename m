From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Date: Fri, 13 Oct 2017 09:09:29 +0200
Message-ID: <20171013070929.GA26652@lst.de>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com> <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com> <20171009185840.GB15336@obsidianresearch.com> <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com> <20171009191820.GD15336@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171009191820.GD15336-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 09, 2017 at 01:18:20PM -0600, Jason Gunthorpe wrote:
> > > If RDMA is driving this need, why not invalidate backing RDMA MRs
> > > instead of requiring a IOMMU to do it? RDMA MR are finer grained and
> > > do not suffer from the re-use problem David W. brought up with IOVAs..
> > 
> > Sounds promising. All I want in the end is to be sure that the kernel
> > is enabled to stop any in-flight RDMA at will without asking
> > userspace. Does this require per-RDMA driver opt-in or is there a
> > common call that can be made?
> 
> I don't think this has ever come up in the context of an all-device MR
> invalidate requirement. Drivers already have code to invalidate
> specifc MRs, but to find all MRs that touch certain pages and then
> invalidate them would be new code.

The whole point is that we should not need that IFF we provide the
right interface.

If we have a new 'register memory with a lease', the driver (or in fact
probably the umem core for the drivers using it) has the lease associated
with the ib_umem structure, which will just need a backpointer from the
ib_umem to the to the MR to unregister it.

Which might be a good opportunity to break the user MR from the in-kernel
ones and merge it with ib_umem, but that's a different story..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
