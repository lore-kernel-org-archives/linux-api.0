From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 4/5] fs, xfs: introduce MAP_DIRECT for creating
 block-map-atomic file ranges
Date: Thu, 24 Aug 2017 13:26:55 -0700
Message-ID: <CAPcyv4j06mdEek-aYfZCbTW0MaL6gy7OpUsgyv4hBB5yy_rW6A@mail.gmail.com>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353213655.5039.7662200155640827407.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824161152.GB27591@lst.de> <CAPcyv4jjNi_+c5DW9nsBLEnYMBtsR_v67+bF6bC4Cb9mY7T+Ww@mail.gmail.com>
 <20170824163925.GA28503@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170824163925.GA28503-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 24, 2017 at 9:39 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> On Thu, Aug 24, 2017 at 09:31:17AM -0700, Dan Williams wrote:
>> External agent is a DMA device, or a hypervisor like Xen. In the DMA
>> case perhaps we can use the fcntl lease mechanism, I'll investigate.
>> In the Xen case it actually would need to use fiemap() to discover the
>> physical addresses that back the file to setup their M2P tables.
>> Here's the discussion where we discovered that physical address
>> dependency:
>>
>>     https://lists.xen.org/archives/html/xen-devel/2017-04/msg00419.html
>
> fiemap does not work to discover physical addresses.  If they want
> to do anything involving physical address they will need a kernel
> driver.

True, it's broken with respect to multi-device filesystems and these
patches do nothing to fix that problem. Ok, I'm fine to let that use
case depend on a kernel driver and just focus on fixing the DMA case.
