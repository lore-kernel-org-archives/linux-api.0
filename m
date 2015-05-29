From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 02/21] libnd,
 nfit: initial libnd infrastructure and NFIT support
Date: Thu, 28 May 2015 20:57:14 -0400
Message-ID: <20150529005714.3482.99612.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150529005536.3482.48349.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150529005536.3482.48349.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

A libnd bus is the anchor device for registering nvdimm resources and
interfaces, for example, a character control device, nvdimm devices,
and I/O region devices.  The ACPI NFIT (NVDIMM Firmware Interface Table)
is one possible platform description for such non-volatile memory
resources in a system.  The nfit.ko driver attaches to the "ACPI0012"
device that indicates the presence of the NFIT and parses the table to
register a libnd bus instance.

Cc: <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/acpi/Kconfig          |   15 +
 drivers/acpi/Makefile         |    1 
 drivers/acpi/nfit.c           |  444 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit.h           |   89 ++++++++
 drivers/block/Kconfig         |    2 
 drivers/block/Makefile        |    1 
 drivers/block/nd/Kconfig      |   20 ++
 drivers/block/nd/Makefile     |    3 
 drivers/block/nd/core.c       |   67 ++++++
 drivers/block/nd/nd-private.h |   23 ++
 include/linux/libnd.h         |   34 +++
 11 files changed, 699 insertions(+)
 create mode 100644 drivers/acpi/nfit.c
 create mode 100644 drivers/acpi/nfit.h
 create mode 100644 drivers/block/nd/Kconfig
 create mode 100644 drivers/block/nd/Makefile
 create mode 100644 drivers/block/nd/core.c
 create mode 100644 drivers/block/nd/nd-private.h
 create mode 100644 include/linux/libnd.h

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index ab2cbb51c6aa..d449f9a7bad1 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -383,6 +383,21 @@ config ACPI_REDUCED_HARDWARE_ONLY
 
 	  If you are unsure what to do, do not enable this option.
 
+config ACPI_NFIT
+	tristate "ACPI NVDIMM Firmware Interface Table (NFIT)"
+	depends on PHYS_ADDR_T_64BIT
+	depends on BLK_DEV
+	select ND_DEVICES
+	select LIBND
+	help
+	  Infrastructure to probe ACPI 6 compliant platforms for
+	  NVDIMMs (NFIT) and register a libnd device tree.  In
+	  addition to storage devices this also enables libnd to pass
+	  ACPI._DSM messages for platform/dimm configuration.
+
+	  To compile this driver as a module, choose M here:
+	  the module will be called nfit.
+
 source "drivers/acpi/apei/Kconfig"
 
 config ACPI_EXTLOG
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 8a063e276530..f7e9c92ccdcb 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
 obj-y				+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
+obj-$(CONFIG_ACPI_NFIT)		+= nfit.o
 obj-y				+= acpi_memhotplug.o
 obj-$(CONFIG_ACPI_HOTPLUG_IOAPIC) += ioapic.o
 obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
