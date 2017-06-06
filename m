From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 04/26] signal: Make group_send_sig_info static
Date: Tue,  6 Jun 2017 14:03:16 -0500
Message-ID: <20170606190338.28347-4-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

It has no users outside of kernel/signal.c

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/signal.h | 1 -
 kernel/signal.c        | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index 1f5a16620693..f1b296a5e537 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -244,7 +244,6 @@ struct pt_regs;
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
 extern int do_send_sig_info(int sig, struct siginfo *info,
 				struct task_struct *p, bool group);
-extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
 extern int do_sigtimedwait(const sigset_t *, siginfo_t *,
 				const struct timespec *);
diff --git a/kernel/signal.c b/kernel/signal.c
index ca92bcfeb322..5eff2f9f8c42 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1262,6 +1262,7 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 /*
  * send signal info to all the members of a group
  */
+static
 int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
 	int ret;
-- 
2.10.1
