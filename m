From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 39/98] include/uapi/linux/socket.h: include sys/socket.h in userspace
Date: Sat, 30 May 2015 17:38:31 +0200
Message-ID: <1433000370-19509-40-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This libc header has sockaddr definition for userspace.

=46ixes userspace compilation errors like these from kernel headers inc=
luding
only linux/socket.h:

error: field =E2=80=98ifru_addr=E2=80=99 has incomplete type
struct sockaddr ifru_addr;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/socket.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
index 76ab0c6..8a81197 100644
--- a/include/uapi/linux/socket.h
+++ b/include/uapi/linux/socket.h
@@ -1,6 +1,10 @@
 #ifndef _UAPI_LINUX_SOCKET_H
 #define _UAPI_LINUX_SOCKET_H
=20
+#ifndef __KERNEL__
+#include <sys/socket.h>
+#endif
+
 /*
  * Desired design of maximum size and alignment (see RFC2553)
  */
--=20
2.1.4
