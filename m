From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] virtio_balloon: drop virtio_balloon_stat_modern
Date: Tue, 14 Apr 2015 12:01:13 +0200
Message-ID: <1429005625-23181-1-git-send-email-mst@redhat.com>
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

Looks like we are better off sticking with the misaligned stat struct,
to reduce the amount of virtio 1 specific code in balloon.  So let's do
it.

Add a detailed comment to reduce the chance people copy this bad example.

This also fixes a bug on BE architectures: tag should use
cpu_to_le16, not cpu_to_le32.

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Just reposting so it's easier to apply.
Feel free to squash into previous patch if you think it's
neater.

 include/uapi/linux/virtio_balloon.h | 33 +++++++++++++++++++++++++--------
 drivers/virtio/virtio_balloon.c     | 19 ++++---------------
 2 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index f81b220..984169a 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -52,15 +52,32 @@ struct virtio_balloon_config {
 #define VIRTIO_BALLOON_S_MEMTOT   5   /* Total amount of memory */
 #define VIRTIO_BALLOON_S_NR       6
 
+/*
+ * Memory statistics structure.
+ * Driver fills an array of these structures and passes to device.
+ *
+ * NOTE: fields are laid out in a way that would make compiler add padding
+ * between and after fields, so we have to use compiler-specific attributes to
+ * pack it, to disable this padding. This also often causes compiler to
+ * generate suboptimal code.
+ *
+ * We maintain this statistics structure format for backwards compatibility,
+ * but don't follow this example.
+ *
+ * If implementing a similar structure, do something like the below instead:
+ *     struct virtio_balloon_stat {
+ *         __virtio16 tag;
+ *         __u8 reserved[6];
+ *         __virtio64 val;
+ *     };
+ *
+ * In other words, add explicit reserved fields to align field and
+ * structure boundaries at field size, avoiding compiler padding
+ * without the packed attribute.
+ */
 struct virtio_balloon_stat {
-	__u16 tag;
-	__u64 val;
+	__virtio16 tag;
+	__virtio64 val;
 } __attribute__((packed));
 
-struct virtio_balloon_stat_modern {
-	__le16 tag;
-	__u8 reserved[6];
-	__le64 val;
-};
-
 #endif /* _LINUX_VIRTIO_BALLOON_H */
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 0583720..9db546e 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -77,10 +77,7 @@ struct virtio_balloon {
 
 	/* Memory statistics */
 	int need_stats_update;
-	union {
-		struct virtio_balloon_stat_modern stats[VIRTIO_BALLOON_S_NR];
-		struct virtio_balloon_stat legacy_stats[VIRTIO_BALLOON_S_NR];
-	};
+	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
 
 	/* To register callback in oom notifier call chain */
 	struct notifier_block nb;
@@ -93,10 +90,7 @@ static struct virtio_device_id id_table[] = {
 
 static void stats_sg_init(struct virtio_balloon *vb, struct scatterlist *sg)
 {
-	if (virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
-		sg_init_one(sg, vb->stats, sizeof(vb->stats));
-	else
-		sg_init_one(sg, vb->legacy_stats, sizeof(vb->legacy_stats));
+	sg_init_one(sg, vb->stats, sizeof(vb->stats));
 }
 
 static u32 page_to_balloon_pfn(struct page *page)
@@ -225,13 +219,8 @@ static inline void update_stat(struct virtio_balloon *vb, int idx,
 			       u16 tag, u64 val)
 {
 	BUG_ON(idx >= VIRTIO_BALLOON_S_NR);
-	if (virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1)) {
-		vb->stats[idx].tag = cpu_to_le32(tag);
-		vb->stats[idx].val = cpu_to_le64(val);
-	} else {
-		vb->legacy_stats[idx].tag = tag;
-		vb->legacy_stats[idx].val = val;
-	}
+	vb->stats[idx].tag = cpu_to_virtio16(vb->vdev, tag);
+	vb->stats[idx].val = cpu_to_virtio64(vb->vdev, val);
 }
 
 #define pages_to_bytes(x) ((u64)(x) << PAGE_SHIFT)
-- 
MST
