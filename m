Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020110.outbound.protection.outlook.com [52.101.85.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EC2489885;
	Tue, 25 Aug 2026 22:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.110
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696165; cv=fail; b=idHexuEmZdv84ClKmuG2UQ4JD9S4RW/JGa2oSsUdVmHeFC1/toETHX+GLtn6b+vHeRAEaPo56HLpwSAvM8QN5UDHlmo0/Jt/Cz9j23VZdkoEF5YmGcCvLsR+rbYkEUwG5NZV9quyYLSChtYA052aIRfKHluOoOTVsasnPnBh53Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696165; c=relaxed/simple;
	bh=ntfd8ECUKYyh2iCwirIhPCUGf3RYvUT8T+G1bz8cMQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=No+yNeJ0sNcYUFQSprvizmINaTYGjOag/bUBXn5kzJTebu0xJkpYXyxNCIQd260SWfq3wvS/U3WZbSGmbJ3KRy4hCwpgB1ElNt5rcEfNPLb22ABMJ77wXDsKFlwem1pZDW+ZI4v8xOiT9GeC86E2JFqpFNDAQC0neGkh3SqcEjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=sCE7dYif; arc=fail smtp.client-ip=52.101.85.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="sCE7dYif"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gmzgwO68tM5aO7hjyMK5GnH3zwEEkFWIWspYe8aHR6LJlWp//sZj9KFtUZIJADGVLyh8OifunApPLUlMapjUQJMWoJxs4xS1Lt1EptYj94VGBvga4yP3pxjmF1uJAjdlLuk2eKRQhT71Ac/miK8LxN20Q+dgTIaw9LxN83Xl6eNb41MB20m91POgp3ij4BDGUe2FqUKgyH+stMSFiy+4JmSgQ/wX1NoA/lLC8FI/vc5ORCBp6UsVgT+nEXN4ItFUe9uX4H9ts3DlD/DAlIoKLxkLO8eDqGA+zCccoY/0laLkuR0Rpk1j6EVqfWidWduDbFnUeccHOqfk20NqhiWaZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTRLE97/EmazR1ngSXgfXnURE205n9wTGUZoyUSI90c=;
 b=LbPr1Q9/YpsIuH+d9DGjBcjX+FuFwxrBfDyf28VB0geOgRKNf3v0Ox9MqbhK94qgVaiKG72XF0IJPg2B+r9SnObkFtdH2EHE9vMQYvRqQS/KuGUMhMaz+kXuMS+U3lksdjLx2JEWhVSm7UYM2Vo5BV+UXB/io1ARuCKOuKhPqpVysiFAwXAynhj0+sOgG3eXeCwwkER1siYFhUgd3mYwQzuooiWusHWFNtE7oAcOsknia5EgNFAhln9YnL5TMWrcA4EweGOUo1Mne54H/Ksxbm4odpD6LRO+QJwyJs4f/tKSNfyqr1R94AWMGLcrdpu0KiYU9JUGSORsZaEJlNBWwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTRLE97/EmazR1ngSXgfXnURE205n9wTGUZoyUSI90c=;
 b=sCE7dYifMqX7X0r8QlGLG8x8FOkfRVkt5c6uvrtyedqO7mZa3kGUUaPcJQzsU6D/gGFiqJi/5OQQTl4anPjk1aBuM9x0lXIsd8KoCM2JAQC8QJcEiwn2CmETsfTdKKyMj9g/3M4Qnekk0wxsdRsJSEGdC2sbezH+T3NruXmHNEN/wNmhOXOYaq03J0/kFY56FEtUtHk3pyZKWdNXCX8ejDci1+87aaLk4zFwoHr0cGov1NEllr29T9n1CVvMBudqBd8kpMYaCdlB0cZ1iICufd6+gBaoeDIlmn4P9qmfqU4qe1uMVZfU+wrLKuZ37Rs+aUeftHsg+sNJOwMYJfcDcg==
Received: from SJ0PR13CA0094.namprd13.prod.outlook.com (2603:10b6:a03:2c5::9)
 by DS2PR04MB993725.namprd04.prod.outlook.com (2603:10b6:8:336::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Tue, 25 Aug
 2026 22:15:52 +0000
Received: from SJ1PEPF000023D1.namprd02.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::53) by SJ0PR13CA0094.outlook.office365.com
 (2603:10b6:a03:2c5::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.6 via Frontend Transport; Tue, 25
 Aug 2026 22:15:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy01.rambus.com; pr=C
Received: from hqxsv-psmtppxy01.rambus.com (192.86.86.210) by
 SJ1PEPF000023D1.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 22:15:52 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy01.rambus.com (Postfix) with ESMTP id 410841801763;
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
Subject: [PATCH v4 06/19] crypto: cmh - add CSHAKE/KMAC ahash
Date: Tue, 25 Aug 2026 15:15:25 -0700
Message-ID: <20260825221539.255951-7-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D1:EE_|DS2PR04MB993725:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 8c72ae98-f05d-45e9-3ccf-08df02f66ce6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|7416014|376014|1800799024|921020|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	MS9c70p6EIWWuGlBxy3LfM/Yp+5QTy3qpwylLX7oFBYLoOTqG4NIdY1sHyWu2NS+z5drdTaHSjB0RGqOtflJJftOqWiL8BzYcISrgHaIoAOmFkcSQDr45LPLfQJmSlM1yo8sagyGMSLDIWbBfdVBI5NhX1kVmtveZl1p3FN+58GNRvC4pJ/OB+koroG58JDqh1C8M9mzo7XB547HyHS9KbRMP6v/qUwR3YnSqL7q6S1epacCbBsHfSE9JuybChUcfPP2sEPitFS3s5s17btQwcsFiy+nH3916KP1NPv3c1//S8ClAOpnVuqggPxRyiwlLlS/pb2BhYPbHoyM455CyoF2SZIjB/gkO7zwz3gXbJVo9fH7yKOUZ/Wj1tNz0o7aSepOo5XbYjfu5eHUov7GZqcxeJuNXwg8ChVpBgNV6qHIyytoDwCjIEjfxUjb1b1BY52mpNRboQVcmiZQEpIDPIFBSKjDfXolzSpy291Gpnght6M/2Yxoc8L8qXDDVEb0Q8nwVN2UOZFiYFZeRQjoaoP4MBW0tdwaPstakOykxXHfn8blpQrm6zyAfDo2F0jdS9ZoTQJTxE4apSmmUesWgn/PPaoJzRVgezLqPlUQ9YKu6yDxF4Zew0cIKB7qZ9hkmknOLslevlXCEEtlbDcharBqWEIVG/fGdfVzsH0C+xoWNCadujPjV34XV0T60T2xg264+Z1bvve1QmoNlm44P+PJJ/j7/fLagbLJraDMY9LeJH+u11deSOOVfVuWj6v6
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy01.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(7416014)(376014)(1800799024)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EEVmEjWmX6CvQzJaQHXSi8hVsSsPyj1MqVaH1/CkLy9FxxLLnF1ptZJiXT0DNSGrqnfpXppKL/QzMFWAdTl02FfBnHLg14MO8smc0FSJPiXMLvktzUOswXEhfKjyzkbJjsLSGKr7auDHIxESXKklAnoKreAJ4BCITawcIVMIN8rAYAXHaqxVtgPdB9lRliUGhnL7empDE2IM8bv93VwjHwSAFRluakp8g6Q5/yRZbLViJz1YPsNQxic29nCikrVYd8KrIcQjdl3znJvOuOE54I/0e6iP2JWkiCTTmdoQ2VP2dRe+k8fwkzsjzck3Dy5OL6d7ID/v7CYksyvg8+UmPDcA8w2k3t+BL6kq8iCTWpfxG2awUYnwj0NRAG9vEVR33p0AteITSWCP7nkq/o8LI0SbWJ2oEm3DNmBG1grdJ2ecVmaA00CoD8AagEKJ+PU1
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 22:15:52.1675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c72ae98-f05d-45e9-3ccf-08df02f66ce6
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy01.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR04MB993725

Register ahash algorithms for cSHAKE128, cSHAKE256, KMAC128, and
KMAC256 using the CMH hash core.  cSHAKE supports incremental
update and export/import.  KMAC has a 64KB data cap imposed by the
hardware.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 drivers/crypto/cmh/Makefile             |   4 +-
 drivers/crypto/cmh/cmh_cshake.c         | 956 ++++++++++++++++++++++++
 drivers/crypto/cmh/cmh_kmac.c           | 642 ++++++++++++++++
 drivers/crypto/cmh/cmh_main.c           |  18 +
 drivers/crypto/cmh/include/cmh_cshake.h |  16 +
 drivers/crypto/cmh/include/cmh_kmac.h   |  16 +
 6 files changed, 1651 insertions(+), 1 deletion(-)
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
index 000000000000..3c1712731929
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_cshake.c
@@ -0,0 +1,956 @@
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
+ * Uses the same streaming transaction model as cmh_hash.c: full sponge
+ * rate-blocks are absorbed by hardware per .update(), only a sub-rate
+ * tail is held back, and the running state lives in the SAVEd HC
+ * context -- so cSHAKE hashes and clones at any length with bounded
+ * kernel memory.
+ *   .init()   -> software-only
+ *   .update() -> [first: CSHAKE(+S) | resume: INIT + RESTORE] +
+ *                UPDATE(full rate-blocks) + SAVE + FLUSH; tail held back
+ *   .final()  -> [first: CSHAKE(+S) | resume: INIT + RESTORE]
+ *                [+ UPDATE(residual)] + FINAL + FLUSH
+ *   .export() -> serialise checkpoint + holdback (software-only)
+ *   .import() -> restore checkpoint + holdback (software-only)
+ *
+ * The cSHAKE prefix (function name N, customization string S) is
+ * absorbed once by HC_CMD_CSHAKE on the first submission (bytepad-ded to
+ * a full rate block, so message absorption stays rate-aligned) and is
+ * carried thereafter in the SAVEd sponge state; resume re-establishes
+ * the mode with HC_CMD_INIT before HC_CMD_RESTORE.  The HC core supports
+ * HC_CMD_SAVE / HC_CMD_RESTORE for SHAKE/cSHAKE (outlen stays 0, unlike
+ * KMAC), which is what enables both streaming and transform cloning.
+ *
+ * .setkey() here configures public domain-separation parameters (N, S),
+ * not a secret key.
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
+/*
+ * SHAKE sponge rates (SP 800-185): the block granularity for incremental
+ * absorption.  cSHAKE shares the SHAKE rate.
+ */
+#define CMH_SHAKE128_RATE	168U
+#define CMH_SHAKE256_RATE	136U
+
+struct cmh_cshake_alg_info {
+	u32         hc_algo;
+	u32         digest_size;
+	u32         block_size;   /* sponge rate for incremental UPDATE */
+	const char *alg_name;
+	const char *drv_name;
+};
+
+static const struct cmh_cshake_alg_info cmh_cshake_algs_info[] = {
+	{
+		.hc_algo     = HC_ALGO_SHAKE128,
+		.digest_size = CMH_SHAKE128_DIGEST_SIZE,
+		.block_size  = CMH_SHAKE128_RATE,
+		.alg_name    = "cshake128",
+		.drv_name    = "rambus-cmh-cshake128",
+	},
+	{
+		.hc_algo     = HC_ALGO_SHAKE256,
+		.digest_size = CMH_SHAKE256_DIGEST_SIZE,
+		.block_size  = CMH_SHAKE256_RATE,
+		.alg_name    = "cshake256",
+		.drv_name    = "rambus-cmh-cshake256",
+	},
+};
+
+#define CMH_CSHAKE_ALG_COUNT  ARRAY_SIZE(cmh_cshake_algs_info)
+
+/* Per-Request State */
+
+/* Larger of the two sponge rates; sizes the sub-rate holdback buffer. */
+#define CMH_CSHAKE_MAX_RATE      CMH_SHAKE128_RATE
+
+/*
+ * Max payload slots for a streaming cSHAKE transaction.  Worst case is a
+ * resume with the largest customization string:
+ *   CSHAKE (1) + inline S (4) + RESTORE (1) + UPDATE (1) + SAVE/FINAL (1)
+ *   + FLUSH (1) = 9
+ */
+#define CMH_CSHAKE_MAX_PAYLOAD   9
+#define CMH_CSHAKE_MAX_PACKED    (CMH_CSHAKE_MAX_PAYLOAD * 2)
+
+/* Fail the build if a large customization string would overflow cmds[]. */
+static_assert(CMH_CSHAKE_MAX_PAYLOAD >=
+	      1 + DIV_ROUND_UP(HC_CSHAKE_MAX_CUSTOMLEN,
+			       sizeof(struct vcq_cmd)) + 4);
+
+/*
+ * Exported request state (statesize): the HC checkpoint from the last
+ * SAVE plus the sub-rate holdback.  Mirrors the unkeyed hash driver so
+ * cSHAKE streams to hardware and clones at any length.
+ */
+struct cmh_cshake_export_state {
+	u8  checkpoint[HC_CONTEXT_SIZE];
+	u8  buf[CMH_CSHAKE_MAX_RATE];
+	u32 buf_len;
+	u32 hw_started;
+};
+
+/*
+ * Stored in ahash_request_ctx().  The checkpoint and holdback are
+ * embedded inline (not heap): the kernel ahash API has no per-request
+ * destructor, so an abandoned request must not leak.
+ */
+struct cmh_cshake_reqctx {
+	const struct cmh_cshake_alg_info *info;
+	int    error;
+	u32    hw_started;      /* non-zero after first HW submission */
+	u32    buf_len;         /* bytes in holdback buf[] */
+	u32    has_checkpoint;  /* non-zero if checkpoint[] valid */
+	/* DMA state for the current async operation */
+	dma_addr_t ckpt_dma;   /* RESTORE input */
+	dma_addr_t save_dma;   /* SAVE output (update only) */
+	dma_addr_t data_dma;   /* UPDATE input */
+	dma_addr_t digest_dma; /* FINAL output (final/digest only) */
+	u8    *save_buf;
+	u8    *data_buf;
+	u32    data_len;
+	u8    *digest_buf;
+	u8     buf[CMH_CSHAKE_MAX_RATE];     /* holdback for partial block */
+	u8     checkpoint[HC_CONTEXT_SIZE];  /* HC context from last SAVE */
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
+/*
+ * Emit the HC prologue that (re-)establishes the sponge mode before an
+ * UPDATE and the trailing SAVE/FINAL:
+ *   cSHAKE (N/S set): CSHAKE [+ inline S]
+ *   plain SHAKE:      INIT
+ * followed by RESTORE when resuming a saved context.  The mode command
+ * is re-issued on resume too: the eSW RESTORE rejects an algo_mode
+ * mismatch, and cSHAKE uses a distinct mode from INIT.  RESTORE then
+ * overwrites the freshly re-absorbed prefix with the saved sponge state.
+ * Returns the next free slot index.
+ */
+static u32 cmh_cshake_emit_prologue(struct vcq_cmd *cmds, u32 idx,
+				    const struct core_dispatch *d,
+				    const struct cmh_cshake_reqctx *rctx,
+				    const struct cmh_cshake_tfm_ctx *tctx,
+				    dma_addr_t ckpt_dma)
+{
+	if (tctx->func_name_len > 0 || tctx->custom_len > 0) {
+		u32 span;
+
+		vcq_add_hc_cshake(&cmds[idx], d->core_id, rctx->info->hc_algo,
+				  tctx->func_name, tctx->func_name_len,
+				  tctx->custom_len);
+		span = vcq_add_inline_data(&cmds[idx], tctx->custom,
+					   tctx->custom_len);
+		idx += span;
+	} else {
+		vcq_add_hc_init(&cmds[idx++], d->core_id, rctx->info->hc_algo);
+	}
+
+	if (rctx->has_checkpoint)
+		vcq_add_hc_restore(&cmds[idx++], d->core_id, (u64)ckpt_dma,
+				   HC_CONTEXT_SIZE);
+
+	return idx;
+}
+
+/* Reset per-request state (no heap held between operations). */
+static void cmh_cshake_free_reqctx(struct cmh_cshake_reqctx *rctx)
+{
+	rctx->has_checkpoint = 0;
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
+	/*
+	 * Free previous N and S.  Unlocked against a concurrent .update()/
+	 * .final() that reads them: the crypto API does not issue setkey
+	 * concurrently with an in-flight request on the same tfm, and the
+	 * only frontend that allowed that race (AF_ALG setsockopt vs I/O)
+	 * is not built on this kernel.
+	 */
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
+	memset(rctx, 0, sizeof(*rctx));
+	rctx->info = cmh_cshake_get_info(tfm);
+
+	return 0;
+}
+
+/*
+ * Update completion -- runs from the threaded IRQ after SAVE.  Takes the
+ * SAVEd context as the new checkpoint.
+ */
+static void cmh_cshake_update_complete(void *data, int error)
+{
+	struct ahash_request *req = data;
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
+	cmh_dma_unmap_single(rctx->save_dma, HC_CONTEXT_SIZE,
+			     DMA_FROM_DEVICE);
+	cmh_dma_unmap_single(rctx->data_dma, rctx->data_len,
+			     DMA_TO_DEVICE);
+
+	if (!error) {
+		memcpy(rctx->checkpoint, rctx->save_buf, HC_CONTEXT_SIZE);
+		rctx->has_checkpoint = 1;
+		rctx->hw_started = 1;
+	} else {
+		rctx->error = error;
+	}
+
+	kfree(rctx->save_buf);
+	rctx->save_buf = NULL;
+	kfree(rctx->data_buf);
+	rctx->data_buf = NULL;
+	rctx->data_len = 0;
+
+	cmh_complete(&req->base, error);
+}
+
+/*
+ * .update -- absorb full sponge rate-blocks in hardware, hold back the
+ * sub-rate tail.  When at least one full block is available it is
+ * linearised and submitted as:
+ *   [first: CSHAKE(+S) | resume: INIT + RESTORE] + UPDATE + SAVE + FLUSH
+ * Returns -EINPROGRESS on HW submission, 0 if only buffering the tail.
+ */
+static int cmh_cshake_update(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_cshake_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_cshake_alg_info *info = rctx->info;
+	struct vcq_cmd cmds[CMH_CSHAKE_MAX_PAYLOAD];
+	struct core_dispatch d;
+	u32 block_size = info->block_size;
+	u32 total_avail, full_len, tail_len, from_src;
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
+	/* buf_len + nbytes must not wrap u32 (mirrors the hash driver). */
+	if (req->nbytes > U32_MAX - rctx->buf_len)
+		return -EMSGSIZE;
+
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+	      GFP_KERNEL : GFP_ATOMIC;
+
+	total_avail = rctx->buf_len + req->nbytes;
+
+	/* Not enough for a full rate-block -- just buffer the tail. */
+	if (total_avail < block_size) {
+		if (req->base.flags & CRYPTO_AHASH_REQ_VIRT)
+			memcpy(rctx->buf + rctx->buf_len,
+			       req->svirt, req->nbytes);
+		else
+			scatterwalk_map_and_copy(rctx->buf + rctx->buf_len,
+						 req->src, 0,
+						 req->nbytes, 0);
+		rctx->buf_len = total_avail;
+		return 0;
+	}
+
+	/* Have at least one full rate-block -- absorb it in hardware. */
+	full_len = total_avail - total_avail % block_size;
+	tail_len = total_avail - full_len;
+	from_src = full_len - rctx->buf_len;
+
+	rctx->data_buf = kmalloc(full_len, gfp | __GFP_NOWARN);
+	if (!rctx->data_buf)
+		return -ENOMEM;
+
+	if (rctx->buf_len > 0)
+		memcpy(rctx->data_buf, rctx->buf, rctx->buf_len);
+
+	if (from_src > 0) {
+		if (req->base.flags & CRYPTO_AHASH_REQ_VIRT)
+			memcpy(rctx->data_buf + rctx->buf_len,
+			       req->svirt, from_src);
+		else
+			scatterwalk_map_and_copy(rctx->data_buf + rctx->buf_len,
+						 req->src, 0,
+						 from_src, 0);
+	}
+
+	rctx->save_buf = kzalloc(HC_CONTEXT_SIZE, gfp);
+	if (!rctx->save_buf) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
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
+						    DMA_TO_DEVICE);
+		if (cmh_dma_map_error(rctx->ckpt_dma)) {
+			ret = -ENOMEM;
+			goto err_unmap_save;
+		}
+	}
+
+	rctx->data_len = full_len;
+
+	d = cmh_core_select_instance(CMH_CORE_HC);
+	idx = cmh_cshake_emit_prologue(cmds, 0, &d, rctx, tctx,
+				       rctx->ckpt_dma);
+
+	vcq_add_hc_update(&cmds[idx++], d.core_id,
+			  (u64)rctx->data_dma, full_len);
+	vcq_add_hc_save(&cmds[idx++], d.core_id,
+			(u64)rctx->save_dma, HC_CONTEXT_SIZE);
+	vcq_add_flush(&cmds[idx++], d.core_id);
+
+	ret = cmh_vcq_pack_and_submit_async(cmds, idx, rctx->packed,
+					    CMH_CSHAKE_MAX_PACKED,
+					    d.mbx_idx,
+					    cmh_cshake_update_complete, req,
+					    !!(req->base.flags &
+					       CRYPTO_TFM_REQ_MAY_BACKLOG),
+					    cmh_tm_async_timeout_jiffies());
+	if (ret && ret != -EBUSY)
+		goto err_unmap_ckpt;
+
+	/*
+	 * Submit accepted (in flight or backlogged) -- only now move the tail
+	 * into the holdback.  A synchronous rejection above (e.g. -EAGAIN)
+	 * leaves rctx->buf/buf_len untouched so the caller can retry the
+	 * identical update.
+	 */
+	if (tail_len > 0) {
+		if (req->base.flags & CRYPTO_AHASH_REQ_VIRT)
+			memcpy(rctx->buf, req->svirt + from_src, tail_len);
+		else
+			scatterwalk_map_and_copy(rctx->buf, req->src,
+						 from_src, tail_len, 0);
+	}
+	rctx->buf_len = tail_len;
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
+ * Final completion -- unmap DMA, copy digest, signal done.
+ */
+static void cmh_cshake_final_complete(void *data, int error)
+{
+	struct ahash_request *req = data;
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
+	cmh_cshake_free_reqctx(rctx);
+	cmh_complete(&req->base, error);
+}
+
+/*
+ * Submit the final transaction:
+ *   [first: CSHAKE(+S) | resume: INIT + RESTORE] [+ UPDATE(residual)]
+ *   + FINAL + FLUSH
+ *
+ * @data_buf: linearised residual (holdback), or NULL for empty input.
+ *            Ownership transferred -- the callback frees it.
+ */
+static int cmh_cshake_submit_final(struct ahash_request *req,
+				   u8 *data_buf, u32 data_len)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_cshake_tfm_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_cshake_alg_info *info = rctx->info;
+	struct vcq_cmd cmds[CMH_CSHAKE_MAX_PAYLOAD];
+	struct core_dispatch d;
+	u32 idx;
+	int ret;
+	gfp_t gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		    GFP_KERNEL : GFP_ATOMIC;
+
+	rctx->data_buf = data_buf;
+	rctx->data_len = data_len;
+
+	rctx->digest_buf = kzalloc(info->digest_size, gfp);
+	if (!rctx->digest_buf) {
+		ret = -ENOMEM;
+		goto err_free_data;
+	}
+
+	rctx->digest_dma = cmh_dma_map_single(rctx->digest_buf,
+					      info->digest_size,
+					      DMA_FROM_DEVICE);
+	if (cmh_dma_map_error(rctx->digest_dma)) {
+		ret = -ENOMEM;
+		goto err_free_digest;
+	}
+
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
+	rctx->ckpt_dma = DMA_MAPPING_ERROR;
+	if (rctx->has_checkpoint) {
+		rctx->ckpt_dma = cmh_dma_map_single(rctx->checkpoint,
+						    HC_CONTEXT_SIZE,
+						    DMA_TO_DEVICE);
+		if (cmh_dma_map_error(rctx->ckpt_dma)) {
+			ret = -ENOMEM;
+			goto err_unmap_data;
+		}
+	}
+
+	d = cmh_core_select_instance(CMH_CORE_HC);
+	idx = cmh_cshake_emit_prologue(cmds, 0, &d, rctx, tctx,
+				       rctx->ckpt_dma);
+
+	if (data_buf && data_len > 0)
+		vcq_add_hc_update(&cmds[idx++], d.core_id,
+				  (u64)rctx->data_dma, data_len);
+
+	vcq_add_hc_final(&cmds[idx++], d.core_id,
+			 (u64)rctx->digest_dma, info->digest_size);
+	vcq_add_flush(&cmds[idx++], d.core_id);
+
+	ret = cmh_vcq_pack_and_submit_async(cmds, idx, rctx->packed,
+					    CMH_CSHAKE_MAX_PACKED,
+					    d.mbx_idx,
+					    cmh_cshake_final_complete, req,
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
+	cmh_cshake_free_reqctx(rctx);
+	return ret;
+}
+
+static int cmh_cshake_final(struct ahash_request *req)
+{
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+	u8 *data_buf = NULL;
+	u32 data_len = 0;
+	gfp_t gfp;
+
+	if (rctx->error)
+		return rctx->error;
+
+	if (rctx->buf_len > 0) {
+		gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		      GFP_KERNEL : GFP_ATOMIC;
+		data_buf = kmalloc(rctx->buf_len, gfp);
+		if (!data_buf)
+			return -ENOMEM;
+		memcpy(data_buf, rctx->buf, rctx->buf_len);
+		data_len = rctx->buf_len;
+		rctx->buf_len = 0;
+	}
+
+	return cmh_cshake_submit_final(req, data_buf, data_len);
+}
+
+/*
+ * .finup -- update + final in one transaction.  Linearises the holdback
+ * and new data and submits through the final path (avoids the kernel's
+ * ahash_def_finup() clone-via-export path).
+ */
+static int cmh_cshake_finup(struct ahash_request *req)
+{
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+	u32 data_len;
+	u8 *data_buf;
+	gfp_t gfp;
+
+	if (rctx->error)
+		return rctx->error;
+
+	if (req->nbytes > U32_MAX - rctx->buf_len)
+		return -EMSGSIZE;
+
+	data_len = rctx->buf_len + req->nbytes;
+
+	if (data_len == 0)
+		return cmh_cshake_submit_final(req, NULL, 0);
+
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+	      GFP_KERNEL : GFP_ATOMIC;
+
+	data_buf = kmalloc(data_len, gfp | __GFP_NOWARN);
+	if (!data_buf)
+		return -ENOMEM;
+
+	if (rctx->buf_len > 0)
+		memcpy(data_buf, rctx->buf, rctx->buf_len);
+
+	if (req->nbytes > 0) {
+		if (req->base.flags & CRYPTO_AHASH_REQ_VIRT)
+			memcpy(data_buf + rctx->buf_len,
+			       req->svirt, req->nbytes);
+		else
+			scatterwalk_map_and_copy(data_buf + rctx->buf_len,
+						 req->src, 0,
+						 req->nbytes, 0);
+	}
+
+	rctx->buf_len = 0;
+	return cmh_cshake_submit_final(req, data_buf, data_len);
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
+/*
+ * Export -- purely software.  Serialise the HC checkpoint (if any) and
+ * the holdback into the export state; the streaming .update() keeps the
+ * checkpoint current after each block.
+ */
+static int cmh_cshake_export(struct ahash_request *req, void *out)
+{
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+	struct cmh_cshake_export_state *state = out;
+
+	/*
+	 * Zero the whole state first: only buf_len bytes of buf[] are
+	 * populated and the struct may carry padding, so this avoids
+	 * leaking kernel memory through the ahash export.
+	 */
+	memset(state, 0, sizeof(*state));
+
+	if (rctx->hw_started)
+		memcpy(state->checkpoint, rctx->checkpoint, HC_CONTEXT_SIZE);
+
+	if (rctx->buf_len > 0)
+		memcpy(state->buf, rctx->buf, rctx->buf_len);
+
+	state->buf_len = rctx->buf_len;
+	state->hw_started = rctx->hw_started;
+
+	return 0;
+}
+
+/*
+ * Import -- purely software.  Restore checkpoint and holdback; the next
+ * .update()/.final() RESTOREs the checkpoint into HW.
+ */
+static int cmh_cshake_import(struct ahash_request *req, const void *in)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cmh_cshake_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_cshake_export_state *state = in;
+
+	memset(rctx, 0, sizeof(*rctx));
+	rctx->info = cmh_cshake_get_info(tfm);
+
+	/*
+	 * The holdback invariant is buf_len < block_size (update() never
+	 * leaves a full block held back); a larger value would overrun the
+	 * linearisation buffer in the next update().
+	 */
+	if (state->buf_len >= rctx->info->block_size)
+		return -EINVAL;
+
+	rctx->hw_started = state->hw_started;
+	rctx->buf_len = state->buf_len;
+	memcpy(rctx->buf, state->buf, state->buf_len);
+
+	if (state->hw_started) {
+		memcpy(rctx->checkpoint, state->checkpoint, HC_CONTEXT_SIZE);
+		rctx->has_checkpoint = 1;
+	}
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
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct cmh_cshake_reqctx));
+	return 0;
+}
+
+static void cmh_cshake_cra_exit(struct crypto_tfm *tfm)
+{
+	struct cmh_cshake_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
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
+	if (!cmh_core_present(CMH_CORE_HC))
+		return 0;
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
+		alg->halg.statesize  = sizeof(struct cmh_cshake_export_state);
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
+	if (!cmh_core_present(CMH_CORE_HC))
+		return;
+
+	for (i = 0; i < CMH_CSHAKE_ALG_COUNT; i++) {
+		crypto_unregister_ahash(&cmh_cshake_drvs[i].alg);
+		dev_dbg(cmh_dev(), "cshake: unregistered %s\n",
+			cmh_cshake_algs_info[i].drv_name);
+	}
+}
diff --git a/drivers/crypto/cmh/cmh_kmac.c b/drivers/crypto/cmh/cmh_kmac.c
new file mode 100644
index 000000000000..22eaf8975a26
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_kmac.c
@@ -0,0 +1,642 @@
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
+		/*
+		 * Store S.  The raw key (above) and S are replaced without a
+		 * lock against a concurrent .final() reader; safe because the
+		 * crypto API does not issue setkey during an in-flight request
+		 * on the same tfm, and AF_ALG (the only racing frontend) is
+		 * not built on this kernel.
+		 */
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
+	/*
+	 * Cap cumulative input at KMAC_MAX_DATA (64 KB) before the alloc
+	 * below, so sizeof(*chunk) + req->nbytes cannot overflow size_t.
+	 */
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
+	if (!cmh_core_present(CMH_CORE_HC))
+		return 0;
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
+	if (!cmh_core_present(CMH_CORE_HC))
+		return;
+
+	for (i = 0; i < CMH_KMAC_ALG_COUNT; i++) {
+		crypto_unregister_ahash(&cmh_kmac_drvs[i].alg);
+		dev_dbg(cmh_dev(), "kmac: unregistered %s\n",
+			cmh_kmac_algs_info[i].drv_name);
+	}
+}
diff --git a/drivers/crypto/cmh/cmh_main.c b/drivers/crypto/cmh/cmh_main.c
index 589363cc4b28..474b438fc18a 100644
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
@@ -214,6 +216,16 @@ static int cmh_probe(struct platform_device *pdev)
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
@@ -224,6 +236,10 @@ static int cmh_probe(struct platform_device *pdev)
 	return 0;
 
 err_mgmt_register:
+	cmh_kmac_unregister();
+err_kmac_register:
+	cmh_cshake_unregister();
+err_cshake_register:
 	cmh_hmac_unregister();
 err_hmac_register:
 	cmh_hash_unregister();
@@ -254,6 +270,8 @@ static void cmh_remove(struct platform_device *pdev)
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

