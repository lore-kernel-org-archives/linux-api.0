From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] Add virtio-input driver.
Date: Fri, 20 Mar 2015 13:39:29 +0100
Message-ID: <1426855170-10997-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

virtio-input is basically evdev-events-over-virtio, so this driver isn't
much more than reading configuration from config space and forwarding
incoming events to the linux input layer.

Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 MAINTAINERS                       |   6 +
 drivers/virtio/Kconfig            |  10 ++
 drivers/virtio/Makefile           |   1 +
 drivers/virtio/virtio_input.c     | 335 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/Kbuild         |   1 +
 include/uapi/linux/virtio_ids.h   |   1 +
 include/uapi/linux/virtio_input.h |  75 +++++++++
 7 files changed, 429 insertions(+)
 create mode 100644 drivers/virtio/virtio_input.c
 create mode 100644 include/uapi/linux/virtio_input.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 0e1abe8..585e6cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10435,6 +10435,12 @@ S:	Maintained
 F:	drivers/vhost/
 F:	include/uapi/linux/vhost.h
 
+VIRTIO INPUT DRIVER
+M:	Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+S:	Maintained
+F:	drivers/virtio/virtio_input.c
+F:	include/uapi/linux/virtio_input.h
+
 VIA RHINE NETWORK DRIVER
 M:	Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>
 S:	Maintained
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index b546da5..cab9f3f 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -48,6 +48,16 @@ config VIRTIO_BALLOON
 
 	 If unsure, say M.
 
+config VIRTIO_INPUT
+	tristate "Virtio input driver"
+	depends on VIRTIO
+	depends on INPUT
+	---help---
+	 This driver supports virtio input devices such as
+	 keyboards, mice and tablets.
+
+	 If unsure, say M.
+
  config VIRTIO_MMIO
 	tristate "Platform bus driver for memory mapped virtio devices"
 	depends on HAS_IOMEM
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index d85565b..41e30e3 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
 virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
 virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
+obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
new file mode 100644
index 0000000..dd3215e
--- /dev/null
+++ b/drivers/virtio/virtio_input.c
@@ -0,0 +1,335 @@
+#include <linux/module.h>
+#include <linux/virtio.h>
+#include <linux/input.h>
+
+#include <uapi/linux/virtio_ids.h>
+#include <uapi/linux/virtio_input.h>
+
+struct virtio_input {
+	struct virtio_device       *vdev;
+	struct input_dev           *idev;
+	char                       name[64];
+	char                       serial[64];
+	char                       phys[64];
+	struct virtqueue           *evt, *sts;
+	struct virtio_input_event  evts[64];
+	struct mutex               lock;
+};
+
+static ssize_t serial_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct input_dev *idev = to_input_dev(dev);
+	struct virtio_input *vi = input_get_drvdata(idev);
+
+	return sprintf(buf, "%s\n", vi->serial);
+}
+static DEVICE_ATTR_RO(serial);
+
+static struct attribute *dev_attrs[] = {
+	&dev_attr_serial.attr,
+	NULL
+};
+
+static umode_t dev_attrs_are_visible(struct kobject *kobj,
+				     struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct input_dev *idev = to_input_dev(dev);
+	struct virtio_input *vi = input_get_drvdata(idev);
+
+	if (a == &dev_attr_serial.attr && !strlen(vi->serial))
+		return 0;
+
+	return a->mode;
+}
+
+static struct attribute_group dev_attr_grp = {
+	.attrs =	dev_attrs,
+	.is_visible =	dev_attrs_are_visible,
+};
+
+static const struct attribute_group *dev_attr_groups[] = {
+	&dev_attr_grp,
+	NULL
+};
+
+static void virtinput_queue_evtbuf(struct virtio_input *vi,
+				   struct virtio_input_event *evtbuf)
+{
+	struct scatterlist sg[1];
+
+	sg_init_one(sg, evtbuf, sizeof(*evtbuf));
+	virtqueue_add_inbuf(vi->evt, sg, 1, evtbuf, GFP_ATOMIC);
+}
+
+static void virtinput_recv_events(struct virtqueue *vq)
+{
+	struct virtio_input *vi = vq->vdev->priv;
+	struct virtio_input_event *event;
+	unsigned int len;
+
+	mutex_lock(&vi->lock);
+	while ((event = virtqueue_get_buf(vi->evt, &len)) != NULL) {
+		input_event(vi->idev,
+			    le16_to_cpu(event->type),
+			    le16_to_cpu(event->code),
+			    le32_to_cpu(event->value));
+		virtinput_queue_evtbuf(vi, event);
+	}
+	virtqueue_kick(vq);
+	mutex_unlock(&vi->lock);
+}
+
+static int virtinput_send_status(struct virtio_input *vi,
+				 u16 type, u16 code, s32 value)
+{
+	struct virtio_input_event *stsbuf;
+	struct scatterlist sg[1];
+	int rc;
+
+	stsbuf = kzalloc(sizeof(*stsbuf), GFP_ATOMIC);
+	if (!stsbuf)
+		return -ENOMEM;
+
+	stsbuf->type  = cpu_to_le16(type);
+	stsbuf->code  = cpu_to_le16(code);
+	stsbuf->value = cpu_to_le32(value);
+	sg_init_one(sg, stsbuf, sizeof(*stsbuf));
+
+	mutex_lock(&vi->lock);
+	rc = virtqueue_add_outbuf(vi->sts, sg, 1, stsbuf, GFP_ATOMIC);
+	virtqueue_kick(vi->sts);
+	mutex_unlock(&vi->lock);
+
+	if (rc != 0)
+		kfree(stsbuf);
+	return rc;
+}
+
+static void virtinput_recv_status(struct virtqueue *vq)
+{
+	struct virtio_input *vi = vq->vdev->priv;
+	struct virtio_input_event *stsbuf;
+	unsigned int len;
+
+	mutex_lock(&vi->lock);
+	while ((stsbuf = virtqueue_get_buf(vi->sts, &len)) != NULL)
+		kfree(stsbuf);
+	mutex_unlock(&vi->lock);
+}
+
+static int virtinput_status(struct input_dev *idev, unsigned int type,
+			    unsigned int code, int value)
+{
+	struct virtio_input *vi = input_get_drvdata(idev);
+
+	return virtinput_send_status(vi, type, code, value);
+}
+
+static size_t virtinput_cfg_select(struct virtio_input *vi,
+				   u8 select, u8 subsel)
+{
+	u8 size;
+
+	virtio_cwrite(vi->vdev, struct virtio_input_config, select, &select);
+	virtio_cwrite(vi->vdev, struct virtio_input_config, subsel, &subsel);
+	virtio_cread(vi->vdev, struct virtio_input_config, size, &size);
+	return size;
+}
+
+static void virtinput_cfg_bits(struct virtio_input *vi, int select, int subsel,
+			       unsigned long *bits, unsigned int bitcount)
+{
+	unsigned int bit;
+	size_t bytes;
+	u8 cfg = 0;
+
+	bytes = virtinput_cfg_select(vi, select, subsel);
+	if (!bytes)
+		return;
+	if (bitcount > bytes*8)
+		bitcount = bytes*8;
+	if (select == VIRTIO_INPUT_CFG_EV_BITS)
+		set_bit(subsel, vi->idev->evbit);
+	for (bit = 0; bit < bitcount; bit++) {
+		if ((bit % 8) == 0)
+			virtio_cread(vi->vdev, struct virtio_input_config,
+				     u.bitmap[bit / 8], &cfg);
+		if (cfg & (1 << (bit % 8)))
+			set_bit(bit, bits);
+	}
+}
+
+static void virtinput_cfg_abs(struct virtio_input *vi, int abs)
+{
+	u32 mi, ma, fu, fl;
+
+	virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ABS_INFO, abs);
+	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.min, &mi);
+	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.max, &ma);
+	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.fuzz, &fu);
+	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.flat, &fl);
+	input_set_abs_params(vi->idev, abs, mi, ma, fu, fl);
+}
+
+static int virtinput_init_vqs(struct virtio_input *vi)
+{
+	struct virtqueue *vqs[2];
+	vq_callback_t *cbs[] = { virtinput_recv_events,
+				 virtinput_recv_status };
+	static const char * names[] = { "events", "status" };
+	int i, err, size;
+
+	err = vi->vdev->config->find_vqs(vi->vdev, 2, vqs, cbs, names);
+	if (err)
+		return err;
+	vi->evt = vqs[0];
+	vi->sts = vqs[1];
+
+	size = virtqueue_get_vring_size(vi->evt);
+	if (size > ARRAY_SIZE(vi->evts))
+		size = ARRAY_SIZE(vi->evts);
+	for (i = 0; i < size; i++)
+		virtinput_queue_evtbuf(vi, &vi->evts[i]);
+	virtqueue_kick(vi->evt);
+
+	return 0;
+}
+
+static int virtinput_probe(struct virtio_device *vdev)
+{
+	struct virtio_input *vi;
+	size_t size;
+	int abs, err;
+
+	vi = kzalloc(sizeof(*vi), GFP_KERNEL);
+	if (!vi)
+		return -ENOMEM;
+
+	vdev->priv = vi;
+	vi->vdev = vdev;
+	mutex_init(&vi->lock);
+
+	err = virtinput_init_vqs(vi);
+	if (err)
+		goto err_init_vq;
+
+	vi->idev = input_allocate_device();
+	if (!vi->idev) {
+		err = -ENOMEM;
+		goto err_input_alloc;
+	}
+	input_set_drvdata(vi->idev, vi);
+
+	size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ID_NAME, 0);
+	virtio_cread_bytes(vi->vdev, offsetof(struct virtio_input_config, u),
+			   vi->name, min(size, sizeof(vi->name)));
+	size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ID_SERIAL, 0);
+	virtio_cread_bytes(vi->vdev, offsetof(struct virtio_input_config, u),
+			   vi->serial, min(size, sizeof(vi->serial)));
+	snprintf(vi->phys, sizeof(vi->phys),
+		 "virtio%d/input0", vdev->index);
+	vi->idev->name = vi->name;
+	vi->idev->phys = vi->phys;
+	vi->idev->uniq = vi->serial;
+
+	size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ID_DEVIDS, 0);
+	if (size >= 8) {
+		virtio_cread(vi->vdev, struct virtio_input_config,
+			     u.ids.bustype, &vi->idev->id.bustype);
+		virtio_cread(vi->vdev, struct virtio_input_config,
+			     u.ids.vendor, &vi->idev->id.vendor);
+		virtio_cread(vi->vdev, struct virtio_input_config,
+			     u.ids.product, &vi->idev->id.product);
+		virtio_cread(vi->vdev, struct virtio_input_config,
+			     u.ids.version, &vi->idev->id.version);
+	} else {
+		vi->idev->id.bustype = BUS_VIRTUAL;
+	}
+
+	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_PROP_BITS, 0,
+			   vi->idev->propbit, INPUT_PROP_CNT);
+	size = virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_REP);
+	if (size)
+		set_bit(EV_REP, vi->idev->evbit);
+
+	vi->idev->dev.parent = &vdev->dev;
+	vi->idev->dev.groups = dev_attr_groups;
+	vi->idev->event = virtinput_status;
+
+	/* device -> kernel */
+	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_KEY,
+			   vi->idev->keybit, KEY_CNT);
+	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_REL,
+			   vi->idev->relbit, REL_CNT);
+	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_ABS,
+			   vi->idev->absbit, ABS_CNT);
+	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_MSC,
+			   vi->idev->mscbit, MSC_CNT);
+	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_SW,
+			   vi->idev->swbit,  SW_CNT);
+
+	/* kernel -> device */
+	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_LED,
+			   vi->idev->ledbit, LED_CNT);
+	virtinput_cfg_bits(vi, VIRTIO_INPUT_CFG_EV_BITS, EV_SND,
+			   vi->idev->sndbit, SND_CNT);
+
+	if (test_bit(EV_ABS, vi->idev->evbit)) {
+		for (abs = 0; abs < ABS_CNT; abs++) {
+			if (!test_bit(abs, vi->idev->absbit))
+				continue;
+			virtinput_cfg_abs(vi, abs);
+		}
+	}
+	virtio_device_ready(vdev);
+
+	err = input_register_device(vi->idev);
+	if (err)
+		goto err_input_register;
+
+	return 0;
+
+err_input_register:
+	input_free_device(vi->idev);
+err_input_alloc:
+	vdev->config->del_vqs(vdev);
+err_init_vq:
+	kfree(vi);
+	return err;
+}
+
+static void virtinput_remove(struct virtio_device *vdev)
+{
+	struct virtio_input *vi = vdev->priv;
+
+	input_unregister_device(vi->idev);
+	input_free_device(vi->idev);
+	vdev->config->del_vqs(vdev);
+	kfree(vi);
+}
+
+static unsigned int features[] = {
+};
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_INPUT, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct virtio_driver virtio_input_driver = {
+	.driver.name         = KBUILD_MODNAME,
+	.driver.owner        = THIS_MODULE,
+	.feature_table       = features,
+	.feature_table_size  = ARRAY_SIZE(features),
+	.id_table            = id_table,
+	.probe               = virtinput_probe,
+	.remove              = virtinput_remove,
+};
+
+module_virtio_driver(virtio_input_driver);
+MODULE_DEVICE_TABLE(virtio, id_table);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Virtio input device driver");
+MODULE_AUTHOR("Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>");
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 68ceb97..04b829e 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -430,6 +430,7 @@ header-y += virtio_blk.h
 header-y += virtio_config.h
 header-y += virtio_console.h
 header-y += virtio_ids.h
