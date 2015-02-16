From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 33/45] include/uapi/asm-generic/signal.h: include stdlib.h in userspace
Date: Tue, 17 Feb 2015 00:05:36 +0100
Message-ID: <1424127948-22484-34-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes compiler warning:
error: unknown type name =E2=80=98size_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/asm-generic/signal.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/asm-generic/signal.h b/include/uapi/asm-gener=
ic/signal.h
index 9df61f1..8a341a2 100644
--- a/include/uapi/asm-generic/signal.h
+++ b/include/uapi/asm-generic/signal.h
@@ -3,6 +3,10 @@
=20
 #include <linux/types.h>
=20
+#ifndef __KERNEL__
+#include <stdlib.h>
+#endif
+
 #define _NSIG		64
 #define _NSIG_BPW	__BITS_PER_LONG
 #define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
--=20
2.1.4
