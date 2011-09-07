From: Paul Clements <paul.clements-eviPjrN/1CxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/3] nbd: add support for feature negotiation
Date: Wed, 7 Sep 2011 12:30:26 -0400
Message-ID: <CAECXXi4YW++_302mcSTX=cPjbguSqcw3Weec85VrLFv1qNHXug@mail.gmail.com>
References: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
	<1315406503-7883-3-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1315406503-7883-3-git-send-email-pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=nbd-general>
List-Post: <mailto:nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Paolo,

thanks for the patch...

On Wed, Sep 7, 2011 at 10:41 AM, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Add a IOCTL to negotiate features between the server and the
> kernel module (mediated by the usermode client). =A0Features are
> stored in the pre-existing flags field.

I'm not crazy about another ioctl, but we need to get this flag
setting functionality in, and I just have not had the time...

> Also zero out the flags when NBD_DO_IT completes.
>
> Cc: Paul Clements <Paul.Clements-G8/ITkJZaeZWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0drivers/block/nbd.c | =A0 =A08 ++++++++
> =A0include/linux/nbd.h | =A0 24 +++++++++++++++---------
> =A02 files changed, 23 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index be23aec..c4fe9c8 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -85,6 +85,7 @@ static const char *ioctl_cmd_to_ascii(int cmd)
> =A0 =A0 =A0 =A0case NBD_PRINT_DEBUG: return "print-debug";
> =A0 =A0 =A0 =A0case NBD_SET_SIZE_BLOCKS: return "set-size-blocks";
> =A0 =A0 =A0 =A0case NBD_DISCONNECT: return "disconnect";
> + =A0 =A0 =A0 case NBD_SET_FEATURES: return "set-features";

Could you name this as NBD_SET_FLAGS, as that's more consistent with
what it's really doing?

Otherwise these look good for inclusion.

Thanks,
Paul


> =A0 =A0 =A0 =A0case BLKROSET: return "set-read-only";
> =A0 =A0 =A0 =A0case BLKFLSBUF: return "flush-buffer-cache";
> =A0 =A0 =A0 =A0}
> @@ -634,6 +635,12 @@ static int __nbd_ioctl(struct block_device *bdev, st=
ruct nbd_device *lo,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lo->xmit_timeout =3D arg * HZ;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> + =A0 =A0 =A0 case NBD_SET_FEATURES:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (((u64) arg) & NBD_FEATURE_RESERVED)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lo->flags =3D (lo->flags & NBD_FEATURE_RESE=
RVED) | (u64)arg;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> =A0 =A0 =A0 =A0case NBD_SET_SIZE_BLOCKS:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lo->bytesize =3D ((u64) arg) * lo->blksize;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bdev->bd_inode->i_size =3D lo->bytesize;
> @@ -672,6 +679,7 @@ static int __nbd_ioctl(struct block_device *bdev, str=
uct nbd_device *lo,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_WARNING "%s: queue cleared\n",=
 lo->disk->disk_name);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fput(file);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lo->flags =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lo->bytesize =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bdev->bd_inode->i_size =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_capacity(lo->disk, 0);
> diff --git a/include/linux/nbd.h b/include/linux/nbd.h
> index 0582054..926f19d 100644
> --- a/include/linux/nbd.h
> +++ b/include/linux/nbd.h
> @@ -17,16 +17,22 @@
>
> =A0#include <linux/types.h>
>
> -#define NBD_SET_SOCK =A0 _IO( 0xab, 0 )
> -#define NBD_SET_BLKSIZE =A0 =A0 =A0 =A0_IO( 0xab, 1 )
> -#define NBD_SET_SIZE =A0 _IO( 0xab, 2 )
> -#define NBD_DO_IT =A0 =A0 =A0_IO( 0xab, 3 )
> -#define NBD_CLEAR_SOCK _IO( 0xab, 4 )
> -#define NBD_CLEAR_QUE =A0_IO( 0xab, 5 )
> -#define NBD_PRINT_DEBUG =A0 =A0 =A0 =A0_IO( 0xab, 6 )
> -#define NBD_SET_SIZE_BLOCKS =A0 =A0_IO( 0xab, 7 )
> -#define NBD_DISCONNECT =A0_IO( 0xab, 8 )
> -#define NBD_SET_TIMEOUT _IO( 0xab, 9 )
> +#define NBD_SET_SOCK =A0 =A0 =A0 =A0 =A0 _IO(0xab, 0)
> +#define NBD_SET_BLKSIZE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_IO(0xab, 1)
> +#define NBD_SET_SIZE =A0 =A0 =A0 =A0 =A0 _IO(0xab, 2)
> +#define NBD_DO_IT =A0 =A0 =A0 =A0 =A0 =A0 =A0_IO(0xab, 3)
> +#define NBD_CLEAR_SOCK =A0 =A0 =A0 =A0 _IO(0xab, 4)
> +#define NBD_CLEAR_QUE =A0 =A0 =A0 =A0 =A0_IO(0xab, 5)
> +#define NBD_PRINT_DEBUG =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_IO(0xab, 6)
> +#define NBD_SET_SIZE_BLOCKS =A0 =A0_IO(0xab, 7)
> +#define NBD_DISCONNECT =A0 =A0 =A0 =A0 _IO(0xab, 8)
> +#define NBD_SET_TIMEOUT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_IO(0xab, 9)
> +#define NBD_SET_FEATURES =A0 =A0 =A0 _IO(0xab, 10)
> +
> +/* bits 0 and 1 are already used for flags in the protocol, we do
> + * not want any overlap. =A0Bits 32-63 are reserved because they
> + * are inaccessible on 32-bit platforms. =A0*/
> +#define NBD_FEATURE_RESERVED =A0 0xFFFFFFFF00000003LL
>
> =A0enum {
> =A0 =A0 =A0 =A0NBD_CMD_READ =3D 0,
> --
> 1.7.6
>
>
>

---------------------------------------------------------------------------=
---
Using storage to extend the benefits of virtualization and iSCSI
Virtualization increases hardware utilization and delivers a new level of
agility. Learn what those decisions are and how to modernize your storage =

and backup environments for virtualization.
http://www.accelacomm.com/jaw/sfnl/114/51434361/
