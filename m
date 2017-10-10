From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Date: Tue, 10 Oct 2017 10:39:27 -0700
Message-ID: <CAPcyv4jL5fN7jjXkQum8ERQ45eW63dCYp5Pm6aHY4OPudz4Wsw@mail.gmail.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171009185840.GB15336@obsidianresearch.com>
 <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
 <20171009191820.GD15336@obsidianresearch.com>
 <CAPcyv4h_uQGBAX6-bMkkZLO_YyQ6t4n_b8tH8wU_P0Jh23N5MQ@mail.gmail.com>
 <20171010172516.GA29915@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20171010172516.GA29915-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 10, 2017 at 10:25 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Oct 09, 2017 at 12:28:29PM -0700, Dan Williams wrote:
>
>> > I don't think this has ever come up in the context of an all-device MR
>> > invalidate requirement. Drivers already have code to invalidate
>> > specifc MRs, but to find all MRs that touch certain pages and then
>> > invalidate them would be new code.
>> >
>> > We also have ODP aware drivers that can retarget a MR to new
>> > physical pages. If the block map changes DAX should synchronously
>> > retarget the ODP MR, not halt DMA.
>>
>> Have a look at the patch [1], I don't touch the ODP path.
>
> But, does ODP work OK already? I'm not clear on that..

It had better. If the mapping is invalidated I would hope that
generates an io fault that gets handled by the driver to setup the new
mapping. I don't see how it can work otherwise.

>> > Most likely ODP & DAX would need to be used together to get robust
>> > user applications, as having the user QP's go to an error state at
>> > random times (due to DMA failures) during operation is never going to
>> > be acceptable...
>>
>> It's not random. The process that set up the mapping and registered
>> the memory gets SIGIO when someone else tries to modify the file map.
>> That process then gets /proc/sys/fs/lease-break-time seconds to fix
>> the problem before the kernel force revokes the DMA access.
>
> Well, the process can't fix the problem in bounded time, so it is
> random if it will fail or not.
>
> MR life time is under the control of the remote side, and time to
> complete the network exchanges required to release the MRs is hard to
> bound. So even if I implement SIGIO properly my app will still likely
> have random QP failures under various cases and work loads. :(
>
> This is why ODP should be the focus because this cannot work fully
> reliably otherwise..

The lease break time is configurable. If that application can't
respond to a stop request within a timeout of its own choosing then it
should not be using DAX mappings.

>
>> > Perhaps you might want to initially only support ODP MR mappings with
>> > DAX and then the DMA fencing issue goes away?
>>
>> I'd rather try to fix the non-ODP DAX case instead of just turning it off.
>
> Well, what about using SIGKILL if the lease-break-time hits? The
> kernel will clean up the MRs when the process exits and this will
> fence DMA to that memory.

Can you point me to where the MR cleanup code fences DMA and quiesces
the device?

> But, still, if you really want to be fined graned, then I think
> invalidating the impacted MR's is a better solution for RDMA than
> trying to do it with the IOMMU...

If there's a better routine for handling ib_umem_lease_break() I'd
love to use it. Right now I'm reaching for the only tool I know for
kernel enforced revocation of DMA access.
