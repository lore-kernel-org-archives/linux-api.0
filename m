From: Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v5 4/8] vringh: introduce vringh_is_little_endian()
 helper
Date: Thu, 23 Apr 2015 21:00:58 +0200
Message-ID: <20150423210058.70f113ef@thh440s>
References: <20150423152608.11795.4373.stgit@bahia.local>
	<20150423152648.11795.30368.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150423152648.11795.30368.stgit@bahia.local>
Sender: kvm-owner@vger.kernel.org
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Thu, 23 Apr 2015 17:26:52 +0200
Greg Kurz <gkurz@linux.vnet.ibm.com> wrote:

> Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
> ---
>  include/linux/vringh.h |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index a3fa537..3ed62ef 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -226,33 +226,38 @@ static inline void vringh_notify(struct vringh *vrh)
>  		vrh->notify(vrh);
>  }
>  
> +static inline bool vringh_is_little_endian(const struct vringh *vrh)
> +{
> +	return vrh->little_endian;
> +}
> +
>  static inline u16 vringh16_to_cpu(const struct vringh *vrh, __virtio16 val)
>  {
> -	return __virtio16_to_cpu(vrh->little_endian, val);
> +	return __virtio16_to_cpu(vringh_is_little_endian(vrh), val);
>  }
>  
>  static inline __virtio16 cpu_to_vringh16(const struct vringh *vrh, u16 val)
>  {
> -	return __cpu_to_virtio16(vrh->little_endian, val);
> +	return __cpu_to_virtio16(vringh_is_little_endian(vrh), val);
>  }
>  
>  static inline u32 vringh32_to_cpu(const struct vringh *vrh, __virtio32 val)
>  {
> -	return __virtio32_to_cpu(vrh->little_endian, val);
> +	return __virtio32_to_cpu(vringh_is_little_endian(vrh), val);
>  }
>  
>  static inline __virtio32 cpu_to_vringh32(const struct vringh *vrh, u32 val)
>  {
> -	return __cpu_to_virtio32(vrh->little_endian, val);
> +	return __cpu_to_virtio32(vringh_is_little_endian(vrh), val);
>  }
>  
>  static inline u64 vringh64_to_cpu(const struct vringh *vrh, __virtio64 val)
>  {
> -	return __virtio64_to_cpu(vrh->little_endian, val);
> +	return __virtio64_to_cpu(vringh_is_little_endian(vrh), val);
>  }
>  
>  static inline __virtio64 cpu_to_vringh64(const struct vringh *vrh, u64 val)
>  {
> -	return __cpu_to_virtio64(vrh->little_endian, val);
> +	return __cpu_to_virtio64(vringh_is_little_endian(vrh), val);
>  }
>  #endif /* _LINUX_VRINGH_H */

Reviewed-by: Thomas Huth <thuth@redhat.com>
