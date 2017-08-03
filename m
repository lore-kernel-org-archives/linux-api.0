From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 09/13] IB/core: Export ioctl enum types to user-space
Date: Thu,  3 Aug 2017 16:07:03 +0300
Message-ID: <1501765627-104860-10-git-send-email-matanb@mellanox.com>
References: <1501765627-104860-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501765627-104860-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add a new ib_user_ioctl_verbs.h which exports all required ABI
enums and structs to the user-space.
Export the default types to user-space through this file.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/uverbs_std_types.h         | 18 +----------
 include/uapi/rdma/ib_user_ioctl_verbs.h | 54 +++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 17 deletions(-)
 create mode 100644 include/uapi/rdma/ib_user_ioctl_verbs.h

diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index bef7409..400efe2 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -34,23 +34,7 @@
 #define _UVERBS_STD_TYPES__
 
 #include <rdma/uverbs_types.h>
-
-enum uverbs_default_objects {
-	UVERBS_OBJECT_DEVICE, /* No instances of DEVICE are allowed */
-	UVERBS_OBJECT_PD,
-	UVERBS_OBJECT_COMP_CHANNEL,
-	UVERBS_OBJECT_CQ,
-	UVERBS_OBJECT_QP,
-	UVERBS_OBJECT_SRQ,
-	UVERBS_OBJECT_AH,
-	UVERBS_OBJECT_MR,
-	UVERBS_OBJECT_MW,
-	UVERBS_OBJECT_FLOW,
-	UVERBS_OBJECT_XRCD,
-	UVERBS_OBJECT_RWQ_IND_TBL,
-	UVERBS_OBJECT_WQ,
-	UVERBS_OBJECT_LAST,
-};
+#include <rdma/ib_user_ioctl_verbs.h>
 
 extern const struct uverbs_object_def uverbs_object_comp_channel;
 extern const struct uverbs_object_def uverbs_object_cq;
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
new file mode 100644
index 0000000..78a2e5b
--- /dev/null
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (c) 2017, Mellanox Technologies inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef IB_USER_IOCTL_VERBS_H
+#define IB_USER_IOCTL_VERBS_H
+
+enum uverbs_default_objects {
+	UVERBS_OBJECT_DEVICE, /* No instances of DEVICE are allowed */
+	UVERBS_OBJECT_PD,
+	UVERBS_OBJECT_COMP_CHANNEL,
+	UVERBS_OBJECT_CQ,
+	UVERBS_OBJECT_QP,
+	UVERBS_OBJECT_SRQ,
+	UVERBS_OBJECT_AH,
+	UVERBS_OBJECT_MR,
+	UVERBS_OBJECT_MW,
+	UVERBS_OBJECT_FLOW,
+	UVERBS_OBJECT_XRCD,
+	UVERBS_OBJECT_RWQ_IND_TBL,
+	UVERBS_OBJECT_WQ,
+	UVERBS_OBJECT_LAST,
+};
+
+#endif
+
-- 
1.8.3.1
