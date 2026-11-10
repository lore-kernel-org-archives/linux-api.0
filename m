Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281811;
	b=b9hX+8Z52un1ErYJDihbvZpmmIkObUbWDzbj9SYvqH8pl4nzhOOktZOObD7AfuVe3mzs
	 8fbbR5gMGJOs9/DKLlt4PsKkiImMPw/EzGtBRvq2umfAJLp0bg3IEBfkY7oK5cRyFC0f+
	 GWv9vdypoYykb5b/bhDnGUEUA1Wr13DvmVWxnyzAK93i7EagdxLYlPVWM63t+7qp92mAv
	 PvTKTyRYuGjb5x6c9aTWiKTaQak7/rDzNvu/zVKu6x1ojhKQO9oIFoE8cE+vEjyO5Q+LE
	 y2W0CRnbGlTMjRhsd/WMFo0Y2y9UWANdVLZwzzgnC4rOTHj+lqw6kBaUY3JFdulOZ4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281811;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=/OyWm2po7wmBu6sRyHb2T0g8K1yOUjLm25tauaNJ68Y=;
	b=UlboK3bV3wXlHrKWQ6OuwY3KJ9CZJVa8ELHSJbkxSV2S8dMy9b7rM7Zwj8VF9isUxYej
	 uGSYiCY2/v276gRGPD3OqGxXvugj4ZWNJzWBqj4gd7JrjJsYNFEv6g/K7PE9SSZcBwJZd
	 3yqszRUJhOlIAnF7MTfLliAAAIM9E0ljlWGs90oI8RvqoodZhmRPiRiZxd8IsfrGeRwtW
	 VdwflzJuByq3l9jSoj8Lhpc81K3K6FNZFxU0YHlEoTvkTHnnILiii1n/9sk5QZW97jSk8
	 fiAUTSjgW+EBtJZeaHCoFSZHfxmXaGUvuEJ8rw9A/iNmiwJYH7QubamZ518y6W4EvUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MiVTHdX2;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6A3606A32E;
	Tue, 10 Nov 2026 03:36:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D6A3606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MiVTHdX2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281810; x=1825817810;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=6tmGCGeB1/noGjmD+MSSOJlMOiM0EtVYDkmW2Xylwt4=;
  b=MiVTHdX2OXGwhc7GMZVzN8QiKkX/acvj7Aoghr6WcMdJh73V60E4/NSv
   riuHvIayt+Ph/FTmYc1hv/l4Xr2mtBpI10OAfRZKr9xMmWE80wh+H7xna
   D/H4uiZqs09Rjg3qgCxj57hRiyOKiSRGNU1ElO8RtyWktn8yragcDZWmB
   4v12S+gN3aRZAayDgJamy8Qo6/ZsKfBASfhF68eSSrQW6mb2oF4nEAeZ4
   Axd22lNTF99x8GlGsPlSJHyIy1KGc5KIft+CQMeIaW8kIJf3pTpV2BYZ9
   Kh3fogs1QianGf1hH5tX+cMqV89kzzcYZ/bX7s6BvWl+zo6t+S38MvQWr
   Q==;
X-CSE-ConnectionGUID: MCX0qli/RbOdLGpt8ae6cw==
X-CSE-MsgGUID: qpYD+bGwRoi3uArcWC2FjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010637"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010637"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: mOimwpSwTraE0B5DKENNhg==
X-CSE-MsgGUID: IAeyHKAES0iZxonjBDpWpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370789"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:29 -0800
Subject: [PATCH 02/13] thermal: intel: Prefix log messages via pr_fmt()
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
Message-Id: <20261109-dpti-custom-cpu-v1-2-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=2082;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=6tmGCGeB1/noGjmD+MSSOJlMOiM0EtVYDkmW2Xylwt4=;
 b=kSpOPwHRuZPO4j6AuFuzkuE9a95M7K2l0dDjjzqe8BvbkPVlFBxAkfV/aV0CfnK1wQqW2OwkE
 kTyheTe6ZmRAS5LVMrPsiaRs7A5B7bW31u8eIpG408I3odaolAHGsmw
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

therm_throt.c emits several log messages, but no pr_fmt() is defined, so
dmesg carries no subsystem hint about which file produced a given line.

Define pr_fmt() to prepend KBUILD_MODNAME, matching thermal_core.c and
most Intel-thermal neighbors (intel_powerclamp, x86_pkg_temp_thermal,
intel_soc_dts_thermal, etc.).

While at it, drop the trailing periods from the two DPTI messages that
have them. No other message in this file uses one.

No functional change intended beyond the log message text.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 drivers/thermal/intel/therm_throt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index 1ed604bd70e0..afbccd367c0b 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -14,6 +14,9 @@
  * Credits: Adapted from Zwane Mwaikambo's original code in mce_intel.c.
  *          Inspired by Ross Biro's and Al Borchers' counter code.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
@@ -717,7 +720,7 @@ static void disable_directed_thermal_pkg_intr(unsigned int cpu)
 		smp_call_function_single(new_cpu, config_directed_thermal_pkg_intr,
 					 &enable, true);
 
-		pr_warn_once("Failed to redirect package thermal interrupt from CPU%u to CPU%u; reverting to broadcast.\n",
+		pr_warn_once("Failed to redirect package thermal interrupt from CPU%u to CPU%u; reverting to broadcast\n",
 			     cpu, new_cpu);
 
 		new_cpu = nr_cpu_ids;
@@ -825,7 +828,7 @@ static int thermal_throttle_online(unsigned int cpu)
 	intel_hfi_online(cpu);
 
 	if (enable_directed_thermal_pkg_intr(cpu)) {
-		pr_info_once("Failed to direct package thermal interrupts. All CPUs will receive it.\n");
+		pr_info_once("Failed to direct package thermal interrupts. All CPUs will receive it\n");
 		cleanup_directed_pkg_thermal_intr();
 	}
 

-- 
2.43.0

