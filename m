From: Guy Shapiro <guy.shapiro@mobi-wize.com>
Subject: [PATCH] nvmem: core: return EFBIG on out-of-range write
Date: Tue, 29 Aug 2017 14:14:04 +0300
Message-ID: <1504005245-9878-1-git-send-email-guy.shapiro@mobi-wize.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: srinivas.kandagatla@linaro.org
Cc: vladimir_zapolskiy@mentor.com, linux-kernel@vger.kernel.org, Guy Shapiro <guy.shapiro@mobi-wize.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

When writing data that exceeds the nvmem size to a nvmem sysfs file
using the sh redirection operator >, the shell hangs, trying to
write the out-of-range bytes endlessly.

Fix the problem by returning EFBIG described in man 2 write.

Similar change was done for binary sysfs files on commit
0936896056365349afa867c16e9f9100a6707cbf

Signed-off-by: Guy Shapiro <guy.shapiro@mobi-wize.com>
Cc: linux-api@vger.kernel.org
---
 drivers/nvmem/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 4c49285..ae6cadd 100644
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
2.1.4
