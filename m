Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281813;
	b=f8wYKZupBn4pV76uIafc19m/af1zH4nEboAjzV1Arr2RXeFzEeXoGL0ZlESc5Zjsb9nm
	 1u3RtKFj9q4ZL6YZYIX/VKeDqZM8eGjU6i0oFj5+5nS4XbAe2lZOPxsr+nbOTPLZ/Fvq9
	 GJIyMNfqZCd4D/FlRES2sQs/8Ys1W0yrqU21QgwS5HsqV5h6thdNEa09OEcQOiZ+vORAa
	 xUpL1c4UTK5h5r1qcvtZh8o7O6y36tCGyNPYSi2V7yDTH1kbj+yZ7KEcU5Yjiz/kxG8c+
	 ipTSE40+Z0+ahq2xnlgqs66uYDIw9PfikHYzN6g/+e040qt17zQZelLL6HSbSqn5jZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281813;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=V12hsboZSUGjMql97mSuupcmd43DcYEW4j6P53kuL0w=;
	b=LZuppsc4ucxmRsLIgNv0u8zJEn3YV3EKwLY3othliF5BlgBHTXXb1jmEY+wtf1tS6Gnu
	 ztDHTQTnAigZRl8HQs2uEAcV+Z4fI9xFyCUksUiBA9OuY0+425o19z3rc/IXGHyFKlgC7
	 8Ye7jtowgsrRFanlCQyMm9VyxV/HNX3SCpjl1ydX3Ygr8PFymZvaF88FvJeElEbsBVkFt
	 n+b/+rva5xAa05rswCRxDT5HL1n+lY7/wgAVUv4/x8b4vas3vMBRmAlmDnYg4Gj6x3Cvq
	 Ylr2CthDH85PHgqi13ynKpEQtjPKRZYHbDWCiUP9idq5xywFPVWpbxNG8euSvOIrEMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kbv05uJh;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FE960A2626;
	Tue, 10 Nov 2026 03:36:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38FE960A2626
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kbv05uJh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281813; x=1825817813;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=D0iYjtXGsRwDDmjO/ruV9qNAdLEM8uZPfKJ6EUbkQPw=;
  b=kbv05uJhb6ce9cPO8y6svidEd03gaFpPFwnAzpptnFOMuZvFY4ItHFSO
   cUncNbaOpkk0g4IPjsr/Xo2QHBocPdqR++DvkklriYdUOyEABNsq1AvhJ
   4K/hVP0xkJGsH5TItCrH+7eVGJcZzTI6FpKsQFtqDghF1FGo9JjLHO2e9
   leZ7j+p56Rz/bhyFAlnyTk7J/Qp56LdOvy8BnU4gOusTQYHn7BTzmg/y1
   pvnOGM4/BeoTNv8y2N1aQP8JqeSC/PHoc0HerXtn0ViKLSIpBcbvtttgj
   WhU9hCVXzMWYTx51t1faOZkf6ifkpIQkzQt068+xRWH01/apNlBsl5Hlf
   g==;
X-CSE-ConnectionGUID: 7prdDPFPTnC2r2jxsvvtXg==
X-CSE-MsgGUID: 16V5046NTwCKAkx3PxIO2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010669"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010669"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: vTLZw+1tSoC6g9MoVxBkyQ==
X-CSE-MsgGUID: LWJOeux6TY+g07uZiDBEaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370819"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:49 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:39 -0800
Subject: [PATCH 12/13] thermal: intel: dpti: Avoid nohz_full CPUs when
 possible
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
Message-Id: <20261109-dpti-custom-cpu-v1-12-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=5271;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=D0iYjtXGsRwDDmjO/ruV9qNAdLEM8uZPfKJ6EUbkQPw=;
 b=e7oKlZ8gDPlaR0ij1uCeafQm7jx30SIHnjRrITeySgrAnigEiA2sE6ADRL2Dn+pqJUdd/bBkg
 vhUkj31A6WMCR45FR22lwNV1Gfr//JQogoBgAwIqYfqvq/JKy73poB4
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

A single CPU of each package owns the directed package-level thermal
interrupt (DPTI). Automatic selection ranks every online CPU of the
package equally. Consequently, the package thermal interrupt could be
directed to a CPU isolated via the nohz_full= or isolcpus=nohz
command-line parameters.

Directing the interrupt to a nohz_full CPU degrades its tickless isolation.
Make the automatic ranking isolation-aware: split DPTI_RANK_ONLINE into
DPTI_RANK_HOUSEKEEPING for CPUs in the HK_TYPE_KERNEL_NOISE mask and
DPTI_RANK_ISOLATED for the nohz_full-isolated ones.

The CPU hotplug online callback reselects and migrates the DPTI on rank
improvement: a housekeeping CPU that comes online later takes over from an
isolated one that claimed the package earlier in boot.

A migration that the hardware does not acknowledge leaves the current owner
in place. Warn once about it rather than failing the online callback, whose
message would report the package as broadcasting. This cannot happen during
boot, so the boot-time teardown is unaffected.

