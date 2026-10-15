Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DDE521235;
	Thu, 15 Oct 2026 12:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068223; cv=none; b=h3BF+aqlqjYnDfuOU5gebJs4xE2onO6fQBEDrPK6hBs3w4j9VsuNloKh+yfkmgULcavJKhmVhNId6CirrF99ZzoIm9hIoAysrQPAk0R3c7xD7BcTjqbF6+CBv4zE6rgqlYl2gs1Ivvx3VWrR7GwWBvl9/RdKrBEkxq56+tiAm9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068223; c=relaxed/simple;
	bh=R5Bf6NUerOr34q8hq/G9ZNFf2mKSQ/r42nrpY5dLtCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPOeqparHKI/wEFG8ltOJqNpo+jP0aqnIcpFqP6PIql73A7P4G8V7pXSkxBsM0fL+nxBCd1/j7MkzmgRGvNmag+LQVTUYzgrzl+C4JUwpSLHanFLMiOnP4wrqSphQXyfPmwHRczLlql09BkBOfb+UzcDct4TYMIYCgJYfGO/320=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tKXS2QKZ; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tKXS2QKZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792068215; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=HqTr5mLb8xecvyl345QTEJXIzykkvSeHeaxa5wMU0kw=;
	b=tKXS2QKZ2U5heKh4F/gt51pgbKMttulZM01YgE+8CquAEu3y2T8jGQoaXTPpP56UTEm4IXyqKxv4K7mqMgkKSSYPxB3f1IVh3jaBzWUD6V9N5qoYSD8QVz846Dc12yP863/Zkxp/HWunxSApYuaV4UDIaI6S2rxuu/fB589Q0YI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCrq.RH_1792068214;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XCrq.RH_1792068214 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 15 Oct 2026 20:43:34 +0800
From: Peng Wang <peng_wang@linux.alibaba.com>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Peng Wang <peng_wang@linux.alibaba.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	He Rongguang <herongguang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH 1/2] tick/nohz: Add a policy dependency for full dynticks
Date: Thu, 15 Oct 2026 20:43:08 +0800
Message-ID: <7e9388359fde6ecec9a09d563fa21325f7e35206.1792067271.git.peng_wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1792067271.git.peng_wang@linux.alibaba.com>
References: <cover.1792067271.git.peng_wang@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Workloads and their need for periodic ticks can change after boot.
Operators may need to retain the non-idle scheduler tick on selected
CPUs in the boot-time nohz_full set while permitting tick suppression
on others, without changing the isolation configuration.
The policy can be changed without taking CPUs offline.

Add a per-CPU POLICY dependency to inhibit non-idle tick suppression.
All nohz_full CPUs remain permitted by default. Revocation uses the
existing asynchronous kick; granting permission clears only POLICY.
Preserve the policy across hotplug and recognize it in tick_stop tracing.
Idle tick suppression is unchanged.

Co-developed-by: He Rongguang <herongguang@linux.alibaba.com>
Signed-off-by: He Rongguang <herongguang@linux.alibaba.com>
Signed-off-by: Peng Wang <peng_wang@linux.alibaba.com>
---
 include/linux/tick.h         |  8 +++--
 include/trace/events/timer.h |  3 +-
 kernel/time/tick-sched.c     | 62 ++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b121c5d53e308..08d272dca0947 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -111,9 +111,10 @@ enum tick_dep_bits {
 	TICK_DEP_BIT_SCHED		= 2,
 	TICK_DEP_BIT_CLOCK_UNSTABLE	= 3,
 	TICK_DEP_BIT_RCU		= 4,
-	TICK_DEP_BIT_RCU_EXP		= 5
+	TICK_DEP_BIT_RCU_EXP		= 5,
+	TICK_DEP_BIT_POLICY		= 6
 };
-#define TICK_DEP_BIT_MAX TICK_DEP_BIT_RCU_EXP
+#define TICK_DEP_BIT_MAX TICK_DEP_BIT_POLICY
 
 #define TICK_DEP_MASK_NONE		0
 #define TICK_DEP_MASK_POSIX_TIMER	(1 << TICK_DEP_BIT_POSIX_TIMER)
