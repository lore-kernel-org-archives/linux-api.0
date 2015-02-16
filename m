From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 29/45] include/uapi/asm-generic/msgbuf.h: include asm/ipcbuf.h
Date: Tue, 17 Feb 2015 00:05:32 +0100
Message-ID: <1424127948-22484-30-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

error: field =E2=80=98msg_perm=E2=80=99 has incomplete type
struct ipc64_perm msg_perm

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/asm-generic/msgbuf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/asm-generic/msgbuf.h b/include/uapi/asm-gener=
ic/msgbuf.h
index f55ecc4..f5fbd8e 100644
--- a/include/uapi/asm-generic/msgbuf.h
+++ b/include/uapi/asm-generic/msgbuf.h
@@ -2,6 +2,8 @@
 #define __ASM_GENERIC_MSGBUF_H
=20
 #include <asm/bitsperlong.h>
+#include <asm/ipcbuf.h>
+
 /*
  * generic msqid64_ds structure.
  *
--=20
2.1.4
