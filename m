Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350412E719B;
	Sat, 17 Oct 2026 08:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792224262; cv=none; b=kvn/l8CWzCHvXLee4ysuRi4lHudqhOF65EQ7Pd0fNqDBCe7ze0vHmW8pW6rmXH9WcOA8DUu9RAGqCRSpBm6o4UIKr0sE2FgM0ouIY9cPSb1iXbJ3Y2WVb6wTVjFVlsPbfc7yxZzwBCEK4V61MKv2pDGo3oElR8/A7L5ULiUjQ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792224262; c=relaxed/simple;
	bh=7qDI74gjHZJGEwkABMcZSoA0MbCGw9LlI8XM9CtMxr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pyv2xzpAZLZNJ9hKG4DifCrfk+m45I9JfPcWDoCmpTSSv2uUD86LLYCVQwWiS0G21IjAcbQeh6Rzog1U37VM7kOsKZGmgrbqV2GkthJv3M0RNG783ADRpdbBh/fJiYLH9/RYx8I43Mx8jAJMV4QTsHFKlJT99W4n5M4e423j7yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Msrv+BWb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Msrv+BWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32EB1F000C4;
	Sat, 17 Oct 2026 08:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792224260;
	bh=rbdJEzm5e/9pK3FIuLFI29o7B4dQ9T6z556KPHhg9Xc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Msrv+BWbTWkRxy7NwxshktzSRodYDmSL0oB1UrHevfw8y1D3qVmOCiGtsqoLrvrqd
	 EgypIPZk3djOJSyw6qwSBif0cY/rRKubPS36GWOfYdZ0wjIodZWxBZfAdwwnmb23XC
	 5LK1W2fC2ZNSzebGK1mcW83rV7rZI6HWPpZveRng=
Date: Sat, 17 Oct 2026 10:04:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Wang <peng_wang@linux.alibaba.com>
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
Message-ID: <2026101743-monotype-demeaning-f97b@gregkh>
References: <cover.1792067271.git.peng_wang@linux.alibaba.com>
 <e93ef15796946485eaaecd774141378351307940.1792067271.git.peng_wang@linux.alibaba.com>
 <2026101646-speller-gutter-c184@gregkh>
 <atJea4b6VvYlAvbD@MacBook-Pro.local>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atJea4b6VvYlAvbD@MacBook-Pro.local>

