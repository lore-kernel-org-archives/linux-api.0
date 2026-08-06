Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022093.outbound.protection.outlook.com [40.107.200.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F85494832;
	Thu,  6 Aug 2026 19:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046143; cv=fail; b=BnCjdxSCr5zZc5GodeoeZjHgGXO9oOdwTYs05YCzAvYy++xCypFZl+1k6Kh3ZepEuiFoUXH7VTPaoTeQaWWL2UB0zWoydItklDDn/l1n3JFZdMYIRh1/Mm7K7kzEryAllQUwEB4LcCn66xdOBu37mYgxSFlkBD9z9vuQSxU3AKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046143; c=relaxed/simple;
	bh=J55bOBY9EjOtZrUs4iBpwAeNAgdH1DMja27uxCnI+zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ULDZ8RPX1KzWNN3QHdJBR7FS3utnRmiC8sQqXXnuhOyynYGMp5ntQJjpXhQMjcN9tF6LNodLJBelwTKqas2ogGfpeRfQc9K2/2mj8xHbCOTYZpg3MSjq5oNgfQY8MBKlFJxd8aUjWMu+SXNopnDXj3uKP5Qd3ySO4yp89IcIYVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=RHwA0493; arc=fail smtp.client-ip=40.107.200.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="RHwA0493"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=urjkOdcNtyvb/SPlaEYv6ED0FASfIB/3Y4GOVAfg2WTmXF9uRC95YfOoyK5D2b1Zqi56QNKbCLY/gcyDlWTWBCBAjb9NLA/uUYolqbjlWpukAg+jhx1Tf4AiSM2w3C42EdsFsJus10JznEoTCqul6TfgdMJjiF9jGrKiN7EYJ9vi8bzhDwmWimILeDodTEml8WcyY2hzFXtGyUkS4/asVF23QlyoCEtkIV7WQr42sAzcOUL+Drh19G49CrLpcfGTO8f4aF/AKJdVFIEHRHD9XGFgSLlxNnVvNBzbyssSebilY5zDGkG9wqkG5l10B5IhQIKEMo83JHgudH2FbaA5Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fExLKTen6CkXD3J7Z7RgzO/Fwr4tgkUAu07EPoxBDdI=;
 b=OahTmbohNP9gnoKAFZhv4PZGTH44/Jo9ycdQk36FO/0aUGOz6InuPz6VaD1MfdBNRyFEBIstfC1nV3a5xKoJfwMcKcCd4THz2fBYSu6l9uQaP/cejL4Dd2ugGTRztrdaM6Drb8pMogO2oI1aCtWO/FkV0PziupXd841BHanpRwlmjkY5FmdTFbnw4dWSUbQsBp8Q/bh3Gg9Whoo0LrUEOhnblQREOShpua1BgNqrBjv/kC2/Xqqa7pR2N7boJa6Wz5eim1MgQfvNncER8Hs6FcCjVdkUgpMRek1RErpO7Qrne/WhhbrKt3LhPuhOLIa3CjTDtHDC8GjxTIFnNH2CyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fExLKTen6CkXD3J7Z7RgzO/Fwr4tgkUAu07EPoxBDdI=;
 b=RHwA049388eZVCgymmw7yjHJaAf7jFqNZ6rNdsEeqn1l1kBLpqCOELxlU/My7Vuu9f4wK95yY1DT8d9oGuuWq/Hpcyu5EpoSvqnkLeBzwkIGcAt/DT/crapRzO9U/m16ECMbt3VjFXSbMIAvFUsCOOP6c3fZzRma4L603eVsabgh5Rf6tZuEvn8wbMf8sF3MTKQcjm04YR6g/Jg2Ymlo7gDqiFPLu4o7vUU8EDT+1C6bqW1qXMYbEO3+xO9HbTIi8REMrvJRb92pzVfuBUh0v7lSX7mkmCVsxYVsWdPZqgxQHVSaqqSZSKG7CnnvU+UJ3LksVDuhS2L5wBFMBqKIlA==
Received: from BL1PR13CA0436.namprd13.prod.outlook.com (2603:10b6:208:2c3::21)
 by DSWPR04MB10000.namprd04.prod.outlook.com (2603:10b6:8:361::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Thu, 6 Aug
 2026 19:55:29 +0000
Received: from BL02EPF0001A103.namprd05.prod.outlook.com
 (2603:10b6:208:2c3:cafe::42) by BL1PR13CA0436.outlook.office365.com
 (2603:10b6:208:2c3::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.7 via Frontend Transport; Thu, 6
 Aug 2026 19:55:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BL02EPF0001A103.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Thu, 6 Aug 2026 19:55:28 +0000
Received: from hqxsv-cmdev3-skrishnamoorthy.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTPS id 9FA6F1801760;
	Thu,  6 Aug 2026 19:55:27 +0000 (UTC)
From: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
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
Subject: [PATCH v3 06/19] crypto: cmh - add CSHAKE/KMAC ahash
Date: Thu,  6 Aug 2026 12:55:05 -0700
Message-ID: <20260806195519.2703224-7-skrishnamoorthy@rambus.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
References: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A103:EE_|DSWPR04MB10000:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: eb3edaa6-a660-4272-812f-08def3f4aa5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|82310400026|376014|7416014|11063799006|56012099006|10067099003|22082099003|18002099003|3023799007|921020;
X-Microsoft-Antispam-Message-Info:
	DYrCC1dPup2PpIldw6kituCyBKSxd2Qdeg/DLPnlDN8wK1g5FHLDk+yPhQEE5v8wNTtwA7QdpZEYOXmd7dQ2E+LAou0RKSBMci0gMUBOrDpGqo6o+qjgFBC2M0nIalFLYhFtu6jaRVM9BJngOyJf5QM3ErPuNukFumkZvqAD+h7YRelOz7rPpyNyM7M0nncMmdGcwv9EZKPTEe2bD4CPSkQpUdSSCGko2PJ2kkbfTa70rUbZc1KEIFZhPcTGzbuCVt3aeLQenh4Ryb78QDrlsSHzWOauaQPlpyUYkH1JXZryoZw6ugNsGGeOBc3uQEm0FiaYycNZKloiEJOFsLCZIgTY1okUYVu6tOoAsYMzfGmYNrA1byfrsGFHHXjuhvrPjeZd3WKirfSVe1jIZVBILmPnqZsgSVwGgOUif5o9LYClOWlBY7fmZ5ZfTsFl/nWlS6iiIoN0lEezTWL1mm430XjazmVkOkXBANqGMuQU2xrnRLpJGFXo9EEOKSzfb9TVJu7SsxMKlne7XYlAsznX1B09I58zkqmyoCFKtEHs/pfsLObHfAE9WuwnUzGa3zO7UAgscqD7wMlQ8ZT++qm+WSUJeBt6QU6/OxOUl0CcRpcxJRbUfmRYsBaxIB7Hv3T62CCol/QfGGVNLmagi3vdtjt//REAFVmSrKekV+Ekhs0XF8N4DLjXB8aOpgrsSMuiM2KGqWOyayuBWoMD5k4d6ZFdxuZqtIzo+Jv2VPhmTtXPY+M3t6dBwIdAzgGVhP5D
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(82310400026)(376014)(7416014)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(3023799007)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	o/lmpaYMW4CqeQSGl+6s9crpoLj063yoVqFK689zXl5WVMo6GFBNZqoAIq40Np+axgJdhyy4xlEiI/V8JPw9jkOXrpXQFweMBT0qmVi3SrUxcHKIwEX6wGl68G+Zz51e8uVqm+LpVZTBd+juR3+CIfbT0ybNskBNPCzZzLw24iELoHazXGjZCr6kgrVbk/8H0OjOsF+5vzP/4oQt8LhMBjXWB0/7L1Kqpx2cYcjINqmt7c223iv2vnwheol1PjifW4wR6r01wIX1DkSw6tlQZYPEBQrXu2b34SXvK/2G6vilwWBjjwEAD2XvP/Ig20eXv94Ff5BlPU77V7C57ZRXHSbfjUKEuxvc8lYLIK8RlP9vqDLRtmp+Iu3TNn1DV9m6XHAE/pwG7Zc+zgajEawGm3P2GypYYOxPLDJmK/t5I6DR3lzRZ4qqwQkteYlgVt/k
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 19:55:28.6372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb3edaa6-a660-4272-812f-08def3f4aa5c
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A103.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR04MB10000

From: Alex Ousherovitch <aousherovitch@rambus.com>

Register ahash algorithms for cSHAKE128, cSHAKE256, KMAC128, and
KMAC256 using the CMH hash core.  cSHAKE supports incremental
update and export/import.  KMAC has a 64KB data cap imposed by the
hardware.

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
Reviewed-by: Thi Nguyen <thin@rambus.com>
---
 drivers/crypto/cmh/Makefile             |   4 +-
 drivers/crypto/cmh/cmh_cshake.c         | 814 ++++++++++++++++++++++++
 drivers/crypto/cmh/cmh_kmac.c           | 630 ++++++++++++++++++
 drivers/crypto/cmh/cmh_main.c           |  18 +
 drivers/crypto/cmh/include/cmh_cshake.h |  16 +
 drivers/crypto/cmh/include/cmh_kmac.h   |  16 +
 6 files changed, 1497 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/cmh/cmh_cshake.c
 create mode 100644 drivers/crypto/cmh/cmh_kmac.c
 create mode 100644 drivers/crypto/cmh/include/cmh_cshake.h
 create mode 100644 drivers/crypto/cmh/include/cmh_kmac.h

diff --git a/drivers/crypto/cmh/Makefile b/drivers/crypto/cmh/Makefile
index acd1827cc084..3ab154744658 100644
--- a/drivers/crypto/cmh/Makefile
+++ b/drivers/crypto/cmh/Makefile
@@ -16,7 +16,9 @@ cmh-y := \
 	cmh_key.o \
 	cmh_sys.o \
 	cmh_hash.o \
-	cmh_hmac.o
+	cmh_hmac.o \
+	cmh_cshake.o \
+	cmh_kmac.o
 
 # Management ioctl device (/dev/cmh_mgmt): key lifecycle, PKE, PQC ioctls.
 cmh-$(CONFIG_CRYPTO_DEV_CMH_MGMT) += \
diff --git a/drivers/crypto/cmh/cmh_cshake.c b/drivers/crypto/cmh/cmh_cshake.c
new file mode 100644
index 000000000000..acba3f2f6f3c
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_cshake.c
@@ -0,0 +1,814 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Kernel Crypto API CSHAKE Driver
+ *
+ * Registers cSHAKE-128 and cSHAKE-256 as ahash algorithms using the
+ * CMH Hash Core (HC) via HC_CMD_CSHAKE.
+ *
+ * CSHAKE (NIST SP 800-185) extends SHAKE with two domain separation
+ * parameters: function name N and customization string S.  When both
+ * are empty, cSHAKE reduces to plain SHAKE -- the driver falls back to
+ * HC_CMD_INIT in that case (per SP 800-185 S6.2).
+ *
+ * N and S are set via .setkey() using a self-describing binary header
+ * (matching the upstream authenc precedent):
+ *
+ *   struct cshake_cfg { __be32 n_len; __be32 s_len; };
+ *   setkey blob: cshake_cfg || N[n_len] || S[s_len]
+ *
+ * If .setkey() is never called, the driver defaults to plain SHAKE
+ * (N="" S="").  .setkey() is per-tfm, not per-request.
+ *
+ * N is embedded inline in the HC_CMD_CSHAKE struct (max 36 bytes).
+ * S is passed as VCQ inline data following the command slot (multi-span).
+ *
+ * Uses the same self-contained transaction model as cmh_hash.c:
+ *   .init()   -> software-only
+ *   .update() -> software-only (accumulate chunks)
+ *   .final()  -> CSHAKE [+ inline S] [+ RESTORE] [+ GATHER] + FINAL + FLUSH
+ *   .export() -> CSHAKE [+ inline S] [+ RESTORE] [+ GATHER] + SAVE + FLUSH
+ *   .import() -> restore HC context checkpoint (software-only)
+ *
+ * The HC core supports HC_CMD_SAVE / HC_CMD_RESTORE for cSHAKE mode.
+ * The cSHAKE domain-separation prefix (function name N, customization
+ * string S) is absorbed into the Keccak sponge state by HC_CMD_CSHAKE
+ * on the first submission, and preserved through save/restore.
+ * Export/import enables crypto API transform cloning.
+ *
+ * .setkey() here configures public domain-separation parameters (N, S),
+ * not a secret key.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/crypto.h>
+#include <crypto/internal/hash.h>
+#include <linux/scatterlist.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <asm/byteorder.h>
+
+#include "cmh_cshake.h"
+#include "cmh_vcq.h"
+#include "cmh_hc_abi.h"
+#include "cmh_txn.h"
+#include "cmh_dma.h"
+
+/* Algorithm Table */
+
+struct cmh_cshake_alg_info {
+	u32         hc_algo;
+	u32         digest_size;
+	const char *alg_name;
+	const char *drv_name;
+};
+
+static const struct cmh_cshake_alg_info cmh_cshake_algs_info[] = {
+	{
+		.hc_algo     = HC_ALGO_SHAKE128,
+		.digest_size = CMH_SHAKE128_DIGEST_SIZE,
+		.alg_name    = "cshake128",
+		.drv_name    = "rambus-cmh-cshake128",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHAKE256,
+		.digest_size = CMH_SHAKE256_DIGEST_SIZE,
+		.alg_name    = "cshake256",
+		.drv_name    = "rambus-cmh-cshake256",
+	},
+};
+
+#define CMH_CSHAKE_ALG_COUNT  ARRAY_SIZE(cmh_cshake_algs_info)
+
+/* Per-Request State */
+
+struct cmh_cshake_chunk {
+	struct list_head  list;
+	struct list_head  tfm_node; /* per-tfm orphan tracking */
+	u32               len;
+	u8                data[];
+};
+
+/*
+ * Max payload slots for CSHAKE:
+ *   CSHAKE (1) + inline S (ceil(S_len/64)) + GATHER (1) + FINAL (1) + FLUSH (1)
+ * S can be up to SHAKE-128 block (168 bytes) = 3 inline slots.
+ * Conservative: 1 + 3 + 1 + 1 + 1 = 7, plus headers.
+ *
+ * Or INIT + GATHER + FINAL + FLUSH = 4 (plain SHAKE fallback).
+ */
+#define CMH_CSHAKE_MAX_PAYLOAD   8
+#define CMH_CSHAKE_MAX_PACKED    (CMH_CSHAKE_MAX_PAYLOAD * 2)
+
+/*
+ * Checkpoint embedded inline: the kernel ahash API has no per-request
+ * destructor, so a heap-allocated checkpoint leaks if a request is
+ * abandoned without .final().
+ */
+struct cmh_cshake_reqctx {
+	const struct cmh_cshake_alg_info *info;
+	int                               error;
+	struct list_head                  chunks;
+	u32                               num_chunks;
+	u32                               total_len;
+	u32                               has_checkpoint;
+	u8                                checkpoint[HC_CONTEXT_SIZE];
+	/* DMA state for async final */
+	dma_addr_t                        digest_dma;
+	dma_addr_t                        ckpt_dma;
+	u8                               *digest_buf;
+	struct cmh_sg_map                *sgm;
+	struct vcq_cmd packed[CMH_CSHAKE_MAX_PACKED];
+};
+
+/* Per-Transform State (carries N and S across requests) */
+
+struct cmh_cshake_tfm_ctx {
+	u8  *func_name;     /* N (function name), NULL if empty */
+	u32  func_name_len;
+	u8  *custom;        /* S (customization string), NULL if empty */
+	u32  custom_len;
+	spinlock_t         chunk_lock;  /* protects all_chunks */
+	struct list_head   all_chunks;  /* orphan-safe chunk tracking */
+};
+
+/* VCQ Builders */
+
+/* VCQ Builders (cSHAKE-specific; shared builders in cmh_hc_abi.h / cmh_vcq.h) */
+
+static void vcq_add_hc_save(struct vcq_cmd *slot, u32 core_id,
+			    u64 output_phys, u32 outlen)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HC_CMD_SAVE);
+	slot->hwc.hc.cmd_save.output = output_phys;
+	slot->hwc.hc.cmd_save.outlen = outlen;
+}
+
+static void vcq_add_hc_restore(struct vcq_cmd *slot, u32 core_id,
+			       u64 input_phys, u32 inlen)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HC_CMD_RESTORE);
+	slot->hwc.hc.cmd_restore.input = input_phys;
+	slot->hwc.hc.cmd_restore.inlen = inlen;
+}
+
+static void vcq_add_hc_cshake(struct vcq_cmd *slot, u32 core_id, u32 algo,
+			      const u8 *name, u32 namelen,
+			      u32 customlen)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HC_CMD_CSHAKE);
+	slot->hwc.hc.cmd_cshake.custom = 0;  /* inline -- CMH eSW reads from next slot(s) */
+	slot->hwc.hc.cmd_cshake.customlen = customlen;
+	slot->hwc.hc.cmd_cshake.algo = algo;
+	slot->hwc.hc.cmd_cshake.namelen = namelen;
+	if (namelen > 0 && name)
+		memcpy(slot->hwc.hc.cmd_cshake.name, name,
+		       min_t(u32, namelen, HC_CSHAKE_MAX_NAMELEN));
+}
+
+/* Request Context Cleanup */
+
+static void cmh_cshake_free_chunks(struct cmh_cshake_reqctx *rctx,
+				   struct cmh_cshake_tfm_ctx *tctx)
+{
+	struct cmh_cshake_chunk *chunk, *tmp;
+
+	spin_lock_bh(&tctx->chunk_lock);
+	list_for_each_entry_safe(chunk, tmp, &rctx->chunks, list) {
+		list_del(&chunk->list);
+		list_del(&chunk->tfm_node);
+		kfree(chunk);
+	}
+	spin_unlock_bh(&tctx->chunk_lock);
+	rctx->num_chunks = 0;
+	rctx->total_len = 0;
+}
+
+static void cmh_cshake_free_reqctx(struct cmh_cshake_reqctx *rctx,
+				   struct cmh_cshake_tfm_ctx *tctx)
+{
+	cmh_cshake_free_chunks(rctx, tctx);
+	rctx->has_checkpoint = 0;
+}
+
+static struct cmh_sg_map *
+cmh_cshake_build_sg(struct cmh_cshake_reqctx *rctx, gfp_t gfp)
+{
+	struct cmh_dma_buf *bufs;
+	struct cmh_cshake_chunk *chunk;
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
+struct cmh_cshake_alg_drv {
+	struct ahash_alg                   alg;
+	const struct cmh_cshake_alg_info  *info;
+};
+
+static const struct cmh_cshake_alg_info *
+cmh_cshake_get_info(struct crypto_ahash *tfm)
+{
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
+
+	return container_of(alg, struct cmh_cshake_alg_drv, alg)->info;
+}
+
+/*
+ * .setkey() -- parse N and S from the self-describing cshake_cfg header.
+ *
+ * Blob format: cshake_cfg { __be32 n_len; __be32 s_len; } || N || S
+ * If never called, the driver defaults to plain SHAKE (N="" S="").
+ */
+struct cshake_cfg {
+	__be32 n_len;
+	__be32 s_len;
+};
+
+static int cmh_cshake_setkey(struct crypto_ahash *tfm, const u8 *key,
+			     unsigned int keylen)
+{
+	struct cmh_cshake_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cshake_cfg cfg;
+	u32 n_len, s_len;
+	const u8 *ptr;
+
+	if (keylen < sizeof(cfg))
+		return -EINVAL;
+
+	memcpy(&cfg, key, sizeof(cfg));
+	n_len = be32_to_cpu(cfg.n_len);
+	s_len = be32_to_cpu(cfg.s_len);
+
+	if (keylen != sizeof(cfg) + n_len + s_len)
+		return -EINVAL;
+
+	if (n_len > HC_CSHAKE_MAX_NAMELEN)
+		return -EINVAL;
+
+	if (s_len > HC_CSHAKE_MAX_CUSTOMLEN)
+		return -EINVAL;
+
+	/* Free previous N and S */
+	kfree(tctx->func_name);
+	kfree(tctx->custom);
+	tctx->func_name = NULL;
+	tctx->func_name_len = 0;
+	tctx->custom = NULL;
+	tctx->custom_len = 0;
+
+	ptr = key + sizeof(cfg);
+
+	if (n_len > 0) {
+		tctx->func_name = kmemdup(ptr, n_len, GFP_KERNEL);
+		if (!tctx->func_name)
+			return -ENOMEM;
+		tctx->func_name_len = n_len;
+		ptr += n_len;
+	}
+
+	if (s_len > 0) {
+		tctx->custom = kmemdup(ptr, s_len, GFP_KERNEL);
+		if (!tctx->custom) {
+			kfree(tctx->func_name);
+			tctx->func_name = NULL;
+			tctx->func_name_len = 0;
+			return -ENOMEM;
+		}
+		tctx->custom_len = s_len;
+	}
+
+	return 0;
+}
+
+static int cmh_cshake_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+
+	rctx->info = cmh_cshake_get_info(tfm);
+	rctx->error = 0;
+	INIT_LIST_HEAD(&rctx->chunks);
+	rctx->num_chunks = 0;
+	rctx->total_len = 0;
+	rctx->has_checkpoint = 0;
+
+	return 0;
+}
+
+static int cmh_cshake_update(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_cshake_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+	struct cmh_cshake_chunk *chunk;
+	int nents;
+
+	if (rctx->error)
+		return rctx->error;
+
+	if (!req->nbytes)
+		return 0;
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
+			kfree(chunk);
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
+	 * The crypto API hash path does not call .final() on error,
+	 * so chunks would be orphaned otherwise.
+	 */
+	cmh_cshake_free_chunks(rctx, tctx);
+	return rctx->error;
+}
+
+static void cmh_cshake_complete(void *data, int error)
+{
+	struct ahash_request *req = data;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_cshake_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+
+	if (error == -EINPROGRESS) {
+		cmh_complete(&req->base, error);
+		return;
+	}
+
+	if (rctx->has_checkpoint)
+		cmh_dma_unmap_single(rctx->ckpt_dma, HC_CONTEXT_SIZE,
+				     DMA_TO_DEVICE);
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
+	cmh_cshake_free_reqctx(rctx, tctx);
+	cmh_complete(&req->base, error);
+}
+
+static int cmh_cshake_final(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_cshake_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_cshake_alg_info *info = rctx->info;
+	struct core_dispatch d;
+	struct vcq_cmd cmds[CMH_CSHAKE_MAX_PAYLOAD];
+	struct cmh_sg_map *sgm = NULL;
+	dma_addr_t digest_dma = DMA_MAPPING_ERROR;
+	dma_addr_t ckpt_dma = DMA_MAPPING_ERROR;
+	u8 *digest_buf;
+	u32 idx;
+	int ret;
+	gfp_t gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		     GFP_KERNEL : GFP_ATOMIC;
+
+	if (rctx->error) {
+		ret = rctx->error;
+		goto out_free;
+	}
+
+	if (rctx->num_chunks > 0) {
+		sgm = cmh_cshake_build_sg(rctx, gfp);
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
+	/* Map checkpoint buffer if present (CMH eSW reads it) */
+	if (rctx->has_checkpoint) {
+		ckpt_dma = cmh_dma_map_single(rctx->checkpoint,
+					      HC_CONTEXT_SIZE, DMA_TO_DEVICE);
+		if (cmh_dma_map_error(ckpt_dma)) {
+			ret = -ENOMEM;
+			goto out_unmap_digest;
+		}
+	}
+
+	d = cmh_core_select_instance(CMH_CORE_HC);
+	idx = 0;
+
+	if (rctx->has_checkpoint) {
+		/*
+		 * Resuming from a saved checkpoint (after export/import):
+		 * INIT + RESTORE [+ GATHER] + FINAL + FLUSH
+		 * The cSHAKE prefix (N,S) is already absorbed in the
+		 * saved Keccak state -- no need to replay HC_CMD_CSHAKE.
+		 */
+		vcq_add_hc_init(&cmds[idx++], d.core_id, info->hc_algo);
+		vcq_add_hc_restore(&cmds[idx++], d.core_id, (u64)ckpt_dma,
+				   HC_CONTEXT_SIZE);
+	} else {
+		bool use_cshake = (tctx->func_name_len > 0 ||
+				   tctx->custom_len > 0);
+
+		if (use_cshake) {
+			u32 span;
+
+			vcq_add_hc_cshake(&cmds[idx], d.core_id,
+					  info->hc_algo,
+					  tctx->func_name,
+					  tctx->func_name_len,
+					  tctx->custom_len);
+			span = vcq_add_inline_data(&cmds[idx],
+						   tctx->custom,
+						   tctx->custom_len);
+			idx += span;
+		} else {
+			vcq_add_hc_init(&cmds[idx++], d.core_id,
+					info->hc_algo);
+		}
+	}
+
+	if (sgm)
+		vcq_add_hc_gather(&cmds[idx++], d.core_id, (u64)sgm->items_dma,
+				  HC_CMD_UPDATE);
+
+	vcq_add_hc_final(&cmds[idx++], d.core_id, (u64)digest_dma, info->digest_size);
+	vcq_add_flush(&cmds[idx++], d.core_id);
+
+	rctx->digest_buf = digest_buf;
+	rctx->digest_dma = digest_dma;
+	rctx->ckpt_dma = ckpt_dma;
+	rctx->sgm = sgm;
+
+	ret = cmh_vcq_pack_and_submit_async(cmds, idx, rctx->packed,
+					    CMH_CSHAKE_MAX_PACKED,
+					    d.mbx_idx,
+					    cmh_cshake_complete, req,
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
+	if (rctx->has_checkpoint)
+		cmh_dma_unmap_single(ckpt_dma, HC_CONTEXT_SIZE,
+				     DMA_TO_DEVICE);
+out_unmap_digest:
+	cmh_dma_unmap_single(digest_dma, info->digest_size,
+			     DMA_FROM_DEVICE);
+out_free_digest:
+	kfree(digest_buf);
+
+out_free_sg:
+	cmh_dma_free_sg(sgm);
+
+out_free:
+	cmh_cshake_free_reqctx(rctx, tctx);
+	return ret;
+}
+
+static int cmh_cshake_finup(struct ahash_request *req)
+{
+	int ret;
+
+	ret = cmh_cshake_update(req);
+	if (ret)
+		return ret;
+
+	return cmh_cshake_final(req);
+}
+
+static int cmh_cshake_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = cmh_cshake_init(req);
+	if (ret)
+		return ret;
+
+	return cmh_cshake_finup(req);
+}
+
+static int cmh_cshake_export(struct ahash_request *req, void *out)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_cshake_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_cshake_alg_info *info = rctx->info;
+	struct core_dispatch d;
+	struct vcq_cmd cmds[CMH_CSHAKE_MAX_PAYLOAD];
+	struct cmh_sg_map *sgm = NULL;
+	dma_addr_t save_dma = DMA_MAPPING_ERROR;
+	dma_addr_t ckpt_dma = DMA_MAPPING_ERROR;
+	u8 *save_buf;
+	u32 idx;
+	int ret;
+
+	if (rctx->num_chunks > 0) {
+		sgm = cmh_cshake_build_sg(rctx, GFP_KERNEL);
+		if (!sgm)
+			return -ENOMEM;
+	}
+
+	save_buf = kzalloc(HC_CONTEXT_SIZE, GFP_KERNEL);
+	if (!save_buf) {
+		cmh_dma_free_sg(sgm);
+		return -ENOMEM;
+	}
+	save_dma = cmh_dma_map_single(save_buf, HC_CONTEXT_SIZE,
+				      DMA_FROM_DEVICE);
+	if (cmh_dma_map_error(save_dma)) {
+		kfree(save_buf);
+		cmh_dma_free_sg(sgm);
+		return -ENOMEM;
+	}
+
+	/* Map checkpoint buffer if present (CMH eSW reads it) */
+	if (rctx->has_checkpoint) {
+		ckpt_dma = cmh_dma_map_single(rctx->checkpoint,
+					      HC_CONTEXT_SIZE, DMA_TO_DEVICE);
+		if (cmh_dma_map_error(ckpt_dma)) {
+			cmh_dma_unmap_single(save_dma, HC_CONTEXT_SIZE,
+					     DMA_FROM_DEVICE);
+			kfree(save_buf);
+			cmh_dma_free_sg(sgm);
+			return -ENOMEM;
+		}
+	}
+
+	d = cmh_core_select_instance(CMH_CORE_HC);
+	idx = 0;
+
+	if (rctx->has_checkpoint) {
+		/*
+		 * Resuming from a saved checkpoint:
+		 * INIT + RESTORE [+ GATHER] + SAVE + FLUSH
+		 */
+		vcq_add_hc_init(&cmds[idx++], d.core_id, info->hc_algo);
+		vcq_add_hc_restore(&cmds[idx++], d.core_id, (u64)ckpt_dma,
+				   HC_CONTEXT_SIZE);
+	} else {
+		bool use_cshake = (tctx->func_name_len > 0 ||
+				   tctx->custom_len > 0);
+
+		if (use_cshake) {
+			u32 span;
+
+			vcq_add_hc_cshake(&cmds[idx], d.core_id,
+					  info->hc_algo,
+					  tctx->func_name,
+					  tctx->func_name_len,
+					  tctx->custom_len);
+			span = vcq_add_inline_data(&cmds[idx],
+						   tctx->custom,
+						   tctx->custom_len);
+			idx += span;
+		} else {
+			vcq_add_hc_init(&cmds[idx++], d.core_id,
+					info->hc_algo);
+		}
+	}
+
+	if (sgm)
+		vcq_add_hc_gather(&cmds[idx++], d.core_id, (u64)sgm->items_dma,
+				  HC_CMD_UPDATE);
+
+	vcq_add_hc_save(&cmds[idx++], d.core_id, (u64)save_dma,
+			HC_CONTEXT_SIZE);
+	vcq_add_flush(&cmds[idx++], d.core_id);
+
+	ret = cmh_vcq_pack_and_submit(cmds, idx, rctx->packed, CMH_CSHAKE_MAX_PACKED,
+				      d.mbx_idx);
+
+	/* Unmap before CPU read */
+	if (rctx->has_checkpoint)
+		cmh_dma_unmap_single(ckpt_dma, HC_CONTEXT_SIZE, DMA_TO_DEVICE);
+	cmh_dma_unmap_single(save_dma, HC_CONTEXT_SIZE, DMA_FROM_DEVICE);
+
+	/*
+	 * Free the gather map (which dma_unmaps each chunk buffer) BEFORE
+	 * freeing the chunk buffers themselves -- the DMA API requires a
+	 * mapping to be torn down before its memory is released.
+	 */
+	cmh_dma_free_sg(sgm);
+
+	if (!ret) {
+		memcpy(out, save_buf, HC_CONTEXT_SIZE);
+		/* Checkpoint now represents all accumulated state */
+		memcpy(rctx->checkpoint, save_buf, HC_CONTEXT_SIZE);
+		rctx->has_checkpoint = 1;
+		/* Accumulated chunks are now captured in checkpoint */
+		cmh_cshake_free_chunks(rctx, tctx);
+	}
+
+	kfree(save_buf);
+	return ret;
+}
+
+static int cmh_cshake_import(struct ahash_request *req, const void *in)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+
+	rctx->info = cmh_cshake_get_info(tfm);
+	rctx->error = 0;
+	INIT_LIST_HEAD(&rctx->chunks);
+	rctx->num_chunks = 0;
+	rctx->total_len = 0;
+
+	memcpy(rctx->checkpoint, in, HC_CONTEXT_SIZE);
+	rctx->has_checkpoint = 1;
+
+	return 0;
+}
+
+/* Transform init/exit */
+
+static int cmh_cshake_cra_init(struct crypto_tfm *tfm)
+{
+	struct cmh_cshake_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
+
+	tctx->func_name = NULL;
+	tctx->func_name_len = 0;
+	tctx->custom = NULL;
+	tctx->custom_len = 0;
+	spin_lock_init(&tctx->chunk_lock);
+	INIT_LIST_HEAD(&tctx->all_chunks);
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct cmh_cshake_reqctx));
+	return 0;
+}
+
+static void cmh_cshake_cra_exit(struct crypto_tfm *tfm)
+{
+	struct cmh_cshake_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct cmh_cshake_chunk *chunk, *tmp;
+
+	/* Free any orphaned chunks (e.g. testmgr export/reimport poison) */
+	spin_lock_bh(&tctx->chunk_lock);
+	list_for_each_entry_safe(chunk, tmp, &tctx->all_chunks, tfm_node) {
+		list_del(&chunk->tfm_node);
+		kfree(chunk);
+	}
+	spin_unlock_bh(&tctx->chunk_lock);
+
+	kfree(tctx->func_name);
+	kfree(tctx->custom);
+	tctx->func_name = NULL;
+	tctx->custom = NULL;
+}
+
+/* Registration */
+
+static struct cmh_cshake_alg_drv cmh_cshake_drvs[CMH_CSHAKE_ALG_COUNT];
+
+/**
+ * cmh_cshake_register() - Register cSHAKE-128/256 hash algorithms with the crypto framework
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_cshake_register(void)
+{
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < CMH_CSHAKE_ALG_COUNT; i++) {
+		const struct cmh_cshake_alg_info *info =
+			&cmh_cshake_algs_info[i];
+		struct cmh_cshake_alg_drv *drv = &cmh_cshake_drvs[i];
+		struct ahash_alg *alg = &drv->alg;
+
+		drv->info = info;
+
+		alg->init   = cmh_cshake_init;
+		alg->update = cmh_cshake_update;
+		alg->final  = cmh_cshake_final;
+		alg->finup  = cmh_cshake_finup;
+		alg->digest = cmh_cshake_digest;
+		alg->export = cmh_cshake_export;
+		alg->import = cmh_cshake_import;
+		alg->setkey = cmh_cshake_setkey;
+
+		alg->halg.digestsize = info->digest_size;
+		alg->halg.statesize  = HC_CONTEXT_SIZE;
+
+		strscpy(alg->halg.base.cra_name, info->alg_name,
+			CRYPTO_MAX_ALG_NAME);
+		strscpy(alg->halg.base.cra_driver_name, info->drv_name,
+			CRYPTO_MAX_ALG_NAME);
+		alg->halg.base.cra_priority    = 300;
+		alg->halg.base.cra_flags       = CRYPTO_ALG_KERN_DRIVER_ONLY |
+						 CRYPTO_ALG_NO_FALLBACK |
+						 CRYPTO_ALG_ASYNC |
+						 CRYPTO_ALG_OPTIONAL_KEY |
+						 CRYPTO_ALG_REQ_VIRT;
+		alg->halg.base.cra_blocksize   = 1;  /* XOF */
+		alg->halg.base.cra_ctxsize     = sizeof(struct cmh_cshake_tfm_ctx);
+		alg->halg.base.cra_init        = cmh_cshake_cra_init;
+		alg->halg.base.cra_exit        = cmh_cshake_cra_exit;
+		alg->halg.base.cra_module      = THIS_MODULE;
+
+		ret = crypto_register_ahash(alg);
+		if (ret) {
+			dev_err(cmh_dev(), "cshake: failed to register %s (rc=%d)\n",
+				info->drv_name, ret);
+			while (i--)
+				crypto_unregister_ahash(&cmh_cshake_drvs[i].alg);
+			return ret;
+		}
+
+		dev_dbg(cmh_dev(), "cshake: registered %s (priority 300)\n",
+			info->drv_name);
+	}
+
+	dev_info(cmh_dev(), "cshake: %zu algorithm(s) registered\n",
+		 CMH_CSHAKE_ALG_COUNT);
+	return 0;
+}
+
+/**
+ * cmh_cshake_unregister() - Unregister cSHAKE hash algorithms from the crypto framework
+ */
+void cmh_cshake_unregister(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < CMH_CSHAKE_ALG_COUNT; i++) {
+		crypto_unregister_ahash(&cmh_cshake_drvs[i].alg);
+		dev_dbg(cmh_dev(), "cshake: unregistered %s\n",
+			cmh_cshake_algs_info[i].drv_name);
+	}
+
+	dev_info(cmh_dev(), "cshake: cleaned up\n");
+}
diff --git a/drivers/crypto/cmh/cmh_kmac.c b/drivers/crypto/cmh/cmh_kmac.c
new file mode 100644
index 000000000000..341f661de34e
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_kmac.c
@@ -0,0 +1,630 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Kernel Crypto API KMAC Driver
+ *
+ * Registers KMAC-128 and KMAC-256 as keyed ahash algorithms using the
+ * CMH Hash Core (HC) via HC_CMD_KMAC.
+ *
+ * KMAC (NIST SP 800-185) is a keyed variant of cSHAKE.  The function
+ * name N is always "KMAC" (hardcoded by the CMH eSW).  The user sets:
+ *   - A key via .setkey() (raw bytes + optional S)
+ *   - An optional customization string S via the setkey blob
+ *
+ * setkey blob format:
+ *   struct kmac_key_param { __be32 keylen; __be32 s_len; };
+ *   blob: kmac_key_param || key[keylen] || S[s_len]
+ *
+ * Uses the same self-contained transaction model as cmh_hmac.c:
+ *   .setkey() -> store raw key (+ S)
+ *   .init()   -> software-only
+ *   .update() -> software-only (accumulate chunks)
+ *   .final()  -> [SYS_CMD_WRITE] + HC_CMD_KMAC [+ inline S] +
+ *               [GATHER] + FINAL + FLUSH
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/crypto.h>
+#include <crypto/internal/hash.h>
+#include <linux/scatterlist.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <asm/byteorder.h>
+
+#include "cmh_kmac.h"
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
+ * The CMH eSW rejects HC_CMD_SAVE when ctx->outlen != 0, which is
+ * always the case for KMAC (eip59_hc_kmac() sets ctx->outlen for
+ * right_encode(outlen) at finalization).  All data must be buffered
+ * in kernel memory and submitted atomically in .final().
+ *
+ * The CMH eSW does not serialize outlen into the external save
+ * context, so HC_CMD_SAVE fails for KMAC mode.
+ */
+#define KMAC_MAX_DATA		(64 * 1024)
+
+/* Algorithm Table */
+
+struct cmh_kmac_alg_info {
+	u32         hc_algo;
+	u32         digest_size;
+	const char *alg_name;
+	const char *drv_name;
+};
+
+static const struct cmh_kmac_alg_info cmh_kmac_algs_info[] = {
+	{
+		.hc_algo     = HC_ALGO_SHAKE128,
+		.digest_size = CMH_SHAKE128_DIGEST_SIZE,
+		.alg_name    = "kmac128",
+		.drv_name    = "rambus-cmh-kmac128",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHAKE256,
+		.digest_size = CMH_SHAKE256_DIGEST_SIZE,
+		.alg_name    = "kmac256",
+		.drv_name    = "rambus-cmh-kmac256",
+	},
+};
+
+#define CMH_KMAC_ALG_COUNT  ARRAY_SIZE(cmh_kmac_algs_info)
+
+/* Per-Request State */
+
+struct cmh_kmac_chunk {
+	struct list_head  list;
+	struct list_head  tfm_node; /* per-tfm orphan tracking */
+	u32               len;
+	u8                data[];
+};
+
+/*
+ * Max payload slots for KMAC:
+ *   SYS_CMD_WRITE (1) + KMAC (1) + inline S (3 max) + GATHER (1) +
+ *   FINAL (1) + FLUSH (1) = 8
+ */
+#define CMH_KMAC_MAX_PAYLOAD   9
+#define CMH_KMAC_MAX_PACKED    (CMH_KMAC_MAX_PAYLOAD * 2)
+
+struct cmh_kmac_reqctx {
+	const struct cmh_kmac_alg_info *info;
+	int                             error;
+	struct list_head                chunks;
+	u32                             num_chunks;
+	u32                             total_len;
+	/* DMA state for async final */
+	dma_addr_t                      digest_dma;
+	dma_addr_t                      key_dma;
+	u8                             *digest_buf;
+	struct cmh_sg_map              *sgm;
+	u32                             keylen;
+	struct vcq_cmd packed[CMH_KMAC_MAX_PACKED];
+};
+
+/* Per-Transform State (carries key + S across requests) */
+
+struct cmh_kmac_tfm_ctx {
+	struct cmh_key_ctx key;
+	u8  *custom;        /* S (customization string), NULL if empty */
+	u32  custom_len;
+	spinlock_t         chunk_lock;  /* protects all_chunks */
+	struct list_head   all_chunks;  /* orphan-safe chunk tracking */
+};
+
+/* VCQ Builders (KMAC-specific; shared builders in cmh_hc_abi.h / cmh_vcq.h) */
+
+static void vcq_add_hc_kmac(struct vcq_cmd *slot, u32 core_id, u64 key_ref, u32 keylen,
+			    u32 customlen, u32 algo, u32 outlen)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HC_CMD_KMAC);
+	slot->hwc.hc.cmd_kmac.key = key_ref;
+	slot->hwc.hc.cmd_kmac.custom = 0;  /* inline */
+	slot->hwc.hc.cmd_kmac.keylen = keylen;
+	slot->hwc.hc.cmd_kmac.customlen = customlen;
+	slot->hwc.hc.cmd_kmac.algo = algo;
+	slot->hwc.hc.cmd_kmac.outlen = outlen;
+}
+
+/* Request Context Cleanup */
+
+static void cmh_kmac_free_chunks(struct cmh_kmac_reqctx *rctx,
+				 struct cmh_kmac_tfm_ctx *tctx)
+{
+	struct cmh_kmac_chunk *chunk, *tmp;
+
+	spin_lock_bh(&tctx->chunk_lock);
+	list_for_each_entry_safe(chunk, tmp, &rctx->chunks, list) {
+		list_del(&chunk->list);
+		list_del(&chunk->tfm_node);
+		kfree(chunk);
+	}
+	spin_unlock_bh(&tctx->chunk_lock);
+	rctx->num_chunks = 0;
+	rctx->total_len = 0;
+}
+
+static struct cmh_sg_map *
+cmh_kmac_build_sg(struct cmh_kmac_reqctx *rctx, gfp_t gfp)
+{
+	struct cmh_dma_buf *bufs;
+	struct cmh_kmac_chunk *chunk;
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
+struct cmh_kmac_alg_drv {
+	struct ahash_alg                 alg;
+	const struct cmh_kmac_alg_info  *info;
+};
+
+static const struct cmh_kmac_alg_info *
+cmh_kmac_get_info(struct crypto_ahash *tfm)
+{
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
+
+	return container_of(alg, struct cmh_kmac_alg_drv, alg)->info;
+}
+
+/*
+ * setkey blob for KMAC (raw key path):
+ *   struct kmac_key_param { __be32 keylen; __be32 s_len; };
+ *   blob: kmac_key_param || key[keylen] || S[s_len]
+ */
+struct kmac_key_param {
+	__be32 keylen;
+	__be32 s_len;
+};
+
+static int cmh_kmac_setkey(struct crypto_ahash *tfm, const u8 *key,
+			   unsigned int keylen)
+{
+	struct cmh_kmac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	/* raw key bytes with optional S */
+	{
+		struct kmac_key_param hdr;
+		u32 raw_keylen, s_len;
+		const u8 *ptr;
+
+		if (keylen < sizeof(hdr))
+			return -EINVAL;
+
+		memcpy(&hdr, key, sizeof(hdr));
+		raw_keylen = be32_to_cpu(hdr.keylen);
+		s_len = be32_to_cpu(hdr.s_len);
+
+		if (keylen != sizeof(hdr) + raw_keylen + s_len)
+			return -EINVAL;
+
+		if (raw_keylen == 0)
+			return -EINVAL;
+
+		if (s_len > HC_CSHAKE_MAX_CUSTOMLEN)
+			return -EINVAL;
+
+		ptr = key + sizeof(hdr);
+
+		/* Store raw key */
+		{
+			int ret = cmh_key_setkey_raw(&tctx->key, ptr,
+						     raw_keylen, CORE_ID_HC);
+			if (ret)
+				return ret;
+		}
+		ptr += raw_keylen;
+
+		/* Store S */
+		kfree(tctx->custom);
+		tctx->custom = NULL;
+		tctx->custom_len = 0;
+
+		if (s_len > 0) {
+			tctx->custom = kmemdup(ptr, s_len, GFP_KERNEL);
+			if (!tctx->custom) {
+				cmh_key_destroy(&tctx->key);
+				return -ENOMEM;
+			}
+			tctx->custom_len = s_len;
+		}
+
+		return 0;
+	}
+}
+
+static int cmh_kmac_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_kmac_reqctx *rctx = ahash_request_ctx(req);
+
+	rctx->info = cmh_kmac_get_info(tfm);
+	rctx->error = 0;
+	INIT_LIST_HEAD(&rctx->chunks);
+	rctx->num_chunks = 0;
+	rctx->total_len = 0;
+
+	return 0;
+}
+
+static int cmh_kmac_update(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_kmac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_kmac_reqctx *rctx = ahash_request_ctx(req);
+	struct cmh_kmac_chunk *chunk;
+	int nents;
+
+	if (rctx->error)
+		return rctx->error;
+
+	if (!req->nbytes)
+		return 0;
+
+	if (req->nbytes > KMAC_MAX_DATA - rctx->total_len) {
+		rctx->error = -EINVAL;
+		goto err_free_chunks;
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
+			kfree(chunk);
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
+	 * The crypto API hash path does not call .final() on error,
+	 * so chunks would be orphaned otherwise.
+	 */
+	cmh_kmac_free_chunks(rctx, tctx);
+	return rctx->error;
+}
+
+static void cmh_kmac_complete(void *data, int error)
+{
+	struct ahash_request *req = data;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_kmac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_kmac_reqctx *rctx = ahash_request_ctx(req);
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
+	cmh_kmac_free_chunks(rctx, tctx);
+	cmh_complete(&req->base, error);
+}
+
+static int cmh_kmac_final(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_kmac_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_kmac_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_kmac_alg_info *info = rctx->info;
+	struct vcq_cmd cmds[CMH_KMAC_MAX_PAYLOAD];
+	struct cmh_sg_map *sgm = NULL;
+	dma_addr_t digest_dma = DMA_MAPPING_ERROR, key_dma = DMA_MAPPING_ERROR;
+	u8 *digest_buf;
+	u64 key_ref;
+	u32 key_len;
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
+	if (tctx->key.mode == CMH_KEY_NONE) {
+		ret = -ENOKEY;
+		goto out_free;
+	}
+
+	if (rctx->num_chunks > 0) {
+		sgm = cmh_kmac_build_sg(rctx, gfp);
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
+	key_dma = tctx->key.raw.dma;
+	vcq_add_sys_write(&cmds[idx++], SYS_REF_TEMP, (u64)key_dma,
+			  SYS_REF_NONE, tctx->key.raw.len,
+			  tctx->key.raw.sys_type);
+	key_ref = SYS_REF_TEMP;
+	key_len = tctx->key.raw.len;
+	d = cmh_core_select_instance(CMH_CORE_HC);
+
+	target_mbx = d.mbx_idx;
+
+	core_id = d.core_id;
+
+	{
+		u32 span;
+
+		vcq_add_hc_kmac(&cmds[idx], core_id, key_ref, key_len,
+				tctx->custom_len, info->hc_algo,
+				info->digest_size);
+
+		/* Add inline S data after the KMAC slot */
+		span = vcq_add_inline_data(&cmds[idx], tctx->custom,
+					   tctx->custom_len);
+		idx += span;
+	}
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
+					    CMH_KMAC_MAX_PACKED,
+					    target_mbx,
+					    cmh_kmac_complete, req,
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
+	cmh_kmac_free_chunks(rctx, tctx);
+	return ret;
+}
+
+static int cmh_kmac_finup(struct ahash_request *req)
+{
+	int ret;
+
+	ret = cmh_kmac_update(req);
+	if (ret)
+		return ret;
+
+	return cmh_kmac_final(req);
+}
+
+static int cmh_kmac_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = cmh_kmac_init(req);
+	if (ret)
+		return ret;
+
+	return cmh_kmac_finup(req);
+}
+
+static int cmh_kmac_export(struct ahash_request *req, void *out)
+{
+	return -EOPNOTSUPP;
+}
+
+static int cmh_kmac_import(struct ahash_request *req, const void *in)
+{
+	return -EOPNOTSUPP;
+}
+
+/* Transform init/exit */
+
+static int cmh_kmac_cra_init(struct crypto_tfm *tfm)
+{
+	struct cmh_kmac_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
+
+	tctx->key.mode = CMH_KEY_NONE;
+	tctx->custom = NULL;
+	tctx->custom_len = 0;
+	spin_lock_init(&tctx->chunk_lock);
+	INIT_LIST_HEAD(&tctx->all_chunks);
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct cmh_kmac_reqctx));
+	return 0;
+}
+
+static void cmh_kmac_cra_exit(struct crypto_tfm *tfm)
+{
+	struct cmh_kmac_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct cmh_kmac_chunk *chunk, *tmp;
+
+	/* Free any orphaned chunks (e.g. testmgr export/reimport poison) */
+	spin_lock_bh(&tctx->chunk_lock);
+	list_for_each_entry_safe(chunk, tmp, &tctx->all_chunks, tfm_node) {
+		list_del(&chunk->tfm_node);
+		kfree(chunk);
+	}
+	spin_unlock_bh(&tctx->chunk_lock);
+
+	cmh_key_destroy(&tctx->key);
+	kfree(tctx->custom);
+	tctx->custom = NULL;
+}
+
+/* Registration */
+
+static struct cmh_kmac_alg_drv cmh_kmac_drvs[CMH_KMAC_ALG_COUNT];
+
+/**
+ * cmh_kmac_register() - Register KMAC-128/256 hash algorithms with the crypto framework
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_kmac_register(void)
+{
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < CMH_KMAC_ALG_COUNT; i++) {
+		const struct cmh_kmac_alg_info *info =
+			&cmh_kmac_algs_info[i];
+		struct cmh_kmac_alg_drv *drv = &cmh_kmac_drvs[i];
+		struct ahash_alg *alg = &drv->alg;
+
+		drv->info = info;
+
+		alg->init   = cmh_kmac_init;
+		alg->update = cmh_kmac_update;
+		alg->final  = cmh_kmac_final;
+		alg->finup  = cmh_kmac_finup;
+		alg->digest = cmh_kmac_digest;
+		alg->export = cmh_kmac_export;
+		alg->import = cmh_kmac_import;
+		alg->setkey = cmh_kmac_setkey;
+
+		alg->halg.digestsize = info->digest_size;
+		alg->halg.statesize  = sizeof(struct cmh_kmac_reqctx);
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
+		alg->halg.base.cra_blocksize   = 1;  /* XOF/keyed XOF */
+		alg->halg.base.cra_ctxsize     = sizeof(struct cmh_kmac_tfm_ctx);
+		alg->halg.base.cra_init        = cmh_kmac_cra_init;
+		alg->halg.base.cra_exit        = cmh_kmac_cra_exit;
+		alg->halg.base.cra_module      = THIS_MODULE;
+
+		ret = crypto_register_ahash(alg);
+		if (ret) {
+			dev_err(cmh_dev(), "kmac: failed to register %s (rc=%d)\n",
+				info->drv_name, ret);
+			while (i--)
+				crypto_unregister_ahash(&cmh_kmac_drvs[i].alg);
+			return ret;
+		}
+
+		dev_dbg(cmh_dev(), "kmac: registered %s (priority 300)\n",
+			info->drv_name);
+	}
+
+	dev_info(cmh_dev(), "kmac: %zu algorithm(s) registered\n",
+		 CMH_KMAC_ALG_COUNT);
+	return 0;
+}
+
+/**
+ * cmh_kmac_unregister() - Unregister KMAC hash algorithms from the crypto framework
+ */
+void cmh_kmac_unregister(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < CMH_KMAC_ALG_COUNT; i++) {
+		crypto_unregister_ahash(&cmh_kmac_drvs[i].alg);
+		dev_dbg(cmh_dev(), "kmac: unregistered %s\n",
+			cmh_kmac_algs_info[i].drv_name);
+	}
+
+	dev_info(cmh_dev(), "kmac: cleaned up\n");
+}
diff --git a/drivers/crypto/cmh/cmh_main.c b/drivers/crypto/cmh/cmh_main.c
index 4bd90d2d394a..bc47d5ef3f86 100644
--- a/drivers/crypto/cmh/cmh_main.c
+++ b/drivers/crypto/cmh/cmh_main.c
@@ -33,6 +33,8 @@
 #include "cmh_rh.h"
 #include "cmh_hash.h"
 #include "cmh_hmac.h"
