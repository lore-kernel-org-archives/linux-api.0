From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 07/10] signal: Don't send siginfo to kthreads.
Date: Mon,  3 Sep 2018 22:44:27 +0200
Message-ID: <20180903204430.25473-7-ebiederm@xmission.com>
References: <87musyl3fa.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87musyl3fa.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Today kernel threads never dequeue siginfo so it is pointless to
enqueue siginfo for them.  The usb gadget mass storage driver goes
one farther and uses SEND_SIG_FORCED to guarantee that no siginfo is
even enqueued.

Generalize the optimization of the usb mass storage driver and never
perform an unnecessary allocation when delivering signals to kthreads.

Switch the mass storage driver from sending signals with
SEND_SIG_FORCED to SEND_SIG_PRIV.  As using SEND_SIG_FORCED is now
unnecessary.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/usb/gadget/function/f_mass_storage.c | 2 +-
 kernel/signal.c                              | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 70038a475c9f..cb402e7a1e9b 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -403,7 +403,7 @@ static void raise_exception(struct fsg_common *common, enum fsg_state new_state)
 		common->exception_req_tag = common->ep0_req_tag;
 		common->state = new_state;
 		if (common->thread_task)
-			send_sig_info(SIGUSR1, SEND_SIG_FORCED,
+			send_sig_info(SIGUSR1, SEND_SIG_PRIV,
 				      common->thread_task);
 	}
 	spin_unlock_irqrestore(&common->lock, flags);
diff --git a/kernel/signal.c b/kernel/signal.c
index 8081ab79e97d..20931a892ace 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1057,7 +1057,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.
 	 */
-	if (info == SEND_SIG_FORCED)
+	if ((info == SEND_SIG_FORCED) || (t->flags & PF_KTHREAD))
 		goto out_set;
 
 	/*
-- 
2.17.1
