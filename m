From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v6 29/29] MAINTAINERS: add entry for FPGA DFL drivers
Date: Tue, 12 Jun 2018 18:10:43 +0800
Message-ID: <1528798243-2029-30-git-send-email-hao.wu@intel.com>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

Add entry for FPGA Device Feature List (DFL) drivers.

Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 448957c..98fc5ea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5619,6 +5619,14 @@ F:	drivers/fpga/
 F:	include/linux/fpga/
 W:	http://www.rocketboards.org
 
+FPGA DFL DRIVERS
+M:	Wu Hao <hao.wu@intel.com>
+L:	linux-fpga@vger.kernel.org
+S:	Maintained
+F:	Documentation/fpga/dfl.txt
+F:	include/uapi/linux/fpga-dfl.h
+F:	drivers/fpga/dfl*
+
 FPU EMULATOR
 M:	Bill Metzenthen <billm@melbpc.org.au>
 W:	http://floatingpoint.sourceforge.net/emulator/index.html
-- 
1.8.3.1
