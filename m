Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022091.outbound.protection.outlook.com [40.93.195.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B9748823C;
	Tue, 25 Aug 2026 22:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696161; cv=fail; b=K7zrSQAA+MTV942BQT34Ad8CsYTeP543YxTium3Db3jdS4mZhK8BHNcMV0Imoziw1mAFjUhH/PYstxuN/RhcRwPUdz/q9TQtQzfuocxzM3YNGbkKGeCZylFHTbfI9QDqktJGXJX7eKsS14rsLrVKqgtCd+Oc/fpFRXcj1Gq8+JY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696161; c=relaxed/simple;
	bh=3sh2Rq1tx22uLYO9aKy0cbuniCHP37qy6UxGE3owcg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EWSIRbg4D9/zq6ol9P7p8yK/ukOxRHUZf4iV0UMKYCXTblZ6MhFfDO3vb9CncsgGtZTFGbXdiT+2ZU+UWZ+UE3PaI8MnodYubKZjkQm5/dqCltxec1h0XcYxxtLy/B1DWIZxNtTHp1toCEwKIB15L5b8CATRPNKMKwsNcBnJTm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=Q7TF/VJm; arc=fail smtp.client-ip=40.93.195.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="Q7TF/VJm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PVe2mcwg54w4Rc28GEKcbvJxhx72SX9fXhbzhXSDa8I3cfiEoOwkN2o6D5VA5mEjeOnT1Pq8b0G9d4GXtlFf1ZbfodvckmlsEazKXOxx8UMS96wmn4fqQ15LlsMcfS16HVIKGnnawCNf9Jaz9Qf0k8G7UEum8UIzAVthOfe5TgVBw9ZwWaVcZigCPDuErrBzq6GAzkrREIgqaAcwN10/XZPYRlRGRR1EHMlmMNCre5b//zmIgf9QnagS1yDK04cgvxmbykLZUPBDJcaDkheFfzxmd3W/FMlnHs0+MU4pPnuGjbwLMQBx1ZcezSdfiKtE9H6xb/4H2RS8W5G90m2Wgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwwcBtRE1uljw0HPn8RwOtf8PSk7ACHE8ZA0Q76mNkc=;
 b=sfcV4ftyrIQTOVgym0f6k4EpdZfcsfD3xtiYvmxlXlJzDUolmbrGbZeXlteP1oj1gQ8cyahjgBpGmz4F3h0IFrfaBqD7nTgdj6KOEGy9QAGNEp1vigddiAC11u+OvqLRTJWmKi4PZkdbYD3B9E0vHT2FaRZ/PLIXBp//a0VRK1YqPwQ2NHsFmBQADXKpQy9XKDH8onLgHym0Kion2xQ6QdjIn+MdP+oULqEJsY9tmN5LK8GfBv6VB5QKlQLx/DKdrPOpVYGcTqC21SdQkUcZ4vwFiJxcw+W3ZxttcWCS9ACoToEPIJAbdx39JUP3p5NS1bOzC149y/lu4iuPV5HPdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwwcBtRE1uljw0HPn8RwOtf8PSk7ACHE8ZA0Q76mNkc=;
 b=Q7TF/VJmqwCiH5PykAGNfjEN39aSZy15NNrTb3q77Mg6yNqV2gN5zZdiypU1q1iLpwLpkwdRyxUWsjJZY/ehplNQlq4EUNkvwo+TRFUyt+KWPi3k7e/03iiQJerMsAgCpWgd21By2sUS2rX9dtAQrUW/VFPxQlYSmaeUpr9tdm24lGiO0pVRLZOyKHXK7Xsn85fTpD80A6+VvzAROoadA6CJzZuRajwu/GLuHQaPGr45rnZUsmWtMet3SIk6bX8MF1tESh5zFEctQKF0F8Ohj+ElOehnjZv1BMCgGa0PwzhSnTeEI55afoQq7oW0mCKAPawYZ3xFaLK0e318/OmusA==
Received: from SJ0PR05CA0046.namprd05.prod.outlook.com (2603:10b6:a03:33f::21)
 by BY5PR04MB6614.namprd04.prod.outlook.com (2603:10b6:a03:1d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Tue, 25 Aug
 2026 22:15:52 +0000
Received: from SJ5PEPF000001D7.namprd05.prod.outlook.com
 (2603:10b6:a03:33f:cafe::1d) by SJ0PR05CA0046.outlook.office365.com
 (2603:10b6:a03:33f::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.6 via Frontend Transport; Tue, 25
 Aug 2026 22:15:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy01.rambus.com; pr=C
Received: from hqxsv-psmtppxy01.rambus.com (192.86.86.210) by
 SJ5PEPF000001D7.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 22:15:52 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy01.rambus.com (Postfix) with ESMTP id 7AA331801769;
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
Subject: [PATCH v4 11/19] crypto: cmh - add DRBG hwrng
Date: Tue, 25 Aug 2026 15:15:30 -0700
Message-ID: <20260825221539.255951-12-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D7:EE_|BY5PR04MB6614:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: b668a00b-d423-438c-a8e6-08df02f66d20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|36860700016|376014|7416014|56012099006|10067099003|6133799003|3023799007|18002099003|22082099003|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	zn8Fgsoeq68CY/aZxst6PNoerTE4q9TArNO+hzCV2JDZK4lhGe4tjHsQ2dwcSVjcnRAyEtzKd0DGvkAHBa2M5PcPmkKWproxj8phP6OOC1JWni5ICtEsYpE9clhVhCf0jL4AaqMKL/Hgktk5jX0aLbU0Mb20nfPmgSvOK4U3idOHxH5eled6saH1afRZr9St/vXQaZmQAKFxGU7716E5P3Y1Vro5R8GU7Th5flqc4kkdtm7wxTn4L/C+Kj8CFnxtZ9/dmcQ2vGs2fFG6Z49wJF8OKjeEr9MN/Z2++nnhkvZtVELtE0Q4Y66UF9jZo/tXd890MIxl2FkpkuMRrubmyqjeywpsrpGdrSeU+aDm6dGs4xMlIAvcyyPSHOIva1CfNSGSwuKW4RjHQIOrJrkw3d4zFBrZtcImT5YXn8OdVA7MnMXI/3i5Ru1co+oanjWl/ZFHKCEQ4pm4SRwnpn4dEURKfod4/H9oZHXNMazSWIamzAdBCQr8z5lzPucIZhbtx3w1brwDztH/Vwp91QGhTaHFEJ/hNp/91q8XJTAG4uIVMn8RWn7go6Dq/4jdtgZ6zSPy5tvkbKwsafr0zecYYazltdkIkS6rNGd6h05V07fOWTrqXT/o72vq4BABPpFW08gEwU8sCiWkwcTCemwPRQh/iQPTex18Mjp8djIJWvRALSO5/43CXYltgUc46Ze9HBVQ9Whbf+nhHcC5rCGu0F1aGBLxuJF+1u8YqD3yTbaIky/IRwyO2HazjB934agH
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy01.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(36860700016)(376014)(7416014)(56012099006)(10067099003)(6133799003)(3023799007)(18002099003)(22082099003)(11063799006)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BMVlHfJlVELRIQO4A8Z1PQHIYt4iEM50w9I55PJTWArFBHo8ETExX3gkBuLqJFDn6RrbrGIZct+ya1bFqyl1SZz5Gifyzo2aP4KQwxhPCOqxmt9OYpeWkv6s0bjCGST+NNd9nsM20IgDjEdwCPcMjdWil/WkWCLj1XP3t+JBNpoVATyXbfUOkDQLjInp4X4oR+E7WqIKsGIk0+whEl3wdr2mP+HVomk9yf1Hdw55rK6MUo4LL6gPBM4eduZPCo3er2MXK6ybLMbieljjKbdN2aiwTku3bjA6sjktl4EkBqDOQaVX9nPlFFfWbXDewRtZvzdvsfGAlRqIx9gqwe2atFJTP2sy7QAHf7+et53GLe0mLw9Hj+Zsz0wxkJmy2tZ9iq60Bw2B6Txw67R3nf/CR0pdQmm1Uhj+lpXrVsTmWdXGIZVwI4FtoAQneDdfouDF
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 22:15:52.5507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b668a00b-d423-438c-a8e6-08df02f66d20
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy01.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6614

Register the CMH DRBG core (core ID 0x0f) as an hwrng provider.
The hardware implements a NIST SP 800-90A compliant DRBG with
automatic self-seeding.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 drivers/crypto/cmh/Makefile   |   3 +-
 drivers/crypto/cmh/cmh_main.c |   9 ++
 drivers/crypto/cmh/cmh_rng.c  | 281 ++++++++++++++++++++++++++++++++++
 3 files changed, 292 insertions(+), 1 deletion(-)
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
index 0738b9815a11..b06a5ea0df4f 100644
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
@@ -235,6 +236,11 @@ static int cmh_probe(struct platform_device *pdev)
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
@@ -308,6 +314,8 @@ static int cmh_probe(struct platform_device *pdev)
 err_aes_aead_register:
 	cmh_aes_unregister();
 err_aes_register:
+	cmh_rng_unregister();
+err_rng_register:
 	cmh_sm3_unregister();
 err_sm3_register:
 	cmh_kmac_unregister();
@@ -353,6 +361,7 @@ static void cmh_remove(struct platform_device *pdev)
 	cmh_aes_cmac_unregister();
 	cmh_aes_aead_unregister();
 	cmh_aes_unregister();
+	cmh_rng_unregister();
 	cmh_sm3_unregister();
 	cmh_kmac_unregister();
 	cmh_cshake_unregister();
diff --git a/drivers/crypto/cmh/cmh_rng.c b/drivers/crypto/cmh/cmh_rng.c
new file mode 100644
index 000000000000..a73634024e13
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_rng.c
@@ -0,0 +1,281 @@
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
+ * CMH security model.  The driver attempts CONFIG at probe with the
+ * hardcoded ratio/strength defaults; this succeeds in stateless mode
+ * (any host may CONFIG) or when this host is the management host.  On
+ * -EPERM the driver logs a notice and continues -- GENERATE works once
+ * the management host configures the DRBG.
+ *
+ * The management host (or any privileged user-space process) can also
+ * reconfigure the DRBG at runtime via CMH_IOCTL_DRBG_CONFIG.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
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
+/* Backoff before re-issuing a blocking read after a transient DRBG error. */
+#define CMH_DRBG_RETRY_BACKOFF_MS	20U
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
+			/*
+			 * Back off before the hwrng core re-issues the
+			 * blocking read: rng_dev_read() loops on a 0 return
+			 * with only a conditional need_resched, so a persistent
+			 * transient fault would otherwise spin the CPU.
+			 */
+			msleep(CMH_DRBG_RETRY_BACKOFF_MS);
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
+ * Attempt a DRBG CONFIG VCQ (best effort; -EPERM when not the management
+ * host is non-fatal), then register the hwrng device with the kernel
+ * hwrng framework.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_rng_register(struct platform_device *pdev)
+{
+	struct vcq_cmd cfg_vcq[DRBG_CONFIG_VCQ_CMDS];
+	int ret;
+
+	/*
+	 * The hwrng core elevates a zero quality to full trust (1024) for
+	 * a hardware RNG, so cmh_hwrng.quality is left at 0.  Set it in the
+	 * hwrng initializer to lower the entropy estimate if a platform
+	 * requires it.
+	 *
+	 * DRBG CONFIG is a management-host operation.  Attempt it: it
+	 * succeeds in stateless mode (any host) or when we are the
+	 * management host.  On -EPERM (not the management host) continue
+	 * without error -- GENERATE works once the management host has
+	 * configured the DRBG.
+	 */
+	vcq_set_header(&cfg_vcq[0], DRBG_CONFIG_VCQ_CMDS);
+	vcq_add_drbg_reset(&cfg_vcq[1]);
+	vcq_add_drbg_config(&cfg_vcq[2], CMH_DRBG_ENTROPY_RATIO,
+			    CMH_DRBG_SECURITY_STRENGTH);
+	vcq_add_flush(&cfg_vcq[3], CORE_ID_DRBG);
+	ret = cmh_tm_submit_sync(cfg_vcq, DRBG_CONFIG_VCQ_CMDS, 1);
+	if (ret == -EPERM)
+		dev_notice(&pdev->dev,
+			   "rng: DRBG config not permitted (not management host); assuming external configuration\n");
+	else if (ret)
+		dev_warn(&pdev->dev,
+			 "rng: DRBG config failed (rc=%d)\n", ret);
+
+	ret = hwrng_register(&cmh_hwrng);
+	if (ret) {
+		dev_err(&pdev->dev, "rng: hwrng_register failed (rc=%d)\n",
+			ret);
+		return ret;
+	}
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

