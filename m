Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281813;
	b=tzUt50bd4A/l2DQzjYve8z/AsuTw/TTTy36akTWnF0O3Ds6xn7Rdns1VB8zopcis7ZXi
	 70NiTsZo16lTCzSaZrqJm5qj09C5Xu/Sz0Y9lbR/FK5fT3RUl8FIkcs9b3uzN6h4dt7as
	 +5w3jhJWL61pt7PabNqU71cc0Uo6bx5ZcmIx8DBzrxfEQPQ1fIuDs+yV27zlMWiXwcYW9
	 ylZ4yNrXtXUmnilpMtjOPFYmAPYnn2JwLiVGNkr7wNZjJLeb2cKEFUsi0UAkRfaqJT/ik
	 TfDN1XMTBZrcqs4/mqNhaqaQX4oRnyuMdYzgtJetD2P285tcZVkFAAOEW7lyopfsPJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281813;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=kJQxIiO0wEzb1LUa3B3G7BojtmbLAy5n00wLXjsyTX4=;
	b=h+3b7XHQfjrlwxtLCSHJIe4NE9xueCCh6JW0Xk9YGyQhyvUsixwuOQkQau8hAutj2KY5
	 jOl76L4d0u7xKeDoiOx8/vwA5ECHHJzUFHSj9UzO++jWNPfp+KiGaURaMVzrgM+CqwD47
	 N3roI4UmUV5iPlmjRFoxTWucRZfTAK37A1lxf2L7mhypxf3utF0VXKIJyYdXmaG0TD+uq
	 DUQVpulXNPjdCqK9ZpjMvsyjdmXdggDd45CHhReDQUT4VIZio74DKlaQsFE579Q0U9xVP
	 g+l8DuMqibwRDen2nQuP9/Oy6YWOLk5ynfnEsS04hnylmB8N/49g94YvAv+pVutcbqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NKC8VgVi;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22E560A2605;
	Tue, 10 Nov 2026 03:36:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D22E560A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NKC8VgVi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281812; x=1825817812;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=VJF/8e21Dy8dmzsZuk+FAaiBL+DiMvsJc6Epq12tN+U=;
  b=NKC8VgVioChFF6U5VDMF8jTtycTsBxgaO0KKLh9HFlAZ96evTMMKiCFr
   +TT6qknns/15pJLLQKONXUW/D+DGoVmsOn7nEbbPpjR0Qw3nOitsx67Fm
   KGdevZmG9eQ6Ja90NqsP3SH1HHLZoWNodR18yVcwXCQx4xXjn6ZgZbl3Z
   1p4VGblhgyX3nzJQ+ITvx+ih6SqD8t+cC/VlHzeUXI2cvsC0xLqYbpj07
   Cw7oBNOGl48uXCmV+eQ/0K51BfH6rHh9hC7AgUeed5uJuyy7XYJDC8DOE
   P1khmeWIvRlZLilv2Ksy/AGEqrbj8MRUKONqDUWF/OzwzL4DYAhK4fO6l
   Q==;
X-CSE-ConnectionGUID: tyFBWwoPSsef5rd92UdBZg==
X-CSE-MsgGUID: JtYNqHejQZSIM55VBWMuhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010652"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010652"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: sY/G2PQ0RVmTk5jhk0LXww==
X-CSE-MsgGUID: r1VQb+nCSeu09QbHcdp4Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370804"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:34 -0800
Subject: [PATCH 07/13] thermal: intel: dpti: Configure the local CPU by
 value
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
Message-Id: <20261109-dpti-custom-cpu-v1-7-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=3914;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=VJF/8e21Dy8dmzsZuk+FAaiBL+DiMvsJc6Epq12tN+U=;
 b=8jP8k6O+5LZg0avEvpy5ywqCtTwyqrv6huCrr1LcvrkJ57CwfgW/yG52ghOf1YI7QRiwHD6zw
 93VIPUW9CEvA60dCJ420+VwB73qHvTwZIj8Qcr9yYAnTR2kPEl70DZN
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

