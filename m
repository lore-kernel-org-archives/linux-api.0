From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 04/13] IB/core: Declare an object instead of declaring only type attributes
Date: Thu,  3 Aug 2017 16:06:58 +0300
Message-ID: <1501765627-104860-5-git-send-email-matanb@mellanox.com>
References: <1501765627-104860-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501765627-104860-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Switch all uverbs_type_attrs_xxxx with DECLARE_UVERBS_OBJECT
macros. This will be later used in order to embed the object
specific methods in the objects as well.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_std_types.c | 112 +++++++++++++----------------
 include/rdma/uverbs_ioctl.h                |  16 +++++
 include/rdma/uverbs_std_types.h            |  40 +++++------
 include/rdma/uverbs_types.h                |  38 ++++++----
 4 files changed, 107 insertions(+), 99 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index ef29337..b75c7da 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -209,67 +209,51 @@ static int uverbs_hot_unplug_completion_event_file(struct ib_uobject_file *uobj_
 	return 0;
 };
 
-const struct uverbs_obj_fd_type uverbs_type_attrs_comp_channel = {
-	.type = UVERBS_TYPE_ALLOC_FD(sizeof(struct ib_uverbs_completion_event_file), 0),
-	.context_closed = uverbs_hot_unplug_completion_event_file,
-	.fops = &uverbs_event_fops,
-	.name = "[infinibandevent]",
-	.flags = O_RDONLY,
-};
-
-const struct uverbs_obj_idr_type uverbs_type_attrs_cq = {
-	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object), 0),
-	.destroy_object = uverbs_free_cq,
-};
-
-const struct uverbs_obj_idr_type uverbs_type_attrs_qp = {
-	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object), 0),
-	.destroy_object = uverbs_free_qp,
-};
-
-const struct uverbs_obj_idr_type uverbs_type_attrs_mw = {
-	.type = UVERBS_TYPE_ALLOC_IDR(0),
-	.destroy_object = uverbs_free_mw,
-};
-
-const struct uverbs_obj_idr_type uverbs_type_attrs_mr = {
-	/* 1 is used in order to free the MR after all the MWs */
-	.type = UVERBS_TYPE_ALLOC_IDR(1),
-	.destroy_object = uverbs_free_mr,
-};
-
-const struct uverbs_obj_idr_type uverbs_type_attrs_srq = {
-	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_usrq_object), 0),
-	.destroy_object = uverbs_free_srq,
-};
-
-const struct uverbs_obj_idr_type uverbs_type_attrs_ah = {
-	.type = UVERBS_TYPE_ALLOC_IDR(0),
-	.destroy_object = uverbs_free_ah,
-};
-
-const struct uverbs_obj_idr_type uverbs_type_attrs_flow = {
-	.type = UVERBS_TYPE_ALLOC_IDR(0),
-	.destroy_object = uverbs_free_flow,
-};
-
-const struct uverbs_obj_idr_type uverbs_type_attrs_wq = {
-	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uwq_object), 0),
-	.destroy_object = uverbs_free_wq,
-};
-
-const struct uverbs_obj_idr_type uverbs_type_attrs_rwq_ind_table = {
-	.type = UVERBS_TYPE_ALLOC_IDR(0),
-	.destroy_object = uverbs_free_rwq_ind_tbl,
-};
-
-const struct uverbs_obj_idr_type uverbs_type_attrs_xrcd = {
-	.type = UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uxrcd_object), 0),
-	.destroy_object = uverbs_free_xrcd,
-};
-
-const struct uverbs_obj_idr_type uverbs_type_attrs_pd = {
-	/* 2 is used in order to free the PD after MRs */
-	.type = UVERBS_TYPE_ALLOC_IDR(2),
-	.destroy_object = uverbs_free_pd,
-};
+DECLARE_UVERBS_OBJECT(uverbs_object_comp_channel,
+		      UVERBS_OBJECT_COMP_CHANNEL,
+		      &UVERBS_TYPE_ALLOC_FD(0,
+					      sizeof(struct ib_uverbs_completion_event_file),
+					      uverbs_hot_unplug_completion_event_file,
+					      &uverbs_event_fops,
+					      "[infinibandevent]", O_RDONLY));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_cq, UVERBS_OBJECT_CQ,
+		      &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object), 0,
+						  uverbs_free_cq));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_qp, UVERBS_OBJECT_QP,
+		      &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uqp_object), 0,
+						  uverbs_free_qp));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_mw, UVERBS_OBJECT_MW,
+		      &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_mw));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_mr, UVERBS_OBJECT_MR,
+		      /* 1 is used in order to free the MR after all the MWs */
+		      &UVERBS_TYPE_ALLOC_IDR(1, uverbs_free_mr));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_srq, UVERBS_OBJECT_SRQ,
+		      &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_usrq_object), 0,
+						  uverbs_free_srq));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_ah, UVERBS_OBJECT_AH,
+		      &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_ah));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_flow, UVERBS_OBJECT_FLOW,
+		      &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_flow));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_wq, UVERBS_OBJECT_WQ,
+		      &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uwq_object), 0,
+						  uverbs_free_wq));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_rwq_ind_table,
+		      UVERBS_OBJECT_RWQ_IND_TBL,
+		      &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_rwq_ind_tbl));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_xrcd, UVERBS_OBJECT_XRCD,
+		      &UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uxrcd_object), 0,
+						  uverbs_free_xrcd));
+
+DECLARE_UVERBS_OBJECT(uverbs_object_pd, UVERBS_OBJECT_PD,
+		      /* 2 is used in order to free the PD after MRs */
+		      &UVERBS_TYPE_ALLOC_IDR(2, uverbs_free_pd));
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index f83f563..9913008 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -127,6 +127,22 @@ struct uverbs_root_spec {
 	struct uverbs_object_spec_hash		*object_buckets[0];
 };
 
