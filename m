From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 30/45] include/uapi/asm-generic/shmbuf.h: include fixes
Date: Tue, 17 Feb 2015 00:05:33 +0100
Message-ID: <1424127948-22484-31-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation errors like:

error: field =E2=80=98shm_perm=E2=80=99 has incomplete type
struct ipc64_perm shm_perm; /* operation perms */
error: unknown type name =E2=80=98size_t=E2=80=99
error: unknown type name =E2=80=98__kernel_time_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/asm-generic/shmbuf.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/asm-generic/shmbuf.h b/include/uapi/asm-gener=
ic/shmbuf.h
index 7e9fb2f..24ef152 100644
--- a/include/uapi/asm-generic/shmbuf.h
+++ b/include/uapi/asm-generic/shmbuf.h
@@ -1,7 +1,13 @@
 #ifndef __ASM_GENERIC_SHMBUF_H
 #define __ASM_GENERIC_SHMBUF_H
=20
+#include <linux/types.h>
 #include <asm/bitsperlong.h>
+#include <asm/msgbuf.h>
+
+#ifndef __KERNEL__
+#include <stdlib.h>
+#endif
=20
 /*
  * The shmid64_ds structure for x86 architecture.
--=20
2.1.4
