From: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 6/8] virtio: add explicit big-endian support to
 memory accessors
Date: Thu, 23 Apr 2015 21:27:19 +0200
Message-ID: <20150423212719.4b7f9507@thh440s>
References: <20150423152608.11795.4373.stgit@bahia.local>
	<20150423152712.11795.29245.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150423152712.11795.29245.stgit-GiB8zCg7hOfDOqzlkpFKJg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 23 Apr 2015 17:29:06 +0200
Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> The current memory accessors logic is:
> - little endian if little_endian
> - native endian (i.e. no byteswap) if !little_endian
> 
> If we want to fully support cross-endian vhost, we also need to be
> able to convert to big endian.
> 
> Instead of changing the little_endian argument to some 3-value enum, this
> patch changes the logic to:
> - little endian if little_endian
> - big endian if !little_endian
> 
> The native endian case is handled by all users with a trivial helper. This
> patch doesn't change any functionality, nor it does add overhead.
> 
> Signed-off-by: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
> 
> Changes since v4:
> - style fixes (I have chosen if ... else in most places to stay below
>   80 columns, with the notable exception of the vhost helper which gets
>   shorten in a later patch)
> 
>  drivers/net/macvtap.c            |    5 ++++-
>  drivers/net/tun.c                |    5 ++++-
>  drivers/vhost/vhost.h            |    2 +-
>  include/linux/virtio_byteorder.h |   24 ++++++++++++++----------
>  include/linux/virtio_config.h    |    5 ++++-
>  include/linux/vringh.h           |    2 +-
>  6 files changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index a2f2958..6cf6b3e 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -51,7 +51,10 @@ struct macvtap_queue {
>  
>  static inline bool macvtap_is_little_endian(struct macvtap_queue *q)
>  {
> -	return q->flags & MACVTAP_VNET_LE;
> +	if (q->flags & MACVTAP_VNET_LE)
> +		return true;
> +	else
> +		return virtio_legacy_is_little_endian();

simply:

	return (q->flags & MACVTAP_VNET_LE) ||
	       virtio_legacy_is_little_endian();

?

>  }
>  
>  static inline u16 macvtap16_to_cpu(struct macvtap_queue *q, __virtio16 val)
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 3c3d6c0..5b044d4 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -208,7 +208,10 @@ struct tun_struct {
>  
>  static inline bool tun_is_little_endian(struct tun_struct *tun)
>  {
> -	return tun->flags & TUN_VNET_LE;
> +	if (tun->flags & TUN_VNET_LE)
> +		return true;
> +	else
> +		return virtio_legacy_is_little_endian();

dito?

>  }
>  
>  static inline u16 tun16_to_cpu(struct tun_struct *tun, __virtio16 val)
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 6a49960..954c657 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -175,7 +175,7 @@ static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit)
>  
>  static inline bool vhost_is_little_endian(struct vhost_virtqueue *vq)
>  {
> -	return vhost_has_feature(vq, VIRTIO_F_VERSION_1);
> +	return vhost_has_feature(vq, VIRTIO_F_VERSION_1) ? true : virtio_legacy_is_little_endian();
>  }

That line is way longer than 80 characters ... may I suggest to switch
at least here to:

	return vhost_has_feature(vq, VIRTIO_F_VERSION_1) ||
	       virtio_legacy_is_little_endian();

?

Apart from the cosmetics, the patch looks good to me.

 Thomas
