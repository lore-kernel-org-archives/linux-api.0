From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Revert "IB/core: Add support for extended query device caps"
Date: Thu,  5 Feb 2015 22:10:18 +0100
Message-ID: <1423170618-12315-1-git-send-email-ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

While commit 7e36ef8205ff ("IB/core: Temporarily disable ex_query_device uverb")
is correct as it make the extended QUERY_DEVICE uverb as integrated as
part of commit 5a77abf9a97a ("IB/core: Add support for extended query device caps")
and commit 860f10a799c8 ("IB/core: Add flags for on demand paging support")
not available to userspace, it doesn't address the initial issue
regarding ib_copy_to_udata() [1][2].

Additionally, further discussions around this new uverb seems to
conclude it would require a different data structure than the one
currently described in <rdma/ib_user_verbs.h> [3].

Both of these issues require a revert of the changes,
so this patch partially revert commit 8cdd312cfed7 ("IB/mlx5: Implement the ODP capability query verb"),
commit 860f10a799c8 ("IB/core: Add flags for on demand paging support")
and fully revert commit 5a77abf9a97a ("IB/core: Add support for extended query device caps").

[1] "Re: [PATCH v3 06/17] IB/core: Add support for extended query device caps"
    http://mid.gmane.org/1418733236.2779.26.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[2] "Re: [PATCH] IB/core: Temporarily disable ex_query_device uverb"
    http://mid.gmane.org/1423067503.3030.83.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[3] "RE: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not depend on request's comp_mask"
    http://mid.gmane.org/2807E5FD2F6FDA4886F6618EAC48510E0CC12C30-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org

Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h     |   1 -
 drivers/infiniband/core/uverbs_cmd.c | 137 +++++++++++------------------------
 drivers/infiniband/hw/mlx5/main.c    |   2 -
 include/rdma/ib_verbs.h              |   5 +-
 include/uapi/rdma/ib_user_verbs.h    |  27 -------
 5 files changed, 42 insertions(+), 130 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b716b0815644..643c08a025a5 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -258,6 +258,5 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
 
 IB_UVERBS_DECLARE_EX_CMD(create_flow);
 IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
-IB_UVERBS_DECLARE_EX_CMD(query_device);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 532d8eba8b02..b7943ff16ed3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -400,52 +400,6 @@ err:
 	return ret;
 }
 
-static void copy_query_dev_fields(struct ib_uverbs_file *file,
-				  struct ib_uverbs_query_device_resp *resp,
-				  struct ib_device_attr *attr)
-{
-	resp->fw_ver		= attr->fw_ver;
-	resp->node_guid		= file->device->ib_dev->node_guid;
-	resp->sys_image_guid	= attr->sys_image_guid;
-	resp->max_mr_size	= attr->max_mr_size;
-	resp->page_size_cap	= attr->page_size_cap;
-	resp->vendor_id		= attr->vendor_id;
-	resp->vendor_part_id	= attr->vendor_part_id;
-	resp->hw_ver		= attr->hw_ver;
-	resp->max_qp		= attr->max_qp;
-	resp->max_qp_wr		= attr->max_qp_wr;
-	resp->device_cap_flags	= attr->device_cap_flags;
-	resp->max_sge		= attr->max_sge;
-	resp->max_sge_rd	= attr->max_sge_rd;
-	resp->max_cq		= attr->max_cq;
-	resp->max_cqe		= attr->max_cqe;
-	resp->max_mr		= attr->max_mr;
-	resp->max_pd		= attr->max_pd;
-	resp->max_qp_rd_atom	= attr->max_qp_rd_atom;
-	resp->max_ee_rd_atom	= attr->max_ee_rd_atom;
-	resp->max_res_rd_atom	= attr->max_res_rd_atom;
-	resp->max_qp_init_rd_atom	= attr->max_qp_init_rd_atom;
-	resp->max_ee_init_rd_atom	= attr->max_ee_init_rd_atom;
-	resp->atomic_cap		= attr->atomic_cap;
-	resp->max_ee			= attr->max_ee;
-	resp->max_rdd			= attr->max_rdd;
-	resp->max_mw			= attr->max_mw;
-	resp->max_raw_ipv6_qp		= attr->max_raw_ipv6_qp;
-	resp->max_raw_ethy_qp		= attr->max_raw_ethy_qp;
-	resp->max_mcast_grp		= attr->max_mcast_grp;
-	resp->max_mcast_qp_attach	= attr->max_mcast_qp_attach;
-	resp->max_total_mcast_qp_attach	= attr->max_total_mcast_qp_attach;
-	resp->max_ah			= attr->max_ah;
-	resp->max_fmr			= attr->max_fmr;
-	resp->max_map_per_fmr		= attr->max_map_per_fmr;
-	resp->max_srq			= attr->max_srq;
-	resp->max_srq_wr		= attr->max_srq_wr;
-	resp->max_srq_sge		= attr->max_srq_sge;
-	resp->max_pkeys			= attr->max_pkeys;
-	resp->local_ca_ack_delay	= attr->local_ca_ack_delay;
-	resp->phys_port_cnt		= file->device->ib_dev->phys_port_cnt;
-}
-
 ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 			       const char __user *buf,
 			       int in_len, int out_len)
