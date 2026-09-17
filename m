Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11020091.outbound.protection.outlook.com [52.101.46.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E26B4B0481;
	Thu, 17 Sep 2026 22:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789685984; cv=fail; b=qGcYz9JLloqvBSHNQDaOwB+o43v9+phbRMh0bTUlw+xkIMGYkPI4sWdMSOKAJM902/Dn01w6v75+pTKXeV4kfdbmHdx9io1Znss3T6SzAgPu4tDVz5rCVrKOwuIilvbzk2M+72G/q5zb0WqnDHGMjGqLSMCw9BCcmW9lfMYPp7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789685984; c=relaxed/simple;
	bh=evSt4A/FvkoEBAv+dzUe+LOCUW3gjCyHmNEsaYrdtsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kuT87tLSFpC2O00qCVO1Gbd7BGJPidHTjo/r606enrb3YX0XnkDtWNHReMhpP0gXffmH5x3D90ZP6IMzL2+x7iFpCTw4Y+JG2kKCSqen1W8sVAv3kgRVrR6E5f2Inr2hso9ZxEiwp4dK73O6AhXMFYQPgdMroZjnyVPrScDBJlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=gObE+Ts+; arc=fail smtp.client-ip=52.101.46.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="gObE+Ts+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9SuSS6cfPxZBn+evcz6kodLSBwWJ8+queg7Zy6sQ/NaYYRGjqrJANpNMzmG/mc7N3XyGLT93+iBCQrhcIH1vfD3uUf/MJrT51LQX2RstRPTkkSq4asifFWaJVLhjg9aP06UnZgSq6uhiJ7KsHpXk61x6C1179+tLm4WJTIK9YlbwthmVO1W9COFE3df/FUwwugznTYXF0rutYW4d+EjpZ+F3Rtl2+LWUiSmO5y6WfkWwySElJuygMTlQpyprkJpfAeXLmzn2hdEGcYSOD/WdeHlOjs0ra9BP/U4pGy1pKYkxB1WxCJNuoJ1NS5wN4kxgXFoiUNl7H+GZ5TkBlFwRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bDt7wAK5h+ciJIa07ayF73SKX4Bw7G7UKRr2NijQ5OM=;
 b=FLXD+QE5EDzeJ0dSBCv6M31u4kCaFrH3kFyHNy/5N6QFxz87z6ecFfmjSdiHrrpZ/IJuL0GJV1O9oYmCFHQ7ZaeNd7D9QqV6/TzKx1OPRCVVKgqWIF0gbOZ+GLTkcLQa9+pzpJwxiKcxxTdElCzDMTIsO1z2SDHEUZpevvdt877StHmHZcJLMredmmPfkH+nCLVyzx/B9ht7HzwC6IDuEdfQspI+3Pun0bCdOXLIXtBSZvu9W0TlK/JVJqAy/oGXUnTD/c0AvQ84b1I98PBGHSVmAkAefqMeJMQjE31pXHpQIn1/mTnnMyk8Gllf3REExLxxq4tibIxaiKCNu+y2Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDt7wAK5h+ciJIa07ayF73SKX4Bw7G7UKRr2NijQ5OM=;
 b=gObE+Ts+W5bYqDoIyUP5jJ11fL/oJb2l3ll4gqEoTQfreXQaerlpGRS0bLUytKhyX4oRCuDzbAG/2+O1BTa6Ih+DDQ9hlWWdCIX4rt+PzI2Zo1XjUDrJOkoL0pkKARDkgZWX2T/PcW4sG8B2xwZ1/c03TNP9is/SVmzraj9JgLFNsL+pI6BiGWbRux+fAHG66SbzSmVorAxv2ay6O7dDxQ9HYsT5hIspV9/GjdJVAsiGBGT2qafxy59/yG0jazP6Z/W6QqHmgaxP0R4uVpuXhPXS3sWe1oYTrEbabrk/V2sMq1nZXy5BgYxD9PEzPRc1xbvhkVeKzxk6Iyi5sSjSaA==
Received: from BLAPR03CA0022.namprd03.prod.outlook.com (2603:10b6:208:32b::27)
 by CY5PR04MB994499.namprd04.prod.outlook.com (2603:10b6:930:12c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Thu, 17 Sep
 2026 22:59:34 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:208:32b:cafe::55) by BLAPR03CA0022.outlook.office365.com
 (2603:10b6:208:32b::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 22:59:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Thu, 17 Sep 2026 22:59:34 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id 16D401801763;
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
Subject: [PATCH v5 07/19] crypto: cmh - add SM3 ahash
Date: Thu, 17 Sep 2026 15:59:16 -0700
Message-ID: <20260917225929.2494111-8-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|CY5PR04MB994499:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: ec77f20e-171f-476a-f68b-08df150f5762
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|1800799024|376014|7416014|3023799007|56012099006|10067099003|11063799006|921020|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Lz4ktcXv+GHHGVvNf4LwXJ1wktbeM0c2I0Sat8TlMMJU0UA50dx7E4ueQr0gcgfxkFh7e5KManHMklEcUAH1+AEkXQZNp/ckHekYBY+IeNWWmjWzYIwRovX3/+zKdsFUA/h+aox4vyHCU5+04yzkBPo+9brA5KUT8yrT+4v909aC1wAX9a5dN8crrCGHSwGeY5UlDQuW4k4a3nY3XkziesLTHIgH+j+BumIO5Y39c3bo1ZyAi7CZZMEVpSVaT3x2kmvpq+1O1H/ye6CvACHEWzAgDwKYybbqvMCOSqHe5zaiN2JOxvlQ2k9ud3bvNmqhxRcTuYl+g8rM6fmeo7JC66yrf6EWxJAmppuZzJw6+uHRCE61c3EFOYtzz2vCJxdIdvtInvpyyUIexlU7eWnnhAxvl1y74TJAqiUZgKN1N54rnZEEvzO/6u0aiwoiNN95rbjQhkn1gbXpaE10X0c1FEmyC0TIF2s+4KjySHpp2KzxIJ1+nzwoyS6qdQ9XvmaxI/eY4oe0U8St+o1j7gPEV0yAM0ewsmktNPrU29zmlW8NyJ6huH9GKPeuwTULg1ItTaSEFFo1R5R2mNmC/IuPD4vSee/G0KhCWFJ1e6kmT4OFVGT6q0OgwvJTmQDdIZukEbYWsKtdfl2LVWyUSrwiuu6CRenoP3IhHqowHvtcGMFWA/WpUxFPUPjXAiHSRLCFYQJiebm+IDvSYYTttftzSk016vfObTftZMkljhYulDvyTUuId7PHkXCtFKKhMjTx
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(1800799024)(376014)(7416014)(3023799007)(56012099006)(10067099003)(11063799006)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	s9IrzjqNYuwPi3uMCSQsz9dJCswuH5Bq0JmiZoI68UGbmP/er/M/IOxABVPe3vKGVfVy0fqUl7ytMKP3otUmbrjqhB9h8MkG2FRfuXZTxL2YIJVntFJ7CR5RjAHVyO1sHm7f8wHu56tahEeEvV0IyRqE4zu2dOy+PTmsE2fjRoIcIpDbsqfFi7zpyJHNzBf06i438+ovqgkTVC4g0VW7aKTeUJO+9vigkGj7Nbcryecg3NoZ+RqqrskCERNE0X2wWBybJ2FboyMnmBbAWUNxH4RRn9b6tY1RF3FqXg3F0rUF8DPwhn48WAaGjYqwufl7u3txqYj+xQE5AEr/6EGmkuLJ9FDye6I5BVPSoxQFBkAMJrnV99G97vmr3xx5fEsUD+mQWjpoGqzoqSpHeX73XJ50Ot5HS4NY8G2EtV+eERHtSNIaaQOMGkaFV/jJRGvU
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 22:59:34.2354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec77f20e-171f-476a-f68b-08df150f5762
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR04MB994499

Register the SM3 ahash algorithm using the CMH SM3 core (core ID
0x05).  Supports incremental update/finup/final and export/import.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 drivers/crypto/cmh/Makefile          |   3 +-
 drivers/crypto/cmh/cmh_main.c        |   9 +
 drivers/crypto/cmh/cmh_sm3.c         | 604 +++++++++++++++++++++++++++
 drivers/crypto/cmh/include/cmh_sm3.h |  28 ++
 4 files changed, 643 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/cmh/cmh_sm3.c
 create mode 100644 drivers/crypto/cmh/include/cmh_sm3.h

diff --git a/drivers/crypto/cmh/Makefile b/drivers/crypto/cmh/Makefile
index 3ab154744658..664b2a20bc19 100644
--- a/drivers/crypto/cmh/Makefile
+++ b/drivers/crypto/cmh/Makefile
@@ -18,7 +18,8 @@ cmh-y := \
 	cmh_hash.o \
 	cmh_hmac.o \
 	cmh_cshake.o \
-	cmh_kmac.o
+	cmh_kmac.o \
+	cmh_sm3.o
 
 # Management ioctl device (/dev/cmh_mgmt): key lifecycle, PKE, PQC ioctls.
 cmh-$(CONFIG_CRYPTO_DEV_CMH_MGMT) += \
diff --git a/drivers/crypto/cmh/cmh_main.c b/drivers/crypto/cmh/cmh_main.c
index 474b438fc18a..4ad1500d8e49 100644
--- a/drivers/crypto/cmh/cmh_main.c
+++ b/drivers/crypto/cmh/cmh_main.c
@@ -35,6 +35,7 @@
 #include "cmh_hmac.h"
 #include "cmh_cshake.h"
 #include "cmh_kmac.h"
+#include "cmh_sm3.h"
 #include "cmh_mgmt.h"
 #include "cmh_registers.h"
 #include "cmh_debugfs.h"
@@ -226,6 +227,11 @@ static int cmh_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_kmac_register;
 
+	/* Register SM3 hash algorithm */
+	ret = cmh_sm3_register();
+	if (ret)
+		goto err_sm3_register;
+
 	/* Register key management device (/dev/cmh_mgmt) */
 	ret = cmh_mgmt_register();
 	if (ret)
@@ -236,6 +242,8 @@ static int cmh_probe(struct platform_device *pdev)
 	return 0;
 
 err_mgmt_register:
+	cmh_sm3_unregister();
+err_sm3_register:
 	cmh_kmac_unregister();
 err_kmac_register:
 	cmh_cshake_unregister();
@@ -270,6 +278,7 @@ static void cmh_remove(struct platform_device *pdev)
 	cfg = &dev->config;
 
 	cmh_mgmt_unregister();
+	cmh_sm3_unregister();
 	cmh_kmac_unregister();
 	cmh_cshake_unregister();
 	cmh_hmac_unregister();
diff --git a/drivers/crypto/cmh/cmh_sm3.c b/drivers/crypto/cmh/cmh_sm3.c
new file mode 100644
index 000000000000..a08341512e5d
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_sm3.c
@@ -0,0 +1,604 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- SM3 Hash Driver (CORE_ID_SM3)
+ *
+ * Registers an asynchronous hash (ahash) algorithm for SM3
+ * (GB/T 32905-2016) using the CMH SM3 core.  This is a standalone
+ * driver separate from cmh_hash.c (which handles HC-based SHA-2/3/SHAKE)
+ * because SM3 runs on a different hardware core with its own command
+ * IDs and context layout.
+ *
+ * Incremental HW update model (same pattern as cmh_hash.c).  The driver
+ * sets CRYPTO_AHASH_ALG_BLOCK_ONLY, so the Crypto API buffers partial
+ * blocks and .update() only ever sees whole-block-aligned data:
+ *
+ *   .init()   -> software-only: zero per-request context
+ *   .update() -> SM3_CMD_INIT [+ RESTORE] + UPDATE + SAVE + FLUSH;
+ *                return -EINPROGRESS, completing with the leftover byte
+ *                count the API must buffer (0 when block-aligned)
+ *   .finup()  -> SM3_CMD_INIT [+ RESTORE] [+ UPDATE] + FINAL + FLUSH
+ *                (also serves .final via the API: nbytes == 0)
+ *   .digest() -> INIT + UPDATE + FINAL + FLUSH (single-shot via finup)
+ *   .export()/.import() -> software-only: copy the SM3 context
+ *                checkpoint; the API appends its own partial-block buffer
+ *
+ * This is an sg-only driver (no CRYPTO_ALG_REQ_VIRT): BLOCK_ONLY buffer
+ * prepending assumes scatterlists.
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
+#include "cmh_sm3.h"
+#include "cmh_vcq.h"
+#include "cmh_txn.h"
+#include "cmh_dma.h"
+
+/* Per-Request State */
+
+/*
+ * Exported SM3 state -- serialised by .export(), deserialised by
+ * .import().  This is what statesize advertises; the Crypto API
+ * appends its own partial-block buffer on top.
+ */
+struct cmh_sm3_export_state {
+	u8  checkpoint[SM3_CONTEXT_SIZE]; /* SM3 context from last SAVE */
+	u32 hw_started;                   /* non-zero if checkpoint valid */
+};
+
+#define CMH_SM3_MAX_PAYLOAD    5   /* INIT + RESTORE + UPDATE + FINAL/SAVE + FLUSH */
+#define CMH_SM3_MAX_PACKED     (CMH_SM3_MAX_PAYLOAD * 2)
+
+/*
+ * Checkpoint embedded inline: the kernel ahash API has no per-request
+ * destructor, so a heap-allocated checkpoint leaks if a request is
+ * abandoned without .final().
+ *
+ * Mapping the inline checkpoint for DMA is safe even on non-coherent
+ * platforms: it is only ever mapped DMA_TO_DEVICE and its bytes are
+ * frozen from dma_map_single() until the matching unmap (it is written
+ * solely in the completion, after the unmap).  CPU writes to adjacent
+ * fields sharing a cacheline never alter the checkpoint bytes, and a
+ * TO_DEVICE unmap performs no cache invalidate; the shared-cacheline
+ * hazard applies only to FROM_DEVICE buffers, which are kmalloc'd.
+ */
+struct cmh_sm3_reqctx {
+	int    error;
+	u32    hw_started;
+	u32    has_checkpoint;
+	u32    update_remainder; /* sub-block bytes the API must re-buffer */
+	u8     checkpoint[SM3_CONTEXT_SIZE]; /* SM3 context from last SAVE */
+	/* DMA state for current async operation */
+	dma_addr_t ckpt_dma;
+	dma_addr_t save_dma;
+	dma_addr_t data_dma;
+	dma_addr_t digest_dma;
+	u8    *save_buf;
+	u8    *data_buf;
+	u32    data_len;
+	u8    *digest_buf;
+	struct vcq_cmd packed[CMH_SM3_MAX_PACKED];
+};
+
+/* VCQ Builders -- SM3 core (CORE_ID_SM3); generic flush from cmh_vcq.h */
+
+static void vcq_add_sm3_init(struct vcq_cmd *slot, u32 core_id)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, SM3_CMD_INIT);
+	/* SM3 has a single algorithm -- no algo selector field */
+}
+
+static void vcq_add_sm3_update(struct vcq_cmd *slot, u32 core_id, u64 input_phys, u32 len)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, SM3_CMD_UPDATE);
+	slot->hwc.sm3.cmd_update.input = input_phys;
+	slot->hwc.sm3.cmd_update.inlen = len;
+}
+
+static void vcq_add_sm3_final(struct vcq_cmd *slot, u32 core_id, u64 digest_phys, u32 outlen)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, SM3_CMD_FINAL);
+	slot->hwc.sm3.cmd_final.digest = digest_phys;
+	slot->hwc.sm3.cmd_final.outlen = outlen;
+}
+
+static void vcq_add_sm3_save(struct vcq_cmd *slot, u32 core_id, u64 output_phys, u32 outlen)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, SM3_CMD_SAVE);
+	slot->hwc.sm3.cmd_save.output = output_phys;
+	slot->hwc.sm3.cmd_save.outlen = outlen;
+}
+
+static void vcq_add_sm3_restore(struct vcq_cmd *slot, u32 core_id, u64 input_phys, u32 inlen)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, SM3_CMD_RESTORE);
+	slot->hwc.sm3.cmd_restore.input = input_phys;
+	slot->hwc.sm3.cmd_restore.inlen = inlen;
+}
+
+/* Request Context Cleanup */
+
+static void cmh_sm3_free_reqctx(struct cmh_sm3_reqctx *rctx)
+{
+	rctx->has_checkpoint = 0;
+}
+
+/* VCQ Packing + Submit */
+
+/* ahash Operations */
+
+static int cmh_sm3_init(struct ahash_request *req)
+{
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
+
+	memset(rctx, 0, sizeof(*rctx));
+	return 0;
+}
+
+/*
+ * Update completion -- takes ownership of save_buf as new checkpoint.
+ */
+static void cmh_sm3_update_complete(void *data, int error)
+{
+	struct ahash_request *req = data;
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
+
+	if (error == -EINPROGRESS) {
+		cmh_complete(&req->base, error);
+		return;
+	}
+
+	if (rctx->has_checkpoint)
+		cmh_dma_unmap_single(rctx->ckpt_dma, SM3_CONTEXT_SIZE,
+				     DMA_TO_DEVICE);
+	cmh_dma_unmap_single(rctx->save_dma, SM3_CONTEXT_SIZE,
+			     DMA_FROM_DEVICE);
+	cmh_dma_unmap_single(rctx->data_dma, rctx->data_len,
+			     DMA_TO_DEVICE);
+
+	if (!error) {
+		memcpy(rctx->checkpoint, rctx->save_buf, SM3_CONTEXT_SIZE);
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
+static int cmh_sm3_update(struct ahash_request *req)
+{
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
+	struct vcq_cmd cmds[CMH_SM3_MAX_PAYLOAD];
+	struct core_dispatch d;
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
+	/* block size is a power of two, but modulo keeps the split exact. */
+	rctx->update_remainder = req->nbytes % CMH_SM3_BLOCK_SIZE;
+	full_len = req->nbytes - rctx->update_remainder;
+
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+	      GFP_KERNEL : GFP_ATOMIC;
+
+	/*
+	 * Reject a single update whose linearisation would exceed the largest
+	 * kmalloc: return a permanent -EMSGSIZE ("message too long") rather
+	 * than a transient -ENOMEM the client would keep retrying.  __GFP_NOWARN
+	 * keeps a borderline-large (but sub-cap) request quiet if it still
+	 * cannot be satisfied.
+	 */
+	if (full_len > KMALLOC_MAX_SIZE)
+		return -EMSGSIZE;
+
+	rctx->data_buf = kmalloc(full_len, gfp | __GFP_NOWARN);
+	if (!rctx->data_buf)
+		return -ENOMEM;
+
+	scatterwalk_map_and_copy(rctx->data_buf, req->src, 0, full_len, 0);
+
+	rctx->data_len = full_len;
+
+	rctx->save_buf = kzalloc(SM3_CONTEXT_SIZE, gfp);
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
+	rctx->save_dma = cmh_dma_map_single(rctx->save_buf, SM3_CONTEXT_SIZE,
+					    DMA_FROM_DEVICE);
+	if (cmh_dma_map_error(rctx->save_dma)) {
+		ret = -ENOMEM;
+		goto err_unmap_data;
+	}
+
+	rctx->ckpt_dma = DMA_MAPPING_ERROR;
+	if (rctx->has_checkpoint) {
+		rctx->ckpt_dma = cmh_dma_map_single(rctx->checkpoint,
+						    SM3_CONTEXT_SIZE,
+						     DMA_TO_DEVICE);
+		if (cmh_dma_map_error(rctx->ckpt_dma)) {
+			ret = -ENOMEM;
+			goto err_unmap_save;
+		}
+	}
+
+	d = cmh_core_select_instance(CMH_CORE_SM3);
+	idx = 0;
+
+	vcq_add_sm3_init(&cmds[idx++], d.core_id);
+
+	if (rctx->has_checkpoint)
+		vcq_add_sm3_restore(&cmds[idx++], d.core_id,
+				    (u64)rctx->ckpt_dma, SM3_CONTEXT_SIZE);
+
+	vcq_add_sm3_update(&cmds[idx++], d.core_id,
+			   (u64)rctx->data_dma, full_len);
+
+	vcq_add_sm3_save(&cmds[idx++], d.core_id,
+			 (u64)rctx->save_dma, SM3_CONTEXT_SIZE);
+
+	vcq_add_flush(&cmds[idx++], d.core_id);
+
+	ret = cmh_vcq_pack_and_submit_async(cmds, idx, rctx->packed,
+					    CMH_SM3_MAX_PACKED,
+					    d.mbx_idx,
+					    cmh_sm3_update_complete, req,
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
+		cmh_dma_unmap_single(rctx->ckpt_dma, SM3_CONTEXT_SIZE,
+				     DMA_TO_DEVICE);
+err_unmap_save:
+	cmh_dma_unmap_single(rctx->save_dma, SM3_CONTEXT_SIZE,
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
+static void cmh_sm3_final_complete(void *data, int error)
+{
+	struct ahash_request *req = data;
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
+
+	if (error == -EINPROGRESS) {
+		cmh_complete(&req->base, error);
+		return;
+	}
+
+	if (rctx->has_checkpoint)
+		cmh_dma_unmap_single(rctx->ckpt_dma, SM3_CONTEXT_SIZE,
+				     DMA_TO_DEVICE);
+	if (rctx->data_buf)
+		cmh_dma_unmap_single(rctx->data_dma, rctx->data_len,
+				     DMA_TO_DEVICE);
+	cmh_dma_unmap_single(rctx->digest_dma, CMH_SM3_DIGEST_SIZE,
+			     DMA_FROM_DEVICE);
+
+	if (!error)
+		memcpy(req->result, rctx->digest_buf, CMH_SM3_DIGEST_SIZE);
+
+	kfree(rctx->digest_buf);
+	rctx->digest_buf = NULL;
+	kfree(rctx->data_buf);
+	rctx->data_buf = NULL;
+	cmh_sm3_free_reqctx(rctx);
+	cmh_complete(&req->base, error);
+}
+
+static int cmh_sm3_submit_final(struct ahash_request *req,
+				u8 *data_buf, u32 data_len)
+{
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
+	struct vcq_cmd cmds[CMH_SM3_MAX_PAYLOAD];
+	struct core_dispatch d;
+	u32 idx;
+	int ret;
+	gfp_t gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		   GFP_KERNEL : GFP_ATOMIC;
+
+	rctx->data_buf = data_buf;
+	rctx->data_len = data_len;
+
+	rctx->digest_buf = kzalloc(CMH_SM3_DIGEST_SIZE, gfp);
+	if (!rctx->digest_buf) {
+		ret = -ENOMEM;
+		goto err_free_data;
+	}
+
+	rctx->digest_dma = cmh_dma_map_single(rctx->digest_buf,
+					      CMH_SM3_DIGEST_SIZE,
+					       DMA_FROM_DEVICE);
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
+						    SM3_CONTEXT_SIZE,
+						     DMA_TO_DEVICE);
+		if (cmh_dma_map_error(rctx->ckpt_dma)) {
+			ret = -ENOMEM;
+			goto err_unmap_data;
+		}
+	}
+
+	d = cmh_core_select_instance(CMH_CORE_SM3);
+	idx = 0;
+
+	vcq_add_sm3_init(&cmds[idx++], d.core_id);
+
+	if (rctx->has_checkpoint)
+		vcq_add_sm3_restore(&cmds[idx++], d.core_id,
+				    (u64)rctx->ckpt_dma, SM3_CONTEXT_SIZE);
+
+	if (data_buf && data_len > 0)
+		vcq_add_sm3_update(&cmds[idx++], d.core_id,
+				   (u64)rctx->data_dma, data_len);
+
+	vcq_add_sm3_final(&cmds[idx++], d.core_id,
+			  (u64)rctx->digest_dma, CMH_SM3_DIGEST_SIZE);
+
+	vcq_add_flush(&cmds[idx++], d.core_id);
+
+	ret = cmh_vcq_pack_and_submit_async(cmds, idx, rctx->packed,
+					    CMH_SM3_MAX_PACKED,
+					    d.mbx_idx,
+					    cmh_sm3_final_complete, req,
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
+		cmh_dma_unmap_single(rctx->ckpt_dma, SM3_CONTEXT_SIZE,
+				     DMA_TO_DEVICE);
+err_unmap_data:
+	if (data_buf && data_len > 0)
+		cmh_dma_unmap_single(rctx->data_dma, data_len,
+				     DMA_TO_DEVICE);
+err_unmap_digest:
+	cmh_dma_unmap_single(rctx->digest_dma, CMH_SM3_DIGEST_SIZE,
+			     DMA_FROM_DEVICE);
+err_free_digest:
+	kfree(rctx->digest_buf);
+	rctx->digest_buf = NULL;
+err_free_data:
+	kfree(data_buf);
+	rctx->data_buf = NULL;
+	/*
+	 * Preserve the SM3 checkpoint on failure: a synchronous rejection is
+	 * retryable, and for a terminal error the inline checkpoint is freed
+	 * with the request context, so it never leaks.  It is cleared only in
+	 * the completion after a successful final().
+	 */
+	return ret;
+}
+
+static int cmh_sm3_finup(struct ahash_request *req);
+
+/*
+ * One-shot digest -- delegates to init + finup so that all data is
+ * linearised and mapped through cmh_dma_map_single(), which is the
+ * only DMA mapping path aware of all supported DMA backends.
+ */
+static int cmh_sm3_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = cmh_sm3_init(req);
+	if (ret)
+		return ret;
+	return cmh_sm3_finup(req);
+}
+
+/*
+ * .finup -- hash any remaining data and finalise in one transaction.
+ * With BLOCK_ONLY the Crypto API prepends the bytes it held back, so
+ * req->src already carries the full tail.  Also serves .final (nbytes
+ * == 0).  Avoids ahash_def_finup(), which would clone via export/import.
+ */
+static int cmh_sm3_finup(struct ahash_request *req)
+{
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
+	u32 data_len = req->nbytes;
+	u8 *data_buf = NULL;
+	gfp_t gfp;
+
+	if (rctx->error)
+		return rctx->error;
+
+	if (data_len == 0)
+		return cmh_sm3_submit_final(req, NULL, 0);
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
+	return cmh_sm3_submit_final(req, data_buf, data_len);
+}
+
+static int cmh_sm3_export(struct ahash_request *req, void *out)
+{
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
+	struct cmh_sm3_export_state *state = out;
+
+	/*
+	 * Zero the whole exported state first: the struct may carry padding,
+	 * so without this the padding would leak kernel memory to user space
+	 * through the ahash export.
+	 */
+	memset(state, 0, sizeof(*state));
+
+	if (rctx->hw_started && rctx->has_checkpoint)
+		memcpy(state->checkpoint, rctx->checkpoint, SM3_CONTEXT_SIZE);
+
+	state->hw_started = rctx->hw_started;
+
+	return 0;
+}
+
+static int cmh_sm3_import(struct ahash_request *req, const void *in)
+{
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_sm3_export_state *state = in;
+
+	memset(rctx, 0, sizeof(*rctx));
+
+	rctx->hw_started = state->hw_started;
+
+	if (state->hw_started) {
+		memcpy(rctx->checkpoint, state->checkpoint, SM3_CONTEXT_SIZE);
+		rctx->has_checkpoint = 1;
+	}
+
+	return 0;
+}
+
+/* Registration */
+
+static struct ahash_alg cmh_sm3_ahash_alg = {
+	.init    = cmh_sm3_init,
+	.update  = cmh_sm3_update,
+	.finup   = cmh_sm3_finup,
+	.digest  = cmh_sm3_digest,
+	.export  = cmh_sm3_export,
+	.import  = cmh_sm3_import,
+
+	.halg = {
+		.digestsize = CMH_SM3_DIGEST_SIZE,
+		.statesize  = sizeof(struct cmh_sm3_export_state),
+		.base = {
+			.cra_name        = "sm3",
+			.cra_driver_name = "rambus-cmh-sm3",
+			.cra_priority    = 300,
+			.cra_flags       = CRYPTO_ALG_KERN_DRIVER_ONLY |
+					   CRYPTO_ALG_NO_FALLBACK |
+					   CRYPTO_ALG_ASYNC |
+					   CRYPTO_AHASH_ALG_BLOCK_ONLY,
+			.cra_blocksize   = CMH_SM3_BLOCK_SIZE,
+			.cra_ctxsize     = 0,
+			.cra_reqsize     = sizeof(struct cmh_sm3_reqctx),
+			.cra_module      = THIS_MODULE,
+		},
+	},
+};
+
+/**
+ * cmh_sm3_register() - Register SM3 hash algorithm with the crypto framework
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_sm3_register(void)
+{
+	int ret;
+
+	if (!cmh_core_present(CMH_CORE_SM3))
+		return 0;
+
+	ret = crypto_register_ahash(&cmh_sm3_ahash_alg);
+	if (ret) {
+		dev_err(cmh_dev(), "sm3: failed to register cmh-sm3 (rc=%d)\n",
+			ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * cmh_sm3_unregister() - Unregister SM3 hash algorithm from the crypto framework
+ */
+void cmh_sm3_unregister(void)
+{
+	if (!cmh_core_present(CMH_CORE_SM3))
+		return;
+
+	crypto_unregister_ahash(&cmh_sm3_ahash_alg);
+}
diff --git a/drivers/crypto/cmh/include/cmh_sm3.h b/drivers/crypto/cmh/include/cmh_sm3.h
new file mode 100644
index 000000000000..962078b051b4
--- /dev/null
+++ b/drivers/crypto/cmh/include/cmh_sm3.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- SM3 Hash Driver
+ *
+ * Registers an ahash algorithm for SM3 (GB/T 32905-2016) with the
+ * Linux crypto subsystem using the CMH SM3 core (CORE_ID_SM3).
+ * This is a CRYPTO_AHASH_ALG_BLOCK_ONLY driver (same model as
+ * cmh_hash.c), so the Crypto API buffers partial blocks and hands the
+ * driver only whole-block-aligned data:
+ *
+ *   .init()   -> software-only: zero per-request context
+ *   .update() -> SM3_CMD_INIT [+ RESTORE] + UPDATE(full blocks) + SAVE + FLUSH
+ *                (also serves final: the API calls finup with nbytes == 0)
+ *   .digest() -> INIT + UPDATE + FINAL + FLUSH (single-shot)
+ *   .export() -> software-only: copy the SM3 checkpoint
+ *   .import() -> software-only: restore the SM3 checkpoint
+ */
+
+#ifndef CMH_SM3_H
+#define CMH_SM3_H
+
+#include "cmh_config.h"
+
+int  cmh_sm3_register(void);
+void cmh_sm3_unregister(void);
+
+#endif /* CMH_SM3_H */
-- 
2.43.7

