From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v5 22/28] fpga: dfl: fme-region: add support for compat_id
Date: Wed,  2 May 2018 10:50:25 +0800
Message-ID: <1525229431-3087-23-git-send-email-hao.wu@intel.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

This patch adds compat_id support, it reuses fme manager's
compat id, as the per region compat id is actually from the
fme manager's register.

Signed-off-by: Wu Hao <hao.wu@intel.com>
---
v5: reuse fme manager's compat_id as per region compat_id
---
 drivers/fpga/dfl-fme-region.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/fpga/dfl-fme-region.c b/drivers/fpga/dfl-fme-region.c
index 696b313..b82a381 100644
--- a/drivers/fpga/dfl-fme-region.c
+++ b/drivers/fpga/dfl-fme-region.c
@@ -45,6 +45,7 @@ static int fme_region_probe(struct platform_device *pdev)
 	}
 
 	region->priv = pdata;
+	region->compat_id = mgr->compat_id;
 	platform_set_drvdata(pdev, region);
 
 	ret = fpga_region_register(region);
-- 
1.8.3.1
