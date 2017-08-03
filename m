From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 05/13] IB/core: Add DEVICE object and root tree structure
Date: Thu,  3 Aug 2017 16:06:59 +0300
Message-ID: <1501765627-104860-6-git-send-email-matanb@mellanox.com>
References: <1501765627-104860-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501765627-104860-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This adds the DEVICE object. This object supports creating the context
that all objects are created from. Moreover, it supports executing
methods which are related to the device itself, such as QUERY_DEVICE.
This is a singleton object (per file instance).

All standard objects are put in the root structure. This root will later
on be used in drivers as the source for their whole parsing tree.
Later on, when new features are added, these drivers could mix this root
with other customized objects.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_std_types.c | 17 +++++++++++++++
 include/rdma/uverbs_ioctl.h                | 35 ++++++++++++++++++++++++++++++
 include/rdma/uverbs_std_types.h            | 18 +++++++++++++++
 3 files changed, 70 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index b75c7da..5f90978 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -257,3 +257,20 @@ static int uverbs_hot_unplug_completion_event_file(struct ib_uobject_file *uobj_
 DECLARE_UVERBS_OBJECT(uverbs_object_pd, UVERBS_OBJECT_PD,
 		      /* 2 is used in order to free the PD after MRs */
 		      &UVERBS_TYPE_ALLOC_IDR(2, uverbs_free_pd));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_device, UVERBS_OBJECT_DEVICE, NULL);
+
+DECLARE_UVERBS_OBJECT_TREE(uverbs_default_objects,
+			   &uverbs_object_device,
+			   &uverbs_object_pd,
+			   &uverbs_object_mr,
+			   &uverbs_object_comp_channel,
+			   &uverbs_object_cq,
+			   &uverbs_object_qp,
+			   &uverbs_object_ah,
+			   &uverbs_object_mw,
+			   &uverbs_object_srq,
+			   &uverbs_object_flow,
+			   &uverbs_object_wq,
+			   &uverbs_object_rwq_ind_table,
+			   &uverbs_object_xrcd);
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 9913008..2e89254 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -133,16 +133,51 @@ struct uverbs_root_spec {
  * =======================================
  */
 
+struct uverbs_attr_def {
+	u16                           id;
+	struct uverbs_attr_spec       attr;
+};
+
+struct uverbs_method_def {
+	u16                                  id;
+	/* Combination of bits from enum UVERBS_ACTION_FLAG_XXXX */
+	u32				     flags;
+	size_t				     num_attrs;
+	const struct uverbs_attr_def * const (*attrs)[];
+	int (*handler)(struct ib_device *ib_dev, struct ib_uverbs_file *ufile,
+		       struct uverbs_attr_bundle *ctx);
+};
+
 struct uverbs_object_def {
+	u16					 id;
 	const struct uverbs_obj_type	        *type_attrs;
+	size_t				         num_methods;
+	const struct uverbs_method_def * const (*methods)[];
+};
+
+struct uverbs_object_tree_def {
+	size_t					 num_objects;
+	const struct uverbs_object_def * const (*objects)[];
 };
 
 #define _UVERBS_OBJECT(_id, _type_attrs, ...)				\
 	((const struct uverbs_object_def) {				\
+	 .id = _id,							\
 	 .type_attrs = _type_attrs})
 #define DECLARE_UVERBS_OBJECT(_name, _id, _type_attrs, ...)		\
 	const struct uverbs_object_def _name =				\
 		_UVERBS_OBJECT(_id, _type_attrs, ##__VA_ARGS__)
+#define _UVERBS_TREE_OBJECTS_SZ(...)					\
+	(sizeof((const struct uverbs_object_def * const []){__VA_ARGS__}) / \
+	 sizeof(const struct uverbs_object_def *))
+#define _UVERBS_OBJECT_TREE(...)					\
+	((const struct uverbs_object_tree_def) {			\
+	 .num_objects = _UVERBS_TREE_OBJECTS_SZ(__VA_ARGS__),		\
+	 .objects = &(const struct uverbs_object_def * const []){__VA_ARGS__} })
+#define DECLARE_UVERBS_OBJECT_TREE(_name, ...)				\
+	const struct uverbs_object_tree_def _name =			\
+		_UVERBS_OBJECT_TREE(__VA_ARGS__)
+
 /* =================================================
  *              Parsing infrastructure
  * =================================================
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index eda271b..bef7409 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -35,6 +35,23 @@
 
 #include <rdma/uverbs_types.h>
 
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
 extern const struct uverbs_object_def uverbs_object_comp_channel;
 extern const struct uverbs_object_def uverbs_object_cq;
 extern const struct uverbs_object_def uverbs_object_qp;
@@ -47,6 +64,7 @@
 extern const struct uverbs_object_def uverbs_object_mw;
 extern const struct uverbs_object_def uverbs_object_pd;
 extern const struct uverbs_object_def uverbs_object_xrcd;
+extern const struct uverbs_object_def uverbs_object_device;
 
 static inline struct ib_uobject *__uobj_get(const struct uverbs_obj_type *type,
 					    bool write,
-- 
1.8.3.1
