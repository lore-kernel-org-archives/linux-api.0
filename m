Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281813;
	b=AmfIu8T/eCwSdUDZaiOJE2key9k+s7QxO6+mYeh0DXnMRvLpiVProp79nRzOZmLRVJar
	 jrjB+s7VDcuHFqb+ur/5u4SI98HYid1gc0SmQC+5l9SpojVKojU6hC/CJY/9jsTue6DTw
	 7ymqj5r6gCPUFY7S2uZoIuPSxsZ+I66isjYNWoYnKkLztyheLCJOaMIrg5HvGM4s6ejWk
	 udrxJQ4wkrXjXbCb2X/p3sXDBrtH8Kqwz2S6aYdppOEQi9Yf3I0Dq5gLsdO1v39gt6CkL
	 W9Re5mMLIokPRuwrPL5iXNo+itUZwiANIpzhB7aXkH0z2ETWDPLKcua73WEsA/mjE1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281813;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=LxxQQlyRmNwegp0nQTByYJ7NflqH4aJw5e+mbd+NdeM=;
	b=FEfM2Qau+SDTB9FiACdefZ2OkMY+zbPaKcY3LAVOXX4FcHusy7ISqV7GDYoDDno8IIQ/
	 Ti+WXk+yspV8KFBwvP0jBalhHa342ysj2he5/K9Nx60Y7LbwV99zjRXH+VYxpRM/RrV03
	 ui2kPCFtRGDCcmcqn/wn3NtZPH1Wt9i7atPUma7Zyz4xuio6I+KYG6c6LMN9SX/daiayy
	 XwCNT/DJ9oCm1oqOgDGumB+ISC9gt7q1YnZOmUP0/4pXlbOdhBXopUOqPfhP5iPz+fR/w
	 p/oQwRhNAOcWOXhaqAqe3tnf618PlQTGnBoxI63gf/Yp6ohEZ4mXNw2AOxGBEx8RvKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bkPfrddn;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518A1606A336;
	Tue, 10 Nov 2026 03:36:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 518A1606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bkPfrddn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281813; x=1825817813;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=XnCUVLtqrD9+LAE+2U2tRsB4Sa3vRxKsU5g/zv8d0tI=;
  b=bkPfrddnaTym8mpdSJZUDXvFxw5UloFRnXAV6Fp2tOPAuFdVC5QCO527
   +QyYX4u3IxyOy2SyjO+hqbkXC2cZ8ZpAtVPlAqo1LKq1n5y962PIcmhR+
   /mVlyzMVNXfTexxn1WsMnC492Y5VRyOQqXGxHaqkyigowmSd1YGnsBujq
   f/7m8hluENmb4iW/STa2RXjuGYsrzedlw0HWaL0sk7Xvb1x4Yckxf62BQ
   M066AI+fSQ6JfQ1lUZWxl1i3cRf1HunfhdPbi1s+wZBT9nrDpXgI1tnbM
   jlhJ0juoCJ5/10uUoBpSM53LmNEksZfNX6097/6vFQ0ewhsivtiAsIPuy
   Q==;
X-CSE-ConnectionGUID: Pitl8OZYTdiHLdbYVlF+KA==
X-CSE-MsgGUID: ucVBo/m7StmHcwj0rp2A+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010672"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010672"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: nRJt/cbeTM+ylqLffAIaqA==
X-CSE-MsgGUID: zaXcTDlUSTiJsWehccVxDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370821"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:49 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:40 -0800
Subject: [PATCH 13/13] thermal: intel: dpti: Add sysfs control of interrupt
 owner
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-dpti-custom-cpu-v1-13-ead8e2d2067e@linux.intel.com>
References: <20261109-dpti-custom-cpu-v1-0-ead8e2d2067e@linux.intel.com>
In-Reply-To: <20261109-dpti-custom-cpu-v1-0-ead8e2d2067e@linux.intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, 
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-pm@vger.kernel.org, linux-api@vger.kernel.org, 
 linux-kernel@vger.kernel.org, ricardo.neri@intel.com, 
 Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=10111;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=XnCUVLtqrD9+LAE+2U2tRsB4Sa3vRxKsU5g/zv8d0tI=;
 b=/CRLJmbSXTKEZ6trCO7BT5b57h989WN01rKZCv7P8po9UgDbN6YHtTZpE+s0oHDRtgcHleBpk
 G1fOEhdPZOPDiVu86sqLOKlwNY25K+VavJaQZMCZ7X6HpPAUuYpCxxJ
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

Override automatic selection and let the user choose a CPU to own a
package's directed package-level thermal interrupt (DPTI). Add a boolean
attribute:

  /sys/devices/system/cpu/cpuX/thermal_throttle/package_interrupt_owner

Reading it reports whether the CPU owns its package's interrupt. Writing 1
migrates the interrupt to the CPU and pins it there. Writing 0 releases the
pin. Documentation/ABI/testing describes the semantics in full.

