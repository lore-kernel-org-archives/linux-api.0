From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 4/4] arm64/syscalls: Move address limit check in loop
Date: Mon, 14 Aug 2017 14:37:32 -0700
Message-ID: <20170814213732.104301-4-thgarnie@google.com>
References: <20170814213732.104301-1-thgarnie@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170814213732.104301-1-thgarnie@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Thomas Garnier <thgarnie@google.com>, Yonghong Song <yhs@fb.com>, David Howells <dhowells@redhat.com>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Dave Martin <Dave.Martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

A bug was reported on ARM where set_fs might be called after it was
checked on the work pending function. ARM64 is not affected by this bug
but has a similar construct. In order to avoid any similar problems in
the future, the addr_limit_user_check function is moved at the beginning
of the loop.

Fixes: cf7de27ab351 ("arm64/syscalls: Check address limit on user-mode return")
Reported-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/arm64/kernel/signal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index c45214f8fb54..0bdc96c61bc0 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -751,10 +751,10 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 	 */
 	trace_hardirqs_off();
 
-	/* Check valid user FS if needed */
-	addr_limit_user_check();
-
 	do {
+		/* Check valid user FS if needed */
+		addr_limit_user_check();
+
 		if (thread_flags & _TIF_NEED_RESCHED) {
 			schedule();
 		} else {
-- 
2.14.1.480.gb18f417b89-goog
