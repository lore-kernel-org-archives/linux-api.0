Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281813;
	b=menSdLpZo7POdkwhqoU7B3+pdcVgzDyKrDe012S76j7GLZBKBVdN4Z+1QH8uGJK25eXX
	 LAdMOCacCCIszWE2AQ7hwIB8a3v9UFJfTJPJ0a1byUn4CuC8bEmhnIgmEvP5gwO2d5Etu
	 XXO199yb8vrRnMAK3yPjSCBvlrUzf9++daThqnlalaLLOuJROOuTNgmmgX2mUICaWQ3EX
	 vzm9hq7ZO0y/ZWfgkorzvhcHyRcon/xH5GmG5AgrvcebR9cOjtjNkQOdP4xi400JH4gM/
	 bbK0w9mWO+o62Ev7nfgZ6d9KqghnuR0XoM05hBoTNBg55GzF6oZiLk5R0JDV1UAd5bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281813;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=6orKxwIYfstO9wberIRN6Th3w1uErss6hpUbWvajyVY=;
	b=gw9PzHn/lYny3Kslb1vUlUTKcr4OSxNng8luFy6O7+MLXN5ogG/KsJfrOMXcTw1odvAH
	 YKfLjznv0+yTKl0Sv/JUYrV9TXlrW4Fxa7svdobtAZk0s/LXyRYOAioaRfiq9iuniTGrm
	 vn9akzMhMNPzELTYHDbhT0wzkCm6XHrg1MTABNP3RzspjXRycsmY8Y5Gttfhlg3wv033+
	 YjCGx5RxolfcxlBj3Y/MLwOwPaTOe/9MkHHKRsQAkUzWF3awY8kYmnTzX+cxW5Agr3Rog
	 EDaaEcTwff2HyyZ6SURfzeqKNzz0gKOWpT+g5qM5GCtYlY02hWSG1fLNv/QLW0+Jn/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="TGdX3/4a";
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3D160A2614;
	Tue, 10 Nov 2026 03:36:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B3D160A2614
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TGdX3/4a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281813; x=1825817813;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=++wDKa2GSXhNYt2AEEJGU7uF1hAHAu4wSMm1/HP6pos=;
  b=TGdX3/4akKVnGK3cDEvqva48UBzq9b6qjF7npC5RuUqHbnL4ReIP1yY4
   DnOhVo9h5OtnOR/IvmZmXoM2W0uvh2IPTSpyVIES9B5XZArZF2guqQmB2
   5Ety9J6utamImhuylnTol3W+fXAqyskhxBpO9ydL7zL0PT8QJNPCyFFcW
   dV4PDb3T8r1cSJs45oAmZkzJwmeTMauUS2FlWndYKWyYFO7kdmZJWKsuU
   TxRdU4oXEHK+faf5SgBRUcuVVJ7i1d6w6hJgUAxk2M5/l/fnkt4BRWpw0
   WUUWAvmg8DkB43n0LFPs1BYKCaHjjwY0NwyOI5Y8nvy/fUKVjJ2DpVzuJ
   g==;
X-CSE-ConnectionGUID: a0oIedeNRMqZMKjP1cBIzw==
X-CSE-MsgGUID: fWlHMcrsS16QyXzTuD6o0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010663"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010663"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: G8FkmxvhShedVeZRwz8Fuw==
X-CSE-MsgGUID: kSwSJcykR0aS5RJUbsReQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370813"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:49 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:37 -0800
Subject: [PATCH 10/13] thermal: intel: dpti: Add rank-based owner selection
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
Message-Id: <20261109-dpti-custom-cpu-v1-10-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=7981;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=++wDKa2GSXhNYt2AEEJGU7uF1hAHAu4wSMm1/HP6pos=;
 b=RkHDOKeL4f41fcMpBjVGseKg/bspIleeRL9vTc80+RX6XzvzbSvYscgWw3JndvqAQR0TW7TAZ
 /Ub4zZb0x+gCUmXjfA7WRRpAD3ICK07mcf55PBdlM8aC+3Siom9s3Sb
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

Prepare for a sysfs interface that lets the user choose a CPU to own a
package's directed package-level thermal interrupt (DPTI). Add the state
and selection functionality for a pinned owner.

Implement a ranking mechanism to identify the best-suited CPU to own the
interrupt. The highest-ranked CPU in a package is the one the user selects
(DPTI_RANK_PINNED). All other CPUs are ranked as DPTI_RANK_ONLINE until
owner selection becomes isolation-aware.

