From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 64/79] include/uapi/linux/reiserfs_xattr.h: use __kernel_size_t instead of size_t
Date: Thu, 15 Oct 2015 07:56:42 +0200
Message-ID: <1444888618-4506-65-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation error:

error: unknown type name =E2=80=98size_t=E2=80=99
  size_t length;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/reiserfs_xattr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/reiserfs_xattr.h b/include/uapi/linux/r=
eiserfs_xattr.h
index 38fdd64..af52b38 100644
--- a/include/uapi/linux/reiserfs_xattr.h
+++ b/include/uapi/linux/reiserfs_xattr.h
@@ -18,7 +18,7 @@ struct reiserfs_xattr_header {
 struct reiserfs_security_handle {
 	const char *name;
 	void *value;
-	size_t length;
+	__kernel_size_t length;
 };
=20
 #endif  /*  _LINUX_REISERFS_XATTR_H  */
--=20
2.5.0
