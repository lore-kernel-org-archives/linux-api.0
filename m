From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH RFC v3 01/16] virtio: memory access APIs
Date: Thu, 23 Oct 2014 09:54:05 +0200
Message-ID: <20141023095405.6bdd5a1a.cornelia.huck@de.ibm.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
	<1414003404-505-2-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1414003404-505-2-git-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>, Anup Patel <anup.patel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, Geert Uytterhoeven <geert@linux-m68k.org>, Sakari Ailus <sakari.ailus@linux.intel.com>, linux-api@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?q?Piotr=20Kr=C3=B3l?= <piotr.krol@3mdeb.com>, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

On Wed, 22 Oct 2014 21:44:08 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> virtio 1.0 makes all memory structures LE, so
> we need APIs to conditionally do a byteswap on BE
> architectures.
> 
> To make it easier to check code statically,
> add virtio specific types for multi-byte integers
> in memory.
> 
> Add low level wrappers that do a byteswap conditionally, these will be
> useful e.g. for vhost.  Add high level wrappers that will (in the
> future) query device endian-ness and act accordingly.
> 
> At the moment, stub them out and assume native endian-ness everywhere.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_byteorder.h | 29 ++++++++++++++++++++++++
>  include/linux/virtio_config.h    | 16 +++++++++++++
>  include/uapi/linux/virtio_ring.h | 49 ++++++++++++++++++++--------------------
>  include/uapi/linux/Kbuild        |  1 +
>  4 files changed, 71 insertions(+), 24 deletions(-)
>  create mode 100644 include/linux/virtio_byteorder.h
> 
> diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
> new file mode 100644
> index 0000000..7afdd8a
> --- /dev/null
> +++ b/include/linux/virtio_byteorder.h
> @@ -0,0 +1,29 @@
> +#ifndef _LINUX_VIRTIO_BYTEORDER_H
> +#define _LINUX_VIRTIO_BYTEORDER_H
> +#include <linux/types.h>
> +#include <uapi/linux/virtio_types.h>
> +
> +/* Memory accessors for handling virtio in modern little endian and in
> + * compatibility big endian format. */

s/big/native/

> +
> +#define __DEFINE_VIRTIO_XX_TO_CPU(bits) \
> +static inline u##bits __virtio##bits##_to_cpu(bool little_endian, __virtio##bits val) \
> +{ \
> +	if (little_endian) \
> +		return le##bits##_to_cpu((__force __le##bits)val); \
> +	else \
> +		return (__force u##bits)val; \
> +} \
> +static inline __virtio##bits __cpu_to_virtio##bits(bool little_endian, u##bits val) \
> +{ \
> +	if (little_endian) \
> +		return (__force __virtio##bits)cpu_to_le##bits(val); \
> +	else \
> +		return val; \
> +}
> +
> +__DEFINE_VIRTIO_XX_TO_CPU(16)
> +__DEFINE_VIRTIO_XX_TO_CPU(32)
> +__DEFINE_VIRTIO_XX_TO_CPU(64)

...although I'm still not too happy with macro-generated helpers.

> +
> +#endif /* _LINUX_VIRTIO_BYTEORDER */

> diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
> index a99f9b7..6c00632 100644
> --- a/include/uapi/linux/virtio_ring.h
> +++ b/include/uapi/linux/virtio_ring.h

> @@ -61,32 +62,32 @@
>  /* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
>  struct vring_desc {
>  	/* Address (guest-physical). */
> -	__u64 addr;
> +	__virtio64 addr;
>  	/* Length. */
> -	__u32 len;
> +	__virtio32 len;
>  	/* The flags as indicated above. */
> -	__u16 flags;
> +	__virtio16 flags;
>  	/* We chain unused descriptors via this, too */
> -	__u16 next;
> +	__virtio16 next;
>  };

I think all of these __virtio types need an explanation somewhere as to
what they mean, e.g.:

/*
 * __virtio{16,32,64} have the following meaning:
 * - __u{16,32,64} for virtio devices in legacy mode,
 *   accessed in native endian
 * - __le{16,32,64} for standard-compliant virtio devices
 */
