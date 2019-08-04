From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 08/12] fpga: dfl: make uinit callback optional
Date: Sun,  4 Aug 2019 18:20:18 +0800
Message-ID: <1564914022-3710-9-git-send-email-hao.wu@intel.com>
References: <1564914022-3710-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1564914022-3710-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, mdf@kernel.org, linux-fpga@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org, Wu Hao <hao.wu@intel.com>
List-Id: linux-api@vger.kernel.org

This patch makes uinit callback of sub features optional. With
this change, people don't need to prepare any empty uinit callback.

Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 drivers/fpga/dfl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index 87eaef6..c0512af 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -259,7 +259,8 @@ void dfl_fpga_dev_feature_uinit(struct platform_device *pdev)
 
 	dfl_fpga_dev_for_each_feature(pdata, feature)
 		if (feature->ops) {
-			feature->ops->uinit(pdev, feature);
+			if (feature->ops->uinit)
+				feature->ops->uinit(pdev, feature);
 			feature->ops = NULL;
 		}
 }
-- 
1.8.3.1
