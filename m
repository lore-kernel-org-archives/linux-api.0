Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11020074.outbound.protection.outlook.com [52.101.46.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558223876C5;
	Thu,  6 Aug 2026 19:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046140; cv=fail; b=VdbBiSIZHb5FEQhuXC52nwbWqFhcJhBu3vra5fNvUg47HtRRe/Hb5a0d2IVWVqPDXPhYbN8LUgBpdM7HqVSD2xGO5lklCwf/rzX/ZtEw35riXthukMNpCqg4gNYTwo8tZV7Y6BbeVn9s3mmzyX96yl0BsUfDymbnMvjWv6LLunw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046140; c=relaxed/simple;
	bh=y4b83WFv7jr7v4+wak4G+W3reOyA1cy4omabOxZbhDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ig2pp4QYmXwtWzLW230R0JsqBFE7ScJp1IAJOep8BIJ4945EGtznTVMzgcMXR68gy8VggFtW+RWd9ERAXoTQnSSYXxGRrQA8GVxkWtwmeSnSnl7Tt68i3Jv+Xb71jpLcuadITGbhx3dve1T+8a9d07eCBSDIXK0WQICHf6eR7XM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=4F1W1rMi; arc=fail smtp.client-ip=52.101.46.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="4F1W1rMi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pwodE4H0Q/cJiYzk/tXiuujB6KvLRzgzoX82IqkmWyRxEHrXY8wGsd/rqigiEplG7IvW5VSEdrKAysJCChuHFERj9akLQ0DEgirzRcwnWCv7kNEhO2wCxb/a6eRGjgA8Mi0v7ezsdsVGK479V6wq/5992OLep1dXQwyHKQw6G/P+4sedB2s6rxQdXOdTvDK2k/JSr1t04ZBeS00KTpI874nvXISB4Y81yxuPQdK41ctPYDICgBKjTUyZiQbiYXCr3wBzfjssIQycPcO88PrDRBzmHPQaTz99ts6B4KP4u9QwWT8VjI0laVXZ1/eh2PnHwQUw51Cy4eVYS279h1klPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2LIvFwOKRswxwuoYTfEKxCw3qZ3YIP0HFsb+rlyhm4=;
 b=qZzIKGOeMezmflHxT8Zx651lQLLD5qf5I1hg4CUiFxZtuCBBb9TPl0bkE/BvMEh5bTGPgC7rAFlyreZsDLJ8iBi8CaJac4tJnM21vmk/QzZowC0gqW+XbNhSy3wazKxk5TXV0Hwfg6qzQeAKWWuEE050dNc+GU9LO2k38z0499CTtto75K1tkXFsE5nFCMYMyY9WhTn5fd1/gRwYe5QnJBbG10kw253oRMKoMdLrCEUzR/cXIvckHkBNR7ZBYfnLrWT8c7Zv3JZpnZ3yAlUCE6KCsyoX/JbPWguOPlTh3W4jBKiQ+BlPZbvU3rufOufrmjp22PYtX6SEUdhtaHMf0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2LIvFwOKRswxwuoYTfEKxCw3qZ3YIP0HFsb+rlyhm4=;
 b=4F1W1rMi6Tbx0+yK5xfh3HIPNICjWH++Hw/zI4TKU1yyupu+CgZXkqZAcXnNjt5E4PlT7TbdKqFBg+lxAVg7Anryc3ChNkMdcE08tf02IG39b0X3imfkoRkK3wxYpDcJJxo0shdcXbXXe5uhL91za/LaK7HezzAvfjvlwpTQuxqLcYFRq+/1P+kFQILrIqJuR0mo5oGBLMeH8X1VJAYOXUwAxljirCol10ONogi4YCRI1hND3s1PYNKzhsFUaxkiDWVCV3DqB1Lnt8MEqlTfly7zQ7h0JO5XBrSHhwHW5TySiMeuGbuaiEo7MarwB/48fcOF2qflBw5Whh+aAgzDCg==
Received: from BL0PR05CA0013.namprd05.prod.outlook.com (2603:10b6:208:91::23)
 by DS0PR04MB993601.namprd04.prod.outlook.com (2603:10b6:8:424::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Thu, 6 Aug
 2026 19:55:30 +0000
Received: from BN3PEPF0000B36F.namprd21.prod.outlook.com
 (2603:10b6:208:91:cafe::2f) by BL0PR05CA0013.outlook.office365.com
 (2603:10b6:208:91::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.7 via Frontend Transport; Thu, 6
 Aug 2026 19:55:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BN3PEPF0000B36F.mail.protection.outlook.com (10.167.243.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.0
 via Frontend Transport; Thu, 6 Aug 2026 19:55:29 +0000
Received: from hqxsv-cmdev3-skrishnamoorthy.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTPS id 00D27180174C;
	Thu,  6 Aug 2026 19:55:28 +0000 (UTC)
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
Subject: [PATCH v3 11/19] crypto: cmh - add DRBG hwrng
Date: Thu,  6 Aug 2026 12:55:10 -0700
Message-ID: <20260806195519.2703224-12-skrishnamoorthy@rambus.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36F:EE_|DS0PR04MB993601:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: e658e64f-c679-4723-3d40-08def3f4aafb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|376014|36860700016|7416014|11063799006|56012099006|10067099003|6133799003|3023799007|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	g5vOhzYZe/iEdxBQiOGMcDXy5ORpgAT/KVmE3omE6IDoj5tdpZcQVvRsD27S6ZiZZAdG29e3qnNn6iEDQjosKaNCcjR/uFpNzRebxHxuycz8eraCkaPIPSQNaEvYwekdH6MtjBsmLLfMOjCEsJ4ld5z+wdLAkDBtp66dVpKXQjOaz2p6mj7Y/7qlp6rZElwovLp45AFuoywhp7Gl6CDS1oY3xTVN923OajMfpE8Wq1sLvxBnS6E8wKOHOqK9MksVhmfteDVKvdxKNIAFQaBIe3U6Z+jpiFT3tZDqtcSSBZRjco7ZMykD3K6p50Ckg2Hr0aaIL4iVw7yY+6mDPbhrCfHquX/WxTuoi2ns5lg5yMgAfWyabjLt90y9OG0GlzdGGdo/JddungfV/4+4C5Xut5haXO6zWWdtzGu5xq+qMmXLpWUHIDxR9KIzyG9/Hwzlui0cQeE7aC8nSN3fdqko55WEnX+puMjuEJUMwZPpMyISshng5hha5EMsCZNFzAc27TYpYLKCq47nJ+kEiiWS04Br+2Fo5vjB9sCAM2dxBqKAVfVgfKx4IRoHswsELbZkAMdxduv4kR2FYWhF8XLpGPsoM0fYrXOaotmtSxgy2+7Us4kyTfD4kHpVYOenVxD3GwJABxefPIqMFbGsU5kqUuf3Mby3u+XAM4yBKdWqUE1MzGpy2P3hRKSNUwkK9svzYb+khmRmrj/1h1/UvMYKmyZwQnMBmsoC2kTF3GL6MlUaBu3qKp7uAr9K+MGGY5an
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(376014)(36860700016)(7416014)(11063799006)(56012099006)(10067099003)(6133799003)(3023799007)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	o9eOVOP6bdi0BfRd+1/PZ/35DaHRn62PvMddu7ajLBFuNPURaUY91Qw3cUpck0A2BNrpTQBwgdw5z0rba2KgjYHUuRPg4DOl/Mlkf3NyOUBxb8fg/d7i40jUFlhs0J0vbcQrsrBEkSuryfWL/pJ8JjCHkVpC3keDAw/diP1Udw3BBtistZkmiR+rfYV5tnFjdG2n6/lyx1P0aodSN0wagI2NJYef/qHgAKxkpUs3f6246vkFL4bOch+Bv0n6U+r7mM+yxdllm+Hx8I8Xzx8OhTWWh1+Isc8XDJ/7DKGDN8qzhr8TsZiwIaJiQZ+QOBe1e3HigBIKYtPYab2nZZBxD8FIMYgfLFBUYO/QpZtjRpuo/e0zhMP9SnMCOUhOC8O5DrfS6t/vbh+CHQpfEuWfHdytDp8wQhb+dc6snlQ91Iqy0q4DRIWo3u3wZtDdtLhc
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 19:55:29.6928
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e658e64f-c679-4723-3d40-08def3f4aafb
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB993601

From: Alex Ousherovitch <aousherovitch@rambus.com>

Register the CMH DRBG core (core ID 0x0f) as an hwrng provider.
The hardware implements a NIST SP 800-90A compliant DRBG with
automatic self-seeding.

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
Reviewed-by: Thi Nguyen <thin@rambus.com>
---
 drivers/crypto/cmh/Makefile   |   3 +-
 drivers/crypto/cmh/cmh_main.c |   9 +
 drivers/crypto/cmh/cmh_rng.c  | 333 ++++++++++++++++++++++++++++++++++
 3 files changed, 344 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/cmh/cmh_rng.c

diff --git a/drivers/crypto/cmh/Makefile b/drivers/crypto/cmh/Makefile
index ef24879ba1f1..407fd2870f6d 100644
--- a/drivers/crypto/cmh/Makefile
+++ b/drivers/crypto/cmh/Makefile
@@ -28,7 +28,8 @@ cmh-y := \
 	cmh_sm4_cmac.o \
 	cmh_ccp.o \
 	cmh_ccp_aead.o \
-	cmh_ccp_poly.o
+	cmh_ccp_poly.o \
+	cmh_rng.o
 
 # Management ioctl device (/dev/cmh_mgmt): key lifecycle, PKE, PQC ioctls.
 cmh-$(CONFIG_CRYPTO_DEV_CMH_MGMT) += \
diff --git a/drivers/crypto/cmh/cmh_main.c b/drivers/crypto/cmh/cmh_main.c
index 73b25ed7edcb..1e0f5dad8575 100644
--- a/drivers/crypto/cmh/cmh_main.c
+++ b/drivers/crypto/cmh/cmh_main.c
@@ -36,6 +36,7 @@
 #include "cmh_cshake.h"
 #include "cmh_kmac.h"
 #include "cmh_sm3.h"
+#include "cmh_rng.h"
 #include "cmh_aes.h"
 #include "cmh_sm4.h"
 #include "cmh_ccp.h"
@@ -270,6 +271,11 @@ static int cmh_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_sm3_register;
 
+	/* Register hwrng backed by DRBG core */
+	ret = cmh_rng_register(pdev);
+	if (ret)
+		goto err_rng_register;
+
 	/* Register AES skcipher algorithms */
 	ret = cmh_aes_register();
 	if (ret)
@@ -345,6 +351,8 @@ static int cmh_probe(struct platform_device *pdev)
 err_aes_aead_register:
 	cmh_aes_unregister();
 err_aes_register:
+	cmh_rng_unregister();
+err_rng_register:
 	cmh_sm3_unregister();
 err_sm3_register:
 	cmh_kmac_unregister();
@@ -390,6 +398,7 @@ static void cmh_remove(struct platform_device *pdev)
 	cmh_aes_cmac_unregister();
 	cmh_aes_aead_unregister();
 	cmh_aes_unregister();
+	cmh_rng_unregister();
 	cmh_sm3_unregister();
 	cmh_kmac_unregister();
 	cmh_cshake_unregister();
diff --git a/drivers/crypto/cmh/cmh_rng.c b/drivers/crypto/cmh/cmh_rng.c
new file mode 100644
index 000000000000..9532b8d66b4c
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_rng.c
@@ -0,0 +1,333 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Hardware RNG (DRBG) Driver
+ *
+ * Implements a Linux hwrng backed by the CMH DRBG core.  Each .read()
+ * builds a 3-entry VCQ (header + GENERATE + FLUSH) and submits it
+ * synchronously through the Transaction Manager.
+ *
+ * DRBG configuration (CONFIG) is a management-host operation in the
+ * CMH security model.  The driver's behaviour is controlled by the
+ * drbg_config setting (debug-only module parameter):
+ *
+ *   "auto" (default) -- attempt CONFIG at probe with the hardcoded
+ *     ratio/strength defaults.  Succeeds in stateless mode (any host may
+ *     CONFIG) or when this host is the management host in stateful
+ *     mode.  On -EPERM the driver logs a notice and continues --
+ *     GENERATE will work once the management host configures the DRBG.
+ *
+ *   "skip" -- do not issue CONFIG; assume an external management host
+ *     will configure the DRBG.  hwrng is still registered; .read()
+ *     returns -EAGAIN until GENERATE succeeds.
+ *
+ * The management host (or any privileged user-space process) can also
+ * reconfigure the DRBG at runtime via CMH_IOCTL_DRBG_CONFIG.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/hw_random.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+
+#include "cmh_rng.h"
+#include "cmh_vcq.h"
+#include "cmh_txn.h"
+#include "cmh_dma.h"
+#include "cmh_sys.h"
+#include "cmh_config.h"
+
+/* VCQ layout for .read(): header + GENERATE + FLUSH = 3 entries. */
+#define DRBG_READ_VCQ_CMDS	3
+
+/* VCQ layout for CONFIG: header + RESET + CONFIG + FLUSH = 4 entries. */
+#define DRBG_CONFIG_VCQ_CMDS	4
+
+/*
+ * Linux hwrng quality is expressed in bits of entropy per 1024 bits of
+ * input.  The kernel clamps to this maximum; mirror it here so our
+ * MODULE_PARM_DESC and clamp logic stay in sync.
+ */
+#define CMH_HWRNG_QUALITY_MAX	1024
+
+/* Module parameters */
+
+static int hwrng_quality;
+module_param(hwrng_quality, int, 0444);
+MODULE_PARM_DESC(hwrng_quality,
+		 "hwrng entropy quality in bits per 1024 bits of output (1-1024). 0 (default) is left to the hwrng core, which elevates it to full trust (1024); set an explicit value to lower the estimate.");
+
+#ifdef CONFIG_CRYPTO_DEV_CMH_DEBUG
+static char *drbg_config = "auto";
+module_param(drbg_config, charp, 0444);
+MODULE_PARM_DESC(drbg_config,
+		 "[debug] DRBG config at probe: \"auto\"=attempt CONFIG, \"skip\"=assume external (default: auto)");
+#else
+static const char *drbg_config = "auto";
+#endif
+
+/*
+ * DRBG parameters -- hardcoded to production defaults.
+ * Entropy ratio 0 = 1:1 (full entropy), security strength 0x10 = 256-bit.
+ */
+#define CMH_DRBG_ENTROPY_RATIO		0
+#define CMH_DRBG_SECURITY_STRENGTH	0x10
+
+static unsigned int drbg_timeout_ms = 500;
+
+/* VCQ Builders */
+
+static void vcq_add_drbg_generate(struct vcq_cmd *slot, u64 dst_phys, u32 len)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(CORE_ID_DRBG, 0, 1, DRBG_CMD_GENERATE);
+	slot->hwc.drbg.cmd_generate.dst = dst_phys;
+	slot->hwc.drbg.cmd_generate.len = len;
+}
+
+/*
+ * Maximum bytes per DRBG GENERATE request.  The kernel calls .read()
+ * repeatedly to fill larger requests, so capping here is safe.
+ * 32 bytes matches the 256-bit security strength natural output size.
+ */
+#define CMH_DRBG_MAX_GENERATE	32U
+
+/* hwrng .read() callback */
+
+static int cmh_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct cmh_dma_orphan *orphan;
+	struct vcq_cmd vcq[DRBG_READ_VCQ_CMDS];
+	dma_addr_t dma_addr;
+	void *dmabuf;
+	size_t nbytes;
+	int ret;
+
+	if (max == 0)
+		return 0;
+
+	/*
+	 * Our path uses GFP_KERNEL allocations and synchronous VCQ
+	 * submission -- both may sleep.  When the caller indicates
+	 * non-blocking context (!wait), return 0 ("no data yet") so
+	 * the hwrng core retries later.
+	 */
+	if (!wait)
+		return 0;
+
+	nbytes = min_t(size_t, max, CMH_DRBG_MAX_GENERATE);
+
+	orphan = kmalloc_obj(*orphan, GFP_KERNEL);
+	if (!orphan)
+		return -ENOMEM;
+
+	dmabuf = kmalloc(nbytes, GFP_KERNEL);
+	if (!dmabuf) {
+		kfree(orphan);
+		return -ENOMEM;
+	}
+
+	dma_addr = cmh_dma_map_single(dmabuf, nbytes, DMA_FROM_DEVICE);
+	if (cmh_dma_map_error(dma_addr)) {
+		kfree(dmabuf);
+		kfree(orphan);
+		return -ENOMEM;
+	}
+
+	orphan->buf  = dmabuf;
+	orphan->addr = dma_addr;
+	orphan->len  = nbytes;
+	orphan->dir  = DMA_FROM_DEVICE;
+
+	vcq_set_header(&vcq[0], DRBG_READ_VCQ_CMDS);
+	vcq_add_drbg_generate(&vcq[1], dma_addr, nbytes);
+	vcq_add_flush(&vcq[2], CORE_ID_DRBG);
+
+	/*
+	 * Use the noabort variant: if the MBX is occupied by a slow
+	 * operation (e.g. SLH-DSA sign at 120 s), we must not issue
+	 * MBX_COMMAND_ABORT -- that would kill the unrelated in-flight
+	 * VCQ.  On timeout with an in-flight VCQ (-EINPROGRESS), the
+	 * orphan callback defers DMA cleanup until the RH fires.
+	 */
+	ret = cmh_tm_submit_sync_noabort(vcq, DRBG_READ_VCQ_CMDS, 1,
+					 msecs_to_jiffies(drbg_timeout_ms),
+					 cmh_dma_orphan_free, orphan);
+	if (ret == -EINPROGRESS) {
+		/*
+		 * The orphan callback owns dmabuf and frees it on VCQ
+		 * completion.  Return 0 (not -EAGAIN): .read() only runs with
+		 * wait=true (see the !wait early return above), and the hwrng
+		 * core forwards a negative errno straight to a blocking read
+		 * whereas a 0 return makes it retry.
+		 */
+		return 0;
+	}
+
+	/* Normal path or cancelled-from-queue: caller owns DMA */
+	cmh_dma_unmap_single(dma_addr, nbytes, DMA_FROM_DEVICE);
+	kfree(orphan);
+
+	if (ret) {
+		/*
+		 * .read() only runs with wait=true (see the !wait early
+		 * return above).  For known transient conditions return 0 so
+		 * the hwrng core retries the blocking read; a negative errno
+		 * here would be forwarded to userspace on a blocking fd
+		 * (e.g. -EAGAIN violates POSIX).  Propagate genuinely
+		 * unexpected failures so real faults are not masked into an
+		 * indefinite retry loop.
+		 */
+		switch (ret) {
+		case -EAGAIN:
+		case -EBUSY:
+		case -ETIMEDOUT:
+		case -EIO:
+		/*
+		 * -ENODEV: the TM is not running -- occurs when the
+		 * hwrng kthread (PF_NOFREEZE, not frozen during
+		 * suspend) calls .read() while the device is suspended.
+		 * Treat as transient: the TM restarts on resume.
+		 */
+		case -ENODEV:
+			dev_dbg_ratelimited(cmh_dev(),
+					    "rng: transient DRBG failure (rc=%d)\n",
+					    ret);
+			kfree_sensitive(dmabuf);
+			return 0;
+		default:
+			dev_err_ratelimited(cmh_dev(),
+					    "rng: DRBG generate failed (rc=%d)\n",
+					    ret);
+			kfree_sensitive(dmabuf);
+			return ret;
+		}
+	}
+
+	memcpy(data, dmabuf, nbytes);
+	kfree_sensitive(dmabuf);
+
+	return nbytes;
+}
+
+/* Registration */
+
+static bool cmh_rng_registered;
+
+static struct hwrng cmh_hwrng = {
+	.name = "rambus-cmh-drbg",
+	.read = cmh_rng_read,
+};
+
+/**
+ * cmh_rng_register() - Register the CMH hardware RNG device
+ * @pdev: Platform device for the CMH accelerator
+ *
+ * Reads hwrng quality from device tree and module parameters, validates
+ * DRBG configuration, optionally sends a DRBG CONFIG VCQ to firmware,
+ * and registers the hwrng device with the kernel hwrng framework.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_rng_register(struct platform_device *pdev)
+{
+	int ret;
+
+	/*
+	 * The hwrng core forces a proper quality at registration:
+	 * rng->quality = min3(default_quality, 1024, quality ?: 1024).
+	 * So quality 0 is NOT "no seeding" -- it is elevated to the core
+	 * default (full trust, 1024).  Pass the module param through and
+	 * clamp to the max; set hwrng_quality explicitly to lower the
+	 * entropy estimate.
+	 */
+	cmh_hwrng.quality = hwrng_quality;
+
+	if (cmh_hwrng.quality > CMH_HWRNG_QUALITY_MAX)
+		cmh_hwrng.quality = CMH_HWRNG_QUALITY_MAX;
+
+	/*
+	 * DRBG CONFIG is a management-host operation.  In "auto" mode,
+	 * attempt it -- this succeeds in stateless mode (any host) or
+	 * when we are the management host in stateful mode.  On -EPERM
+	 * (not management host) we continue without error -- GENERATE
+	 * will work once the management host configures the DRBG.
+	 *
+	 * In "skip" mode, do not issue CONFIG -- assume the management
+	 * host has already configured (or will configure) the DRBG.
+	 */
+	if (strcmp(drbg_config, "skip") != 0) {
+		struct vcq_cmd cfg_vcq[DRBG_CONFIG_VCQ_CMDS];
+
+		if (strcmp(drbg_config, "auto") != 0)
+			dev_warn(&pdev->dev,
+				 "rng: unrecognized drbg_config=\"%s\", treating as \"auto\"\n",
+				 drbg_config);
+
+		vcq_set_header(&cfg_vcq[0], DRBG_CONFIG_VCQ_CMDS);
+		vcq_add_drbg_reset(&cfg_vcq[1]);
+		vcq_add_drbg_config(&cfg_vcq[2], CMH_DRBG_ENTROPY_RATIO,
+				    CMH_DRBG_SECURITY_STRENGTH);
+		vcq_add_flush(&cfg_vcq[3], CORE_ID_DRBG);
+		ret = cmh_tm_submit_sync(cfg_vcq, DRBG_CONFIG_VCQ_CMDS, 1);
+		if (ret == -EPERM)
+			dev_notice(&pdev->dev,
+				   "rng: DRBG config not permitted (not management host); assuming external configuration\n");
+		else if (ret)
+			dev_warn(&pdev->dev,
+				 "rng: DRBG config failed (rc=%d)\n", ret);
+		else
+			dev_info(&pdev->dev,
+				 "rng: DRBG configured (ratio=%u strength=0x%02x)\n",
+				 CMH_DRBG_ENTROPY_RATIO,
+				 CMH_DRBG_SECURITY_STRENGTH);
+	} else {
+		dev_info(&pdev->dev,
+			 "rng: DRBG config skipped (drbg_config=skip); assuming external configuration\n");
+	}
+
+	ret = hwrng_register(&cmh_hwrng);
+	if (ret) {
+		dev_err(&pdev->dev, "rng: hwrng_register failed (rc=%d)\n",
+			ret);
+		return ret;
+	}
+
+	dev_info(&pdev->dev,
+		 "rng: registered rambus-cmh-drbg (quality=%d timeout=%ums)\n",
+		 cmh_hwrng.quality, drbg_timeout_ms);
+
+	cmh_rng_registered = true;
+	return 0;
+}
+
+/**
+ * cmh_rng_unregister() - Unregister the CMH hardware RNG device
+ *
+ * Unregisters the hwrng device from the kernel hwrng framework if it
+ * was previously registered.
+ */
+void cmh_rng_unregister(void)
+{
+	if (!cmh_rng_registered)
+		return;
+	hwrng_unregister(&cmh_hwrng);
+	cmh_rng_registered = false;
+	dev_info(cmh_dev(), "rng: unregistered rambus-cmh-drbg\n");
+}
+
+/* -- debugfs timeout accessor ------------------------------------------ */
+
+#ifdef CONFIG_CRYPTO_DEV_CMH_DEBUG
+/**
+ * cmh_rng_timeout_drbg_ptr() - Return pointer to drbg_timeout_ms for debugfs
+ *
+ * Exposes the DRBG operation timeout for runtime tuning via debugfs
+ * config/ directory.
+ *
+ * Return: pointer to the static drbg_timeout_ms variable.
+ */
+unsigned int *cmh_rng_timeout_drbg_ptr(void) { return &drbg_timeout_ms; }
+#endif
-- 
2.43.7

