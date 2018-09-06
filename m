From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/11] UAPI: ndctl: Remove use of PAGE_SIZE [ver #2]
Date: Thu, 06 Sep 2018 10:19:30 +0100
Message-ID: <153622557095.14298.10281337300003012767.stgit@warthog.procyon.org.uk>
References: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <153622549721.14298.8116794954073122489.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

The macro PAGE_SIZE isn't valid outside of the kernel, so it should not
appear in UAPI headers.

Furthermore, the actual machine page size could theoretically change from
an application's point of view if it's running in a container that gets
migrated to another machine (say 4K/ppc64 to 64K/ppc64).

Fixes: f2ba5a5baecf ("libnvdimm, namespace: make min namespace size 4K")
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
---

 include/linux/ndctl.h      |   22 ++++++++++++++++++++++
 include/uapi/linux/ndctl.h |    4 ----
 2 files changed, 22 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/ndctl.h

diff --git a/include/linux/ndctl.h b/include/linux/ndctl.h
new file mode 100644
index 000000000000..cd5a293ce3ae
--- /dev/null
+++ b/include/linux/ndctl.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2014-2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#ifndef _LINUX_NDCTL_H
+#define _LINUX_NDCTL_H
+
+#include <uapi/linux/ndctl.h>
+
+enum {
+	ND_MIN_NAMESPACE_SIZE = PAGE_SIZE,
+};
+
+#endif /* _LINUX_NDCTL_H */
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 2f2c43d633c5..f57c9e434d2d 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -202,10 +202,6 @@ enum nd_driver_flags {
 	ND_DRIVER_DAX_PMEM	  = 1 << ND_DEVICE_DAX_PMEM,
 };
 
-enum {
-	ND_MIN_NAMESPACE_SIZE = PAGE_SIZE,
-};
-
 enum ars_masks {
 	ARS_STATUS_MASK = 0x0000FFFF,
 	ARS_EXT_STATUS_SHIFT = 16,
