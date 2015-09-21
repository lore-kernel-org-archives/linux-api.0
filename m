From: Petr Mladek <pmladek@suse.com>
Subject: [RFC v2 16/18] rcu: Check actual RCU_GP_FLAG_FQS when handling quiescent state
Date: Mon, 21 Sep 2015 15:03:57 +0200
Message-ID: <1442840639-6963-17-git-send-email-pmladek@suse.com>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1442840639-6963-1-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-api@vger.kernel.org

This change will help a lot if we want to split RCU kthreads into
few kthread works.

The variable "qf" was added by the commit 88d6df612cc3c99f56 ("rcu: Prevent
spurious-wakeup DoS attack on rcu_gp_kthread()"). IMHO, the primary fix
is the "ret" handling.

If I read the code correctly, RCU_GP_FLAG_FQS should not get lost
at this stage. rsp->gp_flags are written in these functions:

  + rcu_gp_init()
  + rcu_gp_cleanup()
    + Both are safe. They are called from other part of the kthread
      that can't get accessed when "gf" is used.

  + rcu_gp_fqs()
    + Safe. It is the function that we call when the flag is set.

  + rcu_report_qs_rsp()
  + force_quiescent_state()
    + Both should be safe. They set RCU_GP_FLAG_FQS and therefore they
      could not cause loss of rcu_gp_fqs() call.

  + rcu_start_gp_advanced()
    + This should be safe. It is called only when the last grace period
      was completed and we are opening a new one. Therefore it should
      not happen when "gf" is set and tested because the grace period
      is closed by the kthread.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/rcu/tree.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 286e300794f0..08d1d3e63b9b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1908,13 +1908,12 @@ static int rcu_gp_init(struct rcu_state *rsp)
  * Helper function for wait_event_interruptible_timeout() wakeup
  * at force-quiescent-state time.
  */
-static bool rcu_gp_fqs_check_wake(struct rcu_state *rsp, int *gfp)
+static bool rcu_gp_fqs_check_wake(struct rcu_state *rsp)
 {
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Someone like call_rcu() requested a force-quiescent-state scan. */
-	*gfp = READ_ONCE(rsp->gp_flags);
-	if (*gfp & RCU_GP_FLAG_FQS)
+	if (READ_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS)
 		return true;
 
 	/* The current grace period has completed. */
@@ -2072,7 +2071,6 @@ static unsigned long normalize_jiffies_till_next_fqs(void)
  */
 static int __noreturn rcu_gp_kthread(void *arg)
 {
-	int gf;
 	unsigned long timeout, j;
 	struct rcu_state *rsp = arg;
 	struct rcu_node *rnp = rcu_get_root(rsp);
@@ -2111,7 +2109,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 					       TPS("fqswait"));
 			rsp->gp_state = RCU_GP_WAIT_FQS;
 			wait_event_interruptible_timeout(rsp->gp_wq,
-					rcu_gp_fqs_check_wake(rsp, &gf),
+					rcu_gp_fqs_check_wake(rsp),
 					timeout);
 			rsp->gp_state = RCU_GP_DOING_FQS;
 try_again:
@@ -2122,7 +2120,7 @@ try_again:
 				break;
 			/* If time for quiescent-state forcing, do it. */
 			if (ULONG_CMP_GE(jiffies, rsp->jiffies_force_qs) ||
-			    (gf & RCU_GP_FLAG_FQS)) {
+			    (READ_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS)) {
 				trace_rcu_grace_period(rsp->name,
 						       READ_ONCE(rsp->gpnum),
 						       TPS("fqsstart"));
-- 
1.8.5.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
