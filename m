From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v8 4/9] sched: move no_new_privs into new atomic flags
Date: Tue, 24 Jun 2014 13:48:08 -0700
Message-ID: <1403642893-23107-5-git-send-email-keescook@chromium.org>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1403642893-23107-1-git-send-email-keescook@chromium.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Since seccomp transitions between threads requires updates to the
no_new_privs flag to be atomic, the flag must be part of an atomic flag
set. This moves the nnp flag into a separate task field, and introduces
accessors.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/exec.c                  |    4 ++--
 include/linux/sched.h      |   16 ++++++++++++++--
 kernel/seccomp.c           |    2 +-
 kernel/sys.c               |    4 ++--
 security/apparmor/domain.c |    4 ++--
 5 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a3d33fe592d6..0f5c272410f6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1234,7 +1234,7 @@ static void check_unsafe_exec(struct linux_binprm *bprm)
 	 * This isn't strictly necessary, but it makes it harder for LSMs to
 	 * mess up.
 	 */
-	if (current->no_new_privs)
+	if (task_no_new_privs(current))
 		bprm->unsafe |= LSM_UNSAFE_NO_NEW_PRIVS;
 
 	t = p;
@@ -1272,7 +1272,7 @@ int prepare_binprm(struct linux_binprm *bprm)
 	bprm->cred->egid = current_egid();
 
 	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) &&
-	    !current->no_new_privs &&
+	    !task_no_new_privs(current) &&
 	    kuid_has_mapping(bprm->cred->user_ns, inode->i_uid) &&
 	    kgid_has_mapping(bprm->cred->user_ns, inode->i_gid)) {
 		/* Set-uid? */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0c987a..0c6917fbd8d4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1307,8 +1307,7 @@ struct task_struct {
 				 * execve */
 	unsigned in_iowait:1;
 
-	/* task may not gain privileges */
-	unsigned no_new_privs:1;
+	unsigned long atomic_flags; /* Flags needing atomic access. */
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
@@ -1967,6 +1966,19 @@ static inline void memalloc_noio_restore(unsigned int flags)
 	current->flags = (current->flags & ~PF_MEMALLOC_NOIO) | flags;
 }
 
+/* Per-process atomic flags. */
+#define PFA_NO_NEW_PRIVS 0x00000001	/* May not gain new privileges. */
+
+static inline bool task_no_new_privs(struct task_struct *p)
+{
+	return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
+}
+
+static inline void task_set_no_new_privs(struct task_struct *p)
+{
+	set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
+}
+
 /*
  * task->jobctl flags
  */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 405eb72dfe35..eb8248ab045e 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -218,7 +218,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
 	 * This avoids scenarios where unprivileged tasks can affect the
 	 * behavior of privileged children.
 	 */
-	if (!current->no_new_privs &&
+	if (!task_no_new_privs(current) &&
 	    security_capable_noaudit(current_cred(), current_user_ns(),
 				     CAP_SYS_ADMIN) != 0)
 		return ERR_PTR(-EACCES);
diff --git a/kernel/sys.c b/kernel/sys.c
index 66a751ebf9d9..ce8129192a26 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1990,12 +1990,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg2 != 1 || arg3 || arg4 || arg5)
 			return -EINVAL;
 
-		current->no_new_privs = 1;
+		task_set_no_new_privs(current);
 		break;
 	case PR_GET_NO_NEW_PRIVS:
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
-		return current->no_new_privs ? 1 : 0;
+		return task_no_new_privs(current) ? 1 : 0;
 	case PR_GET_THP_DISABLE:
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 452567d3a08e..d97cba3e3849 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -621,7 +621,7 @@ int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
 	 * There is no exception for unconfined as change_hat is not
 	 * available.
 	 */
-	if (current->no_new_privs)
+	if (task_no_new_privs(current))
 		return -EPERM;
 
 	/* released below */
@@ -776,7 +776,7 @@ int aa_change_profile(const char *ns_name, const char *hname, bool onexec,
 	 * no_new_privs is set because this aways results in a reduction
 	 * of permissions.
 	 */
-	if (current->no_new_privs && !unconfined(profile)) {
+	if (task_no_new_privs(current) && !unconfined(profile)) {
 		put_cred(cred);
 		return -EPERM;
 	}
-- 
1.7.9.5
