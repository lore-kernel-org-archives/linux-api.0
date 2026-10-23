Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792767625;
	b=qO+HK7su27uQjH3QKFvpOm9gjuzQsV4fQdjyLVl+qD8fcF8qk16xuFugS/0rjjkNnD2p
	 vWBvKqTbFwAmQjT9ScMyNPGxQxjj2SnUH+dg74hlUF8oB3g2BdoUWgzDL7+fKLTKIkeWs
	 2WnnbjfBon3pguQ0Ke2BTGrx+xEDbP3QbzuRHtb9eFpt+b03fDlJXvXnk7bGTNv9ter5g
	 dKJYKCjpQ3qZc9k9aEkaJFcjk+pBUKUzAt9wgNl+6afVucoR7pvuT73a4oha8CbymcABZ
	 +Ac4XAypRfrrZterfzejJ9EUDUvss/yTbPK/PMo/28A/t6FDAhXpBB4OgeZW2Twmy2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792767625;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=7bmXE9eB7alT01S68+GEqtmKgfMF4L3T/lFunQRLqUY=;
	b=ZUJxBXOnns9WIn+yeEkOZaDDgNfVzU7NUMjhVrq5ZnXTIS9U6YPoEJ5LKKlUymJhsqOn
	 D+66SAY+JoLsY/DUf9lTRFg0KDjkB9ZFdI+806/r49leo7S97uMKnXZi7aVpEMXq9sjQH
	 ez2k/eLS+H8Qy+k7Vq0iQge6CNBRqFU7l6+O+lkdK8loMZ9jChS+nYZzkEBtFhYqqprs7
	 CzSJf6mMbvzN0QB6uLeaT6yrLA8P6a00zEo78b5cCr7Efp4T26kByTjj3TrlbKwLE0ZvV
	 7pwlv6xQA+7vZpQG7JdyngnHBOvPpWOllgiv50/JJMApIgj3Bqkgnh6RNxgYLTd5B8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qz65DyB1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BBE606A32A;
	Fri, 23 Oct 2026 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qz65DyB1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8A31F031E1;
	Fri, 23 Oct 2026 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792767625;
	bh=7bmXE9eB7alT01S68+GEqtmKgfMF4L3T/lFunQRLqUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qz65DyB1QDCzSVoTx6uXxOvKWmS2R8mZfO/NABTvk6rz5211L+k2sd4Q78SicBJf3
	 XCIFj4bAp7tM5Y3XNl1UU5I7263BbMzbmnko44BmpQ3Qi4yBNFCAUJGkB1t6mrEO41
	 aTQBhN+7NSKFyrjWT1ic+L6pwJcZYx8ZFqJQrn3eTC/eOmluVsO4F+oYmwIThkcswq
	 csTH2oIj7EBF3ecJsX+wD2pHDOQJTrfyoAPo117BmBIvEjbYN1wLCTEyMiqR5vQo08
	 kZMp7tzKASXXaved61t48KwGVAKSJcn6fTEa17pMahgcsanyhmFlzyrU+kzrwWj2MV
	 9YJvxGqJ28AwA==
Date: Fri, 23 Oct 2026 17:00:22 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Peng Wang <peng_wang@linux.alibaba.com>
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
Message-ID: <att2hiYaaHTIkzG9@localhost.localdomain>
References: <cover.1792242566.git.peng_wang@linux.alibaba.com>
 <58bc33cb018a2651e9cc3fc02baad7de4d543705.1792242566.git.peng_wang@linux.alibaba.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58bc33cb018a2651e9cc3fc02baad7de4d543705.1792242566.git.peng_wang@linux.alibaba.com>

