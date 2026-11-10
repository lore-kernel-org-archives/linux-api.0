Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281812;
	b=elA/OFq7Uh0r03eoIyr7EgZsq6hpNQ5Fy56Uc9BNxwb6tCjBYMLughgtD2yN7Te67KFB
	 g8VHAod8BeYHF7fZHsJQvQVRh36abE4ZWGRoyyi4V9CDoTOw8MT9qTxw7yyrXLHdPVPR7
	 StCaNvmFIUlZfI/1w2sRb0oCgUAhEys54DY8i4AIFgFkP2aO85Ow6c7srcCGASa4kSJT9
	 d7P9ZZLBfWqExNj8GFzkJ0FBbns3foXzS6/J5kvPbpn4c1VIqiYIk6qcpBcGEN1b4jp5l
	 zOxNU7qcWsSlU3OnppG+iBn5dreMZramuTaMMFEewmthD3hA7qTOI6iH7PVoDrO7x0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281812;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=yL/bYpPbA1VV7P5LqvIvItlJYGnGdCxpyPNU7mxY5dw=;
	b=pRkx+vfJ1KQzgppnbAUiWfa6XemdpTiW7oakWxewCz0ShFY+rENhElz0Rx9OCRPpMwUX
	 IvseJMi+Xu64aNbI0r8s7zFmzbHm98ChHgZUwWLuwQW7CB0BvkpAQKiHxg+7Un5RbRlt+
	 EoItJRmRnKo0ezS8KsdbukYMR0KAzCO1LZK1ZQxL/iZxZU/Sc/RB9rOhRCEjyQ3glHPFv
	 bcbYpKIRF5qvwLaU9k/ZoZYaHjZceY2wy083gvXBHmlcWycO2qRR7BGS1yO/uLSwnfGXj
	 +P5PQGnxISmL68PQ/oQkzFCl74KCbKlYLNUKEbB4bLYJdgk1QqeABogkTwQGcENoCIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=L0zhkoaX;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0571060A260B;
	Tue, 10 Nov 2026 03:36:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0571060A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=L0zhkoaX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281812; x=1825817812;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=LUiMntBanciiEpVPXcBhkYz2EJ70zKF81At3HftVud8=;
  b=L0zhkoaXHdm7Bb2pdNMzGuHsEZlshYT6gFkr0ehTs5pcB0ak5AYhxl80
   qS2Vh3b1RHH27Aee9cOEIPb+uBYXiRlxbg3tIK5LzbwijllHYewi+VMH/
   O4vAEnWlbbK4BkTawK2aOQkWSA2eabZ5sDqqBy2JDnqBl15bhQajkI6JE
   n5ZKVUm2bGgu4USHP5jZCU070I6ppOSrBk4GP5HbJqbjNpUnbNF8QXPr2
   vtjcWunJ74fRqjLoh6cxPfwZ+s7rAY3rTI30U2M3a+cVnLJRFWc8zzkKM
   wa2yEUaGheHN3tDZv1Yl+X4Kb++VnYRlEJYHPG2QtGCOVLnGPccbUzBKB
   g==;
X-CSE-ConnectionGUID: RlfTxH79SzWWd4P0GPHgjQ==
X-CSE-MsgGUID: h7WVCrq/RAO5JzjtiDB6zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010655"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010655"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: UO1v5YB+ToKJP6Xid56WLQ==
X-CSE-MsgGUID: TJr8Lm00SQW2LXntDMqJdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370807"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:35 -0800
Subject: [PATCH 08/13] thermal: intel: dpti: Factor the programming
 sequence out into a helper
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
Message-Id: <20261109-dpti-custom-cpu-v1-8-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=4845;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=LUiMntBanciiEpVPXcBhkYz2EJ70zKF81At3HftVud8=;
 b=a2gn89yBP+PACnXnpHrLOfwdnbeDDnnwVWpW1Db8UTHE1Dhv/O1BS1MR89CFmrytxg30Gtwpi
 Nc3rM5iRRHBCPaEcEb9D8Sv+amnsNEdFOIVCkxJer45cGarKFO77atU
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

The hardware programming sequence for the directed package-level thermal
interrupt (DPTI) is embedded in dpti_online(): clear the acknowledgment
status, enable the interrupt, wait for the hardware to acknowledge, and
roll back on failure. The syscore resume callback reuses it to
unconditionally restore the DPTI on CPU0.

The programming sequence will have to run on a selected owner CPU. CPU0
will no longer always be the boot package's owner. The syscore resume
callback then cannot reuse dpti_online().

Factor the sequence out into dpti_program_this_cpu() and call it from both
the online callback and syscore resume. Its unused argument gives it the
callback signature, so that it can run on a remote CPU via
smp_call_on_cpu(). The syscore callbacks now act only if CPU0 owns the
DPTI.

