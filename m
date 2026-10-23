Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773167;
	b=Fj7PEtYrOIdnFkamDhsxdIGPYpBgAkAYVUYxX9/Ls+MV9yGCxhuoZ4UOIMYIjwpf52KD
	 Pm9CYZ2rhjWx4M1X7oWSdpTrBrRGa+EzTzZIeMVoPRzkfeeG6tG1tW+74zbYWSg1JVRcd
	 XD4QmoYghySE6IdLIqgIcZJ3hIdDZjAGwjVdy32mMH2P7qO9PlE/NL69d/NV4DDI13B+q
	 GEL07hMc8wJbuH2AKejhjX4aKFVMFHwj1C24auu3LhW+xY+85VDkLWeitBc+D7Hqx4HDo
	 /fSjAlonfJ64dxqT+zq8FiLymZHERca/qN7X4f6I+wow9tY8SxvUSR/nfgcAGwZjk7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773167;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=3ema2G2wwnlTArQOf2q2NQI5SlV/oLWW1i1rn+h9N4k=;
	b=Q8irdVbjaST/prwshS0R6z66eIg605xzSPvPuZUPQHTX7E64iaWboDVUB7+XCjxN+VNl
	 mPeaswrCPlkLgwrB1JmzUawRXnPNJFvegJKwj6TEEBxc3rE7FmGsvx7kZyA/rZHAngpIg
	 AikdfPvqam8OK2D0zuxenxAQoDu3GiUdMFSRtqt51OpWWEXTL1hBRsmSJ/Fdo7midk+Kn
	 gaBA9IS2qWuiw7STtFeD6Ee3C1A0zt5YcKUdIncudKVb6q4ly1u0pTw2+5A44KB0ugiBg
	 E+tA9iTTfvdzx54/OFIYM/UwiCFLQEO8iDX0LbgP4+fo0lpdqkT/p7NxhArKZEdR1fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B31606A31D;
	Fri, 23 Oct 2026 16:32:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32B31606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792773161; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=3ema2G2wwnlTArQOf2q2NQI5SlV/oLWW1i1rn+h9N4k=;
	b=LXA7K+6QV9zmifvT+SxUkRdKEd0ajcgpj//SS6SggmhAA4yimO6yNexlCcb6h6TTjy6TySdEoHfJCM1h20Io6XOGVH3TIfnBTjc/Cu9+fn4T0P/elVZAhBgN16fxVMzoMfJNCFh22EUe8JpCay0V0coNVbqAWC4vA+J8Mp1vf2U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XDMSvpS_1792773159;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XDMSvpS_1792773159 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Oct 2026 00:32:40 +0800
Date: Sat, 24 Oct 2026 00:32:38 +0800
From: Peng Wang <peng_wang@linux.alibaba.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
	He Rongguang <herongguang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	driver-core@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] tick/nohz: Add a policy dependency for full
 dynticks
Message-ID: <atuMJiJEwbzGjiu4@MacBook-Pro.local>
Reply-To: Peng Wang <peng_wang@linux.alibaba.com>
References: <cover.1792242566.git.peng_wang@linux.alibaba.com>
 <58bc33cb018a2651e9cc3fc02baad7de4d543705.1792242566.git.peng_wang@linux.alibaba.com>
 <att2hiYaaHTIkzG9@localhost.localdomain>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <att2hiYaaHTIkzG9@localhost.localdomain>

On Fri, Oct 23, 2026 at 05:00:22PM +0200, Frederic Weisbecker wrote:
> Le Sat, Oct 17, 2026 at 09:13:41PM +0800, Peng Wang a éãrit :
> > Cloud hosts may pin vCPU threads one-to-one to host CPUs. At full
> > allocation this includes the housekeeping CPUs, which always retain
> > their non-idle tick. Operators want comparable performance for otherwise
> > equivalent vCPUs. Retaining the non-idle tick on nohz_full CPUs as well
> > avoids one placement-dependent difference in host tick interference.
> > With spare capacity, selected CPUs may stop the tick to reduce host
> > scheduler-tick interference with vCPUs.
> > 
> > Allocation changes as VMs are created or destroyed while other VMs
> > remain running. A vCPU thread may be the only runnable task in either
> > state, so existing tick dependencies do not express this policy.
> 
> I'm not sure I understand correctly what you are trying to solve.
> Are you saying that you want to keep the tick running when there
> is more than one vCPU per CPU? Because the scheduler already takes
> care of that.

Hi Frederic,

No. We pin vCPU threads one-to-one to host CPUs, without
oversubscription. By "full allocation" I meant that all allocatable
host CPUs are in use, including CPUs outside the nohz_full set.

For example, on an eight-CPU host booted with isolcpus=nohz,1-7,
CPU0 is outside the nohz_full set:

