From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 02/21] libnvdimm, nfit: initial libnvdimm
 infrastructure and NFIT support
Date: Wed, 17 Jun 2015 14:35:23 -0700
Message-ID: <CAPcyv4jZLtnu-iNdNDM5zd8-iAp5q82n3b0ZEbohmjvqpEAKcA@mail.gmail.com>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150611201018.25175.78715.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1863642.qegEO3HtMW@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1863642.qegEO3HtMW-sKB8Sp2ER+y1GS7QM15AGw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jmoyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 17, 2015 at 2:59 PM, Rafael J. Wysocki <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org> wrote:
> On Thursday, June 11, 2015 04:10:18 PM Dan Williams wrote:
>> A struct nvdimm_bus is the anchor device for registering nvdimm
>> resources and interfaces, for example, a character control device,
>> nvdimm devices, and I/O region devices.  The ACPI NFIT (NVDIMM Firmware
>> Interface Table) is one possible platform description for such
>> non-volatile memory resources in a system.  The nfit.ko driver attaches
>> to the "ACPI0012" device that indicates the presence of the NFIT and
>> parses the table to register a struct nvdimm_bus instance.
>>
>> Cc: <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Cc: Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Cc: Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Cc: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>

Thanks Rafael!

> [cut]
>
>> +
>> +static struct acpi_driver acpi_nfit_driver = {
>> +     .name = KBUILD_MODNAME,
>> +     .ids = acpi_nfit_ids,
>> +     .flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
>
> But this flag is not needed for now IMO.

Indeed, I'll fold the removal in to a v7 when I add the acks and a few
other straggling bug fixes.
