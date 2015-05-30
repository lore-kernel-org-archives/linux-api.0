From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 23/98] cld.h: use __u8, __u16, __s16, __u32 and __s64 from linux/types.h
Date: Sat, 30 May 2015 17:38:15 +0200
Message-ID: <1433000370-19509-24-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

linux/nfsd/cld.h:40:2: error: unknown type name =E2=80=98uint16_t=E2=80=
=99

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/nfsd/cld.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/nfsd/cld.h b/include/uapi/linux/nfsd/cl=
d.h
index f14a9ab..d9f2306 100644
--- a/include/uapi/linux/nfsd/cld.h
+++ b/include/uapi/linux/nfsd/cld.h
@@ -22,6 +22,8 @@
 #ifndef _NFSD_CLD_H
 #define _NFSD_CLD_H
=20
+#include <linux/types.h>
+
 /* latest upcall version available */
 #define CLD_UPCALL_VERSION 1
=20
@@ -37,18 +39,18 @@ enum cld_command {
=20
 /* representation of long-form NFSv4 client ID */
 struct cld_name {
-	uint16_t	cn_len;				/* length of cm_id */
+	__u16	cn_len;				/* length of cm_id */
 	unsigned char	cn_id[NFS4_OPAQUE_LIMIT];	/* client-provided */
 } __attribute__((packed));
=20
 /* message struct for communication with userspace */
 struct cld_msg {
-	uint8_t		cm_vers;		/* upcall version */
-	uint8_t		cm_cmd;			/* upcall command */
-	int16_t		cm_status;		/* return code */
-	uint32_t	cm_xid;			/* transaction id */
+	__u8		cm_vers;		/* upcall version */
+	__u8		cm_cmd;			/* upcall command */
+	__s16		cm_status;		/* return code */
+	__u32	cm_xid;			/* transaction id */
 	union {
-		int64_t		cm_gracetime;	/* grace period start time */
+		__s64		cm_gracetime;	/* grace period start time */
 		struct cld_name	cm_name;
 	} __attribute__((packed)) cm_u;
 } __attribute__((packed));
--=20
2.1.4