On CPU hotplug events, re-evaluate which CPU owns the DPTI. If a
better-ranked CPU comes online, move the interrupt to that CPU. Likewise,
if the owner goes offline, find the next best-ranked CPU and move the
interrupt there. Both cases can occur if the user-selected CPU changes its
online status.

dpti_select_cpu() also reports the rank of its choice, which the online
path needs for its strict-improvement test. dpti_offline() ignores it until
isolation-aware selection warns about an isolated owner, but passes it
anyway rather than making the argument optional.

Route both hotplug callbacks through dpti_lookup_pkg_id() so that they
validate the package id the same way. dpti_online() needs only the
validation: let dpti_lookup_pkg_id() take a NULL pkg_id. dpti_online() now
returns the lookup's -ENODEV rather than -EINVAL: the CPU comes from the
hotplug core and is valid; what is missing is a per-package slot. The
caller only tests the value against zero.

With all CPUs ranked equally, behavior changes only after a failed
acknowledgment: the package then retries on its lowest-numbered online CPU
rather than on the CPU coming online.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 drivers/thermal/intel/therm_throt.c | 151 +++++++++++++++++++++++++++++++-----
 1 file changed, 130 insertions(+), 21 deletions(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index e6ce443c0a9d..97c205dab1b6 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -559,9 +559,13 @@ static int dpti_program_on_cpu(unsigned int cpu)
  * struct dpti_pkg - Per-package DPTI state
  * @owner:	CPU currently programmed to receive the package-level
  *		interrupt, or nr_cpu_ids when the package has no owner.
+ * @pin:	CPU the user requested as the owner, or nr_cpu_ids for
+ *		automatic selection. A pinned CPU overrides the automatic
+ *		selection whenever it is online.
  */
 struct dpti_pkg {
 	unsigned int owner;
+	unsigned int pin;
 };
 
 /*
@@ -596,6 +600,7 @@ static bool dpti_supported(void)
 	return true;
 }
 
+/* @pkg_id may be NULL for a caller that only validates @cpu. */
 static int dpti_lookup_pkg_id(unsigned int cpu, u16 *pkg_id)
 {
 	u16 id;
@@ -607,7 +612,8 @@ static int dpti_lookup_pkg_id(unsigned int cpu, u16 *pkg_id)
 	if (id >= topology_max_packages())
 		return -ENODEV;
 
-	*pkg_id = id;
+	if (pkg_id)
+		*pkg_id = id;
 
 	return 0;
 }
@@ -655,44 +661,145 @@ static void dpti_clear_all(void)
 	}
 }
 
-static int dpti_online(unsigned int cpu)
+/**
+ * enum dpti_rank - How suitable a CPU is as a DPTI owner
+ * @DPTI_RANK_NONE:		No eligible CPU.
+ * @DPTI_RANK_ONLINE:		An online CPU of the package (automatic choice).
+ * @DPTI_RANK_PINNED:		Explicitly requested by the user; overrides any
+ *				automatic choice.
+ *
+ * Higher is better; the selection picks the highest-ranked online CPU in the
+ * package.
+ */
+enum dpti_rank {
+	DPTI_RANK_NONE,
+	DPTI_RANK_ONLINE,
+	DPTI_RANK_PINNED,
+};
+
+static enum dpti_rank dpti_cpu_rank(unsigned int cpu)
 {
-	u16 pkg_id;
-	int ret;
+	/* No concept of isolation yet: every online CPU ranks the same. */
+	return DPTI_RANK_ONLINE;
+}
 
