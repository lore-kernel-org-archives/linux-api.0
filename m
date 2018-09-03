From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 08/10] signal: Never allocate siginfo for SIGKILL or SIGSTOP
Date: Mon,  3 Sep 2018 22:44:28 +0200
Message-ID: <20180903204430.25473-8-ebiederm@xmission.com>
References: <87musyl3fa.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87musyl3fa.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

The SIGKILL and SIGSTOP signals are never delivered to userspace so
queued siginfo for these signals can never be observed.  Therefore
remove the chance of failure by never even attempting to allocate
siginfo in those cases.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 20931a892ace..d7d1adf735f4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1054,10 +1054,11 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 
 	result = TRACE_SIGNAL_DELIVERED;
 	/*
-	 * fast-pathed signals for kernel-internal things like SIGSTOP
-	 * or SIGKILL.
+	 * Skip useless siginfo allocation for SIGKILL SIGSTOP,
+	 * and kernel threads.
 	 */
-	if ((info == SEND_SIG_FORCED) || (t->flags & PF_KTHREAD))
+	if ((info == SEND_SIG_FORCED) ||
+	    sig_kernel_only(sig) || (t->flags & PF_KTHREAD))
 		goto out_set;
 
 	/*
-- 
2.17.1
