From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] fanotify: add a flag to allow setting O_CLOEXEC on
 event fd
Date: Thu, 02 Oct 2014 16:44:17 +0200
Message-ID: <1412261057.5371.8.camel@localhost.localdomain>
References: <cover.1411562410.git.ydroneaud@opteya.com>
	 <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com>
	 <542481B3.8070300@gmx.de> <1411721898.7778.18.camel@localhost.localdomain>
	 <542666B2.9080700@gmx.de>
	 <1411980555-10818-1-git-send-email-ydroneaud@opteya.com>
	 <20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org>
	 <1412230855.28184.5.camel@localhost.localdomain>
	 <1412236349-30035-1-git-send-email-ydroneaud@opteya.com>
	 <542D1726.3040801@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <542D1726.3040801-V8g9lnOeT5ydJdNcDFJN0w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Lino Sanfilippo <LinoSanfilippo-Mmb7MZpHnFY@public.gmane.org>, Valdis Kletnieks <Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

Le jeudi 02 octobre 2014 =C3=A0 10:13 +0100, P=C3=A1draig Brady a =C3=A9=
crit :
> On 10/02/2014 08:52 AM, Yann Droneaud wrote:
> > In order to not potentially break applications which were
> > requesting O_CLOEXEC on event file descriptors but which
> > actually need it to be not effective as the kernel currently
> > ignore the flag, so the file descriptor is inherited accross
> > exec regardless of O_CLOEXEC (please forgive me for the
> > wording), this patch introduces FAN_FD_CLOEXEC flag to
> > fanotify_init() so that application can request O_CLOEXEC
> > to be effective.
> > Newer application would use FAN_FD_CLOEXEC flag along
> > O_CLOEXEC to enable close on exec on newly created
> > file descriptor:
> >=20
> >   fd =3D fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK|FAN_FD_CLOEXEC,
> >                      O_RDONLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);
>=20
> Ugh really?
> IMHO there should be widespread or at least known breakage with
> O_CLOEXEC before adding messiness like this.

You should have read the other part of my message:

> > While I believe fanotify_init() must enable close-on-exec
> > when requested by userspace to prevent unwelcomed security
> > issue, I understand your concerns regarding the possible
> > breakage on userspace application requesting O_CLOEXEC
> > but relying on it not being enable on file descriptor
> > created for the events.
>=20
> > So with a new flag to fanotify_init(), we could allow
> > newer applications to really enable O_CLOEXEC.
>=20
> > But I feel bad to have to force application to specify
> > twice they want close on exec:
> >  - are you sure ?
> >  - are you really sure ?
> >  - is this your final answer ?
> >  ...


I'm not really fond of this option.

> It seems surprising to me that apps that would depend on
> O_CLOEXEC being ineffective.
>=20

We have seen userspace developers making mistakes, and those mistakes
were mistakenly ignored by the kernel until someone try to fix the
mistake on kernel side, which broke the existing userspace application.

> please reconsider this one.
>=20

I'm not going to promote this patch as it's a quick and dirty hack to
demonstrate what would be the other option.

Regards.

--=20
Yann Droneaud
OPTEYA
