From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH v4 24/79] sctp.h: use __u8 and __u32 from linux/types.h
Date: Thu, 15 Oct 2015 07:56:02 +0200
Message-ID: <1444888618-4506-25-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mikko.rapeli-X3B1VOXEql0@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

linux/sctp.h:652:2: error: unknown type name =E2=80=98uint32_t=E2=80=99

Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/sctp.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index ce70fe6..dd0a9c2 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -718,13 +718,13 @@ struct sctp_authkeyid {
  */
 struct sctp_sack_info {
 	sctp_assoc_t	sack_assoc_id;
-	uint32_t	sack_delay;
-	uint32_t	sack_freq;
+	__u32	sack_delay;
+	__u32	sack_freq;
 };
=20
 struct sctp_assoc_value {
     sctp_assoc_t            assoc_id;
-    uint32_t                assoc_value;
+    __u32                assoc_value;
 };
=20
 /*
@@ -794,7 +794,7 @@ struct sctp_status {
 struct sctp_authchunks {
 	sctp_assoc_t	gauth_assoc_id;
 	__u32		gauth_number_of_chunks;
-	uint8_t		gauth_chunks[];
+	__u8		gauth_chunks[];
 };
=20
 /* The broken spelling has been released already in lksctp-tools heade=
r,
--=20
2.5.0
