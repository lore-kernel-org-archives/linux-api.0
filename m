From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 58/79] include/uapi/linux/target_core_user.h: use __u8, __u16, __u32 and __u64 from linux/types.h
Date: Thu, 15 Oct 2015 07:56:36 +0200
Message-ID: <1444888618-4506-59-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, Nicholas Bellinger <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, Kyle McMartin <kyle@redhat.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, David Disseldorp <ddiss@suse.de>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

error: unknown type name =E2=80=98uint16_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/target_core_user.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux=
/target_core_user.h
index 95c6521..440b52a 100644
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -104,26 +104,26 @@ struct tcmu_cmd_entry {
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
2.5.0
