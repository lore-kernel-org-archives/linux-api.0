From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v11 01/11] seccomp: create internal mode-setting function
Date: Wed, 16 Jul 2014 14:50:32 -0700
Message-ID: <1405547442-26641-2-git-send-email-keescook@chromium.org>
References: <1405547442-26641-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1405547442-26641-1-git-send-email-keescook@chromium.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-mips@linux-mips.org, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, James Morris <jmorris@namei.org>, Oleg Nesterov <oleg@redhat.com>, Daniel Borkmann <dborkman@redhat.com>, Julien Tinnes <jln@chromium.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, David Drysdale <drysdale@google.com>, linux-arm-kernel@lists.infradead.org, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

In preparation for having other callers of the seccomp mode setting
logic, split the prctl entry point away from the core logic that performs
seccomp mode setting.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/seccomp.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 301bbc24739c..afb916c7e890 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -473,7 +473,7 @@ long prctl_get_seccomp(void)
 }
 
 /**
- * prctl_set_seccomp: configures current->seccomp.mode
+ * seccomp_set_mode: internal function for setting seccomp mode
  * @seccomp_mode: requested mode to use
  * @filter: optional struct sock_fprog for use with SECCOMP_MODE_FILTER
  *
@@ -486,7 +486,7 @@ long prctl_get_seccomp(void)
  *
  * Returns 0 on success or -EINVAL on failure.
  */
-long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
+static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
 {
 	long ret = -EINVAL;
 
@@ -517,3 +517,15 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
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