+header-y += virtio_input.h
 header-y += virtio_net.h
 header-y += virtio_pci.h
 header-y += virtio_ring.h
diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
index 284fc3a..5f60aa4 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -39,5 +39,6 @@
 #define VIRTIO_ID_9P		9 /* 9p virtio console */
 #define VIRTIO_ID_RPROC_SERIAL 11 /* virtio remoteproc serial link */
 #define VIRTIO_ID_CAIF	       12 /* Virtio caif */
+#define VIRTIO_ID_INPUT        18 /* virtio input */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/include/uapi/linux/virtio_input.h b/include/uapi/linux/virtio_input.h
new file mode 100644
index 0000000..9302422
--- /dev/null
+++ b/include/uapi/linux/virtio_input.h
@@ -0,0 +1,75 @@
+#ifndef _LINUX_VIRTIO_INPUT_H
+#define _LINUX_VIRTIO_INPUT_H
+/* This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR
+ * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
+ * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+ * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
+ * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE. */
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+
+enum virtio_input_config_select {
+	VIRTIO_INPUT_CFG_UNSET      = 0x00,
+	VIRTIO_INPUT_CFG_ID_NAME    = 0x01,
+	VIRTIO_INPUT_CFG_ID_SERIAL  = 0x02,
+	VIRTIO_INPUT_CFG_ID_DEVIDS  = 0x03,
+	VIRTIO_INPUT_CFG_PROP_BITS  = 0x10,
+	VIRTIO_INPUT_CFG_EV_BITS    = 0x11,
+	VIRTIO_INPUT_CFG_ABS_INFO   = 0x12,
+};
+
+struct virtio_input_absinfo {
+	__u32  min;
+	__u32  max;
+	__u32  fuzz;
+	__u32  flat;
+};
+
+struct virtio_input_devids {
+	__u16  bustype;
+	__u16  vendor;
+	__u16  product;
+	__u16  version;
+};
+
+struct virtio_input_config {
+	__u8    select;
+	__u8    subsel;
+	__u8    size;
+	__u8    reserved;
+	union {
+		char string[128];
+		__u8 bitmap[128];
+		struct virtio_input_absinfo abs;
+		struct virtio_input_devids ids;
+	} u;
+};
+
+struct virtio_input_event {
+	__le16 type;
+	__le16 code;
+	__le32 value;
+};
+
+#endif /* _LINUX_VIRTIO_INPUT_H */
-- 
1.8.3.1
