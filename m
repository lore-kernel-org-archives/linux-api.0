Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281812;
	b=GlQPKd3bKelOmiWJNmjx+5Xs27Vb7JPrIkS5LkXC7th/G250XPa7VVq+aqHB8E3JdUHh
	 RUCcDjy3N19RBjy4TXlw7zxuq5Dsa7RPf1k/yFjRz5GJ/PPl/VGomxjmepaykmrboKcs1
	 kSBrw7G8iONpft0BQwn9eXur/eu24swMr0eAEM2wdUKyXH4/u9iDbYoCVh3YMsB8iDPgc
	 c6xluUu5yqHrrG5x2z/6JZOAN/md/CWksuOMOppfCbo/qMcg0ZrfoEIfDrXd0pVulVA8w
	 7CL51NoL+TaD0YjcQDN52tX8sWxDBOOBzoa8UcvXBOhZvvka1RPmpKfnIvU1883Dq+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281812;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=0zvT7oCej3Q9DIt3FKkPiNSTHiXNzdumAlRy8FW076c=;
	b=0J9I0/IL/0QkeKZJMfpVvRH1eK6R38mgG0qKGyj4GWr1rBk/UdJW1Epx9AL5fMfVjqGm
	 awdwboOYVINha41/KZZNwmmRuTSvyU8aJlq2Rsp2e41dgqResdKhvwRyNOv8Z247u7jv8
	 hVHv4GAB8h7/dCI8T96hF/BSV53Jt8s4pz8bKc/gxEVa4mIh0aM5FNUPbTor/YRf/14f9
	 B/B8rhW+p/h22uYSmdrV0WalIyBcvaAyOxDvLgMrIEjDQ83Oq4ooK/+jKIKyUvmL2X3H7
	 /QtZ/N1aIX/FhjpyZNXWv6ytG8hn8/1wlcoixtWC/dOgjeHs4n0v2fc8uYITgfDePYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=B41DpXBu;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1BC60A2601;
	Tue, 10 Nov 2026 03:36:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D1BC60A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=B41DpXBu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281811; x=1825817811;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=09tsY2dIJmO8wbs7jsY3wYPWSdoqLh5GcMEkTuJdszA=;
  b=B41DpXBuWKGVavtG7hp0uZjo1CZWkWxU9LhDklY0+TWIEgKGgUnRDhcL
   v6uWRoSnSgROl+uQuTM+q0IwAc0On7CiAKp9FR8aIXv3ho3zMsrJLDX1Y
   0J/5rafQ2iQrwKSy/GcTw8EhjYFr20O+vCBFUAXa+Mit8HVm5gpvgha1b
   FGYHY4somMTQo4xh6kTK9+l0GUxxOGE24Euvp5dX1HXGqKYcOqPyf4eeJ
   qR7HTlkuz1uJDETo0UST2JdjQkbvqL0AbClEuoOSo2xFFfH0BIOF57mgm
   EJR2FKcobuXE//cZVoFL49PtIvxk2xm+VbFBTHd+vqtjTtaBiFkFmm5LP
   Q==;
X-CSE-ConnectionGUID: /0Pch25cTBGIyreaNvC8eA==
X-CSE-MsgGUID: mX/0XBv2Rs6gkC0D70BxqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010646"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010646"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: OsjkQejNQReVB5NaAcwitQ==
X-CSE-MsgGUID: Qex/qrJqRdyfPpveLJKWzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370798"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:32 -0800
Subject: [PATCH 05/13] thermal: intel: dpti: Tear down DPTI only during
 boot
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
Message-Id: <20261109-dpti-custom-cpu-v1-5-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=4677;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=09tsY2dIJmO8wbs7jsY3wYPWSdoqLh5GcMEkTuJdszA=;
 b=gYLI7ruuFZxx1yX59epue6YMMOdf2G2OW72pq5fzdskQmlu/pm4QOpbcBRvdIJihadEGY0Rme
 ZZ6MV6A4nf+ABhI6SfhWK8xp0Tf8hZuvu2X/s7509aTs7AzJdRVCU+G
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

An unacknowledged DPTI setup on a CPU coming online tears DPTI down on all
packages, at any time. During boot, the hotplug online callback runs on
every online CPU. The teardown keeps each of them from spending its own ack
timeout on the same failure.

