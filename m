From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 02/10] ima: use %pU to output UUID in printable format
Date: Tue,  5 Apr 2016 16:56:11 +0300
Message-ID: <1459864579-55988-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1459864579-55988-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459864579-55988-1-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Instead of open coded variant re-use extension what vsprintf.c provides us for
ages.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 security/integrity/ima/ima_policy.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index be09e2c..4b0c262 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -972,7 +972,7 @@ static void policy_func_show(struct seq_file *m, enum ima_hooks func)
 int ima_policy_show(struct seq_file *m, void *v)
 {
 	struct ima_rule_entry *entry = v;
-	int i = 0;
+	int i;
 	char tbuf[64] = {0,};
 
 	rcu_read_lock();
@@ -1012,17 +1012,7 @@ int ima_policy_show(struct seq_file *m, void *v)
 	}
 
 	if (entry->flags & IMA_FSUUID) {
-		seq_puts(m, "fsuuid=");
-		for (i = 0; i < ARRAY_SIZE(entry->fsuuid); ++i) {
-			switch (i) {
-			case 4:
-			case 6:
-			case 8:
-			case 10:
-				seq_puts(m, "-");
-			}
-			seq_printf(m, "%x", entry->fsuuid[i]);
-		}
+		seq_printf(m, "fsuuid=%pU", entry->fsuuid);
 		seq_puts(m, " ");
 	}
 
-- 
2.8.0.rc3
