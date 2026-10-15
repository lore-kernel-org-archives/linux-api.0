Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770B1429029;
	Thu, 15 Oct 2026 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792086538; cv=none; b=J3bxp+b+ujevT7xjV8GPjuAK6tqUFJUO8YL/+vYnQiQQCWFIojgf1ZzFmuRDVwXS14Q7E4cxuA9E6h+IbMMz/9PGhoOZBkozgSHBgWGF1Op78Vi2zRcMBJCUKk4LgFv9jyUcvUkz9YPk44DfHhbPqUn6EBze+5ltDj9yny0Zmy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792086538; c=relaxed/simple;
	bh=9c2/PaGf1u2yPgJLZdE2wgl/BvhUgfPpxVWHX6kIGWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUuRo5ro/GvtJ6tDFcVkseGDUf/bhwGk5yUlqMklh9NzBia8PSAI4zUJdw9/A3XjAAy2eV/T6ZweO3EeHyUEATWTdg0RIQ9D39j72b9jUCuFL993PckVRR9VNiT5O6uXvhdneeuZWQ+DXFFVQCDtkVm7L/Zwo3rg9QTZiMxem4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SRkneZY7; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SRkneZY7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792086514; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=dkulAnttC6PoebpWm1nHtQ7Lp9yXSkyxV6VmIgyOjW0=;
	b=SRkneZY7+Rt1Y2x6YqysYgUlJffnd/7uYUPzsJ3JFZNyI4FD33ShjSUkSCX8gM72rkIOAoZyya6pOlnUYWZJfvkmen5TAT/pV2Bsl6ZPJ2Ec94peVm10ccpkNioSOtMj5bBWRhsBq5lWxTyIKw2HEAi1nLFibI1VBCc6CvD1maw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCsGuGY_1792086512;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XCsGuGY_1792086512 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 16 Oct 2026 01:48:33 +0800
Date: Fri, 16 Oct 2026 01:48:32 +0800
From: Peng Wang <peng_wang@linux.alibaba.com>
To: Waiman Long <longman@redhat.com>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
	He Rongguang <herongguang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	driver-core@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] tick/nohz: Add runtime control of non-idle tick
 suppression
Message-ID: <atER8P0ws6Gg4GWE@MacBook-Pro.local>
Reply-To: Peng Wang <peng_wang@linux.alibaba.com>
References: <cover.1792067271.git.peng_wang@linux.alibaba.com>
 <8d10bb84-d312-4be0-8c43-ddd602850a1d@redhat.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d10bb84-d312-4be0-8c43-ddd602850a1d@redhat.com>

On Thu, Oct 15, 2026 at 12:00:25PM -0400, Waiman Long wrote:
> On 10/15/26 8:43 AM, Peng Wang wrote:
> > Workloads and their need for periodic ticks can change after boot.
> > This series lets userspace choose at runtime which CPUs in the boot-time
> > nohz_full set retain the non-idle scheduler tick and which are permitted
> > to stop it, while preserving the existing isolation configuration.
> > 
> > The first patch adds a per-CPU tick dependency; the second exposes a
> > sysfs CPU list. Permission defaults to all nohz_full CPUs. Revocation
> > uses the existing asynchronous kick. Idle tick suppression is unchanged,
> > and policy persists across hotplug.
> So you are basically setting up more nohz_full CPUs than the system actually
> needs to use at the moment and so want to disable nohz/tick part of
> nohz_full CPUs that don't need it. Can you elaborate more about the problems
> solve by introducing this new behavior?

Hi Waiman,

Yes. We have CPU-pinned workloads that benefit from reduced periodic
tick interference. The desired tick policy changes with CPU allocation.

With spare capacity, we allow selected nohz_full CPUs to stop their
tick. When capacity is fully allocated, we prefer to retain the
non-idle periodic tick across CPUs, avoiding an additional difference
in tick interference between housekeeping and nohz_full CPUs.
A CPU may still have only one runnable task in either case, so the
existing tick dependencies do not express this policy.

This series keeps the boot-time nohz_full CPU set, context tracking,
RCU offloading and housekeeping configuration unchanged. It only
controls whether those CPUs may stop their non-idle tick. The policy
can be changed without taking CPUs offline.

> > 
> > Existing cpuset partition modes do not express this independent tick
> > policy. Feedback on the proposed interface is welcome.
> 
> We are planning to eventually extend cpuset partition mode to change
> nohz_full at runtime. This is still a work in progress.

Thanks for mentioning the cpuset work. Would this tick-only policy
fit into that plan? The core mechanism in patch 1 is independent of
the sysfs interface.

Thanks,
Peng

> 
> Regards,
> Longman
> 
> > 
> > Thanks,
> > Peng
> > 
> > Peng Wang (2):
> >    tick/nohz: Add a policy dependency for full dynticks
> >    cpu: Add sysfs control of full dynticks policy
> > 
> >   .../ABI/testing/sysfs-devices-system-cpu      | 40 ++++++++++++
> >   drivers/base/cpu.c                            | 46 ++++++++++++++
> >   include/linux/tick.h                          |  8 ++-
> >   include/trace/events/timer.h                  |  3 +-
> >   kernel/time/tick-sched.c                      | 62 +++++++++++++++++++
> >   5 files changed, 156 insertions(+), 3 deletions(-)
> > 
> > 
> > base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
> 
