From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH v2 0/3] SysFS driver for QEMU fw_cfg device
Date: Tue, 1 Sep 2015 12:11:44 -0400
Message-ID: <20150901161144.GB13375@HEDWIG.INI.CMU.EDU>
References: <cover.1439315079.git.somlo@cmu.edu>
 <1439977109-20314-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu-BOKTHb24LnemKmvCwZn0W-NOT=avY94wkkRTx2ViW=Q@mail.gmail.com>
 <20150819204915.GA6164@GLSMBP.INI.CMU.EDU>
 <55DE0227.8090905@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55DE0227.8090905-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jordan Justen <jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, QEMU Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, gleb-RmZWMc9puTNJc61us3aD9laTQe2KTcn/@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Christopher,

On Wed, Aug 26, 2015 at 02:15:03PM -0400, Christopher Covington wrote:
> On 08/19/2015 04:49 PM, Gabriel L. Somlo wrote:
> > On Wed, Aug 19, 2015 at 11:42:02AM +0200, Ard Biesheuvel wrote:
> >> On 19 August 2015 at 11:38, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> >>> From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
> >>>> Several different architectures supported by QEMU are set up with a
> >>>> "firmware configuration" (fw_cfg) device, used to pass configuration
> >>>> "blobs" into the guest by the host running QEMU.
> >>>>
> >>>> Historically, these config blobs were mostly of interest to the guest
> >>>> BIOS, but since QEMU v2.4 it is possible to insert arbitrary blobs via
> >>>> the command line, which makes them potentially interesting to userspace
> >>>> (e.g. for passing early boot environment variables, etc.).
> >>>>
> >>>
> >>> Does 'potentially interesting' mean you have a use case? Could you elaborate?
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
> 
> I do this with kernel parameters:
> 
> host:
> qemu-system-aarch64 -append="KEY1=val1 KEY2=val2"
> 
> guest:
> KEY1=`sed -nr s/.*KEY1=([^ ]+).*/\1/ /proc/cmdline`
> KEY2=`sed -nr s/.*KEY2=([^ ]+).*/\1/ /proc/cmdline`
> 
> do_something_with $KEY1 $KEY2
> 
> In practice it's just script=hostfile, where hostfile is available to the
> guest via a 9P passthrough filesystem mount.
> 
> While quite architecture specific, I've also previously used an
> "angel-cmdline" tool for similar purposes. Peter's recent semihosting patches
> support such a tool for AArch64. (On AArch32 upstream QEMU disallows
> semihosting from userspace.)
> 
> Before I had 9P on all the simulators I regularly ran, I used a semihosting
> based "angel-load" tool.

Someone (maybe it was you) did suggest this during an early thread on
the QEMU dev list. I had considered this, then thought about
piggybacking on smbios (e.g. the type 40 "additional information"
table), but then realized "wait, smbios is currently being inserted
into the guest via fw_cfg, so maybe direct fw_cfg blob transfer *is*
the most asynchronous and out-of-band way I can do this... :)

True, writing a fw_cfg driver is still Linux-specific (leaves out
Windows, which is something I still care about), but dumping a fw_cfg
blob using 'cat' or 'cp' on linux has a certain appeal :)

Yeah, the immediate use case I have personally can be worked around
with kernel command line args, in a slightly less out-of-band, but
still quite serviceable way. I'm thinking a fw_cfg driver is just a
flexible way to make other use cases possible in a (IMHO) neat and
clean way...

Plus, it got me to learn about kobjects, now studying DTs on ARM, so
it's fun ;)

Thanks,
--Gabriel
