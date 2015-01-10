From: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] Documentation: Add entry for dell-laptop sysfs interface
Date: Fri, 9 Jan 2015 22:57:14 -0800
Message-ID: <20150110065714.GB104814@vmdeb7>
References: <1417628493-29323-1-git-send-email-gabriele.mzt@gmail.com>
 <20141231053149.GA3764@norris-Latitude-E6410>
 <1636595.UbTko9mUNA@xps13>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1636595.UbTko9mUNA@xps13>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriele Mazzotta <gabriele.mzt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libsmbios-devel-XtjxT7Vmt5ZskZv2Y/7f+AC/G2K4zDHf@public.gmane.org, Srinivas_G_Gowda-8PEkshWhKlo@public.gmane.org, Michael_E_Brown-8PEkshWhKlo@public.gmane.org, pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, A.Sloman-dxBOTFGcEFw2EctHIo1CcQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 31, 2014 at 12:20:59PM +0100, Gabriele Mazzotta wrote:
> On Tuesday 30 December 2014 21:31:49 Brian Norris wrote:
> > Hi,
> >=20
> > On Wed, Dec 03, 2014 at 06:41:33PM +0100, Gabriele Mazzotta wrote:
> > > Add the documentation for the new sysfs interface of dell-laptop
> > > that allows to configure the keyboard illumination on Dell system=
s.
> > >=20
> > > Signed-off-by: Gabriele Mazzotta <gabriele.mzt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Pali Roh=E1r <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  .../ABI/testing/sysfs-platform-dell-laptop         | 60 ++++++++=
++++++++++++++
> > >  1 file changed, 60 insertions(+)
> > >  create mode 100644 Documentation/ABI/testing/sysfs-platform-dell=
-laptop
> > >=20
> > > diff --git a/Documentation/ABI/testing/sysfs-platform-dell-laptop=
 b/Documentation/ABI/testing/sysfs-platform-dell-laptop
> > > new file mode 100644
> > > index 0000000..7969443
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-platform-dell-laptop
> > > @@ -0,0 +1,60 @@
> > > +What:		/sys/class/leds/dell::kbd_backlight/als_setting
> > > +Date:		December 2014
> > > +KernelVersion:	3.19
> > > +Contact:	Gabriele Mazzotta <gabriele.mzt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
> > > +		Pali Roh=E1r <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > +Description:
> > > +		This file allows to control the automatic keyboard
> > > +		illumination mode on some systems that have an ambient
> > > +		light sensor. Write 1 to this file to enable the auto
> > > +		mode, 0 to disable it.
> > [...]
> >=20
> > This entry appears wrong, or at least incomplete. My system boots w=
ith a
> > default value of 18, and the 'set' implementation accepts any value=
 from
> > 0 to 255.
> >=20
> > According to the comments in dell-laptop.c, the value actually mean=
s
> > something different than on/off:
> >=20
> >   cbArg3, byte0  Desired setting of ALS value that turns the light =
on or off.
> >=20
> > Admittedly, I'm not clear on what the intended interface is, as I'v=
e
> > never had the ALS / keyboard backlight controls all working properl=
y on
> > my laptop in the first place, but I thought this would be the right
> > place to ask about getting the documentation and driver in sync.
>=20
> Hi,
>=20
> You are perfectly right, the documentation is wrong and I'm sorry for
> that. als_setting should allow you to define when the keyboard
> backlight has to be turned on or off depending on the value reported
> by the ambient light sensor.
>=20
> Please note that not everything that is in libsmbios [1] is implement=
ed
> in the kernel driver. Take a look at it, recently there have been few
> changes related to the ALS settings. Probably they are not needed giv=
en
> that you are able to set the threshold with the current kernel driver=
,
> but you might find something interesting.
>=20
> I'll submit a patch to correct the documentation, thanks for reportin=
g.

Hi Gabriele,

Have I missed a patch from you for this? I'd like to see this corrected=
 in the
3.19 rc cycle.

Thanks,

--=20
Darren Hart
Intel Open Source Technology Center
