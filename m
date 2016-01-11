From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] [media] media.h: let be clear that tuners need to use
 connectors
Date: Mon, 11 Jan 2016 10:05:15 -0200
Message-ID: <20160111100515.11337a1e@recife.lan>
References: <16cd172bc9cec7ce438df95c142d2219998e32fe.1449867690.git.mchehab@osg.samsung.com>
	<1667088.5VvxRK5I9C@avalon>
	<CAH-u=83N53gzxGgXZbRAF0aJb_j8Bv0gRLCp6dQwxDuBO90yPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <CAH-u=83N53gzxGgXZbRAF0aJb_j8Bv0gRLCp6dQwxDuBO90yPA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org, Javier Martinez Canillas <javier@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Em Sun, 10 Jan 2016 19:01:27 +0100
Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com> escreveu:

> Hi,
>=20
> 2016-01-10 16:30 GMT+01:00 Laurent Pinchart <laurent.pinchart@ideason=
board.com>:
> > Hi Mauro,
> >
> > Thank you for the patch.
> >
> > On Friday 11 December 2015 19:01:31 Mauro Carvalho Chehab wrote:
> >> The V4L2 core won't be adding connectors to the tuners and other
> >> entities that need them. Let it be clear.
> >>
> >> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This patch was added due to Laurent's comments to this patch:
	https://patchwork.linuxtv.org/patch/31279/

> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >> ---
> >>  include/uapi/linux/media.h | 7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media=
=2Eh
> >> index 86f9753e5c03..cacfceb0d81d 100644
> >> --- a/include/uapi/linux/media.h
> >> +++ b/include/uapi/linux/media.h
> >> @@ -74,10 +74,11 @@ struct media_device_info {
> >>  /*
> >>   * Connectors
> >>   */
> >> +/* It is a responsibility of the entity drivers to add connectors=
 and links
> >
> > Do you mean entity drivers or "master/bridge" (for lack of a better=
 word)
> > drivers ?
>=20
> Is is the responsability of the media device I think...

Yes, the device responsible to create the media_device (e. g. the
bridge driver, on USB drivers) is the one responsible to create such
connectors, but answering that question for DT-based devices is not
trivial.

Right now, no DT-based driver create connectors, although, it makes sen=
se to
add support for it in order to properly support the IGEPv2 expansion bo=
ard:
	https://www.isee.biz/products/igep-expansion-boards/igepv2-expansion

in order to represent the input PAD for the two connector inputs associ=
ated
with the TVP5151 analog demux, e. g. entity_81 on the image below:
	https://mchehab.fedorapeople.org/mc-next-gen/omap3-igepv2-with-tvp5150=
-capture.

=46rom the board schematics:
	https://www.isee.biz/support/downloads?task=3Dcallelement&format=3Draw=
&item_id=3D156&element=3Df85c494b-2b32-4109-b8c1-083cca2b7db6&method=3D=
download&args[0]=3D3bf010234a287974f527ab93d7e06c32

this board has two RCA input PAD connectors, called "VIDEO IN 1" and
"VIDEO IN 2", connected to tvp5151 pins AIP1A and AIP1B. The tvp5151
is supported by the tvp5150 driver, with is also used by several
USB-based em28xx TV boards.

In the IGEPv2 case, I'm not sure if delegating the task of creating the
video input connectors to the "master" driver (e. g. omap3isp) is the b=
est=20
strategy. IMHO, the best is to add DT support for the tvp5150 driver to=
 parse
the input connectors would make more sense than adding it at omap3isp.

That's said, the current input selection framework is crap, at least
on tvp5150 driver: it is using/abusing of v4l2_subdev_audio_ops.s_routi=
ng
ops to select the video input. The comment for this field at
include/media/v4l2-subdev.h is:

 * @s_routing: used to define the input and/or output pins of an audio =
chip,
 *	and any additional configuration data.
 *	Never attempt to use user-level input IDs (e.g. Composite, S-Video,
 *	Tuner) at this level. An i2c device shouldn't know about whether an
 *	input pin is connected to a Composite connector, become on another
 *	board or platform it might be connected to something else entirely.
 *	The calling driver is responsible for mapping a user-level input to
 *	the right pins on the i2c device.

The description is confusing, as "composite, s-video, tuner" is *not* t=
he
audio input. They're actually audio/video inputs. It also delegates the
association of the input ID to the "calling" driver, with doesn't seem =
to
make much sense for DT.

Also, if we parse the input connectors at the tvp5150, we would need
to add more ops in order to properly support the VIDIOC input ioctls:
VIDIOC_ENUMINPUT, VIDIOC_G_INPUT, VIDIOC_S_INPUT.

So, while the changes at tvp5150 for accepting DT-based input connector=
s
seem trivial, that would likely require some non-trivial V4L2 core chan=
ges
in order to add an "input selection framework". Also, we need to double=
-check
if it won't cause troubles for the em28xx-based tvp5150 devices.

So, for now, I would prefer to keep the comments there vague, like on t=
he
proposed patch. We may need to revisit it after we add MC support to th=
e
em28xx driver and connectors support for the IGPv2 expansion board.

Regards,
Mauro

>=20
> > I don't think it should be the responsibility of the tuner driver t=
o
> > create connectors, as the tuner driver shouldn't know about the ent=
ities
> > surrounding it.
> >
> >> */ #define MEDIA_ENT_F_CONN_RF                (MEDIA_ENT_F_BASE + =
21)
> >>  #define MEDIA_ENT_F_CONN_SVIDEO              (MEDIA_ENT_F_BASE + =
22)
> >>  #define MEDIA_ENT_F_CONN_COMPOSITE   (MEDIA_ENT_F_BASE + 23)
> >> -     /* For internal test signal generators and other debug conne=
ctors */
> >> +/* For internal test signal generators and other debug connectors=
 */
