From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 0/4] SysFS driver for QEMU fw_cfg device
Date: Mon, 5 Oct 2015 14:05:17 +0100
Message-ID: <20151005130516.GM19064@leverpostej>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
 <20151005100035.GA19064@leverpostej>
 <20151005124042.GF1977@HEDWIG.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151005124042.GF1977@HEDWIG.INI.CMU.EDU>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Cc: gregkh@linuxfoundation.org, paul@pwsan.com, galak@codeaurora.org, will.deacon@arm.com, agross@codeaurora.org, zajec5@gmail.com, hanjun.guo@linaro.org, catalin.marinas@arm.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org, matt.fleming@intel.com, lersek@redhat.com, jordan.l.justen@intel.com, mst@redhat.com, peter.maydell@linaro.org, leif.lindholm@linaro.org, ard.biesheuvel@linaro.org, pbonzini@redhat.com, kraxel@redhat.com, qemu-devel@nongnu.org
List-Id: linux-api@vger.kernel.org

> > I'm not sure I follow what the difficulty with supporting DT in addition
> > to ACPI is? It looks like all you need is a compatible string and a reg
> > entry.
> 
> Bearing in mind that I have almost no experience with arm:
> 
> I started out by probing all possible port-io and mmio locations where
> fw_cfg registers might have been found, from a "classic" module_init
> method.
> 
> Arm has DT, which as far as I understand will answer the following two
> questions: 1. Do I have fw_cfg ? 2. If yes, what address range does it use ?
> So that I could continue using a classic module_init, but won't need
> to probe for the device.
> 
> PC (my primary architecture, the one I actually care about) does not
> have DT. If I want to share the same code, I can't probe, so if I try
> DT and don't find fw_cfg there (or somehow DT is no-op-ed out because
> I'm on a PC guest), I could somehow look it up in ACPI the same way
> (i.e., use ACPI as sort of a stand-in for DT).

I'd imagine that it's simple to have something in your probe path like:

if (pdev->dev.of_node)
	parse_dt(pdev);
else
	parse_acpi(pdev);

> But all ACPI-enabled drivers I could find use dedicated macros (i.e.
> no more classic module_init() and module_exit(), but rather
> module_acpi_driver() with .add and .remove methods on an acpi_driver
> object, etc.) Not sure how I'd glue DT back into something like that.

You don't have to use those macros, and can simply use the classic
module_{init,exit} functions, calling the requisite acpi driver
registration functions at module {init,exit} time.

> In addition, Michael's comment earlier in the thread suggests that
> even my current acpi version isn't sufficiently "orthodox" w.r.t.
> ACPI, and I should be providing the hardware access routine as
> an ACPI/AML routine, to avoid race conditions with the rest of ACPI,
> and for encapsulation. I.e. it's even rude to use the fw_cfg node's
> ACPI _CRS method (the part where I'd be treating it like a DT stand-in
> only to query fw_cfg's hardware specifics).

As Peter stated, this sounds very much like it rules out sharing the
interface with FW generally (and is certainly scary).

> So far, all the information I've been able to pull together points
> away from a dual DT + ACPI all-in-one solution for fw_cfg. If you know
> of an example where that's done in an acceptable way, please let
> me know so I can use it for inspiration...

I'm not immediately aware, but I would imagine you could search for
files that had both an of_match_table and a acpi_bus_register_driver
call.

Thanks,
Mark.
