From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: Re: [Qemu-devel] [PATCH v4 4/4] devicetree: update documentation
 for fw_cfg ARM bindings
Date: Wed, 18 Nov 2015 15:54:49 -0500
Message-ID: <20151118205448.GD2109@HEDWIG.INI.CMU.EDU>
References: <1447470235-13643-1-git-send-email-somlo@cmu.edu>
 <1447470235-13643-5-git-send-email-somlo@cmu.edu>
 <20151115020754.GA21323@rob-hp-laptop>
 <564995FA.40308@redhat.com>
 <CAL_JsqKEi9BozyLQ9sKM3VL-hSSRntDyET859N1qTTMT4jkDOw@mail.gmail.com>
 <564C7758.6010103@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564C7758.6010103-GANU6spQydw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?Fran=E7ois?= Revol <revol-GANU6spQydw@public.gmane.org>
Cc: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, QEMU Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Gross <agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.bie>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 18, 2015 at 02:04:24PM +0100, Fran=E7ois Revol wrote:
> On 17/11/2015 23:14, Rob Herring wrote:
> > On Mon, Nov 16, 2015 at 2:38 AM, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org=
> wrote:
> >>
> >>
> >> On 15/11/2015 03:07, Rob Herring wrote:
> >>> We generally don't want DT docs to depend on other kernel documen=
tation.
> >>
> >> DT docs do not contain a copy of the data sheets, either.  There i=
s no
> >> reason to say how to use the device (and even then, only doing so
> >> partially) in the DT docs.
> >=20
> > The difference is datasheets apply to all OS's, kernel documentatio=
n
> > does not. In theory at least this could be used for other OS's, rig=
ht?
>=20
> Would be nice indeed, as it's part of their intended purpose.
>=20
> For now we have to shoehorn things into linux-only stuff (like initrd=
)
> because well, nobody cares enough about NetBSD to compile U-Boot with
> its internal API, so let alone adding custom Haiku code.
>=20
> And of course, for things linux doesn't care about (like framebuffer
> description) then we're stuck trying to guess where it's at and writi=
ng
> drivers for our bootloader.
>=20
> So if at least people were considering they aren't the only users of
> this, that'd make life better for everyone.
>=20
> > Perhaps QEMU is the right place to thoroughly describe this and DT =
and
> > sysfs docs can refer to it.
>=20
> The brilliant idea of FDT was that we could have a canonical source a=
nd
> blob for it where people could send patches, but of course Linux and =
BSD
> freaks disagreed, so you now find Linux-flavoured DTs for rPi and oth=
er
> things, as well as BSD versions.
>=20
> Please, at least get the binding documentation for this unique and
> usable for everyone!

That would be 'docs/specs/fw_cfg.txt' in the QEMU source tree. I will
avoid cut'n'pasting anything from there into either the proposed
Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg (leaving only the
sysfs specific bits in there), and also remove any redundant bits from
Documentation/devicetree/bindings/arm/fw-cfg.txt.

I'm inclined to add (in v5) a mention of 'qemu:docs/specs/fw_cfg.txt'
to both the proposed fw_cfg sysfs doc file, and to the existing fw_cfg
arm/dt node doc file, unless I get strong objections against doing so..=
=2E :)

Thanks,
--Gabriel
