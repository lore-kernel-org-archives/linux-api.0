From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RESEND] virtio: Fix typecast of pointer in vring_init()
Date: Sun, 5 Jul 2015 12:58:53 +0200
Message-ID: <20150705124937-mutt-send-email-mst@redhat.com>
References: <1435821682-1809-1-git-send-email-thuth@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435821682-1809-1-git-send-email-thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 02, 2015 at 09:21:22AM +0200, Thomas Huth wrote:
> The virtio_ring.h header is used in userspace programs (ie. QEMU),
> too. Here we can not assume that sizeof(pointer) is the same as
> sizeof(long), e.g. when compiling for Windows, so the typecast in
> vring_init() should be done with (uintptr_t) instead of (unsigned lon=
g).
>=20
> Signed-off-by: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This seems to break some userspace too:

  INSTALL usr/include/linux/ (413 files)
  CHECK   usr/include/linux/ (413 files)
  HOSTCC  Documentation/accounting/getdelays
  HOSTCC  Documentation/connector/ucon
  HOSTCC  Documentation/mic/mpssd/mpssd.o
In file included from Documentation/mic/mpssd/mpssd.c:36:0:
=2E/usr/include/linux/virtio_ring.h: In function =E2=80=98vring_init=E2=
=80=99:
=2E/usr/include/linux/virtio_ring.h:146:24: error: =E2=80=98uintptr_t=E2=
=80=99 undeclared
(first use in this function)
  vr->used =3D (void *)(((uintptr_t)&vr->avail->ring[num] +
sizeof(__virtio16)
                        ^
=2E/usr/include/linux/virtio_ring.h:146:24: note: each undeclared
identifier is reported only once for each function it appears in
scripts/Makefile.host:108: recipe for target
'Documentation/mic/mpssd/mpssd.o' failed
make[3]: *** [Documentation/mic/mpssd/mpssd.o] Error 1
scripts/Makefile.build:403: recipe for target 'Documentation/mic/mpssd'
failed
make[2]: *** [Documentation/mic/mpssd] Error 2
scripts/Makefile.build:403: recipe for target 'Documentation/mic' faile=
d
make[1]: *** [Documentation/mic] Error 2


E.g. fuse.h has this code:
#ifdef __KERNEL__
#include <linux/types.h>
#else
#include <stdint.h>
#endif

Maybe we need something similar.

> ---
>  include/uapi/linux/virtio_ring.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/vi=
rtio_ring.h
> index 915980a..8682551 100644
> --- a/include/uapi/linux/virtio_ring.h
> +++ b/include/uapi/linux/virtio_ring.h
> @@ -143,7 +143,7 @@ static inline void vring_init(struct vring *vr, u=
nsigned int num, void *p,
>  	vr->num =3D num;
>  	vr->desc =3D p;
>  	vr->avail =3D p + num*sizeof(struct vring_desc);
> -	vr->used =3D (void *)(((unsigned long)&vr->avail->ring[num] + sizeo=
f(__virtio16)
> +	vr->used =3D (void *)(((uintptr_t)&vr->avail->ring[num] + sizeof(__=
virtio16)
>  		+ align-1) & ~(align - 1));
>  }
> =20
> --=20
> 1.8.3.1
