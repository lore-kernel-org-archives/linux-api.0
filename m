From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 22/24] fpga: dfl: afu: add FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls support
Date: Tue, 13 Feb 2018 17:24:51 +0800
Message-ID: <1518513893-4719-23-git-send-email-hao.wu@intel.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

FPGA_GET_API_VERSION and FPGA_CHECK_EXTENSION ioctls are common ones which
need to be supported by all feature devices drivers including FME and AFU.
This patch implements above 2 ioctls in FPGA Accelerated Function Unit
(AFU) driver.

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
---
 drivers/fpga/dfl-afu-main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
index b2f8798..bead242 100644
--- a/drivers/fpga/dfl-afu-main.c
+++ b/drivers/fpga/dfl-afu-main.c
@@ -121,6 +121,13 @@ static int afu_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static long afu_ioctl_check_extension(struct feature_platform_data *pdata,
+				      unsigned long arg)
+{
+	/* No extension support for now */
+	return 0;
+}
+
 static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct platform_device *pdev = filp->private_data;
@@ -131,6 +138,10 @@ static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	dev_dbg(&pdev->dev, "%s cmd 0x%x\n", __func__, cmd);
 
 	switch (cmd) {
+	case FPGA_GET_API_VERSION:
+		return FPGA_API_VERSION;
+	case FPGA_CHECK_EXTENSION:
+		return afu_ioctl_check_extension(pdata, arg);
 	default:
 		/*
 		 * Let sub-feature's ioctl function to handle the cmd
-- 
2.7.4
