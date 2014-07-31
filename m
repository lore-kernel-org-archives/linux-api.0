From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 5/5] include/linux/interrupt.h: Require designated
 initialization of structures
Date: Thu, 31 Jul 2014 16:48:08 -0700
Message-ID: <93a72e881cbdf060f6aefa16f0ac01f546eace4f.1406850006.git.josh@joshtriplett.org>
References: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>, Ingo Molnar <mingo@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Michal Marek <mmarek@suse.cz>, Neil Brown <neilb@suse.de>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-sparse@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fix the corresponding tasklet initialization macros to use designated
initializers, which simplifies those initializers using the default
initialization of fields to 0.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/interrupt.h | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 698ad05..559ef98 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -217,7 +217,7 @@ struct irq_affinity_notify {
 	struct work_struct work;
 	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
 	void (*release)(struct kref *ref);
-};
+} __designated_init;
 
 #if defined(CONFIG_SMP)
 
@@ -419,7 +419,7 @@ extern const char * const softirq_to_name[NR_SOFTIRQS];
 struct softirq_action
 {
 	void	(*action)(struct softirq_action *);
-};
+} __designated_init;
 
 asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
@@ -474,14 +474,21 @@ struct tasklet_struct
 	atomic_t count;
 	void (*func)(unsigned long);
 	unsigned long data;
-};
-
-#define DECLARE_TASKLET(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
+} __designated_init;
 
-#define DECLARE_TASKLET_DISABLED(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
+#define DECLARE_TASKLET(name, tsfunc, tsdata) \
+struct tasklet_struct name = {		\
+	.count = ATOMIC_INIT(0),	\
+	.func = tsfunc,			\
+	.data = tsdata,			\
+}
 
+#define DECLARE_TASKLET_DISABLED(name, tsfunc, tsdata) \
+struct tasklet_struct name = {		\
+	.count = ATOMIC_INIT(1),	\
+	.func = tsfunc,			\
+	.data = tsdata,			\
+}
 
 enum
 {
@@ -576,7 +583,7 @@ struct tasklet_hrtimer {
 	struct hrtimer		timer;
 	struct tasklet_struct	tasklet;
 	enum hrtimer_restart	(*function)(struct hrtimer *);
-};
+} __designated_init;
 
 extern void
 tasklet_hrtimer_init(struct tasklet_hrtimer *ttimer,
-- 
2.0.1