+#include "cmh_cshake.h"
+#include "cmh_kmac.h"
 #include "cmh_mgmt.h"
 #include "cmh_registers.h"
 #include "cmh_debugfs.h"
@@ -249,6 +251,16 @@ static int cmh_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_hmac_register;
 
+	/* Register CSHAKE hash algorithms */
+	ret = cmh_cshake_register();
+	if (ret)
+		goto err_cshake_register;
+
+	/* Register KMAC hash algorithms */
+	ret = cmh_kmac_register();
+	if (ret)
+		goto err_kmac_register;
+
 	/* Register key management device (/dev/cmh_mgmt) */
 	ret = cmh_mgmt_register();
 	if (ret)
@@ -261,6 +273,10 @@ static int cmh_probe(struct platform_device *pdev)
 	return 0;
 
 err_mgmt_register:
+	cmh_kmac_unregister();
+err_kmac_register:
+	cmh_cshake_unregister();
+err_cshake_register:
 	cmh_hmac_unregister();
 err_hmac_register:
 	cmh_hash_unregister();
@@ -291,6 +307,8 @@ static void cmh_remove(struct platform_device *pdev)
 	cfg = &dev->config;
 
 	cmh_mgmt_unregister();
+	cmh_kmac_unregister();
+	cmh_cshake_unregister();
 	cmh_hmac_unregister();
 	cmh_hash_unregister();
 	cmh_rh_cleanup(cfg);
