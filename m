From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: [PATCH v3 3/7] macvtap: introduce macvtap_is_little_endian() helper
Date: Tue, 07 Apr 2015 14:09:56 +0200
Message-ID: <20150407120952.4213.80298.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
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
 drivers/net/macvtap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 27ecc5c..a2f2958 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -49,14 +49,19 @@ struct macvtap_queue {
 
 #define MACVTAP_VNET_LE 0x80000000
 
+static inline bool macvtap_is_little_endian(struct macvtap_queue *q)
+{
+	return q->flags & MACVTAP_VNET_LE;
+}
+
 static inline u16 macvtap16_to_cpu(struct macvtap_queue *q, __virtio16 val)
 {
-	return __virtio16_to_cpu(q->flags & MACVTAP_VNET_LE, val);
+	return __virtio16_to_cpu(macvtap_is_little_endian(q), val);
 }
 
 static inline __virtio16 cpu_to_macvtap16(struct macvtap_queue *q, u16 val)
 {
-	return __cpu_to_virtio16(q->flags & MACVTAP_VNET_LE, val);
+	return __cpu_to_virtio16(macvtap_is_little_endian(q), val);
 }
 
 static struct proto macvtap_proto = {
