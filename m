From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v7 22/29] fpga: dfl: fme-region: add support for compat_id
Date: Sat, 30 Jun 2018 08:53:29 +0800
Message-ID: <1530320016-24712-23-git-send-email-hao.wu@intel.com>
References: <1530320016-24712-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530320016-24712-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

This patch adds compat_id support, it reuses fme manager's
compat id, as the per region compat id is actually from the
fme manager's register.

Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
---
v5: reuse fme manager's compat_id as per region compat_id
v6: rebase, fix copyright time and add Acked-by from Alan.
v7: add Acked-by from Moritz.
---
 drivers/fpga/dfl-fme-region.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/fpga/dfl-fme-region.c b/drivers/fpga/dfl-fme-region.c
index a6e0bde..0b7e19c 100644
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