new file mode 100644
index 000000000000..13132a16901c
--- /dev/null
+++ b/drivers/acpi/nfit.c
@@ -0,0 +1,444 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/list_sort.h>
+#include <linux/module.h>
+#include <linux/libnd.h>
+#include <linux/list.h>
+#include <linux/acpi.h>
+#include "nfit.h"
+
+static u8 nfit_uuid[NFIT_UUID_MAX][16];
+
+static const u8 *to_nfit_uuid(enum nfit_uuids id)
+{
+	return nfit_uuid[id];
+}
+
+static int acpi_nfit_ctl(struct nd_bus_descriptor *nd_desc,
+		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
+		unsigned int buf_len)
+{
+	return -ENOTTY;
+}
+
+static const char *spa_type_name(u16 type)
+{
+	switch (type) {
+	case NFIT_SPA_VOLATILE: return "volatile";
+	case NFIT_SPA_PM: return "pmem";
+	case NFIT_SPA_DCR: return "dimm-control-region";
+	case NFIT_SPA_BDW: return "block-data-window";
+	default: return "unknown";
+	}
+}
+
+static int nfit_spa_type(struct acpi_nfit_system_address *spa)
+{
+	int i;
+
+	for (i = 0; i < NFIT_UUID_MAX; i++)
+		if (memcmp(to_nfit_uuid(i), spa->range_guid, 16) == 0)
+			return i;
+	return -1;
+}
+
+static void *add_table(struct acpi_nfit_desc *acpi_desc, void *table, const void *end)
+{
+	struct device *dev = acpi_desc->dev;
+	struct acpi_nfit_header *hdr;
+	void *err = ERR_PTR(-ENOMEM);
+
+	if (table >= end)
+		return NULL;
+
+	hdr = (struct acpi_nfit_header *) table;
+	switch (hdr->type) {
+	case ACPI_NFIT_TYPE_SYSTEM_ADDRESS: {
+		struct nfit_spa *nfit_spa = devm_kzalloc(dev, sizeof(*nfit_spa),
+				GFP_KERNEL);
+		struct acpi_nfit_system_address *spa = table;
+
+		if (!nfit_spa)
+			return err;
+		INIT_LIST_HEAD(&nfit_spa->list);
+		nfit_spa->spa = spa;
+		list_add_tail(&nfit_spa->list, &acpi_desc->spas);
+		dev_dbg(dev, "%s: spa index: %d type: %s\n", __func__,
+				spa->range_index,
+				spa_type_name(nfit_spa_type(spa)));
+		break;
+	}
+	case ACPI_NFIT_TYPE_MEMORY_MAP: {
+		struct nfit_memdev *nfit_memdev = devm_kzalloc(dev,
+				sizeof(*nfit_memdev), GFP_KERNEL);
+		struct acpi_nfit_memory_map *memdev = table;
+
+		if (!nfit_memdev)
+			return err;
+		INIT_LIST_HEAD(&nfit_memdev->list);
+		nfit_memdev->memdev = memdev;
+		list_add_tail(&nfit_memdev->list, &acpi_desc->memdevs);
+		dev_dbg(dev, "%s: memdev handle: %#x spa: %d dcr: %d\n",
+				__func__, memdev->device_handle, memdev->range_index,
+				memdev->region_index);
+		break;
+	}
+	case ACPI_NFIT_TYPE_CONTROL_REGION: {
+		struct nfit_dcr *nfit_dcr = devm_kzalloc(dev, sizeof(*nfit_dcr),
+				GFP_KERNEL);
+		struct acpi_nfit_control_region *dcr = table;
+
+		if (!nfit_dcr)
+			return err;
+		INIT_LIST_HEAD(&nfit_dcr->list);
+		nfit_dcr->dcr = dcr;
+		list_add_tail(&nfit_dcr->list, &acpi_desc->dcrs);
+		dev_dbg(dev, "%s: dcr index: %d windows: %d\n", __func__,
+				dcr->region_index, dcr->windows);
+		break;
+	}
+	case ACPI_NFIT_TYPE_DATA_REGION: {
+		struct nfit_bdw *nfit_bdw = devm_kzalloc(dev, sizeof(*nfit_bdw),
+				GFP_KERNEL);
+		struct acpi_nfit_data_region *bdw = table;
+
+		if (!nfit_bdw)
+			return err;
+		INIT_LIST_HEAD(&nfit_bdw->list);
+		nfit_bdw->bdw = bdw;
+		list_add_tail(&nfit_bdw->list, &acpi_desc->bdws);
+		dev_dbg(dev, "%s: bdw dcr: %d windows: %d\n", __func__,
+				bdw->region_index, bdw->windows);
+		break;
+	}
+	/* TODO */
+	case ACPI_NFIT_TYPE_INTERLEAVE:
+		dev_dbg(dev, "%s: idt\n", __func__);
+		break;
+	case ACPI_NFIT_TYPE_FLUSH_ADDRESS:
+		dev_dbg(dev, "%s: flush\n", __func__);
+		break;
+	case ACPI_NFIT_TYPE_SMBIOS:
+		dev_dbg(dev, "%s: smbios\n", __func__);
+		break;
+	default:
+		dev_err(dev, "unknown table '%d' parsing nfit\n", hdr->type);
+		break;
+	}
+
+	return table + hdr->length;
+}
+
+static void nfit_mem_find_spa_bdw(struct acpi_nfit_desc *acpi_desc,
+		struct nfit_mem *nfit_mem)
+{
+	u32 device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
+	u16 dcr_index = nfit_mem->dcr->region_index;
+	struct nfit_spa *nfit_spa;
+
+	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
+		u16 range_index = nfit_spa->spa->range_index;
+		int type = nfit_spa_type(nfit_spa->spa);
+		struct nfit_memdev *nfit_memdev;
+
+		if (type != NFIT_SPA_BDW)
+			continue;
+
+		list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
+			if (nfit_memdev->memdev->range_index != range_index)
+				continue;
+			if (nfit_memdev->memdev->device_handle != device_handle)
+				continue;
+			if (nfit_memdev->memdev->region_index != dcr_index)
+				continue;
+
+			nfit_mem->spa_bdw = nfit_spa->spa;
+			return;
+		}
+	}
+
+	dev_dbg(acpi_desc->dev, "SPA-BDW not found for SPA-DCR %d\n",
+			nfit_mem->spa_dcr->range_index);
+	nfit_mem->bdw = NULL;
+}
+
+static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
+		struct nfit_mem *nfit_mem, struct acpi_nfit_system_address *spa)
+{
+	u16 dcr_index = __to_nfit_memdev(nfit_mem)->region_index;
+	struct nfit_dcr *nfit_dcr;
+	struct nfit_bdw *nfit_bdw;
+
+	list_for_each_entry(nfit_dcr, &acpi_desc->dcrs, list) {
+		if (nfit_dcr->dcr->region_index != dcr_index)
+			continue;
+		nfit_mem->dcr = nfit_dcr->dcr;
+		break;
+	}
+
+	if (!nfit_mem->dcr) {
+		dev_dbg(acpi_desc->dev, "SPA %d missing:%s%s\n", spa->range_index,
+				__to_nfit_memdev(nfit_mem) ? "" : " MEMDEV",
+				nfit_mem->dcr ? "" : " DCR");
+		return -ENODEV;
+	}
+
+	/*
+	 * We've found enough to create an nd_dimm, optionally
+	 * find an associated BDW
+	 */
+	list_add(&nfit_mem->list, &acpi_desc->dimms);
+
+	list_for_each_entry(nfit_bdw, &acpi_desc->bdws, list) {
+		if (nfit_bdw->bdw->region_index != dcr_index)
+			continue;
+		nfit_mem->bdw = nfit_bdw->bdw;
+		break;
+	}
+
+	if (!nfit_mem->bdw)
+		return 0;
+
+	nfit_mem_find_spa_bdw(acpi_desc, nfit_mem);
+	return 0;
+}
+
+static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_system_address *spa)
+{
+	struct nfit_mem *nfit_mem, *found;
+	struct nfit_memdev *nfit_memdev;
+	int type = nfit_spa_type(spa);
+	u16 dcr_index;
+
+	switch (type) {
+	case NFIT_SPA_DCR:
+	case NFIT_SPA_PM:
+		break;
+	default:
+		return 0;
+	}
+
+	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
+		int rc;
+
+		if (nfit_memdev->memdev->range_index != spa->range_index)
+			continue;
+		found = NULL;
+		dcr_index = nfit_memdev->memdev->region_index;
+		list_for_each_entry(nfit_mem, &acpi_desc->dimms, list)
+			if (__to_nfit_memdev(nfit_mem)->region_index == dcr_index) {
+				found = nfit_mem;
+				break;
+			}
+
+		if (found)
+			nfit_mem = found;
+		else {
+			nfit_mem = devm_kzalloc(acpi_desc->dev,
+					sizeof(*nfit_mem), GFP_KERNEL);
+			if (!nfit_mem)
+				return -ENOMEM;
+			INIT_LIST_HEAD(&nfit_mem->list);
+		}
+
+		if (type == NFIT_SPA_DCR) {
+			/* multiple dimms may share a SPA when interleaved */
+			nfit_mem->spa_dcr = spa;
+			nfit_mem->memdev_dcr = nfit_memdev->memdev;
+		} else {
+			/*
+			 * A single dimm may belong to multiple SPA-PM
+			 * ranges, record at least one in addition to
+			 * any SPA-DCR range.
+			 */
+			nfit_mem->memdev_pmem = nfit_memdev->memdev;
+		}
+
+		if (found)
+			continue;
+
+		rc = nfit_mem_add(acpi_desc, nfit_mem, spa);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int nfit_mem_cmp(void *priv, struct list_head *__a, struct list_head *__b)
+{
+	struct nfit_mem *a = container_of(__a, typeof(*a), list);
+	struct nfit_mem *b = container_of(__b, typeof(*b), list);
+	u32 handleA, handleB;
+
+	handleA = __to_nfit_memdev(a)->device_handle;
+	handleB = __to_nfit_memdev(b)->device_handle;
+	if (handleA < handleB)
+		return -1;
+	else if (handleA > handleB)
+		return 1;
+	return 0;
+}
+
+static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
+{
+	struct nfit_spa *nfit_spa;
+
+	/*
+	 * For each SPA-DCR or SPA-PMEM address range find its
+	 * corresponding MEMDEV(s).  From each MEMDEV find the
+	 * corresponding DCR.  Then, if we're operating on a SPA-DCR,
+	 * try to find a SPA-BDW and a corresponding BDW that references
+	 * the DCR.  Throw it all into an nfit_mem object.  Note, that
+	 * BDWs are optional.
+	 */
+	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
+		int rc;
+
+		rc = nfit_mem_dcr_init(acpi_desc, nfit_spa->spa);
+		if (rc)
+			return rc;
+	}
+
+	list_sort(NULL, &acpi_desc->dimms, nfit_mem_cmp);
+
+	return 0;
+}
+
+static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
+{
+	struct device *dev = acpi_desc->dev;
+	const void *end;
+	u8 *data;
+
+	INIT_LIST_HEAD(&acpi_desc->spas);
+	INIT_LIST_HEAD(&acpi_desc->dcrs);
+	INIT_LIST_HEAD(&acpi_desc->bdws);
+	INIT_LIST_HEAD(&acpi_desc->memdevs);
+	INIT_LIST_HEAD(&acpi_desc->dimms);
+
+	data = (u8 *) acpi_desc->nfit;
+	end = data + sz;
+	data += sizeof(struct acpi_table_nfit);
+	while (!IS_ERR_OR_NULL(data))
+		data = add_table(acpi_desc, data, end);
+
+	if (IS_ERR(data)) {
+		dev_dbg(dev, "%s: nfit table parsing error: %ld\n", __func__,
+				PTR_ERR(data));
+		return PTR_ERR(data);
+	}
+
+	if (nfit_mem_init(acpi_desc) != 0)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int acpi_nfit_add(struct acpi_device *adev)
+{
+	struct nd_bus_descriptor *nd_desc;
+	struct acpi_nfit_desc *acpi_desc;
+	struct device *dev = &adev->dev;
+	struct acpi_table_header *tbl;
+	acpi_status status = AE_OK;
+	acpi_size sz;
+	int rc;
+
+	status = acpi_get_table_with_size("NFIT", 0, &tbl, &sz);
+	if (ACPI_FAILURE(status)) {
+		dev_err(dev, "failed to find NFIT\n");
+		return -ENXIO;
+	}
+
+	acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
+	if (!acpi_desc)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, acpi_desc);
+	acpi_desc->dev = dev;
+	acpi_desc->nfit = (struct acpi_table_nfit *) tbl;
+	nd_desc = &acpi_desc->nd_desc;
+	nd_desc->provider_name = "ACPI.NFIT";
+	nd_desc->ndctl = acpi_nfit_ctl;
+
+	acpi_desc->nd_bus = nd_bus_register(dev, nd_desc);
+	if (!acpi_desc->nd_bus)
+		return -ENXIO;
+
+	rc = acpi_nfit_init(acpi_desc, sz);
+	if (rc) {
+		nd_bus_unregister(acpi_desc->nd_bus);
+		return rc;
+	}
+	return 0;
+}
+
+static int acpi_nfit_remove(struct acpi_device *adev)
+{
+	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(&adev->dev);
+
+	nd_bus_unregister(acpi_desc->nd_bus);
+	return 0;
+}
+
+static const struct acpi_device_id acpi_nfit_ids[] = {
+	{ "ACPI0012", 0 },
+	{ "", 0 },
+};
+MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
+
+static struct acpi_driver acpi_nfit_driver = {
+	.name = KBUILD_MODNAME,
+	.ids = acpi_nfit_ids,
+	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
+	.ops = {
+		.add = acpi_nfit_add,
+		.remove = acpi_nfit_remove,
+	},
+};
+
+static __init int nfit_init(void)
+{
+	BUILD_BUG_ON(sizeof(struct acpi_table_nfit) != 40);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_system_address) != 56);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_memory_map) != 48);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_interleave) != 20);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_smbios) != 9);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_control_region) != 80);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_data_region) != 40);
+
+	acpi_str_to_uuid(UUID_VOLATILE_MEMORY, nfit_uuid[NFIT_SPA_VOLATILE]);
+	acpi_str_to_uuid(UUID_PERSISTENT_MEMORY, nfit_uuid[NFIT_SPA_PM]);
+	acpi_str_to_uuid(UUID_CONTROL_REGION, nfit_uuid[NFIT_SPA_DCR]);
+	acpi_str_to_uuid(UUID_DATA_REGION, nfit_uuid[NFIT_SPA_BDW]);
+	acpi_str_to_uuid(UUID_VOLATILE_VIRTUAL_DISK, nfit_uuid[NFIT_SPA_VDISK]);
+	acpi_str_to_uuid(UUID_VOLATILE_VIRTUAL_CD, nfit_uuid[NFIT_SPA_VCD]);
+	acpi_str_to_uuid(UUID_PERSISTENT_VIRTUAL_DISK, nfit_uuid[NFIT_SPA_PDISK]);
+	acpi_str_to_uuid(UUID_PERSISTENT_VIRTUAL_CD, nfit_uuid[NFIT_SPA_PCD]);
+	acpi_str_to_uuid(UUID_NFIT_BUS, nfit_uuid[NFIT_DEV_BUS]);
+	acpi_str_to_uuid(UUID_NFIT_DIMM, nfit_uuid[NFIT_DEV_DIMM]);
+
+	return acpi_bus_register_driver(&acpi_nfit_driver);
+}
+
+static __exit void nfit_exit(void)
+{
+	acpi_bus_unregister_driver(&acpi_nfit_driver);
+}
+
+module_init(nfit_init);
+module_exit(nfit_exit);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
new file mode 100644
index 000000000000..ff72da9c9694
--- /dev/null
+++ b/drivers/acpi/nfit.h
@@ -0,0 +1,89 @@
+/*
+ * NVDIMM Firmware Interface Table - NFIT
+ *
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __NFIT_H__
+#define __NFIT_H__
+#include <linux/types.h>
+#include <linux/libnd.h>
+#include <linux/uuid.h>
+#include <linux/acpi.h>
+#include <acpi/acuuid.h>
+
+#define UUID_NFIT_BUS "2f10e7a4-9e91-11e4-89d3-123b93f75cba"
+#define UUID_NFIT_DIMM "4309ac30-0d11-11e4-9191-0800200c9a66"
+
+enum nfit_uuids {
+	NFIT_SPA_VOLATILE,
+	NFIT_SPA_PM,
+	NFIT_SPA_DCR,
+	NFIT_SPA_BDW,
+	NFIT_SPA_VDISK,
+	NFIT_SPA_VCD,
+	NFIT_SPA_PDISK,
+	NFIT_SPA_PCD,
+	NFIT_DEV_BUS,
+	NFIT_DEV_DIMM,
+	NFIT_UUID_MAX,
+};
+
+struct nfit_spa {
+	struct acpi_nfit_system_address *spa;
+	struct list_head list;
+};
+
+struct nfit_dcr {
+	struct acpi_nfit_control_region *dcr;
+	struct list_head list;
+};
+
+struct nfit_bdw {
+	struct acpi_nfit_data_region *bdw;
+	struct list_head list;
+};
+
+struct nfit_memdev {
+	struct acpi_nfit_memory_map *memdev;
+	struct list_head list;
+};
+
+/* assembled tables for a given dimm/memory-device */
+struct nfit_mem {
+	struct acpi_nfit_memory_map *memdev_dcr;
+	struct acpi_nfit_memory_map *memdev_pmem;
+	struct acpi_nfit_control_region *dcr;
+	struct acpi_nfit_data_region *bdw;
+	struct acpi_nfit_system_address *spa_dcr;
+	struct acpi_nfit_system_address *spa_bdw;
+	struct list_head list;
+};
+
+struct acpi_nfit_desc {
+	struct nd_bus_descriptor nd_desc;
+	struct acpi_table_nfit *nfit;
+	struct list_head memdevs;
+	struct list_head dimms;
+	struct list_head spas;
+	struct list_head dcrs;
+	struct list_head bdws;
+	struct nd_bus *nd_bus;
+	struct device *dev;
+};
+
+static inline struct acpi_nfit_memory_map *__to_nfit_memdev(struct nfit_mem *nfit_mem)
+{
+	if (nfit_mem->memdev_dcr)
+		return nfit_mem->memdev_dcr;
+	return nfit_mem->memdev_pmem;
+}
+#endif /* __NFIT_H__ */
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index eb1fed5bd516..dfe40e5ca9bd 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -321,6 +321,8 @@ config BLK_DEV_NVME
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvme.
 
