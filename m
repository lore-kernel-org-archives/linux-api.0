From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/4] SysFS driver for QEMU fw_cfg device
Date: Tue, 6 Oct 2015 09:18:37 +0200
Message-ID: <561375CD.4030709@redhat.com>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
 <20151005100035.GA19064@leverpostej>
 <20151005124042.GF1977@HEDWIG.INI.CMU.EDU>
 <20151005130516.GM19064@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151005130516.GM19064@leverpostej>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/05/15 15:05, Mark Rutland wrote:
>>> I'm not sure I follow what the difficulty with supporting DT in addition
>>> to ACPI is? It looks like all you need is a compatible string and a reg
>>> entry.
>>
>> Bearing in mind that I have almost no experience with arm:
>>
>> I started out by probing all possible port-io and mmio locations where
>> fw_cfg registers might have been found, from a "classic" module_init
>> method.
>>
>> Arm has DT, which as far as I understand will answer the following two
>> questions: 1. Do I have fw_cfg ? 2. If yes, what address range does it use ?
>> So that I could continue using a classic module_init, but won't need
>> to probe for the device.
>>
>> PC (my primary architecture, the one I actually care about) does not
>> have DT. If I want to share the same code, I can't probe, so if I try
>> DT and don't find fw_cfg there (or somehow DT is no-op-ed out because
>> I'm on a PC guest), I could somehow look it up in ACPI the same way
>> (i.e., use ACPI as sort of a stand-in for DT).
> 
> I'd imagine that it's simple to have something in your probe path like:
> 
> if (pdev->dev.of_node)
> 	parse_dt(pdev);
> else
> 	parse_acpi(pdev);
> 
>> But all ACPI-enabled drivers I could find use dedicated macros (i.e.
>> no more classic module_init() and module_exit(), but rather
>> module_acpi_driver() with .add and .remove methods on an acpi_driver
>> object, etc.) Not sure how I'd glue DT back into something like that.
> 
> You don't have to use those macros, and can simply use the classic
> module_{init,exit} functions, calling the requisite acpi driver
> registration functions at module {init,exit} time.
> 
>> In addition, Michael's comment earlier in the thread suggests that
>> even my current acpi version isn't sufficiently "orthodox" w.r.t.
>> ACPI, and I should be providing the hardware access routine as
>> an ACPI/AML routine, to avoid race conditions with the rest of ACPI,
>> and for encapsulation. I.e. it's even rude to use the fw_cfg node's
>> ACPI _CRS method (the part where I'd be treating it like a DT stand-in
>> only to query fw_cfg's hardware specifics).
> 
> As Peter stated, this sounds very much like it rules out sharing the
> interface with FW generally (and is certainly scary).
> 
>> So far, all the information I've been able to pull together points
>> away from a dual DT + ACPI all-in-one solution for fw_cfg. If you know
>> of an example where that's done in an acceptable way, please let
>> me know so I can use it for inspiration...
> 
> I'm not immediately aware, but I would imagine you could search for
> files that had both an of_match_table and a acpi_bus_register_driver
> call.

One file that I think is an example for this (and I have looked at
before) is: "drivers/virtio/virtio_mmio.c".

Virtio-mmio is supposed to be enumerable in both ACPI and DT virtual
machines. For the QEMU side, grep QEMU for "LNRO0005" vs. "virtio,mmio".

Thanks
Laszlo
