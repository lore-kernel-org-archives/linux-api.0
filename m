From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 10/13] IB/core: Add legacy driver's user-data
Date: Thu,  3 Aug 2017 16:07:04 +0300
Message-ID: <1501765627-104860-11-git-send-email-matanb@mellanox.com>
References: <1501765627-104860-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501765627-104860-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

In this phase, we don't want to change all the drivers to use
flexible driver's specific attributes. Therefore, we add two default
attributes: UHW_IN and UHW_OUT. These attributes are optional in some
methods and they encode the driver specific command data. We add
a function that extract this data and creates the legacy udata over
it.

Driver's data should start from UVERBS_UDATA_DRIVER_DATA_FLAG. This
turns on the first bit of the namespace, indicating this attribute
belongs to the driver's namespace.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_std_types.c | 40 ++++++++++++++++++++++++++
 include/rdma/uverbs_ioctl.h                | 46 ++++++++++++++++++++++++++++++
 include/uapi/rdma/ib_user_ioctl_verbs.h    | 10 +++++++
 3 files changed, 96 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index 5f90978..db66c18 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -209,6 +209,46 @@ static int uverbs_hot_unplug_completion_event_file(struct ib_uobject_file *uobj_
 	return 0;
 };
 
+/*
+ * This spec is used in order to pass information to the hardware driver in a
+ * legacy way. Every verb that could get driver specific data should get this
+ * spec.
+ */
+static const struct uverbs_attr_def uverbs_uhw_compat_in =
+	UVERBS_ATTR_PTR_IN_SZ(UVERBS_UHW_IN, 0, UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ));
+static const struct uverbs_attr_def uverbs_uhw_compat_out =
+	UVERBS_ATTR_PTR_OUT_SZ(UVERBS_UHW_OUT, 0, UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ));
+
+static void create_udata(struct uverbs_attr_bundle *ctx,
+			 struct ib_udata *udata)
+{
+	/*
+	 * This is for ease of conversion. The purpose is to convert all drivers
+	 * to use uverbs_attr_bundle instead of ib_udata.
+	 * Assume attr == 0 is input and attr == 1 is output.
+	 */
+	void __user *inbuf;
+	size_t inbuf_len = 0;
+	void __user *outbuf;
+	size_t outbuf_len = 0;
+	const struct uverbs_attr *uhw_in =
+		uverbs_attr_get(ctx, UVERBS_UHW_IN);
+	const struct uverbs_attr *uhw_out =
+		uverbs_attr_get(ctx, UVERBS_UHW_OUT);
+
+	if (!IS_ERR(uhw_in)) {
+		inbuf = uhw_in->ptr_attr.ptr;
+		inbuf_len = uhw_in->ptr_attr.len;
+	}
+
+	if (!IS_ERR(uhw_out)) {
+		outbuf = uhw_out->ptr_attr.ptr;
+		outbuf_len = uhw_out->ptr_attr.len;
+	}
+
+	INIT_UDATA_BUF_OR_NULL(udata, inbuf, outbuf, inbuf_len, outbuf_len);
+}
+
 DECLARE_UVERBS_OBJECT(uverbs_object_comp_channel,
 		      UVERBS_OBJECT_COMP_CHANNEL,
 		      &UVERBS_TYPE_ALLOC_FD(0,
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 9a8d217..759afa0 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -36,6 +36,7 @@
 #include <rdma/uverbs_types.h>
 #include <linux/uaccess.h>
 #include <rdma/rdma_user_ioctl.h>
+#include <rdma/ib_user_ioctl_verbs.h>
 
 /*
  * =======================================
@@ -338,6 +339,51 @@ static inline bool uverbs_attr_is_valid(const struct uverbs_attr_bundle *attrs_b
 					    idx & ~UVERBS_ID_NS_MASK);
 }
 
+static inline const struct uverbs_attr *uverbs_attr_get(const struct uverbs_attr_bundle *attrs_bundle,
+							u16 idx)
+{
+	u16 idx_bucket = idx >>	UVERBS_ID_NS_SHIFT;
+
+	if (!uverbs_attr_is_valid(attrs_bundle, idx))
+		return ERR_PTR(-ENOENT);
+
+	return &attrs_bundle->hash[idx_bucket].attrs[idx & ~UVERBS_ID_NS_MASK];
+}
+
+static inline int uverbs_copy_to(const struct uverbs_attr_bundle *attrs_bundle,
+				 size_t idx, const void *from)
+{
+	const struct uverbs_attr *attr = uverbs_attr_get(attrs_bundle, idx);
+	u16 flags;
+
+	if (IS_ERR(attr))
+		return PTR_ERR(attr);
+
+	flags = attr->ptr_attr.flags | UVERBS_ATTR_F_VALID_OUTPUT;
+	return (!copy_to_user(attr->ptr_attr.ptr, from, attr->ptr_attr.len) &&
+		!put_user(flags, &attr->uattr->flags)) ? 0 : -EFAULT;
+}
+
+static inline int _uverbs_copy_from(void *to, size_t to_size,
+				    const struct uverbs_attr_bundle *attrs_bundle,
+				    size_t idx)
+{
+	const struct uverbs_attr *attr = uverbs_attr_get(attrs_bundle, idx);
+
+	if (IS_ERR(attr))
+		return PTR_ERR(attr);
+
+	if (to_size <= sizeof(((struct ib_uverbs_attr *)0)->data))
+		memcpy(to, &attr->ptr_attr.data, attr->ptr_attr.len);
+	else if (copy_from_user(to, attr->ptr_attr.ptr, attr->ptr_attr.len))
+		return -EFAULT;
+
+	return 0;
+}
+
+#define uverbs_copy_from(to, attrs_bundle, idx)				      \
+	_uverbs_copy_from(to, sizeof(*(to)), attrs_bundle, idx)
+
 /* =================================================
  *	 Definitions -> Specs infrastructure
  * =================================================
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 78a2e5b..90f81ee 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -33,6 +33,11 @@
 #ifndef IB_USER_IOCTL_VERBS_H
 #define IB_USER_IOCTL_VERBS_H
 
+#include <rdma/rdma_user_ioctl.h>
+
+#define UVERBS_UDATA_DRIVER_DATA_NS	1
+#define UVERBS_UDATA_DRIVER_DATA_FLAG	(1UL << UVERBS_ID_NS_SHIFT)
+
 enum uverbs_default_objects {
 	UVERBS_OBJECT_DEVICE, /* No instances of DEVICE are allowed */
 	UVERBS_OBJECT_PD,
@@ -50,5 +55,10 @@ enum uverbs_default_objects {
 	UVERBS_OBJECT_LAST,
 };
 
+enum {
+	UVERBS_UHW_IN = UVERBS_UDATA_DRIVER_DATA_FLAG,
+	UVERBS_UHW_OUT,
+};
+
 #endif
 
-- 
1.8.3.1
