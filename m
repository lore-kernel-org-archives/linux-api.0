From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 01/13] IB/core: Add a generic way to execute an operation on a uobject
Date: Thu,  3 Aug 2017 16:06:55 +0300
Message-ID: <1501765627-104860-2-git-send-email-matanb@mellanox.com>
References: <1501765627-104860-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501765627-104860-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The ioctl infrastructure treats all user-objects in the same manner.
It gets objects ids from the user-space and by using the object type
and type attributes mentioned in the object specification, it executes
this required method. Passing an object id from the user-space as
an attribute is carried out in three stages. The first is carried out
before the actual handler and the last is carried out afterwards.

The different supported operations are read, write, destroy and create.
In the first stage, the former three actions just fetches the object
from the repository (by using its id) and locks it. The last action
allocates a new uobject. Afterwards, the second stage is carried out
when the handler itself carries out the required modification of the
object. The last stage is carried out after the handler finishes and
commits the result. The former two operations just unlock the object.
Destroy calls the "free object" operation, taking into account the
object's type and releases the uobject as well. Creation just adds the
new uobject to the repository, making the object visible to the
application.

In order to abstract these details from the ioctl infrastructure
layer, we add uverbs_get_uobject_from_context and
uverbs_finalize_object functions which corresponds to the first
and last stages respectively.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c | 58 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/rdma_core.h | 17 +++++++++++
 include/rdma/uverbs_ioctl.h         | 52 +++++++++++++++++++++++++++++++++
 3 files changed, 127 insertions(+)
 create mode 100644 include/rdma/uverbs_ioctl.h

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 41c31a2..2bd58ff 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -35,6 +35,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/uverbs_types.h>
 #include <linux/rcupdate.h>
+#include <rdma/uverbs_ioctl.h>
 #include "uverbs.h"
 #include "core_priv.h"
 #include "rdma_core.h"
@@ -625,3 +626,60 @@ void uverbs_initialize_ucontext(struct ib_ucontext *ucontext)
 	.needs_kfree_rcu = false,
 };
 
+struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_obj_type *type_attrs,
+						   struct ib_ucontext *ucontext,
+						   enum uverbs_obj_access access,
+						   int id)
+{
+	switch (access) {
+	case UVERBS_ACCESS_READ:
+		return rdma_lookup_get_uobject(type_attrs, ucontext, id, false);
+	case UVERBS_ACCESS_DESTROY:
+	case UVERBS_ACCESS_WRITE:
+		return rdma_lookup_get_uobject(type_attrs, ucontext, id, true);
+	case UVERBS_ACCESS_NEW:
+		return rdma_alloc_begin_uobject(type_attrs, ucontext);
+	default:
+		WARN_ON(true);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+}
+
+int uverbs_finalize_object(struct ib_uobject *uobj,
+			   enum uverbs_obj_access access,
+			   bool commit)
+{
+	int ret = 0;
+
+	/*
+	 * refcounts should be handled at the object level and not at the
+	 * uobject level. Refcounts of the objects themselves are done in
+	 * handlers.
+	 */
+
+	switch (access) {
+	case UVERBS_ACCESS_READ:
+		rdma_lookup_put_uobject(uobj, false);
+		break;
+	case UVERBS_ACCESS_WRITE:
+		rdma_lookup_put_uobject(uobj, true);
+		break;
+	case UVERBS_ACCESS_DESTROY:
+		if (commit)
+			ret = rdma_remove_commit_uobject(uobj);
+		else
+			rdma_lookup_put_uobject(uobj, true);
+		break;
+	case UVERBS_ACCESS_NEW:
+		if (commit)
+			ret = rdma_alloc_commit_uobject(uobj);
+		else
+			rdma_alloc_abort_uobject(uobj);
+		break;
+	default:
+		WARN_ON(true);
+		ret = -EOPNOTSUPP;
+	}
+
+	return ret;
+}
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 1b82e7f..97483d1 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -39,6 +39,7 @@
 
 #include <linux/idr.h>
 #include <rdma/uverbs_types.h>
+#include <rdma/uverbs_ioctl.h>
 #include <rdma/ib_verbs.h>
 #include <linux/mutex.h>
 
@@ -75,4 +76,20 @@
  */
 void uverbs_close_fd(struct file *f);
 
+/*
+ * Get an ib_uobject that corresponds to the given id from ucontext, assuming
+ * the object is from the given type. Lock it to the required access when
+ * applicable.
+ * This function could create (access == NEW), destroy (access == DESTROY)
+ * or unlock (access == READ || access == WRITE) objects if required.
+ * The action will be finalized only when uverbs_finalize_object is called.
+ */
+struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_obj_type *type_attrs,
+						   struct ib_ucontext *ucontext,
+						   enum uverbs_obj_access access,
+						   int id);
+int uverbs_finalize_object(struct ib_uobject *uobj,
+			   enum uverbs_obj_access access,
+			   bool commit);
+
 #endif /* RDMA_CORE_H */
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
new file mode 100644
index 0000000..6885b92
--- /dev/null
+++ b/include/rdma/uverbs_ioctl.h
@@ -0,0 +1,52 @@
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
+#ifndef _UVERBS_IOCTL_
+#define _UVERBS_IOCTL_
+
+#include <rdma/uverbs_types.h>
+
+/*
+ * =======================================
+ *	Verbs action specifications
+ * =======================================
+ */
+
+enum uverbs_obj_access {
+	UVERBS_ACCESS_READ,
+	UVERBS_ACCESS_WRITE,
+	UVERBS_ACCESS_NEW,
+	UVERBS_ACCESS_DESTROY
+};
+
+#endif
+
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
