From: Paul Clements <paul.clements-eviPjrN/1CxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 3/3] nbd: map DISCARD requests to a new nbd request type
Date: Wed, 7 Sep 2011 21:13:47 -0400
Message-ID: <CAECXXi5Wj=y8KPYr570N2Smtrj7u-jr5u-zdE=euDiL6Ka=a8g@mail.gmail.com>
References: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
	<1315406503-7883-4-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315406503-7883-4-git-send-email-pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 7, 2011 at 10:41 AM, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> When the feature is enabled, set QUEUE_FLAG_DISCARD and transmit thos=
e as
> NBD_CMD_TRIM requests.
>
> I used "trim" instead of "discard" to avoid confusion with the existi=
ng
> NBD_CMD_DISC that is used for disconnect.

This patchset looks good to me.

--
Paul

> Cc: Paul Clements <Paul.Clements-G8/ITkJZaeZWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0drivers/block/nbd.c | =A0 15 ++++++++++++---
> =A0include/linux/nbd.h | =A0 =A04 +++-
> =A02 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index c4fe9c8..71ebaab 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -98,6 +98,7 @@ static const char *nbdcmd_to_ascii(int cmd)
> =A0 =A0 =A0 =A0case =A0NBD_CMD_READ: return "read";
> =A0 =A0 =A0 =A0case NBD_CMD_WRITE: return "write";
> =A0 =A0 =A0 =A0case =A0NBD_CMD_DISC: return "disconnect";
> + =A0 =A0 =A0 case =A0NBD_CMD_TRIM: return "trim (discard)";
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return "invalid";
> =A0}
> @@ -454,9 +455,13 @@ static void nbd_handle_req(struct nbd_device *lo=
, struct request *req)
> =A0 =A0 =A0 =A0if (req->cmd_type !=3D REQ_TYPE_FS)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto error_out;
>
> - =A0 =A0 =A0 if (rq_data_dir(req) =3D=3D WRITE)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 nbd_cmd(req) =3D NBD_CMD_WRITE;
> - =A0 =A0 =A0 else
> + =A0 =A0 =A0 if (rq_data_dir(req) =3D=3D WRITE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((req->cmd_flags & REQ_DISCARD)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(!(lo->flags & N=
BD_FEATURE_TRIM));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nbd_cmd(req) =3D NBD_CM=
D_TRIM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nbd_cmd(req) =3D NBD_CM=
D_WRITE;
> + =A0 =A0 =A0 } else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nbd_cmd(req) =3D NBD_CMD_READ;
>
> =A0 =A0 =A0 =A0req->errors =3D 0;
> @@ -659,6 +664,9 @@ static int __nbd_ioctl(struct block_device *bdev,=
 struct nbd_device *lo,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&lo->tx_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (lo->flags & NBD_FEATURE_TRIM)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_flag_set_unlocked=
(QUEUE_FLAG_DISCARD,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 lo->disk->queue);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0thread =3D kthread_create(nbd_thread, =
lo, lo->disk->disk_name);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (IS_ERR(thread)) {
> @@ -677,6 +685,7 @@ static int __nbd_ioctl(struct block_device *bdev,=
 struct nbd_device *lo,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lo->file =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nbd_clear_que(lo);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_WARNING "%s: queue cleared=
\n", lo->disk->disk_name);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_flag_clear_unlocked(QUEUE_FLAG_DI=
SCARD, lo->disk->queue);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fput(file);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lo->flags =3D 0;
> @@ -796,6 +805,9 @@ static int __init nbd_init(void)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Tell the block layer that we are no=
t a rotational device
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0queue_flag_set_unlocked(QUEUE_FLAG_NON=
ROT, disk->queue);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 disk->queue->limits.discard_granularity=
 =3D 512;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 disk->queue->limits.max_discard_sectors=
 =3D UINT_MAX;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 disk->queue->limits.discard_zeroes_data=
 =3D 0;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (register_blkdev(NBD_MAJOR, "nbd")) {
> diff --git a/include/linux/nbd.h b/include/linux/nbd.h
> index 926f19d..7048463 100644
> --- a/include/linux/nbd.h
> +++ b/include/linux/nbd.h
> @@ -33,11 +33,13 @@
> =A0* not want any overlap. =A0Bits 32-63 are reserved because they
> =A0* are inaccessible on 32-bit platforms. =A0*/
> =A0#define NBD_FEATURE_RESERVED =A0 0xFFFFFFFF00000003LL
> +#define NBD_FEATURE_TRIM =A0 =A0 =A0 (1 << 2)
>
> =A0enum {
> =A0 =A0 =A0 =A0NBD_CMD_READ =3D 0,
> =A0 =A0 =A0 =A0NBD_CMD_WRITE =3D 1,
> - =A0 =A0 =A0 NBD_CMD_DISC =3D 2
> + =A0 =A0 =A0 NBD_CMD_DISC =3D 2,
> + =A0 =A0 =A0 NBD_CMD_TRIM =3D 3
> =A0};
>
> =A0#define nbd_cmd(req) ((req)->cmd[0])
> --
> 1.7.6
>
>
