From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: Re: [PATCH v2 0/3] SysFS driver for QEMU fw_cfg device
Date: Thu, 20 Aug 2015 23:47:57 -0400
Message-ID: <20150821034757.GA6982@GLSMBP.INI.CMU.EDU>
References: <cover.1439315079.git.somlo@cmu.edu>
 <1439977109-20314-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu-BOKTHb24LnemKmvCwZn0W-NOT=avY94wkkRTx2ViW=Q@mail.gmail.com>
 <20150819204915.GA6164@GLSMBP.INI.CMU.EDU>
 <CAKv+Gu9wr+BUDjoz9NAkLNXxViDOM_PRoZRU8sxHog-iX=yUpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9wr+BUDjoz9NAkLNXxViDOM_PRoZRU8sxHog-iX=yUpQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Richard W.M. Jones" <rjones@redhat.com>, Jordan Justen <jordan.l.justen@intel.com>, "x86@kernel.org" <x86@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, Gleb Natapov <gleb@cloudius-systems.com>, Matt Fleming <matt.fleming@intel.com>, kernelnewbies@kernelnewbies.org, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, ralf@linux-mips.org, zajec5@gmail.com, paul@pwsan.com, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 20, 2015 at 07:21:48AM +0200, Ard Biesheuvel wrote:
> On 19 August 2015 at 22:49, Gabriel L. Somlo <somlo@cmu.edu> wrote:
> >> > From: "Gabriel L. Somlo" <somlo@cmu.edu>
> >> >> Several different architectures supported by QEMU are set up with a
> >> >> "firmware configuration" (fw_cfg) device, used to pass configuration
> >> >> "blobs" into the guest by the host running QEMU.
> >> >>
> >> >> Historically, these config blobs were mostly of interest to the guest
> >> >> BIOS, but since QEMU v2.4 it is possible to insert arbitrary blobs via
> >> >> the command line, which makes them potentially interesting to userspace
> >> >> (e.g. for passing early boot environment variables, etc.).
> >> >>
> >> >
> >> > Does 'potentially interesting' mean you have a use case? Could you elaborate?
> >
> > My personal one would be something like:
> >
> > cat > guestinfo.txt << EOT
> >   KEY1="val1"
> >   KEY2="val2"
> >   ...
> > EOT
> >
> > qemu-system-x86_64 ... -fw-cfg name="opt/guestinfo",file=./guestinfo.txt ...
> >
> > Then, from inside the guest:
> >
> >   . /sys/firmware/qemu_fw_cfg/by_name/opt/guestinfo/raw
> >
> >   do_something_with $KEY1 $KEY2
> >   ...
> >
> > But I'm thinking this is only one of the many positive things one
> > could do with the ability to access random host-supplied blobs from
> > guest userspace :)
> >
> 
> 'random host-supplied blobs' sounds awfully like files in a file
> system to me, and that is already supported by QEMU and works with any
> guest OS unmodified. If you are in control of the command line, surely
> you can add a -drive xxx,fat:path/to/blobs -device xxx pair that
> simply turns up as a volume.

That did come up, here's the start of original thread on the qemu mailing
list from a while back:

https://lists.gnu.org/archive/html/qemu-devel/2015-02/msg00371.html

To recap, the main advantages to transfering data this way are:

	1. Asynchronous

	   The host can simply pass data via the qemu command line, and
	   not have to care if/when the guest is ready to accept the
	   data (i.e. has made it far enough to e.g. start a guest agent)

	2. Out-of-band

	   I don't have to take over a user-visible element such as a
	   disk drive. Same reason VSOCK (or VMWare VMCI for that matter)
	   exist and are NOT actual Ethernet/TCP-IP network interfaces :)

> > DT on ARM is fine, and I'm certainly happy to learn how to do it (even
> > though my main focus is, for now, x86). The unfortunate thing though
> > is that on x86, fw_cfg is *not* AFAICT in ACPI, so I'd have to detour into
> > first adding it in on the host side, before I can rewrite the guest side
> > driver to look it up in there :)
> >
> >> > I am not sure how relevant sun4 and ppc/mac are for what you are trying to
> >> > accomplish, but perhaps it would be best to focus on x86 and ARM for now
> >> > and do it correctly. If the probing is actually needed, you can always add
> >> > it later.
> >
> > I guess that's the direction things seem to be headed, although it would
> > make me a bit sad to leave out sun and ppc right from the very beginning :)
> >
> 
> Sorry to be blunt, but I am not convinced there is a need for this
> driver anyway.

See above (hopefully I'm being sufficiently persuasive :) )

In VMWare one would fetch similar "guestinfo" variables via something like

	FOO=$(vmware-tools --getinfo "FOO")

but I thought exposing fw_cfg in /sys/firmware/... would make access to
*any* blobs (including, but not limited to my particular use case) even
easier and more generic than that.

> > PS. If you have one .c file in the kernel which does any of the DT-on-arm
> > boilerplate I'm supposed to immitate, I'd appreciate the shortcut :)
> >
> 
> Check out drivers/tty/serial/amba-pl011.c

I'll check it out.

Thanks much!
--Gabriel
