From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Drivers: hv: util: make struct hv_do_fcopy match Hyper-V host messages
Date: Fri, 24 Oct 2014 12:20:27 +0200
Message-ID: <1414146027-1915-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

An attempt to fix fcopy on i586 (bc5a5b0 Drivers: hv: util: Properly pack the data
for file copy functionality) led to a regression on x86_64 (and actually didn't fix
i586 breakage). Fcopy messages from Hyper-V host come in the following format:

struct do_fcopy_hdr   |   36 bytes
0000                  |    4 bytes
offset                |    8 bytes
size                  |    4 bytes
data                  | 6144 bytes

On x86_64 struct hv_do_fcopy matched this format without ' __attribute__((packed))'
and on i586 adding ' __attribute__((packed))' to it doesn't change anything. Keep
the structure packed and add padding to match re reality. Tested both i586 and x86_64
on Hyper-V Server 2012 R2.

Signed-off-by: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/hyperv.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
index 0a8e6ba..bb1cb73 100644
--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -134,6 +134,7 @@ struct hv_start_fcopy {
 
 struct hv_do_fcopy {
 	struct hv_fcopy_hdr hdr;
+	__u32   pad;
 	__u64	offset;
 	__u32	size;
 	__u8	data[DATA_FRAGMENT];
-- 
1.9.3
