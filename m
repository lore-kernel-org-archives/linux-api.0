From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 8/8] macvtap/tun: add VNET_BE flag
Date: Tue, 21 Apr 2015 16:06:33 +0200
Message-ID: <20150421160538-mutt-send-email-mst@redhat.com>
References: <20150410101500.31843.61248.stgit@bahia.local>
 <20150410101923.31843.66853.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150410101923.31843.66853.stgit-GiB8zCg7hOfDOqzlkpFKJg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 10, 2015 at 12:20:21PM +0200, Greg Kurz wrote:
> The VNET_LE flag was introduced to fix accesses to virtio 1.0 headers
> that are always little-endian. It can also be used to handle the special
> case of a legacy little-endian device implemented by a big-endian host.
> 
> Let's add a flag and ioctls for big-endian devices as well. If both flags
> are set, little-endian wins.
> 
> Since this is isn't a common usecase, the feature is controlled by a kernel
> config option (not set by default).
> 
> Both macvtap and tun are covered by this patch since they share the same
> API with userland.
> 
> Signed-off-by: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/net/Kconfig         |   12 ++++++++
>  drivers/net/macvtap.c       |   60 +++++++++++++++++++++++++++++++++++++++++-
>  drivers/net/tun.c           |   62 ++++++++++++++++++++++++++++++++++++++++++-
>  include/uapi/linux/if_tun.h |    2 +
>  4 files changed, 134 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index df51d60..f0e23a0 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -244,6 +244,18 @@ config TUN
>  
>  	  If you don't know what to use this for, you don't need it.
>  
> +config TUN_VNET_BE
> +	bool "Support for big-endian vnet headers"
> +	default n
> +	---help---
> +	  This option allows TUN/TAP and MACVTAP device drivers to parse
> +	  vnet headers that are in big-endian byte order. It is useful
> +	  when the headers come from a big-endian legacy virtio driver and
> +	  the host is little-endian.
> +
> +	  Unless you have a little-endian system hosting a big-endian virtual
> +	  machine with a virtio NIC, you should say N.
> +

should mention cross-endian, not big-endian, right?

