From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 09/24] fpga: dfl-pci: add enumeration for feature devices
Date: Tue, 13 Feb 2018 17:24:38 +0800
Message-ID: <1518513893-4719-10-git-send-email-hao.wu@intel.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518513893-4719-1-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The Device Feature List (DFL) is implemented in MMIO, and features
are linked via the DFLs. This patch enables pcie driver to prepare
enumeration information (e.g locations of all device feature lists
in MMIO) and use common APIs provided by the Device Feature List
framework to enumerate each feature device linked.

Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v3: split from another patch
    use common functions from DFL framework for enumeration.
v4: rebase
---
 drivers/fpga/dfl-pci.c | 199 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 197 insertions(+), 2 deletions(-)

diff --git a/drivers/fpga/dfl-pci.c b/drivers/fpga/dfl-pci.c
index d91ea42..8ce8a94 100644
--- a/drivers/fpga/dfl-pci.c
+++ b/drivers/fpga/dfl-pci.c
@@ -22,9 +22,52 @@
 #include <linux/errno.h>
 #include <linux/aer.h>
 
+#include "dfl.h"
+
 #define DRV_VERSION	"0.8"
 #define DRV_NAME	"dfl-pci"
 
+struct cci_drvdata {
+	struct fpga_cdev *cdev;	/* container device */
+	struct list_head regions; /* list of pci bar mapping region */
+};
+
+/* pci bar mapping info */
+struct cci_region {
+	int bar;
+	void __iomem *ioaddr;	/* pointer to mapped bar region */
+	struct list_head node;
+};
+
+static void __iomem *cci_pci_ioremap_bar(struct pci_dev *pcidev, int bar)
+{
+	struct cci_drvdata *drvdata = pci_get_drvdata(pcidev);
+	struct cci_region *region;
+
+	list_for_each_entry(region, &drvdata->regions, node)
+		if (region->bar == bar) {
+			dev_dbg(&pcidev->dev, "BAR %d region exists\n", bar);
+			return region->ioaddr;
+		}
+
+	region = devm_kzalloc(&pcidev->dev, sizeof(*region), GFP_KERNEL);
+	if (!region)
+		return NULL;
+
+	region->bar = bar;
+	region->ioaddr = pci_ioremap_bar(pcidev, bar);
+	if (!region->ioaddr) {
+		dev_err(&pcidev->dev, "can't ioremap memory from BAR %d.\n",
+			bar);
+		devm_kfree(&pcidev->dev, region);
+		return NULL;
+	}
+
+	list_add(&region->node, &drvdata->regions);
+
+	return region->ioaddr;
+}
+
 /* PCI Device ID */
 #define PCIE_DEVICE_ID_PF_INT_5_X	0xBCBD
 #define PCIE_DEVICE_ID_PF_INT_6_X	0xBCC0
@@ -45,6 +88,143 @@ static struct pci_device_id cci_pcie_id_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, cci_pcie_id_tbl);
 
