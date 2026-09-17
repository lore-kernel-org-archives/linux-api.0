Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11023137.outbound.protection.outlook.com [40.107.201.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0774AAC5F;
	Thu, 17 Sep 2026 22:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.137
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789685983; cv=fail; b=K1v6CuMzaI9oOCxskBkFQo7xjHLHdOdHthkkM5IvMmfkpqhBI78QEoWdMeoUsmBtdCMpNG+UIsQwyVciGtwUZtc0VPavzCaeg16R1vNeGGys3SYYWv8fNOrCY08NJigLgrGhfvgw9gAIe2Q+9lf/76OsAZaJWz4ronkUxFjjWDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789685983; c=relaxed/simple;
	bh=/2vc/aMzPLXvGLoyijGjCfuQ/8pqUiLVI/E3PUfvCKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r5TFNnblsKXm/88bNHYdToxGWKTyrK11urPHj4xHxiuuskV9EVf942xJV7nQksiFdxtJstivSUWwCpb1/9PlorHJnKb7Od+oOaXROhA0qPIgGL0Sl7brjieu9A4ooE9SyZVr0+isO8GkLdMIr0WBDvYJAhL4Q3DRGL2FKFpsG74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=P9Bvp1eU; arc=fail smtp.client-ip=40.107.201.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="P9Bvp1eU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vCn8x3QONbKPMjHMl5AYmcryHTJ+jP+NOwAnD5OrjB/O4xBeYqxYbJEJuJdqjqwtmJnMxU37vVbd/9Q4Vd+fq36WLHGkOL7l0pk8jTB0MyQyRQNdSgjwqn+xC/G0mR0Tf11q+YmnvK3wT+ZphHM7APlj6v94N68aEDJ2F3bLD8I/uT+Hle/CcsHlYs4ib+9cbR4DQ9uWVcA0FslPuamyVv8VHDJtWw1Jw9aL/GAG4V3EV1k7ze41R7orzbdzfnXW2U7KtkwCTgCzCd47TS/7PZLyS/TbZd7cLCz1tlXL16oDsACujcZfTtLOYvkqkDQut4T0L0wm6pngyYXtxazeEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpkTV3CFzIOR2jA1eCCbMwkpyRFDDOnScx8EWM7JARQ=;
 b=CO9nJanEdDFAta/eJge7gZNwR2w82IDfAFZz7MOWOGh7TAkTE1JEmBRCaEDEMevxwwY+ofsFmF/2ClyQ8aRJKJdDpwcarmnnfpZSXbt43ZK+zXJgi/QkmVw/7PUMIHkvZ26+mOC5fuafXPZv1SffzJvery/uV8W4TOYtw+qI3b7CIza1O9BrEO980e2AKmogmejORPro0/hyAN2CW5p6hFlO8TDJTmmcZKMSWdWvZbJk1D0cXocvbHlTh41iF4Z9iTHSlgnKyF3dpmZT+hgdVyoXN8+P5dq8DHTWJ0ZyVNNUDIZsOoS1pAUhFRq8hY8eLLcR5MINx3lt4Nfb1IR3Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpkTV3CFzIOR2jA1eCCbMwkpyRFDDOnScx8EWM7JARQ=;
 b=P9Bvp1eURcRsFYBj6pT5aKBTSb+lMw+yKdzI3/XV9EGuQDHxfDOCnTF1dcARwkPypaz2MCiSexkggvJvYBKsZL3dpkxQriJTnaQYTd32yrryBcxoGs9jBKcb2LIMn4iKi9fjFTQe7rQi9HFS85EgHBVKIDkky//Z9qCN7of3ChroYZt4GHfsgdLfyk9BsN4MXZYTJQD/SIkOn8QCIKq9a5k6Ci9rNAiVewG2guR0ERQRYf8HF1pm3XRZdtpkXfPzNiaWxvTgAWHvEdQ/ZDfM60Zppl7B+zv74TZDjWl2ozVnbzJgv4QHPirrzJM3hLcMRkllVHibLMYBXHa5v9+34A==
Received: from BN0PR07CA0022.namprd07.prod.outlook.com (2603:10b6:408:141::14)
 by DS2PR04MB994244.namprd04.prod.outlook.com (2603:10b6:8:4a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Thu, 17 Sep
 2026 22:59:33 +0000
Received: from BN2PEPF0000A7FE.namprd02.prod.outlook.com
 (2603:10b6:408:141:cafe::90) by BN0PR07CA0022.outlook.office365.com
 (2603:10b6:408:141::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 22:59:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BN2PEPF0000A7FE.mail.protection.outlook.com (10.167.245.165) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Thu, 17 Sep 2026 22:59:32 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id E9BE5180175F;
	Thu, 17 Sep 2026 22:59:31 +0000 (UTC)
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
Subject: [PATCH v5 04/19] crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
Date: Thu, 17 Sep 2026 15:59:13 -0700
Message-ID: <20260917225929.2494111-5-aousherovitch@rambus.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260917225929.2494111-1-aousherovitch@rambus.com>
References: <20260917225929.2494111-1-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A7FE:EE_|DS2PR04MB994244:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: dce906b5-89a8-424d-4841-08df150f5665
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700016|23010399003|921020|3023799007|56012099006|11063799006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	8sYkFs8qxfcJ95iqNaQXfxcUopT/E1d99J0RWuLt3A9AJ/VoOkEHnpnYUqMCrskdRgPquajV3KO77Qef6/ckiTs0hGIIHde5DIpzuU6i45PaqIEkRQhlqTzhSbtq/pDL/bgHrNr1ssI9Egg0+S9HybqfrbOm4mLMoiij6ZSD0jO8XeRwMoWyZVcrfv0eD+rkba3F/zgSaj3sLU4K86gAukUDKOEcrUr0pjtMGNFCnqMvdUXFcyHprwAwFQg1yLtJc+wr1qk+td9QyTsAfYgtnJavMMEq2V6YEYDAxb/sxoB8Tzm0S6Nxxwbo4by1ZEhDmmTPHlEhH6m5+b1onbREm1DZKQjHtTcHDEarLPi2jYmVlpDN6xF9LK6YY80gOkUJdVYZzU99X72MPjRUPkU4UQPwADvbLDFDvvnxPb7AyLaNtZWMwYmrtBiBXTAffi4bhrw/1lVkJ2uKfuKU+8HxG4bj/8Xam6dwZS6dVcIZyevjXow8R75zy24vpjKMVb9wOIX6Np97Yq+3a7rp5s3qVKEuc25mgJiCYTbp1frsUPbU3a+8ZrXPiRarV+poyNWiNAj74uCyedA7SKLkCzBAOVg9l0y8pTYlVY/6xOgyCyWrwHWadcwObG/krXAanR1s68kXKJYiT5FXn3+kyh4vpJzx5L8r6pi27HnKXuvY6NU2gflk5MQ/FcexjeV/hT6GUwQC1uvlQm3glSXsvccYmzbOvZ2hfIoXlYS5O9jKkipSRsPpvaPF9LMPkyV1L/lb
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700016)(23010399003)(921020)(3023799007)(56012099006)(11063799006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CGQhIHeicCYLDR5el7skCN2udspGLptV2/vvHf+QfbYIhhdeZOLphqDfG7mLQHiWe1I4pX1qw31zZzxA2MuR1b1SBNTVUMWAK3NK0PD11hkzLZQ5ZUjZPZs/8i0q6WakyupT0vb0NC2btFAFI7hIp3GziYtsP25USzPl54AprGauAbm2dWdQePev6DBtr1GEnQXCMPg5r5TtzNTIkt5hBuAesBSyvVkc7jXBq9qHx8QXobTpBqa9UB3+AJukCqO21gzxzfz9XQTtrl5jJ230lzwGF2t5i1Fj5CgKXjYqNv9rgX3bCE+2aINmYBuUd67vSjcYoU+ZmGfZb8PjKsKe/mLnncK3sjn21jrkhD5qMDU3CrUTi1A/C1sLjSwlw4+DH25Rm49IqUd7ZYmBp5tXZREi3q1nxaBnnKV7vRQGVgG7wsXYmtOupCWcQM8krewk
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 22:59:32.5765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dce906b5-89a8-424d-4841-08df150f5665
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A7FE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR04MB994244

Register ahash algorithms for SHA-224, SHA-256, SHA-384, SHA-512,
SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128, and SHAKE256
using the CMH hash core (core ID 0x02).

The drivers set CRYPTO_AHASH_ALG_BLOCK_ONLY so the Crypto API buffers
partial blocks; they support incremental update/finup and
export/import for request cloning.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 drivers/crypto/cmh/Makefile           |   3 +-
 drivers/crypto/cmh/cmh_hash.c         | 812 ++++++++++++++++++++++++++
 drivers/crypto/cmh/cmh_main.c         |   9 +
 drivers/crypto/cmh/include/cmh_hash.h |  27 +
 4 files changed, 850 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/cmh/cmh_hash.c
 create mode 100644 drivers/crypto/cmh/include/cmh_hash.h

diff --git a/drivers/crypto/cmh/Makefile b/drivers/crypto/cmh/Makefile
index bb7772555d6a..79c94d87e9ee 100644
--- a/drivers/crypto/cmh/Makefile
+++ b/drivers/crypto/cmh/Makefile
@@ -14,7 +14,8 @@ cmh-y := \
 	cmh_dma.o \
 	cmh_sysfs.o \
 	cmh_key.o \
-	cmh_sys.o
+	cmh_sys.o \
+	cmh_hash.o
 
 # Management ioctl device (/dev/cmh_mgmt): key lifecycle, PKE, PQC ioctls.
 cmh-$(CONFIG_CRYPTO_DEV_CMH_MGMT) += \
diff --git a/drivers/crypto/cmh/cmh_hash.c b/drivers/crypto/cmh/cmh_hash.c
new file mode 100644
index 000000000000..1acc8bdab352
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_hash.c
@@ -0,0 +1,812 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Kernel Crypto API Hash Driver
+ *
+ * Registers asynchronous hash (ahash) algorithms with the Linux crypto
+ * subsystem.  Implements SHA-2 (224/256/384/512), SHA-3
+ * (224/256/384/512), and SHAKE (128/256) families using the CMH Hash
+ * Core (HC).
+ *
+ * Incremental HW update model.  The driver sets
+ * CRYPTO_AHASH_ALG_BLOCK_ONLY, so the Crypto API buffers partial
+ * blocks: .update() is only handed whole-block-aligned data and returns
+ * any sub-block remainder for the API to hold until the next call.
+ *
+ *   .init()   -> software-only: zero per-request context
+ *   .update() -> INIT [+ RESTORE] + UPDATE(full blocks) + SAVE + FLUSH;
+ *                return -EINPROGRESS, completing with the leftover byte
+ *                count the API must buffer (0 when block-aligned)
+ *   .finup()  -> INIT [+ RESTORE] [+ UPDATE(residual)] + FINAL + FLUSH
+ *                (also serves .final via the API: nbytes == 0)
+ *   .digest() -> INIT + UPDATE + FINAL + FLUSH (single-shot via finup)
+ *   .export()/.import() -> software-only: copy the HC context
+ *                checkpoint; the API appends its own partial-block buffer
+ *
+ * The FLUSH after each .update() releases the HC core, so no lockout.
+ * Two hash sessions interleave fine on the same MBX -- each saves its
+ * own state via SAVE and restores via RESTORE on the next call.
+ *
+ * These are sg-only drivers (no CRYPTO_ALG_REQ_VIRT): BLOCK_ONLY buffer
+ * prepending assumes scatterlists.  Export/import carry only HW state,
+ * enabling crypto API transform clone for all plain-hash algorithms.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/crypto.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include "cmh_hash.h"
+#include "cmh_vcq.h"
+#include "cmh_txn.h"
+#include "cmh_dma.h"
+
+/* Algorithm Table */
+
+struct cmh_hash_alg_info {
+	u32         hc_algo;        /* HC_ALGO_* (SHA2, SHA3, SHAKE) */
+	u32         digest_size;    /* bytes */
+	u32         block_size;     /* cra_blocksize for Linux crypto API */
+	const char *alg_name;       /* Linux crypto name: "sha256" */
+	const char *drv_name;       /* driver name: "rambus-cmh-sha256" */
+};
+
+static const struct cmh_hash_alg_info cmh_hash_algs_info[] = {
+	/* SHA-2 family */
+	{
+		.hc_algo     = HC_ALGO_SHA2_224,
+		.digest_size = CMH_SHA224_DIGEST_SIZE,
+		.block_size  = 64,
+		.alg_name    = "sha224",
+		.drv_name    = "rambus-cmh-sha224",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA2_256,
+		.digest_size = CMH_SHA256_DIGEST_SIZE,
+		.block_size  = 64,
+		.alg_name    = "sha256",
+		.drv_name    = "rambus-cmh-sha256",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA2_384,
+		.digest_size = CMH_SHA384_DIGEST_SIZE,
+		.block_size  = 128,
+		.alg_name    = "sha384",
+		.drv_name    = "rambus-cmh-sha384",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA2_512,
+		.digest_size = CMH_SHA512_DIGEST_SIZE,
+		.block_size  = 128,
+		.alg_name    = "sha512",
+		.drv_name    = "rambus-cmh-sha512",
+	},
+	/* SHA-3 family */
+	{
+		.hc_algo     = HC_ALGO_SHA3_224,
+		.digest_size = CMH_SHA3_224_DIGEST_SIZE,
+		.block_size  = 144,  /* rate = 1600/8 - 2*224/8 = 144 */
+		.alg_name    = "sha3-224",
+		.drv_name    = "rambus-cmh-sha3-224",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA3_256,
+		.digest_size = CMH_SHA3_256_DIGEST_SIZE,
+		.block_size  = 136,  /* rate = 1600/8 - 2*256/8 = 136 */
+		.alg_name    = "sha3-256",
+		.drv_name    = "rambus-cmh-sha3-256",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA3_384,
+		.digest_size = CMH_SHA3_384_DIGEST_SIZE,
+		.block_size  = 104,  /* rate = 1600/8 - 2*384/8 = 104 */
+		.alg_name    = "sha3-384",
+		.drv_name    = "rambus-cmh-sha3-384",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHA3_512,
+		.digest_size = CMH_SHA3_512_DIGEST_SIZE,
+		.block_size  = 72,   /* rate = 1600/8 - 2*512/8 = 72 */
+		.alg_name    = "sha3-512",
+		.drv_name    = "rambus-cmh-sha3-512",
+	},
+	/*
+	 * SHAKE (XOF) family -- fixed-output ahash registration.
+	 *
+	 * cra_blocksize = 1: SHAKE is a sponge/XOF, not Merkle-Damgaard.
+	 * With BLOCK_ONLY this means the API never holds anything back and
+	 * every byte reaches .update(); the HC core absorbs any sub-rate
+	 * remainder into its saved context across SAVE/RESTORE, so unaligned
+	 * intermediate absorbs are fine.
+	 */
+	{
+		.hc_algo     = HC_ALGO_SHAKE128,
+		.digest_size = CMH_SHAKE128_DIGEST_SIZE,
+		.block_size  = 1,    /* XOF: no meaningful block for crypto API */
+		.alg_name    = "shake128",
+		.drv_name    = "rambus-cmh-shake128",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHAKE256,
+		.digest_size = CMH_SHAKE256_DIGEST_SIZE,
+		.block_size  = 1,    /* XOF: no meaningful block for crypto API */
+		.alg_name    = "shake256",
+		.drv_name    = "rambus-cmh-shake256",
+	},
+};
+
+#define CMH_HASH_ALG_COUNT  ARRAY_SIZE(cmh_hash_algs_info)
+
+/* Per-Request State */
+
+/*
+ * Exported hash state -- serialised by .export(), deserialised by
+ * .import().  This is what statesize advertises to the crypto
+ * subsystem; the API appends its own partial-block buffer on top.
+ */
+struct cmh_hash_export_state {
+	u8  checkpoint[HC_CONTEXT_SIZE]; /* HC context from last SAVE */
+	u32 hw_started;                  /* non-zero if checkpoint valid */
+};
+
+/*
+ * Maximum payload commands any hash transaction can produce:
+ *   INIT + RESTORE + UPDATE + SAVE/FINAL + FLUSH = 5
+ * Worst-case packed output (stride=7, 1 payload per VCQ):
+ *   5 VCQs x 2 entries = 10
+ */
+#define CMH_HASH_MAX_PAYLOAD    5
+#define CMH_HASH_MAX_PACKED     (CMH_HASH_MAX_PAYLOAD * 2)
+
+/*
+ * Stored in ahash_request_ctx().  Tracks the algorithm, an HC context
+ * checkpoint from the last SAVE, and DMA state for the current in-flight
+ * async operation.  Partial-block buffering is handled by the Crypto API
+ * (CRYPTO_AHASH_ALG_BLOCK_ONLY), not here.
+ *
+ * The checkpoint is embedded inline rather than heap-allocated because
+ * the kernel ahash API has no per-request destructor.  If a request is
+ * abandoned without a final op (e.g. transform freed early), a heap
+ * checkpoint would leak unconditionally.
+ *
+ * Mapping the inline checkpoint for DMA is safe even on non-coherent
+ * platforms: it is only ever mapped DMA_TO_DEVICE, and its bytes are
+ * frozen from dma_map_single() until the matching unmap (it is written
+ * solely in the completion, after the unmap).  The device therefore
+ * always reads the value written back at map time, regardless of CPU
+ * writes to adjacent fields (packed[]) sharing the same cacheline --
+ * those writes never alter the checkpoint bytes, and a TO_DEVICE unmap
+ * performs no cache invalidate.  The shared-cacheline hazard applies
+ * only to FROM_DEVICE / BIDIRECTIONAL mappings, and all such buffers
+ * here (save_buf, digest_buf) are separately kmalloc'd.
+ */
+struct cmh_hash_reqctx {
+	const struct cmh_hash_alg_info *info;
+	int    error;
+	u32    hw_started;      /* non-zero after first HW submission */
+	u32    has_checkpoint;  /* non-zero if checkpoint[] valid */
+	u32    update_remainder; /* sub-block bytes the API must re-buffer */
+	/* DMA state for current async operation */
+	dma_addr_t ckpt_dma;   /* RESTORE input */
+	dma_addr_t save_dma;   /* SAVE output (update only) */
+	dma_addr_t data_dma;   /* UPDATE input */
+	dma_addr_t digest_dma; /* FINAL output (final/digest only) */
+	u8    *save_buf;       /* SAVE output buffer */
+	u8    *data_buf;       /* linearised data for DMA */
+	u32    data_len;       /* bytes in data_buf */
+	u8    *digest_buf;     /* digest output buffer */
+	u8     checkpoint[HC_CONTEXT_SIZE]; /* HC context from last SAVE */
+	struct vcq_cmd packed[CMH_HASH_MAX_PACKED];
+};
+
+/* VCQ Builders (HC-specific; shared builders in cmh_hc_abi.h / cmh_vcq.h) */
+
+/* Add an HC_CMD_UPDATE entry */
+static void vcq_add_hc_update(struct vcq_cmd *slot, u32 core_id, u64 input_phys, u32 len)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HC_CMD_UPDATE);
+	slot->hwc.hc.cmd_update.input = input_phys;
+	slot->hwc.hc.cmd_update.inlen = len;
+}
+
+/* Add an HC_CMD_SAVE entry */
+static void vcq_add_hc_save(struct vcq_cmd *slot, u32 core_id, u64 output_phys, u32 outlen)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HC_CMD_SAVE);
+	slot->hwc.hc.cmd_save.output = output_phys;
+	slot->hwc.hc.cmd_save.outlen = outlen;
+}
+
+/* Add an HC_CMD_RESTORE entry */
+static void vcq_add_hc_restore(struct vcq_cmd *slot, u32 core_id, u64 input_phys, u32 inlen)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HC_CMD_RESTORE);
+	slot->hwc.hc.cmd_restore.input = input_phys;
+	slot->hwc.hc.cmd_restore.inlen = inlen;
+}
+
+/* Request Context Cleanup */
+
+static void cmh_hash_free_reqctx(struct cmh_hash_reqctx *rctx)
+{
+	rctx->has_checkpoint = 0;
+}
+
+/* VCQ Packing + Submit */
+
+/* ahash Operations */
+
+/*
+ * Wrapper struct: embeds ahash_alg + a pointer to our alg_info table
+ * entry so we can recover it in the tfm callbacks.
+ */
+struct cmh_hash_alg_drv {
+	struct ahash_alg                 alg;
+	const struct cmh_hash_alg_info  *info;
+};
+
+/*
+ * Find the cmh_hash_alg_info from the crypto_ahash (embedded in our
+ * registered template).  We stash the info pointer in the algorithm's
+ * driver-private area at registration time (see cmh_hash_register).
+ */
+static const struct cmh_hash_alg_info *
+cmh_hash_get_info(struct crypto_ahash *tfm)
+{
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
+
+	return container_of(alg, struct cmh_hash_alg_drv, alg)->info;
+}
+
+static int cmh_hash_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
+
+	memset(rctx, 0, sizeof(*rctx));
+	rctx->info = cmh_hash_get_info(tfm);
+	return 0;
+}
+
+/*
+ * Update completion -- called from threaded IRQ after SAVE completes.
+ * Takes ownership of save_buf as the new checkpoint.
+ */
+static void cmh_hash_update_complete(void *data, int error)
+{
+	struct ahash_request *req = data;
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
+
+	if (error == -EINPROGRESS) {
+		cmh_complete(&req->base, error);
+		return;
+	}
+
+	/* Unmap DMA buffers */
+	if (rctx->has_checkpoint)
+		cmh_dma_unmap_single(rctx->ckpt_dma, HC_CONTEXT_SIZE,
+				     DMA_TO_DEVICE);
+	cmh_dma_unmap_single(rctx->save_dma, HC_CONTEXT_SIZE,
+			     DMA_FROM_DEVICE);
+	cmh_dma_unmap_single(rctx->data_dma, rctx->data_len,
+			     DMA_TO_DEVICE);
+
+	if (!error) {
+		memcpy(rctx->checkpoint, rctx->save_buf, HC_CONTEXT_SIZE);
+		rctx->has_checkpoint = 1;
+		kfree(rctx->save_buf);
+		rctx->save_buf = NULL;
+		rctx->hw_started = 1;
+		/* Hand the API the sub-block remainder it must re-buffer. */
+		error = rctx->update_remainder;
+	} else {
+		kfree(rctx->save_buf);
+		rctx->save_buf = NULL;
+		rctx->error = error;
+	}
+
+	kfree(rctx->data_buf);
+	rctx->data_buf = NULL;
+	rctx->data_len = 0;
+
+	cmh_complete(&req->base, error);
+}
+
+/*
+ * .update -- submit whole blocks to HW.
+ *
+ * With CRYPTO_AHASH_ALG_BLOCK_ONLY the Crypto API prepends any bytes it
+ * held back from earlier calls, so req->src carries at least one full
+ * block.  We hash the block-aligned prefix as:
+ *   INIT [+ RESTORE] + UPDATE(full blocks) + SAVE + FLUSH
+ * and return the sub-block remainder for the API to re-buffer (reported
+ * through the async completion).  For XOFs (block_size 1) there is never
+ * a remainder; the HC core absorbs sub-rate data across SAVE/RESTORE.
+ */
+static int cmh_hash_update(struct ahash_request *req)
+{
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_hash_alg_info *info = rctx->info;
+	struct vcq_cmd cmds[CMH_HASH_MAX_PAYLOAD];
+	struct core_dispatch d;
+	u32 block_size = info->block_size;
+	u32 full_len;
+	u32 idx;
+	int ret;
+	gfp_t gfp;
+
+	if (rctx->error)
+		return rctx->error;
+
+	if (!req->nbytes)
+		return 0;
+
+	/*
+	 * block_size is not always a power of two (SHA-3 rates: 144/136/
+	 * 104/72), so use modulo -- round_down() would corrupt the split.
+	 */
+	rctx->update_remainder = req->nbytes % block_size;
+	full_len = req->nbytes - rctx->update_remainder;
+
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+	      GFP_KERNEL : GFP_ATOMIC;
+
+	/*
+	 * Reject a single update whose linearisation would exceed the largest
+	 * kmalloc: return a permanent -EMSGSIZE ("message too long") rather
+	 * than a transient -ENOMEM the client would keep retrying.
+	 */
+	if (full_len > KMALLOC_MAX_SIZE)
+		return -EMSGSIZE;
+
+	/*
+	 * Linearise the block-aligned prefix from the scatterlist.
+	 * __GFP_NOWARN keeps a borderline-large (but sub-cap) request from
+	 * splatting the page allocator if it still cannot be satisfied.
+	 */
+	rctx->data_buf = kmalloc(full_len, gfp | __GFP_NOWARN);
+	if (!rctx->data_buf)
+		return -ENOMEM;
+
+	scatterwalk_map_and_copy(rctx->data_buf, req->src, 0, full_len, 0);
+
+	/* Allocate SAVE output buffer */
+	rctx->save_buf = kzalloc(HC_CONTEXT_SIZE, gfp);
+	if (!rctx->save_buf) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
+	/* DMA map data, save output, and checkpoint */
+	rctx->data_dma = cmh_dma_map_single(rctx->data_buf, full_len,
+					    DMA_TO_DEVICE);
+	if (cmh_dma_map_error(rctx->data_dma)) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
+	rctx->save_dma = cmh_dma_map_single(rctx->save_buf, HC_CONTEXT_SIZE,
+					    DMA_FROM_DEVICE);
+	if (cmh_dma_map_error(rctx->save_dma)) {
+		ret = -ENOMEM;
+		goto err_unmap_data;
+	}
+
+	rctx->ckpt_dma = DMA_MAPPING_ERROR;
+	if (rctx->has_checkpoint) {
+		rctx->ckpt_dma = cmh_dma_map_single(rctx->checkpoint,
+						    HC_CONTEXT_SIZE,
+						     DMA_TO_DEVICE);
+		if (cmh_dma_map_error(rctx->ckpt_dma)) {
+			ret = -ENOMEM;
+			goto err_unmap_save;
+		}
+	}
+
+	rctx->data_len = full_len;
+
+	/* Build VCQ: INIT [+ RESTORE] + UPDATE + SAVE + FLUSH */
+	d = cmh_core_select_instance(CMH_CORE_HC);
+	idx = 0;
+
+	vcq_add_hc_init(&cmds[idx++], d.core_id, info->hc_algo);
+
+	if (rctx->has_checkpoint)
+		vcq_add_hc_restore(&cmds[idx++], d.core_id,
+				   (u64)rctx->ckpt_dma, HC_CONTEXT_SIZE);
+
+	vcq_add_hc_update(&cmds[idx++], d.core_id,
+			  (u64)rctx->data_dma, full_len);
+
+	vcq_add_hc_save(&cmds[idx++], d.core_id,
+			(u64)rctx->save_dma, HC_CONTEXT_SIZE);
+
+	vcq_add_flush(&cmds[idx++], d.core_id);
+
+	ret = cmh_vcq_pack_and_submit_async(cmds, idx, rctx->packed,
+					    CMH_HASH_MAX_PACKED,
+					    d.mbx_idx,
+					    cmh_hash_update_complete, req,
+					    !!(req->base.flags &
+					       CRYPTO_TFM_REQ_MAY_BACKLOG),
+					    cmh_tm_async_timeout_jiffies());
+	if (ret && ret != -EBUSY)
+		goto err_unmap_ckpt;
+
+	if (ret == -EBUSY)
+		return -EBUSY;
+	return -EINPROGRESS;
+
+err_unmap_ckpt:
+	if (rctx->has_checkpoint)
+		cmh_dma_unmap_single(rctx->ckpt_dma, HC_CONTEXT_SIZE,
+				     DMA_TO_DEVICE);
+err_unmap_save:
+	cmh_dma_unmap_single(rctx->save_dma, HC_CONTEXT_SIZE,
+			     DMA_FROM_DEVICE);
+err_unmap_data:
+	cmh_dma_unmap_single(rctx->data_dma, full_len, DMA_TO_DEVICE);
+err_free:
+	kfree(rctx->save_buf);
+	rctx->save_buf = NULL;
+	kfree(rctx->data_buf);
+	rctx->data_buf = NULL;
+	rctx->data_len = 0;
+	return ret;
+}
+
+/*
+ * Final completion -- unmap all DMA, copy digest, signal done.
+ */
+static void cmh_hash_final_complete(void *data, int error)
+{
+	struct ahash_request *req = data;
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
+
+	if (error == -EINPROGRESS) {
+		cmh_complete(&req->base, error);
+		return;
+	}
+
+	if (rctx->has_checkpoint)
+		cmh_dma_unmap_single(rctx->ckpt_dma, HC_CONTEXT_SIZE,
+				     DMA_TO_DEVICE);
+	if (rctx->data_buf)
+		cmh_dma_unmap_single(rctx->data_dma, rctx->data_len,
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
+	kfree(rctx->data_buf);
+	rctx->data_buf = NULL;
+	cmh_hash_free_reqctx(rctx);
+	cmh_complete(&req->base, error);
+}
+
+/*
+ * Submit the final VCQ transaction:
+ *   INIT [+ RESTORE] [+ UPDATE(residual)] + FINAL + FLUSH
+ *
+ * @data_buf: linearised residual data, or NULL for empty-hash.
+ *            Ownership transferred -- callback frees it.
+ * @data_len: bytes in data_buf.
+ */
+static int cmh_hash_submit_final(struct ahash_request *req,
+				 u8 *data_buf, u32 data_len)
+{
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_hash_alg_info *info = rctx->info;
+	struct vcq_cmd cmds[CMH_HASH_MAX_PAYLOAD];
+	struct core_dispatch d;
+	u32 idx;
+	int ret;
+	gfp_t gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		   GFP_KERNEL : GFP_ATOMIC;
+
+	rctx->data_buf = data_buf;
+	rctx->data_len = data_len;
+
+	/* Allocate digest output buffer */
+	rctx->digest_buf = kzalloc(info->digest_size, gfp);
+	if (!rctx->digest_buf) {
+		ret = -ENOMEM;
+		goto err_free_data;
+	}
+
+	rctx->digest_dma = cmh_dma_map_single(rctx->digest_buf,
+					      info->digest_size,
+					       DMA_FROM_DEVICE);
+	if (cmh_dma_map_error(rctx->digest_dma)) {
+		ret = -ENOMEM;
+		goto err_free_digest;
+	}
+
+	/* Map residual data for UPDATE */
+	rctx->data_dma = DMA_MAPPING_ERROR;
+	if (data_buf && data_len > 0) {
+		rctx->data_dma = cmh_dma_map_single(data_buf, data_len,
+						    DMA_TO_DEVICE);
+		if (cmh_dma_map_error(rctx->data_dma)) {
+			ret = -ENOMEM;
+			goto err_unmap_digest;
+		}
+	}
+
+	/* Map checkpoint for RESTORE */
+	rctx->ckpt_dma = DMA_MAPPING_ERROR;
+	if (rctx->has_checkpoint) {
+		rctx->ckpt_dma = cmh_dma_map_single(rctx->checkpoint,
+						    HC_CONTEXT_SIZE,
+						     DMA_TO_DEVICE);
+		if (cmh_dma_map_error(rctx->ckpt_dma)) {
+			ret = -ENOMEM;
+			goto err_unmap_data;
+		}
+	}
+
+	/* Build VCQ: INIT [+ RESTORE] [+ UPDATE] + FINAL + FLUSH */
+	d = cmh_core_select_instance(CMH_CORE_HC);
+	idx = 0;
+
+	vcq_add_hc_init(&cmds[idx++], d.core_id, info->hc_algo);
+
+	if (rctx->has_checkpoint)
+		vcq_add_hc_restore(&cmds[idx++], d.core_id,
+				   (u64)rctx->ckpt_dma, HC_CONTEXT_SIZE);
+
+	if (data_buf && data_len > 0)
+		vcq_add_hc_update(&cmds[idx++], d.core_id,
+				  (u64)rctx->data_dma, data_len);
+
+	vcq_add_hc_final(&cmds[idx++], d.core_id,
+			 (u64)rctx->digest_dma, info->digest_size);
+
+	vcq_add_flush(&cmds[idx++], d.core_id);
+
+	ret = cmh_vcq_pack_and_submit_async(cmds, idx, rctx->packed,
+					    CMH_HASH_MAX_PACKED,
+					    d.mbx_idx,
+					    cmh_hash_final_complete, req,
+					    !!(req->base.flags &
+					       CRYPTO_TFM_REQ_MAY_BACKLOG),
+					    cmh_tm_async_timeout_jiffies());
+	if (ret == -EBUSY)
+		return -EBUSY;
+	if (ret)
+		goto err_unmap_ckpt;
+
+	return -EINPROGRESS;
+
+err_unmap_ckpt:
+	if (rctx->has_checkpoint)
+		cmh_dma_unmap_single(rctx->ckpt_dma, HC_CONTEXT_SIZE,
+				     DMA_TO_DEVICE);
+err_unmap_data:
+	if (data_buf && data_len > 0)
+		cmh_dma_unmap_single(rctx->data_dma, data_len,
+				     DMA_TO_DEVICE);
+err_unmap_digest:
+	cmh_dma_unmap_single(rctx->digest_dma, info->digest_size,
+			     DMA_FROM_DEVICE);
+err_free_digest:
+	kfree(rctx->digest_buf);
+	rctx->digest_buf = NULL;
+err_free_data:
+	kfree(data_buf);
+	rctx->data_buf = NULL;
+	/*
+	 * Preserve the HC checkpoint on failure: a synchronous rejection is
+	 * retryable, and for a terminal error the inline checkpoint is freed
+	 * with the request context, so it never leaks.  It is cleared only in
+	 * the completion after a successful final().
+	 */
+	return ret;
+}
+
+static int cmh_hash_finup(struct ahash_request *req);
+
+/*
+ * One-shot digest -- delegates to init + finup so that all data is
+ * linearised and mapped through cmh_dma_map_single(), which is the
+ * only DMA mapping path aware of all supported DMA backends.
+ */
+static int cmh_hash_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = cmh_hash_init(req);
+	if (ret)
+		return ret;
+	return cmh_hash_finup(req);
+}
+
+/*
+ * .finup -- hash any remaining data and finalise in one transaction.
+ *
+ * With BLOCK_ONLY the Crypto API prepends the bytes it held back, so
+ * req->src already carries the full tail; linearise it and submit
+ * INIT [+ RESTORE] [+ UPDATE(residual)] + FINAL + FLUSH.  This also
+ * serves .final (the API calls finup with nbytes == 0) and avoids
+ * ahash_def_finup(), which would clone via export/import.
+ */
+static int cmh_hash_finup(struct ahash_request *req)
+{
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
+	u32 data_len = req->nbytes;
+	u8 *data_buf = NULL;
+	gfp_t gfp;
+
+	if (rctx->error)
+		return rctx->error;
+
+	if (data_len == 0)
+		return cmh_hash_submit_final(req, NULL, 0);
+
+	/* Reject an oversized linearisation with a permanent -EMSGSIZE. */
+	if (data_len > KMALLOC_MAX_SIZE)
+		return -EMSGSIZE;
+
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+	      GFP_KERNEL : GFP_ATOMIC;
+
+	data_buf = kmalloc(data_len, gfp | __GFP_NOWARN);
+	if (!data_buf)
+		return -ENOMEM;
+
+	scatterwalk_map_and_copy(data_buf, req->src, 0, data_len, 0);
+
+	return cmh_hash_submit_final(req, data_buf, data_len);
+}
+
+/*
+ * Export core -- purely software.
+ *
+ * Serialise the HC checkpoint (if any).  The Crypto API appends its own
+ * partial-block buffer to the exported state; this callback carries only
+ * HW state.  No HW interaction needed because the incremental model
+ * keeps the checkpoint up-to-date after each .update().
+ */
+static int cmh_hash_export(struct ahash_request *req, void *out)
+{
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
+	struct cmh_hash_export_state *state = out;
+
+	/*
+	 * Zero the whole exported state first: the struct may carry padding,
+	 * so without this the padding would leak kernel memory to user space
+	 * through the ahash export (e.g. algif_hash).
+	 */
+	memset(state, 0, sizeof(*state));
+
+	if (rctx->hw_started && rctx->has_checkpoint)
+		memcpy(state->checkpoint, rctx->checkpoint, HC_CONTEXT_SIZE);
+
+	state->hw_started = rctx->hw_started;
+
+	return 0;
+}
+
+/*
+ * Import core -- purely software.
+ *
+ * Restore the HC checkpoint from a previously exported state.  The
+ * Crypto API restores its own partial-block buffer separately.  The
+ * next .update() or final op will RESTORE the checkpoint into HW.
+ */
+static int cmh_hash_import(struct ahash_request *req, const void *in)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_hash_export_state *state = in;
+
+	memset(rctx, 0, sizeof(*rctx));
+	rctx->info = cmh_hash_get_info(tfm);
+
+	rctx->hw_started = state->hw_started;
+
+	if (state->hw_started) {
+		memcpy(rctx->checkpoint, state->checkpoint, HC_CONTEXT_SIZE);
+		rctx->has_checkpoint = 1;
+	}
+
+	return 0;
+}
+
+/* Registration */
+
+static struct cmh_hash_alg_drv cmh_hash_drvs[CMH_HASH_ALG_COUNT];
+
+/**
+ * cmh_hash_register() - Register SHA-256/384/512/3-256/3-384/3-512 hash algorithms
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_hash_register(void)
+{
+	unsigned int i;
+	int ret;
+
+	if (!cmh_core_present(CMH_CORE_HC))
+		return 0;
+
+	for (i = 0; i < CMH_HASH_ALG_COUNT; i++) {
+		const struct cmh_hash_alg_info *info = &cmh_hash_algs_info[i];
+		struct cmh_hash_alg_drv *drv = &cmh_hash_drvs[i];
+		struct ahash_alg *alg = &drv->alg;
+
+		drv->info = info;
+
+		alg->init   = cmh_hash_init;
+		alg->update = cmh_hash_update;
+		alg->finup  = cmh_hash_finup;
+		alg->digest = cmh_hash_digest;
+		alg->export = cmh_hash_export;
+		alg->import = cmh_hash_import;
+
+		alg->halg.digestsize = info->digest_size;
+		alg->halg.statesize  = sizeof(struct cmh_hash_export_state);
+
+		strscpy(alg->halg.base.cra_name, info->alg_name,
+			CRYPTO_MAX_ALG_NAME);
+		strscpy(alg->halg.base.cra_driver_name, info->drv_name,
+			CRYPTO_MAX_ALG_NAME);
+		alg->halg.base.cra_priority    = 300;
+		alg->halg.base.cra_flags       = CRYPTO_ALG_KERN_DRIVER_ONLY |
+						 CRYPTO_ALG_NO_FALLBACK |
+						 CRYPTO_ALG_ASYNC |
+						 CRYPTO_AHASH_ALG_BLOCK_ONLY;
+		alg->halg.base.cra_blocksize   = info->block_size;
+		alg->halg.base.cra_ctxsize     = 0;
+		alg->halg.base.cra_reqsize     = sizeof(struct cmh_hash_reqctx);
+		alg->halg.base.cra_module      = THIS_MODULE;
+
+		ret = crypto_register_ahash(alg);
+		if (ret) {
+			dev_err(cmh_dev(), "hash: failed to register %s (rc=%d)\n",
+				info->drv_name, ret);
+			/* Unregister any already-registered algorithms */
+			while (i--)
+				crypto_unregister_ahash(&cmh_hash_drvs[i].alg);
+			return ret;
+		}
+
+		dev_dbg(cmh_dev(), "hash: registered %s (priority 300)\n",
+			info->drv_name);
+	}
+
+	return 0;
+}
+
+/**
+ * cmh_hash_unregister() - Unregister SHA hash algorithms from the crypto framework
+ */
+void cmh_hash_unregister(void)
+{
+	unsigned int i;
+
+	if (!cmh_core_present(CMH_CORE_HC))
+		return;
+
+	for (i = 0; i < CMH_HASH_ALG_COUNT; i++) {
+		crypto_unregister_ahash(&cmh_hash_drvs[i].alg);
+		dev_dbg(cmh_dev(), "hash: unregistered %s\n",
+			cmh_hash_algs_info[i].drv_name);
+	}
+}
diff --git a/drivers/crypto/cmh/cmh_main.c b/drivers/crypto/cmh/cmh_main.c
index d7753c4630ba..50218f19ad6f 100644
--- a/drivers/crypto/cmh/cmh_main.c
+++ b/drivers/crypto/cmh/cmh_main.c
@@ -31,6 +31,7 @@
 #include "cmh_mqi.h"
 #include "cmh_txn.h"
 #include "cmh_rh.h"
