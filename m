From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 3/5] IB/uverbs: ex_query_device: answer must depend on response buffer's size
Date: Thu, 29 Jan 2015 19:00:00 +0100
Message-ID: <a7b2b5adb3b207ec2a4330067a03ce7e4c2225aa.1422553023.git.ydroneaud@opteya.com>
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

So instead of silently truncating extended QUERY_DEVICE uverb's
response, see commit 5a77abf9a97a ("IB/core: Add support for
extended query device caps")), this patch makes function
ib_uverbs_ex_query_device() check the available space in the
response buffer against the minimal response structure and fail
with -ENOSPC if this base structure cannot be returned to
userspace: it's required to be able to return the comp_mask's
value, at least.

For extended features, currently only IB_USER_VERBS_EX_QUERY_DEVICE_ODP
per commit 860f10a799c8 ("IB/core: Add flags for on demand paging
support"), the extension's data is returned if the needed space
is available in the response buffer: it is expected that newer
userspace program pass a bigger response buffer so that it can
retrieve extended features. The comp_mask value will match the fields
that were effectively returned to userspace.

In the end:
- userspace won't get truncated responses;
- newer kernel would be able to support older binaries and
  older binaries will work flawlessly with newer kernel;
- additionally, newer binaries would even be able to support
  older kernel, as far as they don't set new feature bit in
  request's comp_mask.

Note: as offsetof() is used to retrieve the size of the lower chunk
of the response, beware that it only works if the upper chunk
is right after, without any implicit padding. And, as the size of
the latter chunk is added to the base size, implicit padding at the
end of the structure is not taken in account. Both point must be
taken in account when extending the uverbs functionalities.

[1] https://www.openfabrics.org/images/docs/2013_Dev_Workshop/Tues_0423/2013_Workshop_Tues_0830_Tzahi_Oved-verbs_extensions_ofa_2013-tzahio.pdf

Link: http://mid.gmane.org/cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index fbcc54b86795..81d8b5aa2eb6 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3302,6 +3302,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	struct ib_uverbs_ex_query_device  cmd;
 	struct ib_device_attr attr;
 	struct ib_device *device;
+	size_t resp_len;
 	int err;
 
 	device = file->device->ib_dev;
@@ -3318,6 +3319,11 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (cmd.reserved)
 		return -EINVAL;
 
+	resp_len = offsetof(typeof(resp), odp_caps);
+
+	if (ucore->outlen < resp_len)
+		return -ENOSPC;
+
 	err = device->query_device(device, &attr);
 	if (err)
 		return err;
@@ -3326,6 +3332,9 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	copy_query_dev_fields(file, &resp.base, &attr);
 	resp.comp_mask = 0;
 
+	if (ucore->outlen < resp_len + sizeof(resp.odp_caps))
+		goto end;
+
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	resp.odp_caps.general_caps = attr.odp_caps.general_caps;
 	resp.odp_caps.per_transport_caps.rc_odp_caps =
@@ -3336,8 +3345,10 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 		attr.odp_caps.per_transport_caps.ud_odp_caps;
 #endif
 	resp.comp_mask |= IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
+	resp_len += sizeof(resp.odp_caps);
 
-	err = ib_copy_to_udata(ucore, &resp, sizeof(resp));
+end:
+	err = ib_copy_to_udata(ucore, &resp, resp_len);
 	if (err)
 		return err;
 
-- 
2.1.0
