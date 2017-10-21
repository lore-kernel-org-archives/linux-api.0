From: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
Subject: [PATCH] fs: Use CAP_DAC_OVERRIDE to allow for file dedupe
Date: Sat, 21 Oct 2017 15:28:06 +0200
Message-ID: <20171021132806.18086-1-nicolas@belouin.fr>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
Cc: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

In its current implementation the check is against CAP_SYS_ADMIN,
however this capability is bloated and inapropriate for this use.
Indeed the check aims to avoid dedupe against non writable files,
falling directly in the use case of CAP_DAC_OVERRIDE.

Signed-off-by: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
---
 fs/read_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index f0d4b16873e8..43cc7e84e29e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1965,7 +1965,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	u64 len;
 	int i;
 	int ret;
-	bool is_admin = capable(CAP_SYS_ADMIN);
+	bool is_admin = capable(CAP_SYS_ADMIN) || capable(CAP_DAC_OVERRIDE);
 	u16 count = same->dest_count;
 	struct file *dst_file;
 	loff_t dst_off;
-- 
2.14.2
