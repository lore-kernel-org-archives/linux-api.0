From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 1/3] mce: change asm/ioctls.h for linux/ioctl.h
Date: Mon,  5 Oct 2015 16:50:09 +0200
Message-ID: <1444056611-7513-2-git-send-email-gabriel@lse.epita.fr>
References: <1444056611-7513-1-git-send-email-gabriel@lse.epita.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444056611-7513-1-git-send-email-gabriel@lse.epita.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>, Gabriel Laskar <gabriel@lse.epita.fr>, Borislav Petkov <bp@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
---

asm/ioctls.h contains definition for termios, not just the _IO* macros

 arch/x86/include/uapi/asm/mce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/mce.h b/arch/x86/include/uapi/asm/mce.h
index 76880ed..03429da 100644
--- a/arch/x86/include/uapi/asm/mce.h
+++ b/arch/x86/include/uapi/asm/mce.h
@@ -2,7 +2,7 @@
 #define _UAPI_ASM_X86_MCE_H
 
 #include <linux/types.h>
-#include <asm/ioctls.h>
+#include <linux/ioctl.h>
 
 /* Fields are zero when not available */
 struct mce {
-- 
2.6.0
