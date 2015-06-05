From: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
Subject: [RFC PATCH 08/18] kthread: Allow to get struct kthread_iterant from task_struct
Date: Fri,  5 Jun 2015 17:01:07 +0200
Message-ID: <1433516477-5153-9-git-send-email-pmladek@suse.cz>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433516477-5153-1-git-send-email-pmladek-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

It is easy to make a mistake when one implements sleeping between kthread
iterations. We will want to do it a more uniform way. For this we will
want to set some flags in struct kthread_iterant from the current
task (kthread). This patch adds the basic infrastructure to make
it possible.

Signed-off-by: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
---
 kernel/kthread.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index e34f67cb8ecf..41fb6a43a1f1 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -44,6 +44,7 @@ struct kthread {
 	void *data;
 	struct completion parked;
 	struct completion exited;
+	struct kthread_iterant *kti;
 };
 
 enum KTHREAD_BITS {
@@ -69,6 +70,11 @@ static struct kthread *to_live_kthread(struct task_struct *k)
 	return NULL;
 }
 
+static struct kthread_iterant *to_kthread_iterant(struct task_struct *k)
+{
+	return __to_kthread(k->vfork_done)->kti;
+}
+
 /**
  * kthread_stop_current - make the current kthread to terminate a safe way
  *
@@ -199,6 +205,7 @@ static int kthread(void *_create)
 	self.data = data;
 	init_completion(&self.exited);
 	init_completion(&self.parked);
+	self.kti = NULL;
 	current->vfork_done = &self.exited;
 
 	/* If user was SIGKILLed, I release the structure. */
@@ -421,9 +428,12 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
  */
 static int kthread_iterant_fn(void *kti_ptr)
 {
+	struct kthread *kt = to_kthread(current);
 	struct kthread_iterant *kti = kti_ptr;
 	void *data = kti->data;
 
+	kt->kti = kti;
+
 	set_freezable();
 
 	if (kti->init)
-- 
1.8.5.6
