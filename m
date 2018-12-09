From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v10 2/4] seccomp: switch system call argument type to void *
Date: Sun,  9 Dec 2018 11:24:12 -0700
Message-ID: <20181209182414.30862-3-tycho@tycho.ws>
References: <20181209182414.30862-1-tycho@tycho.ws>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181209182414.30862-1-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

The const qualifier causes problems for any code that wants to write to the
third argument of the seccomp syscall, as we will do in a future patch in
this series.

The third argument to the seccomp syscall is documented as void *, so
rather than just dropping the const, let's switch everything to use void *
as well.

I believe this is safe because of 1. the documentation above, 2. there's no
real type information exported about syscalls anywhere besides the man
pages.

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
CC: Kees Cook <keescook@chromium.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Eric W. Biederman <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
CC: Christian Brauner <christian@brauner.io>
CC: Tyler Hicks <tyhicks@canonical.com>
CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
---
v10: change type in include/linux/syscalls.h too to avoid compilation error
     in the !CONFIG_ARCH_HAS_SYSCALL_WRAPPER case
---
 include/linux/seccomp.h  | 2 +-
 include/linux/syscalls.h | 2 +-
 kernel/seccomp.c         | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index e5320f6c8654..b5103c019cf4 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -43,7 +43,7 @@ extern void secure_computing_strict(int this_syscall);
 #endif
 
 extern long prctl_get_seccomp(void);
-extern long prctl_set_seccomp(unsigned long, char __user *);
+extern long prctl_set_seccomp(unsigned long, void __user *);
 
 static inline int seccomp_mode(struct seccomp *s)
 {
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 2ac3d13a915b..a60694fb0f58 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -879,7 +879,7 @@ asmlinkage long sys_renameat2(int olddfd, const char __user *oldname,
 			      int newdfd, const char __user *newname,
 			      unsigned int flags);
 asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
-			    const char __user *uargs);
+			    void __user *uargs);
 asmlinkage long sys_getrandom(char __user *buf, size_t count,
 			      unsigned int flags);
 asmlinkage long sys_memfd_create(const char __user *uname_ptr, unsigned int flags);
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 96afc32e041d..393e029f778a 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -924,7 +924,7 @@ static long seccomp_get_action_avail(const char __user *uaction)
 
 /* Common entry point for both prctl and syscall. */
 static long do_seccomp(unsigned int op, unsigned int flags,
-		       const char __user *uargs)
+		       void __user *uargs)
 {
 	switch (op) {
 	case SECCOMP_SET_MODE_STRICT:
@@ -944,7 +944,7 @@ static long do_seccomp(unsigned int op, unsigned int flags,
 }
 
 SYSCALL_DEFINE3(seccomp, unsigned int, op, unsigned int, flags,
-			 const char __user *, uargs)
+			 void __user *, uargs)
 {
 	return do_seccomp(op, flags, uargs);
 }
@@ -956,10 +956,10 @@ SYSCALL_DEFINE3(seccomp, unsigned int, op, unsigned int, flags,
  *
  * Returns 0 on success or -EINVAL on failure.
  */
-long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
+long prctl_set_seccomp(unsigned long seccomp_mode, void __user *filter)
 {
 	unsigned int op;
-	char __user *uargs;
+	void __user *uargs;
 
 	switch (seccomp_mode) {
 	case SECCOMP_MODE_STRICT:
-- 
2.19.1
