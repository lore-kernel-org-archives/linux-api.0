Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11020128.outbound.protection.outlook.com [52.101.46.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADC148F835;
	Tue, 25 Aug 2026 22:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.128
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696161; cv=fail; b=gdx0olI6smbsbMI42zzwW86osvHWY3oX6SG43vG338dCtBuUBo/dox+Hkk8pDOEdJvakMOImeOlz08ENGy8jSbJMNF+WDpwFf3URE4sMRai66yq2+umjak3wX9/zBDQfGXDVjq7eiM4Y8b+eqhx4tUk6HQNBDo7C+NUCbJzKCzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696161; c=relaxed/simple;
	bh=cqAXOxxoz2POJWZPPUW+g09o6AXIm3zIQayAbdYFqQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j7quDri3cnsIpoWkBIpCUTJPTeLoGnyCwgCOQXtcOzPlVzVmje5lpIxRZodv8Ol72E5pvdJJyAOyd1kiSAsY8qheDp8wDMJfHMHtLHIlm24L4+qa3/v9RfL+4HUHTAvefCJhfwmDlMdBCMOztHl0lkCNEltMNDJV4Kp6TYPxHaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=KnWUdUaK; arc=fail smtp.client-ip=52.101.46.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="KnWUdUaK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xz82qES0d4ogABD/+KwLvQlk9JPsf4Rtpzlvqrnp+7hkUh+AB7u58awEbe+0Cg82OS7Uo9SA1q0IIcAJXogE0hcmvpZ1utaDBQYy2ErZxgFC2a2SasaSV6giJLvRisJEICdz46Ebdj8D7pI2T3jHo6wXzsrzemRn2gGwRP3eRkVwx9MvkxbTlfc7rRgCaI1XunM0sIups9JWFt1P3MtZS1y8hZR8GuerN34Ycu8V08I2KrerFGCNBCvkx/wJC0PjsP5qKokObdcPnavEkl2sOCzPXVHy5H3j3vrx6xo0KDRPZV1ux8FkicLYvhIfVgLVMJh87jLwy+aG3u3wNvV3xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpnEa7ob/yXEIBcdEqTkDMaZCv8HH9xyOboFIiUALmg=;
 b=s0LPoePwgYUVDy6xQ4KTO7oEkLvBy2hDkpYcPiJRh8wooPXZkFkpBHCnfCj2nP3VDu4XTwOncDnUP0YR0bBugJO2XdPIZB3UKfq+vsSAg7ZxSCOw+10FFtX9MdmETXZhP4Z9ILdNENyaeWeNIvNmeM5SEANe32IkiEqa1jsVhfTsZVoITN6ssFFkJ0aFH4aX+SVLK+Mg5s1yFmRLs0KbFBqZaxaE/OHT7wtFd+Nuro684iw3dhREDhXHs1YVrUcn/NP3xTPY1CRo8EZ4gePaSalj74Px5MR6X8qklv5L61cgNyuxxiUVBwZWNBoNOwUs4PGqYBQyVHw6CZd9DIrPmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpnEa7ob/yXEIBcdEqTkDMaZCv8HH9xyOboFIiUALmg=;
 b=KnWUdUaKwJw+LxS82sAzqw8RJUgRll4Ae/xKOOA0hCVznj4VtZHWYoIXU2gxEihJFK3WrnEqhT3nY8knOKNe4MXG6WSNtAkKCqDYQ4bsZZLxAl7Y9PYUDff7XcuRqxJMp7zN8kX5XmTqZ2oo7yDnnnZk/hPhMpaPxWEo8HSZUkjOynU5pPQ7WFFmUH3iv0VUydrBW0BxqKqMsW1ye4L1ZJsC/ChpMQBEDAzhVlniGHglXDdln40OAZOryxnaEdcc95cDGcRfx4Yybnj/fhC48mqRO/dNM3zhobrENo/6PSkxxXKoktIah7Pf1Ujk6YRvj7j9Xw2Ery3ztB0KgYOZPQ==
Received: from SJ0PR03CA0217.namprd03.prod.outlook.com (2603:10b6:a03:39f::12)
 by DS2PR04MB993846.namprd04.prod.outlook.com (2603:10b6:8:336::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Tue, 25 Aug
 2026 22:15:51 +0000
Received: from SJ5PEPF000001D6.namprd05.prod.outlook.com
 (2603:10b6:a03:39f:cafe::ae) by SJ0PR03CA0217.outlook.office365.com
 (2603:10b6:a03:39f::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.6 via Frontend Transport; Tue, 25
 Aug 2026 22:15:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy01.rambus.com; pr=C
Received: from hqxsv-psmtppxy01.rambus.com (192.86.86.210) by
 SJ5PEPF000001D6.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 22:15:51 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy01.rambus.com (Postfix) with ESMTP id 2C6811801760;
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
Subject: [PATCH v4 04/19] crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
Date: Tue, 25 Aug 2026 15:15:23 -0700
Message-ID: <20260825221539.255951-5-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D6:EE_|DS2PR04MB993846:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 110e1cee-1bc2-41f4-c388-08df02f66c63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|23010399003|1800799024|82310400026|921020|3023799007|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pobbdeY816mqxT59dELGhmBK6A3euXdfIcAhRs42VxWgubs5jZQzC4Ofs1mfyoqxeCt/N01cVXA4tVSi38YJOGn6Eve+iGNPApNauILitcllM85rI4y/PlwqUe0OQkIP6j5ubVRNKbQMEIB847c85uFfGI5UM80L00KyrzmMuwL5uK6djut9fMNselL05TD2g14yTF8nCwEhAp3Ls0aCietXO/56DU94avY1sXXFNnrWF6E/KvGLGb3i1jzf5YII9+X/PaX6UNFdpi5Ja8NcPjXN5OCQChrPpPq1Zm3feZlLzfsyrO+Lnw5vOymCV8Irg03n+x0IKLA9BMBzvMQau1mvZm1GzftMgnfMPCCgYRjM+rXg3sY7djiSDNQfmhP6GjVmgFn/G1rTJrqDfHtC2FFrL68EOJLmUzNU8XPvKF4oAXx8vM6BdwDHYjSxnMjtCy4TzQ2UXU0gTzikJqBqgiAcdDvYXqFEm0xCPB2jpfmZsdEDoJZQUDfVlnqHn/YNkJfHxsBT1dWFotNAOFSOxZy60/tVeQgFRBKifNo5t10HhhHBfZe/iYBnvzVHpciNvkLKOgi6hOR4uoiFo05mUxwGoeXZR/riEGk7YoqnsB1eGTjF9MC/jX5x+2LXshS2kxLRejSUWBUI8tafiWFnvRwCTBxhYcDejuvHoXoeRdudveVtK9SZYcb+WZjGugZH+pSovJh81Fni1DorH4m1NrRFFjBcocpdWCYfykqrWpeohiXB7Ttk6+KY6L0Tuqxe
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy01.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(23010399003)(1800799024)(82310400026)(921020)(3023799007)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Mlg404DvzKxArfXRw1Kf8aZM+Miv3SHhqNf3PN8BWf48S7OMuapSeDnIDLrFBZRfmoOOke0UHqylSXv9H+CMeRO+35RH4vmCxgqmm6rHaZQcKoUoYlHRyxkB6VNFgt5eDyw8lWUyf7bSAU0uV9MMQevAMj1wTl96Zhu9aC6ABAH9ytCV4OJrX5a+PfawO3asxQ8gIrNncqnlOI+MPD4awvOoi6ODVauLBLWFLeb43Vf/9Ok/gDGT4BS9Rxr/iuyl+DPVF+NVuabQCmLnOgwrVdK0z4B04MAgzWd5axCT05rfz0Zqvr1k8YLTgk+jLCfz4h25xk6gRUNOiKjtEm0s57bhA552nHpUWZAe36xUTJbmp9CRLYJRy47n6AMV8/r6R64eWXV7PQUO3oeHXvAonHn2vaVmg0ns3D0KxhIYv8qwBo5BUc0tdLr3OD4/TX0e
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 22:15:51.3122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 110e1cee-1bc2-41f4-c388-08df02f66c63
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy01.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR04MB993846

Register ahash algorithms for SHA-224, SHA-256, SHA-384, SHA-512,
SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128, and SHAKE256
using the CMH hash core (core ID 0x02).

Supports incremental update/finup/final, init/export/import for
request cloning, and the CRYPTO_AHASH_REQ_VIRT flag for zero-copy
from virtual buffers.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 drivers/crypto/cmh/Makefile           |   3 +-
 drivers/crypto/cmh/cmh_hash.c         | 898 ++++++++++++++++++++++++++
 drivers/crypto/cmh/cmh_main.c         |   9 +
 drivers/crypto/cmh/include/cmh_hash.h |  26 +
 4 files changed, 935 insertions(+), 1 deletion(-)
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
index 000000000000..72d09c5b0c91
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_hash.c
@@ -0,0 +1,898 @@
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
+ * Incremental HW update model -- each .update() with enough data for
+ * at least one full block submits a self-contained VCQ transaction:
+ *
+ *   .init()   -> software-only: zero per-request context
+ *   .update() -> buffer data in holdback; when >= block_size bytes:
+ *                INIT [+ RESTORE] + UPDATE(full blocks) + SAVE + FLUSH
+ *                -> return -EINPROGRESS  (else return 0, data in holdback)
+ *   .final()  -> INIT [+ RESTORE] [+ UPDATE(residual)] + FINAL + FLUSH
+ *   .finup()  -> linearise holdback + new data, then final path
+ *   .digest() -> INIT + UPDATE + FINAL + FLUSH (single-shot via finup)
+ *   .export() -> software-only: copy checkpoint + holdback to out
+ *   .import() -> software-only: restore checkpoint + holdback from in
+ *
+ * The FLUSH after each .update() releases the HC core, so no lockout.
+ * Two hash sessions interleave fine on the same MBX -- each saves its
+ * own state via SAVE and restores via RESTORE on the next call.
+ *
+ * Export/import is purely software (no HW interaction), enabling
+ * crypto API transform clone for all plain-hash algorithms.
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
+	 * The Keccak rate (168 for SHAKE-128, 136 for SHAKE-256) exceeds
+	 * MAX_ALGAPI_BLOCKSIZE (160) on Linux <=6.7.  Using 1 signals
+	 * "byte-oriented" which is correct for XOF consumers.  The kernel
+	 * raised the limit to 208 in 6.8 (commit 2f3a22704889).
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
+/* Maximum cra_blocksize across all registered algorithms (SHA3-224) */
+#define CMH_HASH_MAX_BLOCK	144
+
+/*
+ * Exported hash state -- serialised by .export(), deserialised by
+ * .import().  This is what statesize advertises to the crypto subsystem.
+ */
+struct cmh_hash_export_state {
+	u8  checkpoint[HC_CONTEXT_SIZE]; /* HC context from last SAVE */
+	u8  buf[CMH_HASH_MAX_BLOCK];    /* holdback buffer */
+	u32 buf_len;                     /* valid bytes in buf[] */
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
+ * Stored in ahash_request_ctx().  Tracks the algorithm, a holdback
+ * buffer for partial blocks, an HC context checkpoint from the last
+ * SAVE, and DMA state for the current in-flight async operation.
+ *
+ * The checkpoint is embedded inline rather than heap-allocated because
+ * the kernel ahash API has no per-request destructor.  If a request is
+ * abandoned without .final() (e.g. transform freed early), a heap
+ * checkpoint would leak unconditionally.
+ */
+struct cmh_hash_reqctx {
+	const struct cmh_hash_alg_info *info;
+	int    error;
+	u32    hw_started;      /* non-zero after first HW submission */
+	u32    buf_len;         /* bytes in holdback buf[] */
+	u32    has_checkpoint;  /* non-zero if checkpoint[] valid */
+	/* DMA state for current async operation */
+	dma_addr_t ckpt_dma;   /* RESTORE input */
+	dma_addr_t save_dma;   /* SAVE output (update only) */
+	dma_addr_t data_dma;   /* UPDATE input */
+	dma_addr_t digest_dma; /* FINAL output (final/digest only) */
+	u8    *save_buf;       /* SAVE output buffer */
+	u8    *data_buf;       /* linearised data for DMA */
+	u32    data_len;       /* bytes in data_buf */
+	u8    *digest_buf;     /* digest output buffer */
+	u8     buf[CMH_HASH_MAX_BLOCK]; /* holdback for partial block */
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
+ * .update -- buffer incoming data, submit full blocks to HW.
+ *
+ * Maintains a partial-block holdback buffer in rctx->buf[].  When
+ * enough data is available for at least one full block, the full
+ * blocks are linearised and submitted as:
+ *   INIT [+ RESTORE] + UPDATE(full_blocks) + SAVE + FLUSH
+ *
+ * The tail (< block_size) stays in the holdback for the next call.
+ * Returns -EINPROGRESS on HW submission, 0 if only buffering.
+ */
+static int cmh_hash_update(struct ahash_request *req)
+{
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_hash_alg_info *info = rctx->info;
+	struct vcq_cmd cmds[CMH_HASH_MAX_PAYLOAD];
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
+	/*
+	 * Each update() linearises its data into a single kmalloc buffer.
+	 * Guard against rctx->buf_len + req->nbytes overflowing u32, which
+	 * would mis-select the "buffer only" path below and overrun the
+	 * holdback.  Such an update is far too large to service anyway.
+	 */
+	if (req->nbytes > U32_MAX - rctx->buf_len)
+		return -EMSGSIZE;
+
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+	      GFP_KERNEL : GFP_ATOMIC;
+
+	total_avail = rctx->buf_len + req->nbytes;
+
+	/* Not enough for a full block -- just buffer */
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
+	/* Have at least one full block -- submit to HW */
+	full_len = total_avail - total_avail % block_size;
+	tail_len = total_avail - full_len;
+	from_src = full_len - rctx->buf_len;
+
+	/*
+	 * Linearise: holdback prefix + full blocks from scatterlist.
+	 * full_len is user-controlled and can exceed KMALLOC_MAX_SIZE for a
+	 * single large update; __GFP_NOWARN avoids splatting the page
+	 * allocator on an oversized request.
+	 */
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
+	cmh_hash_free_reqctx(rctx);
+	return ret;
+}
+
+static int cmh_hash_final(struct ahash_request *req)
+{
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
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
+	return cmh_hash_submit_final(req, data_buf, data_len);
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
+ * .finup -- update + final combined into a single transaction.
+ *
+ * Linearises the holdback buffer + new data and submits everything
+ * through the final path.  Avoids the kernel's ahash_def_finup()
+ * which would allocate a subrequest and clone via export/import.
+ */
+static int cmh_hash_finup(struct ahash_request *req)
+{
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
+	u32 data_len;
+	u8 *data_buf;
+	gfp_t gfp;
+
+	if (rctx->error)
+		return rctx->error;
+
+	/* Mirror update()'s guard: buf_len + nbytes must not wrap u32. */
+	if (req->nbytes > U32_MAX - rctx->buf_len)
+		return -EMSGSIZE;
+
+	data_len = rctx->buf_len + req->nbytes;
+
+	if (data_len == 0)
+		return cmh_hash_submit_final(req, NULL, 0);
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
+	return cmh_hash_submit_final(req, data_buf, data_len);
+}
+
+/*
+ * Export -- purely software.
+ *
+ * Serialise the HC checkpoint (if any) and holdback buffer into the
+ * export state structure.  No HW interaction needed because the
+ * incremental model keeps checkpoint up-to-date after each .update().
+ */
+static int cmh_hash_export(struct ahash_request *req, void *out)
+{
+	struct cmh_hash_reqctx *rctx = ahash_request_ctx(req);
+	struct cmh_hash_export_state *state = out;
+
+	/*
+	 * Zero the whole exported state first: only rctx->buf_len bytes of
+	 * buf[] are populated below and the struct may carry padding, so
+	 * without this the unused tail/padding would leak kernel memory to
+	 * user space through the ahash export (e.g. algif_hash).
+	 */
+	memset(state, 0, sizeof(*state));
+
+	if (rctx->hw_started && rctx->has_checkpoint)
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
+ * Import -- purely software.
+ *
+ * Restore checkpoint and holdback from a previously exported state.
+ * The next .update() or .final() will RESTORE the checkpoint into HW.
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
+	/*
+	 * Reject a corrupt or malicious state.  The holdback invariant is
+	 * buf_len < block_size (update() never leaves a full block in the
+	 * holdback); a larger value would underflow from_src and overrun
+	 * the linearisation buffer in the next update().  block_size never
+	 * exceeds the buf[] size (CMH_HASH_MAX_BLOCK), so this also bounds
+	 * the memcpy below.
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
+/* Transform init (cra_init) -- set per-request context size */
+
+static int cmh_hash_cra_init(struct crypto_tfm *tfm)
+{
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct cmh_hash_reqctx));
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
+		alg->final  = cmh_hash_final;
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
+						 CRYPTO_ALG_REQ_VIRT;
+		alg->halg.base.cra_blocksize   = info->block_size;
+		alg->halg.base.cra_ctxsize     = 0;
+		alg->halg.base.cra_init        = cmh_hash_cra_init;
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
index 000000000000..bf17d3af7787
--- /dev/null
+++ b/drivers/crypto/cmh/include/cmh_hash.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Kernel Crypto API Hash Driver
+ *
+ * Registers ahash algorithms (SHA-2, SHA-3, and SHAKE families) with the
+ * Linux crypto subsystem.  Uses an incremental HW update model:
+ *
+ *   .init()   -> software-only: zero per-request context
+ *   .update() -> holdback partial blocks; submit full blocks via
+ *                INIT [+ RESTORE] + UPDATE + SAVE + FLUSH
+ *   .final()  -> INIT [+ RESTORE] [+ UPDATE(residual)] + FINAL + FLUSH
+ *   .digest() -> INIT + UPDATE + FINAL + FLUSH (single-shot)
+ *   .export() -> software-only: copy checkpoint + holdback
+ *   .import() -> software-only: restore checkpoint + holdback
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

