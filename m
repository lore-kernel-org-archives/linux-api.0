Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020111.outbound.protection.outlook.com [52.101.56.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881B23DAAA9;
	Tue, 25 Aug 2026 22:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.111
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696161; cv=fail; b=I1DnCrI2WSckxfNFqb33bgjjXIYzSPbHmPwS9ThwzHciqHtVa2i24htSELwr6510YBkMFGu/1g7H31Zf7jzZ0CyOgkIZYBeZqsmtveULI29GnLg/XPCUwkuNqzBeZ2P8FPO2keTD1cnW2fYMTvjJRevrhl11fAcFIKD2RRxthTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696161; c=relaxed/simple;
	bh=1Lz7flOl15g60ZhWnGX2JawPtjIWvv1VcsgAJCUnScE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=seMkReLueCWP6Vj6j3//Nx8ZW7OkzNhTVJ/+DUBrepwvHgcXhHWh5ksDp0wR3TwMR1egz/fiHK66rotWKUQuCgoU0q00q9P8MXzNY0jpPqIT1pz8zq9fjk6PrAH8gNwpk9UXRyuR9G71X4V7C8WnviYpErmlQ+2W1P/LIFKBlxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=fUd0jOdb; arc=fail smtp.client-ip=52.101.56.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="fUd0jOdb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q1uGBuKjjoC2cF0NCsL4jUMaQj8DYhNjFo2CSSYsLr3/QuYpevyz3M15XQZ0BGvmdyhU1VkK07Jw65jDxnpMSMfc6IjpsGQMAXlVx5uxfU7TT5WhuWiWTxat0Xu4hxkT/Ss7NQKu9uCpA2JuyIT+CcnyBPGwPeTi9pZcq0riy26nzehfyVbcM4YpwCjuChLV5z/Hynq5IAqbwzm/pNL3MFgw9bQzR4f8S4+YGituFsn+jWH3Bt8HEwrRgafKxdrOI5z6J8CYxcS3ZTgXFDAONaBDa47oCk/yXqj5gzVvJFmyhTIvEQUfAjjFMUfl82jtpO+8cM6cTGCj+8AnjLvrYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/w+zv220K6t7QgWZ8KVqKUJidy0ZzguveMEeZQ0lQhw=;
 b=PN7r53GnzAqmAcfQ8LsQDNwPb1wi5aiTdgrmWCzUtpxySMKD162tNYyH9nl49Jt2ZavW/8yk3MD+RFke92Zp8D39C8FExd9NDHhZ6CIzps3HaFkD7KjX624RElGEbqeCG7pRtdbPqo+1L7oqdOjkEwcSOgHk/Zt3PKI1f1OyB2MzO07h8eazbz2hIfHF7TX7F8aDgWkwAwZ9zHpyJFBG3msHaXQnJoMxzRnlDcqRorRbAjCJvpGp1nZ6t3PKTFjX2jQoEc+i0b79VOO4R02azZJOCzIZARtQyW6yOuOHX4OASFiApdlsKqK1dGEYdsQKdrPeZxoz4jgyumDrB/pCjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/w+zv220K6t7QgWZ8KVqKUJidy0ZzguveMEeZQ0lQhw=;
 b=fUd0jOdbgU5EMyGOHLbNo/hjI6WAgM/VXkR/x1HxaW9gH+WPCHzO+DagVGRR6PPXvKsLwGX1l2QP5GNjJUloKGZN3AUpDGObMtazAp96aGfjmKajpjJbQQICv1FQ1vW4vAOoQOL1yzV/dVRptrm91IWWPmD8wrLiWbIIZAiFzzi8gb6vrKGnWq6VIoz3uiP5wjPZkT9//mIRuP7I/Vz2ZJIoe8qsiIMulfRH0WWYbFxpcRGtRaHQZCN65+B2pqOtcb2MugtM3qjrnHrFpvt/Up+DYxlVS0QyqnnxOlL6Su3IcRctA0S++DvZ84L9obYakXafpkRfOZXWPrsXPG8CaQ==
Received: from SJ0PR13CA0137.namprd13.prod.outlook.com (2603:10b6:a03:2c6::22)
 by CH8PR04MB994335.namprd04.prod.outlook.com (2603:10b6:610:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Tue, 25 Aug
 2026 22:15:52 +0000
Received: from SJ1PEPF000023CB.namprd02.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::f0) by SJ0PR13CA0137.outlook.office365.com
 (2603:10b6:a03:2c6::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.6 via Frontend Transport; Tue, 25
 Aug 2026 22:15:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy01.rambus.com; pr=C
Received: from hqxsv-psmtppxy01.rambus.com (192.86.86.210) by
 SJ1PEPF000023CB.mail.protection.outlook.com (10.167.244.5) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 22:15:52 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy01.rambus.com (Postfix) with ESMTP id 369341801761;
	Tue, 25 Aug 2026 18:15:51 -0400 (EDT)
From: Alex Ousherovitch <aousherovitch@rambus.com>
To: Albert Ou <aou@eecs.berkeley.edu>,
	Alex Ousherovitch <aousherovitch@rambus.com>,
	Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	devicetree@vger.kernel.org,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-api@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thi Nguyen <thin@rambus.com>
Subject: [PATCH v4 05/19] crypto: cmh - add HMAC ahash
Date: Tue, 25 Aug 2026 15:15:24 -0700
Message-ID: <20260825221539.255951-6-aousherovitch@rambus.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260825221539.255951-1-aousherovitch@rambus.com>
References: <20260825221539.255951-1-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CB:EE_|CH8PR04MB994335:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: e709f3bc-4823-4217-6870-08df02f66ce2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|23010399003|376014|36860700016|921020|22082099003|18002099003|3023799007|5023799004|56012099006|11063799006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	yq3WCYd4KXh5F9boZpSNqCYUgZgaMXv36Wm443sie4qQ59aWl6Dc5ztX4rgqQQDTGFqWx+qtroqaQLFgCFdqBm+akx5lBMqUq+HAL66PJ/StHh2M5yeceeFkr1hk2xPkaOfHhQtOCZAmER6Uq078dPmVxdL9GxsXehiEOmfJoyY589JRFi1uDfZyTpo6N9jzB1z8xiqvzZWEy1LeLqqczkA4KNrOBQMDdG6pNdzb4tyhABeKsxbgvy+IdWUEnmu5Hqc/u1/vEExtyeL9EWdqUg/wBM/I++CZaZ7u8WPDwtbTJO6HFdqiRFdSsEty0+N1pgsvpq/KQ2IoyMYazp4scVUwBHe8dUikFgk3LZep9shrNasi/jytAsH8iQX+2PlstlUlb6vHUluvYBSxRlqrhvENR4i90ISCBrCOFHtnes84OH9k35DWVF+GJDmu/DPAYEX8Y0wH2rKstdgb0hp7oHcinW3AxeOwBH/6zTUtM/UP9DWm8uGrMo0pX4hyk0WdjTIxSYCjjyKEUyqq+WEvcQy+iWSaHMoBJG/tN/Yg+3UielNK+wboBX61nZhrYd2bruSmirkVg/nmdVUDrPjW2USfBy4tylQoCltm8S2X+mqwxtTmgyYlOOrEkGT3EC2VZ2icc+DenJBH/C4zrvUGd6ltaqc5Im59qwHS0Jx0xJVG9xcdWh2wM74vLkZC4DI+EWvzoJw61vza+5IhOT6X3gu9KInSP3UiZbTqtb8dxEIj8/qzUUK2h3etkqt621Vr
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy01.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(23010399003)(376014)(36860700016)(921020)(22082099003)(18002099003)(3023799007)(5023799004)(56012099006)(11063799006)(6133799003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	U5zsyKeyHCBQssQYyt3MYryRu3wYkoW3xB4QiH6Tw+LBSNXU8q1nDB3/4BEEg+a0eBh1Q8tF5DSfrqi7cLkQfyasi7UDn5O8TERdmxW0HV08qrZgChuRLKJzZssFn0afLstSfTY+WqS4HxGOsq5OOVRXOTZY7vMN6sWY1X+XQJcCMFWVcIfT9Ky0FpWepCAJo0GHbuZv8ZVlZcVJTi2fBJS/hVkexYTFS7aKK3EiXYNG16ZHhsEm2XN0GEWLj8CmYEe9uys+S0/5kuSDphXTIhL2c4CLlI+C76Zh9In7nW0EeKrcSOJ/ar4IkAdoX2Rk5sTeN5neCseNm7nqsXeldvXhneQbS1UJkfdNsmVyN5jUnhpdVvZt0G2kFwT5CrtRKHmIzll7VEQibE5Ba5wrGMGkFUWvp/P3bsljHhmQFRRHkpz1z5yhp+5nXFlFftip
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 22:15:52.1421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e709f3bc-4823-4217-6870-08df02f66ce2
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy01.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR04MB994335

Register ahash algorithms for HMAC-SHA-224, HMAC-SHA-256,
HMAC-SHA-384, HMAC-SHA-512, HMAC-SHA3-224, HMAC-SHA3-256,
HMAC-SHA3-384, and HMAC-SHA3-512 using the CMH hash core.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 drivers/crypto/cmh/Makefile           |   3 +-
 drivers/crypto/cmh/cmh_hmac.c         | 879 ++++++++++++++++++++++++++
 drivers/crypto/cmh/cmh_main.c         |   9 +
 drivers/crypto/cmh/include/cmh_hmac.h |  16 +
 4 files changed, 906 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/cmh/cmh_hmac.c
 create mode 100644 drivers/crypto/cmh/include/cmh_hmac.h

diff --git a/drivers/crypto/cmh/Makefile b/drivers/crypto/cmh/Makefile
index 79c94d87e9ee..acd1827cc084 100644
--- a/drivers/crypto/cmh/Makefile
+++ b/drivers/crypto/cmh/Makefile
@@ -15,7 +15,8 @@ cmh-y := \
 	cmh_sysfs.o \
 	cmh_key.o \
 	cmh_sys.o \
-	cmh_hash.o
+	cmh_hash.o \
+	cmh_hmac.o
 
 # Management ioctl device (/dev/cmh_mgmt): key lifecycle, PKE, PQC ioctls.
 cmh-$(CONFIG_CRYPTO_DEV_CMH_MGMT) += \
diff --git a/drivers/crypto/cmh/cmh_hmac.c b/drivers/crypto/cmh/cmh_hmac.c
new file mode 100644
index 000000000000..528079f60bfa
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_hmac.c
@@ -0,0 +1,879 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Kernel Crypto API HMAC Driver
+ *
+ * Registers HMAC ahash algorithms with the Linux crypto subsystem.
+ * Supports HMAC-SHA-2 (224/256/384/512) and HMAC-SHA-3 (224/256/384/512)
+ * using the CMH Hash Core (HC) via HC_CMD_HMAC.
+ *
+ * Uses the same self-contained transaction model as cmh_hash.c:
+ *   .setkey() -> store raw key bytes
+ *   .init()   -> software-only: initialize per-request context
+ *   .update() -> software-only: copy SG data into per-call chunk
+ *   .final()  -> [SYS_CMD_WRITE] + HC_CMD_HMAC + [GATHER] + FINAL + FLUSH
+ *
+ * Raw-key atomicity: SYS_CMD_WRITE to SYS_REF_TEMP is packed into
+ * the same VCQ as HC_CMD_HMAC (see cmh_key.h for details).
+ *
+ * ahash .export()/.import() (state cloning): the HW hash core does NOT
+ * support save/restore of intermediate HMAC state, so the driver
+ * accumulates input in kernel memory and serialises that buffer for
+ * the common (bounded) case.  When the accumulated input exceeds the
+ * HW cap (HMAC_MAX_DATA, 64 KB) or the flat export window, the request
+ * transparently switches to a generic software HMAC fallback that the
+ * driver allocates and keys itself: buffered chunks are replayed into it and
+ * all further input streams through it, so arbitrary-length hashing and
+ * transform clone both remain conformant with O(1) driver memory.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/crypto.h>
+#include <crypto/internal/hash.h>
+#include <crypto/hash.h>
+#include <linux/scatterlist.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include "cmh_hmac.h"
+#include "cmh_vcq.h"
+#include "cmh_hc_abi.h"
+#include "cmh_sys_abi.h"
+#include "cmh_sys.h"
+#include "cmh_txn.h"
+#include "cmh_dma.h"
+#include "cmh_key.h"
+
+/*
+ * Maximum data that can be accumulated across .update() calls.
+ * HMAC save/restore is intentionally unsupported (see file header),
+ * so all data must be buffered in kernel memory and submitted
+ * atomically in .final().  This cap prevents unbounded allocation.
+ */
+#define HMAC_MAX_DATA		(64 * 1024)
+
+/* Algorithm Table */
+
+struct cmh_hmac_alg_info {
+	u32         hc_algo;        /* HC_ALGO_* */
+	u32         digest_size;    /* bytes */
+	u32         block_size;     /* cra_blocksize */
+	const char *alg_name;       /* Linux crypto name: "hmac(sha256)" */
+	const char *drv_name;       /* driver name: "rambus-cmh-hmac-sha256" */
+};
+
+static const struct cmh_hmac_alg_info cmh_hmac_algs_info[] = {
+	/* HMAC-SHA-2 family */
+	{
+		.hc_algo     = HC_ALGO_SHA2_224,
+		.digest_size = CMH_SHA224_DIGEST_SIZE,
+		.block_size  = 64,
+		.alg_name    = "hmac(sha224)",
+		.drv_name    = "rambus-cmh-hmac-sha224",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA2_256,
+		.digest_size = CMH_SHA256_DIGEST_SIZE,
+		.block_size  = 64,
+		.alg_name    = "hmac(sha256)",
+		.drv_name    = "rambus-cmh-hmac-sha256",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA2_384,
+		.digest_size = CMH_SHA384_DIGEST_SIZE,
+		.block_size  = 128,
+		.alg_name    = "hmac(sha384)",
+		.drv_name    = "rambus-cmh-hmac-sha384",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA2_512,
+		.digest_size = CMH_SHA512_DIGEST_SIZE,
+		.block_size  = 128,
+		.alg_name    = "hmac(sha512)",
+		.drv_name    = "rambus-cmh-hmac-sha512",
+	},
+	/* HMAC-SHA-3 family */
+	{
+		.hc_algo     = HC_ALGO_SHA3_224,
+		.digest_size = CMH_SHA3_224_DIGEST_SIZE,
+		.block_size  = 144,
+		.alg_name    = "hmac(sha3-224)",
+		.drv_name    = "rambus-cmh-hmac-sha3-224",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA3_256,
+		.digest_size = CMH_SHA3_256_DIGEST_SIZE,
+		.block_size  = 136,
+		.alg_name    = "hmac(sha3-256)",
+		.drv_name    = "rambus-cmh-hmac-sha3-256",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA3_384,
+		.digest_size = CMH_SHA3_384_DIGEST_SIZE,
+		.block_size  = 104,
+		.alg_name    = "hmac(sha3-384)",
+		.drv_name    = "rambus-cmh-hmac-sha3-384",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA3_512,
+		.digest_size = CMH_SHA3_512_DIGEST_SIZE,
+		.block_size  = 72,
+		.alg_name    = "hmac(sha3-512)",
+		.drv_name    = "rambus-cmh-hmac-sha3-512",
+	},
+};
+
+#define CMH_HMAC_ALG_COUNT  ARRAY_SIZE(cmh_hmac_algs_info)
+
+/* Per-Request State */
+
+struct cmh_hmac_chunk {
+	struct list_head  list;
+	struct list_head  tfm_node; /* per-tfm orphan tracking */
+	u32               len;
+	u8                data[];
+};
+
+/*
+ * Maximum payload commands any HMAC transaction can produce:
+ *   [SYS_CMD_WRITE] + HC_CMD_HMAC + [GATHER] + FINAL + FLUSH = 5
+ * Worst-case packed output (stride=7, 1 payload per VCQ):
+ *   5 VCQs x 2 entries = 10
+ */
+#define CMH_HMAC_MAX_PAYLOAD    5
+#define CMH_HMAC_MAX_PACKED     (CMH_HMAC_MAX_PAYLOAD * 2)
+
+struct cmh_hmac_reqctx {
+	const struct cmh_hmac_alg_info *info;
+	int                             error;
+	struct list_head                chunks;
+	u32                             num_chunks;
+	u32                             total_len;
+	bool                            switched;   /* handed off to SW fallback */
+	/* DMA state for async final */
+	dma_addr_t                      digest_dma;
+	dma_addr_t                      key_dma;
+	u8                             *digest_buf;
+	struct cmh_sg_map              *sgm;
+	u32                             keylen;
+	struct vcq_cmd packed[CMH_HMAC_MAX_PACKED];
+};
+
+/*
+ * Flat state for export/import, tagged by the leading @format byte:
+ *
+ *   CMH_HMAC_FMT_RAW -- the accumulated input bytes, verbatim.  Used
+ *     while the request is still on the HW-buffered path and fits the
+ *     flat window (total_len <= CMH_HMAC_EXPORT_MAX).
+ *   CMH_HMAC_FMT_FB  -- the software fallback's own exported state.
+ *     Used once the request has switched to the fallback (oversized
+ *     input, or an export past the flat window), so export/import
+ *     (transform clone) works at any input length.
+ */
+#define CMH_HMAC_FMT_RAW 0
+#define CMH_HMAC_FMT_FB  1
+
+struct cmh_hmac_export_state {
+	u8  format;
+	u8  __pad[3];
+	u32 total_len;
+	u8  data[];
+};
+
+/*
+ * The crypto subsystem pre-allocates statesize bytes per request.
+ * CMH_HMAC_STATE_SIZE (4096) sizes both the CMH_HMAC_FMT_RAW window
+ * (CMH_HMAC_EXPORT_MAX accumulated bytes) and the CMH_HMAC_FMT_FB
+ * software state (the generic fallback's much smaller statesize).  A
+ * RAW export past CMH_HMAC_EXPORT_MAX transparently switches to the
+ * fallback and emits CMH_HMAC_FMT_FB instead, so export/import is not
+ * capped.
+ */
+#define CMH_HMAC_STATE_SIZE 4096
+#define CMH_HMAC_EXPORT_MAX (CMH_HMAC_STATE_SIZE - sizeof(struct cmh_hmac_export_state))
+
+/* Per-Transform State (carries key across requests) */
+
+struct cmh_hmac_tfm_ctx {
+	struct cmh_key_ctx key;
+	struct crypto_ahash *fb;	/* generic SW fallback (oversized ops) */
+	spinlock_t         chunk_lock;  /* protects all_chunks */
+	struct list_head   all_chunks;  /* orphan-safe chunk tracking */
+};
+
+/* VCQ Builders (HMAC-specific; shared builders in cmh_hc_abi.h / cmh_vcq.h) */
+
+/* Add an HC_CMD_HMAC entry */
+static void vcq_add_hc_hmac(struct vcq_cmd *slot, u32 core_id, u64 key_ref,
+			    u32 keylen, u32 algo)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HC_CMD_HMAC);
+	slot->hwc.hc.cmd_hmac.key = key_ref;
+	slot->hwc.hc.cmd_hmac.keylen = keylen;
+	slot->hwc.hc.cmd_hmac.algo = algo;
+}
+
+/* Request Context Cleanup */
+
+static void cmh_hmac_free_chunks(struct cmh_hmac_reqctx *rctx,
+				 struct cmh_hmac_tfm_ctx *tctx)
+{
+	struct cmh_hmac_chunk *chunk, *tmp;
+
+	spin_lock_bh(&tctx->chunk_lock);
+	list_for_each_entry_safe(chunk, tmp, &rctx->chunks, list) {
+		list_del(&chunk->list);
+		list_del(&chunk->tfm_node);
+		kfree_sensitive(chunk);
+	}
+	spin_unlock_bh(&tctx->chunk_lock);
+	rctx->num_chunks = 0;
+	rctx->total_len = 0;
+}
+
+/*
+ * Build a DMA-mapped CMH eSW scatter-gather chain from accumulated chunks.
+ */
+static struct cmh_sg_map *
+cmh_hmac_build_sg(struct cmh_hmac_reqctx *rctx, gfp_t gfp)
+{
+	struct cmh_dma_buf *bufs;
+	struct cmh_hmac_chunk *chunk;
+	struct cmh_sg_map *sgm;
+	u32 i;
+
+	bufs = kcalloc(rctx->num_chunks, sizeof(*bufs), gfp);
+	if (!bufs)
+		return NULL;
+
+	i = 0;
+	list_for_each_entry(chunk, &rctx->chunks, list) {
+		bufs[i].data = chunk->data;
+		bufs[i].len = chunk->len;
+		i++;
+	}
+
+	sgm = cmh_dma_build_sg(bufs, rctx->num_chunks, gfp);
+	kfree(bufs);
+	return sgm;
+}
+
+/* VCQ Packing + Submit */
+
+/* ahash Operations */
+
+struct cmh_hmac_alg_drv {
+	struct ahash_alg                  alg;
+	const struct cmh_hmac_alg_info   *info;
+};
+
+static const struct cmh_hmac_alg_info *
+cmh_hmac_get_info(struct crypto_ahash *tfm)
+{
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
+
+	return container_of(alg, struct cmh_hmac_alg_drv, alg)->info;
+}
+
+/* Software-fallback helpers (arbitrary-length + transform-clone support) */
+
+/*
+ * The fallback ahash_request lives immediately after the reqctx.
+ * cmh_hmac_cra_init() reserves crypto_ahash_reqsize(fb) bytes for it and
+ * PTR_ALIGN keeps it aligned for the fallback's own request context.
+ */
+static struct ahash_request *cmh_hmac_fb_req(struct cmh_hmac_reqctx *rctx)
+{
+	return PTR_ALIGN((void *)(rctx + 1), crypto_tfm_ctx_alignment());
+}
+
+/*
+ * Feed @len bytes of the linear buffer @data to the fallback request.
+ * The core allocated the fallback as a virt-capable transform, so a
+ * virtual address can be handed to it directly.  The fallback is
+ * synchronous (shash-backed), so crypto_ahash_update() completes inline.
+ */
+static int cmh_hmac_fb_update_virt(struct ahash_request *fb_req,
+				   const u8 *data, u32 len)
+{
+	ahash_request_set_virt(fb_req, data, NULL, len);
+	return crypto_ahash_update(fb_req);
+}
+
+/*
+ * Switch a request from the HW-buffered path to the software fallback:
+ * initialise the fallback request, replay every accumulated chunk
+ * through it, then drop the chunks (their bytes now live in the
+ * fallback's running state).  Afterwards the request is O(1) in memory
+ * and no longer input-capped.  The fallback transform was keyed by
+ * cmh_hmac_setkey() when the caller installed the MAC key.
+ */
+static int cmh_hmac_switch_to_fb(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_hmac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_hmac_reqctx *rctx = ahash_request_ctx(req);
+	struct ahash_request *fb_req = cmh_hmac_fb_req(rctx);
+	struct cmh_hmac_chunk *chunk;
+	int ret;
+
+	ahash_request_set_tfm(fb_req, tctx->fb);
+	ahash_request_set_callback(fb_req, 0, NULL, NULL);
+
+	ret = crypto_ahash_init(fb_req);
+	if (ret)
+		return ret;
+
+	list_for_each_entry(chunk, &rctx->chunks, list) {
+		ret = cmh_hmac_fb_update_virt(fb_req, chunk->data, chunk->len);
+		if (ret)
+			return ret;
+	}
+
+	cmh_hmac_free_chunks(rctx, tctx);
+	rctx->switched = true;
+	return 0;
+}
+
+/*
+ * Forward the current update() payload to the fallback and remember any
+ * error so a later final()/update() reports it.  @req may carry either a
+ * virtual buffer or a scatterlist.
+ */
+static int cmh_hmac_fb_forward(struct ahash_request *req,
+			       struct cmh_hmac_reqctx *rctx)
+{
+	struct ahash_request *fb_req = cmh_hmac_fb_req(rctx);
+	int ret;
+
+	if (req->base.flags & CRYPTO_AHASH_REQ_VIRT) {
+		ret = cmh_hmac_fb_update_virt(fb_req, req->svirt, req->nbytes);
+	} else {
+		ahash_request_set_crypt(fb_req, req->src, NULL, req->nbytes);
+		ret = crypto_ahash_update(fb_req);
+	}
+	if (ret)
+		rctx->error = ret;
+	return ret;
+}
+
+static int cmh_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
+			   unsigned int keylen)
+{
+	struct cmh_hmac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	int ret;
+
+	ret = cmh_key_setkey_raw(&tctx->key, key, keylen, CORE_ID_HC);
+	if (ret)
+		return ret;
+
+	/* Keep the software fallback keyed in lock-step for oversized ops. */
+	return crypto_ahash_setkey(tctx->fb, key, keylen);
+}
+
+static int cmh_hmac_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_hmac_reqctx *rctx = ahash_request_ctx(req);
+
+	rctx->info = cmh_hmac_get_info(tfm);
+	rctx->error = 0;
+	INIT_LIST_HEAD(&rctx->chunks);
+	rctx->num_chunks = 0;
+	rctx->total_len = 0;
+	rctx->switched = false;
+
+	return 0;
+}
+
+static int cmh_hmac_update(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_hmac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_hmac_reqctx *rctx = ahash_request_ctx(req);
+	struct cmh_hmac_chunk *chunk;
+	int nents;
+
+	if (rctx->error)
+		return rctx->error;
+
+	if (!req->nbytes)
+		return 0;
+
+	/* Already handed off to the fallback: forward directly (O(1) mem). */
+	if (rctx->switched)
+		return cmh_hmac_fb_forward(req, rctx);
+
+	/*
+	 * Exceeding the HW input cap: switch to the software fallback
+	 * (replaying the buffered chunks) rather than failing, then
+	 * forward this update.
+	 */
+	if (req->nbytes > HMAC_MAX_DATA - rctx->total_len) {
+		rctx->error = cmh_hmac_switch_to_fb(req);
+		if (rctx->error)
+			goto err_free_chunks;
+		return cmh_hmac_fb_forward(req, rctx);
+	}
+
+	chunk = kmalloc(sizeof(*chunk) + req->nbytes,
+			req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+			GFP_KERNEL : GFP_ATOMIC);
+	if (!chunk) {
+		rctx->error = -ENOMEM;
+		goto err_free_chunks;
+	}
+
+	chunk->len = req->nbytes;
+	if (req->base.flags & CRYPTO_AHASH_REQ_VIRT) {
+		memcpy(chunk->data, req->svirt, req->nbytes);
+	} else {
+		nents = sg_nents_for_len(req->src, req->nbytes);
+		if (nents < 0 ||
+		    sg_copy_to_buffer(req->src, nents,
+				      chunk->data, req->nbytes) != req->nbytes) {
+			kfree_sensitive(chunk);
+			rctx->error = -EINVAL;
+			goto err_free_chunks;
+		}
+	}
+
+	list_add_tail(&chunk->list, &rctx->chunks);
+	spin_lock_bh(&tctx->chunk_lock);
+	list_add_tail(&chunk->tfm_node, &tctx->all_chunks);
+	spin_unlock_bh(&tctx->chunk_lock);
+	rctx->num_chunks++;
+	rctx->total_len += req->nbytes;
+
+	return 0;
+
+err_free_chunks:
+	/*
+	 * Terminal error -- free all previously accumulated chunks.
+	 * The crypto API hash path does not call .final()
+	 * on error, and hash_sock_destruct has no per-request
+	 * destructor, so chunks would be orphaned otherwise.
+	 */
+	cmh_hmac_free_chunks(rctx, tctx);
+	return rctx->error;
+}
+
+static void cmh_hmac_complete(void *data, int error)
+{
+	struct ahash_request *req = data;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_hmac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_hmac_reqctx *rctx = ahash_request_ctx(req);
+
+	if (error == -EINPROGRESS) {
+		cmh_complete(&req->base, error);
+		return;
+	}
+
+	cmh_dma_unmap_single(rctx->digest_dma, rctx->info->digest_size,
+			     DMA_FROM_DEVICE);
+
+	if (!error)
+		memcpy(req->result, rctx->digest_buf,
+		       rctx->info->digest_size);
+
+	kfree(rctx->digest_buf);
+	rctx->digest_buf = NULL;
+	cmh_dma_free_sg(rctx->sgm);
+	rctx->sgm = NULL;
+	cmh_hmac_free_chunks(rctx, tctx);
+	cmh_complete(&req->base, error);
+}
+
+static int cmh_hmac_final(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_hmac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_hmac_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_hmac_alg_info *info = rctx->info;
+	struct vcq_cmd cmds[CMH_HMAC_MAX_PAYLOAD];
+	struct cmh_sg_map *sgm = NULL;
+	dma_addr_t digest_dma = DMA_MAPPING_ERROR, key_dma = DMA_MAPPING_ERROR;
+	u8 *digest_buf;
+	u64 key_ref;
+	u32 keylen;
+	struct core_dispatch d;
+	s32 target_mbx;
+	u32 core_id;
+	u32 idx;
+	int ret;
+	gfp_t gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		   GFP_KERNEL : GFP_ATOMIC;
+
+	if (rctx->error) {
+		ret = rctx->error;
+		goto out_free;
+	}
+
+	/* Switched to the software fallback: complete there (synchronous). */
+	if (rctx->switched) {
+		struct ahash_request *fb_req = cmh_hmac_fb_req(rctx);
+
+		ahash_request_set_crypt(fb_req, NULL, req->result, 0);
+		return crypto_ahash_final(fb_req);
+	}
+
+	if (tctx->key.mode == CMH_KEY_NONE) {
+		ret = -ENOKEY;
+		goto out_free;
+	}
+
+	if (rctx->num_chunks > 0) {
+		sgm = cmh_hmac_build_sg(rctx, gfp);
+		if (!sgm) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+	}
+
+	digest_buf = kzalloc(info->digest_size, gfp);
+	if (!digest_buf) {
+		ret = -ENOMEM;
+		goto out_free_sg;
+	}
+	digest_dma = cmh_dma_map_single(digest_buf, info->digest_size,
+					DMA_FROM_DEVICE);
+	if (cmh_dma_map_error(digest_dma)) {
+		ret = -ENOMEM;
+		goto out_free_digest;
+	}
+
+	/* Resolve key reference */
+	idx = 0;
+
+	/*
+	 * Raw key: pack SYS_CMD_WRITE(SYS_REF_TEMP) into the
+	 * same VCQ so the key write + HMAC are atomic.
+	 */
+	key_dma = tctx->key.raw.dma;
+	vcq_add_sys_write(&cmds[idx++], SYS_REF_TEMP, (u64)key_dma,
+			  SYS_REF_NONE, tctx->key.raw.len,
+			  tctx->key.raw.sys_type);
+	key_ref = SYS_REF_TEMP;
+	keylen = tctx->key.raw.len;
+	d = cmh_core_select_instance(CMH_CORE_HC);
+
+	target_mbx = d.mbx_idx;
+
+	core_id = d.core_id;
+
+	vcq_add_hc_hmac(&cmds[idx++], core_id, key_ref, keylen, info->hc_algo);
+
+	if (sgm)
+		vcq_add_hc_gather(&cmds[idx++], core_id, (u64)sgm->items_dma,
+				  HC_CMD_UPDATE);
+
+	vcq_add_hc_final(&cmds[idx++], core_id, (u64)digest_dma, info->digest_size);
+	vcq_add_flush(&cmds[idx++], core_id);
+
+	rctx->digest_buf = digest_buf;
+	rctx->digest_dma = digest_dma;
+	rctx->sgm = sgm;
+
+	ret = cmh_vcq_pack_and_submit_async(cmds, idx, rctx->packed,
+					    CMH_HMAC_MAX_PACKED,
+					    target_mbx,
+					    cmh_hmac_complete, req,
+					    !!(req->base.flags &
+					       CRYPTO_TFM_REQ_MAY_BACKLOG),
+					    cmh_tm_async_timeout_jiffies());
+	if (ret == -EBUSY)
+		return -EBUSY;
+	if (ret)
+		goto out_cleanup_all;
+
+	return -EINPROGRESS;
+
+out_cleanup_all:
+	cmh_dma_unmap_single(digest_dma, info->digest_size,
+			     DMA_FROM_DEVICE);
+out_free_digest:
+	kfree(digest_buf);
+
+out_free_sg:
+	cmh_dma_free_sg(sgm);
+
+out_free:
+	cmh_hmac_free_chunks(rctx, tctx);
+	return ret;
+}
+
+static int cmh_hmac_finup(struct ahash_request *req)
+{
+	int ret;
+
+	ret = cmh_hmac_update(req);
+	if (ret)
+		return ret;
+
+	return cmh_hmac_final(req);
+}
+
+static int cmh_hmac_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = cmh_hmac_init(req);
+	if (ret)
+		return ret;
+
+	return cmh_hmac_finup(req);
+}
+
+/*
+ * ahash .export()/.import(): serialize/deserialize the software
+ * accumulation buffer.  No HW state is involved.
+ */
+
+static int cmh_hmac_export(struct ahash_request *req, void *out)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_hmac_reqctx *rctx = ahash_request_ctx(req);
+	struct cmh_hmac_export_state *state = out;
+	struct cmh_hmac_chunk *chunk;
+	u32 offset = 0;
+	int ret;
+
+	/*
+	 * If more data is buffered than the flat window holds, switch to
+	 * the software fallback so a bounded, fixed-size state can be
+	 * exported -- making export/import (clone) work at any length.
+	 */
+	if (!rctx->switched && rctx->total_len > CMH_HMAC_EXPORT_MAX) {
+		ret = cmh_hmac_switch_to_fb(req);
+		if (ret)
+			return ret;
+	}
+
+	/* Zero the whole state buffer so no kernel memory leaks out. */
+	memset(state, 0, crypto_ahash_statesize(tfm));
+
+	if (rctx->switched) {
+		state->format = CMH_HMAC_FMT_FB;
+		return crypto_ahash_export(cmh_hmac_fb_req(rctx), state->data);
+	}
+
+	state->format = CMH_HMAC_FMT_RAW;
+	state->total_len = rctx->total_len;
+	list_for_each_entry(chunk, &rctx->chunks, list) {
+		memcpy(state->data + offset, chunk->data, chunk->len);
+		offset += chunk->len;
+	}
+	return 0;
+}
+
+static int cmh_hmac_import(struct ahash_request *req, const void *in)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_hmac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_hmac_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_hmac_export_state *state = in;
+	struct cmh_hmac_chunk *chunk;
+
+	/*
+	 * Do NOT call free_chunks() here: the crypto API does not
+	 * guarantee the request context is in a valid state before
+	 * import(), so the list pointers may be stale or invalid.
+	 * Re-initialize from scratch instead.  Any pre-existing chunks
+	 * are tracked on tctx->all_chunks and freed in cra_exit.
+	 */
+	rctx->info = cmh_hmac_get_info(tfm);
+	rctx->error = 0;
+	INIT_LIST_HEAD(&rctx->chunks);
+	rctx->num_chunks = 0;
+	rctx->total_len = 0;
+	rctx->switched = false;
+
+	/* Fallback-format state: replay it into a fallback request. */
+	if (state->format == CMH_HMAC_FMT_FB) {
+		struct ahash_request *fb_req = cmh_hmac_fb_req(rctx);
+		int ret;
+
+		ahash_request_set_tfm(fb_req, tctx->fb);
+		ahash_request_set_callback(fb_req, 0, NULL, NULL);
+		ret = crypto_ahash_import(fb_req, state->data);
+		if (ret)
+			return ret;
+		rctx->switched = true;
+		return 0;
+	}
+
+	if (state->format != CMH_HMAC_FMT_RAW)
+		return -EINVAL;
+
+	if (state->total_len > CMH_HMAC_EXPORT_MAX)
+		return -EINVAL;
+
+	if (state->total_len) {
+		chunk = kmalloc(sizeof(*chunk) + state->total_len,
+				req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+				GFP_KERNEL : GFP_ATOMIC);
+		if (!chunk)
+			return -ENOMEM;
+		chunk->len = state->total_len;
+		memcpy(chunk->data, state->data, state->total_len);
+		list_add_tail(&chunk->list, &rctx->chunks);
+		spin_lock_bh(&tctx->chunk_lock);
+		list_add_tail(&chunk->tfm_node, &tctx->all_chunks);
+		spin_unlock_bh(&tctx->chunk_lock);
+		rctx->num_chunks = 1;
+		rctx->total_len = state->total_len;
+	}
+	return 0;
+}
+
+/* Transform init/exit (cra_init/cra_exit) */
+
+static int cmh_hmac_cra_init(struct crypto_tfm *tfm)
+{
+	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
+	struct cmh_hmac_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct crypto_ahash *fb;
+
+	memset(tctx, 0, sizeof(*tctx));
+	tctx->key.mode = CMH_KEY_NONE;
+	spin_lock_init(&tctx->chunk_lock);
+	INIT_LIST_HEAD(&tctx->all_chunks);
+
+	/*
+	 * Allocate the generic software fallback used when the HW input cap
+	 * is exceeded or an oversized clone is exported.  Masking out
+	 * CRYPTO_ALG_ASYNC excludes this (async) driver, so the allocator
+	 * picks the generic hmac; its request is embedded after the reqctx.
+	 */
+	fb = crypto_alloc_ahash(crypto_ahash_alg_name(ahash), 0,
+				CRYPTO_ALG_ASYNC);
+	if (IS_ERR(fb))
+		return PTR_ERR(fb);
+	tctx->fb = fb;
+
+	/*
+	 * The FB-format export copies the fallback's state into the flat
+	 * window (state->data, CMH_HMAC_EXPORT_MAX bytes).  If the fallback's
+	 * statesize exceeds that, crypto_ahash_export() would overrun the
+	 * driver's export buffer -- refuse to instantiate instead.
+	 */
+	if (crypto_ahash_statesize(fb) > CMH_HMAC_EXPORT_MAX) {
+		crypto_free_ahash(fb);
+		tctx->fb = NULL;
+		return -EINVAL;
+	}
+
+	crypto_ahash_set_reqsize(ahash,
+				 sizeof(struct cmh_hmac_reqctx) +
+				 crypto_tfm_ctx_alignment() +
+				 sizeof(struct ahash_request) +
+				 crypto_ahash_reqsize(fb));
+	return 0;
+}
+
+static void cmh_hmac_cra_exit(struct crypto_tfm *tfm)
+{
+	struct cmh_hmac_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct cmh_hmac_chunk *chunk, *tmp;
+
+	/* Free any orphaned chunks (e.g. testmgr export/reimport poison) */
+	spin_lock_bh(&tctx->chunk_lock);
+	list_for_each_entry_safe(chunk, tmp, &tctx->all_chunks, tfm_node) {
+		list_del(&chunk->tfm_node);
+		kfree_sensitive(chunk);
+	}
+	spin_unlock_bh(&tctx->chunk_lock);
+
+	if (tctx->fb)
+		crypto_free_ahash(tctx->fb);
+	cmh_key_destroy(&tctx->key);
+}
+
+/* Registration */
+
+static struct cmh_hmac_alg_drv cmh_hmac_drvs[CMH_HMAC_ALG_COUNT];
+
+/**
+ * cmh_hmac_register() - Register HMAC-SHA hash algorithms with the crypto framework
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_hmac_register(void)
+{
+	unsigned int i;
+	int ret;
+
+	if (!cmh_core_present(CMH_CORE_HC))
+		return 0;
+
+	for (i = 0; i < CMH_HMAC_ALG_COUNT; i++) {
+		const struct cmh_hmac_alg_info *info = &cmh_hmac_algs_info[i];
+		struct cmh_hmac_alg_drv *drv = &cmh_hmac_drvs[i];
+		struct ahash_alg *alg = &drv->alg;
+
+		drv->info = info;
+
+		alg->init   = cmh_hmac_init;
+		alg->update = cmh_hmac_update;
+		alg->final  = cmh_hmac_final;
+		alg->finup  = cmh_hmac_finup;
+		alg->digest = cmh_hmac_digest;
+		alg->export = cmh_hmac_export;
+		alg->import = cmh_hmac_import;
+		alg->setkey = cmh_hmac_setkey;
+
+		alg->halg.digestsize = info->digest_size;
+		alg->halg.statesize  = CMH_HMAC_STATE_SIZE;
+
+		strscpy(alg->halg.base.cra_name, info->alg_name,
+			CRYPTO_MAX_ALG_NAME);
+		strscpy(alg->halg.base.cra_driver_name, info->drv_name,
+			CRYPTO_MAX_ALG_NAME);
+		alg->halg.base.cra_priority    = 300;
+		alg->halg.base.cra_flags       = CRYPTO_ALG_KERN_DRIVER_ONLY |
+						 CRYPTO_ALG_NO_FALLBACK |
+						 CRYPTO_ALG_ASYNC |
+						 CRYPTO_ALG_REQ_VIRT;
+		alg->halg.base.cra_blocksize   = info->block_size;
+		alg->halg.base.cra_ctxsize     = sizeof(struct cmh_hmac_tfm_ctx);
+		alg->halg.base.cra_init        = cmh_hmac_cra_init;
+		alg->halg.base.cra_exit        = cmh_hmac_cra_exit;
+		alg->halg.base.cra_module      = THIS_MODULE;
+
+		ret = crypto_register_ahash(alg);
+		if (ret) {
+			dev_err(cmh_dev(), "hmac: failed to register %s (rc=%d)\n",
+				info->drv_name, ret);
+			while (i--)
+				crypto_unregister_ahash(&cmh_hmac_drvs[i].alg);
+			return ret;
+		}
+
+		dev_dbg(cmh_dev(), "hmac: registered %s (priority 300)\n",
+			info->drv_name);
+	}
+
+	return 0;
+}
+
+/**
+ * cmh_hmac_unregister() - Unregister HMAC-SHA hash algorithms from the crypto framework
+ */
+void cmh_hmac_unregister(void)
+{
+	unsigned int i;
+
+	if (!cmh_core_present(CMH_CORE_HC))
+		return;
+
+	for (i = 0; i < CMH_HMAC_ALG_COUNT; i++) {
+		crypto_unregister_ahash(&cmh_hmac_drvs[i].alg);
+		dev_dbg(cmh_dev(), "hmac: unregistered %s\n",
+			cmh_hmac_algs_info[i].drv_name);
+	}
+}
diff --git a/drivers/crypto/cmh/cmh_main.c b/drivers/crypto/cmh/cmh_main.c
index 50218f19ad6f..589363cc4b28 100644
--- a/drivers/crypto/cmh/cmh_main.c
+++ b/drivers/crypto/cmh/cmh_main.c
@@ -32,6 +32,7 @@
 #include "cmh_txn.h"
 #include "cmh_rh.h"
 #include "cmh_hash.h"
