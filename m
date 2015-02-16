From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 31/45] asm-generic/sembuf.h: include asm/posix_types.h and asm/ipcbuf.h
Date: Tue, 17 Feb 2015 00:05:34 +0100
Message-ID: <1424127948-22484-32-git-send-email-mikko.rapeli@iki.fi>
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

error: field =E2=80=98msg_perm=E2=80=99 has incomplete type
struct ipc64_perm msg_perm;
error: unknown type name =E2=80=98__kernel_ulong_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/asm-generic/sembuf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/asm-generic/sembuf.h b/include/uapi/asm-gener=
ic/sembuf.h
index 4cb2c13..17d523f 100644
--- a/include/uapi/asm-generic/sembuf.h
+++ b/include/uapi/asm-generic/sembuf.h
@@ -2,6 +2,8 @@
 #define __ASM_GENERIC_SEMBUF_H
=20
 #include <asm/bitsperlong.h>
+#include <asm/posix_types.h>
+#include <asm/ipcbuf.h>
=20
 /*
  * The semid64_ds structure for x86 architecture.
--=20
2.1.4
