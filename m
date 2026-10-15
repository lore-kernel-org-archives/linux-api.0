Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609EE568FC7;
	Thu, 15 Oct 2026 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792086658; cv=none; b=PqirbS1o1owLR0ZAF9WTK+6edTxrL/uelmSOv8vFeWOoKNx5/KAuHgMF9YR+w0HUNk87SVtfr/CQAPqTXn7VuEqP5uxC5S3awXVUAp8XrRXxmO05JE5R4iEJdaNEKuAE7GEfFzWyAGpw3D4+5G7ByWQrjnslCro6mqhwOQbfFA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792086658; c=relaxed/simple;
	bh=R2WBw4Gg/cmC7jy75LHrgAUEe03aD6Qo0tsbSlw1dKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PpbiuBN7rfMF/y6vK4iCZVjjo9tVS1921DVNBPrO1MWmsW4heE72HJD2Jpva49BH8yq9RMZ/XokB7sNMcLvbnz8UpGCwzfSvnFZz4k/aJJKm5h57LhyKHwk8oRlBVXvPHXfNtyKz42tZ10Bpw80J1gx/jwlUp5xEfhthNNavAVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Xf47+RNj; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Xf47+RNj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792086642; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=l9Q5YpqYpJd9onDCM8db0IqtokPYusPa72Hj4TffybM=;
	b=Xf47+RNj10Y46QI+kiYGuHrMBPjCkgHYFzOcbqy+sYmUn7K/aN4q8LLw+ysEjWzz41Cb5K/P1qA/e6yYVfWqz8NkRQNXDDrTuq3wf5zOz6TQwYL7mUrd/mCSyvG3WV/Jx4CqKvwqPxyok55LjFkShaCUL37RzXRJuK4Vod2rRGA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCsOve5_1792086640;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XCsOve5_1792086640 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 16 Oct 2026 01:50:41 +0800
Date: Fri, 16 Oct 2026 01:50:40 +0800
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
Subject: Re: [RFC PATCH 2/2] cpu: Add sysfs control of full dynticks policy
Message-ID: <atEScHbaEEqOtzQw@MacBook-Pro.local>
Reply-To: Peng Wang <peng_wang@linux.alibaba.com>
References: <cover.1792067271.git.peng_wang@linux.alibaba.com>
 <e93ef15796946485eaaecd774141378351307940.1792067271.git.peng_wang@linux.alibaba.com>
 <5f2b1519-6693-4d5c-afb7-4202a6d48365@redhat.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f2b1519-6693-4d5c-afb7-4202a6d48365@redhat.com>

On Thu, Oct 15, 2026 at 12:07:14PM -0400, Waiman Long wrote:
> 
> On 10/15/26 8:43 AM, Peng Wang wrote:
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
> >   .../ABI/testing/sysfs-devices-system-cpu      | 40 ++++++++++++++++
> >   drivers/base/cpu.c                            | 46 +++++++++++++++++++
> >   2 files changed, 86 insertions(+)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> > index 82d10d556cc89..edf3408fd84c8 100644
> > --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> > +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> > @@ -767,6 +767,46 @@ Description:	Preferred MTE tag checking mode
> >   		See also: Documentation/arch/arm64/memory-tagging-extension.rst
> > +What:		/sys/devices/system/cpu/nohz_full_allowed
> 
> I do have a problem with the name of this sysfs file. nohz_full is more than
> just the tick. The naming may introduce the wrong impression that all
> nohz_full behavior can be controlled. May be a name like "nohz_tick_allowed"
> which is much more specific will be better.

Hi Waiman,

Agreed, nohz_tick_allowed describes the scope more accurately.
If the control remains in sysfs, I'll use that name in the next version.

Thanks,
Peng

> 
> Regards,
> Longman
> 
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
> >   What:		/sys/devices/system/cpu/nohz_full
> >   Date:		Apr 2015
> >   Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> > diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> > index 69e52fed42415..299ce61cef895 100644
> > --- a/drivers/base/cpu.c
> > +++ b/drivers/base/cpu.c
> > @@ -324,6 +324,51 @@ static ssize_t nohz_full_show(struct device *dev,
> >   	return sysfs_emit(buf, "\n");
> >   }
> >   static DEVICE_ATTR_RO(nohz_full);
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
> > +	if (memchr(buf, '\0', count) ||
> > +	    (count > 1 && memchr(buf, '\n', count - 1)))
> > +		return -EINVAL;
> > +
> > +	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
> > +		return -ENOMEM;
> > +
> > +	ret = cpulist_parse(buf, mask);
> > +	if (!ret)
> > +		ret = tick_nohz_full_set_allowed(mask);
> > +
> > +	free_cpumask_var(mask);
> > +
> > +	return ret ? ret : count;
> > +}
> > +static DEVICE_ATTR_RW(nohz_full_allowed);
> >   #endif
> >   #ifdef CONFIG_CRASH_HOTPLUG
> > @@ -525,6 +570,7 @@ static struct attribute *cpu_root_attrs[] = {
> >   	&dev_attr_housekeeping.attr,
> >   #ifdef CONFIG_NO_HZ_FULL
> >   	&dev_attr_nohz_full.attr,
> > +	&dev_attr_nohz_full_allowed.attr,
> >   #endif
> >   #ifdef CONFIG_CRASH_HOTPLUG
> >   	&dev_attr_crash_hotplug.attr,
> 
