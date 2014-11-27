From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v5 07/45] virtio: memory access APIs
Date: Thu, 27 Nov 2014 14:30:39 +0200
Message-ID: <1417091078-24611-8-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1417091078-24611-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com, thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexei Starovoitov <ast@plumgrid.com>, stephen hemminger <stephen@networkplumber.org>, =?us-ascii?B?PT9VVEYtOD9xP1Bpb3RyPTIwS3I9QzM9QjNsPz0=?= <piotr.krol@3mdeb.com>, Anup Patel <anup.patel@linaro.org>, Bjarke Istrup Pedersen <gurligebis@gentoo.org>, virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

virtio 1.0 makes all memory structures LE, so
we need APIs to conditionally do a byteswap on BE
architectures.

To make it easier to check code statically,
add virtio specific types for multi-byte integers
in memory.

Add low level wrappers that do a byteswap conditionally, these will be
useful e.g. for vhost.  Add high level wrappers that
query device endian-ness and act accordingly.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_byteorder.h  | 59 +++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_config.h     | 32 +++++++++++++++++++++
 include/uapi/linux/virtio_ring.h  | 45 ++++++++++++++---------------
 include/uapi/linux/virtio_types.h | 46 ++++++++++++++++++++++++++++++
 include/uapi/linux/Kbuild         |  1 +
 5 files changed, 161 insertions(+), 22 deletions(-)
 create mode 100644 include/linux/virtio_byteorder.h
 create mode 100644 include/uapi/linux/virtio_types.h

diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
new file mode 100644
index 0000000..51865d0
--- /dev/null
+++ b/include/linux/virtio_byteorder.h
@@ -0,0 +1,59 @@
+#ifndef _LINUX_VIRTIO_BYTEORDER_H
+#define _LINUX_VIRTIO_BYTEORDER_H
+#include <linux/types.h>
+#include <uapi/linux/virtio_types.h>
+
+/*
+ * Low-level memory accessors for handling virtio in modern little endian and in
+ * compatibility native endian format.
+ */
+
+static inline u16 __virtio16_to_cpu(bool little_endian, __virtio16 val)
+{
+	if (little_endian)
+		return le16_to_cpu((__force __le16)val);
+	else
+		return (__force u16)val;
+}
+
+static inline __virtio16 __cpu_to_virtio16(bool little_endian, u16 val)
+{
+	if (little_endian)
+		return (__force __virtio16)cpu_to_le16(val);
+	else
+		return (__force __virtio16)val;
+}
+
+static inline u32 __virtio32_to_cpu(bool little_endian, __virtio32 val)
+{
+	if (little_endian)
+		return le32_to_cpu((__force __le32)val);
+	else
+		return (__force u32)val;
+}
+
+static inline __virtio32 __cpu_to_virtio32(bool little_endian, u32 val)
+{
+	if (little_endian)
+		return (__force __virtio32)cpu_to_le32(val);
+	else
+		return (__force __virtio32)val;
+}
+
+static inline u64 __virtio64_to_cpu(bool little_endian, __virtio64 val)
+{
+	if (little_endian)
+		return le64_to_cpu((__force __le64)val);
+	else
+		return (__force u64)val;
+}
+
+static inline __virtio64 __cpu_to_virtio64(bool little_endian, u64 val)
+{
+	if (little_endian)
+		return (__force __virtio64)cpu_to_le64(val);
+	else
+		return (__force __virtio64)val;
+}
+
+#endif /* _LINUX_VIRTIO_BYTEORDER */
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 022d904..b9cd689 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -4,6 +4,7 @@
 #include <linux/err.h>
 #include <linux/bug.h>
 #include <linux/virtio.h>
+#include <linux/virtio_byteorder.h>
 #include <uapi/linux/virtio_config.h>
 
 /**
@@ -152,6 +153,37 @@ int virtqueue_set_affinity(struct virtqueue *vq, int cpu)
 	return 0;
 }
 
+/* Memory accessors */
+static inline u16 virtio16_to_cpu(struct virtio_device *vdev, __virtio16 val)
+{
+	return __virtio16_to_cpu(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+}
+
+static inline __virtio16 cpu_to_virtio16(struct virtio_device *vdev, u16 val)
+{
+	return __cpu_to_virtio16(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+}
+
+static inline u32 virtio32_to_cpu(struct virtio_device *vdev, __virtio32 val)
+{
+	return __virtio32_to_cpu(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+}
+
+static inline __virtio32 cpu_to_virtio32(struct virtio_device *vdev, u32 val)
+{
+	return __cpu_to_virtio32(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+}
+
+static inline u64 virtio64_to_cpu(struct virtio_device *vdev, __virtio64 val)
+{
+	return __virtio64_to_cpu(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+}
+
+static inline __virtio64 cpu_to_virtio64(struct virtio_device *vdev, u64 val)
+{
+	return __cpu_to_virtio64(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+}
+
 /* Config space accessors. */
 #define virtio_cread(vdev, structname, member, ptr)			\
 	do {								\
diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
index a99f9b7..61c818a 100644
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
@@ -135,15 +136,15 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
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
diff --git a/include/uapi/linux/virtio_types.h b/include/uapi/linux/virtio_types.h
new file mode 100644
index 0000000..e845e8c
--- /dev/null
+++ b/include/uapi/linux/virtio_types.h
@@ -0,0 +1,46 @@
+#ifndef _UAPI_LINUX_VIRTIO_TYPES_H
+#define _UAPI_LINUX_VIRTIO_TYPES_H
+/* Type definitions for virtio implementations.
+ *
+ * This header is BSD licensed so anyone can use the definitions to implement
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
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ *
+ * Copyright (C) 2014 Red Hat, Inc.
+ * Author: Michael S. Tsirkin <mst@redhat.com>
+ */
+#include <linux/types.h>
+
+/*
+ * __virtio{16,32,64} have the following meaning:
+ * - __u{16,32,64} for virtio devices in legacy mode, accessed in native endian
+ * - __le{16,32,64} for standard-compliant virtio devices
+ */
+
+typedef __u16 __bitwise__ __virtio16;
+typedef __u32 __bitwise__ __virtio32;
+typedef __u64 __bitwise__ __virtio64;
+
+#endif /* _UAPI_LINUX_VIRTIO_TYPES_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 4c94f31..44a5581 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -423,6 +423,7 @@ header-y += virtio_blk.h
 header-y += virtio_config.h
 header-y += virtio_console.h
 header-y += virtio_ids.h
+header-y += virtio_types.h
 header-y += virtio_net.h
 header-y += virtio_pci.h
 header-y += virtio_ring.h
-- 
MST
