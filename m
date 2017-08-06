From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 13/36] x86 uapi asm/sembuf.h: include linux/types.h and linux/ipc.h
Date: Sun,  6 Aug 2017 18:44:04 +0200
Message-ID: <20170806164428.2273-14-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compile errors like:

error: field ‘sem_perm’ has incomplete type
  struct ipc64_perm sem_perm; /* permissions .. see ipc.h */
error: unknown type name ‘__kernel_time_t’
  __kernel_time_t sem_otime; /* last semop time */

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/uapi/asm/sembuf.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/uapi/asm/sembuf.h b/arch/x86/include/uapi/asm/sembuf.h
index cc2d6a3aeae7..f11ed5282eec 100644
--- a/arch/x86/include/uapi/asm/sembuf.h
+++ b/arch/x86/include/uapi/asm/sembuf.h
@@ -1,6 +1,9 @@
 #ifndef _ASM_X86_SEMBUF_H
 #define _ASM_X86_SEMBUF_H
 
+#include <linux/types.h>
+#include <linux/ipc.h>
+
 /*
  * The semid64_ds structure for x86 architecture.
  * Note extra padding because this structure is passed back and forth
-- 
2.13.3