On Sat, Oct 17, 2026 at 01:27:07AM +0800, Peng Wang wrote:
> On Fri, Oct 16, 2026 at 06:25:26PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Oct 15, 2026 at 08:43:09PM +0800, Peng Wang wrote:
> > > Expose nohz_full_allowed under /sys/devices/system/cpu/ as the subset of
> > > nohz_full CPUs permitted to suppress their non-idle scheduler tick.
> > > 
> > > Writes replace the entire list; reads report policy, not current tick
> > > state. Reject invalid input before updating policy. Document asynchronous
> > > revocation, offline CPU configuration and persistence across hotplug.
> > > The existing nohz_full attribute continues to report membership.
> > > 
> > > Co-developed-by: He Rongguang <herongguang@linux.alibaba.com>
> > > Signed-off-by: He Rongguang <herongguang@linux.alibaba.com>
> > > Signed-off-by: Peng Wang <peng_wang@linux.alibaba.com>
> > > ---
> > >  .../ABI/testing/sysfs-devices-system-cpu      | 40 ++++++++++++++++
> > >  drivers/base/cpu.c                            | 46 +++++++++++++++++++
> > >  2 files changed, 86 insertions(+)
> > > 
> > > diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> > > index 82d10d556cc89..edf3408fd84c8 100644
> > > --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> > > +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> > > @@ -767,6 +767,46 @@ Description:	Preferred MTE tag checking mode
> > >  
> > >  		See also: Documentation/arch/arm64/memory-tagging-extension.rst
> > >  
> > > +What:		/sys/devices/system/cpu/nohz_full_allowed
> > > +Date:		October 2026
> > > +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> > > +Description:
> > > +		(RW) CPUs permitted to stop the scheduler tick while non-idle.
> > > +		Available with CONFIG_NO_HZ_FULL. The default is the complete
> > > +		nohz_full CPU list. Readback reports permission, not the current
> > > +		tick state: all the usual tick dependencies still apply.
> > > +
> > > +		A write replaces the entire list, using CPU-list syntax (for
> > > +		example, "1-3,5"). An empty line revokes permission from all
> > > +		nohz_full CPUs. Invalid input is rejected without changing
> > > +		policy. A parsed list containing CPUs outside nohz_full fails
> > > +		with EINVAL. CPU numbers beyond the mask range and numeric
> > > +		overflows are rejected by the CPU-list parser with ERANGE and
> > > +		EOVERFLOW, respectively. Input must be shorter than PAGE_SIZE
> > > +		bytes, otherwise E2BIG is returned. Embedded NULs and newlines
> > > +		other than a trailing newline are rejected with EINVAL. Valid
> > > +		writes without an active nohz_full configuration fail with
> > > +		EOPNOTSUPP.
> > > +
> > > +		Reads fail with EOVERFLOW if the formatted output reaches
> > > +		PAGE_SIZE - 1 bytes, rather than returning a potentially
> > > +		truncated CPU list.
> > > +
> > > +		Revoking permission adds a per-CPU tick dependency. Online CPUs
> > > +		are notified through the existing asynchronous kick mechanism
> > > +		to restart a stopped non-idle tick. A successful write means
> > > +		the policy is updated and any needed notification is queued;
> > > +		it does not wait for tick restart. Changes to multiple CPUs
> > > +		are not simultaneous. Granting permission only removes this
> > > +		dependency and does not force the tick to stop.
> > > +
> > > +		Offline CPUs may be configured without sending notifications.
> > > +		Policy persists across CPU offline/online. Idle tick suppression
> > > +		is unchanged; the policy applies when a CPU leaves idle.
> > > +
> > > +		This interface does not change nohz_full membership, context
> > > +		tracking, RCU offloading, or housekeeping configuration.
> > > +
> > >  What:		/sys/devices/system/cpu/nohz_full
> > >  Date:		Apr 2015
> > >  Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> > > diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> > > index 69e52fed42415..299ce61cef895 100644
> > > --- a/drivers/base/cpu.c
> > > +++ b/drivers/base/cpu.c
> > > @@ -324,6 +324,51 @@ static ssize_t nohz_full_show(struct device *dev,
> > >  	return sysfs_emit(buf, "\n");
> > >  }
> > >  static DEVICE_ATTR_RO(nohz_full);
> > > +
> > > +static ssize_t nohz_full_allowed_show(struct device *dev,
> > > +				      struct device_attribute *attr, char *buf)
> > > +{
> > > +	cpumask_var_t mask;
> > > +	ssize_t ret;
> > > +
> > > +	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
> > > +		return -ENOMEM;
> > > +
> > > +	tick_nohz_full_get_allowed(mask);
> > > +	ret = sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(mask));
> > > +
> > > +	free_cpumask_var(mask);
> > > +
> > > +	/* Never present a truncated CPU list as the complete policy. */
> > > +	return ret == PAGE_SIZE - 1 ? -EOVERFLOW : ret;
> > 
> > Why not?  What will userspace do then if it gets -EOVERFLOW as it can
> > not get the full list?
> 
> Hi Greg,
> 
> There is no way to retrieve the full list through this attribute.
> The intent was to avoid returning a truncated list that userspace
> could write back, unintentionally revoking permission for the omitted
> CPUs. Returning an error does not solve that interface limitation.

If you _MUST_ have such a size of a sysfs file, then use a binary
attribute which can accept any size.  I think we have had to do that for
other sysfs files that show this information in the past, right?  Please
check them.

> > > +}
> > > +
> > > +static ssize_t nohz_full_allowed_store(struct device *dev,
> > > +				       struct device_attribute *attr,
> > > +				       const char *buf, size_t count)
> > > +{
> > > +	cpumask_var_t mask;
> > > +	int ret;
> > > +
> > > +	/* kernfs may truncate an oversized write to PAGE_SIZE. */
> > > +	if (count >= PAGE_SIZE)
> > > +		return -E2BIG;
> > 
> > How are you getting a larger than PAGE_SIZE value here?
> 
> I cannot; kernfs caps count at PAGE_SIZE. The check is intended for
> count == PAGE_SIZE, to avoid applying a potentially truncated prefix
> as a complete list. It also rejects an exactly page-sized input.

If the check is for == PAGE_SIZE then check for that, not for something
that can never happen :)

But again, don't do this at all by using a binary attribute if you are
going to be needing to accept larger amounts of data.  Don't create a
known-broken api from the start please.

> > 
> > > +	if (memchr(buf, '\0', count) ||
> > > +	    (count > 1 && memchr(buf, '\n', count - 1)))
> > > +		return -EINVAL;
> > 
> > What are you testing for here, sorry, I can't easily figure it out.
> 
> The checks reject user-supplied NULs and non-final newlines.
> For example, cpulist_parse() accepts "1\n2\n" as CPU 1 only, while
> store() would report the full input as consumed. The NUL appended
> by kernfs is at buf[count], outside the checked range.

Please document that in a comment here.

> I propose replacing the global attribute with
> /sys/devices/system/cpu/cpuN/nohz_tick_allowed, available only on
> nohz_full CPUs. Writing 0 would prevent non-idle tick suppression,
> using the existing asynchronous kick when needed. Writing 1 would
> allow suppression, subject to the existing tick dependencies.
> Readback would report policy, not the current tick state.
> 
> Each write would affect only that CPU, without changing nohz_full
> membership or other isolation settings. This would give up the
> single-write whole-list replacement. Would that be a better fit?

That's much simpler, so I'm all for that from a sysfs point of view,
thanks.

greg k-h