+/*
+ * =======================================
+ *	Verbs definitions
+ * =======================================
+ */
+
+struct uverbs_object_def {
+	const struct uverbs_obj_type	        *type_attrs;
+};
+
+#define _UVERBS_OBJECT(_id, _type_attrs, ...)				\
+	((const struct uverbs_object_def) {				\
+	 .type_attrs = _type_attrs})
+#define DECLARE_UVERBS_OBJECT(_name, _id, _type_attrs, ...)		\
+	const struct uverbs_object_def _name =				\
+		_UVERBS_OBJECT(_id, _type_attrs, ##__VA_ARGS__)
 /* =================================================
  *              Parsing infrastructure
  * =================================================
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index 7771ce9..eda271b 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -35,18 +35,18 @@
 
 #include <rdma/uverbs_types.h>
 
-extern const struct uverbs_obj_fd_type uverbs_type_attrs_comp_channel;
-extern const struct uverbs_obj_idr_type uverbs_type_attrs_cq;
-extern const struct uverbs_obj_idr_type uverbs_type_attrs_qp;
-extern const struct uverbs_obj_idr_type uverbs_type_attrs_rwq_ind_table;
-extern const struct uverbs_obj_idr_type uverbs_type_attrs_wq;
-extern const struct uverbs_obj_idr_type uverbs_type_attrs_srq;
-extern const struct uverbs_obj_idr_type uverbs_type_attrs_ah;
-extern const struct uverbs_obj_idr_type uverbs_type_attrs_flow;
-extern const struct uverbs_obj_idr_type uverbs_type_attrs_mr;
-extern const struct uverbs_obj_idr_type uverbs_type_attrs_mw;
-extern const struct uverbs_obj_idr_type uverbs_type_attrs_pd;
-extern const struct uverbs_obj_idr_type uverbs_type_attrs_xrcd;
+extern const struct uverbs_object_def uverbs_object_comp_channel;
+extern const struct uverbs_object_def uverbs_object_cq;
+extern const struct uverbs_object_def uverbs_object_qp;
+extern const struct uverbs_object_def uverbs_object_rwq_ind_table;
+extern const struct uverbs_object_def uverbs_object_wq;
+extern const struct uverbs_object_def uverbs_object_srq;
+extern const struct uverbs_object_def uverbs_object_ah;
+extern const struct uverbs_object_def uverbs_object_flow;
+extern const struct uverbs_object_def uverbs_object_mr;
+extern const struct uverbs_object_def uverbs_object_mw;
+extern const struct uverbs_object_def uverbs_object_pd;
+extern const struct uverbs_object_def uverbs_object_xrcd;
 
 static inline struct ib_uobject *__uobj_get(const struct uverbs_obj_type *type,
 					    bool write,
@@ -56,22 +56,22 @@ static inline struct ib_uobject *__uobj_get(const struct uverbs_obj_type *type,
 	return rdma_lookup_get_uobject(type, ucontext, id, write);
 }
 
-#define uobj_get_type(_type) uverbs_type_attrs_##_type.type
+#define uobj_get_type(_object) uverbs_object_##_object.type_attrs
 
 #define uobj_get_read(_type, _id, _ucontext)				\
-	 __uobj_get(&(_type), false, _ucontext, _id)
+	 __uobj_get(_type, false, _ucontext, _id)
 
-#define uobj_get_obj_read(_type, _id, _ucontext)			\
+#define uobj_get_obj_read(_object, _id, _ucontext)			\
 ({									\
-	struct ib_uobject *uobj =					\
-		__uobj_get(&uobj_get_type(_type),			\
+	struct ib_uobject *__uobj =					\
+		__uobj_get(uverbs_object_##_object.type_attrs,		\
 			   false, _ucontext, _id);			\
 									\
-	(struct ib_##_type *)(IS_ERR(uobj) ? NULL : uobj->object);	\
+	(struct ib_##_object *)(IS_ERR(__uobj) ? NULL : __uobj->object);\
 })
 
 #define uobj_get_write(_type, _id, _ucontext)				\
-	 __uobj_get(&(_type), true, _ucontext, _id)
+	 __uobj_get(_type, true, _ucontext, _id)
 
 static inline void uobj_put_read(struct ib_uobject *uobj)
 {
@@ -108,7 +108,7 @@ static inline struct ib_uobject *__uobj_alloc(const struct uverbs_obj_type *type
 }
 
 #define uobj_alloc(_type, ucontext)	\
-	__uobj_alloc(&(_type), ucontext)
+	__uobj_alloc(_type, ucontext)
 
 #endif
 
diff --git a/include/rdma/uverbs_types.h b/include/rdma/uverbs_types.h
index 351ea18..9760b6d 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -151,22 +151,30 @@ struct uverbs_obj_fd_type {
 
 #define UVERBS_BUILD_BUG_ON(cond) (sizeof(char[1 - 2 * !!(cond)]) -	\
 				   sizeof(char))
-#define UVERBS_TYPE_ALLOC_FD(_size, _order)				 \
-	{								 \
-		.destroy_order = _order,				 \
-		.type_class = &uverbs_fd_class,				 \
-		.obj_size = (_size) +					 \
-			  UVERBS_BUILD_BUG_ON((_size) <			 \
-					      sizeof(struct ib_uobject_file)),\
-	}
-#define UVERBS_TYPE_ALLOC_IDR_SZ(_size, _order)				\
-	{								\
+#define UVERBS_TYPE_ALLOC_FD(_order, _obj_size, _context_closed, _fops, _name, _flags)\
+	((&((const struct uverbs_obj_fd_type)				\
+	 {.type = {							\
+		.destroy_order = _order,				\
+		.type_class = &uverbs_fd_class,				\
+		.obj_size = (_obj_size) +				\
+			UVERBS_BUILD_BUG_ON((_obj_size) < sizeof(struct ib_uobject_file)), \
+	 },								\
+	 .context_closed = _context_closed,				\
+	 .fops = _fops,							\
+	 .name = _name,							\
+	 .flags = _flags}))->type)
+#define UVERBS_TYPE_ALLOC_IDR_SZ(_size, _order, _destroy_object)	\
+	((&((const struct uverbs_obj_idr_type)				\
+	 {.type = {							\
 		.destroy_order = _order,				\
 		.type_class = &uverbs_idr_class,			\
 		.obj_size = (_size) +					\
-			  UVERBS_BUILD_BUG_ON((_size) <			\
-					      sizeof(struct ib_uobject)), \
-	}
-#define UVERBS_TYPE_ALLOC_IDR(_order)					\
-	 UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uobject), _order)
+			UVERBS_BUILD_BUG_ON((_size) <			\
+					    sizeof(struct ib_uobject))	\
+	 },								\
+	 .destroy_object = _destroy_object,}))->type)
+#define UVERBS_TYPE_ALLOC_IDR(_order, _destroy_object)			\
+	 UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uobject), _order,	\
+				  _destroy_object)
+
 #endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
