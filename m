From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v12 02/11] seccomp: extract check/assign mode helpers
Date: Thu, 17 Jul 2014 11:08:29 -0700
Message-ID: <1405620518-18495-3-git-send-email-keescook@chromium.org>
References: <1405620518-18495-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1405620518-18495-1-git-send-email-keescook@chromium.org>
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
Cc: linux-arch@vger.kernel.org, linux-mips@linux-mips.org, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, x86@kernel.org, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, linux-security-module@vger.kernel.org, Julien Tinnes <jln@chromium.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, James Morris <james.l.morris@oracle.com>, David Drysdale <drysdale@google.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

To support splitting mode 1 from mode 2, extract the mode checking and
assignment logic into common functions.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/seccomp.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index afb916c7e890..9df7def86c3b 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -194,7 +194,23 @@ static u32 seccomp_run_filters(int syscall)
 	}
 	return ret;
 }
+#endif /* CONFIG_SECCOMP_FILTER */
 
+static inline bool seccomp_may_assign_mode(unsigned long seccomp_mode)
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
+	if (!seccomp_may_assign_mode(seccomp_mode))
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
