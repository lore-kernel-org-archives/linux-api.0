Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6DF53F690
	for <linux-api@vger.kernel.org>; Thu, 15 Oct 2026 16:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792080461; cv=none; b=K5SK8exhIlcBUReA7FYn5toCHHgt+SVb03kbbeS14EXtal9FrNaV90oKnEfwo8O8DsB9C00VQOrYqt/8luxGc5kX+GhrNA0KtsDHnVbTgbjSYMsS4Y3b8FOxoYyXWqmZgtZbN2LQrriHGT0GT8j0D9SvQA52Lxu9yIzWe1fCnOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792080461; c=relaxed/simple;
	bh=xnKWrE1Omy01mo+6cTfcJuIBThWWbMeGacsUgaGPQCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sCqwbCtqtswTHXpxmODR2XkTioL4mfn73kjLM1mW5SaYa0r+8pGT86D6JCUGYeqqvAhikhApG8i/4hsEUgHgmvzhY1Z/698yBBrab/2tTaHFQorKyQm8wn5okoqwG/6H++ooVKd1SYu+0/sgkGHYxu4VTCRZVLGcZPC/CwCQ4VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TPBQHJFY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TPBQHJFY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792080446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HubSHotYOf/oGf2cBN9rOHOiLgBKo8BUDdzp8n8K/8M=;
	b=TPBQHJFYHdeEeI1JQaOrnLhrq6gWzLEEI9ceNtTcPmpsSvT6WtsTnWwnyaitLbTac0tlz8
	PKiVw8W+1FHr0qnTyAp6NkIOsheWb2/ECqT64y3HrsvwnCGxZHt7tgsDUOx07JLeICAIk0
	s21roKHmQksYG9NZ5gM57gsWQSqldHg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-jNf5vPUTP0uYF0DzuvHGWA-1; Thu,
 15 Oct 2026 16:07:22 +0000
X-MC-Unique: jNf5vPUTP0uYF0DzuvHGWA-1
X-Mimecast-MFC-AGG-ID: jNf5vPUTP0uYF0DzuvHGWA_1792080439
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F1A51955F0D;
	Thu, 15 Oct 2026 16:07:19 +0000 (UTC)
Received: from [100.91.18.181] (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A98E018001CA;
	Thu, 15 Oct 2026 16:07:15 +0000 (UTC)
Message-ID: <5f2b1519-6693-4d5c-afb7-4202a6d48365@redhat.com>
Date: Thu, 15 Oct 2026 12:07:14 -0400
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] cpu: Add sysfs control of full dynticks policy
To: Peng Wang <peng_wang@linux.alibaba.com>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
 He Rongguang <herongguang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, driver-core@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <cover.1792067271.git.peng_wang@linux.alibaba.com>
 <e93ef15796946485eaaecd774141378351307940.1792067271.git.peng_wang@linux.alibaba.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <e93ef15796946485eaaecd774141378351307940.1792067271.git.peng_wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


On 10/15/26 8:43 AM, Peng Wang wrote:
> Expose nohz_full_allowed under /sys/devices/system/cpu/ as the subset of
> nohz_full CPUs permitted to suppress their non-idle scheduler tick.
>
> Writes replace the entire list; reads report policy, not current tick
> state. Reject invalid input before updating policy. Document asynchronous
> revocation, offline CPU configuration and persistence across hotplug.
> The existing nohz_full attribute continues to report membership.
>
> Co-developed-by: He Rongguang <herongguang@linux.alibaba.com>
> Signed-off-by: He Rongguang <herongguang@linux.alibaba.com>
> Signed-off-by: Peng Wang <peng_wang@linux.alibaba.com>
> ---
>   .../ABI/testing/sysfs-devices-system-cpu      | 40 ++++++++++++++++
>   drivers/base/cpu.c                            | 46 +++++++++++++++++++
>   2 files changed, 86 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index 82d10d556cc89..edf3408fd84c8 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -767,6 +767,46 @@ Description:	Preferred MTE tag checking mode
>   
>   		See also: Documentation/arch/arm64/memory-tagging-extension.rst
>   
> +What:		/sys/devices/system/cpu/nohz_full_allowed

I do have a problem with the name of this sysfs file. nohz_full is more 
than just the tick. The naming may introduce the wrong impression that 
all nohz_full behavior can be controlled. May be a name like 
"nohz_tick_allowed" which is much more specific will be better.

