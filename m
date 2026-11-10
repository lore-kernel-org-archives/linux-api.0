Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281810;
	b=U1PW3Lkj4tQpklEn1ulOjbDvgPhURTaZVfG1/2hS25ttXDAzRm5IeSHwNk/wNl3btg5P
	 gM1d5Im2treshn8iHDv7QMWpuyPsbXNTLSyXOYDBEtyDfFAvjeKvhDI+7Fm+2RrXEklwz
	 b6EVL9sDFW95XNcEntdHQGS/U/L8g6Q4uJA8U4jYgU08SVr1ggmFXXzylZVWtL8E63cbw
	 hYatq0i9rWeEI767Jcbd3fcj0/CXQXJzd7gmMfiu3W18VEL8jC5eXUyK5liJMaHO4x1E9
	 luovWZ7tozAuMHu5BxrYr447voD2xMOppInA2jLYn97IGy4MQTT2zDI7SpswBu4rbFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281810;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=MNLCtg4MjfwzcayI+etWY1aDfDu+u6Xqzbezo5dAPp8=;
	b=iiYHqDo+qtKpq/bpltzgQVeZGweq+89agG85QLqGivngg3WZFlkTv8fC+1RJgNFRovu1
	 cG9OOGgADHgpsNBj/l8ZwQ0LUxD3JMa/+cKRl8Ap9Y7YSLEFxF1uzo2cXAmoGOTp/Stc9
	 NlSD1Ok6JoLZahumkgiUV1BCSyly7ZUekvuocynba5YxyuMKUFydSy2LnrvztT3ra3P1X
	 uRpRUxXtds28XB779lXbAcQDrSseJNtdmXp+5UPtOVsZjOOmgdmIpNmfOGxwElWzkuCVr
	 BeiHEdoorUGcc62DcdUs7uIwNaM0DLlPkaWsPEd2VIPhBWZL6u5Obm98PtqKvzLtxKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=H5YmaVhb;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD84606A32A;
	Tue, 10 Nov 2026 03:36:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDD84606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=H5YmaVhb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281810; x=1825817810;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=BlWif15Ll12twzZtrT3KqEDk9Ws6r4dEfEHOmt/E6es=;
  b=H5YmaVhbkMnFcnIfhzvqB3u8Gb719ZwzS/Oj4sunH71YDRaI5XB7yIzQ
   CXCYpG46rMVvMyf3cWuQx/u3paSaqBxXgjZe9L1L1Tu5dv2qGw0jwrd7S
   sNRHJZUDCbBzzZAZvPvGFYblWYBE5UYUijPk2tWpmsRMmKCE/e5KEg5ld
   8LrhYqnfuDfFbIjEEonOa0lKf3BojWNWIdcPgiVCYyzj6G8Y//hiD8/c6
   t2QCtXVDxO2HGmPJ07Lysg2Ii5oAKA+U5Bzmjo3Pe462SmE08Z8q1VdKJ
   gUH/YCHPjJ9EOcRKG10CnwOHp12pgCjjuBq6JZ/meMqV7QXgcp3Y6r66r
   g==;
X-CSE-ConnectionGUID: qPM8mp72R1q/4MggZQt5EQ==
X-CSE-MsgGUID: IMZV1CBhQP+kt7y+xv9yjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010634"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010634"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: OtcybSYFRS+2MwLxYCXtEw==
X-CSE-MsgGUID: 4OtWMI47Tnywms1+3QLmxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370786"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:28 -0800
Subject: [PATCH 01/13] thermal: intel: Keep directed package interrupts off
 after syscore shutdown
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
Message-Id: <20261109-dpti-custom-cpu-v1-1-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=3555;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=BlWif15Ll12twzZtrT3KqEDk9Ws6r4dEfEHOmt/E6es=;
 b=JEXQuupDBi8XkbrfxyZ2dhmkwlOo1zD4gQw+Gbcx2NmBqgQo0B/TSuQHUzrdJP3DEXryYCIUf
 7dHgpAc2BLRAuJB7QSZaTeFusPOxCiJgBqAyBLaius9WMu0NOUAqm32
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

On kexec, the syscore shutdown callback disables the directed package-level
thermal interrupt (DPTI) on every package. kernel_kexec() runs the callback
with CPU hotplug disabled, but re-enables CPU hotplug before
machine_shutdown() stops the other CPUs. A CPU hotplug operation in that
window directs the interrupt again: offlining the CPU that handles it
migrates the interrupt to another CPU, and a CPU coming online claims a
package that has no handler. The next kernel inherits the enable bit on
that CPU, never records the CPU as a handler, and never clears it.

Set a flag in the shutdown callback and make the CPU hotplug callbacks
leave DPTI alone once it is set. No lock is needed. The callback runs with
CPU hotplug disabled. Every later CPU hotplug operation takes
cpu_add_remove_lock, which cpu_hotplug_enable() releases after the flag is
set.

Fixes: 1e768cc92bc7 ("thermal: intel: Add a syscore shutdown callback for kexec reboot")
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
Each package's handler is the first of its CPUs to come online, which for
package 0 is CPU0. On x86, CPU0 cannot be offlined. Its interrupt never
migrates: a single-package system never opens the window. The other
packages of a multi-package system can.

The sysfs interface added later in this series makes the window real on any
system: it can move the interrupt off CPU0, and each write programs a CPU
without a CPU hotplug operation.
---
 drivers/thermal/intel/therm_throt.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index 59520cac6cc8..1ed604bd70e0 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -578,6 +578,13 @@ static void config_directed_thermal_pkg_intr(void *info)
  */
 static unsigned int *directed_intr_handler_cpus;
 
+/*
+ * Set by the syscore shutdown callback before it disables the directed
+ * interrupt, so that no CPU hotplug operation enables it again on the way to
+ * kexec.
+ */
+static bool directed_pkg_intr_shut_down;
+
 static bool directed_thermal_pkg_intr_supported(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_DPTI))
@@ -603,6 +610,10 @@ static void disable_directed_thermal_pkg_intr_all(void)
 	if (!directed_thermal_pkg_intr_supported())
 		return;
 
+	/*
+	 * No need to reset the handlers: callers free directed_intr_handler_cpus
+	 * or have shut DPTI down.
+	 */
 	for (i = 0; i < topology_max_packages(); i++) {
 		if (directed_intr_handler_cpus[i] == nr_cpu_ids)
 			continue;
@@ -625,6 +636,9 @@ static int enable_directed_thermal_pkg_intr(unsigned int cpu)
 	if (pkg_id >= topology_max_packages())
 		return -EINVAL;
 
+	if (directed_pkg_intr_shut_down)
+		return 0;
+
 	/* Another CPU in this package already handles the directed interrupt. */
 	if (directed_intr_handler_cpus[pkg_id] != nr_cpu_ids)
 		return 0;
@@ -662,6 +676,9 @@ static void disable_directed_thermal_pkg_intr(unsigned int cpu)
 	if (pkg_id >= topology_max_packages())
 		return;
 
+	if (directed_pkg_intr_shut_down)
+		return;
+
 	/* Not the CPU handling the directed interrupt. */
 	if (directed_intr_handler_cpus[pkg_id] != cpu)
 		return;
@@ -738,6 +755,8 @@ static int directed_pkg_intr_syscore_suspend(void *data)
 
 static void directed_pkg_intr_syscore_shutdown(void *data)
 {
+	directed_pkg_intr_shut_down = true;
+
 	disable_directed_thermal_pkg_intr_all();
 }
 

-- 
2.43.0