Le Sat, Oct 17, 2026 at 09:13:41PM +0800, Peng Wang a écrit :
> Cloud hosts may pin vCPU threads one-to-one to host CPUs. At full
> allocation this includes the housekeeping CPUs, which always retain
> their non-idle tick. Operators want comparable performance for otherwise
> equivalent vCPUs. Retaining the non-idle tick on nohz_full CPUs as well
> avoids one placement-dependent difference in host tick interference.
> With spare capacity, selected CPUs may stop the tick to reduce host
> scheduler-tick interference with vCPUs.
> 
> Allocation changes as VMs are created or destroyed while other VMs
> remain running. A vCPU thread may be the only runnable task in either
> state, so existing tick dependencies do not express this policy.

I'm not sure I understand correctly what you are trying to solve.
Are you saying that you want to keep the tick running when there
is more than one vCPU per CPU? Because the scheduler already takes
care of that.

> 
> Add a per-CPU POLICY dependency within the boot-time nohz_full set.
> Permission defaults to enabled. The policy can be changed without
> taking CPUs offline. Revoking permission uses the existing asynchronous
> kick; granting it leaves all other dependencies effective. Preserve
> POLICY across CPU hotplug and report it in tick_stop tracing.
> 
> Idle tick suppression, nohz_full membership, context tracking, RCU
> offloading and housekeeping configuration are unchanged.

This still keeps the overhead of nohz_full even if the tick stays on, right?
(RCU nocb, kernel <-> user overhead, etc...). Isn't it a problem for you?

Thanks.

