From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH v2 0/3] SysFS driver for QEMU fw_cfg device
Date: Thu, 20 Aug 2015 00:04:30 +0100
Message-ID: <20150819230430.GJ10728@bivouac.eciton.net>
References: <cover.1439315079.git.somlo@cmu.edu>
 <1439977109-20314-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu-BOKTHb24LnemKmvCwZn0W-NOT=avY94wkkRTx2ViW=Q@mail.gmail.com>
 <20150819204915.GA6164@GLSMBP.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150819204915.GA6164@GLSMBP.INI.CMU.EDU>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, Matt Fleming <matt.fleming@intel.com>, kernelnewbies@kernelnewbies.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Aug 19, 2015 at 04:49:15PM -0400, Gabriel L. Somlo wrote:
> Hi Ard,
> 
> On Wed, Aug 19, 2015 at 11:42:02AM +0200, Ard Biesheuvel wrote:
> > (missed some cc's)
> > 
> > On 19 August 2015 at 11:38, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > > From: "Gabriel L. Somlo" <somlo@cmu.edu>
> > >> Several different architectures supported by QEMU are set up with a
> > >> "firmware configuration" (fw_cfg) device, used to pass configuration
> > >> "blobs" into the guest by the host running QEMU.
> > >>
> > >> Historically, these config blobs were mostly of interest to the guest
> > >> BIOS, but since QEMU v2.4 it is possible to insert arbitrary blobs via
> > >> the command line, which makes them potentially interesting to userspace
> > >> (e.g. for passing early boot environment variables, etc.).
> > >>
> > >
> > > Does 'potentially interesting' mean you have a use case? Could you elaborate?
> 
> My personal one would be something like:
> 
> cat > guestinfo.txt << EOT
>   KEY1="val1"
>   KEY2="val2"
>   ...
> EOT
> 
> qemu-system-x86_64 ... -fw-cfg name="opt/guestinfo",file=./guestinfo.txt ...
> 
> Then, from inside the guest:
> 
>   . /sys/firmware/qemu_fw_cfg/by_name/opt/guestinfo/raw
> 
>   do_something_with $KEY1 $KEY2
>   ...
> 
> But I'm thinking this is only one of the many positive things one
> could do with the ability to access random host-supplied blobs from
> guest userspace :)

> > >>   1/3 - probes for the qemu fw_cfg device in locations known to work on
> > >>       the supported architectures, in decreasing order of "likelihood".
> > >>
> > >>       While it *may* be possible to detect the presence of fw_cfg via
> > >>       acpi or dtb (on x86 and arm, respectively), there's no way I know
> > >>       of attempting that on sun4 and ppc/mac, so I've stuck with simply
> > >>       probing (the fw_cfg_modes[] structure and fw_cfg_io_probe() function)
> > >>       in fw_cfg.c. I could use some advice on how else that could be
> > >>       done more elegantly, if needed.
> > >>
> > >
> > > Sorry, but this is really out of the question, at least on ARM, but surely on
> > > other architectures as well. You can't just go around and probe random memory
> > > addresses. Perhaps QEMU tolerates it, but on anything that resembles a real
> > > system, this will immediately blow up. Also, what happens if the QEMU memory
> > > map changes? Add more probes addresses?
> > >
> > > It is not /that/ difficult to simply wire it up to the DT and ACPI
> > > infrastructures, there are plenty of examples in the kernel tree how to
> > > accomplish that. As a bonus, it removes all the arch specific knowledge
> > > from your code, which means that if QEMU grows support for another DT or
> > > ACPI based architecture, it will just work.
> 
> I was *hoping* a successful call to request_[mem_]region() will be
> enough in the way of asking for permission before probing for the
> fw_cfg registers, but I realize that might still not be polite enough :)

Either way, it would make sense to not probe in locations that
couldn't possibly work on the current platform. The cleanest way would
probably be a per-architecture probe function (or structure). But even
then, it needs to only probe when it is safe to do so.
 
> DT on ARM is fine, and I'm certainly happy to learn how to do it (even
> though my main focus is, for now, x86). The unfortunate thing though
> is that on x86, fw_cfg is *not* AFAICT in ACPI, so I'd have to detour into
> first adding it in on the host side, before I can rewrite the guest side
> driver to look it up in there :)

It is probaly the only non-hackish way to do it for arm*.

> > > I am not sure how relevant sun4 and ppc/mac are for what you are trying to
> > > accomplish, but perhaps it would be best to focus on x86 and ARM for now
> > > and do it correctly. If the probing is actually needed, you can always add
> > > it later.
> 
> I guess that's the direction things seem to be headed, although it would
> make me a bit sad to leave out sun and ppc right from the very beginning :) 
> 
> PS. If you have one .c file in the kernel which does any of the DT-on-arm
> boilerplate I'm supposed to immitate, I'd appreciate the shortcut :)
> 
> PS2. Do you happen to be in Seattle right now ? :)

Unfortunately, neither Ard nor myself is there. But Mark Rutland
should be around and someone useful to talk to about this.

/
    Leif
