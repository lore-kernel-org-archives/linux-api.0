From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v8 3/3] tpm: update PPI documentation to address the location change.
Date: Fri,  3 Jul 2015 17:27:20 +0300
Message-ID: <1435933643-4516-4-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1435933643-4516-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435933643-4516-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: peterhuewe-Mmb7MZpHnFY@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Updated Documentation/ABI/testing/sysfs-driver-ppi in order to explain
where PPI attributes are located and how backwards compatiblity is
addressed.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-driver-ppi | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ppi b/Documentation/ABI/testing/sysfs-driver-ppi
index 7d1435b..9921ef2 100644
--- a/Documentation/ABI/testing/sysfs-driver-ppi
+++ b/Documentation/ABI/testing/sysfs-driver-ppi
@@ -1,4 +1,4 @@
-What:		/sys/devices/pnp0/<bus-num>/ppi/
+What:		/sys/class/tpm/tpmX/ppi/
 Date:		August 2012
 Kernel Version:	3.6
 Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
@@ -8,9 +8,14 @@ Description:
 		folder makes sense. The folder path can be got by command
 		'find /sys/ -name 'pcrs''. For the detail information of PPI,
 		please refer to the PPI specification from
+
 		http://www.trustedcomputinggroup.org/
 
-What:		/sys/devices/pnp0/<bus-num>/ppi/version
+		In Linux 4.2 ppi was moved to the character device directory.
+		A symlink from tpmX/device/ppi to tpmX/ppi to provide backwards
+		compatibility.
+
+What:		/sys/class/tpm/tpmX/ppi/version
 Date:		August 2012
 Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
 Description:
@@ -18,7 +23,7 @@ Description:
 		platform.
 		This file is readonly.
 
-What:		/sys/devices/pnp0/<bus-num>/ppi/request
+What:		/sys/class/tpm/tpmX/ppi/request
 Date:		August 2012
 Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
 Description:
@@ -28,7 +33,7 @@ Description:
 		integer value range from 1 to 160, and 0 means no request.
 		This file can be read and written.
 
-What:		/sys/devices/pnp0/00:<bus-num>/ppi/response
+What:		/sys/class/tpm/tpmX/ppi/response
 Date:		August 2012
 Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
 Description:
@@ -37,7 +42,7 @@ Description:
 		: <response description>".
 		This file is readonly.
 
-What:		/sys/devices/pnp0/<bus-num>/ppi/transition_action
+What:		/sys/class/tpm/tpmX/ppi/transition_action
 Date:		August 2012
 Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
 Description:
@@ -47,7 +52,7 @@ Description:
 		description>".
 		This file is readonly.
 
-What:		/sys/devices/pnp0/<bus-num>/ppi/tcg_operations
+What:		/sys/class/tpm/tpmX/ppi/tcg_operations
 Date:		August 2012
 Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
 Description:
@@ -58,7 +63,7 @@ Description:
 		This attribute is only supported by PPI version 1.2+.
 		This file is readonly.
 
-What:		/sys/devices/pnp0/<bus-num>/ppi/vs_operations
+What:		/sys/class/tpm/tpmX/ppi/vs_operations
 Date:		August 2012
 Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
 Description:
-- 
2.1.4
