Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281813;
	b=NNnzt+ULOP5pX2hrQ+sTyqB7zzr5bMiuXdWvDGRxpfd2qHFGnbX+NGPqSAHcw33lGM2O
	 KQv2tgSVHZf/GeMqUUzTEiXLYkmXi4lwK4NCSqiZ4toyYmsWEUmps+5IXsV+h2WEq4RiX
	 zzDGxM6Ad/L1oWF7clJy9owxtKd/JDbLXxkoZ/TZ2KXXxp7HdKUo7PLwipy41S2ob/rKy
	 C7cpWdPWVXm2DWaI6vIMOAUPGn2pbZAnY/buWvPhsc9UYwwG6HVHzckjGPvKmhLbKXiWU
	 LVE6YTr73h4AbZBPhUo5CyqiJdHNg3Rn9gkDLpTX78qHlXMDVoJVwPyyIKmMIJzvYuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281813;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=Vp+AefeiFtQujH5CPnAlySRb9Yz0jRLToe3dzSaEq0s=;
	b=TbhuojCWuYVMCjpWMNwIqZA0YD+fZNZYVaiY242eI4P7xHvOjTiU6w2MLoq4weDRZjwo
	 4F9qyoWIXE6Lcd2YbM2MNA9m6k3HTimh78YamLZjDxHCgMEOADVdZSJ/4jJNpO/7MB3KB
	 s5OGj7kYou6YwMlaS+/88JwTXwRgx7wjKXLLbd5lFmtuZtmH+erpxDJMaTHxZjsIUpigI
	 skCDH3Fjy545oD1hrCewF7LPr+AVf/UJ08yJJKrDe5k0Xxz0gxWXrR7HVe4QVLJE82rZ2
	 eVwCFQZqw7Oja9F9aW3ozWbl1/vl9Lyk+BMT6jT5DW2Uwqsh5bMlvMjTdMiHA/2Xs0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="GgMoW/LL";
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E918260A261F;
	Tue, 10 Nov 2026 03:36:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E918260A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GgMoW/LL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281813; x=1825817813;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=0T3TWnGnFfL0vVyLxNCTiDoxI07hJzlFTkJcLPco9zA=;
  b=GgMoW/LLHjQNE8knfyLNv8+HeXZ44tRgzgM9xM7mT2RH2Zjf0WhDuFWX
   wcTHIdqFUtmXZr5bLO5apRu73FMx85Xhgs+gNjWr1Wu3mIwiHhUvGczJE
   qbcgmhwt9wabHz1mKtuQ2ZrxoKpPlXwxLVkYHkopRshwDl4QHnWanLxcR
   5EAQScGVBwVOG9Kgcrh9m5du8mh3uPtk30rkCm1YesmNb3EuO9VGJ6iON
   yNgYkPV/SqbpSCMTPWSmQ9jgwM3z6WMtaSbv09iDtZx36xGES1Cxxwa/3
   sM94OBJPaCSQoyHjG4ilxRAEhMHS9E71G8aHR42ZWMR3UZJESL4GdHNJd
   w==;
X-CSE-ConnectionGUID: ZFv20sGiSUy1GAc7RFYR8g==
X-CSE-MsgGUID: rYUtemEbQxaH0eFhhjTHCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010666"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010666"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: 33hphzbYTfSjZ0szEnISjw==
X-CSE-MsgGUID: FwBuP/PsRSezAQtSjRkxyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370816"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:49 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:38 -0800
Subject: [PATCH 11/13] thermal: intel: dpti: Serialize updates to the
 directed interrupt state
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
Message-Id: <20261109-dpti-custom-cpu-v1-11-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=4022;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=0T3TWnGnFfL0vVyLxNCTiDoxI07hJzlFTkJcLPco9zA=;
 b=Io7Eqqg3rQyglz2kzwNaXros2Mnw4/wyyVXU2yyr8UPSJiLZoCMbQ1PXyWC/ZzB0uhEdfIjUW
 uRqEy1RpzMqDdEH/lQzbOKDhT0W7YjsH/ymHikX6sBCJuI90hEtoci/
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

dpti_pkgs[] is written from the CPU hotplug callbacks, from the init and
cleanup paths, and from the syscore callbacks. None of those can run
concurrently with one another: the array needs no lock of its own today.