- With eight pinned vCPUs, CPU0 retains its non-idle tick while
  CPUs1-7 may stop theirs. Retaining the tick on CPUs1-7 too avoids
  this placement-dependent difference in tick interference between
  otherwise equivalent vCPUs.

- With seven or fewer pinned vCPUs, we can leave CPU0 without a
  vCPU and keep them on CPUs1-7. We can then allow tick suppression
  on CPUs1-7, subject to the existing dependencies. This gives
  these vCPUs a common tick policy while reducing host tick
  interference.

If the vCPU on CPU0 is released while the other seven remain
running, we allow CPUs1-7 to suppress their ticks. If a new vCPU
is later assigned to CPU0, we retain the ticks on CPUs1-7 again
to avoid the difference in tick interference.

Throughout these transitions, CPU1 can still have its original
pinned vCPU thread as its only runnable task. Its runnable task
count does not change merely because CPU0 gains or loses a vCPU,
so the scheduler's existing tick dependency cannot express this
allocation policy.

> 
> > 
> > Add a per-CPU POLICY dependency within the boot-time nohz_full set.
> > Permission defaults to enabled. The policy can be changed without
> > taking CPUs offline. Revoking permission uses the existing asynchronous
> > kick; granting it leaves all other dependencies effective. Preserve
> > POLICY across CPU hotplug and report it in tick_stop tracing.
> > 
> > Idle tick suppression, nohz_full membership, context tracking, RCU
> > offloading and housekeeping configuration are unchanged.
> 
> This still keeps the overhead of nohz_full even if the tick stays on, right?
> (RCU nocb, kernel <-> user overhead, etc...). Isn't it a problem for you?

Yes. Our setup uses only the nohz flag of isolcpus, without
additional housekeeping affinity tuning. Context tracking and
RCU callback offloading remain enabled when the tick is kept
running.

We have observed a performance benefit from this nohz_full setup
with our database workload running on pinned vCPUs. We retain the
boot-time nohz_full configuration so that tick suppression remains
available as vCPU allocation changes, even though its other costs
remain when the tick is kept running.

This control changes only whether non-idle ticks may be suppressed;
it does not change the nohz_full CPU set or housekeeping CPU masks.

Thanks,
Peng

