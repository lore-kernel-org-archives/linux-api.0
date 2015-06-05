From: Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 03/18] kthread: Add kthread_stop_current()
Date: Fri,  5 Jun 2015 17:01:02 +0200
Message-ID: <1433516477-5153-4-git-send-email-pmladek@suse.cz>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-nfs@vger.kernel.org, Borislav Petkov <bp@suse.de>, Jiri Kosina <jkosina@suse.cz>, Richard Weinberger <richard@nod.at>, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Michal Hocko <mhocko@suse.cz>, Chris Mason <clm@fb.com>, Petr Mladek <pmladek@suse.cz>, linux-mtd@lists.infradead.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, live-patching@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Woodhouse <dwmw2@infradead.org>, Anna Schumaker <anna.schumaker@netapp.com>
List-Id: linux-api@vger.kernel.org

For example, jffs2_gcd_mtd kthread can be stopped by SIGKILL.
The signal is handled inside the main function.

We would like to convert such kthreads to the iterant API
and use proper signal handlers.

The new functions will allow to pass the information
between the signal handler and the main kthread functions.

kthread_stop_current() allows to quit the kthread correctly.
It means to leave the main cycle on a safe point and call
clean up actions via post() function.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 include/linux/kthread.h |  1 +
 kernel/kthread.c        | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 06fe9ad192dd..100c1e006729 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -86,6 +86,7 @@ kthread_iterant_create_on_cpu(struct kthread_iterant *kti,
 })
 
 void kthread_bind(struct task_struct *k, unsigned int cpu);
+void kthread_stop_current(void);
 int kthread_stop(struct task_struct *k);
 bool kthread_should_stop(void);
 bool kthread_should_park(void);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 4b2698bcc622..688bb4cfd807 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -70,6 +70,19 @@ static struct kthread *to_live_kthread(struct task_struct *k)
 }
 
 /**
+ * kthread_stop_current - make the current kthread to terminate a safe way
+ *
+ * This function sets KTHREAD_SHOULD_STOP flags. It makes kthread to break
+ * the main loop and do some clean up actions before the main kthread
+ * function finishes. It is the standard behavior for SIGTERM signal.
+ */
+void kthread_stop_current(void)
+{
+	set_bit(KTHREAD_SHOULD_STOP, &to_kthread(current)->flags);
+}
+EXPORT_SYMBOL(kthread_stop_current);
+
+/**
  * kthread_should_stop - should this kthread return now?
  *
  * When someone calls kthread_stop() on your kthread, it will be woken
-- 
1.8.5.6


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
