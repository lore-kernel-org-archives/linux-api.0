Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743EF526AA2;
	Thu, 15 Oct 2026 12:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068229; cv=none; b=bZGy47VpnMgCxRtE91OqpBLBUMyUrYHRw4C0giHQu5ZuUDcpI/olPwn8VBb+m3NxxCeVgbpK772yBiNe75nVuNbnaxai6lYLKBjAazSAwq5bQXwPDOGGuh4IwKAiMLn49b4XyyrMg8xuXUws/ZQYmsXa6mDQXmXaBWOPuFNXxtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068229; c=relaxed/simple;
	bh=dCkYiG28FMjtYsP3hQci4uxgaCcTKqUYsnUCHyC3Aro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtfG1QrI+ViwQqT0enrhW+lJfWx2uMfl6z2KYOYJU1BLXiTmlbD/+wwLD6/37dD0DsEMFnxRc66xt8uh1N5QtQqCNvPRWqmOD94a1JscucdHIK7yvRovrsEjjNUlsCILzDMlZagsmhRMF9prFAbSy26zrRHiv0iHwmXYx17+GZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Pz9s8UQ1; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Pz9s8UQ1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792068216; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=aQ9wvhtdSDD+mKc+7iAgPfLlhjTT/B1SZKpq9mlbJAM=;
	b=Pz9s8UQ1lm7jgsA99lExfwJO66GD2+sbBJp2Vmrq37il+zJZlTroFjuIe8s0l1IuTIJqfU36kaFcYm15lh412TDQ1NQLsKsc/iUdh1ENjurTlr+NezNBXpv3+0hqYzjldyKU17K4Ux0I1XOnxM9avPp8/YJIfipQ5JII1HOEy1Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCrqjaP_1792068215;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XCrqjaP_1792068215 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 15 Oct 2026 20:43:35 +0800
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
Subject: [RFC PATCH 2/2] cpu: Add sysfs control of full dynticks policy
Date: Thu, 15 Oct 2026 20:43:09 +0800
Message-ID: <e93ef15796946485eaaecd774141378351307940.1792067271.git.peng_wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1792067271.git.peng_wang@linux.alibaba.com>
References: <cover.1792067271.git.peng_wang@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose nohz_full_allowed under /sys/devices/system/cpu/ as the subset of
nohz_full CPUs permitted to suppress their non-idle scheduler tick.

Writes replace the entire list; reads report policy, not current tick
state. Reject invalid input before updating policy. Document asynchronous
revocation, offline CPU configuration and persistence across hotplug.
The existing nohz_full attribute continues to report membership.

Co-developed-by: He Rongguang <herongguang@linux.alibaba.com>
Signed-off-by: He Rongguang <herongguang@linux.alibaba.com>
Signed-off-by: Peng Wang <peng_wang@linux.alibaba.com>
---
 .../ABI/testing/sysfs-devices-system-cpu      | 40 ++++++++++++++++
 drivers/base/cpu.c                            | 46 +++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 82d10d556cc89..edf3408fd84c8 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -767,6 +767,46 @@ Description:	Preferred MTE tag checking mode
 
 		See also: Documentation/arch/arm64/memory-tagging-extension.rst
 
+What:		/sys/devices/system/cpu/nohz_full_allowed
+Date:		October 2026
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:
+		(RW) CPUs permitted to stop the scheduler tick while non-idle.
+		Available with CONFIG_NO_HZ_FULL. The default is the complete
+		nohz_full CPU list. Readback reports permission, not the current
+		tick state: all the usual tick dependencies still apply.
+
+		A write replaces the entire list, using CPU-list syntax (for
+		example, "1-3,5"). An empty line revokes permission from all
+		nohz_full CPUs. Invalid input is rejected without changing
+		policy. A parsed list containing CPUs outside nohz_full fails
+		with EINVAL. CPU numbers beyond the mask range and numeric
+		overflows are rejected by the CPU-list parser with ERANGE and
+		EOVERFLOW, respectively. Input must be shorter than PAGE_SIZE
+		bytes, otherwise E2BIG is returned. Embedded NULs and newlines
+		other than a trailing newline are rejected with EINVAL. Valid
+		writes without an active nohz_full configuration fail with
+		EOPNOTSUPP.
+
+		Reads fail with EOVERFLOW if the formatted output reaches
+		PAGE_SIZE - 1 bytes, rather than returning a potentially
+		truncated CPU list.
+
+		Revoking permission adds a per-CPU tick dependency. Online CPUs
+		are notified through the existing asynchronous kick mechanism
+		to restart a stopped non-idle tick. A successful write means
+		the policy is updated and any needed notification is queued;
+		it does not wait for tick restart. Changes to multiple CPUs
+		are not simultaneous. Granting permission only removes this
+		dependency and does not force the tick to stop.
+
+		Offline CPUs may be configured without sending notifications.
+		Policy persists across CPU offline/online. Idle tick suppression
+		is unchanged; the policy applies when a CPU leaves idle.
+
+		This interface does not change nohz_full membership, context
+		tracking, RCU offloading, or housekeeping configuration.
+
 What:		/sys/devices/system/cpu/nohz_full
 Date:		Apr 2015
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 69e52fed42415..299ce61cef895 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -324,6 +324,51 @@ static ssize_t nohz_full_show(struct device *dev,
 	return sysfs_emit(buf, "\n");
 }
 static DEVICE_ATTR_RO(nohz_full);
+
+static ssize_t nohz_full_allowed_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	cpumask_var_t mask;
+	ssize_t ret;
+
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	tick_nohz_full_get_allowed(mask);
+	ret = sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(mask));
+
+	free_cpumask_var(mask);
+
+	/* Never present a truncated CPU list as the complete policy. */
+	return ret == PAGE_SIZE - 1 ? -EOVERFLOW : ret;
+}
+
+static ssize_t nohz_full_allowed_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	cpumask_var_t mask;
+	int ret;
+
+	/* kernfs may truncate an oversized write to PAGE_SIZE. */
+	if (count >= PAGE_SIZE)
+		return -E2BIG;
+	if (memchr(buf, '\0', count) ||
+	    (count > 1 && memchr(buf, '\n', count - 1)))
+		return -EINVAL;
+
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	ret = cpulist_parse(buf, mask);
+	if (!ret)
+		ret = tick_nohz_full_set_allowed(mask);
+
+	free_cpumask_var(mask);
+
+	return ret ? ret : count;
+}
+static DEVICE_ATTR_RW(nohz_full_allowed);
 #endif
 
 #ifdef CONFIG_CRASH_HOTPLUG
@@ -525,6 +570,7 @@ static struct attribute *cpu_root_attrs[] = {
 	&dev_attr_housekeeping.attr,
 #ifdef CONFIG_NO_HZ_FULL
 	&dev_attr_nohz_full.attr,
+	&dev_attr_nohz_full_allowed.attr,
 #endif
 #ifdef CONFIG_CRASH_HOTPLUG
 	&dev_attr_crash_hotplug.attr,
