Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203131;
	b=PBzcEnMMPn0HbMzoFVD+pzdSJTgox9FjF4IBoue/mNP8EnyLOw1mk/tBWeU0Y3e6zIoA
	 hDLlhPTURN+OzxJb47w2ZbxkX/dG1c8liBO5LZB+ei1wxln/SerKtlVb+0IYagKrWBD6N
	 T/O1RJKwge95XXm8h9PrADzXQT/ll3MPRQ+JwE8kKysKx1zHDfmkRJi7Vy+YVFAYBFcny
	 0ZzJDwoSBYqXCwDZkCL79uB5jjwQNdDliza1inNdWHZqwlUm2IWey33J6d4wKQFOzV7ok
	 LxzOjXvTMF8N+SGtoYLUeviYcLEbxdbimY8P93jyu0ncu8Ml4+V0KhVUs0YVn0rPhCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203131;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=KaGhgSwdPewaNyyalbhvVyRytdZ/XV116s7GiJ25PBY=;
	b=0JpuKUpnKkLbKwkd3OlTj7oYeBm14cB7eDixNht0IrIUuBTX1gxxDPw7ZAqqpvzzqaCv
	 r4IX75jEvDeAr4zmEw24K4sLAANe3XStkM2IPWn1ueZ2lnwtR8ssKfsOeydfhR348hj0N
	 EufJPiXZxEJKf0Io/Vn36ZRFZ6eAe3Y5ldSkYLbzVsBa5S/KpgsVrBpdPupwTDqjQe+qr
	 LPh/4XhMMvniF/YUXX1n3vvv2M8a5wtnoGBQofFnN85OBb6XzlTnVy7TdjHjjaVz4s5MH
	 hXyKacdE5HIUr4LllrxXFGqrIevku2kvlOm7b8qBsf0V6i8fUovURxgB9Q4GnA6uvzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NEMpD7ND;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3290606A31C;
	Wed, 28 Oct 2026 15:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NEMpD7ND
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BFD1F01829;
	Wed, 28 Oct 2026 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793203130;
	bh=KaGhgSwdPewaNyyalbhvVyRytdZ/XV116s7GiJ25PBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NEMpD7NDcOeDg9hzGOPnRl+r1niBLIFDT/DjEKwwaniyFSVPAABrBHPbJv1gdTZ8M
	 OsW9WMoqFBWpwIyff+FsoFuy054ytujvh60x9IH0B+L9RI4emy/7PGukkD5whnQ9i+
	 64XPhQzcp+Ee6Av1JPNQKqJsAefBUMGaHhNqGpFo5JxQ8AJq9YD5mq6XGJmx1Fk+d5
	 eNqx9K/Xfcc/M7ktJ//3C0gpB6z+e1InXfFIPD0O5ZfEPKZ6Rzn7vNdsBOnztLezg/
	 dpN+WU99gp+MynU9j88tn5hKgUx7JPkAT7bPY7lvTpfjLnLat4R427gcmJ8f0H6f3K
	 fERqz8DA0AqZQ==
Date: Wed, 28 Oct 2026 16:58:47 +0100
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
Message-ID: <auIbt5JAC2cHw5jr@localhost.localdomain>
References: <cover.1792242566.git.peng_wang@linux.alibaba.com>
 <58bc33cb018a2651e9cc3fc02baad7de4d543705.1792242566.git.peng_wang@linux.alibaba.com>
 <att2hiYaaHTIkzG9@localhost.localdomain>
 <atuMJiJEwbzGjiu4@MacBook-Pro.local>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <atuMJiJEwbzGjiu4@MacBook-Pro.local>

