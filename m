From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 34/79] include/uapi/asm-generic/shmbuf.h: include fixes
Date: Thu, 15 Oct 2015 07:56:12 +0200
Message-ID: <1444888618-4506-35-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Include linux/types.h and asm/msgbuf.h and use __kernel_size_t instead
of size_t.

=46ixes userspace compilation errors like:

error: field =E2=80=98shm_perm=E2=80=99 has incomplete type
struct ipc64_perm shm_perm; /* operation perms */
error: unknown type name =E2=80=98size_t=E2=80=99
error: unknown type name =E2=80=98__kernel_time_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/asm-generic/shmbuf.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/asm-generic/shmbuf.h b/include/uapi/asm-gener=
ic/shmbuf.h
index 7e9fb2f..ae867ad 100644
--- a/include/uapi/asm-generic/shmbuf.h
+++ b/include/uapi/asm-generic/shmbuf.h
@@ -1,7 +1,9 @@
 #ifndef __ASM_GENERIC_SHMBUF_H
 #define __ASM_GENERIC_SHMBUF_H
=20
+#include <linux/types.h>
 #include <asm/bitsperlong.h>
+#include <asm/msgbuf.h>
=20
 /*
  * The shmid64_ds structure for x86 architecture.
@@ -24,7 +26,7 @@
=20
 struct shmid64_ds {
 	struct ipc64_perm	shm_perm;	/* operation perms */
-	size_t			shm_segsz;	/* size of segment (bytes) */
+	__kernel_size_t		shm_segsz;	/* size of segment (bytes) */
 	__kernel_time_t		shm_atime;	/* last attach time */
 #if __BITS_PER_LONG !=3D 64
 	unsigned long		__unused1;
--=20
2.5.0
