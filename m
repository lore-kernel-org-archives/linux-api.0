From: srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Subject: [PATCH 1/4] nvmem: core: return EFBIG on out-of-range write
Date: Mon, 11 Sep 2017 11:00:11 +0200
Message-ID: <20170911090014.16806-2-srinivas.kandagatla@linaro.org>
References: <20170911090014.16806-1-srinivas.kandagatla@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170911090014.16806-1-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Shapiro <guy.shapiro-2HKgp+mgmS5l57MIdRCFDg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Guy Shapiro <guy.shapiro-2HKgp+mgmS5l57MIdRCFDg@public.gmane.org>

When writing data that exceeds the nvmem size to a nvmem sysfs file
using the sh redirection operator >, the shell hangs, trying to
write the out-of-range bytes endlessly.

Fix the problem by returning EFBIG described in man 2 write.

Similar change was done for binary sysfs files on commit
0936896056365349afa867c16e9f9100a6707cbf

Signed-off-by: Guy Shapiro <guy.shapiro-2HKgp+mgmS5l57MIdRCFDg@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/nvmem/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index de54c7f..3866117 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -135,7 +135,7 @@ static ssize_t bin_attr_nvmem_write(struct file *filp, struct kobject *kobj,
 
 	/* Stop the user from writing */
 	if (pos >= nvmem->size)
-		return 0;
+		return -EFBIG;
 
 	if (count < nvmem->word_size)
 		return -EINVAL;
-- 
2.9.3
