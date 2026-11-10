Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281811;
	b=AlQEC987vfTYpS2vcwnX3x12KUt5LmbLDKLLabGnvuca6ozErayVl02LKbpbT6NhkrUD
	 Ki2fK0rqsQOWslO57HalCvE/0fn+ir06pTDxkAlu0mLpbMcZ4I1aTBWJ/EewCp8+JAQYO
	 4NBhzMXnjUNgJPmtT+WwzFHTLOH2PMEdKOt29avOuLfHK9+nnsKYicAg5VDSkiQEI0EVz
	 omBXvbADe9YFu3qtTTQtTR8fNo4qQ4gFK5cKGu7UOyxLKXqBK1xIRB+J9XwUVKTnLjnCN
	 EhckKbAOIBfZG8zTNBGAamfvec+38PaQlN3xqydItzHmJT1/h8uRPJ4ShIUxDtye+ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281811;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=XvT6SrS3WByACIWQsMUmanDDvi+2dp9vxowUFsg8ZNc=;
	b=ZlHdXusY94Vgk9MvigpwlGIf3n8FPCjEx7a8iNVp7kPWSu9wEWPFihfW7w8nqAtkWzAN
	 9SUqetjjbcR8atCY7TFEaBubEuibzcHQwnfHTHK6zoEy/uJeKtOIkl+5X6jZT5cTwrPeM
	 a1eoWgTqQ2GepKQn1Nrv6FdBubsIt7pQUJUtbhoG3A7AJii6OQW4T4H5hGd7g8tac38aa
	 kn/0mBg3O258DSYKeeDNoEc+q4UafXW2kEFXXzI3pr269LIOmR8/F2vTaBwRan6MV7zfz
	 WoWJz51EpDBrfd+n+HUEXcwuNKD7QSwSSL9uFWUbIHUc3cUGLZlHGNi084W5jDz/2xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=H+2fkBGr;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21697606A33A;
	Tue, 10 Nov 2026 03:36:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21697606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=H+2fkBGr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281811; x=1825817811;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=hBP3oWWYrgMe+isStYPU/9NtZs87dKbADOcOu4wBe7w=;
  b=H+2fkBGrbu5LRiaHrD6jqQWQ7lymvZa1b47oGx6VdqU+xrkRzWcixCmO
   yAZmPxqnZQMuBIntSFUaz2q4E5uR6KWjxit2HfG8gwrU+Vr8fDsCbXkdu
   /Ie/BNhCeMAfBB1lZT0mZgmEjzP1/j8E6iPsEW6pwiy/9QcLqleNSTLZM
   AwEm1MFKQrTgNJ4iJqWZJGuBKL4HA+GuyhcgGumG2SAM5vRO7qGDTq1yh
   qDTJAGQ1Ya3LuAVLvM/tBPOHUImnjkOJDl9TVwzLCrO8o3gLBc2g7ADFR
   ayT/B0kcWuywrkt+m3/F2zv2umwAgjW2whPkZ6Sy6MW+7rmyYRognmdr3
   w==;
X-CSE-ConnectionGUID: jeQFVSpaSlC52viwXo6ACg==
X-CSE-MsgGUID: tOO73ed4REqAc4bB9/zNUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010643"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010643"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: wJ+7Unj4SESgHRTZbr7GWA==
X-CSE-MsgGUID: IWkcCct4R3WZPDubEmJutA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370795"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:31 -0800
Subject: [PATCH 04/13] thermal: intel: dpti: Adopt the dpti_ prefix and the
 owner terminology
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
Message-Id: <20261109-dpti-custom-cpu-v1-4-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=11312;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=hBP3oWWYrgMe+isStYPU/9NtZs87dKbADOcOu4wBe7w=;
 b=xMvjJMT2KWqm6dmc6f1cE4B698/UCpBFfuaEFJAlIg+2PfcgtjHlsAiOArBjKOWhR+IxVyMCS
 kCW5jUK0f3vD8oGRpz76+ko8EcwfmOcwT61lLo3LkY0q4Zz6gXsaTxQ
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

The functions and variables that implement the directed package-level
thermal interrupt (DPTI) are spelled four different ways:
directed_thermal_pkg_intr, directed_pkg_thermal_intr, directed_pkg_intr,
and directed_intr. No single spelling covers the whole group, so no single
grep finds it. The longhand also yields names of up to 37 characters, which
crowds the 80-column limit at the call sites.

