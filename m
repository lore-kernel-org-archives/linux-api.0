Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD6C222580;
	Fri, 16 Oct 2026 02:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792118046; cv=none; b=T9VvHgUQlZzJ1u86R1q95TKq4uiAiRzAaeU+QmZUmOg/JLGBdIjQ4NV9H8FQsOVMRhjRRrxZE7uI/t/xFAOQqClhU5zDGORmvjkRvNAdDCd1QT804MMN/vAuAwbzRxStYyNn6EMnwkojXgM4G+ojGSfzlZG87QDHp1eNhsgF6aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792118046; c=relaxed/simple;
	bh=2mlYCwTuDre2pY1UtM0QzTBYr7c2iLuTUGPMKaJprRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQBHcFqY0J2VH21EywwaztEVTl0FiJbN590JXZ5RRrRv6O1sa68+cU4hnWys3SK6ApEQREpJX6384rC+viI50QbLu+ZRxm8dV2JzVWgkEKzq6zIyCq0HuIJQS0Vn9AC8HQlbxNP3HPaepKRdCXLy44/BvMs2gyezj+Kp7joW5/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=j4Yy7sNx; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="j4Yy7sNx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792118040; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=GwRBWNugQ+ez7PQ9anvHaCPoVAAqhLatL//ZldKkejU=;
	b=j4Yy7sNxe7z7Qw9jfOs8+FQTof7RB5qWlyP/piynZTCl6X1pYGxmogjlcTFErzhd70ZYDvvubtCGaYX0Il4JGdCQ6ZrzCeeiRVupJ2HDHvc16SZ9LvxEsuD4mE3fTAdQJEyOh8V5LJ1f4WLDgaEVRUiHRF8YF6tEMWmv0ApanNs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCtIv.x_1792118038;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XCtIv.x_1792118038 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 16 Oct 2026 10:33:59 +0800
Date: Fri, 16 Oct 2026 10:33:58 +0800
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
Message-ID: <atGNFhQk9Uj-wuVu@MacBook-Pro.local>
Reply-To: Peng Wang <peng_wang@linux.alibaba.com>
References: <cover.1792067271.git.peng_wang@linux.alibaba.com>
 <8d10bb84-d312-4be0-8c43-ddd602850a1d@redhat.com>
 <atER8P0ws6Gg4GWE@MacBook-Pro.local>
 <f12ad8ee-4cad-4c7e-a0c9-c22fe894f14c@redhat.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f12ad8ee-4cad-4c7e-a0c9-c22fe894f14c@redhat.com>

On Thu, Oct 15, 2026 at 04:13:49PM -0400, Waiman Long wrote:
> On 10/15/26 1:48 PM, Peng Wang wrote:
> > On Thu, Oct 15, 2026 at 12:00:25PM -0400, Waiman Long wrote:
> > > On 10/15/26 8:43 AM, Peng Wang wrote:
> > > > Workloads and their need for periodic ticks can change after boot.
> > > > This series lets userspace choose at runtime which CPUs in the boot-time
> > > > nohz_full set retain the non-idle scheduler tick and which are permitted
> > > > to stop it, while preserving the existing isolation configuration.
> > > > 
> > > > The first patch adds a per-CPU tick dependency; the second exposes a
> > > > sysfs CPU list. Permission defaults to all nohz_full CPUs. Revocation
> > > > uses the existing asynchronous kick. Idle tick suppression is unchanged,
> > > > and policy persists across hotplug.
> > > So you are basically setting up more nohz_full CPUs than the system actually
> > > needs to use at the moment and so want to disable nohz/tick part of
> > > nohz_full CPUs that don't need it. Can you elaborate more about the problems
> > > solve by introducing this new behavior?
> > Hi Waiman,
> > 
> > Yes. We have CPU-pinned workloads that benefit from reduced periodic
> > tick interference. The desired tick policy changes with CPU allocation.
> > 
> > With spare capacity, we allow selected nohz_full CPUs to stop their
> > tick. When capacity is fully allocated, we prefer to retain the
> > non-idle periodic tick across CPUs, avoiding an additional difference
> > in tick interference between housekeeping and nohz_full CPUs.
> What problem does that cause?

Hi Waiman,

The concern is placement-dependent performance variation between
vCPUs sold under the same specification. Customers do not see which
host CPU backs their vCPU, so such differences would appear as
unexplained variation within the same specification.

At full allocation, we want a consistent non-idle tick policy across
the allocated CPUs to avoid this additional source of variation.

> > A CPU may still have only one runnable task in either case, so the
> > existing tick dependencies do not express this policy.
> > 
> > This series keeps the boot-time nohz_full CPU set, context tracking,
> > RCU offloading and housekeeping configuration unchanged. It only
> > controls whether those CPUs may stop their non-idle tick. The policy
> > can be changed without taking CPUs offline.
> 
> So the policy is to make the tick keeps running when there is only one
> running task. Right? I am just not clear about the advantage of doing that.
> Is there a use case that will require this particular feature? I doubt this
> will get accepted unless there is a compelling reason to show why we will
> want to have this feature.

Yes. We run cloud hosts with vCPU threads pinned one-to-one to host
CPUs. Some CPUs are kept outside nohz_full for housekeeping, but
they also provide vCPU capacity at full allocation. Dedicating them
exclusively to housekeeping would reduce the capacity available to
guests.

At full allocation, vCPUs also run on housekeeping CPUs, which
retain their non-idle tick. Allowing only the nohz_full CPUs to stop
the tick would introduce a placement-dependent difference in tick
behavior between vCPUs of the same specification.

We therefore want to restore the non-idle tick on those nohz_full
CPUs, accepting the extra tick overhead to remove this controllable
difference. Host-side background activity is limited in this
deployment, and we can tolerate the remaining housekeeping noise.

With spare capacity, we want to allow selected nohz_full CPUs to
stop the tick to reduce host scheduler-tick interference with guest
execution. This is an opportunistic optimization when capacity
permits.

Host allocation changes as customers acquire or release vCPUs, while
other customers' VMs continue running.

A nohz_full CPU hosting a remaining vCPU may still have that vCPU
thread as its only runnable task, whether the host is fully or
partially allocated. The existing tick dependencies therefore do
not express the desired change in policy.

The proposed control allows per-CPU runtime changes without taking
CPUs offline or changing the boot-time nohz_full set or other
isolation settings.

Thanks,
Peng

> 
> Cheers,
> Longman
> 