+#include "cmh_hmac.h"
 #include "cmh_mgmt.h"
 #include "cmh_registers.h"
 #include "cmh_debugfs.h"
@@ -208,6 +209,11 @@ static int cmh_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_hash_register;
 
+	/* Register HMAC hash algorithms */
+	ret = cmh_hmac_register();
+	if (ret)
+		goto err_hmac_register;
+
 	/* Register key management device (/dev/cmh_mgmt) */
 	ret = cmh_mgmt_register();
 	if (ret)
@@ -218,6 +224,8 @@ static int cmh_probe(struct platform_device *pdev)
 	return 0;
 
 err_mgmt_register:
+	cmh_hmac_unregister();
+err_hmac_register:
 	cmh_hash_unregister();
 err_hash_register:
 	cmh_rh_cleanup(cfg);
@@ -246,6 +254,7 @@ static void cmh_remove(struct platform_device *pdev)
 	cfg = &dev->config;
 
 	cmh_mgmt_unregister();
+	cmh_hmac_unregister();
 	cmh_hash_unregister();
 	cmh_rh_cleanup(cfg);
 	cmh_tm_cleanup();
diff --git a/drivers/crypto/cmh/include/cmh_hmac.h b/drivers/crypto/cmh/include/cmh_hmac.h
new file mode 100644
index 000000000000..fb1a11fb76eb
--- /dev/null
+++ b/drivers/crypto/cmh/include/cmh_hmac.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Kernel Crypto API HMAC Driver
+ *
+ * Registers HMAC ahash algorithms (HMAC-SHA-2, HMAC-SHA-3) with the
+ * Linux crypto subsystem using HC_CMD_HMAC.
+ */
+
+#ifndef CMH_HMAC_H
+#define CMH_HMAC_H
+
+int  cmh_hmac_register(void);
+void cmh_hmac_unregister(void);
+
+#endif /* CMH_HMAC_H */
-- 
2.43.7