+source "drivers/block/nd/Kconfig"
+
 config BLK_DEV_SKD
 	tristate "STEC S1120 Block Driver"
 	depends on PCI
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 9cc6c18a1c7e..07a6acecf4d8 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_CDROM_PKTCDVD)	+= pktcdvd.o
 obj-$(CONFIG_MG_DISK)		+= mg_disk.o
 obj-$(CONFIG_SUNVDC)		+= sunvdc.o
 obj-$(CONFIG_BLK_DEV_NVME)	+= nvme.o
+obj-$(CONFIG_ND_DEVICES)	+= nd/
 obj-$(CONFIG_BLK_DEV_SKD)	+= skd.o
 obj-$(CONFIG_BLK_DEV_OSD)	+= osdblk.o
 
diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
new file mode 100644
index 000000000000..9b909c21afa1
--- /dev/null
+++ b/drivers/block/nd/Kconfig
@@ -0,0 +1,20 @@
+menuconfig ND_DEVICES
+	bool "NVDIMM (Non-Volatile Memory Device) Support"
+	help
+	  Generic support for non-volatile memory devices including
+	  ACPI-6-NFIT defined resources.  On platforms that define an
+	  NFIT, or otherwise can discover NVDIMM resources, a libnd
+	  bus is registered to advertise PMEM (persistent memory)
+	  namespaces (/dev/pmemX) and BLK (sliding mmio window(s))
+	  namespaces (/dev/ndX). A PMEM namespace refers to a memory
+	  resource that may span multiple DIMMs and support DAX (see
+	  CONFIG_DAX).  A BLK namespace refers to an NVDIMM control
+	  region which exposes an mmio register set for windowed
+	  access mode to non-volatile memory.
+
+if ND_DEVICES
+
+config LIBND
+	tristate
+
+endif
diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
new file mode 100644
index 000000000000..a647ff6cf557
--- /dev/null
+++ b/drivers/block/nd/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_LIBND) += libnd.o
+
+libnd-y := core.o
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
new file mode 100644
index 000000000000..15b89ce1a9af
--- /dev/null
+++ b/drivers/block/nd/core.c
@@ -0,0 +1,67 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/libnd.h>
+#include <linux/slab.h>
+#include "nd-private.h"
+
+static DEFINE_IDA(nd_ida);
+
+static void nd_bus_release(struct device *dev)
+{
+	struct nd_bus *nd_bus = container_of(dev, struct nd_bus, dev);
+
+	ida_simple_remove(&nd_ida, nd_bus->id);
+	kfree(nd_bus);
+}
+
+struct nd_bus *nd_bus_register(struct device *parent,
+		struct nd_bus_descriptor *nd_desc)
+{
+	struct nd_bus *nd_bus = kzalloc(sizeof(*nd_bus), GFP_KERNEL);
+	int rc;
+
+	if (!nd_bus)
+		return NULL;
+	nd_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
+	if (nd_bus->id < 0) {
+		kfree(nd_bus);
+		return NULL;
+	}
+	nd_bus->nd_desc = nd_desc;
+	nd_bus->dev.parent = parent;
+	nd_bus->dev.release = nd_bus_release;
+	dev_set_name(&nd_bus->dev, "ndbus%d", nd_bus->id);
+	rc = device_register(&nd_bus->dev);
+	if (rc) {
+		dev_dbg(&nd_bus->dev, "device registration failed: %d\n", rc);
+		put_device(&nd_bus->dev);
+		return NULL;
+	}
+
+	return nd_bus;
+}
+EXPORT_SYMBOL_GPL(nd_bus_register);
+
+void nd_bus_unregister(struct nd_bus *nd_bus)
+{
+	if (!nd_bus)
+		return;
+	device_unregister(&nd_bus->dev);
+}
+EXPORT_SYMBOL_GPL(nd_bus_unregister);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
new file mode 100644
index 000000000000..a107a19ffa9c
--- /dev/null
+++ b/drivers/block/nd/nd-private.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __ND_PRIVATE_H__
+#define __ND_PRIVATE_H__
+#include <linux/device.h>
+#include <linux/libnd.h>
+
+struct nd_bus {
+	struct nd_bus_descriptor *nd_desc;
+	struct device dev;
+	int id;
+};
+#endif /* __ND_PRIVATE_H__ */
diff --git a/include/linux/libnd.h b/include/linux/libnd.h
new file mode 100644
index 000000000000..8e4441002868
--- /dev/null
+++ b/include/linux/libnd.h
@@ -0,0 +1,34 @@
+/*
+ * libnd - Non-volatile-memory Devices Subsystem
+ *
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __LIBND_H__
+#define __LIBND_H__
+struct nd_dimm;
+struct nd_bus_descriptor;
+typedef int (*ndctl_fn)(struct nd_bus_descriptor *nd_desc,
+		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
+		unsigned int buf_len);
+
+struct nd_bus_descriptor {
+	unsigned long dsm_mask;
+	char *provider_name;
+	ndctl_fn ndctl;
+};
+
+struct nd_bus;
+struct device;
+struct nd_bus *nd_bus_register(struct device *parent,
+		struct nd_bus_descriptor *nfit_desc);
+void nd_bus_unregister(struct nd_bus *nd_bus);
+#endif /* __LIBND_H__ */