The read format matches the other boolean attributes under
/sys/devices/system/cpu. The write side uses kstrtobool(), as
umwait_control/enable_c02 does.

A user who isolates a CPU at runtime, through a cpuset isolated partition,
can move the interrupt away with this attribute. A pin to a
nohz_full-isolated CPU is honored with a warning, rate-limited because the
write is repeatable.

The attribute is created before the hardware is programmed, and a
programming failure during boot tears DPTI down for good. Remove the
attribute from the CPUs that already got it: otherwise it outlives the
feature it controls, failing every access with -ENODEV, while CPUs coming
online later get no such file at all. A failure after boot is different:
DPTI stays up, and the attribute keeps reporting hardware state truthfully.
The other thermal_throttle attributes need no equivalent teardown, as the
CPUID features and boot parameter gating them cannot be withdrawn at
runtime.

Although the owner is a per-package property, keep the implementation
simple and report ownership through the per-CPU thermal_throttle directory.
A CPU's file is a stateless view onto the same per-package state. This
mirrors the package_throttle_count attribute.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
checkpatch warns that the msleep(5) can sleep for up to 20ms and suggests
usleep_range(). The 5ms is taken from lock_device_hotplug_sysfs(), which
answers a contended hotplug lock with the same trylock, sleep and
restart_syscall() sequence. Sleeping longer than asked only delays the
retry of a contended write.
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |  40 ++++++
 drivers/thermal/intel/therm_throt.c                | 139 +++++++++++++++++++++
 2 files changed, 179 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 545687ebadcc..73dd75c9004a 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -830,3 +830,43 @@ Description:
 		degradations due to underlying physical CPU contention.
 
 		See Documentation/scheduler/sched-paravirt.rst for more details.
+
+What:		/sys/devices/system/cpu/cpuX/thermal_throttle/package_interrupt_owner
+Date:		November 2026
+Contact:	Linux power management list <linux-pm@vger.kernel.org>
+Description:
+		(RW) Boolean. On CPUs supporting the directed package-level
+		thermal interrupt, a single CPU per package is programmed to
+		receive it. This attribute reports and controls whether cpuX is
+		that CPU.
+
+		Reading returns 1 if cpuX currently owns the package thermal
+		interrupt, 0 otherwise. The owner is per package: at most one
+		CPU of a package reads 1, and every CPU of the package reads 0
+		while the package has no owner. A package has no owner until one
+		is programmed, and none if the hardware does not acknowledge
+		one. On Intel processors, a package without an owner broadcasts
+		the thermal interrupt to all of its CPUs. If such a failure
+		happens while the kernel boots, the attribute does not exist on
+		any CPU.
+
+		Writing 1 (also 'y' or 'on') migrates the interrupt to cpuX and
+		pins it there, overriding automatic selection. The request is
+		honored even if cpuX is nohz_full-isolated; a warning is logged
+		in that case, since a directed interrupt disturbs the isolated
+		CPU. The write fails if the hardware does not acknowledge the
+		new owner.
+
+		Writing 0 (also 'n' or 'off') releases a pin on cpuX and returns
+		the package to automatic selection, which prefers CPUs that are
+		not nohz_full-isolated. If cpuX is nohz_full-isolated and such a
+		preferred CPU of the package is online, the interrupt moves
+		there, provided the hardware acknowledges the new owner.
+		Otherwise cpuX remains the owner and keeps reading 1. Writing 0
+		to a CPU that is not pinned has no effect.
+
+		The pin survives offlining. While a pinned CPU is offline this
+		attribute does not exist for it, and automatic selection hands
+		the interrupt to another CPU of the package, which reads 1 in
+		the meantime. The interrupt returns to the pinned CPU as soon as
+		it comes back online.
diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index c8c91a621cf6..1688f6362f6f 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -18,6 +18,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/sched/isolation.h>
+#include <linux/sched/signal.h>
 #include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
@@ -760,6 +761,13 @@ static void dpti_warn_if_isolated(unsigned int cpu, enum dpti_rank rank)
 			     topology_logical_package_id(cpu), cpu);
 }
 
