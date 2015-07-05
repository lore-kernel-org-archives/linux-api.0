From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RESEND] virtio: Fix typecast of pointer in vring_init()
Date: Sun, 5 Jul 2015 14:59:54 +0200
Message-ID: <20150705145917-mutt-send-email-mst@redhat.com>
References: <1435821682-1809-1-git-send-email-thuth@redhat.com>
 <20150705124937-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150705124937-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Jul 05, 2015 at 12:58:53PM +0200, Michael S. Tsirkin wrote:
> On Thu, Jul 02, 2015 at 09:21:22AM +0200, Thomas Huth wrote:
> > The virtio_ring.h header is used in userspace programs (ie. QEMU),
> > too. Here we can not assume that sizeof(pointer) is the same as
> > sizeof(long), e.g. when compiling for Windows, so the typecast in
> > vring_init() should be done with (uintptr_t) instead of (unsigned l=
ong).
> >=20
> > Signed-off-by: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
> This seems to break some userspace too:
>=20
>   INSTALL usr/include/linux/ (413 files)
>   CHECK   usr/include/linux/ (413 files)
>   HOSTCC  Documentation/accounting/getdelays
>   HOSTCC  Documentation/connector/ucon
>   HOSTCC  Documentation/mic/mpssd/mpssd.o
> In file included from Documentation/mic/mpssd/mpssd.c:36:0:
> ./usr/include/linux/virtio_ring.h: In function =E2=80=98vring_init=E2=
=80=99:
> ./usr/include/linux/virtio_ring.h:146:24: error: =E2=80=98uintptr_t=E2=
=80=99 undeclared
> (first use in this function)
>   vr->used =3D (void *)(((uintptr_t)&vr->avail->ring[num] +
> sizeof(__virtio16)
>                         ^
> ./usr/include/linux/virtio_ring.h:146:24: note: each undeclared
> identifier is reported only once for each function it appears in
> scripts/Makefile.host:108: recipe for target
> 'Documentation/mic/mpssd/mpssd.o' failed
> make[3]: *** [Documentation/mic/mpssd/mpssd.o] Error 1
> scripts/Makefile.build:403: recipe for target 'Documentation/mic/mpss=
d'
> failed
> make[2]: *** [Documentation/mic/mpssd] Error 2
> scripts/Makefile.build:403: recipe for target 'Documentation/mic' fai=
led
> make[1]: *** [Documentation/mic] Error 2
>=20
>=20
> E.g. fuse.h has this code:
> #ifdef __KERNEL__
> #include <linux/types.h>
> #else
> #include <stdint.h>
> #endif
>=20
> Maybe we need something similar.

The following seems to help.  Does it help the windows build?

---
 include/uapi/linux/virtio_ring.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virt=
io_ring.h
index 8682551..c072959 100644
--- a/include/uapi/linux/virtio_ring.h
+++ b/include/uapi/linux/virtio_ring.h
@@ -31,6 +31,9 @@
  * SUCH DAMAGE.
  *
  * Copyright Rusty Russell IBM Corporation 2007. */
+#ifndef __KERNEL__
+#include <stdint.h>
+#endif
 #include <linux/types.h>
 #include <linux/virtio_types.h>
=20
--=20
MST
