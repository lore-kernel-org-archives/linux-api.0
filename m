From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: [PATCH v4 2/8] tun: add tun_is_little_endian() helper
Date: Fri, 10 Apr 2015 12:15:40 +0200
Message-ID: <20150410101535.31843.34470.stgit@bahia.local>
References: <20150410101500.31843.61248.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150410101500.31843.61248.stgit@bahia.local>
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
 drivers/net/tun.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 857dca4..3c3d6c0 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -206,14 +206,19 @@ struct tun_struct {
 	u32 flow_count;
 };
 
+static inline bool tun_is_little_endian(struct tun_struct *tun)
+{
+	return tun->flags & TUN_VNET_LE;
+}
+
 static inline u16 tun16_to_cpu(struct tun_struct *tun, __virtio16 val)
 {
-	return __virtio16_to_cpu(tun->flags & TUN_VNET_LE, val);
+	return __virtio16_to_cpu(tun_is_little_endian(tun), val);
 }
 
 static inline __virtio16 cpu_to_tun16(struct tun_struct *tun, u16 val)
 {
-	return __cpu_to_virtio16(tun->flags & TUN_VNET_LE, val);
+	return __cpu_to_virtio16(tun_is_little_endian(tun), val);
 }
 
 static inline u32 tun_hashfn(u32 rxhash)
