From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 82/98] include/uapi/linux/target_core_user.h: use __u8, __u16, __u32 and __u64 from linux/types.h
Date: Sat, 30 May 2015 17:39:14 +0200
Message-ID: <1433000370-19509-83-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ilias Tsitsimpis <iliastsi-9y75AaqT1ExBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

error: unknown type name =E2=80=98uint16_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/target_core_user.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux=
/target_core_user.h
index b67f99d..012e013 100644
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -108,26 +108,26 @@ struct tcmu_cmd_entry {
=20
 	union {
 		struct {
-			uint32_t iov_cnt;
-			uint32_t iov_bidi_cnt;
-			uint32_t iov_dif_cnt;
-			uint64_t cdb_off;
-			uint64_t __pad1;
-			uint64_t __pad2;
+			__u32 iov_cnt;
+			__u32 iov_bidi_cnt;
+			__u32 iov_dif_cnt;
+			__u64 cdb_off;
+			__u64 __pad1;
+			__u64 __pad2;
 			struct iovec iov[0];
 		} req;
 		struct {
-			uint8_t scsi_status;
-			uint8_t __pad1;
-			uint16_t __pad2;
-			uint32_t __pad3;
+			__u8 scsi_status;
+			__u8 __pad1;
+			__u16 __pad2;
+			__u32 __pad3;
 			char sense_buffer[TCMU_SENSE_BUFFERSIZE];
 		} rsp;
 	};
=20
 } __packed;
=20
-#define TCMU_OP_ALIGN_SIZE sizeof(uint64_t)
+#define TCMU_OP_ALIGN_SIZE sizeof(__u64)
=20
 enum tcmu_genl_cmd {
 	TCMU_CMD_UNSPEC,
--=20
2.1.4
