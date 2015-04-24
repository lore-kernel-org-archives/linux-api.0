From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v5 7/8] vhost: cross-endian support for legacy devices
Date: Fri, 24 Apr 2015 09:19:26 +0200
Message-ID: <20150424091926.1f5dee0b.cornelia.huck@de.ibm.com>
References: <20150423152608.11795.4373.stgit@bahia.local>
	<20150423152915.11795.13921.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150423152915.11795.13921.stgit@bahia.local>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Thu, 23 Apr 2015 17:29:42 +0200
Greg Kurz <gkurz@linux.vnet.ibm.com> wrote:

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
> Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
> ---
> 
> Changes since v4:
> - rewrote patch title to mention cross-endian
> - renamed config to VHOST_CROSS_ENDIAN_LEGACY
> - rewrote config description and help
> - moved ifdefery to top of vhost.c
> - added a detailed comment about the lifecycle of vq->user_be in
>   vhost_init_is_le()
> - renamed ioctls to VHOST_[GS]ET_VRING_ENDIAN
> - added LE/BE defines to the ioctl API
> - rewrote ioctl sanity check with the LE/BE defines
> - updated comment in <uapi/linux/vhost.h> to mention that the availibility
>   of both SET and GET ioctls depends on the kernel config
> 
>  drivers/vhost/Kconfig      |   15 ++++++++
>  drivers/vhost/vhost.c      |   86 +++++++++++++++++++++++++++++++++++++++++++-
>  drivers/vhost/vhost.h      |   10 +++++
>  include/uapi/linux/vhost.h |   12 ++++++
>  4 files changed, 121 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 017a1e8..74d7380 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -32,3 +32,18 @@ config VHOST
>  	---help---
>  	  This option is selected by any driver which needs to access
>  	  the core of vhost.
> +
> +config VHOST_CROSS_ENDIAN_LEGACY
> +	bool "Cross-endian support for vhost"
> +	default n
> +	---help---
> +	  This option allows vhost to support guests with a different byte
> +	  ordering from host.

"...while using legacy virtio."

Might help to explain the "LEGACY" in the config option ;)

> +
> +	  Userspace programs can control the feature using the
> +	  VHOST_SET_VRING_ENDIAN and VHOST_GET_VRING_ENDIAN ioctls.
> +
> +	  This is only useful on a few platforms (ppc64 and arm64). Since it
> +	  adds some overhead, it is disabled default.

s/default/by default/

> +
> +	  If unsure, say "N".
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 2ee2826..8c4390d 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -36,6 +36,78 @@ enum {
>  #define vhost_used_event(vq) ((__virtio16 __user *)&vq->avail->ring[vq->num])
>  #define vhost_avail_event(vq) ((__virtio16 __user *)&vq->used->ring[vq->num])
> 
> +#ifdef CONFIG_VHOST_CROSS_ENDIAN_LEGACY
> +static void vhost_vq_reset_user_be(struct vhost_virtqueue *vq)
> +{
> +	vq->user_be = !virtio_legacy_is_little_endian();
> +}
> +
> +static long vhost_set_vring_endian(struct vhost_virtqueue *vq, int __user *argp)
> +{
> +	struct vhost_vring_state s;
> +
> +	if (vq->private_data)
> +		return -EBUSY;
> +
> +	if (copy_from_user(&s, argp, sizeof(s)))
> +		return -EFAULT;
> +
> +	if (s.num != VHOST_VRING_LITTLE_ENDIAN &&
> +	    s.num != VHOST_VRING_BIG_ENDIAN)
> +		return -EINVAL;
> +
> +	vq->user_be = s.num;
> +
> +	return 0;
> +}
> +
> +static long vhost_get_vring_endian(struct vhost_virtqueue *vq, u32 idx,
> +				   int __user *argp)
> +{
> +	struct vhost_vring_state s = {
> +		.index = idx,
> +		.num = vq->user_be
> +	};
> +
> +	if (copy_to_user(argp, &s, sizeof(s)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static void vhost_init_is_le(struct vhost_virtqueue *vq)
> +{
> +	/* Note for legacy virtio: user_be is initialized at reset time
> +	 * according to the host endianness. If userspace does not set an
> +	 * explicit endianness, the default behavior is native endian, as
> +	 * expected by legacy virtio.
> +	 */
> +	vq->is_le = vhost_has_feature(vq, VIRTIO_F_VERSION_1) || !vq->user_be;
> +}
> +#else
> +static void vhost_vq_reset_user_be(struct vhost_virtqueue *vq)
> +{
> +	;

Just leave the function body empty?

> +}
> +
> +static long vhost_set_vring_endian(struct vhost_virtqueue *vq, int __user *argp)
> +{
> +	return -ENOIOCTLCMD;
> +}
> +
> +static long vhost_get_vring_endian(struct vhost_virtqueue *vq, u32 idx,
> +				   int __user *argp)
> +{
> +	return -ENOIOCTLCMD;
> +}
> +
> +static void vhost_init_is_le(struct vhost_virtqueue *vq)
> +{
> +	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
> +		vq->is_le = true;
> +}
> +#endif /* CONFIG_VHOST_CROSS_ENDIAN_LEGACY */
> +
>  static void vhost_poll_func(struct file *file, wait_queue_head_t *wqh,
>  			    poll_table *pt)
>  {
(...)
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index bb6a5b4..b980b53 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -103,6 +103,18 @@ struct vhost_memory {
>  /* Get accessor: reads index, writes value in num */
>  #define VHOST_GET_VRING_BASE _IOWR(VHOST_VIRTIO, 0x12, struct vhost_vring_state)
> 
> +/* Set the vring byte order in num. Valid values are VHOST_VRING_LITTLE_ENDIAN
> + * or VHOST_VRING_BIG_ENDIAN (other values return EINVAL).

-EINVAL?

Should you also mention when you return -EBUSY?

> + * This is a legacy only API that is simply ignored when VIRTIO_F_VERSION_1 is
> + * set.
> + * Not all kernel configurations support this ioctl, but all configurations that
> + * support SET also support GET.
> + */
> +#define VHOST_VRING_LITTLE_ENDIAN 0
> +#define VHOST_VRING_BIG_ENDIAN 1
> +#define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
> +#define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
> +
>  /* The following ioctls use eventfd file descriptors to signal and poll
>   * for events. */

Apart from style nitpicks, looks good.
