From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: [PATCH v4 7/8] vhost: feature to set the vring endianness
Date: Fri, 10 Apr 2015 12:19:16 +0200
Message-ID: <20150410101627.31843.21710.stgit@bahia.local>
References: <20150410101500.31843.61248.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150410101500.31843.61248.stgit@bahia.local>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Rusty Russell <rusty@rustcorp.com.au>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

This patch brings cross-endian support to vhost when used to implement
legacy virtio devices. Since it is a relatively rare situation, the
feature availability is controlled by a kernel config option (not set
by default).

The vq->is_le boolean field is added to cache the endianness to be
used for ring accesses. It defaults to native endian, as expected
by legacy virtio devices. When the ring gets active, we force little
endian if the device is modern. When the ring is deactivated, we
revert to the native endian default.

If cross-endian was compiled in, a vq->user_be boolean field is added
so that userspace may request a specific endianness. This field is
used to override the default when activating the ring of a legacy
device. It has no effect on modern devices.

Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
---
 drivers/vhost/Kconfig      |   10 ++++++
 drivers/vhost/vhost.c      |   76 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h      |   12 +++++--
 include/uapi/linux/vhost.h |    9 +++++
 4 files changed, 103 insertions(+), 4 deletions(-)

Changes since v3:
- VHOST_SET_VRING_ENDIAN_LEGACY ioctl renamed to VHOST_SET_VRING_BIG_ENDIAN
- ioctl API is now: 0 for le, 1 for be, other values are EINVAL
- ioctl doesn't filter out modern devices
- ioctl stubs return ENOIOCTLCMD
- forbid endianness changes when vring is active
- logic now handled with vq->is_le and vq->user_be according to device
  start/stop as suggested by Michael

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 017a1e8..0aec88c 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -32,3 +32,13 @@ config VHOST
 	---help---
 	  This option is selected by any driver which needs to access
 	  the core of vhost.
+
+config VHOST_SET_ENDIAN_LEGACY
+	bool "Cross-endian support for host kernel accelerator"
+	default n
+	---help---
+	  This option allows vhost to support guests with a different byte
+	  ordering from host. It is disabled by default since it adds overhead
+	  and it is only needed by a few platforms (powerpc and arm).
+
+	  If unsure, say "N".
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 2ee2826..3eb756b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -199,6 +199,10 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->call = NULL;
 	vq->log_ctx = NULL;
 	vq->memory = NULL;
+	vq->is_le = virtio_legacy_is_little_endian();
+#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
+	vq->user_be = !vq->is_le;
+#endif
 }
 
 static int vhost_worker(void *data)
@@ -630,6 +634,53 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 	return 0;
 }
 
+#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
+static long vhost_set_vring_big_endian(struct vhost_virtqueue *vq,
+				       int __user *argp)
+{
+	struct vhost_vring_state s;
+
+	if (vq->private_data)
+		return -EBUSY;
+
+	if (copy_from_user(&s, argp, sizeof(s)))
+		return -EFAULT;
+
+	if (s.num && s.num != 1)
+		return -EINVAL;
+
+	vq->user_be = s.num;
+
+	return 0;
+}
+
+static long vhost_get_vring_big_endian(struct vhost_virtqueue *vq, u32 idx,
+				       int __user *argp)
+{
+	struct vhost_vring_state s = {
+		.index = idx,
+		.num = vq->user_be
+	};
+
+	if (copy_to_user(argp, &s, sizeof(s)))
+		return -EFAULT;
+
+	return 0;
+}
+#else
+static long vhost_set_vring_big_endian(struct vhost_virtqueue *vq,
+				       int __user *argp)
+{
+	return -ENOIOCTLCMD;
+}
+
+static long vhost_get_vring_big_endian(struct vhost_virtqueue *vq, u32 idx,
+				       int __user *argp)
+{
+	return -ENOIOCTLCMD;
+}
+#endif /* CONFIG_VHOST_SET_ENDIAN_LEGACY */
+
 long vhost_vring_ioctl(struct vhost_dev *d, int ioctl, void __user *argp)
 {
 	struct file *eventfp, *filep = NULL;
@@ -806,6 +857,12 @@ long vhost_vring_ioctl(struct vhost_dev *d, int ioctl, void __user *argp)
 		} else
 			filep = eventfp;
 		break;
+	case VHOST_SET_VRING_BIG_ENDIAN:
+		r = vhost_set_vring_big_endian(vq, argp);
+		break;
+	case VHOST_GET_VRING_BIG_ENDIAN:
+		r = vhost_get_vring_big_endian(vq, idx, argp);
+		break;
 	default:
 		r = -ENOIOCTLCMD;
 	}
@@ -1040,12 +1097,29 @@ static int vhost_update_avail_event(struct vhost_virtqueue *vq, u16 avail_event)
 	return 0;
 }
 
+#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
+static void vhost_init_is_le(struct vhost_virtqueue *vq)
+{
+	vq->is_le = vhost_has_feature(vq, VIRTIO_F_VERSION_1) || !vq->user_be;
+}
+#else
+static void vhost_init_is_le(struct vhost_virtqueue *vq)
+{
+	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
+		vq->is_le = true;
+}
+#endif
+
 int vhost_init_used(struct vhost_virtqueue *vq)
 {
 	__virtio16 last_used_idx;
 	int r;
-	if (!vq->private_data)
+	if (!vq->private_data) {
+		vq->is_le = virtio_legacy_is_little_endian();
 		return 0;
+	}
+
+	vhost_init_is_le(vq);
 
 	r = vhost_update_used_flags(vq);
 	if (r)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 4e9a186..04b2add 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -106,6 +106,14 @@ struct vhost_virtqueue {
 	/* Log write descriptors */
 	void __user *log_base;
 	struct vhost_log *log;
+
+	/* Ring endianness. Defaults to legacy native endianness.
+	 * Set to true when starting a modern virtio device. */
+	bool is_le;
+#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
+	/* Ring endianness requested by userspace for cross-endian support. */
+	bool user_be;
+#endif
 };
 
 struct vhost_dev {
@@ -175,9 +183,7 @@ static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit)
 
 static inline bool vhost_is_little_endian(struct vhost_virtqueue *vq)
 {
-	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
-		return true;
-	return virtio_legacy_is_little_endian();
+	return vq->is_le;
 }
 
 /* Memory accessors */
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index bb6a5b4..5cdebbc 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -103,6 +103,15 @@ struct vhost_memory {
 /* Get accessor: reads index, writes value in num */
 #define VHOST_GET_VRING_BASE _IOWR(VHOST_VIRTIO, 0x12, struct vhost_vring_state)
 
+/* Set the vring byte order in num. This is a legacy only API that is simply
+ * ignored when VIRTIO_F_VERSION_1 is set.
+ * 0 to set to little-endian
+ * 1 to set to big-endian
+ * other values return EINVAL.
+ */
+#define VHOST_SET_VRING_BIG_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
+#define VHOST_GET_VRING_BIG_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
