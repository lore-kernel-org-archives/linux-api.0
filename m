From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC v3 01/16] virtio: memory access APIs
Date: Wed, 22 Oct 2014 21:44:08 +0300
Message-ID: <1414003404-505-2-git-send-email-mst@redhat.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1414003404-505-1-git-send-email-mst@redhat.com>
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
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>, Anup Patel <anup.patel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, virtualization@lists.linux-foundation.org, Geert Uytterhoeven <geert@linux-m68k.org>, Sakari Ailus <sakari.ailus@linux.intel.com>, linux-api@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?us-ascii?B?PT9VVEYtOD9xP1Bpb3RyPTIwS3I9QzM9QjNsPz0=?= <piotr.krol@3mdeb.com>, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

virtio 1.0 makes all memory structures LE, so
we need APIs to conditionally do a byteswap on BE
architectures.

To make it easier to check code statically,
add virtio specific types for multi-byte integers
in memory.

Add low level wrappers that do a byteswap conditionally, these will be
useful e.g. for vhost.  Add high level wrappers that will (in the
future) query device endian-ness and act accordingly.

At the moment, stub them out and assume native endian-ness everywhere.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_byteorder.h | 29 ++++++++++++++++++++++++
 include/linux/virtio_config.h    | 16 +++++++++++++
 include/uapi/linux/virtio_ring.h | 49 ++++++++++++++++++++--------------------
 include/uapi/linux/Kbuild        |  1 +
 4 files changed, 71 insertions(+), 24 deletions(-)
 create mode 100644 include/linux/virtio_byteorder.h

diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
new file mode 100644
index 0000000..7afdd8a
--- /dev/null
+++ b/include/linux/virtio_byteorder.h
@@ -0,0 +1,29 @@
+#ifndef _LINUX_VIRTIO_BYTEORDER_H
+#define _LINUX_VIRTIO_BYTEORDER_H
+#include <linux/types.h>
+#include <uapi/linux/virtio_types.h>
+
+/* Memory accessors for handling virtio in modern little endian and in
+ * compatibility big endian format. */
+
+#define __DEFINE_VIRTIO_XX_TO_CPU(bits) \
+static inline u##bits __virtio##bits##_to_cpu(bool little_endian, __virtio##bits val) \
+{ \
+	if (little_endian) \
+		return le##bits##_to_cpu((__force __le##bits)val); \
+	else \
+		return (__force u##bits)val; \
+} \
+static inline __virtio##bits __cpu_to_virtio##bits(bool little_endian, u##bits val) \
+{ \
+	if (little_endian) \
+		return (__force __virtio##bits)cpu_to_le##bits(val); \
+	else \
+		return val; \
+}
+
+__DEFINE_VIRTIO_XX_TO_CPU(16)
+__DEFINE_VIRTIO_XX_TO_CPU(32)
+__DEFINE_VIRTIO_XX_TO_CPU(64)
+
+#endif /* _LINUX_VIRTIO_BYTEORDER */
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 7f4ef66..d38d3c2 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -4,6 +4,7 @@
 #include <linux/err.h>
 #include <linux/bug.h>
 #include <linux/virtio.h>
+#include <linux/virtio_byteorder.h>
 #include <uapi/linux/virtio_config.h>
 
 /**
@@ -152,6 +153,21 @@ int virtqueue_set_affinity(struct virtqueue *vq, int cpu)
 	return 0;
 }
 
+/* Memory accessors */
+#define DEFINE_VIRTIO_XX_TO_CPU(bits) \
+static inline u##bits virtio##bits##_to_cpu(struct virtio_device *vdev, __virtio##bits val) \
+{ \
+	return __virtio##bits##_to_cpu(false, val); \
+} \
+static inline __virtio##bits cpu_to_virtio##bits(struct virtio_device *vdev, u##bits val) \
+{ \
+	return __cpu_to_virtio##bits(false, val); \
+}
+
+DEFINE_VIRTIO_XX_TO_CPU(16)
+DEFINE_VIRTIO_XX_TO_CPU(32)
+DEFINE_VIRTIO_XX_TO_CPU(64)
+
 /* Config space accessors. */
 #define virtio_cread(vdev, structname, member, ptr)			\
 	do {								\
diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
index a99f9b7..6c00632 100644
--- a/include/uapi/linux/virtio_ring.h
+++ b/include/uapi/linux/virtio_ring.h
@@ -32,6 +32,7 @@
  *
  * Copyright Rusty Russell IBM Corporation 2007. */
 #include <linux/types.h>
+#include <linux/virtio_types.h>
 
 /* This marks a buffer as continuing via the next field. */
 #define VRING_DESC_F_NEXT	1
@@ -61,32 +62,32 @@
 /* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
 struct vring_desc {
 	/* Address (guest-physical). */
-	__u64 addr;
+	__virtio64 addr;
 	/* Length. */
-	__u32 len;
+	__virtio32 len;
 	/* The flags as indicated above. */
-	__u16 flags;
+	__virtio16 flags;
 	/* We chain unused descriptors via this, too */
-	__u16 next;
+	__virtio16 next;
 };
 
 struct vring_avail {
-	__u16 flags;
-	__u16 idx;
-	__u16 ring[];
+	__virtio16 flags;
+	__virtio16 idx;
+	__virtio16 ring[];
 };
 
 /* u32 is used here for ids for padding reasons. */
 struct vring_used_elem {
 	/* Index of start of used descriptor chain. */
-	__u32 id;
+	__virtio32 id;
 	/* Total length of the descriptor chain which was used (written to) */
-	__u32 len;
+	__virtio32 len;
 };
 
 struct vring_used {
-	__u16 flags;
-	__u16 idx;
+	__virtio16 flags;
+	__virtio16 idx;
 	struct vring_used_elem ring[];
 };
 
@@ -109,25 +110,25 @@ struct vring {
  *	struct vring_desc desc[num];
  *
  *	// A ring of available descriptor heads with free-running index.
- *	__u16 avail_flags;
- *	__u16 avail_idx;
- *	__u16 available[num];
- *	__u16 used_event_idx;
+ *	__virtio16 avail_flags;
+ *	__virtio16 avail_idx;
+ *	__virtio16 available[num];
+ *	__virtio16 used_event_idx;
  *
  *	// Padding to the next align boundary.
  *	char pad[];
  *
  *	// A ring of used descriptor heads with free-running index.
- *	__u16 used_flags;
- *	__u16 used_idx;
+ *	__virtio16 used_flags;
+ *	__virtio16 used_idx;
  *	struct vring_used_elem used[num];
- *	__u16 avail_event_idx;
+ *	__virtio16 avail_event_idx;
  * };
  */
 /* We publish the used event index at the end of the available ring, and vice
  * versa. They are at the end for backwards compatibility. */
 #define vring_used_event(vr) ((vr)->avail->ring[(vr)->num])
-#define vring_avail_event(vr) (*(__u16 *)&(vr)->used->ring[(vr)->num])
+#define vring_avail_event(vr) (*(__virtio16 *)&(vr)->used->ring[(vr)->num])
 
 static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 			      unsigned long align)
@@ -135,29 +136,29 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 	vr->num = num;
 	vr->desc = p;
 	vr->avail = p + num*sizeof(struct vring_desc);
-	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + sizeof(__u16)
+	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + sizeof(__virtio16)
 		+ align-1) & ~(align - 1));
 }
 
 static inline unsigned vring_size(unsigned int num, unsigned long align)
 {
-	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (3 + num)
+	return ((sizeof(struct vring_desc) * num + sizeof(__virtio16) * (3 + num)
 		 + align - 1) & ~(align - 1))
-		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
+		+ sizeof(__virtio16) * 3 + sizeof(struct vring_used_elem) * num;
 }
 
 /* The following is used with USED_EVENT_IDX and AVAIL_EVENT_IDX */
 /* Assuming a given event_idx value from the other size, if
  * we have just incremented index from old to new_idx,
  * should we trigger an event? */
-static inline int vring_need_event(__u16 event_idx, __u16 new_idx, __u16 old)
+static inline int vring_need_event(__virtio16 event_idx, __virtio16 new_idx, __virtio16 old)
 {
 	/* Note: Xen has similar logic for notification hold-off
 	 * in include/xen/interface/io/ring.h with req_event and req_prod
 	 * corresponding to event_idx + 1 and new_idx respectively.
 	 * Note also that req_event and req_prod in Xen start at 1,
 	 * event indexes in virtio start at 0. */
-	return (__u16)(new_idx - event_idx - 1) < (__u16)(new_idx - old);
+	return (__virtio16)(new_idx - event_idx - 1) < (__virtio16)(new_idx - old);
 }
 
 #endif /* _UAPI_LINUX_VIRTIO_RING_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 6cad974..39c161a 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -419,6 +419,7 @@ header-y += virtio_blk.h
 header-y += virtio_config.h
 header-y += virtio_console.h
 header-y += virtio_ids.h
+header-y += virtio_types.h
 header-y += virtio_net.h
 header-y += virtio_pci.h
 header-y += virtio_ring.h
-- 
MST