@@ -122,6 +123,7 @@ enum tick_dep_bits {
 #define TICK_DEP_MASK_CLOCK_UNSTABLE	(1 << TICK_DEP_BIT_CLOCK_UNSTABLE)
 #define TICK_DEP_MASK_RCU		(1 << TICK_DEP_BIT_RCU)
 #define TICK_DEP_MASK_RCU_EXP		(1 << TICK_DEP_BIT_RCU_EXP)
+#define TICK_DEP_MASK_POLICY		(1 << TICK_DEP_BIT_POLICY)
 
 #ifdef CONFIG_NO_HZ_COMMON
 extern bool tick_nohz_enabled;
@@ -205,6 +207,8 @@ extern void tick_nohz_dep_set_signal(struct task_struct *tsk,
 extern void tick_nohz_dep_clear_signal(struct signal_struct *signal,
 				       enum tick_dep_bits bit);
 extern bool tick_nohz_cpu_hotpluggable(unsigned int cpu);
+extern void tick_nohz_full_get_allowed(struct cpumask *mask);
+extern int tick_nohz_full_set_allowed(const struct cpumask *mask);
 
 /*
  * The below are tick_nohz_[set,clear]_dep() wrappers that optimize off-cases
diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 3aa0608c63611..dff9579cd90eb 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -435,7 +435,8 @@ TRACE_EVENT(itimer_expire,
 		tick_dep_name(SCHED)			\
 		tick_dep_name(CLOCK_UNSTABLE)		\
 		tick_dep_name(RCU)			\
-		tick_dep_name_end(RCU_EXP)
+		tick_dep_name(RCU_EXP)			\
+		tick_dep_name_end(POLICY)
 
 #undef tick_dep_name
 #undef tick_dep_mask_name
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6c3fea3867139..d76128cba985c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -27,6 +27,7 @@
 #include <linux/posix-timers.h>
 #include <linux/context_tracking.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 
 #include <asm/irq_regs.h>
 
@@ -337,6 +338,7 @@ EXPORT_SYMBOL_GPL(tick_nohz_full_mask);
 bool tick_nohz_full_running;
 EXPORT_SYMBOL_GPL(tick_nohz_full_running);
 static atomic_t tick_dep_mask;
+static DEFINE_MUTEX(tick_nohz_full_policy_mutex);
 
 static bool check_tick_dependency(atomic_t *dep)
 {
@@ -375,6 +377,11 @@ static bool check_tick_dependency(atomic_t *dep)
 		return true;
 	}
 
+	if (val & TICK_DEP_MASK_POLICY) {
+		trace_tick_stop(0, TICK_DEP_MASK_POLICY);
+		return true;
+	}
+
 	return false;
 }
 
@@ -556,6 +563,57 @@ void tick_nohz_dep_clear_cpu(int cpu, enum tick_dep_bits bit)
 }
 EXPORT_SYMBOL_GPL(tick_nohz_dep_clear_cpu);
 
+/* Read policy, not whether a CPU currently has its tick stopped. */
+void tick_nohz_full_get_allowed(struct cpumask *mask)
+{
+	int cpu;
+
+	cpumask_clear(mask);
+	if (!tick_nohz_full_enabled())
+		return;
+
+	/* Exclude the reset of tick_cpu_sched during CPU teardown. */
+	cpus_read_lock();
+	mutex_lock(&tick_nohz_full_policy_mutex);
+	for_each_cpu(cpu, tick_nohz_full_mask) {
+		struct tick_sched *ts = per_cpu_ptr(&tick_cpu_sched, cpu);
+
+		if (!(atomic_read(&ts->tick_dep_mask) & TICK_DEP_MASK_POLICY))
+			cpumask_set_cpu(cpu, mask);
+	}
+	mutex_unlock(&tick_nohz_full_policy_mutex);
+	cpus_read_unlock();
+}
+
+int tick_nohz_full_set_allowed(const struct cpumask *mask)
+{
+	int cpu;
+
+	if (!tick_nohz_full_enabled())
+		return -EOPNOTSUPP;
+	if (!cpumask_subset(mask, tick_nohz_full_mask))
+		return -EINVAL;
+
+	cpus_read_lock();
+	mutex_lock(&tick_nohz_full_policy_mutex);
+	for_each_cpu(cpu, tick_nohz_full_mask) {
+		if (cpumask_test_cpu(cpu, mask)) {
+			tick_nohz_dep_clear_cpu(cpu, TICK_DEP_BIT_POLICY);
+		} else if (cpu_online(cpu)) {
+			/* The existing kick requests an asynchronous restart. */
+			tick_nohz_dep_set_cpu(cpu, TICK_DEP_BIT_POLICY);
+		} else {
+			struct tick_sched *ts = per_cpu_ptr(&tick_cpu_sched, cpu);
+
+			/* Record policy without queuing irq_work on an offline CPU. */
+			atomic_or(TICK_DEP_MASK_POLICY, &ts->tick_dep_mask);
+		}
+	}
+	mutex_unlock(&tick_nohz_full_policy_mutex);
+	cpus_read_unlock();
+	return 0;
+}
+
 /*
  * Set a per-task tick dependency. RCU needs this. Also posix CPU timers
  * in order to elapse per task timers.
@@ -1528,6 +1586,7 @@ void tick_sched_timer_dying(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long idle_calls, idle_sleeps;
+	int policy;
 
 	/* This must happen before hrtimers are migrated! */
 	if (tick_sched_flag_test(ts, TS_FLAG_HIGHRES))
@@ -1535,7 +1594,10 @@ void tick_sched_timer_dying(int cpu)
 
 	idle_calls = ts->idle_calls;
 	idle_sleeps = ts->idle_sleeps;
+	/* Preserve only the policy dependency across CPU offline/online. */
+	policy = atomic_read(&ts->tick_dep_mask) & TICK_DEP_MASK_POLICY;
 	memset(ts, 0, sizeof(*ts));
+	atomic_set(&ts->tick_dep_mask, policy);
 	ts->idle_calls = idle_calls;
 	ts->idle_sleeps = idle_sleeps;
 }
