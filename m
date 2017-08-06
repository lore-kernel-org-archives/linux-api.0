From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 08/36] uapi asm-generic/shmbuf.h: include fixes
Date: Sun,  6 Aug 2017 18:43:59 +0200
Message-ID: <20170806164428.2273-9-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, "H . J . Lu" <hjl.tools@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Include linux/types.h and asm/msgbuf.h and use __kernel_size_t instead
of size_t.

Fixes userspace compilation errors like:

error: field ‘shm_perm’ has incomplete type
struct ipc64_perm shm_perm; /* operation perms */
error: unknown type name ‘size_t’
error: unknown type name ‘__kernel_time_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 include/uapi/asm-generic/shmbuf.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/asm-generic/shmbuf.h b/include/uapi/asm-generic/shmbuf.h
index 7e9fb2f0853b..ae867ad1e5e4 100644
--- a/include/uapi/asm-generic/shmbuf.h
+++ b/include/uapi/asm-generic/shmbuf.h
@@ -1,7 +1,9 @@
 #ifndef __ASM_GENERIC_SHMBUF_H
 #define __ASM_GENERIC_SHMBUF_H
 
+#include <linux/types.h>
 #include <asm/bitsperlong.h>
+#include <asm/msgbuf.h>
 
 /*
  * The shmid64_ds structure for x86 architecture.
@@ -24,7 +26,7 @@
 
 struct shmid64_ds {
 	struct ipc64_perm	shm_perm;	/* operation perms */
-	size_t			shm_segsz;	/* size of segment (bytes) */
+	__kernel_size_t		shm_segsz;	/* size of segment (bytes) */
 	__kernel_time_t		shm_atime;	/* last attach time */
 #if __BITS_PER_LONG != 64
 	unsigned long		__unused1;
-- 
2.13.3
