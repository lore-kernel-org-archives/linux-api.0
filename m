From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 09/26] signal: Don't allow sending SIGKILL or SIGSTOP to init
Date: Tue,  6 Jun 2017 14:03:21 -0500
Message-ID: <20170606190338.28347-9-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Even to init SIGKILL and SIGSTOP are alwasys delivered if they are
sent, so don't allow tracing an init task allow them.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 5eff2f9f8c42..627b482fa3f8 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -98,8 +98,12 @@ static int sig_ignored(struct task_struct *t, int sig, bool force)
 
 	/*
 	 * Tracers may want to know about even ignored signals.
+	 * We can never safely allow SIGKILL or SIGSTOP to
+	 * be sent to init from it's children.
 	 */
-	return !t->ptrace;
+	return !t->ptrace ||
+		((t->signal->flags & SIGNAL_UNKILLABLE) &&
+		 sig_kernel_only(sig) && !force);
 }
 
 /*
-- 
2.10.1
