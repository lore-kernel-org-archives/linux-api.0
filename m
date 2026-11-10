Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281811;
	b=2N4zthGwD41YLbNGbwLoJDO7bZ6zrS/RXwO2v3nHSX908e2fN/VT7bdXHJvzCx7eQnsM
	 ndayafTGI/RjGKERPkys4Y/dH15bILv9ARDKIg4UoyQ1WWQnQLRc8Jvs9SB64Z/YMVuTl
	 q41OqsZCtko/OjOaqHB/rNrcZ4RjdGjOcE79b+CmeXt7Eg0tN1Tt9MlVyZ3OuGZabooGi
	 n4K99GCWm4RoRyUue/lTkZLXGNbF0+DhK9V0b1gTP3qTpkd4AsHgwV/bhXRtx7SdMhpSH
	 R7JpMPvCY1jmy1uaRFkMFHPgoYA/PwZ6fN1+azrCZcxYYgRhnLhqym+06kk+qzGl3Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281811;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=oBvjhj5mA9cP+8HQy3MmppUNwq6KXbqmuj5mAbRfZdw=;
	b=x3KouQJEXcf6WONDh0hjKw99SNZc1DXNujl6GvhykmrCDX0oLzIEDY91YfodE1eQ+WuG
	 gzeV11AJt3oTnCAAv184hv0VmXxADzoDfZWRq+GkQ/09DYeCVoCapPahS2A+ikftIKTMs
	 zQFZlZrVcrzvguQayCAYbZVMq/mbfAeg/nOYMXZaORR1KOmZQSYM8y7fAcUq6IklONv0h
	 xYBOa+cdE8SdQpszyOKQuKxOspfwG6WymmlGx3m4SxL5S4rdhjsuv41/hYUX7yLDynB4i
	 fmL+IutcwjvWQv7niO5+szVmBX6pG4it82Ttnjuvb+YXY8VyJaI8QBqkNIdgUOXQdcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=covzX1+5;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC1160A2600;
	Tue, 10 Nov 2026 03:36:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BC1160A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=covzX1+5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281811; x=1825817811;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=WCMIOAy3+UdQk6bUXBwe+jyEPO6jPfwHW80F+W581Zk=;
  b=covzX1+5NDAvIpa/xgQat0FcapeDsxlYfodkSM1jbeKrIeE/8VwkKBa5
   sqU84LZyrWwk6jnbCWUunKNOt3O7ibDqEi0cEQwgLzNQ3+LNKi1v/qXlh
   ciFHskOkQ6a6/EfJv4S9rZP/X8KzjWJPaVy2keyID+zh2I72SHdPeAWUk
   tYPaXwELmDww5fU1SAijxbPzQ+5LPW1+dKmNBtHv1N9y5+V0R1O5WloY+
   MM3dZUUM99AhieOxymj8VH9ngGGUKwOkrG+SAcmB1sjwvuYStIengmhl6
   fVXUo49AmgBv3jtbf2yFrcl9dXOlfCJ7q0YZrEyylFedQVeAX3yDrD3gX
   Q==;
X-CSE-ConnectionGUID: YodkH1rsRHStvBTAZ4Takw==
X-CSE-MsgGUID: OPhWjMXpRtWVdSswQRhv5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010649"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010649"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: HKttpJ3SRB+SVkvqACq3Dg==
X-CSE-MsgGUID: 0OX97Z6/RzWwRyb/IZfioQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370801"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:33 -0800
Subject: [PATCH 06/13] thermal: intel: dpti: Introduce struct dpti_pkg for
 per-package state
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
Message-Id: <20261109-dpti-custom-cpu-v1-6-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=4114;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=WCMIOAy3+UdQk6bUXBwe+jyEPO6jPfwHW80F+W581Zk=;
 b=GzJ+k3SGno3K1RHBNjdMsU9rxQrcus35VRpy/ys2U8eINTa7ztzHYgujvlX0qoFhWS5pzDChB
 6idkcrBX3S+AjI5VC6NWDUIM+XGLsrFz4LrlM72K4ty+ZklNarAUHXM
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

The array dpti_owner_cpus[] tracks the CPU that owns the directed
package-level thermal interrupt (DPTI) for each package.

A sticky, per-package owner CPU that the user selects through sysfs will
need a field of its own. Rather than adding a second parallel array, wrap
the state in a struct. Future members can be added in one place without
churning every call site again.

