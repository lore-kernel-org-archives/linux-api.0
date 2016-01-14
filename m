From: Kamil Debski <k.debski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
Date: Thu, 14 Jan 2016 18:21:37 +0100
Message-ID: <00ac01d14ef0$0702b2f0$150818d0$@samsung.com>
References: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
 <1452686611-145620-2-git-send-email-wuchengli@chromium.org>
 <003f01d14e21$78f7ad40$6ae707c0$@samsung.com>
 <1452783743.10009.18.camel@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1452783743.10009.18.camel-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Content-language: pl
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Nicolas Dufresne' <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, 'Wu-Cheng Li' <wuchengli-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ao2-qKGr9MkilAE@public.gmane.org, bparrot-l0cyMroinI0@public.gmane.org, 'Andrzej Hajda' <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

> From: Nicolas Dufresne [mailto:nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org]
> Sent: Thursday, January 14, 2016 4:02 PM
> To: Kamil Debski; 'Wu-Cheng Li'; pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org;
> mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org; hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org; crope-X3B1VOXEql0@public.gmane.org;
> standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; ao2-qKGr9MkilAE@public.gmane.org;
> bparrot-l0cyMroinI0@public.gmane.org
> Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] v4l: add
> V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
>=20
> Hi Kamil,
>=20
> Le mercredi 13 janvier 2016 =C3=A0 17:43 +0100, Kamil Debski a =C3=A9=
crit :
> > Good to hear that there are new codecs to use the V4L2 codec API :)
> >
> > My two cents are following - when you add a control that does the s=
ame
> > work as a driver specific control then it would be great if you
> > modified the driver that uses the specific control to also support =
the
> > newly added control.
> > This way future applications  could use the control you added for b=
oth
> > new and old drivers.
>=20
> When i first notice this MFC specific control, I believed it was use =
to produce
> I-Frame only streams (rather then a toggle, to produce one key- frame=
 on
> demand). So I wanted to verify the implementation to make sure what W=
u-
> Cheng is doing make sense. Though, I found that we set:
>=20
>   ctx->force_frame_type =3D ctrl->val;
>=20
> And never use that value anywhere else in the driver code. Hopefully =
I'm just
> missing something, but if it's not implemented, maybe it's better not=
 to
> expose it. Otherwise, this may lead to hard to find streaming issues.=
 I do
> hope we can add this feature though, as it's very useful feature for =
real time
> encoding.

Ooops, you're right. It's not implemented. I am adding Andrzej Hajda to=
 the CC loop, he may know more about this. I think it may have been imp=
lemented in some of our development branches, but somehow did not make =
it into the mainline kernel. That's one thing.

The other one is about your previous comment. I will quote it below, as=
 it is in another email.

> I don't like the way it's implemented. I don't know any decoder that =
have
> a frame type forcing feature other they I-Frame. It would be much mor=
e
> natural to use a toggle button control (and add more controls for oth=
er
> types when needed) then trying to merge hypothetical toggles into
>something that manually need to be set and disabled.

I had a look into the documentation of MFC. It is possible to force two=
 types of a frame to be coded.
The one is a keyframe, the other is a not coded frame. As I understand =
this is a type of frame that means that image did not change from previ=
ous frame. I am sure I seen it in an MPEG4 stream in a movie trailer. T=
he initial board with the age rating is displayed for a couple of secon=
ds and remains static. Thus there is one I-frame and a number of non-co=
ded frames.

That is the reason why the control was implemented in MFC as a menu and=
 not a button. Thus the question remains - is it better to leave it as =
a menu, or should there be two (maybe more in the future) buttons?=20

Wu-Cheng, does your hardware also supports inserting such a non-coded f=
rame? I can imagine that there could be hardware (in the future or some=
 current hardware that I am not aware of other than MFC) that could sup=
port this.

Best wishes,
--=20
Kamil Debski
Samsung R&D Institute Poland
