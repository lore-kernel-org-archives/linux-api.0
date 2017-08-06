From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 04/36] uapi scsi/scsi_netlink_fc.h: use __u16, __u32 and __u64 from linux/types.h
Date: Sun,  6 Aug 2017 18:43:55 +0200
Message-ID: <20170806164428.2273-5-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, linux-scsi@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation errors like:

scsi/scsi_netlink_fc.h:60:2: error: expected specifier-qualifier-list before ‘uint64_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-scsi@vger.kernel.org
---
 include/uapi/scsi/scsi_netlink_fc.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/scsi/scsi_netlink_fc.h b/include/uapi/scsi/scsi_netlink_fc.h
index cbf76e479761..2493a0f533dc 100644
--- a/include/uapi/scsi/scsi_netlink_fc.h
+++ b/include/uapi/scsi/scsi_netlink_fc.h
@@ -57,14 +57,14 @@
  */
 struct fc_nl_event {
 	struct scsi_nl_hdr snlh;		/* must be 1st element ! */
-	uint64_t seconds;
-	uint64_t vendor_id;
-	uint16_t host_no;
-	uint16_t event_datalen;
-	uint32_t event_num;
-	uint32_t event_code;
-	uint32_t event_data;
-} __attribute__((aligned(sizeof(uint64_t))));
+	__u64 seconds;
+	__u64 vendor_id;
+	__u16 host_no;
+	__u16 event_datalen;
+	__u32 event_num;
+	__u32 event_code;
+	__u32 event_data;
+} __attribute__((aligned(sizeof(__u64))));
 
 
 #endif /* SCSI_NETLINK_FC_H */
-- 
2.13.3
