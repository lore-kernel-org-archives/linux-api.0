From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2] Add virtio-input driver.
Date: Sat, 21 Mar 2015 23:23:08 +0100
Message-ID: <20150321222308.GB17208@redhat.com>
References: <1426855170-10997-1-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1426855170-10997-1-git-send-email-kraxel@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, David Herrmann <dh.herrmann@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 20, 2015 at 01:39:29PM +0100, Gerd Hoffmann wrote:
> virtio-input is basically evdev-events-over-virtio, so this driver isn't
> much more than reading configuration from config space and forwarding
> incoming events to the linux input layer.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  MAINTAINERS                       |   6 +
>  drivers/virtio/Kconfig            |  10 ++
>  drivers/virtio/Makefile           |   1 +
>  drivers/virtio/virtio_input.c     | 335 ++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/Kbuild         |   1 +
>  include/uapi/linux/virtio_ids.h   |   1 +
>  include/uapi/linux/virtio_input.h |  75 +++++++++
>  7 files changed, 429 insertions(+)
>  create mode 100644 drivers/virtio/virtio_input.c
>  create mode 100644 include/uapi/linux/virtio_input.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0e1abe8..585e6cd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10435,6 +10435,12 @@ S:	Maintained
>  F:	drivers/vhost/
>  F:	include/uapi/linux/vhost.h
>  
> +VIRTIO INPUT DRIVER
> +M:	Gerd Hoffmann <kraxel@redhat.com>
> +S:	Maintained
> +F:	drivers/virtio/virtio_input.c
> +F:	include/uapi/linux/virtio_input.h
> +
>  VIA RHINE NETWORK DRIVER
>  M:	Roger Luethi <rl@hellgate.ch>
>  S:	Maintained
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index b546da5..cab9f3f 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -48,6 +48,16 @@ config VIRTIO_BALLOON
>  
>  	 If unsure, say M.
>  
> +config VIRTIO_INPUT
> +	tristate "Virtio input driver"
> +	depends on VIRTIO
> +	depends on INPUT
> +	---help---
> +	 This driver supports virtio input devices such as
> +	 keyboards, mice and tablets.
> +
> +	 If unsure, say M.
> +
>   config VIRTIO_MMIO
>  	tristate "Platform bus driver for memory mapped virtio devices"
>  	depends on HAS_IOMEM
> diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
> index d85565b..41e30e3 100644
> --- a/drivers/virtio/Makefile
> +++ b/drivers/virtio/Makefile
> @@ -4,3 +4,4 @@ obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
>  virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
>  virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
>  obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
> +obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
> diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
> new file mode 100644
> index 0000000..dd3215e
> --- /dev/null
> +++ b/drivers/virtio/virtio_input.c
> @@ -0,0 +1,335 @@
> +#include <linux/module.h>
> +#include <linux/virtio.h>
> +#include <linux/input.h>
> +
> +#include <uapi/linux/virtio_ids.h>
> +#include <uapi/linux/virtio_input.h>
> +
> +struct virtio_input {
> +	struct virtio_device       *vdev;
> +	struct input_dev           *idev;
> +	char                       name[64];
> +	char                       serial[64];
> +	char                       phys[64];
> +	struct virtqueue           *evt, *sts;
> +	struct virtio_input_event  evts[64];
> +	struct mutex               lock;
> +};
> +
> +static ssize_t serial_show(struct device *dev,
> +			   struct device_attribute *attr, char *buf)
> +{
> +	struct input_dev *idev = to_input_dev(dev);
> +	struct virtio_input *vi = input_get_drvdata(idev);
> +
> +	return sprintf(buf, "%s\n", vi->serial);
> +}
> +static DEVICE_ATTR_RO(serial);
> +
> +static struct attribute *dev_attrs[] = {
> +	&dev_attr_serial.attr,
> +	NULL
> +};
> +
> +static umode_t dev_attrs_are_visible(struct kobject *kobj,
> +				     struct attribute *a, int n)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct input_dev *idev = to_input_dev(dev);
> +	struct virtio_input *vi = input_get_drvdata(idev);
> +
> +	if (a == &dev_attr_serial.attr && !strlen(vi->serial))
> +		return 0;
> +
> +	return a->mode;
> +}
> +
> +static struct attribute_group dev_attr_grp = {
> +	.attrs =	dev_attrs,
> +	.is_visible =	dev_attrs_are_visible,
> +};
> +
> +static const struct attribute_group *dev_attr_groups[] = {
> +	&dev_attr_grp,
> +	NULL
> +};
> +
> +static void virtinput_queue_evtbuf(struct virtio_input *vi,
> +				   struct virtio_input_event *evtbuf)
> +{
> +	struct scatterlist sg[1];
> +
> +	sg_init_one(sg, evtbuf, sizeof(*evtbuf));
> +	virtqueue_add_inbuf(vi->evt, sg, 1, evtbuf, GFP_ATOMIC);
> +}
> +
> +static void virtinput_recv_events(struct virtqueue *vq)
> +{
> +	struct virtio_input *vi = vq->vdev->priv;
> +	struct virtio_input_event *event;
> +	unsigned int len;
> +
> +	mutex_lock(&vi->lock);
> +	while ((event = virtqueue_get_buf(vi->evt, &len)) != NULL) {
> +		input_event(vi->idev,
> +			    le16_to_cpu(event->type),
> +			    le16_to_cpu(event->code),
> +			    le32_to_cpu(event->value));
> +		virtinput_queue_evtbuf(vi, event);
> +	}
> +	virtqueue_kick(vq);
> +	mutex_unlock(&vi->lock);
> +}
> +
> +static int virtinput_send_status(struct virtio_input *vi,
> +				 u16 type, u16 code, s32 value)
> +{
> +	struct virtio_input_event *stsbuf;
> +	struct scatterlist sg[1];
> +	int rc;
> +
> +	stsbuf = kzalloc(sizeof(*stsbuf), GFP_ATOMIC);
> +	if (!stsbuf)
> +		return -ENOMEM;
> +
> +	stsbuf->type  = cpu_to_le16(type);
> +	stsbuf->code  = cpu_to_le16(code);
> +	stsbuf->value = cpu_to_le32(value);
> +	sg_init_one(sg, stsbuf, sizeof(*stsbuf));
> +
> +	mutex_lock(&vi->lock);
> +	rc = virtqueue_add_outbuf(vi->sts, sg, 1, stsbuf, GFP_ATOMIC);
> +	virtqueue_kick(vi->sts);
> +	mutex_unlock(&vi->lock);
> +
> +	if (rc != 0)
> +		kfree(stsbuf);
> +	return rc;
> +}
> +
> +static void virtinput_recv_status(struct virtqueue *vq)
> +{
> +	struct virtio_input *vi = vq->vdev->priv;
> +	struct virtio_input_event *stsbuf;
> +	unsigned int len;
> +
> +	mutex_lock(&vi->lock);
> +	while ((stsbuf = virtqueue_get_buf(vi->sts, &len)) != NULL)
> +		kfree(stsbuf);
> +	mutex_unlock(&vi->lock);
> +}
> +

You can't take a mutex in an interrupt callback.
since you do everything with GFP_ATOMIC, I would say
just switch lock to a spinlock.
You can virtqueue_kick if contention becomes a problem.

Sent more comments on v1.

-- 
MST