x86 already uses the short form in the X86_FEATURE_DPTI feature bit and in
the DPTI field names of MSR_IA32_THERM_INTERRUPT and
MSR_IA32_PACKAGE_THERM_STATUS. Reuse it for the C symbols as well: the
namespace becomes uniform, shorter, and greps as one unit.

These names also call the CPU that receives the interrupt the "handler",
which reads as the interrupt service routine. Across the kernel the noun
names a function rather than a CPU. Call that CPU the owner instead. The
handling of the Corrected Machine Check Interrupt already uses this
vocabulary for the same problem: mce_banks_owned tracks which CPU services
each of a package's shared banks, and cmci_rediscover() hands that duty to
another CPU when the owner goes offline.

A planned sysfs attribute, package_interrupt_owner, will use the term too.

No functional change intended.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 drivers/thermal/intel/therm_throt.c | 129 ++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 66 deletions(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index d89362dc5075..a170dcc8513f 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -477,7 +477,7 @@ static int __init int_pln_enable_setup(char *s)
 __setup("int_pln_enable", int_pln_enable_setup);
 
 #ifdef CONFIG_SYSFS
-static int check_directed_thermal_pkg_intr_ack(void)
+static int dpti_wait_for_ack(void)
 {
 	unsigned int count = 15000;
 	u64 msr_val;
@@ -500,7 +500,7 @@ static int check_directed_thermal_pkg_intr_ack(void)
 	return 0;
 }
 
-static void config_directed_thermal_pkg_intr(void *info)
+static void dpti_config(void *info)
 {
 	bool enable = *((bool *)info);
 	u64 msr_val;
@@ -520,21 +520,21 @@ static void config_directed_thermal_pkg_intr(void *info)
  * hotplug is inactive: the init and cleanup paths as well as syscore callbacks.
  * No extra locking needed.
  */
-static unsigned int *directed_intr_handler_cpus;
+static unsigned int *dpti_owner_cpus;
 
 /*
  * Set by the syscore shutdown callback before it disables the directed
  * interrupt, so that no CPU hotplug operation enables it again on the way to
  * kexec.
  */
-static bool directed_pkg_intr_shut_down;
+static bool dpti_shut_down;
 
-static bool directed_thermal_pkg_intr_supported(void)
+static bool dpti_supported(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_DPTI))
 		return false;
 
-	if (!directed_intr_handler_cpus)
+	if (!dpti_owner_cpus)
 		return false;
 
 	return true;
@@ -546,53 +546,52 @@ static bool directed_thermal_pkg_intr_supported(void)
  * deadlocks in SMP function calls. The syscore shutdown callback also calls
  * this function, but runs with CPU hotplug disabled (and interrupts enabled).
  */
-static void disable_directed_thermal_pkg_intr_all(void)
+static void dpti_clear_all(void)
 {
 	bool enable = false;
 	int i;
 
-	if (!directed_thermal_pkg_intr_supported())
+	if (!dpti_supported())
 		return;
 
 	/*
-	 * No need to reset the handlers: callers free directed_intr_handler_cpus
-	 * or have shut DPTI down.
+	 * No need to reset the owners: callers free dpti_owner_cpus or have shut
+	 * DPTI down.
 	 */
 	for (i = 0; i < topology_max_packages(); i++) {
-		if (directed_intr_handler_cpus[i] == nr_cpu_ids)
+		if (dpti_owner_cpus[i] == nr_cpu_ids)
 			continue;
 
-		smp_call_function_single(directed_intr_handler_cpus[i],
-					 config_directed_thermal_pkg_intr,
+		smp_call_function_single(dpti_owner_cpus[i], dpti_config,
 					 &enable, true);
 	}
 }
 
-static int enable_directed_thermal_pkg_intr(unsigned int cpu)
+static int dpti_online(unsigned int cpu)
 {
 	bool enable = true;
 	u16 pkg_id;
 
-	if (!directed_thermal_pkg_intr_supported())
+	if (!dpti_supported())
 		return 0;
 
 	pkg_id = topology_logical_package_id(cpu);
 	if (pkg_id >= topology_max_packages())
 		return -EINVAL;
 
-	if (directed_pkg_intr_shut_down)
+	if (dpti_shut_down)
 		return 0;
 
-	/* Another CPU in this package already handles the directed interrupt. */
-	if (directed_intr_handler_cpus[pkg_id] != nr_cpu_ids)
+	/* Another CPU in this package already owns the directed interrupt. */
+	if (dpti_owner_cpus[pkg_id] != nr_cpu_ids)
 		return 0;
 
 	thermal_clear_package_intr_status(PACKAGE_LEVEL,
 					  PACKAGE_THERM_STATUS_DPTI_ACK);
 
-	config_directed_thermal_pkg_intr(&enable);
-	if (!check_directed_thermal_pkg_intr_ack()) {
-		directed_intr_handler_cpus[pkg_id] = cpu;
+	dpti_config(&enable);
+	if (!dpti_wait_for_ack()) {
+		dpti_owner_cpus[pkg_id] = cpu;
 		return 0;
 	}
 
@@ -602,29 +601,29 @@ static int enable_directed_thermal_pkg_intr(unsigned int cpu)
 	 * CPUs may come online and would otherwise keep trying.
 	 */
 	enable = false;
-	config_directed_thermal_pkg_intr(&enable);
+	dpti_config(&enable);
 
 	return -ETIMEDOUT;
 }
 
-static void disable_directed_thermal_pkg_intr(unsigned int cpu)
+static void dpti_offline(unsigned int cpu)
 {
 	unsigned int new_cpu;
 	bool enable;
 	u16 pkg_id;
 
-	if (!directed_thermal_pkg_intr_supported())
+	if (!dpti_supported())
 		return;
 
 	pkg_id = topology_logical_package_id(cpu);
 	if (pkg_id >= topology_max_packages())
 		return;
 
-	if (directed_pkg_intr_shut_down)
+	if (dpti_shut_down)
 		return;
 
-	/* Not the CPU handling the directed interrupt. */
-	if (directed_intr_handler_cpus[pkg_id] != cpu)
+	/* Not the owner of the directed interrupt. */
+	if (dpti_owner_cpus[pkg_id] != cpu)
 		return;
 
 	/*
@@ -646,8 +645,7 @@ static void disable_directed_thermal_pkg_intr(unsigned int cpu)
 		 * but it does not reach this path because all the secondary
 		 * CPUs are offline.
 		 */
-		smp_call_function_single(new_cpu, config_directed_thermal_pkg_intr,
-					 &enable, true);
+		smp_call_function_single(new_cpu, dpti_config, &enable, true);
 	}
 
 	/*
@@ -657,9 +655,8 @@ static void disable_directed_thermal_pkg_intr(unsigned int cpu)
 	 * receive it.
 	 */
 	enable = false;
-	if (new_cpu < nr_cpu_ids && check_directed_thermal_pkg_intr_ack()) {
-		smp_call_function_single(new_cpu, config_directed_thermal_pkg_intr,
-					 &enable, true);
+	if (new_cpu < nr_cpu_ids && dpti_wait_for_ack()) {
+		smp_call_function_single(new_cpu, dpti_config, &enable, true);
 
 		pr_warn_once("Failed to redirect package thermal interrupt from CPU%u to CPU%u; reverting to broadcast\n",
 			     cpu, new_cpu);
@@ -671,76 +668,76 @@ static void disable_directed_thermal_pkg_intr(unsigned int cpu)
 	 * Clear the directed interrupt on @cpu. Hardware acknowledgment can be
 	 * ignored since @cpu is going offline.
 	 */
-	config_directed_thermal_pkg_intr(&enable);
+	dpti_config(&enable);
 
-	directed_intr_handler_cpus[pkg_id] = (new_cpu < nr_cpu_ids) ? new_cpu : nr_cpu_ids;
+	dpti_owner_cpus[pkg_id] = (new_cpu < nr_cpu_ids) ? new_cpu : nr_cpu_ids;
 }
 
 /*
- * CPU0 may be handling the directed interrupt, but the CPU hotplug callbacks
- * are not called for CPU0 during suspend and resume.
+ * CPU0 may own the directed interrupt, but the CPU hotplug callbacks are not
+ * called for CPU0 during suspend and resume.
  */
-static void directed_pkg_intr_syscore_resume(void *data)
+static void dpti_syscore_resume(void *data)
 {
 	/*
 	 * We can't do anything to handle errors. If direction fails for CPU0,
 	 * another CPU will take over or disable direction entirely during CPU
 	 * hotplug.
 	 */
-	enable_directed_thermal_pkg_intr(0);
+	dpti_online(0);
 }
 
-static int directed_pkg_intr_syscore_suspend(void *data)
+static int dpti_syscore_suspend(void *data)
 {
-	disable_directed_thermal_pkg_intr(0);
+	dpti_offline(0);
 
 	return 0;
 }
 
-static void directed_pkg_intr_syscore_shutdown(void *data)
+static void dpti_syscore_shutdown(void *data)
 {
-	directed_pkg_intr_shut_down = true;
+	dpti_shut_down = true;
 
-	disable_directed_thermal_pkg_intr_all();
+	dpti_clear_all();
 }
 
-static const struct syscore_ops directed_pkg_intr_pm_ops = {
-	.resume = directed_pkg_intr_syscore_resume,
-	.suspend = directed_pkg_intr_syscore_suspend,
-	.shutdown = directed_pkg_intr_syscore_shutdown,
+static const struct syscore_ops dpti_syscore_ops = {
+	.resume = dpti_syscore_resume,
+	.suspend = dpti_syscore_suspend,
+	.shutdown = dpti_syscore_shutdown,
 };
 
-static struct syscore directed_pkg_intr_pm = {
-	.ops = &directed_pkg_intr_pm_ops,
+static struct syscore dpti_syscore = {
+	.ops = &dpti_syscore_ops,
 };
 
-static __init void init_directed_pkg_intr(void)
+static __init void dpti_init(void)
 {
 	int i;
 
 	if (!boot_cpu_has(X86_FEATURE_DPTI))
 		return;
 
-	directed_intr_handler_cpus = kmalloc_objs(*directed_intr_handler_cpus,
-						  topology_max_packages());
-	if (!directed_intr_handler_cpus)
+	dpti_owner_cpus = kmalloc_objs(*dpti_owner_cpus,
+				       topology_max_packages());
+	if (!dpti_owner_cpus)
 		return;
 
 	for (i = 0; i < topology_max_packages(); i++)
-		directed_intr_handler_cpus[i] = nr_cpu_ids;
+		dpti_owner_cpus[i] = nr_cpu_ids;
 
-	register_syscore(&directed_pkg_intr_pm);
+	register_syscore(&dpti_syscore);
 }
 
-static void cleanup_directed_pkg_thermal_intr(void)
+static void dpti_cleanup(void)
 {
-	if (!directed_thermal_pkg_intr_supported())
+	if (!dpti_supported())
 		return;
 
-	unregister_syscore(&directed_pkg_intr_pm);
-	disable_directed_thermal_pkg_intr_all();
-	kfree(directed_intr_handler_cpus);
-	directed_intr_handler_cpus = NULL;
+	unregister_syscore(&dpti_syscore);
+	dpti_clear_all();
+	kfree(dpti_owner_cpus);
+	dpti_owner_cpus = NULL;
 }
 
 /* Add/Remove thermal_throttle interface for CPU device: */
@@ -827,9 +824,9 @@ static int thermal_throttle_online(unsigned int cpu)
 	 */
 	intel_hfi_online(cpu);
 
-	if (enable_directed_thermal_pkg_intr(cpu)) {
+	if (dpti_online(cpu)) {
 		pr_info_once("Failed to direct package thermal interrupts. All CPUs will receive it\n");
-		cleanup_directed_pkg_thermal_intr();
+		dpti_cleanup();
 	}
 
 	/* Unmask the thermal vector after the above workqueues are initialized. */
@@ -849,7 +846,7 @@ static int thermal_throttle_offline(unsigned int cpu)
 	l = apic_read(APIC_LVTTHMR);
 	apic_write(APIC_LVTTHMR, l | APIC_LVT_MASKED);
 
-	disable_directed_thermal_pkg_intr(cpu);
+	dpti_offline(cpu);
 
 	intel_hfi_offline(cpu);
 
@@ -870,7 +867,7 @@ static __init int thermal_throttle_init_device(void)
 	if (!atomic_read(&therm_throt_en))
 		return 0;
 
-	init_directed_pkg_intr();
+	dpti_init();
 
 	intel_hfi_init();
 
@@ -880,7 +877,7 @@ static __init int thermal_throttle_init_device(void)
 	if (ret >= 0)
 		return 0;
 
-	cleanup_directed_pkg_thermal_intr();
+	dpti_cleanup();
 
 	return ret;
 }

-- 
2.43.0

