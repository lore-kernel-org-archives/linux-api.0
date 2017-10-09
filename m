From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Date: Mon, 9 Oct 2017 12:28:29 -0700
Message-ID: <CAPcyv4h_uQGBAX6-bMkkZLO_YyQ6t4n_b8tH8wU_P0Jh23N5MQ@mail.gmail.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171009185840.GB15336@obsidianresearch.com> <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
 <20171009191820.GD15336@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009191820.GD15336-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 9, 2017 at 12:18 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Oct 09, 2017 at 12:05:30PM -0700, Dan Williams wrote:
>> On Mon, Oct 9, 2017 at 11:58 AM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > On Fri, Oct 06, 2017 at 03:35:54PM -0700, Dan Williams wrote:
>> >> otherwise be quiesced. The need for this knowledge is driven by a need
>> >> to make RDMA transfers to DAX mappings safe. If the DAX file's block map
>> >> changes we need to be to reliably stop accesses to blocks that have been
>> >> freed or re-assigned to a new file.
>> >
>> > If RDMA is driving this need, why not invalidate backing RDMA MRs
>> > instead of requiring a IOMMU to do it? RDMA MR are finer grained and
>> > do not suffer from the re-use problem David W. brought up with IOVAs..
>>
>> Sounds promising. All I want in the end is to be sure that the kernel
>> is enabled to stop any in-flight RDMA at will without asking
>> userspace. Does this require per-RDMA driver opt-in or is there a
>> common call that can be made?
>
> I don't think this has ever come up in the context of an all-device MR
> invalidate requirement. Drivers already have code to invalidate
> specifc MRs, but to find all MRs that touch certain pages and then
> invalidate them would be new code.
>
> We also have ODP aware drivers that can retarget a MR to new
> physical pages. If the block map changes DAX should synchronously
> retarget the ODP MR, not halt DMA.

Have a look at the patch [1], I don't touch the ODP path.

> Most likely ODP & DAX would need to be used together to get robust
> user applications, as having the user QP's go to an error state at
> random times (due to DMA failures) during operation is never going to
> be acceptable...

It's not random. The process that set up the mapping and registered
the memory gets SIGIO when someone else tries to modify the file map.
That process then gets /proc/sys/fs/lease-break-time seconds to fix
the problem before the kernel force revokes the DMA access.

It's otherwise not acceptable to allow DMA into random locations when
the file map changes.

> Perhaps you might want to initially only support ODP MR mappings with
> DAX and then the DMA fencing issue goes away?

I'd rather try to fix the non-ODP DAX case instead of just turning it off.

[1]: https://patchwork.kernel.org/patch/9991681/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
