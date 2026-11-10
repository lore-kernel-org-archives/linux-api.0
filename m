Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281812;
	b=B5BKgQljKVL474MfjpRQnnhvB6qPmeT3mQcxtSReTXrJ1bzc2QPta2cj8NkXLe41NQLK
	 eL5womX7tfYydeb5l68OQRP5Uj2w5h2WsrSV6dXHEQoVVTdPWyFSBVi8VA3lpSWDNLS23
	 /dp/14S+z1M0NrmUW8NhBjDa+IIEsMg6ZPylNBKLQJ0uqdrm0rvGkK5lXOivU+MDlMWqt
	 Jr1ZKbUuOy1bndLqfFo1nH/2odIgg1XOBt+lHeYZ3BQZJzC+5hXUJk8/46PNWPTimMtPz
	 XYbzXuc6+sZ9tVjw8QtFe0j6nHciDgYNuQe5Lsekn3+WJqoKZIBxDZ7UbpICvX4rf+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281812;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=BUcImGsuwZjWXWfaY2Ct64FrLcHe3Ijl1QsSaBtzKnM=;
	b=EnQtCXNsbSnO2r9qmPwmWjEd02827cQdu261xRjMy3XAmPgW/1e4O9tYf38oB+Ou7ZPE
	 ig/a/xAM2e2zitA5xotd/0uCrEBg60AX3sPHVxkz3Rru5virhbtrxdRj3ZtdRLRzhtpQ0
	 P2pcFVDxDbtZPKdI8E0K2Ot8aG54WgcFQuM6PmSSknopeCpA2bu5y9AMr+O3/lpncWt3U
	 f1JzlucE7Q4xSWx2y/I5Kq0NIY6pcvK0c2CxV3qeuErLBTkNMdObYIB2TTDTbzE1lZQLi
	 fbG937TKJh4lSsnty9eIbM7bktULBkVm9CXkHVu0tyAeyl+0v+yC1/omy9mMKzvD01A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PyOgvoq4;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5331560A2612;
	Tue, 10 Nov 2026 03:36:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5331560A2612
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PyOgvoq4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281812; x=1825817812;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=bM9HLueu+R7OwU7cX4lNqTZqYbJBSpXuav4uV0W17YY=;
  b=PyOgvoq4nRQlZFIALhmwbIN1Slv/5HOxZbB+8AD3SJdSM8/MbRyK/BDC
   wt/WkSp3hti/ALda+fR+TUWqtV7tfv8fwZF6KntcLdvvYdN+J2bTV6GlA
   68igcKsC2bmHuBbt+JPPatIV8BZmhDteuB3ZMJnH7uqrdSXmPYmQg/Vbk
   H8Sa7aQPNMebvOI1OFJ0zNaSysKHCxrXt3j4a0Pi5K3k6zbY+hKlqTULJ
   gW2+7bqyMIdCAZPmYXSJdSRBuZxCRQl1MNl+roYt/Y4VPpJLxTB3rkrM+
   32Eq7fGnBYZoNC836jXIava/8QEfyRKgjMp1t+gO466rSpiBWCgQJa59Y
   A==;
X-CSE-ConnectionGUID: TakrGOmHRKy45KYyh9zJAQ==
X-CSE-MsgGUID: Cl1np3cCQYy+OOsNPT0ZVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010658"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010658"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: F9qFKA5aRn2PsdaZEsj+bg==
X-CSE-MsgGUID: BG7vd6VGQ5CkUOqnpqs6MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370810"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:36 -0800
Subject: [PATCH 09/13] thermal: intel: dpti: Program the directed interrupt
 on the target CPU
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
Message-Id: <20261109-dpti-custom-cpu-v1-9-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=5342;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=bM9HLueu+R7OwU7cX4lNqTZqYbJBSpXuav4uV0W17YY=;
 b=Q8XsueQ2OqWfMjJxVdtXZmYgiByWdvI1EeGs0mh8BXlUW+T755Bt7dFunE5v3tN4aqA7PwGQ6
 DPT0oTGGqu+DyvNao0tQyyIoFPvLK5FFNSVjMSojYPCmkpYWbGM90rX
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

The CPU online and offline paths of the directed package-level thermal
interrupt (DPTI) both perform the same hardware programming sequence: clear
the acknowledgment status, enable the interrupt on a target CPU, wait for
the hardware to acknowledge the setup, and roll back the enable if the
acknowledgment times out.

MSR_IA32_PACKAGE_THERM_STATUS is package-scoped, but both paths clear and
poll it on the CPU that runs them while enabling the interrupt on the
target CPU. This setup works because every caller today targets a CPU in
its own package. A sysfs interface that programs an owner on behalf of any
package will lift that restriction.

Run the full sequence on the target CPU instead.
smp_call_function_single() cannot be used for the sequence: it would wait
for up to 15ms in interrupt context. Instead, use smp_call_on_cpu(), which
can wait and cannot migrate to another CPU.