dpti_config() enables or disables the directed package-level thermal
interrupt (DPTI) on the CPU that runs it. It takes its argument by
pointer because it also serves as an smp_call_function_single()
callback. A caller that only programs its own CPU therefore has to
declare a scratch bool and track which value it holds at each call site.

Rename it to dpti_config_this_cpu() and let it take the setting by value.
Only the callers that reach another CPU need the callback signature;
unmarshal the argument for them in a thin dpti_config_ipi() trampoline.
The scratch bool then exists only where an SMP function call is made.

This also prepares for factoring the hardware programming sequence into a
helper that runs on the local CPU and configures the interrupt the same
way.

No functional change intended: the MSR read-modify-write is unchanged, and
the scratch bools held a known value at every converted call site.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 drivers/thermal/intel/therm_throt.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index a0a3842e2760..36cdbe0eb6c1 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -500,9 +500,8 @@ static int dpti_wait_for_ack(void)
 	return 0;
 }
 
-static void dpti_config(void *info)
+static void dpti_config_this_cpu(bool enable)
 {
-	bool enable = *((bool *)info);
 	u64 msr_val;
 
 	rdmsrq(MSR_IA32_THERM_INTERRUPT, msr_val);
@@ -515,6 +514,11 @@ static void dpti_config(void *info)
 	wrmsrq(MSR_IA32_THERM_INTERRUPT, msr_val);
 }
 
+static void dpti_config_ipi(void *info)
+{
+	dpti_config_this_cpu(*((bool *)info));
+}
+
 /**
  * struct dpti_pkg - Per-package DPTI state
  * @owner:	CPU currently programmed to receive the package-level
@@ -578,14 +582,13 @@ static void dpti_clear_all(void)
 		if (dpti_pkgs[i].owner == nr_cpu_ids)
 			continue;
 
-		smp_call_function_single(dpti_pkgs[i].owner, dpti_config,
+		smp_call_function_single(dpti_pkgs[i].owner, dpti_config_ipi,
 					 &enable, true);
 	}
 }
 
 static int dpti_online(unsigned int cpu)
 {
-	bool enable = true;
 	u16 pkg_id;
 
 	if (!dpti_supported())
@@ -605,15 +608,14 @@ static int dpti_online(unsigned int cpu)
 	thermal_clear_package_intr_status(PACKAGE_LEVEL,
 					  PACKAGE_THERM_STATUS_DPTI_ACK);
 
-	dpti_config(&enable);
+	dpti_config_this_cpu(true);
 	if (!dpti_wait_for_ack()) {
 		dpti_pkgs[pkg_id].owner = cpu;
 		return 0;
 	}
 
 	/* Roll back on failure so the package reverts to broadcasting mode. */
-	enable = false;
-	dpti_config(&enable);
+	dpti_config_this_cpu(false);
 
 	return -ETIMEDOUT;
 }
@@ -657,7 +659,8 @@ static void dpti_offline(unsigned int cpu)
 		 * but it does not reach this path because all the secondary
 		 * CPUs are offline.
 		 */
-		smp_call_function_single(new_cpu, dpti_config, &enable, true);
+		smp_call_function_single(new_cpu, dpti_config_ipi, &enable,
+					 true);
 	}
 
 	/*
@@ -668,7 +671,8 @@ static void dpti_offline(unsigned int cpu)
 	 */
 	enable = false;
 	if (new_cpu < nr_cpu_ids && dpti_wait_for_ack()) {
-		smp_call_function_single(new_cpu, dpti_config, &enable, true);
+		smp_call_function_single(new_cpu, dpti_config_ipi, &enable,
+					 true);
 
 		pr_warn_once("Failed to redirect package thermal interrupt from CPU%u to CPU%u; reverting to broadcast\n",
 			     cpu, new_cpu);
@@ -680,7 +684,7 @@ static void dpti_offline(unsigned int cpu)
 	 * Clear the directed interrupt on @cpu. Hardware acknowledgment can be
 	 * ignored since @cpu is going offline.
 	 */
-	dpti_config(&enable);
+	dpti_config_this_cpu(false);
 
 	dpti_pkgs[pkg_id].owner = (new_cpu < nr_cpu_ids) ? new_cpu : nr_cpu_ids;
 }

-- 
2.43.0

