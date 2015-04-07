From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: [PATCH v3 4/7] vringh: introduce vringh_is_little_endian() helper
Date: Tue, 07 Apr 2015 14:15:19 +0200
Message-ID: <20150407121001.4213.73270.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
References: <20150407120929.4213.8225.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150407120929.4213.8225.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
---
 include/linux/vringh.h |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index a3fa537..3ed62ef 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -226,33 +226,38 @@ static inline void vringh_notify(struct vringh *vrh)
 		vrh->notify(vrh);
 }
 
+static inline bool vringh_is_little_endian(const struct vringh *vrh)
+{
+	return vrh->little_endian;
+}
+
 static inline u16 vringh16_to_cpu(const struct vringh *vrh, __virtio16 val)
 {
-	return __virtio16_to_cpu(vrh->little_endian, val);
+	return __virtio16_to_cpu(vringh_is_little_endian(vrh), val);
 }
 
 static inline __virtio16 cpu_to_vringh16(const struct vringh *vrh, u16 val)
 {
-	return __cpu_to_virtio16(vrh->little_endian, val);
+	return __cpu_to_virtio16(vringh_is_little_endian(vrh), val);
 }
 
 static inline u32 vringh32_to_cpu(const struct vringh *vrh, __virtio32 val)
 {
-	return __virtio32_to_cpu(vrh->little_endian, val);
+	return __virtio32_to_cpu(vringh_is_little_endian(vrh), val);
 }
 
 static inline __virtio32 cpu_to_vringh32(const struct vringh *vrh, u32 val)
 {
-	return __cpu_to_virtio32(vrh->little_endian, val);
+	return __cpu_to_virtio32(vringh_is_little_endian(vrh), val);
 }
 
 static inline u64 vringh64_to_cpu(const struct vringh *vrh, __virtio64 val)
 {
-	return __virtio64_to_cpu(vrh->little_endian, val);
+	return __virtio64_to_cpu(vringh_is_little_endian(vrh), val);
 }
 
 static inline __virtio64 cpu_to_vringh64(const struct vringh *vrh, u64 val)
 {
-	return __cpu_to_virtio64(vrh->little_endian, val);
+	return __cpu_to_virtio64(vringh_is_little_endian(vrh), val);
 }
 #endif /* _LINUX_VRINGH_H */
