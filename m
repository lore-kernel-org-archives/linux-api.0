From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v4 05/42] virtio: memory access APIs
Date: Tue, 25 Nov 2014 18:42:38 +0100
Message-ID: <20141125184238.0a4436f8.cornelia.huck@de.ibm.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-6-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1416933600-21398-6-git-send-email-mst@redhat.com>
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
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>, rusty@au1.ibm.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, Geert Uytterhoeven <geert@linux-m68k.org>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, linux-api@vger.kernel.org, pbonzini@redhat.com, David Miller <davem@davemloft.net>, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

On Tue, 25 Nov 2014 18:41:42 +0200
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
> useful e.g. for vhost.  Add high level wrappers that
> query device endian-ness and act accordingly.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_byteorder.h  | 59 +++++++++++++++++++++++++++++++++++++++
>  include/linux/virtio_config.h     | 32 +++++++++++++++++++++
>  include/uapi/linux/virtio_ring.h  | 45 ++++++++++++++---------------
>  include/uapi/linux/virtio_types.h | 48 +++++++++++++++++++++++++++++++
>  include/uapi/linux/Kbuild         |  1 +
>  5 files changed, 163 insertions(+), 22 deletions(-)
>  create mode 100644 include/linux/virtio_byteorder.h
>  create mode 100644 include/uapi/linux/virtio_types.h
> 
> diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
> new file mode 100644
> index 0000000..824ed0b
> --- /dev/null
> +++ b/include/linux/virtio_byteorder.h
> @@ -0,0 +1,59 @@
> +#ifndef _LINUX_VIRTIO_BYTEORDER_H
> +#define _LINUX_VIRTIO_BYTEORDER_H
> +#include <linux/types.h>
> +#include <uapi/linux/virtio_types.h>
> +
> +/*
> + * Memory accessors for handling virtio in modern little endian and in

"Low-level memory accessors"?

> + * compatibility native endian format.
> + */
(...)
> diff --git a/include/uapi/linux/virtio_types.h b/include/uapi/linux/virtio_types.h
> new file mode 100644
> index 0000000..b90385f
> --- /dev/null
> +++ b/include/uapi/linux/virtio_types.h
> @@ -0,0 +1,48 @@
> +#ifndef _UAPI_LINUX_VIRTIO_TYPES_H
> +#define _UAPI_LINUX_VIRTIO_TYPES_H
> +/* An interface for efficient virtio implementation, currently for use by KVM
> + * and lguest, but hopefully others soon.  

You probably copied this from the existing virtio header, didn't you?

What about simply:

"Type definitions for virtio implementations."

(and then the remaining text)

> Do NOT change this since it will
> + * break existing servers and clients.
> + *
> + * This header is BSD licensed so anyone can use the definitions to implement
> + * compatible drivers/servers.
(...)
