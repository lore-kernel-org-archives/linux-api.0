From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 83/98] include/uapi/linux/omapfb.h: use __kernel_size_t instead of size_t
Date: Sat, 30 May 2015 17:39:15 +0200
Message-ID: <1433000370-19509-84-git-send-email-mikko.rapeli@iki.fi>
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

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/omapfb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/omapfb.h b/include/uapi/linux/omapfb.h
index 7c97bc0..b637a92 100644
--- a/include/uapi/linux/omapfb.h
+++ b/include/uapi/linux/omapfb.h
@@ -181,7 +181,7 @@ struct omapfb_memory_read {
 	__u16 y;
 	__u16 w;
 	__u16 h;
-	size_t buffer_size;
+	__kernel_size_t buffer_size;
 	void __user *buffer;
 };
=20
--=20
2.1.4