@@ -466,7 +420,47 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
 		return ret;
 
 	memset(&resp, 0, sizeof resp);
-	copy_query_dev_fields(file, &resp, &attr);
+
+	resp.fw_ver 		       = attr.fw_ver;
+	resp.node_guid 		       = file->device->ib_dev->node_guid;
+	resp.sys_image_guid 	       = attr.sys_image_guid;
+	resp.max_mr_size 	       = attr.max_mr_size;
+	resp.page_size_cap 	       = attr.page_size_cap;
+	resp.vendor_id 		       = attr.vendor_id;
+	resp.vendor_part_id 	       = attr.vendor_part_id;
+	resp.hw_ver 		       = attr.hw_ver;
+	resp.max_qp 		       = attr.max_qp;
+	resp.max_qp_wr 		       = attr.max_qp_wr;
+	resp.device_cap_flags 	       = attr.device_cap_flags;
+	resp.max_sge 		       = attr.max_sge;
+	resp.max_sge_rd 	       = attr.max_sge_rd;
+	resp.max_cq 		       = attr.max_cq;
+	resp.max_cqe 		       = attr.max_cqe;
+	resp.max_mr 		       = attr.max_mr;
+	resp.max_pd 		       = attr.max_pd;
+	resp.max_qp_rd_atom 	       = attr.max_qp_rd_atom;
+	resp.max_ee_rd_atom 	       = attr.max_ee_rd_atom;
+	resp.max_res_rd_atom 	       = attr.max_res_rd_atom;
+	resp.max_qp_init_rd_atom       = attr.max_qp_init_rd_atom;
+	resp.max_ee_init_rd_atom       = attr.max_ee_init_rd_atom;
+	resp.atomic_cap 	       = attr.atomic_cap;
+	resp.max_ee 		       = attr.max_ee;
+	resp.max_rdd 		       = attr.max_rdd;
+	resp.max_mw 		       = attr.max_mw;
+	resp.max_raw_ipv6_qp 	       = attr.max_raw_ipv6_qp;
+	resp.max_raw_ethy_qp 	       = attr.max_raw_ethy_qp;
+	resp.max_mcast_grp 	       = attr.max_mcast_grp;
+	resp.max_mcast_qp_attach       = attr.max_mcast_qp_attach;
+	resp.max_total_mcast_qp_attach = attr.max_total_mcast_qp_attach;
+	resp.max_ah 		       = attr.max_ah;
+	resp.max_fmr 		       = attr.max_fmr;
+	resp.max_map_per_fmr 	       = attr.max_map_per_fmr;
+	resp.max_srq 		       = attr.max_srq;
+	resp.max_srq_wr 	       = attr.max_srq_wr;
+	resp.max_srq_sge 	       = attr.max_srq_sge;
+	resp.max_pkeys 		       = attr.max_pkeys;
+	resp.local_ca_ack_delay        = attr.local_ca_ack_delay;
+	resp.phys_port_cnt	       = file->device->ib_dev->phys_port_cnt;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
@@ -3293,52 +3287,3 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 
 	return ret ? ret : in_len;
 }
