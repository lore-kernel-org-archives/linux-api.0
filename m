From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 09/16] libnvdimm, pmem: move pmem to drivers/nvdimm/
Date: Wed, 1 Jul 2015 10:24:53 -0700
Message-ID: <CAPcyv4j-anyF1Tt3F5G7yoQpfik9SmhXEojUmSrPm+SMVN31Sw@mail.gmail.com>
References: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617231408.11597.28725.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CAMuHMdVMxoJFmzBZ_qAx5gDfZxsGUo2wJzawgMxS5TER==VUWQ@mail.gmail.com>
	<CAPcyv4jEhoYsW_M3SPG1_YVQCXtnytg6Wi+BfXU=idFSp-2wYg@mail.gmail.com>
	<CAMuHMdU8z7iUVaUaGs3f1kUcDus5Qg1+EQQ5uu7uCWrHO_kBaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMuHMdU8z7iUVaUaGs3f1kUcDus5Qg1+EQQ5uu7uCWrHO_kBaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ACPI Devel Maling List <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 1, 2015 at 9:49 AM, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:
> On Wed, Jul 1, 2015 at 6:41 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> On Wed, Jul 1, 2015 at 6:13 AM, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:
>>> On Thu, Jun 18, 2015 at 1:14 AM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>>> Prepare the pmem driver to consume PMEM namespaces emitted by regions of
>>>> an nvdimm_bus instance.  No functional change.
>>>
>>> As LIBNVDIMM depends on PHYS_ADDR_T_64BIT, the driver can no
>>> longer be enabled on pure 32-bit platforms. Is that intended?
>>
>> Yes it was intentional.  It still allows 32-bit platforms with 64-bit
>> resource_size_t to compile. Do you otherwise have a 32-bit use case
>> for pmem?  I'm of course open to working through the changes to add
>> wider architecture support.
>
> Nope, just wondering, as the original didn't depend on PHYS_ADDR_T_64BIT.

Not explicitly, but it did rely on X86_PMEM_LEGACY.
