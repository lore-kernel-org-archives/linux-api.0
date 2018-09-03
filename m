From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 06/10] signal: Remove the siginfo paramater from kernel_dqueue_signal
Date: Mon,  3 Sep 2018 22:44:26 +0200
Message-ID: <20180903204430.25473-6-ebiederm@xmission.com>
References: <87musyl3fa.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87musyl3fa.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

None of the callers use the it so remove it.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/usb/gadget/function/f_mass_storage.c | 2 +-
 fs/jffs2/background.c                        | 2 +-
 include/linux/sched/signal.h                 | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index ca8a4b53c59f..70038a475c9f 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2311,7 +2311,7 @@ static void handle_exception(struct fsg_common *common)
 	 * into a high-priority EXIT exception.
 	 */
 	for (;;) {
-		int sig = kernel_dequeue_signal(NULL);
+		int sig = kernel_dequeue_signal();
 		if (!sig)
 			break;
 		if (sig != SIGUSR1) {
diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
index 453a6a1fff34..2b4d5013dc5d 100644
--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -125,7 +125,7 @@ static int jffs2_garbage_collect_thread(void *_c)
 			if (try_to_freeze())
 				goto again;
 
-			signr = kernel_dequeue_signal(NULL);
+			signr = kernel_dequeue_signal();
 
 			switch(signr) {
 			case SIGSTOP:
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 1be35729c2c5..9b6968cbde14 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -272,14 +272,14 @@ extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
 extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
 
-static inline int kernel_dequeue_signal(siginfo_t *info)
+static inline int kernel_dequeue_signal(void)
 {
 	struct task_struct *tsk = current;
 	siginfo_t __info;
 	int ret;
 
 	spin_lock_irq(&tsk->sighand->siglock);
-	ret = dequeue_signal(tsk, &tsk->blocked, info ?: &__info);
+	ret = dequeue_signal(tsk, &tsk->blocked, &__info);
 	spin_unlock_irq(&tsk->sighand->siglock);
 
 	return ret;
-- 
2.17.1