Regards,
Longman

> +Date:		October 2026
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +Description:
> +		(RW) CPUs permitted to stop the scheduler tick while non-idle.
> +		Available with CONFIG_NO_HZ_FULL. The default is the complete
> +		nohz_full CPU list. Readback reports permission, not the current
> +		tick state: all the usual tick dependencies still apply.
> +
> +		A write replaces the entire list, using CPU-list syntax (for
> +		example, "1-3,5"). An empty line revokes permission from all
> +		nohz_full CPUs. Invalid input is rejected without changing
> +		policy. A parsed list containing CPUs outside nohz_full fails
> +		with EINVAL. CPU numbers beyond the mask range and numeric
> +		overflows are rejected by the CPU-list parser with ERANGE and
> +		EOVERFLOW, respectively. Input must be shorter than PAGE_SIZE
> +		bytes, otherwise E2BIG is returned. Embedded NULs and newlines
> +		other than a trailing newline are rejected with EINVAL. Valid
> +		writes without an active nohz_full configuration fail with
> +		EOPNOTSUPP.
> +
> +		Reads fail with EOVERFLOW if the formatted output reaches
> +		PAGE_SIZE - 1 bytes, rather than returning a potentially
> +		truncated CPU list.
> +
> +		Revoking permission adds a per-CPU tick dependency. Online CPUs
> +		are notified through the existing asynchronous kick mechanism
> +		to restart a stopped non-idle tick. A successful write means
> +		the policy is updated and any needed notification is queued;
> +		it does not wait for tick restart. Changes to multiple CPUs
> +		are not simultaneous. Granting permission only removes this
> +		dependency and does not force the tick to stop.
> +
> +		Offline CPUs may be configured without sending notifications.
> +		Policy persists across CPU offline/online. Idle tick suppression
> +		is unchanged; the policy applies when a CPU leaves idle.
> +
> +		This interface does not change nohz_full membership, context
> +		tracking, RCU offloading, or housekeeping configuration.
> +
>   What:		/sys/devices/system/cpu/nohz_full
>   Date:		Apr 2015
>   Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 69e52fed42415..299ce61cef895 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -324,6 +324,51 @@ static ssize_t nohz_full_show(struct device *dev,
>   	return sysfs_emit(buf, "\n");
>   }
>   static DEVICE_ATTR_RO(nohz_full);
> +
> +static ssize_t nohz_full_allowed_show(struct device *dev,
> +				      struct device_attribute *attr, char *buf)
> +{
> +	cpumask_var_t mask;
> +	ssize_t ret;
> +
> +	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	tick_nohz_full_get_allowed(mask);
> +	ret = sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(mask));
> +
> +	free_cpumask_var(mask);
> +
> +	/* Never present a truncated CPU list as the complete policy. */
> +	return ret == PAGE_SIZE - 1 ? -EOVERFLOW : ret;
> +}
> +
> +static ssize_t nohz_full_allowed_store(struct device *dev,
> +				       struct device_attribute *attr,
> +				       const char *buf, size_t count)
> +{
> +	cpumask_var_t mask;
> +	int ret;
> +
> +	/* kernfs may truncate an oversized write to PAGE_SIZE. */
> +	if (count >= PAGE_SIZE)
> +		return -E2BIG;
> +	if (memchr(buf, '\0', count) ||
> +	    (count > 1 && memchr(buf, '\n', count - 1)))
> +		return -EINVAL;
> +
> +	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	ret = cpulist_parse(buf, mask);
> +	if (!ret)
> +		ret = tick_nohz_full_set_allowed(mask);
> +
> +	free_cpumask_var(mask);
> +
> +	return ret ? ret : count;
> +}
> +static DEVICE_ATTR_RW(nohz_full_allowed);
>   #endif
>   
>   #ifdef CONFIG_CRASH_HOTPLUG
> @@ -525,6 +570,7 @@ static struct attribute *cpu_root_attrs[] = {
>   	&dev_attr_housekeeping.attr,
>   #ifdef CONFIG_NO_HZ_FULL
>   	&dev_attr_nohz_full.attr,
> +	&dev_attr_nohz_full_allowed.attr,
>   #endif
>   #ifdef CONFIG_CRASH_HOTPLUG
>   	&dev_attr_crash_hotplug.attr,

