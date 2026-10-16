Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288D457267E;
	Fri, 16 Oct 2026 17:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792171637; cv=none; b=ugpXa6xmc5E7Nk8CCAuVVbuTVZ+c3BV3+E47hc0hv+xt+XTWAA/kBtLycLYCzzxIWtUpRAtpeFnkLl0eIi5L0hB0lkyJggwUAo0lEDfPu51NdO2GjXajZQVebs/h4wKu0xFK5kC3jRDN1plDBaDQvq9v33lGo7hWtMak4mYHmEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792171637; c=relaxed/simple;
	bh=STyj/lYVqM8gAurdqYy6Pjs7GEOpRb+Xus0p1OR+ffU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRaI6nrWV28srHevAL3C0cBozdRIkZ3I/nAvWHBFg3zaD03rK8NGgRfEkmDnA8sEjc/ohpaJOzUoHNEfO7/Yf6IGLCY7xIFvdhnlo1Mf080P3KOcJmReTtTZ9MkjWcoRbPYUIsXaT0TD+2LtKvGwK3uyoJcVmo3qaFFaAOYUZ0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vTk+hQhE; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vTk+hQhE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792171630; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=1juLGbyehF1Q7piOkFmo3ZV7cET5DQh/zeO/hMNZHdU=;
	b=vTk+hQhEe3thvP15S5N+dOnPLikFnr1gqSW5J4K6tFO9hekQ4dm9bQOHBtrhoWP7NEbXZFDXvI+l045KmwFSy2OBMAqHxn8xvYu5CyM+VONJAuWlayqYorBj4xvjMtmJqeiylVnFgSxDiO6dc1ixoTg1ALAAt6u4UHq1Ozt3Sbw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCvPRM5_1792171628;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XCvPRM5_1792171628 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 17 Oct 2026 01:27:09 +0800
Date: Sat, 17 Oct 2026 01:27:07 +0800
From: Peng Wang <peng_wang@linux.alibaba.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
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
Subject: Re: [RFC PATCH 2/2] cpu: Add sysfs control of full dynticks policy
Message-ID: <atJea4b6VvYlAvbD@MacBook-Pro.local>
Reply-To: Peng Wang <peng_wang@linux.alibaba.com>
References: <cover.1792067271.git.peng_wang@linux.alibaba.com>
 <e93ef15796946485eaaecd774141378351307940.1792067271.git.peng_wang@linux.alibaba.com>
 <2026101646-speller-gutter-c184@gregkh>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026101646-speller-gutter-c184@gregkh>