Add a flag that tells boot apart from later CPU hotplug. Clear it once the
hotplug callbacks are registered. By then at least one CPU has attempted
the setup. If DPTI is still up, that attempt succeeded. From then on,
assume the hardware works and prevent a complete teardown from other code
paths.

The flag is system-wide. This assumes that if DPTI works on the boot
package it will work on others too. This assumption is reasonable since all
packages are identical in hardware and firmware.

Skipping the teardown after boot is safe because a failure leaves the
hardware in a working state: failures in the migration of the interrupt to
another CPU fall back to broadcasting the interrupt to all CPUs in the
package.

Name the failing package in the message and whether it alone or every
package reverts to broadcast. Raise the message to a warning, like the
offline path's.

cpuhp_setup_state() releases the CPU hotplug lock before returning.
Clearing the flag outside the lock means a CPU could come online in that
window, see the flag still set, and hit the boot-teardown path on failure,
even though the initcall has already finished verifying the CPUs to which
"boot" refers. Use cpuhp_setup_state_cpuslocked() under cpus_read_lock()
so the flag is cleared while no CPU can come online.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 drivers/thermal/intel/therm_throt.c | 47 +++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index a170dcc8513f..ac719e2407ac 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -529,6 +529,13 @@ static unsigned int *dpti_owner_cpus;
  */
 static bool dpti_shut_down;
 
+/*
+ * Cleared once the hotplug callbacks are registered: at least one CPU
+ * attempted the setup by then, and the hardware is assumed sane from that
+ * point on.
+ */
+static bool dpti_in_boot __ro_after_init = true;
+
 static bool dpti_supported(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_DPTI))
@@ -595,11 +602,7 @@ static int dpti_online(unsigned int cpu)
 		return 0;
 	}
 
-	/*
-	 * A failure indicates faulty hardware. Roll back completely so that
-	 * no other CPU tries. This is especially important during boot as all
-	 * CPUs may come online and would otherwise keep trying.
-	 */
+	/* Roll back on failure so the package reverts to broadcasting mode. */
 	enable = false;
 	dpti_config(&enable);
 
@@ -681,8 +684,7 @@ static void dpti_syscore_resume(void *data)
 {
 	/*
 	 * We can't do anything to handle errors. If direction fails for CPU0,
-	 * another CPU will take over or disable direction entirely during CPU
-	 * hotplug.
+	 * another CPU will take over during CPU hotplug.
 	 */
 	dpti_online(0);
 }
@@ -825,8 +827,16 @@ static int thermal_throttle_online(unsigned int cpu)
 	intel_hfi_online(cpu);
 
 	if (dpti_online(cpu)) {
-		pr_info_once("Failed to direct package thermal interrupts. All CPUs will receive it\n");
-		dpti_cleanup();
+		pr_warn_once("Failed to direct the thermal interrupt of package %u; reverting to broadcast on %s\n",
+			     topology_logical_package_id(cpu),
+			     dpti_in_boot ? "all packages" : "this package");
+
+		/*
+		 * A failure during boot indicates faulty hardware, so no other
+		 * CPU should try.
+		 */
+		if (dpti_in_boot)
+			dpti_cleanup();
 	}
 
 	/* Unmask the thermal vector after the above workqueues are initialized. */
@@ -871,11 +881,22 @@ static __init int thermal_throttle_init_device(void)
 
 	intel_hfi_init();
 
-	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/therm:online",
-				thermal_throttle_online,
-				thermal_throttle_offline);
-	if (ret >= 0)
+	/*
+	 * A CPU coming online before dpti_in_boot is cleared would treat a DPTI
+	 * failure as faulty hardware and tear DPTI down. Hold the CPU hotplug
+	 * lock across the registration and the clear, so that the flag changes
+	 * only while no CPU can come online.
+	 */
+	guard(cpus_read_lock)();
+
+	ret = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
+					   "x86/therm:online",
+					   thermal_throttle_online,
+					   thermal_throttle_offline);
+	if (ret >= 0) {
+		dpti_in_boot = false;
 		return 0;
+	}
 
 	dpti_cleanup();
 

-- 
2.43.0

