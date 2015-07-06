From: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RESEND] virtio: Fix typecast of pointer in vring_init()
Date: Mon, 6 Jul 2015 12:05:06 +0200
Message-ID: <20150706120506.4d80a832@thh440s>
References: <1435821682-1809-1-git-send-email-thuth@redhat.com>
	<20150705124937-mutt-send-email-mst@redhat.com>
	<20150705145917-mutt-send-email-mst@redhat.com>
	<20150706112442.60079de5@thh440s>
	<20150706124939-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150706124939-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 6 Jul 2015 12:50:22 +0300
"Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, Jul 06, 2015 at 11:24:42AM +0200, Thomas Huth wrote:
> > On Sun, 5 Jul 2015 14:59:54 +0200
> > "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >=20
> > > On Sun, Jul 05, 2015 at 12:58:53PM +0200, Michael S. Tsirkin wrot=
e:
> > > > On Thu, Jul 02, 2015 at 09:21:22AM +0200, Thomas Huth wrote:
> > > > > The virtio_ring.h header is used in userspace programs (ie. Q=
EMU),
> > > > > too. Here we can not assume that sizeof(pointer) is the same =
as
> > > > > sizeof(long), e.g. when compiling for Windows, so the typecas=
t in
> > > > > vring_init() should be done with (uintptr_t) instead of (unsi=
gned long).
> > > > >=20
> > > > > Signed-off-by: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > >=20
> > > > This seems to break some userspace too:
> > > >=20
> > > >   INSTALL usr/include/linux/ (413 files)
> > > >   CHECK   usr/include/linux/ (413 files)
> > > >   HOSTCC  Documentation/accounting/getdelays
> > > >   HOSTCC  Documentation/connector/ucon
> > > >   HOSTCC  Documentation/mic/mpssd/mpssd.o
> > > > In file included from Documentation/mic/mpssd/mpssd.c:36:0:
> > > > ./usr/include/linux/virtio_ring.h: In function =E2=80=98vring_i=
nit=E2=80=99:
> > > > ./usr/include/linux/virtio_ring.h:146:24: error: =E2=80=98uintp=
tr_t=E2=80=99 undeclared
> > > > (first use in this function)
> > > >   vr->used =3D (void *)(((uintptr_t)&vr->avail->ring[num] +
> > > > sizeof(__virtio16)
> > > >                         ^
> > > > ./usr/include/linux/virtio_ring.h:146:24: note: each undeclared
> > > > identifier is reported only once for each function it appears i=
n
> > > > scripts/Makefile.host:108: recipe for target
> >=20
> > D'oh, I only built the kernel for powerpc, that's why I did not not=
ice
> > this breakage in the MIC code. Sorry!
> >=20
> > > > E.g. fuse.h has this code:
> > > > #ifdef __KERNEL__
> > > > #include <linux/types.h>
> > > > #else
> > > > #include <stdint.h>
> > > > #endif
> > > >=20
> > > > Maybe we need something similar.
> > >=20
> > > The following seems to help.  Does it help the windows build?
> > ...
> > > diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linu=
x/virtio_ring.h
> > > index 8682551..c072959 100644
> > > --- a/include/uapi/linux/virtio_ring.h
> > > +++ b/include/uapi/linux/virtio_ring.h
> > > @@ -31,6 +31,9 @@
> > >   * SUCH DAMAGE.
> > >   *
> > >   * Copyright Rusty Russell IBM Corporation 2007. */
> > > +#ifndef __KERNEL__
> > > +#include <stdint.h>
> > > +#endif
> > >  #include <linux/types.h>
> > >  #include <linux/virtio_types.h>
> >=20
> > Since the update-linux-headers.sh script from QEMU replaces the
> > "#include <linux/types.h>" in virtio_ring.h to include a file that =
again
> > includes stdint.h already, your above patch should not do any
> > difference for compiling QEMU for Windows, I think. It's really jus=
t
> > about replacing the typecast there.
> >=20
> > But you're right of course for other user space applications which
> > include this header by other means. So I'm fine if you change my pa=
tch
> > with your hunk above (or add it as an additional patch). Or shall I
> > rather resend my patch with your above hunk included?
> >=20
> >  Thomas
>=20
> You don't have to, but could you confirm that stdint has uintptr_t on
> mingw?
>=20

$ grep typedef.*uintptr /usr/x86_64-w64-mingw32/sys-root/mingw/include/=
*.h
=2E..
/usr/x86_64-w64-mingw32/sys-root/mingw/include/crtdefs.h:__MINGW_EXTENS=
ION typedef unsigned __int64 uintptr_t;
=2E..

And the stdint.h from my MinGW installation includes crtdefs.h.
So yes, confirmed that stdint.h provides uintptr_t there, too.

 Thomas
