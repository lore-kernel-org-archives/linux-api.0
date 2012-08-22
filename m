From: xiaoyan.zhang@intel.com
Subject: [PATCH v5 1/2] Documentation: sysfs for Physical Presence Interface
Date: Wed, 22 Aug 2012 18:47:21 +0800
Message-ID: <1345632442-1458-2-git-send-email-xiaoyan.zhang@intel.com>
References: <1345632442-1458-1-git-send-email-xiaoyan.zhang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1345632442-1458-1-git-send-email-xiaoyan.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: xiaoyan.zhang@intel.com, joseph.cihula@intel.com, gang.wei@intel.com, tpmdd-devel@lists.sourceforge.net, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com, m.selhorst@sirrix.com, shpedoikal@gmail.com, linux-security-module@vger.kernel.org, james.l.morris@oracle.com, hpa@zytor.com, linux-api@vger.kernel.org, yoder1@us.ibm.com, key@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org

From: Xiaoyan Zhang <xiaoyan.zhang@intel.com>


Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-ppi |   70 ++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ppi

diff --git a/Documentation/ABI/testing/sysfs-driver-ppi b/Documentation/ABI/testing/sysfs-driver-ppi
new file mode 100644
index 0000000..97a003e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-ppi
@@ -0,0 +1,70 @@
+What:		/sys/devices/pnp0/<bus-num>/ppi/
+Date:		August 2012
+Kernel Version:	3.6
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This folder includes the attributes related with PPI (Physical
+		Presence Interface). Only if TPM is supported by BIOS, this
+		folder makes sence. The folder path can be got by command
+		'find /sys/ -name 'pcrs''. For the detail information of PPI,
+		please refer to the PPI specification from
+		http://www.trustedcomputinggroup.org/
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/version
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the version of the PPI supported by the
+		platform.
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/request
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the request for an operation to be
+		executed in the pre-OS environment. It is the only input from
+		the OS to the pre-OS environment. The request should be an
+		integer value range from 1 to 160, and 0 means no request.
+		This file can be read and written.
+
+What:		/sys/devices/pnp0/00:<bus-num>/ppi/response
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the response to the most recent operation
+		request it acted upon. The format is "<request> <response num>
+		: <response description>".
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/transition_action
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows the platform-specific action that should
+		take place in order to transition to the BIOS for execution of
+		a requested operation. The format is "<action num>: <action
+		description>".
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/tcg_operations
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows whether it is allowed to request an
+		operation to be executed in the pre-OS environment by the BIOS
+		for the requests defined by TCG, i.e. requests from 1 to 22.
+		The format is "<request> <status num>: <status description>".
+		This attribute is only supported by PPI version 1.2+.
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/vs_operations
+Date:		August 2012
+Contact:	xiaoyan.zhang@intel.com
+Description:
+		This attribute shows whether it is allowed to request an
+		operation to be executed in the pre-OS environment by the BIOS
+		for the verdor specific requests, i.e. requests from 128 to
+		255. The format is same with tcg_operations. This attribute
+		is also only supported by PPI version 1.2+.
+		This file is readonly.
-- 
1.7.7.6