+static int cci_init_drvdata(struct pci_dev *pcidev)
+{
+	struct cci_drvdata *drvdata;
+
+	drvdata = devm_kzalloc(&pcidev->dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&drvdata->regions);
+
+	pci_set_drvdata(pcidev, drvdata);
+
+	return 0;
+}
+
+static void cci_pci_release_regions(struct pci_dev *pcidev)
+{
+	struct cci_drvdata *drvdata = pci_get_drvdata(pcidev);
+	struct cci_region *tmp, *region;
+
+	list_for_each_entry_safe(region, tmp, &drvdata->regions, node) {
+		list_del(&region->node);
+		if (region->ioaddr)
+			pci_iounmap(pcidev, region->ioaddr);
+		devm_kfree(&pcidev->dev, region);
+	}
+}
+
+static void cci_remove_drvdata(struct pci_dev *pcidev)
+{
+	struct cci_drvdata *drvdata = pci_get_drvdata(pcidev);
+
+	cci_pci_release_regions(pcidev);
+	pci_set_drvdata(pcidev, NULL);
+	devm_kfree(&pcidev->dev, drvdata);
+}
+
+static void cci_remove_feature_devs(struct pci_dev *pcidev)
+{
+	struct cci_drvdata *drvdata = pci_get_drvdata(pcidev);
+
+	/* remove all children feature devices */
+	fpga_remove_feature_devs(drvdata->cdev);
+}
+
+/* enumerate feature devices under pci device */
+static int cci_enumerate_feature_devs(struct pci_dev *pcidev)
+{
+	struct cci_drvdata *drvdata = pci_get_drvdata(pcidev);
+	struct fpga_cdev *cdev;
+	struct fpga_enum_info *info;
+	resource_size_t start, len;
+	void __iomem *base;
+	int port_num, bar, i, ret = 0;
+	u32 offset;
+	u64 v;
+
+	/* allocate enumeration info via pci_dev */
+	info = fpga_enum_info_alloc(&pcidev->dev);
+	if (!info)
+		return -ENOMEM;
+
+	/* start to find Device Feature List from Bar 0 */
+	base = cci_pci_ioremap_bar(pcidev, 0);
+	if (!base) {
+		ret = -ENOMEM;
+		goto enum_info_free_exit;
+	}
+
+	/*
+	 * PF device has FME and Ports/AFUs, and VF device only has 1 Port/AFU.
+	 * check them and add related "Device Feature List" info for the next
+	 * step enumeration.
+	 */
+	if (feature_is_fme(base)) {
+		start = pci_resource_start(pcidev, 0);
+		len = pci_resource_len(pcidev, 0);
+
+		fpga_enum_info_add_dfl(info, start, len, base);
+
+		/*
+		 * find more Device Feature Lists (e.g Ports) per information
+		 * indicated by FME module.
+		 */
+		v = readq(base + FME_HDR_CAP);
+		port_num = FIELD_GET(FME_CAP_NUM_PORTS, v);
+
+		WARN_ON(port_num > MAX_FPGA_PORT_NUM);
+
+		for (i = 0; i < port_num; i++) {
+			v = readq(base + FME_HDR_PORT_OFST(i));
+
+			/* skip ports which are not implemented. */
+			if (!(v & FME_PORT_OFST_IMP))
+				continue;
+
+			/*
+			 * add Port's Device Feature List information for next
+			 * step enumeration.
+			 */
+			bar = FIELD_GET(FME_PORT_OFST_BAR_ID, v);
+			offset = FIELD_GET(FME_PORT_OFST_DFH_OFST, v);
+			base = cci_pci_ioremap_bar(pcidev, bar);
+			if (!base)
+				continue;
+
+			start = pci_resource_start(pcidev, bar) + offset;
+			len = pci_resource_len(pcidev, bar) - offset;
+
+			fpga_enum_info_add_dfl(info, start, len, base + offset);
+		}
+	} else if (feature_is_port(base)) {
+		start = pci_resource_start(pcidev, 0);
+		len = pci_resource_len(pcidev, 0);
+
+		fpga_enum_info_add_dfl(info, start, len, base);
+	} else {
+		ret = -ENODEV;
+		goto enum_info_free_exit;
+	}
+
+	/* start enumeration with prepared enumeration information */
+	cdev = fpga_enumerate_feature_devs(info);
+	if (IS_ERR(cdev)) {
+		dev_err(&pcidev->dev, "Enumeration failure\n");
+		ret = PTR_ERR(cdev);
+		goto enum_info_free_exit;
+	}
+
+	drvdata->cdev = cdev;
+
+enum_info_free_exit:
+	fpga_enum_info_free(info);
+
+	return ret;
+}
+
 static
 int cci_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *pcidevid)
 {
@@ -82,9 +262,22 @@ int cci_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *pcidevid)
 		goto release_region_exit;
 	}
 
-	/* TODO: create and add the platform device per feature list */
-	return 0;
+	ret = cci_init_drvdata(pcidev);
+	if (ret) {
+		dev_err(&pcidev->dev, "Fail to init drvdata %d.\n", ret);
+		goto release_region_exit;
+	}
+
+	ret = cci_enumerate_feature_devs(pcidev);
+	if (ret) {
+		dev_err(&pcidev->dev, "enumeration failure %d.\n", ret);
+		goto remove_drvdata_exit;
+	}
+
+	return ret;
 
+remove_drvdata_exit:
+	cci_remove_drvdata(pcidev);
 release_region_exit:
 	pci_release_regions(pcidev);
 disable_error_report_exit:
@@ -95,6 +288,8 @@ int cci_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *pcidevid)
 
 static void cci_pci_remove(struct pci_dev *pcidev)
 {
+	cci_remove_feature_devs(pcidev);
+	cci_remove_drvdata(pcidev);
 	pci_release_regions(pcidev);
 	pci_disable_pcie_error_reporting(pcidev);
 	pci_disable_device(pcidev);
-- 
2.7.4
