From: Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v5 2/8] tun: add tun_is_little_endian() helper
Date: Thu, 23 Apr 2015 20:57:56 +0200
Message-ID: <20150423205756.5f477b27@thh440s>
References: <20150423152608.11795.4373.stgit@bahia.local>
	<20150423152628.11795.87340.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150423152628.11795.87340.stgit@bahia.local>
Sender: kvm-owner@vger.kernel.org
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Thu, 23 Apr 2015 17:26:30 +0200
Greg Kurz <gkurz@linux.vnet.ibm.com> wrote:

> Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
> ---
>  drivers/net/tun.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 857dca4..3c3d6c0 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -206,14 +206,19 @@ struct tun_struct {
>  	u32 flow_count;
>  };
>  
> +static inline bool tun_is_little_endian(struct tun_struct *tun)
> +{
> +	return tun->flags & TUN_VNET_LE;
> +}
> +
>  static inline u16 tun16_to_cpu(struct tun_struct *tun, __virtio16 val)
>  {
> -	return __virtio16_to_cpu(tun->flags & TUN_VNET_LE, val);
> +	return __virtio16_to_cpu(tun_is_little_endian(tun), val);
>  }
>  
>  static inline __virtio16 cpu_to_tun16(struct tun_struct *tun, u16 val)
>  {
> -	return __cpu_to_virtio16(tun->flags & TUN_VNET_LE, val);
> +	return __cpu_to_virtio16(tun_is_little_endian(tun), val);
>  }

Reviewed-by: Thomas Huth <thuth@redhat.com>

