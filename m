Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281811;
	b=mamkLJ/Ph//NdyPZ9qIxI2vI9RjjjA2I95Uu/aE4GTPJyaynpsfQsY+A620OobIM70XC
	 8Gm4p9Stw7DXG838pX3C+JELEUmxTiiZNIX9OWEihS4cC+lpP/30viPuHf+y5eVRbkB8B
	 TOs3bf+UUgFus/oEHkW19UaNE60O1oBMXyOGHfAP5vRfEnF3qW8RbthWHikQlZCDtuMRj
	 2qDkNM2EvlYrjqk74mKLsoGBaJMAoanPMAaxG+NAMr6TINInlXLjk1t3K+T8IzJCOQ7kR
	 pKIBvEYhLfO4PPrYCG6EQbdKl3Dd5+WZlMEF+3TAXE6eNh4bjBSvVed8Zu5SlvtMqsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281811;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=kJbDn5H6PtWqLobFK7X6Ceu4bpjFcn3bnz2ZcPIRE8Y=;
	b=Kj5N9LWevqQakpcKNP7QsUuHe1P3yW2kNlkS/AJgtPLFtYVUMje5Vef0RGQ4Gffr9pEf
	 DLApsoJ2+gRBctiu8QKlj/Jbg7K5E9+stbVBt1dbQFyBranArx3jDnVIcWCrw59KRsH20
	 DG94VpOcIL4bY2M7dRfp0VcmC1hk/Nhc3Bu5P6fatZJZucIN4+AYajH0hXLVltUMz9IZG
	 242dPTd/sEI1f/9qe9RD/4mkEJ5JOWaPxH5YVYoTXBB6fJgo4zEfu7B8C99Ks05YuVsGd
	 8t3MoSWNktU1yjyoDMks4wUMg9iXprjeDgjo43UHBPg4AVmHFd2xaHnnHCAqUGWM3iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jRYvADLr;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAACA606A333;
	Tue, 10 Nov 2026 03:36:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAACA606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jRYvADLr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794281811; x=1825817811;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=sF+i+4NrUPBmnWX1u/tZDKshMYm3QXe8ru3BETSGZ/E=;
  b=jRYvADLr+P65XUEkAxPjYXL83EWUC0fa+iKJVR8YrqQn4+CGbG63OJxl
   UY91UgEXNuCsu8Idg+7cKtJPPPPgBtip61Y7LnGkzVwpwkMn1jjAHCff2
   AunVBJyQWTYTdYWl9kJw0vM6bBnTApUBRFYWVskejGU2c8jjTA4XhK1rg
   KDg1MLRllpF5pIvGhxValb/LCbGrlKUb4Ll1S3ep+7sajqUmGtYidUx++
   NBYrp65gj+/boPf0JjTj+vKhAOOhpRoDIrs7gDVbYaN34emBA6YOS4yNe
   /MQ/ZDksMVXheKUpzk3WB5bUQ8V7eAxHaQgv9xZrRiWcsUDCqxgikuSPr
   Q==;
X-CSE-ConnectionGUID: giDfyBI0RTyT63yrfmGz2A==
X-CSE-MsgGUID: G5K9m58OQTey3fprWQ9/cA==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3010640"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="3010640"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
X-CSE-ConnectionGUID: 2T8bewCJTKW9bbSHqSYvHQ==
X-CSE-MsgGUID: DO0eVP7cQEWK6d0g4BvL5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="8370792"
Received: from unknown (HELO [172.25.112.21]) ([172.25.112.21])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 19:36:48 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Date: Mon, 09 Nov 2026 19:36:30 -0800
Subject: [PATCH 03/13] thermal: intel: Move the sysfs device helpers next
 to their callers
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
Message-Id: <20261109-dpti-custom-cpu-v1-3-ead8e2d2067e@linux.intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794281807; l=4660;
 i=ricardo.neri-calderon@linux.intel.com; s=20250602;
 h=from:subject:message-id; bh=sF+i+4NrUPBmnWX1u/tZDKshMYm3QXe8ru3BETSGZ/E=;
 b=iAkpfe1E1mr5ajRxKrcOJMwL9JvdF+K+dXU1Oe0Z7v1+12fmXglbcHZJyTMUSX1AMl9nryhBS
 9Ht3OAH1pLxAU8aYACfGC+VS/90wnDMCUZQc+4FZJ67FCA9S8Bo8Y1p
X-Developer-Key: i=ricardo.neri-calderon@linux.intel.com; a=ed25519;
 pk=NfZw5SyQ2lxVfmNMaMR6KUj3+0OhcwDPyRzFDH9gY2w=

thermal_throttle_add_dev() and thermal_throttle_remove_dev() sit at the
top of the second CONFIG_SYSFS block, more than 300 lines above
thermal_throttle_online() and thermal_throttle_offline(), their only
callers. Anything the add path needs must therefore be declared ahead of
it, even when the definition lives far below.