> 
> Thanks.
> 
> > 
> > Co-developed-by: He Rongguang <herongguang@linux.alibaba.com>
> > Signed-off-by: He Rongguang <herongguang@linux.alibaba.com>
> > Signed-off-by: Peng Wang <peng_wang@linux.alibaba.com>
> > ---
> >  include/linux/tick.h         |  8 +++++--
> >  include/trace/events/timer.h |  3 ++-
> >  kernel/time/tick-sched.c     | 42 ++++++++++++++++++++++++++++++++++++
> >  3 files changed, 50 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/tick.h b/include/linux/tick.h
> > index b121c5d53e308..8b250f245ff31 100644
> > --- a/include/linux/tick.h
> > +++ b/include/linux/tick.h
> > @@ -111,9 +111,10 @@ enum tick_dep_bits {
> >  	TICK_DEP_BIT_SCHED		= 2,
> >  	TICK_DEP_BIT_CLOCK_UNSTABLE	= 3,
> >  	TICK_DEP_BIT_RCU		= 4,
> > -	TICK_DEP_BIT_RCU_EXP		= 5
> > +	TICK_DEP_BIT_RCU_EXP		= 5,
> > +	TICK_DEP_BIT_POLICY		= 6
> >  };
> > -#define TICK_DEP_BIT_MAX TICK_DEP_BIT_RCU_EXP
> > +#define TICK_DEP_BIT_MAX TICK_DEP_BIT_POLICY
> >  
> >  #define TICK_DEP_MASK_NONE		0
> >  #define TICK_DEP_MASK_POSIX_TIMER	(1 << TICK_DEP_BIT_POSIX_TIMER)
> > @@ -122,6 +123,7 @@ enum tick_dep_bits {
> >  #define TICK_DEP_MASK_CLOCK_UNSTABLE	(1 << TICK_DEP_BIT_CLOCK_UNSTABLE)
> >  #define TICK_DEP_MASK_RCU		(1 << TICK_DEP_BIT_RCU)
> >  #define TICK_DEP_MASK_RCU_EXP		(1 << TICK_DEP_BIT_RCU_EXP)
> > +#define TICK_DEP_MASK_POLICY		(1 << TICK_DEP_BIT_POLICY)
> >  
> >  #ifdef CONFIG_NO_HZ_COMMON
> >  extern bool tick_nohz_enabled;
> > @@ -205,6 +207,8 @@ extern void tick_nohz_dep_set_signal(struct task_struct *tsk,
> >  extern void tick_nohz_dep_clear_signal(struct signal_struct *signal,
> >  				       enum tick_dep_bits bit);
> >  extern bool tick_nohz_cpu_hotpluggable(unsigned int cpu);
> > +extern bool tick_nohz_full_get_allowed(unsigned int cpu);
> > +extern int tick_nohz_full_set_allowed(unsigned int cpu, bool allowed);
> >  
> >  /*
> >   * The below are tick_nohz_[set,clear]_dep() wrappers that optimize off-cases
> > diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
> > index 3aa0608c63611..dff9579cd90eb 100644
> > --- a/include/trace/events/timer.h
> > +++ b/include/trace/events/timer.h
> > @@ -435,7 +435,8 @@ TRACE_EVENT(itimer_expire,
> >  		tick_dep_name(SCHED)			\
> >  		tick_dep_name(CLOCK_UNSTABLE)		\
> >  		tick_dep_name(RCU)			\
> > -		tick_dep_name_end(RCU_EXP)
> > +		tick_dep_name(RCU_EXP)			\
> > +		tick_dep_name_end(POLICY)
> >  
> >  #undef tick_dep_name
> >  #undef tick_dep_mask_name
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index 87e2a7a875265..0d6fcc3736bae 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -375,6 +375,11 @@ static bool check_tick_dependency(atomic_t *dep)
> >  		return true;
> >  	}
> >  
> > +	if (val & TICK_DEP_MASK_POLICY) {
> > +		trace_tick_stop(0, TICK_DEP_MASK_POLICY);
> > +		return true;
> > +	}
> > +
> >  	return false;
> >  }
> >  
> > @@ -561,6 +566,39 @@ void tick_nohz_dep_clear_cpu(int cpu, enum tick_dep_bits bit)
> >  }
> >  EXPORT_SYMBOL_GPL(tick_nohz_dep_clear_cpu);
> >  
> > +/* Read policy, not whether a CPU currently has its tick stopped. */
> > +bool tick_nohz_full_get_allowed(unsigned int cpu)
> > +{
> > +	struct tick_sched *ts = per_cpu_ptr(&tick_cpu_sched, cpu);
> > +
> > +	/* CPU teardown resets and restores this bit under stop_machine(). */
> > +	return !(atomic_read(&ts->tick_dep_mask) & TICK_DEP_MASK_POLICY);
> > +}
> > +
> > +int tick_nohz_full_set_allowed(unsigned int cpu, bool allowed)
> > +{
> > +	struct tick_sched *ts = per_cpu_ptr(&tick_cpu_sched, cpu);
> > +
> > +	if (!tick_nohz_full_cpu(cpu))
> > +		return -EINVAL;
> > +
> > +	/* CPU device removal may wait for an active sysfs callback. */
> > +	if (!cpus_read_trylock())
> > +		return -EBUSY;
> > +
> > +	if (allowed) {
> > +		tick_nohz_dep_clear_cpu(cpu, TICK_DEP_BIT_POLICY);
> > +	} else if (cpu_online(cpu)) {
> > +		/* The existing kick requests an asynchronous restart. */
> > +		tick_nohz_dep_set_cpu(cpu, TICK_DEP_BIT_POLICY);
> > +	} else {
> > +		/* Record policy without queuing irq_work on an offline CPU. */
> > +		atomic_or(TICK_DEP_MASK_POLICY, &ts->tick_dep_mask);
> > +	}
> > +	cpus_read_unlock();
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Set a per-task tick dependency. RCU needs this. Also posix CPU timers
> >   * in order to elapse per task timers.
> > @@ -1533,6 +1571,7 @@ void tick_sched_timer_dying(int cpu)
> >  {
> >  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> >  	unsigned long idle_calls, idle_sleeps;
> > +	int policy;
> >  
> >  	/* This must happen before hrtimers are migrated! */
> >  	if (tick_sched_flag_test(ts, TS_FLAG_HIGHRES))
> > @@ -1540,7 +1579,10 @@ void tick_sched_timer_dying(int cpu)
> >  
> >  	idle_calls = ts->idle_calls;
> >  	idle_sleeps = ts->idle_sleeps;
> > +	/* Preserve only the policy dependency across CPU offline/online. */
> > +	policy = atomic_read(&ts->tick_dep_mask) & TICK_DEP_MASK_POLICY;
> >  	memset(ts, 0, sizeof(*ts));
> > +	atomic_set(&ts->tick_dep_mask, policy);
> >  	ts->idle_calls = idle_calls;
> >  	ts->idle_sleeps = idle_sleeps;
> >  }
> > -- 
> > 2.47.0
> > 
> 
> -- 
> Frederic Weisbecker
> SUSE Labs
