From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 88/98] include/uapi/linux/reiserfs_xattr.h: use __kernel_size_t instead of size_t
Date: Sat, 30 May 2015 17:39:20 +0200
Message-ID: <1433000370-19509-89-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation error:

error: unknown type name =E2=80=98size_t=E2=80=99
  size_t length;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
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
2.1.4
