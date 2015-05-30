From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 51/98] include/uapi/linux/llc.h: include linux/if.h
Date: Sat, 30 May 2015 17:38:43 +0200
Message-ID: <1433000370-19509-52-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compile error:

error: =E2=80=98IFHWADDRLEN=E2=80=99 undeclared here (not in a function=
)
 unsigned char   sllc_mac[IFHWADDRLEN];

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/llc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/llc.h b/include/uapi/linux/llc.h
index 9c987a4..f503599 100644
--- a/include/uapi/linux/llc.h
+++ b/include/uapi/linux/llc.h
@@ -14,6 +14,7 @@
 #define _UAPI__LINUX_LLC_H
=20
 #include <linux/socket.h>
+#include <linux/if.h>
=20
 #define __LLC_SOCK_SIZE__ 16	/* sizeof(sockaddr_llc), word align. */
 struct sockaddr_llc {
--=20
2.1.4