>  config VETH
>  	tristate "Virtual ethernet pair device"
>  	---help---
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index 0a03a66..e0ab1b7 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -48,12 +48,27 @@ struct macvtap_queue {
>  #define MACVTAP_FEATURES (IFF_VNET_HDR | IFF_MULTI_QUEUE)
>  
>  #define MACVTAP_VNET_LE 0x80000000
> +#define MACVTAP_VNET_BE 0x40000000
> +
> +#ifdef CONFIG_TUN_VNET_BE
> +static inline bool macvtap_legacy_is_little_endian(struct macvtap_queue *q)
> +{
> +	if (q->flags & MACVTAP_VNET_BE)
> +		return false;
> +	return virtio_legacy_is_little_endian();
> +}
> +#else
> +static inline bool macvtap_legacy_is_little_endian(struct macvtap_queue *q)
> +{
> +	return virtio_legacy_is_little_endian();
> +}
> +#endif
>  
>  static inline bool macvtap_is_little_endian(struct macvtap_queue *q)
>  {
>  	if (q->flags & MACVTAP_VNET_LE)
>  		return true;
> -	return virtio_legacy_is_little_endian();
> +	return macvtap_legacy_is_little_endian(q);
>  }
>  
>  static inline u16 macvtap16_to_cpu(struct macvtap_queue *q, __virtio16 val)
> @@ -1000,6 +1015,43 @@ static int set_offload(struct macvtap_queue *q, unsigned long arg)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_TUN_VNET_BE
> +static long macvtap_get_vnet_be(struct macvtap_queue *q, int __user *sp)
> +{
> +	int s = !!(q->flags & MACVTAP_VNET_BE);
> +
> +	if (put_user(s, sp))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static long macvtap_set_vnet_be(struct macvtap_queue *q, int __user *sp)
> +{
> +	int s;
> +
> +	if (get_user(s, sp))
> +		return -EFAULT;
> +
> +	if (s)
> +		q->flags |= MACVTAP_VNET_BE;
> +	else
> +		q->flags &= ~MACVTAP_VNET_BE;
> +
> +	return 0;
> +}
> +#else
> +static long macvtap_get_vnet_be(struct macvtap_queue *q, int __user *argp)
> +{
> +	return -EINVAL;
> +}
> +
> +static long macvtap_set_vnet_be(struct macvtap_queue *q, int __user *argp)
> +{
> +	return -EINVAL;
> +}
> +#endif /* CONFIG_TUN_VNET_BE */
> +
>  /*
>   * provide compatibility with generic tun/tap interface
>   */
> @@ -1097,6 +1149,12 @@ static long macvtap_ioctl(struct file *file, unsigned int cmd,
>  			q->flags &= ~MACVTAP_VNET_LE;
>  		return 0;
>  
> +	case TUNGETVNETBE:
> +		return macvtap_get_vnet_be(q, sp);
> +
> +	case TUNSETVNETBE:
> +		return macvtap_set_vnet_be(q, sp);
> +
>  	case TUNSETOFFLOAD:
>  		/* let the user check for future flags */
>  		if (arg & ~(TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 053f9b6..4e12488 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -111,6 +111,7 @@ do {								\
>  #define TUN_FASYNC	IFF_ATTACH_QUEUE
>  /* High bits in flags field are unused. */
>  #define TUN_VNET_LE     0x80000000
> +#define TUN_VNET_BE     0x40000000
>  
>  #define TUN_FEATURES (IFF_NO_PI | IFF_ONE_QUEUE | IFF_VNET_HDR | \
>  		      IFF_MULTI_QUEUE)
> @@ -206,11 +207,25 @@ struct tun_struct {
>  	u32 flow_count;
>  };
>  
> +#ifdef CONFIG_TUN_VNET_BE
> +static inline bool tun_legacy_is_little_endian(struct tun_struct *tun)
> +{
> +	if (tun->flags & TUN_VNET_BE)
> +		return false;
> +	return virtio_legacy_is_little_endian();
> +}
> +#else
> +static inline bool tun_legacy_is_little_endian(struct tun_struct *tun)
> +{
> +	return virtio_legacy_is_little_endian();
> +}
> +#endif
> +
>  static inline bool tun_is_little_endian(struct tun_struct *tun)
>  {
>  	if (tun->flags & TUN_VNET_LE)
>  		return true;
> -	return virtio_legacy_is_little_endian();
> +	return tun_legacy_is_little_endian(tun);
>  }
>  
>  static inline u16 tun16_to_cpu(struct tun_struct *tun, __virtio16 val)
> @@ -1836,6 +1851,43 @@ unlock:
>  	return ret;
>  }
>  
> +#ifdef CONFIG_TUN_VNET_BE
> +static long tun_get_vnet_be(struct tun_struct *tun, int __user *argp)
> +{
> +	int be = !!(tun->flags & TUN_VNET_BE);
> +
> +	if (put_user(be, argp))
> +		return EFAULT;
> +
> +	return 0;
> +}
> +
> +static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
> +{
> +	int be;
> +
> +	if (get_user(be, argp))
> +		return -EFAULT;
> +
> +	if (be)
> +		tun->flags |= TUN_VNET_BE;
> +	else
> +		tun->flags &= ~TUN_VNET_BE;
> +
> +	return 0;
> +}
> +#else
> +static long tun_get_vnet_be(struct tun_struct *tun, int __user *argp)
> +{
> +	return -EINVAL;
> +}
> +
> +static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
> +{
> +	return -EINVAL;
> +}
> +#endif /* CONFIG_TUN_VNET_BE */
> +
>  static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
>  			    unsigned long arg, int ifreq_len)
>  {
> @@ -2065,6 +2117,14 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
>  			tun->flags &= ~TUN_VNET_LE;
>  		break;
>  
> +	case TUNGETVNETBE:
> +		ret = tun_get_vnet_be(tun, argp);
> +		break;
> +
> +	case TUNSETVNETBE:
> +		ret = tun_set_vnet_be(tun, argp);
> +		break;
> +
>  	case TUNATTACHFILTER:
>  		/* Can be set only for TAPs */
>  		ret = -EINVAL;
> diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
> index 50ae243..bcac4c0 100644
> --- a/include/uapi/linux/if_tun.h
> +++ b/include/uapi/linux/if_tun.h
> @@ -50,6 +50,8 @@
>  #define TUNGETFILTER _IOR('T', 219, struct sock_fprog)
>  #define TUNSETVNETLE _IOW('T', 220, int)
>  #define TUNGETVNETLE _IOR('T', 221, int)
> +#define TUNSETVNETBE _IOW('T', 222, int)
> +#define TUNGETVNETBE _IOR('T', 223, int)
>  
>  /* TUNSETIFF ifr flags */
>  #define IFF_TUN		0x0001