On Fri, Oct 16, 2026 at 06:25:26PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Oct 15, 2026 at 08:43:09PM +0800, Peng Wang wrote:
> > Expose nohz_full_allowed under /sys/devices/system/cpu/ as the subset of
> > nohz_full CPUs permitted to suppress their non-idle scheduler tick.
> > 
> > Writes replace the entire list; reads report policy, not current tick
> > state. Reject invalid input before updating policy. Document asynchronous
> > revocation, offline CPU configuration and persistence across hotplug.
> > The existing nohz_full attribute continues to report membership.
> > 
> > Co-developed-by: He Rongguang <herongguang@linux.alibaba.com>
> > Signed-off-by: He Rongguang <herongguang@linux.alibaba.com>
> > Signed-off-by: Peng Wang <peng_wang@linux.alibaba.com>
> > ---
> >  .../ABI/testing/sysfs-devices-system-cpu      | 40 ++++++++++++++++
> >  drivers/base/cpu.c                            | 46 +++++++++++++++++++
> >  2 files changed, 86 insertions(+)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> > index 82d10d556cc89..edf3408fd84c8 100644
> > --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> > +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> > @@ -767,6 +767,46 @@ Description:	Preferred MTE tag checking mode
> >  
> >  		See also: Documentation/arch/arm64/memory-tagging-extension.rst
> >  
> > +What:		/sys/devices/system/cpu/nohz_full_allowed
> > +Date:		October 2026
> > +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> > +Description:
> > +		(RW) CPUs permitted to stop the scheduler tick while non-idle.
> > +		Available with CONFIG_NO_HZ_FULL. The default is the complete
> > +		nohz_full CPU list. Readback reports permission, not the current
> > +		tick state: all the usual tick dependencies still apply.
> > +
> > +		A write replaces the entire list, using CPU-list syntax (for
> > +		example, "1-3,5"). An empty line revokes permission from all
> > +		nohz_full CPUs. Invalid input is rejected without changing
> > +		policy. A parsed list containing CPUs outside nohz_full fails
> > +		with EINVAL. CPU numbers beyond the mask range and numeric
> > +		overflows are rejected by the CPU-list parser with ERANGE and
> > +		EOVERFLOW, respectively. Input must be shorter than PAGE_SIZE
> > +		bytes, otherwise E2BIG is returned. Embedded NULs and newlines
> > +		other than a trailing newline are rejected with EINVAL. Valid
> > +		writes without an active nohz_full configuration fail with
> > +		EOPNOTSUPP.
> > +
> > +		Reads fail with EOVERFLOW if the formatted output reaches
> > +		PAGE_SIZE - 1 bytes, rather than returning a potentially
> > +		truncated CPU list.
> > +
> > +		Revoking permission adds a per-CPU tick dependency. Online CPUs
> > +		are notified through the existing asynchronous kick mechanism
> > +		to restart a stopped non-idle tick. A successful write means
> > +		the policy is updated and any needed notification is queued;
> > +		it does not wait for tick restart. Changes to multiple CPUs
> > +		are not simultaneous. Granting permission only removes this
> > +		dependency and does not force the tick to stop.
> > +
> > +		Offline CPUs may be configured without sending notifications.
> > +		Policy persists across CPU offline/online. Idle tick suppression
> > +		is unchanged; the policy applies when a CPU leaves idle.
> > +
> > +		This interface does not change nohz_full membership, context
> > +		tracking, RCU offloading, or housekeeping configuration.
> > +
> >  What:		/sys/devices/system/cpu/nohz_full
> >  Date:		Apr 2015
> >  Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> > diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> > index 69e52fed42415..299ce61cef895 100644
> > --- a/drivers/base/cpu.c
> > +++ b/drivers/base/cpu.c
> > @@ -324,6 +324,51 @@ static ssize_t nohz_full_show(struct device *dev,
> >  	return sysfs_emit(buf, "\n");
> >  }
> >  static DEVICE_ATTR_RO(nohz_full);
> > +
> > +static ssize_t nohz_full_allowed_show(struct device *dev,
> > +				      struct device_attribute *attr, char *buf)
> > +{
> > +	cpumask_var_t mask;
> > +	ssize_t ret;
> > +
> > +	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
> > +		return -ENOMEM;
> > +
> > +	tick_nohz_full_get_allowed(mask);
> > +	ret = sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(mask));
> > +
> > +	free_cpumask_var(mask);
> > +
> > +	/* Never present a truncated CPU list as the complete policy. */
> > +	return ret == PAGE_SIZE - 1 ? -EOVERFLOW : ret;
> 
> Why not?  What will userspace do then if it gets -EOVERFLOW as it can
> not get the full list?

Hi Greg,

There is no way to retrieve the full list through this attribute.
The intent was to avoid returning a truncated list that userspace
could write back, unintentionally revoking permission for the omitted
CPUs. Returning an error does not solve that interface limitation.

> 
> > +}
> > +
> > +static ssize_t nohz_full_allowed_store(struct device *dev,
> > +				       struct device_attribute *attr,
> > +				       const char *buf, size_t count)
> > +{
> > +	cpumask_var_t mask;
> > +	int ret;
> > +
> > +	/* kernfs may truncate an oversized write to PAGE_SIZE. */
> > +	if (count >= PAGE_SIZE)
> > +		return -E2BIG;
> 
> How are you getting a larger than PAGE_SIZE value here?

I cannot; kernfs caps count at PAGE_SIZE. The check is intended for
count == PAGE_SIZE, to avoid applying a potentially truncated prefix
as a complete list. It also rejects an exactly page-sized input.

> 
> > +	if (memchr(buf, '\0', count) ||
> > +	    (count > 1 && memchr(buf, '\n', count - 1)))
> > +		return -EINVAL;
> 
> What are you testing for here, sorry, I can't easily figure it out.

The checks reject user-supplied NULs and non-final newlines.
For example, cpulist_parse() accepts "1\n2\n" as CPU 1 only, while
store() would report the full input as consumed. The NUL appended
by kernfs is at buf[count], outside the checked range.

I propose replacing the global attribute with
/sys/devices/system/cpu/cpuN/nohz_tick_allowed, available only on
nohz_full CPUs. Writing 0 would prevent non-idle tick suppression,
using the existing asynchronous kick when needed. Writing 1 would
allow suppression, subject to the existing tick dependencies.
Readback would report policy, not the current tick state.

Each write would affect only that CPU, without changing nohz_full
membership or other isolation settings. This would give up the
single-write whole-list replacement. Would that be a better fit?

Thanks,
Peng

> 
> thanks,
> 
> greg k-h
