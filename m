From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: [PATCH v3 5/7] vhost: introduce vhost_is_little_endian() helper
Date: Tue, 07 Apr 2015 14:15:28 +0200
Message-ID: <20150407121524.4213.72480.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
References: <20150407120929.4213.8225.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150407120929.4213.8225.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
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
 drivers/vhost/vhost.h |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 8c1c792..6a49960 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -173,34 +173,39 @@ static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit)
 	return vq->acked_features & (1ULL << bit);
 }
 
+static inline bool vhost_is_little_endian(struct vhost_virtqueue *vq)
+{
+	return vhost_has_feature(vq, VIRTIO_F_VERSION_1);
+}
+
 /* Memory accessors */
 static inline u16 vhost16_to_cpu(struct vhost_virtqueue *vq, __virtio16 val)
 {
-	return __virtio16_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+	return __virtio16_to_cpu(vhost_is_little_endian(vq), val);
 }
 
 static inline __virtio16 cpu_to_vhost16(struct vhost_virtqueue *vq, u16 val)
 {
-	return __cpu_to_virtio16(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+	return __cpu_to_virtio16(vhost_is_little_endian(vq), val);
 }
 
 static inline u32 vhost32_to_cpu(struct vhost_virtqueue *vq, __virtio32 val)
 {
-	return __virtio32_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+	return __virtio32_to_cpu(vhost_is_little_endian(vq), val);
 }
 
 static inline __virtio32 cpu_to_vhost32(struct vhost_virtqueue *vq, u32 val)
 {
-	return __cpu_to_virtio32(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+	return __cpu_to_virtio32(vhost_is_little_endian(vq), val);
 }
 
 static inline u64 vhost64_to_cpu(struct vhost_virtqueue *vq, __virtio64 val)
 {
-	return __virtio64_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+	return __virtio64_to_cpu(vhost_is_little_endian(vq), val);
 }
 
 static inline __virtio64 cpu_to_vhost64(struct vhost_virtqueue *vq, u64 val)
 {
-	return __cpu_to_virtio64(vhost_has_feature(vq, VIRTIO_F_VERSION_1), val);
+	return __cpu_to_virtio64(vhost_is_little_endian(vq), val);
 }
 #endif