> 
> Co-developed-by: He Rongguang <herongguang@linux.alibaba.com>
> Signed-off-by: He Rongguang <herongguang@linux.alibaba.com>
> Signed-off-by: Peng Wang <peng_wang@linux.alibaba.com>
> ---
>  include/linux/tick.h         |  8 +++++--
>  include/trace/events/timer.h |  3 ++-
>  kernel/time/tick-sched.c     | 42 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/tick.h b/include/linux/tick.h
> index b121c5d53e308..8b250f245ff31 100644
> --- a/include/linux/tick.h
> +++ b/include/linux/tick.h
> @@ -111,9 +111,10 @@ enum tick_dep_bits {
>  	TICK_DEP_BIT_SCHED		= 2,
>  	TICK_DEP_BIT_CLOCK_UNSTABLE	= 3,
>  	TICK_DEP_BIT_RCU		= 4,
> -	TICK_DEP_BIT_RCU_EXP		= 5
> +	TICK_DEP_BIT_RCU_EXP		= 5,
> +	TICK_DEP_BIT_POLICY		= 6
>  };
> -#define TICK_DEP_BIT_MAX TICK_DEP_BIT_RCU_EXP
> +#define TICK_DEP_BIT_MAX TICK_DEP_BIT_POLICY
>  
>  #define TICK_DEP_MASK_NONE		0
>  #define TICK_DEP_MASK_POSIX_TIMER	(1 << TICK_DEP_BIT_POSIX_TIMER)
> @@ -122,6 +123,7 @@ enum tick_dep_bits {
>  #define TICK_DEP_MASK_CLOCK_UNSTABLE	(1 << TICK_DEP_BIT_CLOCK_UNSTABLE)
>  #define TICK_DEP_MASK_RCU		(1 << TICK_DEP_BIT_RCU)
>  #define TICK_DEP_MASK_RCU_EXP		(1 << TICK_DEP_BIT_RCU_EXP)
> +#define TICK_DEP_MASK_POLICY		(1 << TICK_DEP_BIT_POLICY)
>  
>  #ifdef CONFIG_NO_HZ_COMMON
>  extern bool tick_nohz_enabled;
> @@ -205,6 +207,8 @@ extern void tick_nohz_dep_set_signal(struct task_struct *tsk,
>  extern void tick_nohz_dep_clear_signal(struct signal_struct *signal,
>  				       enum tick_dep_bits bit);
>  extern bool tick_nohz_cpu_hotpluggable(unsigned int cpu);
> +extern bool tick_nohz_full_get_allowed(unsigned int cpu);
> +extern int tick_nohz_full_set_allowed(unsigned int cpu, bool allowed);
>  
>  /*
>   * The below are tick_nohz_[set,clear]_dep() wrappers that optimize off-cases
> diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
> index 3aa0608c63611..dff9579cd90eb 100644
> --- a/include/trace/events/timer.h
> +++ b/include/trace/events/timer.h
> @@ -435,7 +435,8 @@ TRACE_EVENT(itimer_expire,
>  		tick_dep_name(SCHED)			\
>  		tick_dep_name(CLOCK_UNSTABLE)		\
>  		tick_dep_name(RCU)			\
> -		tick_dep_name_end(RCU_EXP)
> +		tick_dep_name(RCU_EXP)			\
> +		tick_dep_name_end(POLICY)
>  
>  #undef tick_dep_name
>  #undef tick_dep_mask_name
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 87e2a7a875265..0d6fcc3736bae 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -375,6 +375,11 @@ static bool check_tick_dependency(atomic_t *dep)
>  		return true;
>  	}
>  
> +	if (val & TICK_DEP_MASK_POLICY) {
> +		trace_tick_stop(0, TICK_DEP_MASK_POLICY);
> +		return true;
> +	}
> +
>  	return false;
>  }
>  
> @@ -561,6 +566,39 @@ void tick_nohz_dep_clear_cpu(int cpu, enum tick_dep_bits bit)
>  }
>  EXPORT_SYMBOL_GPL(tick_nohz_dep_clear_cpu);
>  
> +/* Read policy, not whether a CPU currently has its tick stopped. */
> +bool tick_nohz_full_get_allowed(unsigned int cpu)
> +{
> +	struct tick_sched *ts = per_cpu_ptr(&tick_cpu_sched, cpu);
> +
> +	/* CPU teardown resets and restores this bit under stop_machine(). */
> +	return !(atomic_read(&ts->tick_dep_mask) & TICK_DEP_MASK_POLICY);
> +}
> +
> +int tick_nohz_full_set_allowed(unsigned int cpu, bool allowed)
> +{
> +	struct tick_sched *ts = per_cpu_ptr(&tick_cpu_sched, cpu);
> +
> +	if (!tick_nohz_full_cpu(cpu))
> +		return -EINVAL;
> +
> +	/* CPU device removal may wait for an active sysfs callback. */
> +	if (!cpus_read_trylock())
> +		return -EBUSY;
> +
> +	if (allowed) {
> +		tick_nohz_dep_clear_cpu(cpu, TICK_DEP_BIT_POLICY);
> +	} else if (cpu_online(cpu)) {
> +		/* The existing kick requests an asynchronous restart. */
> +		tick_nohz_dep_set_cpu(cpu, TICK_DEP_BIT_POLICY);
> +	} else {
> +		/* Record policy without queuing irq_work on an offline CPU. */
> +		atomic_or(TICK_DEP_MASK_POLICY, &ts->tick_dep_mask);
> +	}
> +	cpus_read_unlock();
> +	return 0;
> +}
> +
>  /*
>   * Set a per-task tick dependency. RCU needs this. Also posix CPU timers
>   * in order to elapse per task timers.
> @@ -1533,6 +1571,7 @@ void tick_sched_timer_dying(int cpu)
>  {
>  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
>  	unsigned long idle_calls, idle_sleeps;
> +	int policy;
>  
>  	/* This must happen before hrtimers are migrated! */
>  	if (tick_sched_flag_test(ts, TS_FLAG_HIGHRES))
> @@ -1540,7 +1579,10 @@ void tick_sched_timer_dying(int cpu)
>  
>  	idle_calls = ts->idle_calls;
>  	idle_sleeps = ts->idle_sleeps;
> +	/* Preserve only the policy dependency across CPU offline/online. */
> +	policy = atomic_read(&ts->tick_dep_mask) & TICK_DEP_MASK_POLICY;
>  	memset(ts, 0, sizeof(*ts));
> +	atomic_set(&ts->tick_dep_mask, policy);
>  	ts->idle_calls = idle_calls;
>  	ts->idle_sleeps = idle_sleeps;
>  }
> -- 
> 2.47.0
> 

-- 
Frederic Weisbecker
SUSE Labs
