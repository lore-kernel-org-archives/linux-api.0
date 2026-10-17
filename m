Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E793AD516;
	Sat, 17 Oct 2026 13:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792242845; cv=none; b=BWwyujJC3pBkCyQvhxDSuculVEzgfBAxkITmnGM/e1UeAYnyM8mBPRNM0Dx0P44zdn+GedCIZQHX/oPzBxPI7uw+flW/8N3FMpnPbK6jSG1n20zagu5CZ1dNKfX8+sNjRNI6F4m1nIP6alNyD6Tq70BO5oW026LaBQSHGNO3Ih0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792242845; c=relaxed/simple;
	bh=JhqV9qgcM/uvUapF+jThpqVr1FyMbJ+kztGNoub7Y/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjxw4IUzdOwKpTdPlssciyESlNCujxi9EFCYTSqakVVnBglHV1pby1mFq/f1RayRV6AgVSQzndtoVN+rYQgY4cYH4kt0vVs6rCArcRM7DM6A8ZPjvTHxoxLB5VzKG1O/o3n01cDlo+aI0FaWZcp2KCXYTn//t8r65rgAAZE86kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gkWe4Iw/; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gkWe4Iw/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792242834; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=h1wv041oPlWAQwmsLMvk9LUOMcsyK9a97+mNPFPm+oI=;
	b=gkWe4Iw/iTp7Jvy/0EBSRIgB72ZFMXmeG3Z9FcuqFd0ZBtE7iCBZym9oxC6ZQHAT83ICwkMPjqFzB15QyS6eJqgTIMAgQNr3S88HpEPpSdeLcIY0xnLMPvrlG4Z+pB/JUpR7PXjH9GVOOfmdEjQwL1IT7yG7SAEO2dIwFNBX6Ss=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCxEdhX_1792242832;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XCxEdhX_1792242832 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 17 Oct 2026 21:13:53 +0800
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
Subject: [RFC PATCH v2 2/2] cpu: Add per-CPU control of non-idle tick suppression
Date: Sat, 17 Oct 2026 21:13:42 +0800
Message-ID: <224314ef5ad5c3c7634f73efad433616eb1d68ca.1792242566.git.peng_wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1792242566.git.peng_wang@linux.alibaba.com>
References: <cover.1792242566.git.peng_wang@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose cpuN/nohz_tick_allowed on CPUs in the boot-time nohz_full set.
The boolean defaults to 1: allow non-idle tick suppression, subject to
existing dependencies. Writing 0 prevents suppression through POLICY.
Readback reports permission, not the current tick state.

Each write affects only that CPU. Registered offline CPUs remain
configurable, and policy persists across offline/online transitions.
Retry writes when CPU hotplug is in progress so CPU device removal
can drain active sysfs callbacks without a lock dependency cycle.

Co-developed-by: He Rongguang <herongguang@linux.alibaba.com>
Signed-off-by: He Rongguang <herongguang@linux.alibaba.com>
Signed-off-by: Peng Wang <peng_wang@linux.alibaba.com>
---
 .../ABI/testing/sysfs-devices-system-cpu      | 27 ++++++++++
 drivers/base/cpu.c                            | 53 +++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 82d10d556cc89..4f6ac6b41e2b6 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -767,6 +767,33 @@ Description:	Preferred MTE tag checking mode
 
 		See also: Documentation/arch/arm64/memory-tagging-extension.rst
 
+What:		/sys/devices/system/cpu/cpuX/nohz_tick_allowed
+Date:		October 2026
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:
+		(RW) Boolean allowing this CPU to stop its non-idle scheduler
+		tick. Present only for registered CPUs in the boot-time
+		nohz_full set, with CONFIG_NO_HZ_FULL.
+
+		The default is 1 (allowed), subject to existing tick
+		dependencies. Writing 0 prevents non-idle tick suppression;
+		writing 1 allows it without forcing the tick to stop. Each
+		write affects one CPU. Readback reports permission, not the
+		current tick state.
+
+		Revoking permission requests an asynchronous restart of a
+		stopped non-idle tick on an online CPU. The write does not wait
+		for restart. Idle tick suppression is unchanged; the policy
+		applies when the CPU leaves idle.
+
+		Registered offline CPUs may be configured. Policy is retained
+		per logical CPU across offline/online and CPU device removal
+		and re-addition. CPUs without a registered cpuN device cannot
+		be configured through this interface.
+
+		This does not change nohz_full membership, context tracking,
+		RCU offloading or housekeeping configuration.
+
 What:		/sys/devices/system/cpu/nohz_full
 Date:		Apr 2015
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 69e52fed42415..6fad1b0227dac 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/sched/signal.h>
 #include <linux/cpu.h>
 #include <linux/topology.h>
 #include <linux/device.h>
@@ -189,7 +190,56 @@ static const struct attribute_group crash_note_cpu_attr_group = {
 };
 #endif
 
+#ifdef CONFIG_NO_HZ_FULL
+static ssize_t nohz_tick_allowed_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%u\n", tick_nohz_full_get_allowed(dev->id));
+}
+
+static ssize_t nohz_tick_allowed_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	bool allowed;
+	int ret;
+
+	ret = kstrtobool(buf, &allowed);
+	if (ret)
+		return ret;
+
+	ret = tick_nohz_full_set_allowed(dev->id, allowed);
+	if (ret == -EBUSY) {
+		/* Retry after releasing the sysfs active reference. */
+		fsleep(5000);
+		return restart_syscall();
+	}
+
+	return ret ? ret : count;
+}
+static DEVICE_ATTR_RW(nohz_tick_allowed);
+
+static umode_t nohz_tick_is_visible(struct kobject *kobj,
+				   struct attribute *attr, int unused)
+{
+	return tick_nohz_full_cpu(kobj_to_dev(kobj)->id) ? attr->mode : 0;
+}
+
+static struct attribute *nohz_tick_cpu_attrs[] = {
+	&dev_attr_nohz_tick_allowed.attr,
+	NULL
+};
+
+static const struct attribute_group nohz_tick_cpu_attr_group = {
+	.attrs = nohz_tick_cpu_attrs,
+	.is_visible = nohz_tick_is_visible,
+};
+#endif
+
 static const struct attribute_group *common_cpu_attr_groups[] = {
+#ifdef CONFIG_NO_HZ_FULL
+	&nohz_tick_cpu_attr_group,
+#endif
 #ifdef CONFIG_CRASH_DUMP
 	&crash_note_cpu_attr_group,
 #endif
@@ -197,6 +247,9 @@ static const struct attribute_group *common_cpu_attr_groups[] = {
 };
 
 static const struct attribute_group *hotplugable_cpu_attr_groups[] = {
+#ifdef CONFIG_NO_HZ_FULL
+	&nohz_tick_cpu_attr_group,
+#endif
 #ifdef CONFIG_CRASH_DUMP
 	&crash_note_cpu_attr_group,
 #endif
-- 
2.47.0

