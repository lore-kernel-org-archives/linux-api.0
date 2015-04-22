From: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: Re: [PATCH/RFC 0/2] Repurpose the v4l2_plane data_offset field
Date: Wed, 22 Apr 2015 09:02:27 -0400
Message-ID: <1429707747.3857.8.camel@collabora.com>
References: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <5530E01D.3050105@xs4all.nl> <7986966.gGAFkYegjs@avalon>
Reply-To: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7986966.gGAFkYegjs@avalon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Cc: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pawel Osciak <pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Le vendredi 17 avril 2015 =C3=A0 15:53 +0300, Laurent Pinchart a =C3=A9=
crit :
> It's funny you mention that. I cloned the gstreamer repositories and
> tried to=20
> investigate. The gstreamer v4l2 elements started using data_offset a
> year ago=20
> in
>=20
> commit 92bdd596f2b07dbf4ccc9b8bf3d17620d44f131a
> Author: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
> Date:   Fri Apr 11 17:10:11 2014 -0400
>=20
>     v4l2: Add DMABUF and USERPTR importation
>=20
> (I've CC'ed Nicolas to this e-mail)
>=20
> I'm not too familiar with the latest gstreamer code, but after a
> first=20
> investigation it seems that gstreamer uses the data_offset field for
> the=20
> purpose introduced by this patch, not to convey the header size. One
> more=20
> argument in favour of repurposing the field ;-)

My impression was that the data before the offset was non-generic and
had to be skipped by applications that aren't aware. An example usage
would be to a camera with custom sensor producing data serialized with
the frames. The sensor data could be set in a header using custom but
documented format, generic application would simply skip that and work
as usual. Be aware that the implementation in GStreamer is incomplete
and untested as all tested drivers where setting this offset to 0.

cheers,
Nicolas
