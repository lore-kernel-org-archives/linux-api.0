From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH] tty: fix comment of ASYNCB_SPD_HI
Date: Mon, 11 May 2015 10:23:38 +0900
Message-ID: <1431307418-8334-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-serial@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

This comment does not reflect the actual code.  It should be 57600,
not 56000.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 include/uapi/linux/tty_flags.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/tty_flags.h b/include/uapi/linux/tty_flags.h
index fae4864..072e41e 100644
--- a/include/uapi/linux/tty_flags.h
+++ b/include/uapi/linux/tty_flags.h
@@ -15,7 +15,7 @@
 #define ASYNCB_FOURPORT		 1 /* Set OU1, OUT2 per AST Fourport settings */
 #define ASYNCB_SAK		 2 /* Secure Attention Key (Orange book) */
 #define ASYNCB_SPLIT_TERMIOS	 3 /* [x] Separate termios for dialin/callout */
-#define ASYNCB_SPD_HI		 4 /* Use 56000 instead of 38400 bps */
+#define ASYNCB_SPD_HI		 4 /* Use 57600 instead of 38400 bps */
 #define ASYNCB_SPD_VHI		 5 /* Use 115200 instead of 38400 bps */
 #define ASYNCB_SKIP_TEST	 6 /* Skip UART test during autoconfiguration */
 #define ASYNCB_AUTO_IRQ		 7 /* Do automatic IRQ during
-- 
1.9.1
