From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH 33/45] include/uapi/asm-generic/signal.h: include
 stdlib.h in userspace
Date: Wed, 11 Mar 2015 00:58:28 +0200
Message-ID: <20150310225828.GZ12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-34-git-send-email-mikko.rapeli@iki.fi>
 <2372547.aJh8O9JSDy@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2372547.aJh8O9JSDy@wuerfel>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 10:44:48AM +0100, Arnd Bergmann wrote:
> On Tuesday 17 February 2015 00:05:36 Mikko Rapeli wrote:
> > Fixes compiler warning:
> > error: unknown type name =E2=80=98size_t=E2=80=99
> >=20
> > Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> > ---
> >  include/uapi/asm-generic/signal.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> >=20
> > diff --git a/include/uapi/asm-generic/signal.h b/include/uapi/asm-g=
eneric/signal.h
> > index 9df61f1..8a341a2 100644
> > --- a/include/uapi/asm-generic/signal.h
> > +++ b/include/uapi/asm-generic/signal.h
> > @@ -3,6 +3,10 @@
> > =20
> >  #include <linux/types.h>
> > =20
> > +#ifndef __KERNEL__
> > +#include <stdlib.h>
> > +#endif
> > +
>=20
> Hmm, maybe we should use __kernel_size_t instead?

This problem is in several uapi header files on x86:

asm-generic/shmbuf.h
asm-generic/signal.h
asm/signal.h
drm/drm.h
linux/agpgart.h
linux/kexec.h
linux/ncp_fs.h
linux/nfc.h
linux/omapfb.h
linux/reiserfs_xattr.h
linux/sysctl.h
sound/asound.h

so I guess using __kernel_size_t is the correct approach for all of the=
m,
right?

linux/kexec.h seems suspicious though:

#ifndef __KERNEL__
/*
 * This structure is used to hold the arguments that are used when
 * loading  kernel binaries.
 */
struct kexec_segment {
        const void *buf;
        size_t bufsz;
        const void *mem;
        size_t memsz;
};

#endif /* __KERNEL__ */

-Mikko
