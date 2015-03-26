From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4] Add virtio-input driver.
Date: Thu, 26 Mar 2015 09:46:44 +0100
Message-ID: <20150326092255-mutt-send-email-mst@redhat.com>
References: <1427198927-1745-1-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <virtio-dev-return-687-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <1427198927-1745-1-git-send-email-kraxel@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org, David Herrmann <dh.herrmann@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 24, 2015 at 01:08:46PM +0100, Gerd Hoffmann wrote:
> virtio-input is basically evdev-events-over-virtio, so this driver isn't
> much more than reading configuration from config space and forwarding
> incoming events to the linux input layer.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Looks good overallm though I think I still see a couple of minor issues.

> ---
>  MAINTAINERS                       |   6 +
>  drivers/virtio/Kconfig            |  10 ++
>  drivers/virtio/Makefile           |   1 +
>  drivers/virtio/virtio_input.c     | 363 ++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/Kbuild         |   1 +
>  include/uapi/linux/virtio_ids.h   |   1 +
>  include/uapi/linux/virtio_input.h |  76 ++++++++
>  7 files changed, 458 insertions(+)
>  create mode 100644 drivers/virtio/virtio_input.c
>  create mode 100644 include/uapi/linux/virtio_input.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 358eb01..6f233dd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10442,6 +10442,12 @@ S:	Maintained
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
> index 0000000..fc99a15
> --- /dev/null
> +++ b/drivers/virtio/virtio_input.c
> @@ -0,0 +1,363 @@
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
> +	spinlock_t                 lock;
> +	bool                       ready;
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
> +	unsigned long flags;
> +	unsigned int len;
> +
> +	spin_lock_irqsave(&vi->lock, flags);
> +	if (vi->ready) {
> +		while ((event = virtqueue_get_buf(vi->evt, &len)) != NULL) {
> +			input_event(vi->idev,
> +				    le16_to_cpu(event->type),
> +				    le16_to_cpu(event->code),
> +				    le32_to_cpu(event->value));
> +			virtinput_queue_evtbuf(vi, event);
> +		}
> +		virtqueue_kick(vq);
> +	}
> +	spin_unlock_irqrestore(&vi->lock, flags);
> +}
> +
> +static int virtinput_send_status(struct virtio_input *vi,
> +				 u16 type, u16 code, s32 value)
> +{
> +	struct virtio_input_event *stsbuf;
> +	struct scatterlist sg[1];
> +	unsigned long flags;
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
> +	spin_lock_irqsave(&vi->lock, flags);
> +	if (vi->ready) {
> +		rc = virtqueue_add_outbuf(vi->sts, sg, 1, stsbuf, GFP_ATOMIC);
> +		virtqueue_kick(vi->sts);
> +	} else {
> +		rc = -ENODEV;
> +	}
> +	spin_unlock_irqrestore(&vi->lock, flags);
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
> +	unsigned long flags;
> +	unsigned int len;
> +
> +	spin_lock_irqsave(&vi->lock, flags);
> +	while ((stsbuf = virtqueue_get_buf(vi->sts, &len)) != NULL)
> +		kfree(stsbuf);
> +	spin_unlock_irqrestore(&vi->lock, flags);
> +}
> +
> +static int virtinput_status(struct input_dev *idev, unsigned int type,
> +			    unsigned int code, int value)
> +{
> +	struct virtio_input *vi = input_get_drvdata(idev);
> +
> +	return virtinput_send_status(vi, type, code, value);
> +}
> +
> +static size_t virtinput_cfg_select(struct virtio_input *vi,
> +				   u8 select, u8 subsel)
> +{
> +	u8 size;
> +
> +	virtio_cwrite(vi->vdev, struct virtio_input_config, select, &select);
> +	virtio_cwrite(vi->vdev, struct virtio_input_config, subsel, &subsel);
> +	virtio_cread(vi->vdev, struct virtio_input_config, size, &size);
> +	return size;
> +}
> +
> +static void virtinput_cfg_bits(struct virtio_input *vi, int select, int subsel,
> +			       unsigned long *bits, unsigned int bitcount)
> +{
> +	unsigned int bit;
> +	size_t bytes;
> +	u8 *virtio_bits;
> +
> +	bytes = virtinput_cfg_select(vi, select, subsel);
> +	if (!bytes)
> +		return;
> +	if (bitcount > bytes * 8)
> +		bitcount = bytes * 8;
> +
> +	/*
> +	 * Bitmap in virtio config space is a simple stream of bytes,
> +	 * with the first byte carrying bits 0-7, second bits 8-15 and
> +	 * so on.
> +	 */
> +	virtio_bits = kzalloc(bytes, GFP_KERNEL);
> +	if (!virtio_bits)
> +		return;
> +	virtio_cread_bytes(vi->vdev, offsetof(struct virtio_input_config,
> +					      u.bitmap),
> +			   virtio_bits, bytes);
> +	for (bit = 0; bit < bitcount; bit++) {
> +		if (virtio_bits[bit / 8] & (1 << (bit % 8)))
> +			__set_bit(bit, bits);
> +	}
> +	kfree(virtio_bits);
> +
> +	if (select == VIRTIO_INPUT_CFG_EV_BITS)
> +		__set_bit(subsel, vi->idev->evbit);
> +}
> +
> +static void virtinput_cfg_abs(struct virtio_input *vi, int abs)
> +{
> +	u32 mi, ma, re, fu, fl;
> +
> +	virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ABS_INFO, abs);
> +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.min, &mi);
> +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.max, &ma);
> +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.res, &re);
> +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.fuzz, &fu);
> +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.flat, &fl);
> +	input_set_abs_params(vi->idev, abs, mi, ma, fu, fl);
> +	input_abs_set_res(vi->idev, abs, re);
> +}
> +
> +static int virtinput_init_vqs(struct virtio_input *vi)
> +{
> +	struct virtqueue *vqs[2];
> +	vq_callback_t *cbs[] = { virtinput_recv_events,
> +				 virtinput_recv_status };
> +	static const char *names[] = { "events", "status" };
> +	int err;
> +
> +	err = vi->vdev->config->find_vqs(vi->vdev, 2, vqs, cbs, names);
> +	if (err)
> +		return err;
> +	vi->evt = vqs[0];
> +	vi->sts = vqs[1];
> +
> +	return 0;
> +}
> +
> +static void virtinput_fill_evt(struct virtio_input *vi)
> +{
> +	unsigned long flags;
> +	int i, size;
> +
> +	spin_lock_irqsave(&vi->lock, flags);
> +	size = virtqueue_get_vring_size(vi->evt);
> +	if (size > ARRAY_SIZE(vi->evts))
> +		size = ARRAY_SIZE(vi->evts);
> +	for (i = 0; i < size; i++)
> +		virtinput_queue_evtbuf(vi, &vi->evts[i]);
> +	virtqueue_kick(vi->evt);
> +	spin_unlock_irqrestore(&vi->lock, flags);
> +}
> +
> +static int virtinput_probe(struct virtio_device *vdev)
> +{
> +	struct virtio_input *vi;
> +	size_t size;
> +	int abs, err;
> +
> +	if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> +		return -ENODEV;
> +
> +	vi = kzalloc(sizeof(*vi), GFP_KERNEL);
> +	if (!vi)
> +		return -ENOMEM;
> +
> +	vdev->priv = vi;
> +	vi->vdev = vdev;
> +	spin_lock_init(&vi->lock);
> +
> +	err = virtinput_init_vqs(vi);
> +	if (err)
> +		goto err_init_vq;
> +
> +	vi->idev = input_allocate_device();
> +	if (!vi->idev) {
> +		err = -ENOMEM;
> +		goto err_input_alloc;
> +	}
> +	input_set_drvdata(vi->idev, vi);
> +
> +	size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ID_NAME, 0);
> +	virtio_cread_bytes(vi->vdev, offsetof(struct virtio_input_config,
> +					      u.string),
> +			   vi->name, min(size, sizeof(vi->name)));
> +	size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ID_SERIAL, 0);
> +	virtio_cread_bytes(vi->vdev, offsetof(struct virtio_input_config,
> +					      u.string),
> +			   vi->serial, min(size, sizeof(vi->serial)));
> +	snprintf(vi->phys, sizeof(vi->phys),
> +		 "virtio%d/input0", vdev->index);
> +	vi->idev->name = vi->name;
> +	vi->idev->phys = vi->phys;
> +	vi->idev->uniq = vi->serial;
> +
> +	size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ID_DEVIDS, 0);
> +	if (size >= sizeof(struct virtio_input_devids)) {
> +		virtio_cread(vi->vdev, struct virtio_input_config,
> +			     u.ids.bustype, &vi->idev->id.bustype);
> +		virtio_cread(vi->vdev, struct virtio_input_config,
> +			     u.ids.vendor, &vi->idev->id.vendor);
> +		virtio_cread(vi->vdev, struct virtio_input_config,
> +			     u.ids.product, &vi->idev->id.product);
> +		virtio_cread(vi->vdev, struct virtio_input_config,
> +			     u.ids.version, &vi->idev->id.version);
> +	} else {
> +		vi->idev->id.bustype = BUS_VIRTUAL;
> +	}
> +
> +	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_PROP_BITS, 0,
> +			   vi->idev->propbit, INPUT_PROP_CNT);
> +	size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_REP);
> +	if (size)
> +		__set_bit(EV_REP, vi->idev->evbit);
> +
> +	vi->idev->dev.parent = &vdev->dev;
> +	vi->idev->event = virtinput_status;
> +
> +	/* device -> kernel */
> +	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_KEY,
> +			   vi->idev->keybit, KEY_CNT);
> +	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_REL,
> +			   vi->idev->relbit, REL_CNT);
> +	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_ABS,
> +			   vi->idev->absbit, ABS_CNT);
> +	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_MSC,
> +			   vi->idev->mscbit, MSC_CNT);
> +	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_SW,
> +			   vi->idev->swbit,  SW_CNT);
> +
> +	/* kernel -> device */
> +	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_LED,
> +			   vi->idev->ledbit, LED_CNT);
> +	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_SND,
> +			   vi->idev->sndbit, SND_CNT);
> +
> +	if (test_bit(EV_ABS, vi->idev->evbit)) {
> +		for (abs = 0; abs < ABS_CNT; abs++) {
> +			if (!test_bit(abs, vi->idev->absbit))
> +				continue;
> +			virtinput_cfg_abs(vi, abs);
> +		}
> +	}
> +	err = input_register_device(vi->idev);
> +	if (err)
> +		goto err_input_register;


