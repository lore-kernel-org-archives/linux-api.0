From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 17/21] libnvdimm: infrastructure for btt devices
Date: Wed, 17 Jun 2015 10:09:53 -0700
Message-ID: <CAPcyv4hMDo+V3ny340F68kvrFfpxtO+NTo4ZYacrSpK9t_g+Xw@mail.gmail.com>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150602001541.4506.90125.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150609064200.GE9804@lst.de>
	<20150610184616.GL2729@linux.intel.com>
	<20150611072812.GB1905@lst.de>
	<x49381qp9ic.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4g0CVzhDDiUjc3=5=Bx1HUFjJ7XmCJfxPG1oQAoZ8yvug@mail.gmail.com>
	<x49twu6nugs.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <x49twu6nugs.fsf@segfault.boston.devel.redhat.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jun 17, 2015 at 9:57 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> On Wed, Jun 17, 2015 at 9:47 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Christoph Hellwig <hch@lst.de> writes:
>>>
>>>> On Wed, Jun 10, 2015 at 02:46:16PM -0400, Matthew Wilcox wrote:
>>>>> Don't screw up rw_page.  The point of rw_page is to read or write a page
>>>>> cache page.  It can sleep, and it indicates success by using the page
>>>>> flags.  Don't try and scqueeze rw_bytes into it.  If you want rw_bytes
>>>>> to be a queue operation, that's one thing, but don't mess with rw_page.
>>>>
>>>> Oh, I forgot about the page manipulating nature.  Yes, we'll need a different
>>>> operation in this case.
>>>
>>> I didn't see this addressed in the new patch set.  I'm also concerned
>>> about the layering, but I haven't put enough time into it to really make
>>> a better suggestion.  I really dislike the idea of yet another device
>>> stacking model in the kernel and I'm worried the code will go in, and the
>>> sysfs interface will end up as a "user abi" and we won't be able to
>>> change it in the future.
>>>
>>> Dan, have you made any progress on this, or do you have plans to?
>>
>> ? in v6 ->rw_bytes() moved from libnvdimm local hackery to a top-level
>> block device operation.  Is that your concern or something else?
>
> Hmm, I guess I was conflating two things.  I see now that you did move
> the rw_bytes into the block device operations, that looks good.  I'll
> table my concerns over yet another stacking model until I can say
> something intelligent about it.

MD and DM guys can jump in here if I mis-characterize, but I believe
the libnvdimm stacking model:

1/ is warranted because ->rw_bytes() is unique to nvdimm devices and
there are plans for other drivers btt-like drivers to stack on top, a
"struct page" driver is an example

2/ avoids the mistakes of the MD and DM stacking implementations by
having a device-model handle in existence *prior* to attaching a
backing device.  MD requires the parent block device to be created
first which causes the implementation to jump through hoops trying to
determine when the MD device has lost its "last opener".  DM's model
is mostly opaque to sysfs, it just pops into existence after a magic
sequence of ioctls+netlink.

It also solves the "autodetect" problem of needing to scan every block
device in the system, the scanning is asynchronous and contained to a
given nvdimm bus.
