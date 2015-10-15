From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 47/79] include/uapi/linux/llc.h: include linux/if.h
Date: Thu, 15 Oct 2015 07:56:25 +0200
Message-ID: <1444888618-4506-48-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compile error:

error: =E2=80=98IFHWADDRLEN=E2=80=99 undeclared here (not in a function=
)
 unsigned char   sllc_mac[IFHWADDRLEN];

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
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
2.5.0
