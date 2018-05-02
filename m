From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v5 04/28] fpga: mgr: add compat_id support
Date: Wed,  2 May 2018 10:50:07 +0800
Message-ID: <1525229431-3087-5-git-send-email-hao.wu@intel.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

This patch introduces compat_id support to fpga manager, it adds
a fpga_compat_id pointer to fpga manager data structure to allow
fpga manager drivers to save the compatibility id. This compat_id
could be used for compatibility checking before doing partial
reconfiguration to associated fpga regions.

Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 include/linux/fpga/fpga-mgr.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/fpga/fpga-mgr.h b/include/linux/fpga/fpga-mgr.h
index 802eac8..f163f22 100644
--- a/include/linux/fpga/fpga-mgr.h
+++ b/include/linux/fpga/fpga-mgr.h
@@ -147,11 +147,23 @@ struct fpga_manager_ops {
 #define FPGA_MGR_STATUS_FIFO_OVERFLOW_ERR	BIT(4)
 
 /**
+ * struct fpga_compat_id - id for compatibility check
+ *
+ * @id_h: high 64bit of the compat_id
+ * @id_l: low 64bit of the compat_id
+ */
+struct fpga_compat_id {
+	u64 id_h;
+	u64 id_l;
+};
+
+/**
  * struct fpga_manager - fpga manager structure
  * @name: name of low level fpga manager
  * @dev: fpga manager device
  * @ref_mutex: only allows one reference to fpga manager
  * @state: state of fpga manager
+ * @compat_id: FPGA manager id for compatibility check.
  * @mops: pointer to struct of fpga manager ops
  * @priv: low level driver private date
  */
@@ -160,6 +172,7 @@ struct fpga_manager {
 	struct device dev;
 	struct mutex ref_mutex;
 	enum fpga_mgr_states state;
+	struct fpga_compat_id *compat_id;
 	const struct fpga_manager_ops *mops;
 	void *priv;
 };
-- 
1.8.3.1
