From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 27/98] scsi_netlink.h: use __u8, __u16 and __u64 from linux/types.h
Date: Sat, 30 May 2015 17:38:19 +0200
Message-ID: <1433000370-19509-28-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

scsi/scsi_netlink.h:43:2: error: unknown type name =E2=80=98uint8_t=E2=80=
=99

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/scsi/scsi_netlink.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/uapi/scsi/scsi_netlink.h b/include/uapi/scsi/scsi_=
netlink.h
index 62b4eda..36b53a76 100644
--- a/include/uapi/scsi/scsi_netlink.h
+++ b/include/uapi/scsi/scsi_netlink.h
@@ -22,8 +22,8 @@
 #ifndef SCSI_NETLINK_H
 #define SCSI_NETLINK_H
=20
-#include <linux/netlink.h>
 #include <linux/types.h>
+#include <linux/netlink.h>
=20
 /*
  * This file intended to be included by both kernel and user space
@@ -40,12 +40,12 @@
=20
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
=20
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
=20
=20
 /*
--=20
2.1.4