> >>  #define MEDIA_ENT_F_CONN_TEST                (MEDIA_ENT_F_BASE + =
24)
> >>
> >>  /*
> >> @@ -105,6 +106,10 @@ struct media_device_info {
> >>  #define MEDIA_ENT_F_FLASH            (MEDIA_ENT_F_OLD_SUBDEV_BASE=
 + 2)
> >>  #define MEDIA_ENT_F_LENS             (MEDIA_ENT_F_OLD_SUBDEV_BASE=
 + 3)
> >>  #define MEDIA_ENT_F_ATV_DECODER              (MEDIA_ENT_F_OLD_SUB=
DEV_BASE + 4)
> >> +/*
> >> + * It is a responsibility of the entity drivers to add connectors=
 and links
> >> + *   for the tuner entities.
> >> + */
> >>  #define MEDIA_ENT_F_TUNER            (MEDIA_ENT_F_OLD_SUBDEV_BASE=
 + 5)
> >>
> >>  #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN      MEDIA_ENT_F_OLD_SUBD=
EV_BASE
> >
> > --
> > Regards,
> >
> > Laurent Pinchart
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-med=
ia" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> <div id=3D"DDB4FAA8-2DD7-40BB-A1B8-4E2AA1F9FDF2"><table
> style=3D"border-top: 1px solid #aaabb6; margin-top: 30px;">
> 	<tr>
> 		<td style=3D"width: 105px; padding-top: 15px;">
> 			<a href=3D"https://www.avast.com/sig-email?utm_medium=3Demail&utm_=
source=3Dlink&utm_campaign=3Dsig-email&utm_content=3Dwebmail"
> target=3D"_blank"><img
> src=3D"https://ipmcdn.avast.com/images/logo-avast-v1.png" style=3D"wi=
dth:
> 90px; height:33px;"/></a>
> 		</td>
> 		<td style=3D"width: 470px; padding-top: 20px; color: #41424e;
> font-size: 13px; font-family: Arial, Helvetica, sans-serif;
> line-height: 18px;">Cet e-mail a =C3=A9t=C3=A9 envoy=C3=A9 depuis un =
ordinateur
> prot=C3=A9g=C3=A9 par Avast. <br /><a
> href=3D"https://www.avast.com/sig-email?utm_medium=3Demail&utm_source=
=3Dlink&utm_campaign=3Dsig-email&utm_content=3Dwebmail"
> target=3D"_blank" style=3D"color: #4453ea;">www.avast.com</a> 		</td>
> 	</tr>
> </table>
> <a href=3D"#DDB4FAA8-2DD7-40BB-A1B8-4E2AA1F9FDF2" width=3D"1" height=3D=
"1"></a></div>
