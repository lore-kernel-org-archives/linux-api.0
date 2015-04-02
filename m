From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: [PATCH v2 6/7] virtio: add explicit big-endian support to memory
 accessors
Date: Thu, 02 Apr 2015 15:17:08 +0200
Message-ID: <20150402131708.24676.41784.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
References: <20150402131637.24676.60700.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150402131637.24676.60700.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

The current memory accessors logic is:
- little endian if little_endian
- native endian (i.e. no byteswap) if !little_endian

If we want to fully support cross-endian vhost, we also need to be
able to convert to big endian.

Instead of changing the little_endian argument to some 3-value enum, this
patch changes the logic to:
- little endian if little_endian
- big endian if !little_endian

The native endian case is handled by all users with a trivial helper. This
patch doesn't change any functionality, nor it does add overhead.

Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
---
 drivers/net/macvtap.c            |    4 +++-
 drivers/net/tun.c                |    4 +++-
 drivers/vhost/vhost.h            |    4 +++-
 include/linux/virtio_byteorder.h |   24 ++++++++++++++----------
 include/linux/virtio_config.h    |    4 +++-
 include/linux/vringh.h           |    4 +++-
 6 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index a2f2958..0a03a66 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -51,7 +51,9 @@ struct macvtap_queue {
 
 static inline bool macvtap_is_little_endian(struct macvtap_queue *q)
 {
-	return q->flags & MACVTAP_VNET_LE;
+	if (q->flags & MACVTAP_VNET_LE)
+		return true;
+	return virtio_legacy_is_little_endian();
 }
 
 static inline u16 macvtap16_to_cpu(struct macvtap_queue *q, __virtio16 val)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3c3d6c0..053f9b6 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -208,7 +208,9 @@ struct tun_struct {
 
 static inline bool tun_is_little_endian(struct tun_struct *tun)
 {
-	return tun->flags & TUN_VNET_LE;
+	if (tun->flags & TUN_VNET_LE)
+		return true;
+	return virtio_legacy_is_little_endian();
 }
 
 static inline u16 tun16_to_cpu(struct tun_struct *tun, __virtio16 val)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 6a49960..4e9a186 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -175,7 +175,9 @@ static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit)
 
 static inline bool vhost_is_little_endian(struct vhost_virtqueue *vq)
 {
-	return vhost_has_feature(vq, VIRTIO_F_VERSION_1);
+	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
+		return true;
+	return virtio_legacy_is_little_endian();
 }
 
 /* Memory accessors */
diff --git a/include/linux/virtio_byteorder.h b/include/linux/virtio_byteorder.h
index 51865d0..ce63a2c 100644
--- a/include/linux/virtio_byteorder.h
+++ b/include/linux/virtio_byteorder.h
@@ -3,17 +3,21 @@
 #include <linux/types.h>
 #include <uapi/linux/virtio_types.h>
 
-/*
- * Low-level memory accessors for handling virtio in modern little endian and in
- * compatibility native endian format.
- */
+static inline bool virtio_legacy_is_little_endian(void)
+{
+#ifdef __LITTLE_ENDIAN
+	return true;
+#else
+	return false;
+#endif
+}
 
 static inline u16 __virtio16_to_cpu(bool little_endian, __virtio16 val)
 {
 	if (little_endian)
 		return le16_to_cpu((__force __le16)val);
 	else
-		return (__force u16)val;
+		return be16_to_cpu((__force __be16)val);
 }
 
 static inline __virtio16 __cpu_to_virtio16(bool little_endian, u16 val)
@@ -21,7 +25,7 @@ static inline __virtio16 __cpu_to_virtio16(bool little_endian, u16 val)
 	if (little_endian)
 		return (__force __virtio16)cpu_to_le16(val);
 	else
-		return (__force __virtio16)val;
+		return (__force __virtio16)cpu_to_be16(val);
 }
 
 static inline u32 __virtio32_to_cpu(bool little_endian, __virtio32 val)
@@ -29,7 +33,7 @@ static inline u32 __virtio32_to_cpu(bool little_endian, __virtio32 val)
 	if (little_endian)
 		return le32_to_cpu((__force __le32)val);
 	else
-		return (__force u32)val;
+		return be32_to_cpu((__force __be32)val);
 }
 
 static inline __virtio32 __cpu_to_virtio32(bool little_endian, u32 val)
@@ -37,7 +41,7 @@ static inline __virtio32 __cpu_to_virtio32(bool little_endian, u32 val)
 	if (little_endian)
 		return (__force __virtio32)cpu_to_le32(val);
 	else
-		return (__force __virtio32)val;
+		return (__force __virtio32)cpu_to_be32(val);
 }
 
 static inline u64 __virtio64_to_cpu(bool little_endian, __virtio64 val)
@@ -45,7 +49,7 @@ static inline u64 __virtio64_to_cpu(bool little_endian, __virtio64 val)
 	if (little_endian)
 		return le64_to_cpu((__force __le64)val);
 	else
-		return (__force u64)val;
+		return be64_to_cpu((__force __be64)val);
 }
 
 static inline __virtio64 __cpu_to_virtio64(bool little_endian, u64 val)
@@ -53,7 +57,7 @@ static inline __virtio64 __cpu_to_virtio64(bool little_endian, u64 val)
 	if (little_endian)
 		return (__force __virtio64)cpu_to_le64(val);
 	else
-		return (__force __virtio64)val;
+		return (__force __virtio64)cpu_to_be64(val);
 }
 
 #endif /* _LINUX_VIRTIO_BYTEORDER */
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index bd1a582..36a6daa 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -207,7 +207,9 @@ int virtqueue_set_affinity(struct virtqueue *vq, int cpu)
 
 static inline bool virtio_is_little_endian(struct virtio_device *vdev)
 {
-	return virtio_has_feature(vdev, VIRTIO_F_VERSION_1);
+	if (virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
+		return true;
+	return virtio_legacy_is_little_endian();
 }
 
 /* Memory accessors */
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 3ed62ef..d786c2d 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -228,7 +228,9 @@ static inline void vringh_notify(struct vringh *vrh)
 
 static inline bool vringh_is_little_endian(const struct vringh *vrh)
 {
-	return vrh->little_endian;
+	if (vrh->little_endian)
+		return true;
+	return virtio_legacy_is_little_endian();
 }
 
 static inline u16 vringh16_to_cpu(const struct vringh *vrh, __virtio16 val)
