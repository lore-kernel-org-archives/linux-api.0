From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v9 3/3] tpm: update PPI documentation to address the location change.
Date: Tue, 29 Sep 2015 10:36:33 +0300
Message-ID: <1443512197-5477-4-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1443512197-5477-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443512197-5477-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: peterhuewe@gmx.de, gregkh@linuxfoundation.org, jgunthorpe@obsidianresearch.com, akpm@linux-foundation.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Updated Documentation/ABI/testing/sysfs-driver-ppi in order to explain
where PPI attributes are located and how backwards compatiblity is
addressed.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
 Contact:	xiaoyan.zhang@intel.com
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
 Contact:	xiaoyan.zhang@intel.com
 Description:
@@ -18,7 +23,7 @@ Description:
 		platform.
 		This file is readonly.
 
-What:		/sys/devices/pnp0/<bus-num>/ppi/request
+What:		/sys/class/tpm/tpmX/ppi/request
 Date:		August 2012
 Contact:	xiaoyan.zhang@intel.com
 Description:
@@ -28,7 +33,7 @@ Description:
 		integer value range from 1 to 160, and 0 means no request.
 		This file can be read and written.
 
-What:		/sys/devices/pnp0/00:<bus-num>/ppi/response
+What:		/sys/class/tpm/tpmX/ppi/response
 Date:		August 2012
 Contact:	xiaoyan.zhang@intel.com
 Description:
@@ -37,7 +42,7 @@ Description:
 		: <response description>".
 		This file is readonly.
 
-What:		/sys/devices/pnp0/<bus-num>/ppi/transition_action
+What:		/sys/class/tpm/tpmX/ppi/transition_action
 Date:		August 2012
 Contact:	xiaoyan.zhang@intel.com
 Description:
@@ -47,7 +52,7 @@ Description:
 		description>".
 		This file is readonly.
 
-What:		/sys/devices/pnp0/<bus-num>/ppi/tcg_operations
+What:		/sys/class/tpm/tpmX/ppi/tcg_operations
 Date:		August 2012
 Contact:	xiaoyan.zhang@intel.com
 Description:
@@ -58,7 +63,7 @@ Description:
 		This attribute is only supported by PPI version 1.2+.
 		This file is readonly.
 
-What:		/sys/devices/pnp0/<bus-num>/ppi/vs_operations
+What:		/sys/class/tpm/tpmX/ppi/vs_operations
 Date:		August 2012
 Contact:	xiaoyan.zhang@intel.com
 Description:
-- 
2.5.0
