From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 4/4] arm64/syscalls: Move address limit check in loop
Date: Thu,  7 Sep 2017 08:30:47 -0700
Message-ID: <1504798247-48833-5-git-send-email-keescook@chromium.org>
References: <1504798247-48833-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504798247-48833-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Dave Martin <Dave.Martin@arm.com>, Pratyush Anand <panand@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Yonghong Song <yhs@fb.com>, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Thomas Garnier <thgarnie@google.com>

A bug was reported on ARM where set_fs might be called after it was
checked on the work pending function. ARM64 is not affected by this bug
but has a similar construct. In order to avoid any similar problems in
the future, the addr_limit_user_check function is moved at the beginning
of the loop.

Fixes: cf7de27ab351 ("arm64/syscalls: Check address limit on user-mode return")
Reported-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
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
2.7.4
