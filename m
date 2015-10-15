From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 27/79] scsi_netlink_fc.h: use __u16, __u32 and __u64 from linux/types.h
Date: Thu, 15 Oct 2015 07:56:05 +0200
Message-ID: <1444888618-4506-28-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

scsi/scsi_netlink_fc.h:60:2: error: expected specifier-qualifier-list b=
efore =E2=80=98uint64_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/scsi/scsi_netlink_fc.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/scsi/scsi_netlink_fc.h b/include/uapi/scsi/sc=
si_netlink_fc.h
index cbf76e4..2493a0f 100644
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
=20
=20
 #endif /* SCSI_NETLINK_FC_H */
--=20
2.5.0
