From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC 4/5] virtio_pci: modern driver
Date: Thu, 11 Dec 2014 21:37:37 +0200
Message-ID: <1418326570-9541-5-git-send-email-mst@redhat.com>
References: <1418326570-9541-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1418326570-9541-1-git-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

It compiles! Must be perfect.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci_common.h |  23 +-
 include/uapi/linux/virtio_pci.h    |  29 ++
 drivers/virtio/virtio_pci_modern.c | 560 +++++++++++++++++++++++++++++++++++++
 drivers/virtio/Makefile            |   2 +-
 4 files changed, 610 insertions(+), 4 deletions(-)
 create mode 100644 drivers/virtio/virtio_pci_modern.c

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 38d99ad..1567531 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -53,12 +53,29 @@ struct virtio_pci_device {
 	struct virtio_device vdev;
 	struct pci_dev *pci_dev;
 
+	/* In legacy mode, these two point to within ->legacy. */
+	/* Where to read and clear interrupt */
+	u8 __iomem *isr;
+
+	/* Modern only fields */
+	/* The IO mapping for the PCI config space (non-legacy mode) */
+	struct virtio_pci_common_cfg __iomem *common;
+	/* Device-specific data (non-legacy mode)  */
+	void __iomem *device;
+	/* Base of vq notifications (non-legacy mode). */
+	void __iomem *notify_base;
+
+	/* So we can sanity-check accesses. */
+	size_t notify_len;
+	size_t device_len;
+
+	/* Multiply queue_notify_off by this value. (non-legacy mode). */
+	u32 notify_offset_multiplier;
+
+	/* Legacy only field */
 	/* the IO mapping for the PCI config space */
 	void __iomem *ioaddr;
 
-	/* the IO mapping for ISR operation */
-	void __iomem *isr;
-
 	/* a list of queues so we can dispatch IRQs */
 	spinlock_t lock;
 	struct list_head virtqueues;
diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 8423764..601c66b 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -159,6 +159,35 @@ struct virtio_pci_common_cfg {
 	__le32 queue_used_hi;		/* read-write */
 };
 
+/* Macro versions of offsets for the Old Timers! */
+#define VIRTIO_PCI_CAP_VNDR		0
+#define VIRTIO_PCI_CAP_NEXT		1
+#define VIRTIO_PCI_CAP_LEN		2
+#define VIRTIO_PCI_CAP_TYPE_AND_BAR	3
+#define VIRTIO_PCI_CAP_OFFSET		4
+#define VIRTIO_PCI_CAP_LENGTH		8
+
+#define VIRTIO_PCI_NOTIFY_CAP_MULT	12
+
+#define VIRTIO_PCI_COMMON_DFSELECT	0
+#define VIRTIO_PCI_COMMON_DF		4
+#define VIRTIO_PCI_COMMON_GFSELECT	8
+#define VIRTIO_PCI_COMMON_GF		12
+#define VIRTIO_PCI_COMMON_MSIX		16
+#define VIRTIO_PCI_COMMON_NUMQ		18
+#define VIRTIO_PCI_COMMON_STATUS	20
+#define VIRTIO_PCI_COMMON_Q_SELECT	22
+#define VIRTIO_PCI_COMMON_Q_SIZE	24
+#define VIRTIO_PCI_COMMON_Q_MSIX	26
+#define VIRTIO_PCI_COMMON_Q_ENABLE	28
+#define VIRTIO_PCI_COMMON_Q_NOFF	30
+#define VIRTIO_PCI_COMMON_Q_DESCLO	32
+#define VIRTIO_PCI_COMMON_Q_DESCHI	36
+#define VIRTIO_PCI_COMMON_Q_AVAILLO	40
+#define VIRTIO_PCI_COMMON_Q_AVAILHI	44
+#define VIRTIO_PCI_COMMON_Q_USEDLO	48
+#define VIRTIO_PCI_COMMON_Q_USEDHI	52
+
 #endif /* VIRTIO_PCI_NO_MODERN */
 
 #endif
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
new file mode 100644
index 0000000..e6e65e1
--- /dev/null
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -0,0 +1,560 @@
+/*
+ * Virtio PCI driver - legacy device support
+ *
+ * This module allows virtio devices to be used over a virtual PCI device.
+ * This can be used with QEMU based VMMs like KVM or Xen.
+ *
+ * Copyright IBM Corp. 2007
+ * Copyright Red Hat, Inc. 2014
+ *
+ * Authors:
+ *  Anthony Liguori  <aliguori@us.ibm.com>
+ *  Rusty Russell <rusty@rustcorp.com.au>
+ *  Michael S. Tsirkin <mst@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+
+#define VIRTIO_PCI_NO_LEGACY
+#include "virtio_pci_common.h"
+
+/* Qumranet donated their vendor ID for devices 0x1000 thru 0x10FF. */
+static const struct pci_device_id virtio_pci_id_table[] = {
+	{ PCI_DEVICE(0x1af4, PCI_ANY_ID) },
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
+
+static void iowrite64_twopart(u64 val, __le32 __iomem *lo, __le32 __iomem *hi)
+{
+	iowrite32((u32)val, lo);
+	iowrite32(val >> 32, hi);
+}
+
+/* virtio config->get_features() implementation */
+static u64 vp_get_features(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	u64 features;
+
+	iowrite32(0, &vp_dev->common->device_feature_select);
+	features = ioread32(&vp_dev->common->device_feature);
+	iowrite32(1, &vp_dev->common->device_feature_select);
+	features |= ((u64)ioread32(&vp_dev->common->device_feature) << 32);
+
+	return features;
+}
+
+/* virtio config->finalize_features() implementation */
+static int vp_finalize_features(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+
+	/* Give virtio_ring a chance to accept features. */
+	vring_transport_features(vdev);
+
+	iowrite32(0, &vp_dev->common->guest_feature_select);
+	iowrite32((u32)vdev->features, &vp_dev->common->guest_feature);
+	iowrite32(1, &vp_dev->common->guest_feature_select);
+	iowrite32(vdev->features >> 32, &vp_dev->common->guest_feature);
+
+	return 0;
+}
+
+/* virtio config->get() implementation */
+static void vp_get(struct virtio_device *vdev, unsigned offset,
+		   void *buf, unsigned len)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	u8 b;
+	__le16 w;
+	__le32 l;
+
+	switch (len) {
+	case 1:
+		b = ioread8(vp_dev->device + offset);
+		memcpy(buf, &b, sizeof b);
+		break;
+	case 2:
+		w = cpu_to_le16(ioread16(vp_dev->device + offset));
+		memcpy(buf, &w, sizeof w);
+		break;
+	case 4:
+		l = cpu_to_le32(ioread32(vp_dev->device + offset));
+		memcpy(buf, &l, sizeof l);
+		break;
+	case 8:
+		l = cpu_to_le32(ioread32(vp_dev->device + offset));
+		memcpy(buf, &l, sizeof l);
+		l = cpu_to_le32(ioread32(vp_dev->device + offset + sizeof l));
+		memcpy(buf + sizeof l, &l, sizeof l);
+		break;
+	default:
+		BUG();
+	}
+}
+
+/* the config->set() implementation.  it's symmetric to the config->get()
+ * implementation */
+static void vp_set(struct virtio_device *vdev, unsigned offset,
+		   const void *buf, unsigned len)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	u8 b;
+	__le16 w;
+	__le32 l;
+
+	switch (len) {
+	case 1:
+		memcpy(&b, buf, sizeof b);
+		iowrite8(b, vp_dev->device + offset);
+		break;
+	case 2:
+		memcpy(&w, buf, sizeof w);
+		iowrite16(le16_to_cpu(w), vp_dev->device + offset);
+		break;
+	case 4:
+		memcpy(&l, buf, sizeof l);
+		iowrite32(le32_to_cpu(l), vp_dev->device + offset);
+		break;
+	case 8:
+		memcpy(&l, buf, sizeof l);
+		iowrite32(le32_to_cpu(l), vp_dev->device + offset);
+		memcpy(&l, buf + sizeof l, sizeof l);
+		iowrite32(le32_to_cpu(l), vp_dev->device + offset + sizeof l);
+		break;
+	default:
+		BUG();
+	}
+}
+
+/* config->{get,set}_status() implementations */
+static u8 vp_get_status(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	return ioread8(&vp_dev->common->device_status);
+}
+
+static void vp_set_status(struct virtio_device *vdev, u8 status)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	/* We should never be setting status to 0. */
+	BUG_ON(status == 0);
+	iowrite8(status, &vp_dev->common->device_status);
+}
+
+static void vp_reset(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	/* 0 status means a reset. */
+	iowrite8(0, &vp_dev->common->device_status);
+	/* Flush out the status write, and flush in device writes,
+	 * including MSI-X interrupts, if any. */
+	ioread8(&vp_dev->common->device_status);
+	/* Flush pending VQ/configuration callbacks. */
+	vp_synchronize_vectors(vdev);
+}
+
+static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
+{
+	/* Setup the vector used for configuration events */
+	iowrite16(vector, &vp_dev->common->msix_config);
+	/* Verify we had enough resources to assign the vector */
+	/* Will also flush the write out to device */
+	return ioread16(&vp_dev->common->msix_config);
+}
+
+static size_t vring_pci_size(u16 num)
+{
+	/* We only need a cacheline separation. */
+	return PAGE_ALIGN(vring_size(num, SMP_CACHE_BYTES));
+}
+
+static void *alloc_virtqueue_pages(int *num)
+{
+	void *pages;
+
+	/* TODO: allocate each queue chunk individually */
+	for (; *num && vring_pci_size(*num) > PAGE_SIZE; *num /= 2) {
+		pages = alloc_pages_exact(vring_pci_size(*num),
+					  GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN);
+		if (pages)
+			return pages;
+	}
+
+	if (!*num)
+		return NULL;
+
+	/* Try to get a single page. You are my only hope! */
+	return alloc_pages_exact(vring_pci_size(*num), GFP_KERNEL|__GFP_ZERO);
+}
+
+static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
+				  struct virtio_pci_vq_info *info,
+				  unsigned index,
+				  void (*callback)(struct virtqueue *vq),
+				  const char *name,
+				  u16 msix_vec)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = vp_dev->common;
+	struct virtqueue *vq;
+	u16 num, off;
+	int err;
+
+	if (index >= ioread16(&cfg->num_queues))
+		return ERR_PTR(-ENOENT);
+
+	/* Select the queue we're interested in */
+	iowrite16(index, &cfg->queue_select);
+
+	/* Check if queue is either not available or already active. */
+	num = ioread16(&cfg->queue_size);
+	if (!num || ioread8(&cfg->queue_enable))
+		return ERR_PTR(-ENOENT);
+
+	if (num & (num - 1)) {
+		dev_warn(&vp_dev->pci_dev->dev, "bad queue size %u", num);
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* get offset of notification word for this vq (shouldn't wrap) */
+	off = ioread16(&cfg->queue_notify_off);
+	if ((u64)off * vp_dev->notify_offset_multiplier + 2
+	    > vp_dev->notify_len) {
+		dev_warn(&vp_dev->pci_dev->dev,
+			 "bad notification offset %u (x %u) for queue %u > %zd",
+			 off, vp_dev->notify_offset_multiplier, 
+			 index, vp_dev->notify_len);
+		return ERR_PTR(-EINVAL);
+	}
+
+	info->num = num;
+	info->msix_vector = msix_vec;
+
+	info->queue = alloc_virtqueue_pages(&info->num);
+	if (info->queue == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	/* create the vring */
+	vq = vring_new_virtqueue(index, info->num,
+				 SMP_CACHE_BYTES, &vp_dev->vdev,
+				 true, info->queue, vp_notify, callback, name);
+	if (!vq) {
+		err = -ENOMEM;
+		goto out_activate_queue;
+	}
+
+	/* activate the queue */
+	iowrite16(num, &cfg->queue_size);
+	iowrite64_twopart(virt_to_phys(info->queue),
+			  &cfg->queue_desc_lo, &cfg->queue_desc_hi);
+	iowrite64_twopart(virt_to_phys(virtqueue_get_avail(vq)),
+			  &cfg->queue_avail_lo, &cfg->queue_avail_hi);
+	iowrite64_twopart(virt_to_phys(virtqueue_get_avail(vq)),
+			  &cfg->queue_used_lo, &cfg->queue_used_hi);
+
+
+	/* TODO: map each vq notification area individually */
+	vq->priv = (void __force *)vp_dev->notify_base +
+		off * vp_dev->notify_offset_multiplier;
+
+	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
+		iowrite16(msix_vec, &cfg->queue_msix_vector);
+		msix_vec = ioread16(&cfg->queue_msix_vector);
+		if (msix_vec == VIRTIO_MSI_NO_VECTOR) {
+			err = -EBUSY;
+			goto out_assign;
+		}
+	}
+
+	return vq;
+
+out_assign:
+	vring_del_virtqueue(vq);
+out_activate_queue:
+	free_pages_exact(info->queue, vring_pci_size(info->num));
+	return ERR_PTR(err);
+}
+
+static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned nvqs,
+			      struct virtqueue *vqs[],
+			      vq_callback_t *callbacks[],
+			      const char *names[])
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtqueue *vq;
+	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names);
+
+	if (rc)
+		return rc;
+
+	/* Select and activate all queues. Has to be done last: once we do
+	 * this, there's no way to go back except reset.
+	 */
+	list_for_each_entry(vq, &vdev->vqs, list) {
+		iowrite16(vq->index, &vp_dev->common->queue_select);
+		iowrite8(1, &vp_dev->common->queue_enable);
+	}
+
+	return 0;
+}
+
+static void del_vq(struct virtio_pci_vq_info *info)
+{
+	struct virtqueue *vq = info->vq;
+	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
+
+	iowrite16(vq->index, &vp_dev->common->queue_select);
+
+	if (vp_dev->msix_enabled) {
+		iowrite16(VIRTIO_MSI_NO_VECTOR,
+			  &vp_dev->common->queue_msix_vector);
+		/* Flush the write out to device */
+		ioread16(&vp_dev->common->queue_msix_vector);
+	}
+
+	vring_del_virtqueue(vq);
+
+	free_pages_exact(info->queue, vring_pci_size(info->num));
+}
+
+static const struct virtio_config_ops virtio_pci_config_ops = {
+	.get		= vp_get,
+	.set		= vp_set,
+	.get_status	= vp_get_status,
+	.set_status	= vp_set_status,
+	.reset		= vp_reset,
+	.find_vqs	= vp_modern_find_vqs,
+	.del_vqs	= vp_del_vqs,
+	.get_features	= vp_get_features,
+	.finalize_features = vp_finalize_features,
+	.bus_name	= vp_bus_name,
+	.set_vq_affinity = vp_set_vq_affinity,
+};
+
+/**
+ * virtio_pci_find_capability - walk capabilities to find device info.
+ * @dev: the pci device
+ * @cfg_type: the VIRTIO_PCI_CAP_* value we seek
+ * @ioresource_types: IORESOURCE_MEM and/or IORESOURCE_IO.
+ *
+ * Returns offset of the capability, or 0.
+ */
+static inline int virtio_pci_find_capability(struct pci_dev *dev, u8 cfg_type,
+					     u32 ioresource_types)
+{
+	int pos;
+
+	for (pos = pci_find_capability(dev, PCI_CAP_ID_VNDR);
+	     pos > 0;
+	     pos = pci_find_next_capability(dev, pos, PCI_CAP_ID_VNDR)) {
+		u8 type_and_bar, type, bar;
+		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
+							 type_and_bar),
+				     &type_and_bar);
+
+		type = (type_and_bar >> VIRTIO_PCI_CAP_TYPE_SHIFT) &
+			VIRTIO_PCI_CAP_TYPE_MASK;
+		bar = (type_and_bar >> VIRTIO_PCI_CAP_BAR_SHIFT) &
+			VIRTIO_PCI_CAP_BAR_MASK;
+
+		if (type == cfg_type) {
+			if (pci_resource_flags(dev, bar) & ioresource_types)
+				return pos;
+		}
+	}
+	return 0;
+}
+
+static void __iomem *map_capability(struct pci_dev *dev, int off, size_t minlen,
+				    size_t *len)
+{
+	u8 type_and_bar, bar;
+	u32 offset, length;
+	void __iomem *p;
+
+	pci_read_config_byte(dev, off + offsetof(struct virtio_pci_cap,
+						 type_and_bar),
+			     &type_and_bar);
+	pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, offset),
+			     &offset);
+	pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, length),
+			      &length);
+
+	if (length < minlen) {
+		dev_err(&dev->dev,
+			"virtio_pci: small capability len %u (%zu expected)\n",
+			length, minlen);
+		return NULL;
+	}
+
+	if (len)
+		*len = length;
+
+	bar = (type_and_bar >> VIRTIO_PCI_CAP_BAR_SHIFT) &
+		VIRTIO_PCI_CAP_BAR_MASK;
+
+	/* We want uncachable mapping, even if bar is cachable. */
+	p = pci_iomap_range(dev, bar, offset, length, PAGE_SIZE, true);
+	if (!p)
+		dev_err(&dev->dev,
+			"virtio_pci: unable to map virtio %u@%u on bar %i\n",
+			length, offset, bar);
+	return p;
+}
+
+/* the PCI probing function */
+static int virtio_pci_probe(struct pci_dev *pci_dev,
+			    const struct pci_device_id *id)
+{
+	struct virtio_pci_device *vp_dev;
+	int err, common, isr, notify, device;
+
+	/* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
+	if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
+		return -ENODEV;
+
+	/* allocate our structure and fill it out */
+	vp_dev = kzalloc(sizeof(struct virtio_pci_device), GFP_KERNEL);
+	if (vp_dev == NULL)
+		return -ENOMEM;
+
+	vp_dev->vdev.dev.parent = &pci_dev->dev;
+	vp_dev->vdev.dev.release = virtio_pci_release_dev;
+	vp_dev->vdev.config = &virtio_pci_config_ops;
+	vp_dev->pci_dev = pci_dev;
+	INIT_LIST_HEAD(&vp_dev->virtqueues);
+	spin_lock_init(&vp_dev->lock);
+
+	/* check for a common config: if not, use legacy mode (bar 0). */
+	common = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_COMMON_CFG,
+					    IORESOURCE_IO|IORESOURCE_MEM);
+	if (!common) {
+		dev_info(&pci_dev->dev,
+			 "virtio_pci: leaving for legacy driver\n");
+		return -ENODEV;
+	}
+
+	/* If common is there, these should be too... */
+	isr = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_ISR_CFG,
+					 IORESOURCE_IO|IORESOURCE_MEM);
+	notify = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_NOTIFY_CFG,
+					    IORESOURCE_IO|IORESOURCE_MEM);
+	device = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_DEVICE_CFG,
+					    IORESOURCE_IO|IORESOURCE_MEM);
+	if (!isr || !notify || !device) {
+		dev_err(&pci_dev->dev,
+			"virtio_pci: missing capabilities %i/%i/%i/%i\n",
+			common, isr, notify, device);
+		return -EINVAL;
+	}
+
+	/* Disable MSI/MSIX to bring device to a known good state. */
+	pci_msi_off(pci_dev);
+
+	/* enable the device */
+	err = pci_enable_device(pci_dev);
+	if (err)
+		goto out;
+
+	err = pci_request_regions(pci_dev, "virtio-pci");
+	if (err)
+		goto out_enable_device;
+
+	err = -EINVAL;
+	vp_dev->common = map_capability(pci_dev, common,
+					sizeof(struct virtio_pci_common_cfg),
+					NULL);
+	if (!vp_dev->common)
+		goto out_req_regions;
+	vp_dev->isr = map_capability(pci_dev, isr, sizeof(u8), NULL);
+	if (!vp_dev->isr)
+		goto out_map_common;
+
+	/* Read notify_off_multiplier from config space. */
+	pci_read_config_dword(pci_dev,
+			      notify + offsetof(struct virtio_pci_notify_cap,
+						notify_off_multiplier),
+			      &vp_dev->notify_offset_multiplier);
+	vp_dev->notify_base = map_capability(pci_dev, notify, sizeof(u8),
+					     &vp_dev->notify_len);
+	if (!vp_dev->notify_len)
+		goto out_map_isr;
+	vp_dev->device = map_capability(pci_dev, device, 0, &vp_dev->device_len);
+	if (!vp_dev->device)
+		goto out_map_notify;
+
+	pci_set_drvdata(pci_dev, vp_dev);
+	pci_set_master(pci_dev);
+
+	if (pci_dev->device < 0x1040) {
+		/* Transitional devices: use the PCI subsystem device id as
+		 * virtio device id, same as legacy driver always did.
+		 */
+		vp_dev->vdev.id.device = pci_dev->subsystem_device;
+	} else {
+		/* Modern devices: simply use PCI device id, but start from 0x1040. */
+		vp_dev->vdev.id.device = pci_dev->device - 0x1040;
+	}
+
+	vp_dev->vdev.id.vendor = pci_dev->subsystem_vendor;
+	vp_dev->config_vector = vp_config_vector;
+	vp_dev->setup_vq = setup_vq;
+	vp_dev->del_vq = del_vq;
+
+	/* finally register the virtio device */
+	err = register_virtio_device(&vp_dev->vdev);
+	if (err)
+		goto out_set_drvdata;
+
+	return 0;
+
+out_set_drvdata:
+	pci_set_drvdata(pci_dev, NULL);
+	pci_iounmap(pci_dev, vp_dev->device);
+out_map_notify:
+	pci_iounmap(pci_dev, vp_dev->notify_base);
+out_map_isr:
+	pci_iounmap(pci_dev, vp_dev->isr);
+out_map_common:
+	pci_iounmap(pci_dev, vp_dev->common);
+out_req_regions:
+	pci_release_regions(pci_dev);
+out_enable_device:
+	pci_disable_device(pci_dev);
+out:
+	kfree(vp_dev);
+	return err;
+}
+
+static void virtio_pci_remove(struct pci_dev *pci_dev)
+{
+	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
+
+	unregister_virtio_device(&vp_dev->vdev);
+
+	vp_del_vqs(&vp_dev->vdev);
+	pci_set_drvdata(pci_dev, NULL);
+	pci_iounmap(pci_dev, vp_dev->device);
+	pci_iounmap(pci_dev, vp_dev->notify_base);
+	pci_iounmap(pci_dev, vp_dev->isr);
+	pci_iounmap(pci_dev, vp_dev->common);
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
+	kfree(vp_dev);
+}
+
+static struct pci_driver virtio_pci_driver = {
+	.name		= "virtio-pci",
+	.id_table	= virtio_pci_id_table,
+	.probe		= virtio_pci_probe,
+	.remove		= virtio_pci_remove,
+#ifdef CONFIG_PM_SLEEP
+	.driver.pm	= &virtio_pci_pm_ops,
+#endif
+};
+
+module_pci_driver(virtio_pci_driver);
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index bf5104b..bd230d1 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_VIRTIO) += virtio.o virtio_ring.o
 obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
-virtio_pci-y := virtio_pci_legacy.o virtio_pci_common.o
+virtio_pci-y := virtio_pci_modern.o virtio_pci_legacy.o virtio_pci_common.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
-- 
MST
