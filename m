From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 08/13] IB/core: Explicitly destroy an object while keeping uobject
Date: Thu,  3 Aug 2017 16:07:02 +0300
Message-ID: <1501765627-104860-9-git-send-email-matanb@mellanox.com>
References: <1501765627-104860-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501765627-104860-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

When some objects are destroyed, we need to extract their status at
destruction. After object's destruction, this status
(e.g. events_reported) relies in the uobject. In order to have the
latest and correct status, the underlying object should be destroyed,
but we should keep the uobject alive and read this information off the
uobject. We introduce a rdma_explicit_destroy function. This function
destroys the class type object (for example, the IDR class type which
destroys the underlying object as well) and then convert the uobject
to be of a null class type. This uobject will then be destroyed as any
other uobject once uverbs_finalize_object[s] is called.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c | 35 +++++++++++++++++++++++++++++++++++
 include/rdma/uverbs_types.h         |  1 +
 2 files changed, 36 insertions(+)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 2a2f002..85b5ee4 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -451,6 +451,41 @@ int __must_check rdma_remove_commit_uobject(struct ib_uobject *uobj)
 	return ret;
 }
 
+static int null_obj_type_class_remove_commit(struct ib_uobject *uobj,
+					     enum rdma_remove_reason why)
+{
+	return 0;
+}
+
+static const struct uverbs_obj_type null_obj_type = {
+	.type_class = &((const struct uverbs_obj_type_class){
+			.remove_commit = null_obj_type_class_remove_commit,
+			/* be cautious */
+			.needs_kfree_rcu = true}),
+};
+
+int rdma_explicit_destroy(struct ib_uobject *uobject)
+{
+	int ret;
+	struct ib_ucontext *ucontext = uobject->context;
+
+	/* Cleanup is running. Calling this should have been impossible */
+	if (!down_read_trylock(&ucontext->cleanup_rwsem)) {
+		WARN(true, "ib_uverbs: Cleanup is running while removing an uobject\n");
+		return 0;
+	}
+	lockdep_check(uobject, true);
+	ret = uobject->type->type_class->remove_commit(uobject,
+						       RDMA_REMOVE_DESTROY);
+	if (ret)
+		return ret;
+
+	uobject->type = &null_obj_type;
+
+	up_read(&ucontext->cleanup_rwsem);
+	return 0;
+}
+
 static void alloc_commit_idr_uobject(struct ib_uobject *uobj)
 {
 	uverbs_uobject_add(uobj);
diff --git a/include/rdma/uverbs_types.h b/include/rdma/uverbs_types.h
index 9760b6d..cc04ec6 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -129,6 +129,7 @@ struct ib_uobject *rdma_alloc_begin_uobject(const struct uverbs_obj_type *type,
 void rdma_alloc_abort_uobject(struct ib_uobject *uobj);
 int __must_check rdma_remove_commit_uobject(struct ib_uobject *uobj);
 int rdma_alloc_commit_uobject(struct ib_uobject *uobj);
+int rdma_explicit_destroy(struct ib_uobject *uobject);
 
 struct uverbs_obj_fd_type {
 	/*
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
