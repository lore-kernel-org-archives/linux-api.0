From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v4 2/4] seccomp: make get_nth_filter available outside of CHECKPOINT_RESTORE
Date: Thu, 21 Jun 2018 16:04:14 -0600
Message-ID: <20180621220416.5412-3-tycho@tycho.ws>
References: <20180621220416.5412-1-tycho@tycho.ws>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621220416.5412-1-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, "Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

In the next commit we'll use this same mnemonic to get a listener for the
nth filter, so we need it available outside of CHECKPOINT_RESTORE. This is
slightly looser than necessary, because it really could be
CHECKPOINT_RESTORE || USER_NOTIFICATION, but it's declared static and this
complicates the code less, so hopefully it's ok.

v2: new in v2
v3: no changes

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
CC: Kees Cook <keescook@chromium.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Eric W. Biederman <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>
CC: Christian Brauner <christian.brauner@ubuntu.com>
CC: Tyler Hicks <tyhicks@canonical.com>
CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
---
 kernel/seccomp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 24949478a812..bbc24938c51d 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1184,7 +1184,7 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
 	return do_seccomp(op, 0, uargs);
 }
 
-#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
+#if defined(CONFIG_SECCOMP_FILTER)
 static struct seccomp_filter *get_nth_filter(struct task_struct *task,
 					     unsigned long filter_off)
 {
@@ -1231,6 +1231,7 @@ static struct seccomp_filter *get_nth_filter(struct task_struct *task,
 	return filter;
 }
 
+#if defined(CONFIG_CHECKPOINT_RESTORE)
 long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
 			void __user *data)
 {
@@ -1303,7 +1304,8 @@ long seccomp_get_metadata(struct task_struct *task,
 	__put_seccomp_filter(filter);
 	return ret;
 }
-#endif
+#endif /* CONFIG_CHECKPOINT_RESTORE */
+#endif /* CONFIG_SECCOMP_FILTER */
 
 #ifdef CONFIG_SYSCTL
 
-- 
2.17.1