-	if (!dpti_supported())
-		return 0;
+/*
+ * Select the owner of the package-level thermal interrupt for @pkg_cpu's
+ * package. @skip is excluded from the selection (e.g., if it is going offline).
+ * @rank receives the rank of the selected CPU.
+ *
+ * A user-pinned CPU takes precedence whenever it is online; otherwise the best
+ * ranked CPU in the package is chosen.
+ */
+static unsigned int dpti_select_cpu(unsigned int pkg_cpu, unsigned int skip,
+				    enum dpti_rank *rank)
+{
+	const struct cpumask *pkg_mask = topology_core_cpumask(pkg_cpu);
+	enum dpti_rank best_rank = DPTI_RANK_NONE;
+	unsigned int cpu, pin, best = nr_cpu_ids;
 
-	pkg_id = topology_logical_package_id(cpu);
-	if (pkg_id >= topology_max_packages())
-		return -EINVAL;
+	lockdep_assert_cpus_held();
+
+	/*
+	 * Choose the user-pinned CPU if available: it is online and not going
+	 * offline (as indicated by @skip).
+	 */
+	pin = dpti_pkg_of_cpu_nocheck(pkg_cpu)->pin;
+	if (pin < nr_cpu_ids && pin != skip &&
+	    cpumask_test_cpu(pin, pkg_mask)) {
+		*rank = DPTI_RANK_PINNED;
+		return pin;
+	}
+
+	for_each_cpu(cpu, pkg_mask) {
+		enum dpti_rank cpu_rank;
+
+		if (cpu == skip)
+			continue;
+
+		cpu_rank = dpti_cpu_rank(cpu);
+		if (cpu_rank > best_rank) {
+			best_rank = cpu_rank;
+			best = cpu;
+			/*
+			 * Nothing outranks an online CPU in automatic selection.
+			 */
+			if (best_rank == DPTI_RANK_ONLINE)
+				break;
+		}
+	}
+
+	*rank = best_rank;
+
+	return best;
+}
+
+/*
+ * Reselect the owner for @cpu's package and migrate to it, but only on a
+ * strict rank improvement.
+ */
+static int dpti_update_owner(unsigned int cpu)
+{
+	struct dpti_pkg *pkg = dpti_pkg_of_cpu_nocheck(cpu);
+	enum dpti_rank new_rank, old_rank;
+	unsigned int new_cpu, old_cpu;
+	int ret;
 
 	if (dpti_shut_down)
 		return 0;
 
-	/* Another CPU in this package already owns the directed interrupt. */
-	if (dpti_pkgs[pkg_id].owner != nr_cpu_ids)
+	old_cpu = pkg->owner;
+	new_cpu = dpti_select_cpu(cpu, nr_cpu_ids, &new_rank);
+	if (new_cpu == old_cpu)
 		return 0;
 
-	ret = dpti_program_on_cpu(cpu);
+	old_rank = DPTI_RANK_NONE;
+	if (old_cpu < nr_cpu_ids)
+		old_rank = dpti_cpu_rank(old_cpu);
+	if (new_rank <= old_rank)
+		return 0;
+
+	ret = dpti_program_on_cpu(new_cpu);
 	if (ret)
 		return ret;
 
-	dpti_pkgs[pkg_id].owner = cpu;
+	if (old_cpu < nr_cpu_ids)
+		dpti_clear_on_cpu(old_cpu);
+
+	pkg->owner = new_cpu;
 
 	return 0;
 }
 
+static int dpti_online(unsigned int cpu)
+{
+	int ret;
+
+	if (!dpti_supported())
+		return 0;
+
+	/*
+	 * Validate @cpu's package id on behalf of dpti_update_owner(), which
+	 * indexes dpti_pkgs[] based on @cpu.
+	 */
+	ret = dpti_lookup_pkg_id(cpu, NULL);
+	if (ret)
+		return ret;
+
+	/*
+	 * A CPU coming online may be a better owner than the one currently
+	 * programmed.
+	 */
+	return dpti_update_owner(cpu);
+}
+
 static void dpti_offline(unsigned int cpu)
 {
+	enum dpti_rank new_rank;
 	unsigned int new_cpu;
 	u16 pkg_id;
 
-	if (!dpti_supported())
-		return;
-
-	pkg_id = topology_logical_package_id(cpu);
-	if (pkg_id >= topology_max_packages())
+	if (dpti_lookup_pkg_id(cpu, &pkg_id))
 		return;
 
 	if (dpti_shut_down)
@@ -706,7 +813,7 @@ static void dpti_offline(unsigned int cpu)
 	 * The package-level interrupt must remain directed after this CPU goes
 	 * offline.
 	 */
-	new_cpu = cpumask_any_but(topology_core_cpumask(cpu), cpu);
+	new_cpu = dpti_select_cpu(cpu, cpu, &new_rank);
 
 	/*
 	 * dpti_program_on_cpu() undoes a setup that the hardware does not
@@ -727,7 +834,7 @@ static void dpti_offline(unsigned int cpu)
 	 */
 	dpti_config_this_cpu(false);
 
-	dpti_pkgs[pkg_id].owner = (new_cpu < nr_cpu_ids) ? new_cpu : nr_cpu_ids;
+	dpti_pkgs[pkg_id].owner = new_cpu;
 }
 
 /*
@@ -785,8 +892,10 @@ static __init void dpti_init(void)
 	if (!dpti_pkgs)
 		return;
 
-	for (i = 0; i < topology_max_packages(); i++)
+	for (i = 0; i < topology_max_packages(); i++) {
 		dpti_pkgs[i].owner = nr_cpu_ids;
+		dpti_pkgs[i].pin = nr_cpu_ids;
+	}
 
 	register_syscore(&dpti_syscore);
 }

-- 
2.43.0