+static void dpti_warn_if_pinned_isolated(unsigned int cpu)
+{
+	if (dpti_cpu_rank(cpu) == DPTI_RANK_ISOLATED)
+		pr_warn_ratelimited("Package %u thermal interrupt pinned to nohz_full-isolated CPU%u\n",
+				    topology_logical_package_id(cpu), cpu);
+}
+
 /*
  * Reselect the owner for @cpu's package and migrate to it, but only on a
  * strict rank improvement.
@@ -881,6 +889,121 @@ static void dpti_offline(unsigned int cpu)
 	dpti_warn_if_isolated(new_cpu, new_rank);
 }
 
+/*
+ * The DPTI owner is a per-package property, but it is exposed through the
+ * existing per-CPU thermal_throttle sysfs group.
+ *
+ * Reading reports whether @cpu is the owner programmed in hardware, not
+ * whether it is pinned. A released pin therefore still reads 1 until the
+ * placement changes, and while a pinned CPU is offline the remaining CPUs
+ * report the automatically chosen fallback.
+ */
+static ssize_t package_interrupt_owner_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	unsigned int cpu = dev->id;
+	bool is_owner;
+	u16 pkg_id;
+	int ret;
+
+	ret = dpti_lookup_pkg_id(cpu, &pkg_id);
+	if (ret)
+		return ret;
+
+	scoped_guard(mutex, &dpti_mutex)
+		is_owner = dpti_pkgs[pkg_id].owner == cpu;
+
+	return sysfs_emit(buf, "%u\n", is_owner);
+}
+
+static int dpti_pin_owner(unsigned int cpu)
+{
+	struct dpti_pkg *pkg = dpti_pkg_of_cpu_nocheck(cpu);
+	unsigned int old_pin;
+	int ret;
+
+	guard(mutex)(&dpti_mutex);
+
+	/* The pin outranks every automatic choice, so it always migrates. */
+	old_pin = pkg->pin;
+	pkg->pin = cpu;
+
+	/*
+	 * A failed write must not change policy or get silently retried on the
+	 * next hotplug event.
+	 */
+	ret = dpti_update_owner(cpu);
+	if (ret)
+		pkg->pin = old_pin;
+	else
+		dpti_warn_if_pinned_isolated(cpu);
+
+	return ret;
+}
+
+static void dpti_unpin_owner(unsigned int cpu)
+{
+	struct dpti_pkg *pkg = dpti_pkg_of_cpu_nocheck(cpu);
+
+	guard(mutex)(&dpti_mutex);
+
+	if (pkg->pin != cpu)
+		return;
+
+	pkg->pin = nr_cpu_ids;
+
+	/*
+	 * Without the pin, a housekeeping CPU of the package outranks an
+	 * isolated owner. Migrate rather than wait for a re-evaluation that may
+	 * never come. A hardware acknowledgment failure leaves the interrupt in
+	 * place, which is still a valid outcome of releasing a pin.
+	 */
+	dpti_update_owner(cpu);
+}
+
+static ssize_t package_interrupt_owner_store(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	unsigned int cpu = dev->id;
+	bool want_pin;
+	int ret;
+
+	ret = dpti_lookup_pkg_id(cpu, NULL);
+	if (ret)
+		return ret;
+
+	ret = kstrtobool(buf, &want_pin);
+	if (ret)
+		return ret;
+
+	/*
+	 * The selection reads the package's online CPUs; the programming runs
+	 * remotely on the CPU it picks. Both need the CPU hotplug lock, which
+	 * this write cannot block on: offlining @cpu holds it while
+	 * sysfs_remove_group() waits for this write to release its reference on
+	 * the attribute. Restart the syscall instead, which drops that
+	 * reference and lets the offline proceed. Avoid busy looping with a 5ms
+	 * sleep between tries. lock_device_hotplug_sysfs() follows the same
+	 * approach.
+	 */
+	if (!cpus_read_trylock()) {
+		msleep(5);
+		return restart_syscall();
+	}
+
+	if (want_pin)
+		ret = dpti_pin_owner(cpu);
+	else
+		dpti_unpin_owner(cpu);
+
+	cpus_read_unlock();
+
+	return ret ? ret : count;
+}
+static DEVICE_ATTR_RW(package_interrupt_owner);
+
 /*
  * CPU0 may own the directed interrupt, but the CPU hotplug callbacks are not
  * called for CPU0 during suspend and resume.
@@ -947,9 +1070,17 @@ static __init void dpti_init(void)
 
 static void dpti_cleanup(void)
 {
+	unsigned int cpu;
+
 	if (!dpti_supported())
 		return;
 
+	/* The attribute must not outlive the per-package state. */
+	for_each_online_cpu(cpu)
+		sysfs_remove_file_from_group(&get_cpu_device(cpu)->kobj,
+					     &dev_attr_package_interrupt_owner.attr,
+					     thermal_attr_group.name);
+
 	unregister_syscore(&dpti_syscore);
 	dpti_clear_all();
 	kfree(dpti_pkgs);
@@ -966,6 +1097,14 @@ static int thermal_throttle_add_dev(struct device *dev, unsigned int cpu)
 	if (err)
 		return err;
 
+	if (dpti_supported()) {
+		err = sysfs_add_file_to_group(&dev->kobj,
+					      &dev_attr_package_interrupt_owner.attr,
+					      thermal_attr_group.name);
+		if (err)
+			goto del_group;
+	}
+
 	if (cpu_has(c, X86_FEATURE_PLN) && int_pln_enable) {
 		err = sysfs_add_file_to_group(&dev->kobj,
 					      &dev_attr_core_power_limit_count.attr,

-- 
2.43.0