Le Sat, Oct 24, 2026 at 12:32:38AM +0800, Peng Wang a écrit :
> On Fri, Oct 23, 2026 at 05:00:22PM +0200, Frederic Weisbecker wrote:
> > Le Sat, Oct 17, 2026 at 09:13:41PM +0800, Peng Wang a 殂rit :
> > > Cloud hosts may pin vCPU threads one-to-one to host CPUs. At full
> > > allocation this includes the housekeeping CPUs, which always retain
> > > their non-idle tick. Operators want comparable performance for otherwise
> > > equivalent vCPUs. Retaining the non-idle tick on nohz_full CPUs as well
> > > avoids one placement-dependent difference in host tick interference.
> > > With spare capacity, selected CPUs may stop the tick to reduce host
> > > scheduler-tick interference with vCPUs.
> > > 
> > > Allocation changes as VMs are created or destroyed while other VMs
> > > remain running. A vCPU thread may be the only runnable task in either
> > > state, so existing tick dependencies do not express this policy.
> > 
> > I'm not sure I understand correctly what you are trying to solve.
> > Are you saying that you want to keep the tick running when there
> > is more than one vCPU per CPU? Because the scheduler already takes
> > care of that.
> 
> Hi Frederic,
> 
> No. We pin vCPU threads one-to-one to host CPUs, without
> oversubscription. By "full allocation" I meant that all allocatable
> host CPUs are in use, including CPUs outside the nohz_full set.
> 
> For example, on an eight-CPU host booted with isolcpus=nohz,1-7,
> CPU0 is outside the nohz_full set:
> 
> - With eight pinned vCPUs, CPU0 retains its non-idle tick while
>   CPUs1-7 may stop theirs. Retaining the tick on CPUs1-7 too avoids
>   this placement-dependent difference in tick interference between
>   otherwise equivalent vCPUs.
> 
> - With seven or fewer pinned vCPUs, we can leave CPU0 without a
>   vCPU and keep them on CPUs1-7. We can then allow tick suppression
>   on CPUs1-7, subject to the existing dependencies. This gives
>   these vCPUs a common tick policy while reducing host tick
>   interference.
> 
> If the vCPU on CPU0 is released while the other seven remain
> running, we allow CPUs1-7 to suppress their ticks. If a new vCPU
> is later assigned to CPU0, we retain the ticks on CPUs1-7 again
> to avoid the difference in tick interference.
> 
> Throughout these transitions, CPU1 can still have its original
> pinned vCPU thread as its only runnable task. Its runnable task
> count does not change merely because CPU0 gains or loses a vCPU,
> so the scheduler's existing tick dependency cannot express this
> allocation policy.

Ok now I understand what you want to do, I just don't understand why.
Why it matters to turn off nohz_full on all CPUs when vCPUs run on housekeeping?

> > > Add a per-CPU POLICY dependency within the boot-time nohz_full set.
> > > Permission defaults to enabled. The policy can be changed without
> > > taking CPUs offline. Revoking permission uses the existing asynchronous
> > > kick; granting it leaves all other dependencies effective. Preserve
> > > POLICY across CPU hotplug and report it in tick_stop tracing.
> > > 
> > > Idle tick suppression, nohz_full membership, context tracking, RCU
> > > offloading and housekeeping configuration are unchanged.
> > 
> > This still keeps the overhead of nohz_full even if the tick stays on, right?
> > (RCU nocb, kernel <-> user overhead, etc...). Isn't it a problem for you?
> 
> Yes. Our setup uses only the nohz flag of isolcpus, without
> additional housekeeping affinity tuning. Context tracking and
> RCU callback offloading remain enabled when the tick is kept
> running.
> 
> We have observed a performance benefit from this nohz_full setup
> with our database workload running on pinned vCPUs.

Do you mean that your database runs better when hosts CPUs are in nohz_full?
But how does this new interface help? Ie: why is it worse to have all CPUs in
nohz_full except the housekeeping rather than shutting down nohz_full
altogether?

Or to put it another way: why is it better to have either:

- all vCPUs on nohz_full host CPUs
or
- all vCPUs on ticking CPUs

And why does it hurt to have a single vCPU running on a ticking CPU.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
