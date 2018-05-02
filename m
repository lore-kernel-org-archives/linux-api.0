From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v5 26/28] fpga: dfl: afu: add DFL_FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls support
Date: Wed,  2 May 2018 10:50:29 +0800
Message-ID: <1525229431-3087-27-git-send-email-hao.wu@intel.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

DFL_FPGA_GET_API_VERSION and DFL_FPGA_CHECK_EXTENSION ioctls are common
ones which need to be supported by all feature devices drivers including
FME and AFU. This patch implements above 2 ioctls in FPGA Accelerated
Function Unit (AFU) driver.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
---
v2: rebased
v3: rebased as driver renamed to fpga-dfl-afu
    fix one checkpatch issue
v4: add Acked-by from Alan and Moritz.
v5: rebase, and add DFL_ prefix to APIs.
---
 drivers/fpga/dfl-afu-main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
index 6f846b7..57bb726 100644
--- a/drivers/fpga/dfl-afu-main.c
+++ b/drivers/fpga/dfl-afu-main.c
@@ -236,6 +236,13 @@ static int afu_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static long afu_ioctl_check_extension(struct dfl_feature_platform_data *pdata,
+				      unsigned long arg)
+{
+	/* No extension support for now */
+	return 0;
+}
+
 static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct platform_device *pdev = filp->private_data;
@@ -248,6 +255,10 @@ static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	pdata = dev_get_platdata(&pdev->dev);
 
 	switch (cmd) {
+	case DFL_FPGA_GET_API_VERSION:
+		return DFL_FPGA_API_VERSION;
+	case DFL_FPGA_CHECK_EXTENSION:
+		return afu_ioctl_check_extension(pdata, arg);
 	default:
 		/*
 		 * Let sub-feature's ioctl function to handle the cmd
-- 
1.8.3.1
