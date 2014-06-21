From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH 1/5] i8k: Fix non-SMP operation
Date: Sat, 21 Jun 2014 08:08:08 -0700
Message-ID: <1403363304-22358-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Commit f36fdb9f0266 (i8k: Force SMM to run on CPU 0) adds support
for multi-core CPUs to the driver. Unfortunately, that causes it
to fail loading if compiled without SMP support, at least on
32 bit kernels. Kernel log shows "i8k: unable to get SMM Dell
signature", and function i8k_smm is found to return -EINVAL.

Testing revealed that the culprit is the missing return value check
of set_cpus_allowed_ptr.

Fixes: f36fdb9f0266 (i8k: Force SMM to run on CPU 0)
Reported-by: Jim Bos <jim876-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Tested-by: Jim Bos <jim876-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.14+
Signed-off-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
---
 drivers/char/i8k.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index d915707..93dcad0 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -138,7 +138,9 @@ static int i8k_smm(struct smm_regs *regs)
 	if (!alloc_cpumask_var(&old_mask, GFP_KERNEL))
 		return -ENOMEM;
 	cpumask_copy(old_mask, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current, cpumask_of(0));
+	rc = set_cpus_allowed_ptr(current, cpumask_of(0));
+	if (rc)
+		goto out;
 	if (smp_processor_id() != 0) {
 		rc = -EBUSY;
 		goto out;
-- 
1.9.1
