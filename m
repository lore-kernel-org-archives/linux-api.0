From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 43/98] include/uapi/linux/hdlc/ioctl.h: include linux/if.h
Date: Tue, 2 Jun 2015 22:34:47 +0300
Message-ID: <20150602193447.GS12550@lakka.kapsi.fi>
References: <20150530195223.GA15645@bugger.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150530195223.GA15645-LuJdRk73L+f/9pzu0YdTqQ@public.gmane.org>
 <20150530202253.GD15645-LuJdRk73L+f/9pzu0YdTqQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frans Klaver <fransklaver-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, May 30, 2015 at 10:22:53PM +0200, Frans Klaver wrote:
> On Sat, May 30, 2015 at 05:38:35PM +0200, Mikko Rapeli wrote:
> > Fixes userspace compiler error:
> >=20
> > error: =E2=80=98IFNAMSIZ=E2=80=99 undeclared here (not in a functio=
n)
> >=20
> > Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> > ---
> >  include/uapi/linux/hdlc/ioctl.h | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/include/uapi/linux/hdlc/ioctl.h b/include/uapi/linux/h=
dlc/ioctl.h
> > index 04bc027..8bbee11 100644
> > --- a/include/uapi/linux/hdlc/ioctl.h
> > +++ b/include/uapi/linux/hdlc/ioctl.h
> > @@ -1,6 +1,7 @@
> >  #ifndef __HDLC_IOCTL_H__
> >  #define __HDLC_IOCTL_H__
> > =20
> > +#include <linux/if.h>
> > =20
> >  #define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc=
 utility */
>=20
> What's the point of this one if you break this circular dependency in
> patch 49? Are those in between related?

They are indeed...

On Sat, May 30, 2015 at 09:52:23PM +0200, Frans Klaver wrote:
> On Sat, May 30, 2015 at 05:38:41PM +0200, Mikko Rapeli wrote:
> > This isn't pretty but does the job. I assume including plain linux/=
hdlc/ioctl.h
> > without linux/if.h is much more rare than the other way round, and =
that
> > these header file names are part of API, and that creating a new he=
ader file
> > just for IFNAMSIZ isn't a good idea either.
> >=20
> > Fixes userspace compiler error:
> >=20
> > error: =E2=80=98IFNAMSIZ=E2=80=99 undeclared here (not in a functio=
n)
> >=20
> > Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> > ---
> >  include/uapi/linux/hdlc/ioctl.h | 5 ++++-
> >  include/uapi/linux/if.h         | 4 ++++
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/uapi/linux/hdlc/ioctl.h b/include/uapi/linux/h=
dlc/ioctl.h
> > index 8bbee11..73982ec 100644
> > --- a/include/uapi/linux/hdlc/ioctl.h
> > +++ b/include/uapi/linux/hdlc/ioctl.h
> > @@ -1,7 +1,10 @@
> >  #ifndef __HDLC_IOCTL_H__
> >  #define __HDLC_IOCTL_H__
> > =20
> > -#include <linux/if.h>
> > +/* For breaking dependency loop between if.h and hdlc/ioctl.h */
> > +#ifndef IFNAMSIZ
> > +#define IFNAMSIZ        16
> > +#endif
> > =20
> >  #define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc=
 utility */
> > =20
> > diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
> > index 9cf2394..e4b130a 100644
> > --- a/include/uapi/linux/if.h
> > +++ b/include/uapi/linux/if.h
> > @@ -23,6 +23,10 @@
> >  #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
> >  #include <linux/compiler.h>		/* for "__user" et al           */
> > =20
> > +/**
> > + * IFNAMSIZ is also defined in linux/hdlc/ioctl.h if it does not e=
xists
> > + * to break dependency loop between linux/if.h and linux/hdlc/ioct=
l.h.
> > + */
> >  #define	IFNAMSIZ	16
> >  #define	IFALIASZ	256
> >  #include <linux/hdlc/ioctl.h>
>=20
> This feels backwards to me. Wouldn't it be less funky to accept that
> IFNAMSIZE isn't defined in if.h, but rather in hdlc/ioctl.h? If now

That is much less funky, thanks! I'll squash these to commits into a on=
e
which moves IFNAMSIZ to linux/hdlc/ioctl.h.

-Mikko
