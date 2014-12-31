From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] Documentation: Add entry for dell-laptop sysfs interface
Date: Wed, 31 Dec 2014 12:20:59 +0100
Message-ID: <1636595.UbTko9mUNA@xps13>
References: <1417628493-29323-1-git-send-email-gabriele.mzt@gmail.com> <20141231053149.GA3764@norris-Latitude-E6410>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <platform-driver-x86-owner@vger.kernel.org>
In-Reply-To: <20141231053149.GA3764@norris-Latitude-E6410>
Sender: platform-driver-x86-owner@vger.kernel.org
To: Brian Norris <computersforpeace@gmail.com>
Cc: dvhart@infradead.org, mjg59@srcf.ucam.org, linux-api@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com, Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com, pali.rohar@gmail.com, A.Sloman@cs.bham.ac.uk
List-Id: linux-api@vger.kernel.org

On Tuesday 30 December 2014 21:31:49 Brian Norris wrote:
> Hi,
>=20
> On Wed, Dec 03, 2014 at 06:41:33PM +0100, Gabriele Mazzotta wrote:
> > Add the documentation for the new sysfs interface of dell-laptop
> > that allows to configure the keyboard illumination on Dell systems.
> >=20
> > Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
> > Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> > ---
> >  .../ABI/testing/sysfs-platform-dell-laptop         | 60 ++++++++++=
++++++++++++
> >  1 file changed, 60 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-platform-dell-l=
aptop
> >=20
> > diff --git a/Documentation/ABI/testing/sysfs-platform-dell-laptop b=
/Documentation/ABI/testing/sysfs-platform-dell-laptop
> > new file mode 100644
> > index 0000000..7969443
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-platform-dell-laptop
> > @@ -0,0 +1,60 @@
> > +What:		/sys/class/leds/dell::kbd_backlight/als_setting
> > +Date:		December 2014
> > +KernelVersion:	3.19
> > +Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
> > +		Pali Roh=E1r <pali.rohar@gmail.com>
> > +Description:
> > +		This file allows to control the automatic keyboard
> > +		illumination mode on some systems that have an ambient
> > +		light sensor. Write 1 to this file to enable the auto
> > +		mode, 0 to disable it.
> [...]
>=20
> This entry appears wrong, or at least incomplete. My system boots wit=
h a
> default value of 18, and the 'set' implementation accepts any value f=
rom
> 0 to 255.
>=20
> According to the comments in dell-laptop.c, the value actually means
> something different than on/off:
>=20
>   cbArg3, byte0  Desired setting of ALS value that turns the light on=
 or off.
>=20
> Admittedly, I'm not clear on what the intended interface is, as I've
> never had the ALS / keyboard backlight controls all working properly =
on
> my laptop in the first place, but I thought this would be the right
> place to ask about getting the documentation and driver in sync.

Hi,

You are perfectly right, the documentation is wrong and I'm sorry for
that. als_setting should allow you to define when the keyboard
backlight has to be turned on or off depending on the value reported
by the ambient light sensor.

Please note that not everything that is in libsmbios [1] is implemented
in the kernel driver. Take a look at it, recently there have been few
changes related to the ALS settings. Probably they are not needed given
that you are able to set the threshold with the current kernel driver,
but you might find something interesting.

I'll submit a patch to correct the documentation, thanks for reporting.

[1] http://linux.dell.com/git/libsmbios.git

> NB: I came across this because
>=20
>    (1) I'd really like to be able to turn the keyboard backlight on, =
the
>    timeout off, and the ALS off; and
>=20
>    (2) I noticed there was a new driver patch in 3.19 (nice! thanks!)=
,
>    where previously there must have been some kind of half-functional
>    working driver -- I could get backlight control, but it always tim=
ed
>    out too quickly.
>=20
> It seems like /sys/.../als_setting is documented to handle the latter
> part of (1), but its implementation does not match.
>=20
> Thanks,
> Brian
>=20
> P.S. The author of this page [1] might be interested in these new dri=
ver
> additions.
>=20
> [1] http://www.cs.bham.ac.uk/~axs/laptop/dell-e6410-fn-keys.html
