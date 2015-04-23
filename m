From: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 5/8] vhost: introduce vhost_is_little_endian() helper
Date: Thu, 23 Apr 2015 21:05:02 +0200
Message-ID: <20150423210502.1d97ca77@thh440s>
References: <20150423152608.11795.4373.stgit@bahia.local>
	<20150423152700.11795.9146.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150423152700.11795.9146.stgit-GiB8zCg7hOfDOqzlkpFKJg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 23 Apr 2015 17:27:05 +0200
Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> Signed-off-by: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/vhost/vhost.h |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 8c1c792..6a49960 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -173,34 +173,39 @@ static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit)
>  	return vq->acked_features & (1ULL << bit);
>  }
>  
> +static inline bool vhost_is_little_endian(struct vhost_virtqueue *vq)
> +{
> +	return vhost_has_feature(vq, VIRTIO_F_VERSION_1);
> +}
> +
>  /* Memory accessors */
>  static inline u16 vhost16_to_cpu(struct vhost_virtqueue *vq, __virtio16 val)
>  {
> -	return __virtio16_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
> +	return __virtio16_to_cpu(vhost_is_little_endian(vq), val);
>  }
>  
>  static inline __virtio16 cpu_to_vhost16(struct vhost_virtqueue *vq, u16 val)
>  {
> -	return __cpu_to_virtio16(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
> +	return __cpu_to_virtio16(vhost_is_little_endian(vq), val);
>  }
>  
>  static inline u32 vhost32_to_cpu(struct vhost_virtqueue *vq, __virtio32 val)
>  {
> -	return __virtio32_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
> +	return __virtio32_to_cpu(vhost_is_little_endian(vq), val);
>  }
>  
>  static inline __virtio32 cpu_to_vhost32(struct vhost_virtqueue *vq, u32 val)
>  {
> -	return __cpu_to_virtio32(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
> +	return __cpu_to_virtio32(vhost_is_little_endian(vq), val);
>  }
>  
>  static inline u64 vhost64_to_cpu(struct vhost_virtqueue *vq, __virtio64 val)
>  {
> -	return __virtio64_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
> +	return __virtio64_to_cpu(vhost_is_little_endian(vq), val);
>  }
>  
>  static inline __virtio64 cpu_to_vhost64(struct vhost_virtqueue *vq, u64 val)
>  {
> -	return __cpu_to_virtio64(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
> +	return __cpu_to_virtio64(vhost_is_little_endian(vq), val);
>  }
>  #endif

Reviewed-by: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
