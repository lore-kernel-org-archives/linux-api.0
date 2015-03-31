From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 1/6] virtio_balloon: transitional interface
Date: Tue, 31 Mar 2015 21:52:39 +0200
Message-ID: <1427831230-28044-2-git-send-email-mst@redhat.com>
References: <1427831230-28044-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1427831230-28044-1-git-send-email-mst@redhat.com>
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

Virtio 1.0 doesn't include a modern balloon device.
But it's not a big change to support a transitional
balloon device: this has the advantage of supporting
existing drivers, transparently.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_balloon.h | 11 +++++++++--
 drivers/virtio/virtio_balloon.c     | 29 +++++++++++++++++++++--------
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index 4b0488f..71ef93b 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -38,9 +38,9 @@
 
 struct virtio_balloon_config {
 	/* Number of pages host wants Guest to give up. */
-	__le32 num_pages;
+	__u32 num_pages;
 	/* Number of pages we've actually got in balloon. */
-	__le32 actual;
+	__u32 actual;
 };
 
 #define VIRTIO_BALLOON_S_SWAP_IN  0   /* Amount of memory swapped in */
@@ -51,9 +51,16 @@ struct virtio_balloon_config {
 #define VIRTIO_BALLOON_S_MEMTOT   5   /* Total amount of memory */
 #define VIRTIO_BALLOON_S_NR       6
 
+/* Legacy stat structure. We keep it around to avoid breaking old userspace. */
 struct virtio_balloon_stat {
 	__u16 tag;
 	__u64 val;
 } __attribute__((packed));
 
+struct virtio_balloon_stat_modern {
+	__u8 reserved[6];
+	__virtio16 tag;
+	__virtio64 val;
+};
+
 #endif /* _LINUX_VIRTIO_BALLOON_H */
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 6a356e3..574267f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -77,7 +77,7 @@ struct virtio_balloon {
 
 	/* Memory statistics */
 	int need_stats_update;
-	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
+	struct virtio_balloon_stat_modern stats[VIRTIO_BALLOON_S_NR];
 
 	/* To register callback in oom notifier call chain */
 	struct notifier_block nb;
@@ -269,7 +269,11 @@ static void stats_handle_request(struct virtio_balloon *vb)
 	vq = vb->stats_vq;
 	if (!virtqueue_get_buf(vq, &len))
 		return;
-	sg_init_one(&sg, vb->stats, sizeof(vb->stats));
+	if (virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
+		sg_init_one(&sg, vb->stats, sizeof(vb->stats));
+	else
+		sg_init_one(&sg, &vb->stats->tag, sizeof(vb->stats) -
+			    offsetof(typeof(*vb->stats, tag);
 	virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
 	virtqueue_kick(vq);
 }
@@ -283,21 +287,30 @@ static void virtballoon_changed(struct virtio_device *vdev)
 
 static inline s64 towards_target(struct virtio_balloon *vb)
 {
-	__le32 v;
 	s64 target;
+	u32 num_pages;
 
-	virtio_cread(vb->vdev, struct virtio_balloon_config, num_pages, &v);
+	virtio_cread(vb->vdev, struct virtio_balloon_config,
+		     num_pages, &num_pages);
 
-	target = le32_to_cpu(v);
+	/* Legacy balloon config space is LE, unlike all other devices. */
+	if (!virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
+		num_pages = le32_to_cpu((__force le32)num_pages);
+
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
+		actual = (__force u32)cpu_to_le32(num_pages);
 
-	virtio_cwrite(vb->vdev, struct virtio_balloon_config, actual,
-		      &actual);
+	virtio_cwrite(vb->vdev, struct virtio_balloon_config,
+		      actual, &actual);
 }
 
 /*
-- 
MST
