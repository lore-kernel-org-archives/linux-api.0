From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 05/17] asm-generic: Remove empty asm/unistd.h
Date: Wed, 25 Apr 2018 18:02:59 +0200
Message-ID: <20180425160311.2718314-6-arnd@arndb.de>
References: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425160311.2718314-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, netdev@vger.kernel.org, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, albert.aribaud@3adev.fr, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

Nothing is left in asm/unistd.h except for the redirect to
uapi/asm/unistd.h, so removing the file simply leads to that one being
used directly.  The linux/export.h inclusion is a leftover from commit
e1b5bb6d1236 ("consolidate cond_syscall and SYSCALL_ALIAS declarations")
and should not be used anyway.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/unistd.h | 3 ---
 1 file changed, 3 deletions(-)
 delete mode 100644 include/asm-generic/unistd.h

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
deleted file mode 100644
index 71d2fcf9dbcd..000000000000
--- a/include/asm-generic/unistd.h
+++ /dev/null
@@ -1,3 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#include <uapi/asm-generic/unistd.h>
-#include <linux/export.h>
-- 
2.9.0
