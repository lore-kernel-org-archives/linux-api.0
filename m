From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 12/13] IB/core: Assign root to all drivers
Date: Thu,  3 Aug 2017 16:07:06 +0300
Message-ID: <1501765627-104860-13-git-send-email-matanb@mellanox.com>
References: <1501765627-104860-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501765627-104860-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

In order to use the parsing tree, we need to assign the root
to all drivers. Currently, we just assign the default parsing
tree via ib_uverbs_add_one. The driver could override this by
assigning a parsing tree prior to registering the device.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_main.c | 18 ++++++++++++++++++
 include/rdma/uverbs_ioctl.h           | 12 ++++++++++++
 include/rdma/uverbs_std_types.h       | 14 ++++++++++++++
 4 files changed, 45 insertions(+)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 64d494a..0f6f768 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -100,6 +100,7 @@ struct ib_uverbs_device {
 	struct mutex				lists_mutex; /* protect lists */
 	struct list_head			uverbs_file_list;
 	struct list_head			uverbs_events_file_list;
+	struct uverbs_root_spec			*specs_root;
 };
 
 struct ib_uverbs_event_queue {
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 3d26096..0fcea1b 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -49,6 +49,7 @@
 #include <linux/uaccess.h>
 
 #include <rdma/ib.h>
+#include <rdma/uverbs_std_types.h>
 
 #include "uverbs.h"
 #include "core_priv.h"
@@ -1109,6 +1110,18 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	if (device_create_file(uverbs_dev->dev, &dev_attr_abi_version))
 		goto err_class;
 
+	if (!device->specs_root) {
+		const struct uverbs_object_tree_def *default_root[] = {
+			uverbs_default_get_objects()};
+
+		uverbs_dev->specs_root = uverbs_alloc_spec_tree(1,
+								default_root);
+		if (IS_ERR(uverbs_dev->specs_root))
+			goto err_class;
+
+		device->specs_root = uverbs_dev->specs_root;
+	}
+
 	ib_set_client_data(device, &uverbs_client, uverbs_dev);
 
 	return;
@@ -1240,6 +1253,11 @@ static void ib_uverbs_remove_one(struct ib_device *device, void *client_data)
 		ib_uverbs_comp_dev(uverbs_dev);
 	if (wait_clients)
 		wait_for_completion(&uverbs_dev->comp);
+	if (uverbs_dev->specs_root) {
+		uverbs_free_spec_tree(uverbs_dev->specs_root);
+		device->specs_root = NULL;
+	}
+
 	kobject_put(&uverbs_dev->kobj);
 }
 
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 759afa0..6da4407 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -419,8 +419,20 @@ static inline int _uverbs_copy_from(void *to, size_t to_size,
  * An object without any methods is considered invalid and will abort the
  * function with -ENOENT error.
  */
+#if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
 struct uverbs_root_spec *uverbs_alloc_spec_tree(unsigned int num_trees,
 						const struct uverbs_object_tree_def **trees);
 void uverbs_free_spec_tree(struct uverbs_root_spec *root);
+#else
+static inline struct uverbs_root_spec *uverbs_alloc_spec_tree(unsigned int num_trees,
+							      const struct uverbs_object_tree_def **trees)
+{
+	return NULL;
+}
+
+static inline void uverbs_free_spec_tree(struct uverbs_root_spec *root)
+{
+}
+#endif
 
 #endif
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index 400efe2..5f8e20b 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -34,8 +34,10 @@
 #define _UVERBS_STD_TYPES__
 
 #include <rdma/uverbs_types.h>
+#include <rdma/uverbs_ioctl.h>
 #include <rdma/ib_user_ioctl_verbs.h>
 
+#if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
 extern const struct uverbs_object_def uverbs_object_comp_channel;
 extern const struct uverbs_object_def uverbs_object_cq;
 extern const struct uverbs_object_def uverbs_object_qp;
@@ -50,6 +52,18 @@
 extern const struct uverbs_object_def uverbs_object_xrcd;
 extern const struct uverbs_object_def uverbs_object_device;
 
+extern const struct uverbs_object_tree_def uverbs_default_objects;
+static inline const struct uverbs_object_tree_def *uverbs_default_get_objects(void)
+{
+	return &uverbs_default_objects;
+}
+#else
+static inline const struct uverbs_object_tree_def *uverbs_default_get_objects(void)
+{
+	return NULL;
+}
+#endif
+
 static inline struct ib_uobject *__uobj_get(const struct uverbs_obj_type *type,
 					    bool write,
 					    struct ib_ucontext *ucontext,
-- 
1.8.3.1