diff --git a/drivers/crypto/cmh/include/cmh_cshake.h b/drivers/crypto/cmh/include/cmh_cshake.h
new file mode 100644
index 000000000000..9bafe0baf52f
--- /dev/null
+++ b/drivers/crypto/cmh/include/cmh_cshake.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Kernel Crypto API CSHAKE Driver
+ *
+ * Registers cSHAKE-128 and cSHAKE-256 ahash algorithms using
+ * HC_CMD_CSHAKE with inline customization string S.
+ */
+
+#ifndef CMH_CSHAKE_H
+#define CMH_CSHAKE_H
+
+int  cmh_cshake_register(void);
+void cmh_cshake_unregister(void);
+
+#endif /* CMH_CSHAKE_H */
diff --git a/drivers/crypto/cmh/include/cmh_kmac.h b/drivers/crypto/cmh/include/cmh_kmac.h
new file mode 100644
index 000000000000..b3c92d71a0b6
--- /dev/null
+++ b/drivers/crypto/cmh/include/cmh_kmac.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Kernel Crypto API KMAC Driver
+ *
+ * Registers KMAC-128 and KMAC-256 ahash algorithms using
+ * HC_CMD_KMAC with inline customization string S.
+ */
+
+#ifndef CMH_KMAC_H
+#define CMH_KMAC_H
+
+int  cmh_kmac_register(void);
+void cmh_kmac_unregister(void);
+
+#endif /* CMH_KMAC_H */
-- 
2.43.7

