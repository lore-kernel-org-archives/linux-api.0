From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC v2 15/16] virtio_net: fix types for in memory structures
Date: Wed, 22 Oct 2014 18:51:12 +0300
Message-ID: <1413992894-22976-16-git-send-email-mst@redhat.com>
References: <1413992894-22976-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1413992894-22976-1-git-send-email-mst@redhat.com>
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

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_net.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 172a7f0..b5f1677 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
+#include <linux/virtio_types.h>
 #include <linux/if_ether.h>
 
 /* The feature bitmap for virtio net */
@@ -84,17 +85,17 @@ struct virtio_net_hdr {
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	// GSO frame, IPv6 TCP
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	// TCP has ECN set
 	__u8 gso_type;
-	__u16 hdr_len;		/* Ethernet + IP + tcp/udp hdrs */
-	__u16 gso_size;		/* Bytes to append to hdr_len per frame */
-	__u16 csum_start;	/* Position to start checksumming from */
-	__u16 csum_offset;	/* Offset after that to place checksum */
+	__virtio16 hdr_len;		/* Ethernet + IP + tcp/udp hdrs */
+	__virtio16 gso_size;		/* Bytes to append to hdr_len per frame */
+	__virtio16 csum_start;	/* Position to start checksumming from */
+	__virtio16 csum_offset;	/* Offset after that to place checksum */
 };
 
 /* This is the version of the header to use when the MRG_RXBUF
  * feature has been negotiated. */
 struct virtio_net_hdr_mrg_rxbuf {
 	struct virtio_net_hdr hdr;
-	__u16 num_buffers;	/* Number of merged rx buffers */
+	__virtio16 num_buffers;	/* Number of merged rx buffers */
 };
 
 /*
@@ -149,7 +150,7 @@ typedef __u8 virtio_net_ctrl_ack;
  * VIRTIO_NET_F_CTRL_MAC_ADDR feature is available.
  */
 struct virtio_net_ctrl_mac {
-	__u32 entries;
+	__virtio32 entries;
 	__u8 macs[][ETH_ALEN];
 } __attribute__((packed));
 
@@ -193,7 +194,7 @@ struct virtio_net_ctrl_mac {
  * specified.
  */
 struct virtio_net_ctrl_mq {
-	__u16 virtqueue_pairs;
+	__virtio16 virtqueue_pairs;
 };
 
 #define VIRTIO_NET_CTRL_MQ   4
-- 
MST
