From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv8 09/10] acpi/hmat: Register memory side cache attributes
Date: Mon, 11 Mar 2019 14:56:05 -0600
Message-ID: <20190311205606.11228-10-keith.busch@intel.com>
References: <20190311205606.11228-1-keith.busch@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190311205606.11228-1-keith.busch@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, Brice Goglin <Brice.Goglin@inria.fr>, Keith Busch <keith.busch@intel.com>
List-Id: linux-api@vger.kernel.org

Register memory side cache attributes with the memory's node if HMAT
provides the side cache iniformation table.

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 drivers/acpi/hmat/hmat.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
index 7a3a2b50cadd..b7824a0309f7 100644
--- a/drivers/acpi/hmat/hmat.c
+++ b/drivers/acpi/hmat/hmat.c
@@ -314,6 +314,7 @@ static __init int hmat_parse_cache(union acpi_subtable_headers *header,
 				   const unsigned long end)
 {
 	struct acpi_hmat_cache *cache = (void *)header;
+	struct node_cache_attrs cache_attrs;
 	u32 attrs;
 
 	if (cache->header.length < sizeof(*cache)) {
@@ -327,6 +328,37 @@ static __init int hmat_parse_cache(union acpi_subtable_headers *header,
 		cache->memory_PD, cache->cache_size, attrs,
 		cache->number_of_SMBIOShandles);
 
+	cache_attrs.size = cache->cache_size;
+	cache_attrs.level = (attrs & ACPI_HMAT_CACHE_LEVEL) >> 4;
+	cache_attrs.line_size = (attrs & ACPI_HMAT_CACHE_LINE_SIZE) >> 16;
+
+	switch ((attrs & ACPI_HMAT_CACHE_ASSOCIATIVITY) >> 8) {
+	case ACPI_HMAT_CA_DIRECT_MAPPED:
+		cache_attrs.indexing = NODE_CACHE_DIRECT_MAP;
+		break;
+	case ACPI_HMAT_CA_COMPLEX_CACHE_INDEXING:
+		cache_attrs.indexing = NODE_CACHE_INDEXED;
+		break;
+	case ACPI_HMAT_CA_NONE:
+	default:
+		cache_attrs.indexing = NODE_CACHE_OTHER;
+		break;
+	}
+
+	switch ((attrs & ACPI_HMAT_WRITE_POLICY) >> 12) {
+	case ACPI_HMAT_CP_WB:
+		cache_attrs.write_policy = NODE_CACHE_WRITE_BACK;
+		break;
+	case ACPI_HMAT_CP_WT:
+		cache_attrs.write_policy = NODE_CACHE_WRITE_THROUGH;
+		break;
+	case ACPI_HMAT_CP_NONE:
+	default:
+		cache_attrs.write_policy = NODE_CACHE_WRITE_OTHER;
+		break;
+	}
+
+	node_add_cache(pxm_to_node(cache->memory_PD), &cache_attrs);
 	return 0;
 }
 
-- 
2.14.4
