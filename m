From: "Zhang, Xiaoyan" <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Documentation: sysfs for Physical Presence Interface
Date: Wed, 23 May 2012 03:35:07 +0000
Message-ID: <953B7F5DA8C0F44CBD2621D8763F4F6005F7C5@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org" <m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org>, "shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Cihula, Joseph" <joseph.cihula-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wei, Gang" <gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Xiaoyan Zhang <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-driver-ppi |   70 ++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ppi

diff --git a/Documentation/ABI/testing/sysfs-driver-ppi b/Documentation/ABI/testing/sysfs-driver-ppi
new file mode 100644
index 0000000..5da9acd
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-ppi
@@ -0,0 +1,70 @@
+What:		/sys/devices/pnp0/<bus-num>/ppi/
+Date:		May 2012
+Kernel Version:	3.4
+Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
+Description:
+		This folder includes the attributes related with PPI (Physical
+		Presence Interface). Only if TPM is supported by BIOS, this
+		folder makes sense. The folder path can be got by command
+		'find /sys/ -name 'pcrs''. For the detail information of PPI,
+		please refer to the PPI specification from
+		http://www.trustedcomputinggroup.org/
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/version
+Date:		May 2012
+Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
+Description:
+		This attribute shows the version of the PPI supported by the
+		platform.
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/request
+Date:		May 2012
+Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
+Description:
+		This attribute shows the request for an operation to be
+		executed in the pre-OS environment. It is the only input from
+		the OS to the pre-OS environment. The request should be an
+		integer value range from 1 to 160, and 0 means no request.
+		This file can be read and written.
+
+What:		/sys/devices/pnp0/00:<bus-num>/ppi/response
+Date:		May 2012
+Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
+Description:
+		This attribute shows the response to the most recent operation
+		request it acted upon. The format is "<request> <response num>
+		: <response description>".
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/transition_action
+Date:		May 2012
+Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
+Description:
+		This attribute shows the platform-specific action that should
+		take place in order to transition to the BIOS for execution of
+		a requested operation. The format is "<action num>: <action
+		description>".
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/tcg_operations
+Date:		May 2012
+Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
+Description:
+		This attribute shows whether it is allowed to request an
+		operation to be executed in the pre-OS environment by the BIOS
+		for the requests defined by TCG, i.e. requests from 1 to 22.
+		The format is "<request> <status num>: <status description>".
+		This attribute is only supported by PPI version 1.2+.
+		This file is readonly.
+
+What:		/sys/devices/pnp0/<bus-num>/ppi/vs_operations
+Date:		May 2012
+Contact:	xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
+Description:
+		This attribute shows whether it is allowed to request an
+		operation to be executed in the pre-OS environment by the BIOS
+		for the vendor specific requests, i.e. requests from 128 to
+		255. The format is same with tcg_operations. This attribute
+		is also only supported by PPI version 1.2+.
+		This file is readonly.
-- 
1.7.6.5