vi->ready is false here so you might lose status updates.
Losing updates isn't too terrible, but seems easy to fix:


	virtio_device_ready(vdev);
	vi->ready = true;
	err = input_register_device(vi->idev);

...

err_input_register:
	vi->ready = false;

it's up to you whether to do this.


> +
> +	virtio_device_ready(vdev);
> +	vi->ready = true;
> +	virtinput_fill_evt(vi);
> +	return 0;
> +
> +err_input_register:
> +	input_free_device(vi->idev);
> +err_input_alloc:
> +	vdev->config->del_vqs(vdev);
> +err_init_vq:
> +	kfree(vi);
> +	return err;
> +}
> +
> +static void virtinput_remove(struct virtio_device *vdev)
> +{
> +	struct virtio_input *vi = vdev->priv;
> +
> +	vi->ready = false;

This one needs to be done under a lock, otherwise
we can't be sure no callbacks are running here.

> +	input_unregister_device(vi->idev);
> +	vdev->config->del_vqs(vdev);
> +	kfree(vi);
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int virtinput_freeze(struct virtio_device *vdev)
> +{
> +	struct virtio_input *vi = vdev->priv;
> +
> +	vi->ready = false;

Same here I think.

> +	vdev->config->del_vqs(vdev);
> +	return 0;
> +}
> +
> +static int virtinput_restore(struct virtio_device *vdev)
> +{
> +	struct virtio_input *vi = vdev->priv;
> +	int err;
> +
> +	err = virtinput_init_vqs(vi);
> +	if (err)
> +		return err;
> +
> +	virtio_device_ready(vdev);
> +	vi->ready = true;
> +	virtinput_fill_evt(vi);
> +	return 0;
> +}
> +#endif
> +
> +static unsigned int features[] = {
> +};


an emoty line won't hurt here.

> +static struct virtio_device_id id_table[] = {
> +	{ VIRTIO_ID_INPUT, VIRTIO_DEV_ANY_ID },
> +	{ 0 },
> +};
> +
> +static struct virtio_driver virtio_input_driver = {
> +	.driver.name         = KBUILD_MODNAME,
> +	.driver.owner        = THIS_MODULE,
> +	.feature_table       = features,
> +	.feature_table_size  = ARRAY_SIZE(features),
> +	.id_table            = id_table,
> +	.probe               = virtinput_probe,
> +	.remove              = virtinput_remove,
> +#ifdef CONFIG_PM_SLEEP
> +	.freeze	             = virtinput_freeze,
> +	.restore             = virtinput_restore,
> +#endif
> +};
> +
> +module_virtio_driver(virtio_input_driver);
> +MODULE_DEVICE_TABLE(virtio, id_table);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Virtio input device driver");
> +MODULE_AUTHOR("Gerd Hoffmann <kraxel@redhat.com>");
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index 68ceb97..04b829e 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -430,6 +430,7 @@ header-y += virtio_blk.h
>  header-y += virtio_config.h
>  header-y += virtio_console.h
>  header-y += virtio_ids.h
> +header-y += virtio_input.h
>  header-y += virtio_net.h
>  header-y += virtio_pci.h
>  header-y += virtio_ring.h
> diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
> index 284fc3a..5f60aa4 100644
> --- a/include/uapi/linux/virtio_ids.h
> +++ b/include/uapi/linux/virtio_ids.h
> @@ -39,5 +39,6 @@
>  #define VIRTIO_ID_9P		9 /* 9p virtio console */
>  #define VIRTIO_ID_RPROC_SERIAL 11 /* virtio remoteproc serial link */
>  #define VIRTIO_ID_CAIF	       12 /* Virtio caif */
> +#define VIRTIO_ID_INPUT        18 /* virtio input */
>  
>  #endif /* _LINUX_VIRTIO_IDS_H */
> diff --git a/include/uapi/linux/virtio_input.h b/include/uapi/linux/virtio_input.h
> new file mode 100644
> index 0000000..dc61b28
> --- /dev/null
> +++ b/include/uapi/linux/virtio_input.h
> @@ -0,0 +1,76 @@
> +#ifndef _LINUX_VIRTIO_INPUT_H
> +#define _LINUX_VIRTIO_INPUT_H
> +/* This header is BSD licensed so anyone can use the definitions to implement
> + * compatible drivers/servers.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + * 2. Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in the
> + *    documentation and/or other materials provided with the distribution.
> + * 3. Neither the name of IBM nor the names of its contributors
> + *    may be used to endorse or promote products derived from this software
> + *    without specific prior written permission.
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> + * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR
> + * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
> + * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
> + * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
> + * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> + * SUCH DAMAGE. */

You must include linux/types.h for __le types I think.

> +#include <linux/virtio_ids.h>

This one is there in all other headers, so ok,
though I don't know why.

> +#include <linux/virtio_config.h>

I'm sure you don't need this one.

> +
> +enum virtio_input_config_select {
> +	VIRTIO_INPUT_CFG_UNSET      = 0x00,
> +	VIRTIO_INPUT_CFG_ID_NAME    = 0x01,
> +	VIRTIO_INPUT_CFG_ID_SERIAL  = 0x02,
> +	VIRTIO_INPUT_CFG_ID_DEVIDS  = 0x03,
> +	VIRTIO_INPUT_CFG_PROP_BITS  = 0x10,
> +	VIRTIO_INPUT_CFG_EV_BITS    = 0x11,
> +	VIRTIO_INPUT_CFG_ABS_INFO   = 0x12,
> +};
> +
> +struct virtio_input_absinfo {
> +	__u32 min;
> +	__u32 max;
> +	__u32 fuzz;
> +	__u32 flat;
> +	__u32 res;
> +};
> +
> +struct virtio_input_devids {
> +	__u16 bustype;
> +	__u16 vendor;
> +	__u16 product;
> +	__u16 version;
> +};
> +
> +struct virtio_input_config {
> +	__u8    select;
> +	__u8    subsel;
> +	__u8    size;
> +	__u8    reserved;


Thinking more about it, might it be better to make
this reserved[5] so the union is 8 byte aligned?
Will be helpful if you later want a 64 bit field in the union.

> +	union {
> +		char string[128];
> +		__u8 bitmap[128];
> +		struct virtio_input_absinfo abs;
> +		struct virtio_input_devids ids;
> +	} u;
> +};
> +
> +struct virtio_input_event {
> +	__le16 type;
> +	__le16 code;
> +	__le32 value;
> +};
> +
> +#endif /* _LINUX_VIRTIO_INPUT_H */
> -- 
> 1.8.3.1
