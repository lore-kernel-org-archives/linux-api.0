From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 03/36] uapi scsi/scsi_netlink.h: use __u8, __u16 and __u64 from linux/types.h
Date: Sun,  6 Aug 2017 18:43:54 +0200
Message-ID: <20170806164428.2273-4-mikko.rapeli@iki.fi>
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

scsi/scsi_netlink.h:43:2: error: unknown type name ‘uint8_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-scsi@vger.kernel.org
---
 include/uapi/scsi/scsi_netlink.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/uapi/scsi/scsi_netlink.h b/include/uapi/scsi/scsi_netlink.h
index 62b4edab15d3..36b53a769a04 100644
--- a/include/uapi/scsi/scsi_netlink.h
+++ b/include/uapi/scsi/scsi_netlink.h
@@ -22,8 +22,8 @@
 #ifndef SCSI_NETLINK_H
 #define SCSI_NETLINK_H
 
-#include <linux/netlink.h>
 #include <linux/types.h>
+#include <linux/netlink.h>
 
 /*
  * This file intended to be included by both kernel and user space
@@ -40,12 +40,12 @@
 
 /* SCSI_TRANSPORT_MSG event message header */
 struct scsi_nl_hdr {
-	uint8_t version;
-	uint8_t transport;
-	uint16_t magic;
-	uint16_t msgtype;
-	uint16_t msglen;
-} __attribute__((aligned(sizeof(uint64_t))));
+	__u8 version;
+	__u8 transport;
+	__u16 magic;
+	__u16 msgtype;
+	__u16 msglen;
+} __attribute__((aligned(sizeof(__u64))));
 
 /* scsi_nl_hdr->version value */
 #define SCSI_NL_VERSION				1
@@ -89,10 +89,10 @@ struct scsi_nl_hdr {
  */
 struct scsi_nl_host_vendor_msg {
 	struct scsi_nl_hdr snlh;		/* must be 1st element ! */
-	uint64_t vendor_id;
-	uint16_t host_no;
-	uint16_t vmsg_datalen;
-} __attribute__((aligned(sizeof(uint64_t))));
+	__u64 vendor_id;
+	__u16 host_no;
+	__u16 vmsg_datalen;
+} __attribute__((aligned(sizeof(__u64))));
 
 
 /*
-- 
2.13.3
