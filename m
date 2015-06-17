From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 17/21] libnvdimm: infrastructure for btt devices
Date: Wed, 17 Jun 2015 12:47:23 -0400
Message-ID: <x49381qp9ic.fsf@segfault.boston.devel.redhat.com>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150602001541.4506.90125.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150609064200.GE9804@lst.de> <20150610184616.GL2729@linux.intel.com>
	<20150611072812.GB1905@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611072812.GB1905-jcswGhMUV9g@public.gmane.org> (Christoph Hellwig's message of
	"Thu, 11 Jun 2015 09:28:12 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:

> On Wed, Jun 10, 2015 at 02:46:16PM -0400, Matthew Wilcox wrote:
>> Don't screw up rw_page.  The point of rw_page is to read or write a page
>> cache page.  It can sleep, and it indicates success by using the page
>> flags.  Don't try and scqueeze rw_bytes into it.  If you want rw_bytes
>> to be a queue operation, that's one thing, but don't mess with rw_page.
>
> Oh, I forgot about the page manipulating nature.  Yes, we'll need a different
> operation in this case.

I didn't see this addressed in the new patch set.  I'm also concerned
about the layering, but I haven't put enough time into it to really make
a better suggestion.  I really dislike the idea of yet another device
stacking model in the kernel and I'm worried the code will go in, and the
sysfs interface will end up as a "user abi" and we won't be able to
change it in the future.

Dan, have you made any progress on this, or do you have plans to?

Cheers,
Jeff