A sysfs interface to select the owner will access dpti_pkgs[] concurrently
with the CPU hotplug callbacks. Introduce dpti_mutex to serialize them. The
mutex is always taken inside the CPU hotplug lock, never the other way
around.

dpti_shut_down needs the same protection. The syscore shutdown callback
sets it with CPU hotplug disabled, which keeps out the CPU hotplug
callbacks but not a sysfs writer. Set it under the mutex too.

No functional change intended: until the sysfs writer lands, there is only
one class of writer, so the mutex is never contended.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 drivers/thermal/intel/therm_throt.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index 97c205dab1b6..c418471cf8f4 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -26,6 +26,7 @@
 #include <linux/export.h>
 #include <linux/delay.h>
 #include <linux/types.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/sysfs.h>
@@ -569,16 +570,17 @@ struct dpti_pkg {
 };
 
 /*
- * Accessed from CPU hotplug callbacks and from code that runs while CPU
- * hotplug is inactive: the init and cleanup paths as well as syscore callbacks.
- * No extra locking needed.
+ * Serializes updates to dpti_pkgs[] and dpti_shut_down. To avoid deadlock, a
+ * path that needs both this mutex and the CPU hotplug lock always takes the
+ * hotplug lock first.
  */
+static DEFINE_MUTEX(dpti_mutex);
+
 static struct dpti_pkg *dpti_pkgs;
 
 /*
- * Set by the syscore shutdown callback before it disables the directed
- * interrupt, so that no CPU hotplug operation enables it again on the way to
- * kexec.
+ * Set under dpti_mutex by the syscore shutdown callback before it disables
+ * DPTI, so that no owner update enables it again on the way to kexec.
  */
 static bool dpti_shut_down;
 
@@ -624,6 +626,10 @@ static struct dpti_pkg *dpti_pkg_of_cpu_nocheck(unsigned int cpu)
 	return &dpti_pkgs[topology_logical_package_id(cpu)];
 }
 
+/*
+ * Reads dpti_pkgs[] without dpti_mutex: the syscore callers run with
+ * interrupts disabled on the only online CPU.
+ */
 static bool dpti_cpu_is_owner(unsigned int cpu)
 {
 	u16 pkg_id;
@@ -647,6 +653,8 @@ static void dpti_clear_all(void)
 	if (!dpti_supported())
 		return;
 
+	guard(mutex)(&dpti_mutex);
+
 	/*
 	 * No need to reset the owners: callers free dpti_pkgs[] or have shut
 	 * DPTI down.
@@ -699,6 +707,7 @@ static unsigned int dpti_select_cpu(unsigned int pkg_cpu, unsigned int skip,
 	unsigned int cpu, pin, best = nr_cpu_ids;
 
 	lockdep_assert_cpus_held();
+	lockdep_assert_held(&dpti_mutex);
 
 	/*
 	 * Choose the user-pinned CPU if available: it is online and not going
@@ -745,6 +754,8 @@ static int dpti_update_owner(unsigned int cpu)
 	unsigned int new_cpu, old_cpu;
 	int ret;
 
+	lockdep_assert_held(&dpti_mutex);
+
 	if (dpti_shut_down)
 		return 0;
 
@@ -786,6 +797,8 @@ static int dpti_online(unsigned int cpu)
 	if (ret)
 		return ret;
 
+	guard(mutex)(&dpti_mutex);
+
 	/*
 	 * A CPU coming online may be a better owner than the one currently
 	 * programmed.
@@ -802,6 +815,8 @@ static void dpti_offline(unsigned int cpu)
 	if (dpti_lookup_pkg_id(cpu, &pkg_id))
 		return;
 
+	guard(mutex)(&dpti_mutex);
+
 	if (dpti_shut_down)
 		return;
 
@@ -866,7 +881,8 @@ static int dpti_syscore_suspend(void *data)
 
 static void dpti_syscore_shutdown(void *data)
 {
-	dpti_shut_down = true;
+	scoped_guard(mutex, &dpti_mutex)
+		dpti_shut_down = true;
 
 	dpti_clear_all();
 }

-- 
2.43.0

