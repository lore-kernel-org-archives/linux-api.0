From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: [PATCH v5 1/8] virtio: introduce virtio_is_little_endian() helper
Date: Thu, 23 Apr 2015 17:26:20 +0200
Message-ID: <20150423152617.11795.13272.stgit@bahia.local>
References: <20150423152608.11795.4373.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150423152608.11795.4373.stgit@bahia.local>
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

Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
---
 include/linux/virtio_config.h |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index ca3ed78..bd1a582 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -205,35 +205,40 @@ int virtqueue_set_affinity(struct virtqueue *vq, int cpu)
 	return 0;
 }
 
+static inline bool virtio_is_little_endian(struct virtio_device *vdev)
+{
+	return virtio_has_feature(vdev, VIRTIO_F_VERSION_1);
+}
+
 /* Memory accessors */
 static inline u16 virtio16_to_cpu(struct virtio_device *vdev, __virtio16 val)
 {
-	return __virtio16_to_cpu(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+	return __virtio16_to_cpu(virtio_is_little_endian(vdev), val);
 }
 
 static inline __virtio16 cpu_to_virtio16(struct virtio_device *vdev, u16 val)
 {
-	return __cpu_to_virtio16(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+	return __cpu_to_virtio16(virtio_is_little_endian(vdev), val);
 }
 
 static inline u32 virtio32_to_cpu(struct virtio_device *vdev, __virtio32 val)
 {
-	return __virtio32_to_cpu(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+	return __virtio32_to_cpu(virtio_is_little_endian(vdev), val);
 }
 
 static inline __virtio32 cpu_to_virtio32(struct virtio_device *vdev, u32 val)
 {
-	return __cpu_to_virtio32(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+	return __cpu_to_virtio32(virtio_is_little_endian(vdev), val);
 }
 
 static inline u64 virtio64_to_cpu(struct virtio_device *vdev, __virtio64 val)
 {
-	return __virtio64_to_cpu(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+	return __virtio64_to_cpu(virtio_is_little_endian(vdev), val);
 }
 
 static inline __virtio64 cpu_to_virtio64(struct virtio_device *vdev, u64 val)
 {
-	return __cpu_to_virtio64(virtio_has_feature(vdev, VIRTIO_F_VERSION_1), val);
+	return __cpu_to_virtio64(virtio_is_little_endian(vdev), val);
 }
 
 /* Config space accessors. */
