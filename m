From: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 7/7] vhost: feature to set the vring endianness
Date: Tue, 7 Apr 2015 17:01:31 +0200
Message-ID: <20150407170131.3899d62c.cornelia.huck@de.ibm.com>
References: <20150407120929.4213.8225.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
	<20150407121557.4213.95569.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150407121557.4213.95569.stgit-to6p26YowclJmDnNpxttO7KMsZMIf1jtdfLczzV0R5oAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 07 Apr 2015 14:19:31 +0200
Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> This patch brings cross-endian support to vhost when used to implement
> legacy virtio devices. Since it is a relatively rare situation, the
> feature availability is controlled by a kernel config option (not set
> by default).
> 
> The ioctls introduced by this patch are for legacy only: virtio 1.0
> devices are returned EPERM.
> 
> Signed-off-by: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/vhost/Kconfig      |   10 ++++++++
>  drivers/vhost/vhost.c      |   55 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/vhost/vhost.h      |   17 +++++++++++++-
>  include/uapi/linux/vhost.h |    5 ++++
>  4 files changed, 86 insertions(+), 1 deletion(-)

> +#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
> +static long vhost_set_vring_endian_legacy(struct vhost_virtqueue *vq,
> +					  void __user *argp)
> +{
> +	struct vhost_vring_state s;
> +
> +	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
> +		return -EPERM;
> +
> +	if (copy_from_user(&s, argp, sizeof(s)))
> +		return -EFAULT;
> +
> +	vq->legacy_is_little_endian = !!s.num;
> +	return 0;
> +}
> +
> +static long vhost_get_vring_endian_legacy(struct vhost_virtqueue *vq,
> +					  u32 idx,
> +					  void __user *argp)
> +{
> +	struct vhost_vring_state s = {
> +		.index = idx,
> +		.num = vq->legacy_is_little_endian
> +	};
> +
> +	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
> +		return -EPERM;
> +
> +	if (copy_to_user(argp, &s, sizeof(s)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +#else
> +static long vhost_set_vring_endian_legacy(struct vhost_virtqueue *vq,
> +					  void __user *argp)
> +{
> +	return 0;

I'm wondering whether this handler should return an error if the
feature is not configured for the kernel? How can the userspace caller
find out whether it has successfully prompted the kernel to handle the
endianness correctly?

> +}
> +
> +static long vhost_get_vring_endian_legacy(struct vhost_virtqueue *vq,
> +					  u32 idx,
> +					  void __user *argp)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_VHOST_SET_ENDIAN_LEGACY */
