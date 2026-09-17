Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020140.outbound.protection.outlook.com [52.101.56.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F3049E14C;
	Thu, 17 Sep 2026 22:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789685982; cv=fail; b=M1mk1yzEUY4Z9rL/JDgA9oX0QMNUU6g3Z+pEeYGMHi+ORqML2rR20DV5kfx5nxk64FoAlQoRSd3heHpJbBHT+WU+OHt41pMGTlg/HCQs2cYaVJ2dhx956xkjq8jthZ6+5YhExBF7q0UkXBRTz91kj3k5l42PFY8/LMrJqQFA11Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789685982; c=relaxed/simple;
	bh=3sh2Rq1tx22uLYO9aKy0cbuniCHP37qy6UxGE3owcg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mrZJ29FtA2CTzBqawjrb0tLstwdS84sGcg4fgaamVQHODyr/EcNibhqQYYabAD688z0j4kJtrAWvV9ugNcYa5xwn5ZKTr3g4elT9A2mb3LCyQW/1Y8E6ybI9DoafEuCllF1we6wTb5shnYrTaN4qDx7mjeXkfPfEg0ZhcrhDpsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=054H6JKJ; arc=fail smtp.client-ip=52.101.56.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="054H6JKJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DWnhb04H1sO1TpO833MNfR+vkakiqpb2cYq9uEskr/EQsPovsinhOSrTBVAylIgssUM64NaZlRGJQlMMo3B7jbs3gkOWDrDhmRmtI08fpk+NqJSNiF/tn/i7F73vKSBk21pl5k+DhUTLzRbM7Z80Z7jbGuUp0KW3UqEI6Oa5eO8ZbkJPBH5jL7d/l7OVgGuYDDRIXqkhpcMhBT+WBtzTpoDdA3lrCSBn6+ku6KbgXPjTU0vJqMMvtnH1ekIcSgqqQpfmIyjMwT099Fzft2m/DQFVnoU6SFT+DVQ1Twf3F0ykhpWscEbH78c5vOYl2wl0d7hkHzSCuKZ8lufeEtWJhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwwcBtRE1uljw0HPn8RwOtf8PSk7ACHE8ZA0Q76mNkc=;
 b=FELr7RwThLi+m4WDiQSi31nNNAz6OznC5khHaOT23eGB6hIm97Q/yttCpDRU6NJ79gmqiDF0ne+9u+P9gvTSayDGmOEjZgj/XUArhOeV2dU2yU6mc1QwU8mV67kbj7i5Bv+AI+AEYZcVdjhEHLBs4h97l8ktfkx4onj/6qy22x8t4jtaY2kBN9hvUGpgutxsTEPWYPTnbMbKAWQNGfn4TwWNidf8K/aR6+/SYlZM0CR2s1u5cxtVGxK+3JZJAtCn2qxd6aG/hYO7FrYnM+telDgj0rv2yVcjru3kHRifaGWeEjMbAleBBAwqcoePszNdy+Db2/Tzfbqh6tV8SjPaWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwwcBtRE1uljw0HPn8RwOtf8PSk7ACHE8ZA0Q76mNkc=;
 b=054H6JKJpPJf3qCB78v+162WGZ5cAgBB9svEdmp8te6ja7qm7WPDi0IyMx4DWXshsdfUzE7mDTpM/XCybgAPMUsU4qs1OoUM+iT+81+NHQtwyzDXIEbOIFzRn5p2nuBKzGcF4xzytV8sxdOJ1n0F9MI1pCZG/eFB+C+DSBPiTk0wWPhq7SbDOdzxF8IvP4IXcKwJWRQQbevgg6jnaJHmdg49Ps+r4tOILBhN8kpQPc0YoA6LImofWUyPFfcdrPsoBIu5fqS/xvASo89ISbzyrko7JP5NistfhgTjUyf35YhDcqalV99fGPh9glLx90JWwKShwQ9lv/GnxVpmnzBh2w==
Received: from SJ0PR13CA0154.namprd13.prod.outlook.com (2603:10b6:a03:2c7::9)
 by BY1PR04MB9633.namprd04.prod.outlook.com (2603:10b6:a03:5b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Thu, 17 Sep
 2026 22:59:34 +0000
Received: from SJ1PEPF000026C8.namprd04.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::78) by SJ0PR13CA0154.outlook.office365.com
 (2603:10b6:a03:2c7::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8 via Frontend Transport; Thu, 17
 Sep 2026 22:59:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 SJ1PEPF000026C8.mail.protection.outlook.com (10.167.244.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Thu, 17 Sep 2026 22:59:33 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id 4D2201801768;
	Thu, 17 Sep 2026 22:59:32 +0000 (UTC)
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
Subject: [PATCH v5 11/19] crypto: cmh - add DRBG hwrng
Date: Thu, 17 Sep 2026 15:59:20 -0700
Message-ID: <20260917225929.2494111-12-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C8:EE_|BY1PR04MB9633:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: aa50b22f-9eb1-4656-7824-08df150f5713
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|82310400026|1800799024|23010399003|10067099003|921020|6133799003|3023799007|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	s2TKjjH/xcRXXwfbBJDfOD7RrQqCwUXVPbs/3LihN9X+brQDkmEL2NdwUPoNSM1bUcLSL9UIQEdw1M7DE8J4+Zza9QUpcHt6iTysd0DfpbONHkvTt7XQ5zo3RpJR7+K8DNA4IJANoM8lZHum9H33AtMGpr83p5U/5BcU4L3buKyp5nqYhSdb/a9eTOUh9ysx6BMkXRNkZz9lnaffW/6F2g9zZjo3g9iFH1R20PgqqGLWMHLR21wkYgMl2DXcTl/85ITmFp+sF7jnO0aAYfOeImfjzUUM6YU3a3KJ6TEwoOvs4lQB5U7b+cguG8CoZnEF0WohN+X4Dt3b+aFoVSmbEoPSp3AIa/OpshMqaMMoNSwA/mQI1ibQjBnvaz2kDpUJRMSJQoT2PxCVjHL/HlJ04ldyo6N99sSQeXwyaVe6FPTx8gyeCWtHt8TL4/dtXE/9PGibZvv5c0k2/5qhslD0vVWBr1x1uPukvG4pxKUV5JrefnB/hn+sL2IYz3RG4P0cVC7mjj05e4EDzqGJt2sLGdOVQgQFzSDZF/p4fKDKCkNGUfTAKU6px+ayG8GUXxfzbTW87WMsCDEi75IWBCV6/HXpMU5LYvmfcAIBBVhaSsKVnpn4k6ghhAmlB18YUr4xcMf/SxnDc9K2k56CsHsYNHU3BK0KKbibnfJKMRg48Kdd5FyULFLz2D8odQv40lfCpM3KxMwvVX5dprrpEFnNLf/fFuWvggd7+KvbsqxPFqQ2/vIE/ndfOjkGRWjDuMxW
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(82310400026)(1800799024)(23010399003)(10067099003)(921020)(6133799003)(3023799007)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QiojtGVtn+6nCkLo7WZzZCfo061f6HIAKZ6bmGQWIYLybky+RBUabD0MP0pO6hjz6rGAO0x2AIti0BCK98liMdINN25cVkecSy2wLd5Wv6vcJRA5TXOCr1f1mNrTCgc0KOrIWtC1Rpcv2As35PeESMk7ORhLCc7vB2JTrUBTiHoCACUHF2/qBtgsXexB8r+eyxZEz8wv9Dl7BAW5yad3tJ/d8N1riCUnJoT8eEuWhNGX8NdlGhvW9T1SAA01Vwdg0fLhmTgr1ZfhRPTZmlB+0QMX3Yc52mJ5jFteK7r7jkB2xZaFgqptDmcf/C8FKWq4v0dbL9npLUs1xDihtTAKmb7LqQX15S5lnlm3uavGb2+zQ3MPLLYrXZhnF85PHDsWJT00m3sUIoyySn+sqov3PYXsXY7ar/uuCEp3FjzaCvIVHHsrctCtnJSq2/JIdUs8
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 22:59:33.8975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa50b22f-9eb1-4656-7824-08df150f5713
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB9633

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