-
-int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
-			      struct ib_udata *ucore,
-			      struct ib_udata *uhw)
-{
-	struct ib_uverbs_ex_query_device_resp resp;
-	struct ib_uverbs_ex_query_device  cmd;
-	struct ib_device_attr attr;
-	struct ib_device *device;
-	int err;
-
-	device = file->device->ib_dev;
-	if (ucore->inlen < sizeof(cmd))
-		return -EINVAL;
-
-	err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
-	if (err)
-		return err;
-
-	if (cmd.reserved)
-		return -EINVAL;
-
-	err = device->query_device(device, &attr);
-	if (err)
-		return err;
-
-	memset(&resp, 0, sizeof(resp));
-	copy_query_dev_fields(file, &resp.base, &attr);
-	resp.comp_mask = 0;
-
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	if (cmd.comp_mask & IB_USER_VERBS_EX_QUERY_DEVICE_ODP) {
-		resp.odp_caps.general_caps = attr.odp_caps.general_caps;
-		resp.odp_caps.per_transport_caps.rc_odp_caps =
-			attr.odp_caps.per_transport_caps.rc_odp_caps;
-		resp.odp_caps.per_transport_caps.uc_odp_caps =
-			attr.odp_caps.per_transport_caps.uc_odp_caps;
-		resp.odp_caps.per_transport_caps.ud_odp_caps =
-			attr.odp_caps.per_transport_caps.ud_odp_caps;
-		resp.comp_mask |= IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
-	}
-#endif
-
-	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
-	if (err)
-		return err;
-
-	return 0;
-}
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8a87404e9c76..03bf81211a54 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1331,8 +1331,6 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)		|
 		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
-	dev->ib_dev.uverbs_ex_cmd_mask =
-		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE);
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0d74f1de99aa..65994a19e840 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1707,10 +1707,7 @@ static inline int ib_copy_from_udata(void *dest, struct ib_udata *udata, size_t
 
 static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len)
 {
-	size_t copy_sz;
-
-	copy_sz = min_t(size_t, len, udata->outlen);
-	return copy_to_user(udata->outbuf, src, copy_sz) ? -EFAULT : 0;
+	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
 }
 
 /**
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 4275b961bf60..867cc5084afb 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -90,7 +90,6 @@ enum {
 };
 
 enum {
-	IB_USER_VERBS_EX_CMD_QUERY_DEVICE = IB_USER_VERBS_CMD_QUERY_DEVICE,
 	IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
 	IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
 };
@@ -202,32 +201,6 @@ struct ib_uverbs_query_device_resp {
 	__u8  reserved[4];
 };
 
-enum {
-	IB_USER_VERBS_EX_QUERY_DEVICE_ODP =		1ULL << 0,
-};
-
-struct ib_uverbs_ex_query_device {
-	__u32 comp_mask;
-	__u32 reserved;
-};
-
-struct ib_uverbs_odp_caps {
-	__u64 general_caps;
-	struct {
-		__u32 rc_odp_caps;
-		__u32 uc_odp_caps;
-		__u32 ud_odp_caps;
-	} per_transport_caps;
-	__u32 reserved;
-};
-
-struct ib_uverbs_ex_query_device_resp {
-	struct ib_uverbs_query_device_resp base;
-	__u32 comp_mask;
-	__u32 reserved;
-	struct ib_uverbs_odp_caps odp_caps;
-};
-
 struct ib_uverbs_query_port {
 	__u64 response;
 	__u8  port_num;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
