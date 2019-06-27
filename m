From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 02/15] fpga: dfl: fme: remove copy_to_user() in ioctl for PR
Date: Thu, 27 Jun 2019 12:44:42 +0800
Message-ID: <1561610695-5414-3-git-send-email-hao.wu@intel.com>
References: <1561610695-5414-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1561610695-5414-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, yilun.xu@intel.com, hao.wu@intel.com, gregkh@linuxfoundation.org, atull@kernel.org
List-Id: linux-api@vger.kernel.org

This patch removes copy_to_user() code in partial reconfiguration
ioctl, as it's useless as user never needs to read the data
structure after ioctl.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Moritz Fischer <mdf@kernel.org>
Acked-by: Alan Tull <atull@kernel.org>
---
v2: clean up code split from patch 2 in v1 patchset.
v3: no change.
v4: no change.
---
 drivers/fpga/dfl-fme-pr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/fpga/dfl-fme-pr.c b/drivers/fpga/dfl-fme-pr.c
index d9ca955..6ec0f09 100644
--- a/drivers/fpga/dfl-fme-pr.c
+++ b/drivers/fpga/dfl-fme-pr.c
@@ -159,9 +159,6 @@ static int fme_pr(struct platform_device *pdev, unsigned long arg)
 	mutex_unlock(&pdata->lock);
 free_exit:
 	vfree(buf);
-	if (copy_to_user((void __user *)arg, &port_pr, minsz))
-		return -EFAULT;
-
 	return ret;
 }
 
-- 
1.8.3.1
