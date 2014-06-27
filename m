From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v9 02/11] seccomp: extract check/assign mode helpers
Date: Fri, 27 Jun 2014 16:22:51 -0700
Message-ID: <1403911380-27787-3-git-send-email-keescook@chromium.org>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403911380-27787-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

To support splitting mode 1 from mode 2, extract the mode checking and
assignment logic into common functions.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/seccomp.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index afb916c7e890..03a5959b7930 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -194,7 +194,23 @@ static u32 seccomp_run_filters(int syscall)
 	}
 	return ret;
 }
+#endif /* CONFIG_SECCOMP_FILTER */
 
+static inline bool seccomp_check_mode(unsigned long seccomp_mode)
+{
+	if (current->seccomp.mode && current->seccomp.mode != seccomp_mode)
+		return false;
+
+	return true;
+}
+
+static inline void seccomp_assign_mode(unsigned long seccomp_mode)
+{
+	current->seccomp.mode = seccomp_mode;
+	set_tsk_thread_flag(current, TIF_SECCOMP);
+}
+
+#ifdef CONFIG_SECCOMP_FILTER
 /**
  * seccomp_attach_filter: Attaches a seccomp filter to current.
  * @fprog: BPF program to install
@@ -490,8 +506,7 @@ static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
 {
 	long ret = -EINVAL;
 
-	if (current->seccomp.mode &&
-	    current->seccomp.mode != seccomp_mode)
+	if (!seccomp_check_mode(seccomp_mode))
 		goto out;
 
 	switch (seccomp_mode) {
@@ -512,8 +527,7 @@ static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
 		goto out;
 	}
 
-	current->seccomp.mode = seccomp_mode;
-	set_thread_flag(TIF_SECCOMP);
+	seccomp_assign_mode(seccomp_mode);
 out:
 	return ret;
 }
-- 
1.7.9.5
