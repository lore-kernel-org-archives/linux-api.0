From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/4] syscalls: Use CHECK_DATA_CORRUPTION for addr_limit_user_check
Date: Thu,  7 Sep 2017 08:30:44 -0700
Message-ID: <1504798247-48833-2-git-send-email-keescook@chromium.org>
References: <1504798247-48833-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504798247-48833-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Dave Martin <Dave.Martin@arm.com>, Pratyush Anand <panand@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Yonghong Song <yhs@fb.com>, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Thomas Garnier <thgarnie@google.com>

Use CHECK_DATA_CORRUPTION instead of BUG_ON to provide more flexibility
on address limit failures. By default, send a SIGKILL signal to kill the
current process preventing exploitation of a bad address limit.

Make the TIF_FSCHECK flag optional so ARM can use this function.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/syscalls.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 88951b795ee3..65e273aadada 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -219,21 +219,25 @@ static inline int is_syscall_trace_event(struct trace_event_call *tp_event)
 	}								\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
-#ifdef TIF_FSCHECK
 /*
  * Called before coming back to user-mode. Returning to user-mode with an
  * address limit different than USER_DS can allow to overwrite kernel memory.
  */
 static inline void addr_limit_user_check(void)
 {
-
+#ifdef TIF_FSCHECK
 	if (!test_thread_flag(TIF_FSCHECK))
 		return;
+#endif
 
-	BUG_ON(!segment_eq(get_fs(), USER_DS));
+	if (CHECK_DATA_CORRUPTION(!segment_eq(get_fs(), USER_DS),
+				  "Invalid address limit on user-mode return"))
+		force_sig(SIGKILL, current);
+
+#ifdef TIF_FSCHECK
 	clear_thread_flag(TIF_FSCHECK);
-}
 #endif
+}
 
 asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
 			       qid_t id, void __user *addr);
-- 
2.7.4
