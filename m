From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not depend on request's comp_mask
Date: Thu, 29 Jan 2015 18:59:58 +0100
Message-ID: <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

As specified in "Extending Verbs API" presentation [1] by Tzahi Oved
during OFA International Developer Workshop 2013, the request's
comp_mask should describe the request data: it's describe the
availability of extended fields in the request.
Conversely, the response's comp_mask should describe the presence
of extended fields in the response.

So this patch changes ib_uverbs_ex_query_device() function to always
return the maximum supported features, currently only
IB_USER_VERBS_EX_QUERY_DEVICE_ODP per commit 860f10a799c8 ("IB/core:
Add flags for on demand paging support"), regardless of the value of
request's comp_mask.

[1] https://www.openfabrics.org/images/docs/2013_Dev_Workshop/Tues_0423/2013_Workshop_Tues_0830_Tzahi_Oved-verbs_extensions_ofa_2013-tzahio.pdf

Link: http://mid.gmane.org/cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 532d8eba8b02..6ef06a9b4362 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3324,17 +3324,15 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	resp.comp_mask = 0;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
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
+	resp.odp_caps.general_caps = attr.odp_caps.general_caps;
+	resp.odp_caps.per_transport_caps.rc_odp_caps =
+		attr.odp_caps.per_transport_caps.rc_odp_caps;
+	resp.odp_caps.per_transport_caps.uc_odp_caps =
+		attr.odp_caps.per_transport_caps.uc_odp_caps;
+	resp.odp_caps.per_transport_caps.ud_odp_caps =
+		attr.odp_caps.per_transport_caps.ud_odp_caps;
 #endif
+	resp.comp_mask |= IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
 
 	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
 	if (err)
-- 
2.1.0
