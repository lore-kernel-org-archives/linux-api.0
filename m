From: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 7/8] vhost: feature to set the vring endianness
Date: Tue, 14 Apr 2015 16:20:23 +0200
Message-ID: <20150414162023.2f8694fe.cornelia.huck@de.ibm.com>
References: <20150410101500.31843.61248.stgit@bahia.local>
	<20150410101627.31843.21710.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150410101627.31843.21710.stgit-GiB8zCg7hOfDOqzlkpFKJg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 10 Apr 2015 12:19:16 +0200
Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> This patch brings cross-endian support to vhost when used to implement
> legacy virtio devices. Since it is a relatively rare situation, the
> feature availability is controlled by a kernel config option (not set
> by default).
> 
> The vq->is_le boolean field is added to cache the endianness to be
> used for ring accesses. It defaults to native endian, as expected
> by legacy virtio devices. When the ring gets active, we force little
> endian if the device is modern. When the ring is deactivated, we
> revert to the native endian default.
> 
> If cross-endian was compiled in, a vq->user_be boolean field is added
> so that userspace may request a specific endianness. This field is
> used to override the default when activating the ring of a legacy
> device. It has no effect on modern devices.
> 
> Signed-off-by: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/vhost/Kconfig      |   10 ++++++
>  drivers/vhost/vhost.c      |   76 +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/vhost/vhost.h      |   12 +++++--
>  include/uapi/linux/vhost.h |    9 +++++
>  4 files changed, 103 insertions(+), 4 deletions(-)

> +#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
> +static long vhost_set_vring_big_endian(struct vhost_virtqueue *vq,
> +				       int __user *argp)
> +{
> +	struct vhost_vring_state s;
> +
> +	if (vq->private_data)
> +		return -EBUSY;
> +
> +	if (copy_from_user(&s, argp, sizeof(s)))
> +		return -EFAULT;
> +
> +	if (s.num && s.num != 1)

Checking for s.num > 1 might be more obvious at a glance?

> +		return -EINVAL;
> +
> +	vq->user_be = s.num;
> +
> +	return 0;
> +}
> +

(...)

> +#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
> +static void vhost_init_is_le(struct vhost_virtqueue *vq)
> +{
> +	vq->is_le = vhost_has_feature(vq, VIRTIO_F_VERSION_1) || !vq->user_be;

So if the endianness is not explicitly set to BE, it will be forced to
LE (instead of native endian)? Won't that break userspace that does not
yet use the new interface when CONFIG_VHOST_SET_ENDIAN_LEGACY is set?

> +}
> +#else
> +static void vhost_init_is_le(struct vhost_virtqueue *vq)
> +{
> +	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
> +		vq->is_le = true;
> +}
> +#endif
> +
>  int vhost_init_used(struct vhost_virtqueue *vq)
>  {
>  	__virtio16 last_used_idx;
>  	int r;
> -	if (!vq->private_data)
> +	if (!vq->private_data) {
> +		vq->is_le = virtio_legacy_is_little_endian();
>  		return 0;
> +	}
> +
> +	vhost_init_is_le(vq);
> 
>  	r = vhost_update_used_flags(vq);
>  	if (r)
