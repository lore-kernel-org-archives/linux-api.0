From: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
Subject: [RFC PATCH 12/18] lockd: Convert the central lockd service to kthread_iterant API
Date: Fri,  5 Jun 2015 17:01:11 +0200
Message-ID: <1433516477-5153-13-git-send-email-pmladek@suse.cz>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433516477-5153-1-git-send-email-pmladek-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The new iterant kthread API allows to define a common checkpoint for
freezing, parking, termination, and even signal handling. It will allow
to maintain kthreads more easily and make the operations more reliable.

The kthread function is split into optional init(), func(), destroy() parts
where func() is called in a cycle. The common check point is after
each func() function finishes. See kthread_iterant_fn() for more details.

This patch moves the action associated with the signal into a proper
signal handler.

It removes the obsolete set_freezable() call because iterant kthreads
are freezable by default.

struct kthread_iterant is stored into struct svc_rqst. We have already
stored there the pointer to the related task_struct.

The rest is just shuffling the code from the while cycle into _func().

Signed-off-by: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
---
 fs/lockd/svc.c             | 80 ++++++++++++++++++++++++----------------------
 include/linux/sunrpc/svc.h |  2 ++
 2 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 55505cbe11af..5b1efe509fcc 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -122,58 +122,55 @@ static void restart_grace(void)
 }
 
 /*
- * This is the lockd kernel thread
+ * Lockd kernel thread implementation using the iterant API
+ * We don't terminate until the last NFS mount or NFS daemon
+ * has gone away.
  */
-static int
-lockd(void *vrqstp)
+static void lockd_sigkill(int sig)
 {
-	int		err = 0;
-	struct svc_rqst *rqstp = vrqstp;
-
-	/* try_to_freeze() is called from svc_recv() */
-	set_freezable();
+	restart_grace();
+}
 
+static void lockd_init(void *vrqstp)
+{
 	/* Allow SIGKILL to tell lockd to drop all of its locks */
-	allow_signal(SIGKILL);
+	kthread_sigaction(SIGKILL, lockd_sigkill);
 
 	dprintk("NFS locking service started (ver " LOCKD_VERSION ").\n");
+}
 
-	/*
-	 * The main request loop. We don't terminate until the last
-	 * NFS mount or NFS daemon has gone away.
-	 */
-	while (!kthread_should_stop()) {
-		long timeout = MAX_SCHEDULE_TIMEOUT;
-		RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
+static void lockd_func(void *vrqstp)
+{
+	int err = 0;
+	struct svc_rqst *rqstp = vrqstp;
 
-		/* update sv_maxconn if it has changed */
-		rqstp->rq_server->sv_maxconn = nlm_max_connections;
+	long timeout = MAX_SCHEDULE_TIMEOUT;
+	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
 
-		if (signalled()) {
-			flush_signals(current);
-			restart_grace();
-			continue;
-		}
+	/* update sv_maxconn if it has changed */
+	rqstp->rq_server->sv_maxconn = nlm_max_connections;
 
-		timeout = nlmsvc_retry_blocked();
+	timeout = nlmsvc_retry_blocked();
 
-		/*
-		 * Find a socket with data available and call its
-		 * recvfrom routine.
-		 */
-		err = svc_recv(rqstp, timeout);
-		if (err == -EAGAIN || err == -EINTR)
-			continue;
-		dprintk("lockd: request from %s\n",
-				svc_print_addr(rqstp, buf, sizeof(buf)));
+	/*
+	 * Find a socket with data available and call its
+	 * recvfrom routine.
+	 */
+	err = svc_recv(rqstp, timeout);
+	if (err == -EAGAIN || err == -EINTR)
+		return;
 
-		svc_process(rqstp);
-	}
-	flush_signals(current);
+	dprintk("lockd: request from %s\n",
+		svc_print_addr(rqstp, buf, sizeof(buf)));
+
+	svc_process(rqstp);
+}
+
+static void lockd_destroy(void *vrqstp)
+{
 	if (nlmsvc_ops)
 		nlmsvc_invalidate_all();
 	nlm_shutdown_hosts();
-	return 0;
 }
 
 static int create_lockd_listener(struct svc_serv *serv, const char *name,
@@ -301,7 +298,14 @@ static int lockd_start_svc(struct svc_serv *serv)
 	svc_sock_update_bufs(serv);
 	serv->sv_maxconn = nlm_max_connections;
 
-	nlmsvc_task = kthread_create(lockd, nlmsvc_rqst, "%s", serv->sv_name);
+	nlmsvc_rqst->rq_kti.type = 0;
+	nlmsvc_rqst->rq_kti.data = nlmsvc_rqst;
+	nlmsvc_rqst->rq_kti.init = lockd_init;
+	nlmsvc_rqst->rq_kti.func = lockd_func;
+	nlmsvc_rqst->rq_kti.destroy = lockd_destroy;
+
+	nlmsvc_task = kthread_iterant_create(&nlmsvc_rqst->rq_kti,
+					     "%s", serv->sv_name);
 	if (IS_ERR(nlmsvc_task)) {
 		error = PTR_ERR(nlmsvc_task);
 		printk(KERN_WARNING
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index fae6fb947fc8..6275e9b9df9b 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -16,6 +16,7 @@
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/auth.h>
 #include <linux/sunrpc/svcauth.h>
+#include <linux/kthread.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
 
@@ -283,6 +284,7 @@ struct svc_rqst {
 	struct auth_domain *	rq_client;	/* RPC peer info */
 	struct auth_domain *	rq_gssclient;	/* "gss/"-style peer info */
 	struct svc_cacherep *	rq_cacherep;	/* cache info */
+	struct kthread_iterant  rq_kti;		/* info for iterant kthread */
 	struct task_struct	*rq_task;	/* service thread */
 	spinlock_t		rq_lock;	/* per-request lock */
 };
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
