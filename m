From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 08/14] asm-generic: Remove empty asm/unistd.h
Date: Mon, 27 Aug 2018 21:45:25 +0200
Message-ID: <20180827194531.3796559-9-arnd@arndb.de>
References: <20180827194531.3796559-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827194531.3796559-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de
Cc: y2038@lists.linaro.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, deepa.kernel@gmail.com, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

Nothing is left in asm/unistd.h except for the redirect to
uapi/asm/unistd.h, so removing the file simply leads to that one being
used directly.  The linux/export.h inclusion is a leftover from commit
e1b5bb6d1236 ("consolidate cond_syscall and SYSCALL_ALIAS declarations")
and should not be used anyway.

Reviewed-by: Christoph Hellwig <hch@lst.de>
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
2.18.0
