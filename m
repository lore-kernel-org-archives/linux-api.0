From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 06/10] sysctl: drop away useless label
Date: Tue,  5 Apr 2016 16:56:15 +0300
Message-ID: <1459864579-55988-7-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1459864579-55988-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459864579-55988-1-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

We have no locking in bin_uuid(). Thus, we may remove the out label and use
return statements directly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 kernel/sysctl_binary.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 10a1d7d..055ad65 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1123,15 +1123,14 @@ static ssize_t bin_uuid(struct file *file,
 
 		result = kernel_read(file, 0, buf, sizeof(buf) - 1);
 		if (result < 0)
-			goto out;
+			return result;
 
 		buf[result] = '\0';
 
 		/* Convert the uuid to from a string to binary */
 		for (i = 0; i < 16; i++) {
-			result = -EIO;
 			if (!isxdigit(str[0]) || !isxdigit(str[1]))
-				goto out;
+				return -EIO;
 
 			uuid[i] = (hex_to_bin(str[0]) << 4) |
 					hex_to_bin(str[1]);
@@ -1143,15 +1142,12 @@ static ssize_t bin_uuid(struct file *file,
 		if (oldlen > 16)
 			oldlen = 16;
 
-		result = -EFAULT;
 		if (copy_to_user(oldval, uuid, oldlen))
-			goto out;
+			return -EFAULT;
 
 		copied = oldlen;
 	}
-	result = copied;
-out:
-	return result;
+	return copied;
 }
 
 static ssize_t bin_dn_node_address(struct file *file,
-- 
2.8.0.rc3