No functional change intended.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 drivers/thermal/intel/therm_throt.c | 38 ++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index ac719e2407ac..a0a3842e2760 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -515,12 +515,21 @@ static void dpti_config(void *info)
 	wrmsrq(MSR_IA32_THERM_INTERRUPT, msr_val);
 }
 
+/**
+ * struct dpti_pkg - Per-package DPTI state
+ * @owner:	CPU currently programmed to receive the package-level
+ *		interrupt, or nr_cpu_ids when the package has no owner.
+ */
+struct dpti_pkg {
+	unsigned int owner;
+};
+
 /*
  * Accessed from CPU hotplug callbacks and from code that runs while CPU
  * hotplug is inactive: the init and cleanup paths as well as syscore callbacks.
  * No extra locking needed.
  */
-static unsigned int *dpti_owner_cpus;
+static struct dpti_pkg *dpti_pkgs;
 
 /*
  * Set by the syscore shutdown callback before it disables the directed
@@ -541,7 +550,7 @@ static bool dpti_supported(void)
 	if (!boot_cpu_has(X86_FEATURE_DPTI))
 		return false;
 
-	if (!dpti_owner_cpus)
+	if (!dpti_pkgs)
 		return false;
 
 	return true;
@@ -562,14 +571,14 @@ static void dpti_clear_all(void)
 		return;
 
 	/*
-	 * No need to reset the owners: callers free dpti_owner_cpus or have shut
+	 * No need to reset the owners: callers free dpti_pkgs[] or have shut
 	 * DPTI down.
 	 */
 	for (i = 0; i < topology_max_packages(); i++) {
-		if (dpti_owner_cpus[i] == nr_cpu_ids)
+		if (dpti_pkgs[i].owner == nr_cpu_ids)
 			continue;
 
-		smp_call_function_single(dpti_owner_cpus[i], dpti_config,
+		smp_call_function_single(dpti_pkgs[i].owner, dpti_config,
 					 &enable, true);
 	}
 }
@@ -590,7 +599,7 @@ static int dpti_online(unsigned int cpu)
 		return 0;
 
 	/* Another CPU in this package already owns the directed interrupt. */
-	if (dpti_owner_cpus[pkg_id] != nr_cpu_ids)
+	if (dpti_pkgs[pkg_id].owner != nr_cpu_ids)
 		return 0;
 
 	thermal_clear_package_intr_status(PACKAGE_LEVEL,
@@ -598,7 +607,7 @@ static int dpti_online(unsigned int cpu)
 
 	dpti_config(&enable);
 	if (!dpti_wait_for_ack()) {
-		dpti_owner_cpus[pkg_id] = cpu;
+		dpti_pkgs[pkg_id].owner = cpu;
 		return 0;
 	}
 
@@ -626,7 +635,7 @@ static void dpti_offline(unsigned int cpu)
 		return;
 
 	/* Not the owner of the directed interrupt. */
-	if (dpti_owner_cpus[pkg_id] != cpu)
+	if (dpti_pkgs[pkg_id].owner != cpu)
 		return;
 
 	/*
@@ -673,7 +682,7 @@ static void dpti_offline(unsigned int cpu)
 	 */
 	dpti_config(&enable);
 
-	dpti_owner_cpus[pkg_id] = (new_cpu < nr_cpu_ids) ? new_cpu : nr_cpu_ids;
+	dpti_pkgs[pkg_id].owner = (new_cpu < nr_cpu_ids) ? new_cpu : nr_cpu_ids;
 }
 
 /*
@@ -720,13 +729,12 @@ static __init void dpti_init(void)
 	if (!boot_cpu_has(X86_FEATURE_DPTI))
 		return;
 
-	dpti_owner_cpus = kmalloc_objs(*dpti_owner_cpus,
-				       topology_max_packages());
-	if (!dpti_owner_cpus)
+	dpti_pkgs = kmalloc_objs(*dpti_pkgs, topology_max_packages());
+	if (!dpti_pkgs)
 		return;
 
 	for (i = 0; i < topology_max_packages(); i++)
-		dpti_owner_cpus[i] = nr_cpu_ids;
+		dpti_pkgs[i].owner = nr_cpu_ids;
 
 	register_syscore(&dpti_syscore);
 }
@@ -738,8 +746,8 @@ static void dpti_cleanup(void)
 
 	unregister_syscore(&dpti_syscore);
 	dpti_clear_all();
-	kfree(dpti_owner_cpus);
-	dpti_owner_cpus = NULL;
+	kfree(dpti_pkgs);
+	dpti_pkgs = NULL;
 }
 
 /* Add/Remove thermal_throttle interface for CPU device: */

-- 
2.43.0

