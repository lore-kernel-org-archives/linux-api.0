From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 1/6] virtio_balloon: transitional interface
Date: Mon, 30 Mar 2015 19:37:12 +0200
Message-ID: <1427737006-23191-2-git-send-email-mst@redhat.com>
References: <1427737006-23191-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1427737006-23191-1-git-send-email-mst@redhat.com>
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
Cc: virtio-dev@lists.oasis-open.org, linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

Virtio 1.0 doesn't include a modern balloon device.
But it's not a big change to support a transitional
balloon device: this has the advantage of supporting
existing drivers, transparently.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_balloon.h | 6 ++++++
 drivers/virtio/virtio_balloon.c     | 8 ++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index 4b0488f..5d83902 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -56,4 +56,10 @@ struct virtio_balloon_stat {
 	__u64 val;
 } __attribute__((packed));
 
+struct virtio_balloon_stat_modern {
+	__u8 reserved[6];
+	__u16 tag;
+	__u64 val;
+};
+
 #endif /* _LINUX_VIRTIO_BALLOON_H */
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 6a356e3..68e937f 100644
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
-- 
MST