Add dpti_lookup_pkg_id() to check, at entry points, that a CPU's package
has per-package state, and dpti_pkg_of_cpu_nocheck() for code that runs
after that check. Owner selection and the sysfs interface will reuse them.

No locking is needed in the syscore path: interrupts are disabled and
only the boot CPU is online at this point.

A suspend and resume cycle leaves the same state as before: the DPTI
directed to CPU0, or broadcasting if the hardware does not acknowledge.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 drivers/thermal/intel/therm_throt.c | 83 ++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index 36cdbe0eb6c1..72dabffe3b2f 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -519,6 +519,25 @@ static void dpti_config_ipi(void *info)
 	dpti_config_this_cpu(*((bool *)info));
 }
 
+/* The unused argument matches the smp_call_on_cpu() callback signature. */
+static int dpti_program_this_cpu(void *unused)
+{
+	int ret;
+
+	thermal_clear_package_intr_status(PACKAGE_LEVEL,
+					  PACKAGE_THERM_STATUS_DPTI_ACK);
+
+	dpti_config_this_cpu(true);
+	ret = dpti_wait_for_ack();
+	if (!ret)
+		return 0;
+
+	/* Undo the enable on failure, leaving the package as it was before. */
+	dpti_config_this_cpu(false);
+
+	return ret;
+}
+
 /**
  * struct dpti_pkg - Per-package DPTI state
  * @owner:	CPU currently programmed to receive the package-level
@@ -560,6 +579,38 @@ static bool dpti_supported(void)
 	return true;
 }
 
+static int dpti_lookup_pkg_id(unsigned int cpu, u16 *pkg_id)
+{
+	u16 id;
+
+	if (!dpti_supported())
+		return -ENODEV;
+
+	id = topology_logical_package_id(cpu);
+	if (id >= topology_max_packages())
+		return -ENODEV;
+
+	*pkg_id = id;
+
+	return 0;
+}
+
+/* For callers already past dpti_lookup_pkg_id(). */
+static struct dpti_pkg *dpti_pkg_of_cpu_nocheck(unsigned int cpu)
+{
+	return &dpti_pkgs[topology_logical_package_id(cpu)];
+}
+
+static bool dpti_cpu_is_owner(unsigned int cpu)
+{
+	u16 pkg_id;
+
+	if (dpti_lookup_pkg_id(cpu, &pkg_id))
+		return false;
+
+	return dpti_pkgs[pkg_id].owner == cpu;
+}
+
 /*
  * Must be called with cpu_hotplug_lock held to prevent CPUs from going offline
  * while iterating through packages and interrupts must be enabled to avoid
@@ -590,6 +641,7 @@ static void dpti_clear_all(void)
 static int dpti_online(unsigned int cpu)
 {
 	u16 pkg_id;
+	int ret;
 
 	if (!dpti_supported())
 		return 0;
@@ -605,19 +657,13 @@ static int dpti_online(unsigned int cpu)
 	if (dpti_pkgs[pkg_id].owner != nr_cpu_ids)
 		return 0;
 
-	thermal_clear_package_intr_status(PACKAGE_LEVEL,
-					  PACKAGE_THERM_STATUS_DPTI_ACK);
-
-	dpti_config_this_cpu(true);
-	if (!dpti_wait_for_ack()) {
-		dpti_pkgs[pkg_id].owner = cpu;
-		return 0;
-	}
+	ret = dpti_program_this_cpu(NULL);
+	if (ret)
+		return ret;
 
-	/* Roll back on failure so the package reverts to broadcasting mode. */
-	dpti_config_this_cpu(false);
+	dpti_pkgs[pkg_id].owner = cpu;
 
-	return -ETIMEDOUT;
+	return 0;
 }
 
 static void dpti_offline(unsigned int cpu)
@@ -695,16 +741,23 @@ static void dpti_offline(unsigned int cpu)
  */
 static void dpti_syscore_resume(void *data)
 {
+	if (!dpti_cpu_is_owner(0))
+		return;
+
+	if (!dpti_program_this_cpu(NULL))
+		return;
+
 	/*
-	 * We can't do anything to handle errors. If direction fails for CPU0,
-	 * another CPU will take over during CPU hotplug.
+	 * Let another CPU take over via CPU hotplug. No lock is needed here:
+	 * only CPU0 is online and interrupts are disabled.
 	 */
-	dpti_online(0);
+	dpti_pkg_of_cpu_nocheck(0)->owner = nr_cpu_ids;
 }
 
 static int dpti_syscore_suspend(void *data)
 {
-	dpti_offline(0);
+	if (dpti_cpu_is_owner(0))
+		dpti_config_this_cpu(false);
 
 	return 0;
 }

-- 
2.43.0

