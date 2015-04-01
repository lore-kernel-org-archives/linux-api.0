From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 1/6] virtio_balloon: transitional interface
Date: Wed, 1 Apr 2015 12:35:45 +0200
Message-ID: <1427884468-23930-2-git-send-email-mst@redhat.com>
References: <1427884468-23930-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427884468-23930-1-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Virtio 1.0 doesn't include a modern balloon device.
But it's not a big change to support a transitional
balloon device: this has the advantage of supporting
existing drivers, transparently.

Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/virtio_balloon.h | 11 ++++++++--
 drivers/virtio/virtio_balloon.c     | 43 +++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index 4b0488f..f81b220 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -25,6 +25,7 @@
  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  * SUCH DAMAGE. */
+#include <linux/types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
@@ -38,9 +39,9 @@
 
 struct virtio_balloon_config {
 	/* Number of pages host wants Guest to give up. */
-	__le32 num_pages;
+	__u32 num_pages;
 	/* Number of pages we've actually got in balloon. */
-	__le32 actual;
+	__u32 actual;
 };
 
 #define VIRTIO_BALLOON_S_SWAP_IN  0   /* Amount of memory swapped in */
@@ -56,4 +57,10 @@ struct virtio_balloon_stat {
 	__u64 val;
 } __attribute__((packed));
 
+struct virtio_balloon_stat_modern {
+	__le16 tag;
+	__u8 reserved[6];
+	__le64 val;
+};
+
 #endif /* _LINUX_VIRTIO_BALLOON_H */
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 6a356e3..0583720 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -77,7 +77,10 @@ struct virtio_balloon {
 
 	/* Memory statistics */
 	int need_stats_update;
-	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
+	union {
+		struct virtio_balloon_stat_modern stats[VIRTIO_BALLOON_S_NR];
+		struct virtio_balloon_stat legacy_stats[VIRTIO_BALLOON_S_NR];
+	};
 
 	/* To register callback in oom notifier call chain */
 	struct notifier_block nb;
@@ -88,6 +91,14 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
+static void stats_sg_init(struct virtio_balloon *vb, struct scatterlist *sg)
+{
+	if (virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
+		sg_init_one(sg, vb->stats, sizeof(vb->stats));
+	else
+		sg_init_one(sg, vb->legacy_stats, sizeof(vb->legacy_stats));
+}
+
 static u32 page_to_balloon_pfn(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -214,8 +225,13 @@ static inline void update_stat(struct virtio_balloon *vb, int idx,
 			       u16 tag, u64 val)
 {
 	BUG_ON(idx >= VIRTIO_BALLOON_S_NR);
-	vb->stats[idx].tag = tag;
-	vb->stats[idx].val = val;
+	if (virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1)) {
+		vb->stats[idx].tag = cpu_to_le32(tag);
+		vb->stats[idx].val = cpu_to_le64(val);
+	} else {
+		vb->legacy_stats[idx].tag = tag;
+		vb->legacy_stats[idx].val = val;
+	}
 }
 
 #define pages_to_bytes(x) ((u64)(x) << PAGE_SHIFT)
@@ -269,7 +285,7 @@ static void stats_handle_request(struct virtio_balloon *vb)
 	vq = vb->stats_vq;
 	if (!virtqueue_get_buf(vq, &len))
 		return;
-	sg_init_one(&sg, vb->stats, sizeof(vb->stats));
+	stats_sg_init(vb, &sg);
 	virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
 	virtqueue_kick(vq);
 }
@@ -283,18 +299,27 @@ static void virtballoon_changed(struct virtio_device *vdev)
 
 static inline s64 towards_target(struct virtio_balloon *vb)
 {
-	__le32 v;
 	s64 target;
+	u32 num_pages;
+
+	virtio_cread(vb->vdev, struct virtio_balloon_config, num_pages,
+		     &num_pages);
 
-	virtio_cread(vb->vdev, struct virtio_balloon_config, num_pages, &v);
+	/* Legacy balloon config space is LE, unlike all other devices. */
+	if (!virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
+		num_pages = le32_to_cpu((__force __le32)num_pages);
 
-	target = le32_to_cpu(v);
+	target = num_pages;
 	return target - vb->num_pages;
 }
 
 static void update_balloon_size(struct virtio_balloon *vb)
 {
-	__le32 actual = cpu_to_le32(vb->num_pages);
+	u32 actual = vb->num_pages;
+
+	/* Legacy balloon config space is LE, unlike all other devices. */
+	if (!virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
+		actual = (__force u32)cpu_to_le32(actual);
 
 	virtio_cwrite(vb->vdev, struct virtio_balloon_config, actual,
 		      &actual);
@@ -397,7 +422,7 @@ static int init_vqs(struct virtio_balloon *vb)
 		 * Prime this virtqueue with one buffer so the hypervisor can
 		 * use it to signal us later (it can't be broken yet!).
 		 */
-		sg_init_one(&sg, vb->stats, sizeof vb->stats);
+		stats_sg_init(vb, &sg);
 		if (virtqueue_add_outbuf(vb->stats_vq, &sg, 1, vb, GFP_KERNEL)
 		    < 0)
 			BUG();
-- 
MST
