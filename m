From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 7/7] vhost: feature to set the vring endianness
Date: Tue, 7 Apr 2015 18:11:29 +0200
Message-ID: <20150407175640-mutt-send-email-mst@redhat.com>
References: <20150407120929.4213.8225.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
 <20150407121557.4213.95569.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150407121557.4213.95569.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 07, 2015 at 02:19:31PM +0200, Greg Kurz wrote:
> This patch brings cross-endian support to vhost when used to implement
> legacy virtio devices. Since it is a relatively rare situation, the
> feature availability is controlled by a kernel config option (not set
> by default).
> 
> The ioctls introduced by this patch are for legacy only: virtio 1.0
> devices are returned EPERM.
> 
> Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
> ---
>  drivers/vhost/Kconfig      |   10 ++++++++
>  drivers/vhost/vhost.c      |   55 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/vhost/vhost.h      |   17 +++++++++++++-
>  include/uapi/linux/vhost.h |    5 ++++
>  4 files changed, 86 insertions(+), 1 deletion(-)
> 
> Changes since v2:
> - fixed typos in Kconfig description
> - renamed vq->legacy_big_endian to vq->legacy_is_little_endian
> - vq->legacy_is_little_endian reset to default in vhost_vq_reset()
> - dropped VHOST_F_SET_ENDIAN_LEGACY feature
> - dropped struct vhost_vring_endian from the user API (re-use
>   struct vhost_vring_state instead)
> - added VHOST_GET_VRING_ENDIAN_LEGACY ioctl
> - introduced more helpers and stubs to avoid polluting the code with ifdefs
> 
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 017a1e8..0aec88c 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -32,3 +32,13 @@ config VHOST
>  	---help---
>  	  This option is selected by any driver which needs to access
>  	  the core of vhost.
> +
> +config VHOST_SET_ENDIAN_LEGACY
> +	bool "Cross-endian support for host kernel accelerator"
> +	default n
> +	---help---
> +	  This option allows vhost to support guests with a different byte
> +	  ordering from host. It is disabled by default since it adds overhead
> +	  and it is only needed by a few platforms (powerpc and arm).
> +
> +	  If unsure, say "N".
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 2ee2826..3529a3c 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -199,6 +199,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>  	vq->call = NULL;
>  	vq->log_ctx = NULL;
>  	vq->memory = NULL;
> +	vq->legacy_is_little_endian = virtio_legacy_is_little_endian();
>  }
>  
>  static int vhost_worker(void *data)
> @@ -630,6 +631,54 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
>  	return 0;
>  }
>  
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
> +}
> +
> +static long vhost_get_vring_endian_legacy(struct vhost_virtqueue *vq,
> +					  u32 idx,
> +					  void __user *argp)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_VHOST_SET_ENDIAN_LEGACY */
> +
>  long vhost_vring_ioctl(struct vhost_dev *d, int ioctl, void __user *argp)
>  {
>  	struct file *eventfp, *filep = NULL;
> @@ -806,6 +855,12 @@ long vhost_vring_ioctl(struct vhost_dev *d, int ioctl, void __user *argp)
>  		} else
>  			filep = eventfp;
>  		break;
> +	case VHOST_SET_VRING_ENDIAN_LEGACY:
> +		r = vhost_set_vring_endian_legacy(vq, argp);
> +		break;
> +	case VHOST_GET_VRING_ENDIAN_LEGACY:
> +		r = vhost_get_vring_endian_legacy(vq, idx, argp);
> +		break;
>  	default:
>  		r = -ENOIOCTLCMD;
>  	}
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 4e9a186..981ba06 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -106,6 +106,9 @@ struct vhost_virtqueue {
>  	/* Log write descriptors */
>  	void __user *log_base;
>  	struct vhost_log *log;
> +
> +	/* We need to know the device endianness with legacy virtio. */
> +	bool legacy_is_little_endian;
>  };
>  
>  struct vhost_dev {
> @@ -173,11 +176,23 @@ static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit)
>  	return vq->acked_features & (1ULL << bit);
>  }
>  
> +#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
> +static inline bool vhost_legacy_is_little_endian(struct vhost_virtqueue *vq)
> +{
> +	return vq->legacy_is_little_endian;
> +}
> +#else
> +static inline bool vhost_legacy_is_little_endian(struct vhost_virtqueue *vq)
> +{
> +	return virtio_legacy_is_little_endian();
> +}
> +#endif
> +
>  static inline bool vhost_is_little_endian(struct vhost_virtqueue *vq)
>  {
>  	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
>  		return true;
> -	return virtio_legacy_is_little_endian();
> +	return vhost_legacy_is_little_endian(vq);
>  }
>  
>  /* Memory accessors */
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index bb6a5b4..1b01a72 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -103,6 +103,11 @@ struct vhost_memory {
>  /* Get accessor: reads index, writes value in num */
>  #define VHOST_GET_VRING_BASE _IOWR(VHOST_VIRTIO, 0x12, struct vhost_vring_state)
>  
> +/* Set endianness for the ring (legacy virtio only) */
> +/* num is 0 for big endian, other values mean little endian */
> +#define VHOST_SET_VRING_ENDIAN_LEGACY _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
> +#define VHOST_GET_VRING_ENDIAN_LEGACY _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
> +
>  /* The following ioctls use eventfd file descriptors to signal and poll
>   * for events. */
>  

So if the config feature is enabled, you actually check two
things: 1. feature 2. ioctl

Why not override is_le when we set VIRTIO_F_VERSION_1?
I guess you are worried that setting a value and not being
able to read it back is ugly. We can add a flag to track
it though. So here's an idea
	I would probably rename to G/SET_BIG_ENDIAN then it's obvious
	it's legacy.  And just document that it's ignored with
	VIRTIO_F_VERSION_1.

	make sure it's not changed when ring is running

	simply set vq->is_le correctly when we start/stop the device
		vq->is_le = vhost_has_feature(vq, VIRTIO_F_VERSION_1) ||
			!vq->user_be;

	 static inline bool vhost_is_little_endian(struct vhost_virtqueue *vq)
	 {
		return vq->is_le;
	 }


-- 
MST
