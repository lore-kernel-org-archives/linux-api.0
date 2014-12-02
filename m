From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC 1/2] virtio_balloon: convert to virtio 1.0 endian-ness
Date: Tue, 2 Dec 2014 13:44:06 +0200
Message-ID: <1417520617-2135-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
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

balloon device is not part of virtio 1.0 spec.  Still, it's easy enough
to make it handle endian-ness exactly as other virtio 1.0 devices: what
we gain from this, is that there's no need to special-case it in virtio
core.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_balloon.h | 5 +++--
 drivers/virtio/virtio_balloon.c     | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index 5e26f61..5bee71c 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -27,6 +27,7 @@
  * SUCH DAMAGE. */
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
+#include <linux/virtio_types.h>
 
 /* The feature bitmap for virtio balloon */
 #define VIRTIO_BALLOON_F_MUST_TELL_HOST	0 /* Tell before reclaiming pages */
@@ -52,8 +53,8 @@ struct virtio_balloon_config
 #define VIRTIO_BALLOON_S_NR       6
 
 struct virtio_balloon_stat {
-	__u16 tag;
-	__u64 val;
+	__virtio16 tag;
+	__virtio64 val;
 } __attribute__((packed));
 
 #endif /* _LINUX_VIRTIO_BALLOON_H */
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 4497def..721e32f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -201,8 +201,8 @@ static inline void update_stat(struct virtio_balloon *vb, int idx,
 			       u16 tag, u64 val)
 {
 	BUG_ON(idx >= VIRTIO_BALLOON_S_NR);
-	vb->stats[idx].tag = tag;
-	vb->stats[idx].val = val;
+	vb->stats[idx].tag = cpu_to_virtio16(vb->vdev, tag);
+	vb->stats[idx].val = cpu_to_virtio64(vb->vdev, val);
 }
 
 #define pages_to_bytes(x) ((u64)(x) << PAGE_SHIFT)
-- 
MST