+#include "cmh_hash.h"
 #include "cmh_mgmt.h"
 #include "cmh_registers.h"
 #include "cmh_debugfs.h"
@@ -202,6 +203,11 @@ static int cmh_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_rh_init;
 
+	/* Register hash algorithms with the kernel crypto API */
+	ret = cmh_hash_register();
+	if (ret)
+		goto err_hash_register;
+
 	/* Register key management device (/dev/cmh_mgmt) */
 	ret = cmh_mgmt_register();
 	if (ret)
@@ -212,6 +218,8 @@ static int cmh_probe(struct platform_device *pdev)
 	return 0;
 
 err_mgmt_register:
+	cmh_hash_unregister();
+err_hash_register:
 	cmh_rh_cleanup(cfg);
 err_rh_init:
 	cmh_tm_cleanup();
@@ -238,6 +246,7 @@ static void cmh_remove(struct platform_device *pdev)
 	cfg = &dev->config;
 
 	cmh_mgmt_unregister();
+	cmh_hash_unregister();
 	cmh_rh_cleanup(cfg);
 	cmh_tm_cleanup();
 	cmh_mqi_cleanup(cfg);
diff --git a/drivers/crypto/cmh/include/cmh_hash.h b/drivers/crypto/cmh/include/cmh_hash.h
new file mode 100644
index 000000000000..198e557be280
--- /dev/null
+++ b/drivers/crypto/cmh/include/cmh_hash.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Kernel Crypto API Hash Driver
+ *
+ * Registers ahash algorithms (SHA-2, SHA-3, and SHAKE families) with the
+ * Linux crypto subsystem.  These are CRYPTO_AHASH_ALG_BLOCK_ONLY drivers,
+ * so the Crypto API buffers partial blocks and hands the driver only
+ * whole-block-aligned data:
+ *
+ *   .init()   -> software-only: zero per-request context
+ *   .update() -> INIT [+ RESTORE] + UPDATE(full blocks) + SAVE + FLUSH
+ *                (also serves final: the API calls finup with nbytes == 0)
+ *   .digest() -> INIT + UPDATE + FINAL + FLUSH (single-shot)
+ *   .export() -> software-only: copy the HC checkpoint
+ *   .import() -> software-only: restore the HC checkpoint
+ */
+
+#ifndef CMH_HASH_H
+#define CMH_HASH_H
+
+#include "cmh_config.h"
+
+int  cmh_hash_register(void);
+void cmh_hash_unregister(void);
+
+#endif /* CMH_HASH_H */
-- 
2.43.7

