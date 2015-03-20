From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH v2] coresight: moving to new "hwtracing" directory
Date: Fri, 20 Mar 2015 11:01:23 -0600
Message-ID: <1426870883-12169-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux@arm.linux.org.uk, catalin.marinas@arm.com
Cc: will.deacon@arm.com, gregkh@linuxfoundation.org, alexander.shishkin@linux.intel.com, linux-kernel@vger.kernel.org, peter.lachner@intel.com, norbert.schulz@intel.com, keven.boell@intel.com, yann.fouassier@intel.com, laurent.fert@intel.com, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kaixu.xia@linaro.org, zhang.chunyan@linaro.org, mathieu.poirier@linaro.org
List-Id: linux-api@vger.kernel.org

Keeping drivers related to HW tracing on ARM, i.e coresight,
under "drivers/coresight" doesn't make sense when other
architectures start rolling out technologies of the same
nature.

As such creating a new "drivers/hwtracing" directory where all
drivers of the same kind can reside, reducing namespace
pollution under "drivers/".

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
Change for v2:
 - generated patch with -M option 
---
 MAINTAINERS                                              | 2 +-
 arch/arm/Kconfig.debug                                   | 2 +-
 arch/arm64/Kconfig.debug                                 | 2 +-
 drivers/Makefile                                         | 2 +-
 drivers/{ => hwtracing}/coresight/Kconfig                | 0
 drivers/{ => hwtracing}/coresight/Makefile               | 0
 drivers/{ => hwtracing}/coresight/coresight-etb10.c      | 0
 drivers/{ => hwtracing}/coresight/coresight-etm-cp14.c   | 0
 drivers/{ => hwtracing}/coresight/coresight-etm.h        | 0
 drivers/{ => hwtracing}/coresight/coresight-etm3x.c      | 0
 drivers/{ => hwtracing}/coresight/coresight-funnel.c     | 0
 drivers/{ => hwtracing}/coresight/coresight-priv.h       | 0
 drivers/{ => hwtracing}/coresight/coresight-replicator.c | 0
 drivers/{ => hwtracing}/coresight/coresight-tmc.c        | 0
 drivers/{ => hwtracing}/coresight/coresight-tpiu.c       | 0
 drivers/{ => hwtracing}/coresight/coresight.c            | 0
 drivers/{ => hwtracing}/coresight/of_coresight.c         | 0
 17 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/{ => hwtracing}/coresight/Kconfig (100%)
 rename drivers/{ => hwtracing}/coresight/Makefile (100%)
 rename drivers/{ => hwtracing}/coresight/coresight-etb10.c (100%)
 rename drivers/{ => hwtracing}/coresight/coresight-etm-cp14.c (100%)
 rename drivers/{ => hwtracing}/coresight/coresight-etm.h (100%)
 rename drivers/{ => hwtracing}/coresight/coresight-etm3x.c (100%)
 rename drivers/{ => hwtracing}/coresight/coresight-funnel.c (100%)
 rename drivers/{ => hwtracing}/coresight/coresight-priv.h (100%)
 rename drivers/{ => hwtracing}/coresight/coresight-replicator.c (100%)
 rename drivers/{ => hwtracing}/coresight/coresight-tmc.c (100%)
 rename drivers/{ => hwtracing}/coresight/coresight-tpiu.c (100%)
 rename drivers/{ => hwtracing}/coresight/coresight.c (100%)
 rename drivers/{ => hwtracing}/coresight/of_coresight.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0e1abe8cc684..bc5d53ba1197 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -953,7 +953,7 @@ ARM/CORESIGHT FRAMEWORK AND DRIVERS
 M:	Mathieu Poirier <mathieu.poirier@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	drivers/coresight/*
+F:	drivers/hwtracing/coresight/*
 F:	Documentation/trace/coresight.txt
 F:	Documentation/devicetree/bindings/arm/coresight.txt
 F:	Documentation/ABI/testing/sysfs-bus-coresight-devices-*
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 8d14ad4e1db0..8b0183a9a300 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1610,6 +1610,6 @@ config DEBUG_SET_MODULE_RONX
 	  against certain classes of kernel exploits.
 	  If in doubt, say "N".
 
-source "drivers/coresight/Kconfig"
+source "drivers/hwtracing/coresight/Kconfig"
 
 endmenu
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 5b2ffd8e6cdb..d6285ef9b5f9 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -89,6 +89,6 @@ config DEBUG_ALIGN_RODATA
 
 	  If in doubt, say N
 
-source "drivers/coresight/Kconfig"
+source "drivers/hwtracing/coresight/Kconfig"
 
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 527a6da8d539..46d2554be404 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -163,5 +163,5 @@ obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
 obj-$(CONFIG_RAS)		+= ras/
 obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
-obj-$(CONFIG_CORESIGHT)		+= coresight/
+obj-$(CONFIG_CORESIGHT)		+= hwtracing/coresight/
 obj-$(CONFIG_ANDROID)		+= android/
diff --git a/drivers/coresight/Kconfig b/drivers/hwtracing/coresight/Kconfig
similarity index 100%
rename from drivers/coresight/Kconfig
rename to drivers/hwtracing/coresight/Kconfig
diff --git a/drivers/coresight/Makefile b/drivers/hwtracing/coresight/Makefile
similarity index 100%
rename from drivers/coresight/Makefile
rename to drivers/hwtracing/coresight/Makefile
diff --git a/drivers/coresight/coresight-etb10.c b/drivers/hwtracing/coresight/coresight-etb10.c
similarity index 100%
rename from drivers/coresight/coresight-etb10.c
rename to drivers/hwtracing/coresight/coresight-etb10.c
diff --git a/drivers/coresight/coresight-etm-cp14.c b/drivers/hwtracing/coresight/coresight-etm-cp14.c
similarity index 100%
rename from drivers/coresight/coresight-etm-cp14.c
rename to drivers/hwtracing/coresight/coresight-etm-cp14.c
diff --git a/drivers/coresight/coresight-etm.h b/drivers/hwtracing/coresight/coresight-etm.h
similarity index 100%
rename from drivers/coresight/coresight-etm.h
rename to drivers/hwtracing/coresight/coresight-etm.h
diff --git a/drivers/coresight/coresight-etm3x.c b/drivers/hwtracing/coresight/coresight-etm3x.c
similarity index 100%
rename from drivers/coresight/coresight-etm3x.c
rename to drivers/hwtracing/coresight/coresight-etm3x.c
diff --git a/drivers/coresight/coresight-funnel.c b/drivers/hwtracing/coresight/coresight-funnel.c
similarity index 100%
rename from drivers/coresight/coresight-funnel.c
rename to drivers/hwtracing/coresight/coresight-funnel.c
diff --git a/drivers/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
similarity index 100%
rename from drivers/coresight/coresight-priv.h
rename to drivers/hwtracing/coresight/coresight-priv.h
diff --git a/drivers/coresight/coresight-replicator.c b/drivers/hwtracing/coresight/coresight-replicator.c
similarity index 100%
rename from drivers/coresight/coresight-replicator.c
rename to drivers/hwtracing/coresight/coresight-replicator.c
diff --git a/drivers/coresight/coresight-tmc.c b/drivers/hwtracing/coresight/coresight-tmc.c
similarity index 100%
rename from drivers/coresight/coresight-tmc.c
rename to drivers/hwtracing/coresight/coresight-tmc.c
diff --git a/drivers/coresight/coresight-tpiu.c b/drivers/hwtracing/coresight/coresight-tpiu.c
similarity index 100%
rename from drivers/coresight/coresight-tpiu.c
rename to drivers/hwtracing/coresight/coresight-tpiu.c
diff --git a/drivers/coresight/coresight.c b/drivers/hwtracing/coresight/coresight.c
similarity index 100%
rename from drivers/coresight/coresight.c
rename to drivers/hwtracing/coresight/coresight.c
diff --git a/drivers/coresight/of_coresight.c b/drivers/hwtracing/coresight/of_coresight.c
similarity index 100%
rename from drivers/coresight/of_coresight.c
rename to drivers/hwtracing/coresight/of_coresight.c
-- 
1.9.1
