From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 4/5] IB/uverbs: ex_query_device: no need to clear the whole structure
Date: Thu, 29 Jan 2015 19:00:01 +0100
Message-ID: <0b646f62e9272bc962a1ff6ff03ad9523b454dfe.1422553023.git.ydroneaud@opteya.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

As only the requested fields are set and copied to userspace,
there's no need to clear the content of the response structure
beforehand.

Link: http://mid.gmane.org/cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 81d8b5aa2eb6..9520880a163f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3328,9 +3328,9 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (err)
 		return err;
 
-	memset(&resp, 0, sizeof(resp));
 	copy_query_dev_fields(file, &resp.base, &attr);
 	resp.comp_mask = 0;
+	resp.reserved = 0;
 
 	if (ucore->outlen < resp_len + sizeof(resp.odp_caps))
 		goto end;
@@ -3343,6 +3343,9 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 		attr.odp_caps.per_transport_caps.uc_odp_caps;
 	resp.odp_caps.per_transport_caps.ud_odp_caps =
 		attr.odp_caps.per_transport_caps.ud_odp_caps;
+	resp.odp_caps.reserved = 0;
+#else
+	memset(&resp.odp_caps, 0, sizeof(resp.odp_caps));
 #endif
 	resp.comp_mask |= IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
 	resp_len += sizeof(resp.odp_caps);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