Wiring a sysfs interface for the directed package-level thermal interrupt
owner into thermal_throttle_add_dev() would need forward declarations.

Move both helpers down, immediately above thermal_throttle_online().

No functional change intended.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
 drivers/thermal/intel/therm_throt.c | 118 ++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index afbccd367c0b..d89362dc5075 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -477,65 +477,6 @@ static int __init int_pln_enable_setup(char *s)
 __setup("int_pln_enable", int_pln_enable_setup);
 
 #ifdef CONFIG_SYSFS
-/* Add/Remove thermal_throttle interface for CPU device: */
-static int thermal_throttle_add_dev(struct device *dev, unsigned int cpu)
-{
-	int err;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	err = sysfs_create_group(&dev->kobj, &thermal_attr_group);
-	if (err)
-		return err;
-
-	if (cpu_has(c, X86_FEATURE_PLN) && int_pln_enable) {
-		err = sysfs_add_file_to_group(&dev->kobj,
-					      &dev_attr_core_power_limit_count.attr,
-					      thermal_attr_group.name);
-		if (err)
-			goto del_group;
-	}
-
-	if (cpu_has(c, X86_FEATURE_PTS)) {
-		err = sysfs_add_file_to_group(&dev->kobj,
-					      &dev_attr_package_throttle_count.attr,
-					      thermal_attr_group.name);
-		if (err)
-			goto del_group;
-
-		err = sysfs_add_file_to_group(&dev->kobj,
-					      &dev_attr_package_throttle_max_time_ms.attr,
-					      thermal_attr_group.name);
-		if (err)
-			goto del_group;
-
-		err = sysfs_add_file_to_group(&dev->kobj,
-					      &dev_attr_package_throttle_total_time_ms.attr,
-					      thermal_attr_group.name);
-		if (err)
-			goto del_group;
-
-		if (cpu_has(c, X86_FEATURE_PLN) && int_pln_enable) {
-			err = sysfs_add_file_to_group(&dev->kobj,
-					&dev_attr_package_power_limit_count.attr,
-					thermal_attr_group.name);
-			if (err)
-				goto del_group;
-		}
-	}
-
-	return 0;
-
-del_group:
-	sysfs_remove_group(&dev->kobj, &thermal_attr_group);
-
-	return err;
-}
-
-static void thermal_throttle_remove_dev(struct device *dev)
-{
-	sysfs_remove_group(&dev->kobj, &thermal_attr_group);
-}
-
 static int check_directed_thermal_pkg_intr_ack(void)
 {
 	unsigned int count = 15000;
@@ -802,6 +743,65 @@ static void cleanup_directed_pkg_thermal_intr(void)
 	directed_intr_handler_cpus = NULL;
 }
 
+/* Add/Remove thermal_throttle interface for CPU device: */
+static int thermal_throttle_add_dev(struct device *dev, unsigned int cpu)
+{
+	int err;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	err = sysfs_create_group(&dev->kobj, &thermal_attr_group);
+	if (err)
+		return err;
+
+	if (cpu_has(c, X86_FEATURE_PLN) && int_pln_enable) {
+		err = sysfs_add_file_to_group(&dev->kobj,
+					      &dev_attr_core_power_limit_count.attr,
+					      thermal_attr_group.name);
+		if (err)
+			goto del_group;
+	}
+
+	if (cpu_has(c, X86_FEATURE_PTS)) {
+		err = sysfs_add_file_to_group(&dev->kobj,
+					      &dev_attr_package_throttle_count.attr,
+					      thermal_attr_group.name);
+		if (err)
+			goto del_group;
+
+		err = sysfs_add_file_to_group(&dev->kobj,
+					      &dev_attr_package_throttle_max_time_ms.attr,
+					      thermal_attr_group.name);
+		if (err)
+			goto del_group;
+
+		err = sysfs_add_file_to_group(&dev->kobj,
+					      &dev_attr_package_throttle_total_time_ms.attr,
+					      thermal_attr_group.name);
+		if (err)
+			goto del_group;
+
+		if (cpu_has(c, X86_FEATURE_PLN) && int_pln_enable) {
+			err = sysfs_add_file_to_group(&dev->kobj,
+					&dev_attr_package_power_limit_count.attr,
+					thermal_attr_group.name);
+			if (err)
+				goto del_group;
+		}
+	}
+
+	return 0;
+
+del_group:
+	sysfs_remove_group(&dev->kobj, &thermal_attr_group);
+
+	return err;
+}
+
+static void thermal_throttle_remove_dev(struct device *dev)
+{
+	sysfs_remove_group(&dev->kobj, &thermal_attr_group);
+}
+
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
 static int thermal_throttle_online(unsigned int cpu)
 {

-- 
2.43.0

