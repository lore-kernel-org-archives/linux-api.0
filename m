Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D8B242D67;
	Sat, 17 Oct 2026 13:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792242840; cv=none; b=F/YvYtvKkjmAOcyOTnZAq16k1l02n8umy2CUDx4PfpVKG5omdi8dc9NKx/wxQ6h6tmSQLZFcmvx24ZcGe2WzNWpKuUVRBuTgUxAXKdldlutZib2a3Sh7yltpQ81cJlvs2/rBb2/Nm9SK0NVeq4obxpF+ScJ7pi1wjamNckJZtjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792242840; c=relaxed/simple;
	bh=cMAkdJNW1SErKnzl9/oVHuljS2yCDKMvsogsdOO2tms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQnjHXKXrznOip4aG0BoXUCeWC2tz3BEPHkJhKmH/39EChjGj47MRkWJ0rERXglCYl/6DOwTrwjNQinZhVYvr/XgsQaZHc0iireqp+/vcpX42urFpc5VEkQvO4h8kkaF8nT6WLAqskid4gnlH9Wk3Lnz0lbtktigzU9Fn9BLGV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EIK65uDp; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EIK65uDp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792242832; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=4zaba4hvJPG/HT/o9fVsqkFjh5xQEjH0W9ibRY3KOIA=;
	b=EIK65uDpYLfHqM/8hRnHXQBhRgfXvpptXkI//9lhjX9zx7HH3tbGqa8UO1j49lJpOp6Ktx5Y3hazhZC3Xd6GA9qKXSXG01f+/MzSFpdS4vvA6oAuSz/PY/0hKkByS00d6hesWdI3z4eBXQq3CjyLwnadl8WEPdmjr5ZXk15PKmY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCxEdh9_1792242831;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XCxEdh9_1792242831 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 17 Oct 2026 21:13:51 +0800
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
Subject: [RFC PATCH v2 1/2] tick/nohz: Add a policy dependency for full dynticks
Date: Sat, 17 Oct 2026 21:13:41 +0800
Message-ID: <58bc33cb018a2651e9cc3fc02baad7de4d543705.1792242566.git.peng_wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1792242566.git.peng_wang@linux.alibaba.com>
References: <cover.1792242566.git.peng_wang@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cloud hosts may pin vCPU threads one-to-one to host CPUs. At full
allocation this includes the housekeeping CPUs, which always retain
their non-idle tick. Operators want comparable performance for otherwise
equivalent vCPUs. Retaining the non-idle tick on nohz_full CPUs as well
avoids one placement-dependent difference in host tick interference.
With spare capacity, selected CPUs may stop the tick to reduce host
scheduler-tick interference with vCPUs.

Allocation changes as VMs are created or destroyed while other VMs
remain running. A vCPU thread may be the only runnable task in either
state, so existing tick dependencies do not express this policy.

Add a per-CPU POLICY dependency within the boot-time nohz_full set.
Permission defaults to enabled. The policy can be changed without
taking CPUs offline. Revoking permission uses the existing asynchronous
kick; granting it leaves all other dependencies effective. Preserve
POLICY across CPU hotplug and report it in tick_stop tracing.

Idle tick suppression, nohz_full membership, context tracking, RCU
offloading and housekeeping configuration are unchanged.

Co-developed-by: He Rongguang <herongguang@linux.alibaba.com>
Signed-off-by: He Rongguang <herongguang@linux.alibaba.com>
Signed-off-by: Peng Wang <peng_wang@linux.alibaba.com>
---
 include/linux/tick.h         |  8 +++++--
 include/trace/events/timer.h |  3 ++-
 kernel/time/tick-sched.c     | 42 ++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b121c5d53e308..8b250f245ff31 100644
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
+extern bool tick_nohz_full_get_allowed(unsigned int cpu);
+extern int tick_nohz_full_set_allowed(unsigned int cpu, bool allowed);
 
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
index 87e2a7a875265..0d6fcc3736bae 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -375,6 +375,11 @@ static bool check_tick_dependency(atomic_t *dep)
 		return true;
 	}
 
+	if (val & TICK_DEP_MASK_POLICY) {
+		trace_tick_stop(0, TICK_DEP_MASK_POLICY);
+		return true;
+	}
+
 	return false;
 }
 
@@ -561,6 +566,39 @@ void tick_nohz_dep_clear_cpu(int cpu, enum tick_dep_bits bit)
 }
 EXPORT_SYMBOL_GPL(tick_nohz_dep_clear_cpu);
 
+/* Read policy, not whether a CPU currently has its tick stopped. */
+bool tick_nohz_full_get_allowed(unsigned int cpu)
+{
+	struct tick_sched *ts = per_cpu_ptr(&tick_cpu_sched, cpu);
+
+	/* CPU teardown resets and restores this bit under stop_machine(). */
+	return !(atomic_read(&ts->tick_dep_mask) & TICK_DEP_MASK_POLICY);
+}
+
+int tick_nohz_full_set_allowed(unsigned int cpu, bool allowed)
+{
+	struct tick_sched *ts = per_cpu_ptr(&tick_cpu_sched, cpu);
+
+	if (!tick_nohz_full_cpu(cpu))
+		return -EINVAL;
+
+	/* CPU device removal may wait for an active sysfs callback. */
+	if (!cpus_read_trylock())
+		return -EBUSY;
+
+	if (allowed) {
+		tick_nohz_dep_clear_cpu(cpu, TICK_DEP_BIT_POLICY);
+	} else if (cpu_online(cpu)) {
+		/* The existing kick requests an asynchronous restart. */
+		tick_nohz_dep_set_cpu(cpu, TICK_DEP_BIT_POLICY);
+	} else {
+		/* Record policy without queuing irq_work on an offline CPU. */
+		atomic_or(TICK_DEP_MASK_POLICY, &ts->tick_dep_mask);
+	}
+	cpus_read_unlock();
+	return 0;
+}
+
 /*
  * Set a per-task tick dependency. RCU needs this. Also posix CPU timers
  * in order to elapse per task timers.
@@ -1533,6 +1571,7 @@ void tick_sched_timer_dying(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long idle_calls, idle_sleeps;
+	int policy;
 
 	/* This must happen before hrtimers are migrated! */
 	if (tick_sched_flag_test(ts, TS_FLAG_HIGHRES))
@@ -1540,7 +1579,10 @@ void tick_sched_timer_dying(int cpu)
 
 	idle_calls = ts->idle_calls;
 	idle_sleeps = ts->idle_sleeps;
+	/* Preserve only the policy dependency across CPU offline/online. */
+	policy = atomic_read(&ts->tick_dep_mask) & TICK_DEP_MASK_POLICY;
 	memset(ts, 0, sizeof(*ts));
+	atomic_set(&ts->tick_dep_mask, policy);
 	ts->idle_calls = idle_calls;
 	ts->idle_sleeps = idle_sleeps;
 }
-- 
2.47.0

