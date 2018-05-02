From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v5 02/28] fpga: mgr: add region_id to fpga_image_info
Date: Wed,  2 May 2018 10:50:05 +0800
Message-ID: <1525229431-3087-3-git-send-email-hao.wu@intel.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

This patch adds region_id to fpga_image_info data structure, it
allows driver to pass region id information to fpga-mgr via
fpga_image_info for fpga reconfiguration function.

Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Moritz Fischer <mdf@kernel.org>
Acked-by: Alan Tull <atull@kernel.org>
---
v3: add one line comment for region_id
v4: add Acked-by from Moritz and Alan.
---
 include/linux/fpga/fpga-mgr.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fpga/fpga-mgr.h b/include/linux/fpga/fpga-mgr.h
index 1266c11..eecfca5 100644
--- a/include/linux/fpga/fpga-mgr.h
+++ b/include/linux/fpga/fpga-mgr.h
@@ -88,6 +88,7 @@ enum fpga_mgr_states {
  * @sgt: scatter/gather table containing FPGA image
  * @buf: contiguous buffer containing FPGA image
  * @count: size of buf
+ * @region_id: id of target region
  * @dev: device that owns this
  * @overlay: Device Tree overlay
  */
@@ -100,6 +101,7 @@ struct fpga_image_info {
 	struct sg_table *sgt;
 	const char *buf;
 	size_t count;
+	int region_id;
 	struct device *dev;
 #ifdef CONFIG_OF
 	struct device_node *overlay;
-- 
1.8.3.1
