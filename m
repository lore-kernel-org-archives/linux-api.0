From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 1/9] seccomp: create internal mode-setting function
Date: Tue, 10 Jun 2014 20:25:13 -0700
Message-ID: <1402457121-8410-2-git-send-email-keescook@chromium.org>
References: <1402457121-8410-1-git-send-email-keescook@chromium.org>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1402457121-8410-1-git-send-email-keescook@chromium.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Alexei Starovoitov <ast@plumgrid.com>, John Johansen <john.johansen@canonical.com>, Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

In preparation for having other callers of the seccomp mode setting
logic, split the prctl entry point away from the core logic that performs
seccomp mode setting.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/seccomp.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index f6d76bebe69f..552b972b8f83 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -465,7 +465,7 @@ long prctl_get_seccomp(void)
 }
 
 /**
- * prctl_set_seccomp: configures current->seccomp.mode
+ * seccomp_set_mode: internal function for setting seccomp mode
  * @seccomp_mode: requested mode to use
  * @filter: optional struct sock_fprog for use with SECCOMP_MODE_FILTER
  *
@@ -478,7 +478,7 @@ long prctl_get_seccomp(void)
  *
  * Returns 0 on success or -EINVAL on failure.
  */
-long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
+static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
 {
 	long ret = -EINVAL;
 
@@ -509,3 +509,15 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
 out:
 	return ret;
 }
+
+/**
+ * prctl_set_seccomp: configures current->seccomp.mode
+ * @seccomp_mode: requested mode to use
+ * @filter: optional struct sock_fprog for use with SECCOMP_MODE_FILTER
+ *
+ * Returns 0 on success or -EINVAL on failure.
+ */
+long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
+{
+	return seccomp_set_mode(seccomp_mode, filter);
+}
-- 
1.7.9.5
