From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 17/21] libnvdimm: infrastructure for btt devices
Date: Wed, 17 Jun 2015 09:50:33 -0700
Message-ID: <CAPcyv4g0CVzhDDiUjc3=5=Bx1HUFjJ7XmCJfxPG1oQAoZ8yvug@mail.gmail.com>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150602001541.4506.90125.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150609064200.GE9804@lst.de>
	<20150610184616.GL2729@linux.intel.com>
	<20150611072812.GB1905@lst.de>
	<x49381qp9ic.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <x49381qp9ic.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jun 17, 2015 at 9:47 AM, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:
>
>> On Wed, Jun 10, 2015 at 02:46:16PM -0400, Matthew Wilcox wrote:
>>> Don't screw up rw_page.  The point of rw_page is to read or write a page
>>> cache page.  It can sleep, and it indicates success by using the page
>>> flags.  Don't try and scqueeze rw_bytes into it.  If you want rw_bytes
>>> to be a queue operation, that's one thing, but don't mess with rw_page.
>>
>> Oh, I forgot about the page manipulating nature.  Yes, we'll need a different
>> operation in this case.
>
> I didn't see this addressed in the new patch set.  I'm also concerned
> about the layering, but I haven't put enough time into it to really make
> a better suggestion.  I really dislike the idea of yet another device
> stacking model in the kernel and I'm worried the code will go in, and the
> sysfs interface will end up as a "user abi" and we won't be able to
> change it in the future.
>
> Dan, have you made any progress on this, or do you have plans to?

? in v6 ->rw_bytes() moved from libnvdimm local hackery to a top-level
block device operation.  Is that your concern or something else?
