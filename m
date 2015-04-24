From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: [PATCH v6 7/8] vhost: cross-endian support for legacy devices
Date: Fri, 24 Apr 2015 14:27:24 +0200
Message-ID: <20150424122632.19156.88058.stgit@bahia.local>
References: <20150424122211.19156.97626.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150424122211.19156.97626.stgit@bahia.local>
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
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
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

Changes since v5:
- fixed description in Kconfig
- fixed error description in uapi header
- dropped useless semi-colon in the vhost_vq_reset_user_be() stub

 drivers/vhost/Kconfig      |   15 ++++++++
 drivers/vhost/vhost.c      |   85 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h      |   11 +++++-
 include/uapi/linux/vhost.h |   14 +++++++
 4 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 017a1e8..533eaf0 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -32,3 +32,18 @@ config VHOST
 	---help---
 	  This option is selected by any driver which needs to access
 	  the core of vhost.
+
+config VHOST_CROSS_ENDIAN_LEGACY
+	bool "Cross-endian support for vhost"
+	default n
+	---help---
+	  This option allows vhost to support guests with a different byte
+	  ordering from host while using legacy virtio.
+
+	  Userspace programs can control the feature using the
+	  VHOST_SET_VRING_ENDIAN and VHOST_GET_VRING_ENDIAN ioctls.
+
+	  This is only useful on a few platforms (ppc64 and arm64). Since it
+	  adds some overhead, it is disabled by default.
+
+	  If unsure, say "N".
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 2ee2826..9e8e004 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -36,6 +36,77 @@ enum {
 #define vhost_used_event(vq) ((__virtio16 __user *)&vq->avail->ring[vq->num])
 #define vhost_avail_event(vq) ((__virtio16 __user *)&vq->used->ring[vq->num])
 
+#ifdef CONFIG_VHOST_CROSS_ENDIAN_LEGACY
+static void vhost_vq_reset_user_be(struct vhost_virtqueue *vq)
+{
+	vq->user_be = !virtio_legacy_is_little_endian();
+}
+
+static long vhost_set_vring_endian(struct vhost_virtqueue *vq, int __user *argp)
+{
+	struct vhost_vring_state s;
+
+	if (vq->private_data)
+		return -EBUSY;
+
+	if (copy_from_user(&s, argp, sizeof(s)))
+		return -EFAULT;
+
+	if (s.num != VHOST_VRING_LITTLE_ENDIAN &&
+	    s.num != VHOST_VRING_BIG_ENDIAN)
+		return -EINVAL;
+
+	vq->user_be = s.num;
+
+	return 0;
+}
+
+static long vhost_get_vring_endian(struct vhost_virtqueue *vq, u32 idx,
+				   int __user *argp)
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
+
+static void vhost_init_is_le(struct vhost_virtqueue *vq)
+{
+	/* Note for legacy virtio: user_be is initialized at reset time
+	 * according to the host endianness. If userspace does not set an
+	 * explicit endianness, the default behavior is native endian, as
+	 * expected by legacy virtio.
+	 */
+	vq->is_le = vhost_has_feature(vq, VIRTIO_F_VERSION_1) || !vq->user_be;
+}
+#else
+static void vhost_vq_reset_user_be(struct vhost_virtqueue *vq)
+{
+}
+
+static long vhost_set_vring_endian(struct vhost_virtqueue *vq, int __user *argp)
+{
+	return -ENOIOCTLCMD;
+}
+
+static long vhost_get_vring_endian(struct vhost_virtqueue *vq, u32 idx,
+				   int __user *argp)
+{
+	return -ENOIOCTLCMD;
+}
+
+static void vhost_init_is_le(struct vhost_virtqueue *vq)
+{
+	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
+		vq->is_le = true;
+}
+#endif /* CONFIG_VHOST_CROSS_ENDIAN_LEGACY */
+
 static void vhost_poll_func(struct file *file, wait_queue_head_t *wqh,
 			    poll_table *pt)
 {
@@ -199,6 +270,8 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->call = NULL;
 	vq->log_ctx = NULL;
 	vq->memory = NULL;
+	vq->is_le = virtio_legacy_is_little_endian();
+	vhost_vq_reset_user_be(vq);
 }
 
 static int vhost_worker(void *data)
@@ -806,6 +879,12 @@ long vhost_vring_ioctl(struct vhost_dev *d, int ioctl, void __user *argp)
 		} else
 			filep = eventfp;
 		break;
+	case VHOST_SET_VRING_ENDIAN:
+		r = vhost_set_vring_endian(vq, argp);
+		break;
+	case VHOST_GET_VRING_ENDIAN:
+		r = vhost_get_vring_endian(vq, idx, argp);
+		break;
 	default:
 		r = -ENOIOCTLCMD;
 	}
@@ -1044,8 +1123,12 @@ int vhost_init_used(struct vhost_virtqueue *vq)
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
index a4fa33a..ce6f6da 100644
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
+#ifdef CONFIG_VHOST_CROSS_ENDIAN_LEGACY
+	/* Ring endianness requested by userspace for cross-endian support. */
+	bool user_be;
+#endif
 };
 
 struct vhost_dev {
@@ -175,8 +183,7 @@ static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit)
 
 static inline bool vhost_is_little_endian(struct vhost_virtqueue *vq)
 {
-	return vhost_has_feature(vq, VIRTIO_F_VERSION_1) ||
-		virtio_legacy_is_little_endian();
+	return vq->is_le;
 }
 
 /* Memory accessors */
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index bb6a5b4..ab373191 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -103,6 +103,20 @@ struct vhost_memory {
 /* Get accessor: reads index, writes value in num */
 #define VHOST_GET_VRING_BASE _IOWR(VHOST_VIRTIO, 0x12, struct vhost_vring_state)
 
+/* Set the vring byte order in num. Valid values are VHOST_VRING_LITTLE_ENDIAN
+ * or VHOST_VRING_BIG_ENDIAN (other values return -EINVAL).
+ * The byte order cannot be changed while the device is active: trying to do so
+ * returns -EBUSY.
+ * This is a legacy only API that is simply ignored when VIRTIO_F_VERSION_1 is
+ * set.
+ * Not all kernel configurations support this ioctl, but all configurations that
+ * support SET also support GET.
+ */
+#define VHOST_VRING_LITTLE_ENDIAN 0
+#define VHOST_VRING_BIG_ENDIAN 1
+#define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
+#define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
+
 /* The following ioctls use eventfd file descriptors to signal and poll
  * for events. */