Keep using smp_call_function_single() to clear the directed interrupt on a
CPU. It does not wait for acknowledgment and can therefore run in interrupt
context. Clearing is then the only remote configuration left. Replace
dpti_config_ipi() with dpti_clear_ipi(), which takes no setting.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 drivers/thermal/intel/therm_throt.c | 63 +++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 34 deletions(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index 72dabffe3b2f..e6ce443c0a9d 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -514,9 +514,14 @@ static void dpti_config_this_cpu(bool enable)
 	wrmsrq(MSR_IA32_THERM_INTERRUPT, msr_val);
 }
 
-static void dpti_config_ipi(void *info)
+static void dpti_clear_ipi(void *unused)
 {
-	dpti_config_this_cpu(*((bool *)info));
+	dpti_config_this_cpu(false);
+}
+
+static void dpti_clear_on_cpu(unsigned int cpu)
+{
+	smp_call_function_single(cpu, dpti_clear_ipi, NULL, true);
 }
 
 /* The unused argument matches the smp_call_on_cpu() callback signature. */
@@ -538,6 +543,18 @@ static int dpti_program_this_cpu(void *unused)
 	return ret;
 }
 
+/*
+ * MSR_IA32_PACKAGE_THERM_STATUS is package-scoped, so the acknowledgment must
+ * be polled on the same package. Run a worker bound to @cpu: it cannot be
+ * migrated and may wait for the acknowledgment for as long as 15ms.
+ */
+static int dpti_program_on_cpu(unsigned int cpu)
+{
+	lockdep_assert_cpus_held();
+
+	return smp_call_on_cpu(cpu, dpti_program_this_cpu, NULL, false);
+}
+
 /**
  * struct dpti_pkg - Per-package DPTI state
  * @owner:	CPU currently programmed to receive the package-level
@@ -619,7 +636,6 @@ static bool dpti_cpu_is_owner(unsigned int cpu)
  */
 static void dpti_clear_all(void)
 {
-	bool enable = false;
 	int i;
 
 	if (!dpti_supported())
@@ -630,11 +646,12 @@ static void dpti_clear_all(void)
 	 * DPTI down.
 	 */
 	for (i = 0; i < topology_max_packages(); i++) {
-		if (dpti_pkgs[i].owner == nr_cpu_ids)
+		unsigned int owner = dpti_pkgs[i].owner;
+
+		if (owner == nr_cpu_ids)
 			continue;
 
-		smp_call_function_single(dpti_pkgs[i].owner, dpti_config_ipi,
-					 &enable, true);
+		dpti_clear_on_cpu(owner);
 	}
 }
 
@@ -657,7 +674,7 @@ static int dpti_online(unsigned int cpu)
 	if (dpti_pkgs[pkg_id].owner != nr_cpu_ids)
 		return 0;
 
-	ret = dpti_program_this_cpu(NULL);
+	ret = dpti_program_on_cpu(cpu);
 	if (ret)
 		return ret;
 
@@ -669,7 +686,6 @@ static int dpti_online(unsigned int cpu)
 static void dpti_offline(unsigned int cpu)
 {
 	unsigned int new_cpu;
-	bool enable;
 	u16 pkg_id;
 
 	if (!dpti_supported())
@@ -691,35 +707,14 @@ static void dpti_offline(unsigned int cpu)
 	 * offline.
 	 */
 	new_cpu = cpumask_any_but(topology_core_cpumask(cpu), cpu);
-	if (new_cpu < nr_cpu_ids) {
-		enable = true;
-		thermal_clear_package_intr_status(PACKAGE_LEVEL,
-						  PACKAGE_THERM_STATUS_DPTI_ACK);
-
-		/*
-		 * We are here via CPU hotplug. Since we are holding the
-		 * cpu_hotplug_lock, @new_cpu cannot go offline and interrupts
-		 * are enabled, so the SMP function call is safe.
-		 *
-		 * The syscore suspend callback runs with interrupts disabled,
-		 * but it does not reach this path because all the secondary
-		 * CPUs are offline.
-		 */
-		smp_call_function_single(new_cpu, dpti_config_ipi, &enable,
-					 true);
-	}
 
 	/*
-	 * If hardware does not acknowledge the directed interrupt setup on
-	 * @new_cpu, disable the redirection. Since no other CPU is configured
-	 * to receive the package-level interrupt, all CPUs in the package will
-	 * receive it.
+	 * dpti_program_on_cpu() undoes a setup that the hardware does not
+	 * acknowledge on @new_cpu. With @cpu cleared below, no CPU is then
+	 * configured to receive the package-level interrupt: all CPUs in the
+	 * package receive it.
 	 */
-	enable = false;
-	if (new_cpu < nr_cpu_ids && dpti_wait_for_ack()) {
-		smp_call_function_single(new_cpu, dpti_config_ipi, &enable,
-					 true);
-
+	if (new_cpu < nr_cpu_ids && dpti_program_on_cpu(new_cpu)) {
 		pr_warn_once("Failed to redirect package thermal interrupt from CPU%u to CPU%u; reverting to broadcast\n",
 			     cpu, new_cpu);
 

-- 
2.43.0

