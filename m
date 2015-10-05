From: Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/4] SysFS driver for QEMU fw_cfg device
Date: Mon, 5 Oct 2015 13:50:47 +0100
Message-ID: <CAFEAcA9qVSsmPW_s3wRSBykGYWU-2PS2ZNCagnoe0FGCg8mqzQ@mail.gmail.com>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
 <20151005100035.GA19064@leverpostej> <20151005124042.GF1977@HEDWIG.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151005124042.GF1977-h65ZQ0r4j6KKUezXOiBB2eW1CriLhL8O@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml - Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jordan Justen <jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, QEMU Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 5 October 2015 at 13:40, Gabriel L. Somlo <somlo-D+Gtc/HYRWM@public.gmane.org> wrote:
> In addition, Michael's comment earlier in the thread suggests that
> even my current acpi version isn't sufficiently "orthodox" w.r.t.
> ACPI, and I should be providing the hardware access routine as
> an ACPI/AML routine, to avoid race conditions with the rest of ACPI,
> and for encapsulation. I.e. it's even rude to use the fw_cfg node's
> ACPI _CRS method (the part where I'd be treating it like a DT stand-in
> only to query fw_cfg's hardware specifics).

If you want to try to support "firmware might also be reading
fw_cfg at the same time as the kernel" this is a (painful)
problem regardless of how the kernel figures out whether a
fw_cfg device is present. I had assumed that one of the design
assumptions of this series was that firmware would only
read the fw_cfg before booting the guest kernel and never touch
it afterwards. If it might touch it later then letting the
guest kernel also mess with fw_cfg seems like a really bad idea.

thanks
-- PMM