Warn once when a package has to fall back to an isolated CPU.

Isolation changes at runtime via cpuset isolated partitions are not
tracked.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 drivers/thermal/intel/therm_throt.c | 47 ++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index c418471cf8f4..c8c91a621cf6 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -17,6 +17,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched/isolation.h>
 #include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
@@ -672,7 +673,8 @@ static void dpti_clear_all(void)
 /**
  * enum dpti_rank - How suitable a CPU is as a DPTI owner
  * @DPTI_RANK_NONE:		No eligible CPU.
- * @DPTI_RANK_ONLINE:		An online CPU of the package (automatic choice).
+ * @DPTI_RANK_ISOLATED:		nohz_full-isolated (last resort).
+ * @DPTI_RANK_HOUSEKEEPING:	Not isolated (ideal automatic choice).
  * @DPTI_RANK_PINNED:		Explicitly requested by the user; overrides any
  *				automatic choice.
  *
@@ -681,14 +683,21 @@ static void dpti_clear_all(void)
  */
 enum dpti_rank {
 	DPTI_RANK_NONE,
-	DPTI_RANK_ONLINE,
+	DPTI_RANK_ISOLATED,
+	DPTI_RANK_HOUSEKEEPING,
 	DPTI_RANK_PINNED,
 };
 
 static enum dpti_rank dpti_cpu_rank(unsigned int cpu)
 {
-	/* No concept of isolation yet: every online CPU ranks the same. */
-	return DPTI_RANK_ONLINE;
+	/*
+	 * Prefer a HK_TYPE_KERNEL_NOISE CPU to avoid disturbing nohz_full
+	 * isolated CPUs. The mask is boot-static. No locking needed.
+	 */
+	if (housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE))
+		return DPTI_RANK_HOUSEKEEPING;
+
+	return DPTI_RANK_ISOLATED;
 }
 
 /*
@@ -731,9 +740,10 @@ static unsigned int dpti_select_cpu(unsigned int pkg_cpu, unsigned int skip,
 			best_rank = cpu_rank;
 			best = cpu;
 			/*
-			 * Nothing outranks an online CPU in automatic selection.
+			 * Nothing outranks a housekeeping CPU in automatic
+			 * selection.
 			 */
-			if (best_rank == DPTI_RANK_ONLINE)
+			if (best_rank == DPTI_RANK_HOUSEKEEPING)
 				break;
 		}
 	}
@@ -743,6 +753,13 @@ static unsigned int dpti_select_cpu(unsigned int pkg_cpu, unsigned int skip,
 	return best;
 }
 
+static void dpti_warn_if_isolated(unsigned int cpu, enum dpti_rank rank)
+{
+	if (rank == DPTI_RANK_ISOLATED)
+		pr_warn_once("Package %u thermal interrupt directed to nohz_full-isolated CPU%u; no housekeeping CPU available\n",
+			     topology_logical_package_id(cpu), cpu);
+}
+
 /*
  * Reselect the owner for @cpu's package and migrate to it, but only on a
  * strict rank improvement.
@@ -771,13 +788,18 @@ static int dpti_update_owner(unsigned int cpu)
 		return 0;
 
 	ret = dpti_program_on_cpu(new_cpu);
-	if (ret)
+	if (ret) {
+		if (old_cpu < nr_cpu_ids)
+			pr_warn_once("Failed to redirect package thermal interrupt from CPU%u to CPU%u; keeping CPU%u\n",
+				     old_cpu, new_cpu, old_cpu);
 		return ret;
+	}
 
 	if (old_cpu < nr_cpu_ids)
 		dpti_clear_on_cpu(old_cpu);
 
 	pkg->owner = new_cpu;
+	dpti_warn_if_isolated(new_cpu, new_rank);
 
 	return 0;
 }
@@ -801,9 +823,14 @@ static int dpti_online(unsigned int cpu)
 
 	/*
 	 * A CPU coming online may be a better owner than the one currently
-	 * programmed.
+	 * programmed. If the hardware does not acknowledge it, the current
+	 * owner keeps the interrupt: a valid outcome, already reported.
 	 */
-	return dpti_update_owner(cpu);
+	ret = dpti_update_owner(cpu);
+	if (ret && dpti_pkg_of_cpu_nocheck(cpu)->owner < nr_cpu_ids)
+		return 0;
+
+	return ret;
 }
 
 static void dpti_offline(unsigned int cpu)
@@ -841,6 +868,7 @@ static void dpti_offline(unsigned int cpu)
 			     cpu, new_cpu);
 
 		new_cpu = nr_cpu_ids;
+		new_rank = DPTI_RANK_NONE;
 	}
 
 	/*
@@ -850,6 +878,7 @@ static void dpti_offline(unsigned int cpu)
 	dpti_config_this_cpu(false);
 
 	dpti_pkgs[pkg_id].owner = new_cpu;
+	dpti_warn_if_isolated(new_cpu, new_rank);
 }
 
 /*

-- 
2.43.0

