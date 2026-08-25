Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021098.outbound.protection.outlook.com [52.101.57.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC27A48D86B;
	Tue, 25 Aug 2026 22:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696165; cv=fail; b=nojB0Sz1/Ig0/8Q33Oo3YjKMbY5Pgpm5FfaeNk1fskRiPZaIm6iMxD/wfzvHflcpYMRMgxbWTyT5IbC2IJPxu/xZqOGIO1D32ak7szP6woyHZ75CRbzickiiXHbbLJumQFg8s5lM7qEHgm2ilBoRRN5g/FsDm4KxO16Lq+XWqqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696165; c=relaxed/simple;
	bh=zoBOWESFYx4iTXLkUlg64U/CG12Ckjo5ZJgUCpiclyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1BFNEjS34TovMehaX/X6+GFITsQoJUWhp9P9/brruEdj8ssauWT0K0hP1mvstp9R/nCrcjHkAaedKibqwoGDpZvOl2YGfq+/Yn5fq5iaflBtmd2OFzZcxGuz1i39r/3ovTAh0/YPxGwgDJZ+FfLx2UJ5jccPwh55Xs5Cl7ijMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=driMLVY+; arc=fail smtp.client-ip=52.101.57.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="driMLVY+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LwUhR6R6vnM0+D0CWQwf+BrfGPhu9NSbfflRztNS8epJCJbOwm7kYAKcNHa5IiF0Y7MjVw4hLKdJWVBdn3754AA2m6wPXI9j1d0AP4ugaX12KanBNitLiDG+5cS5X3ws11kNQuXY+owjJUmLHfwmp+xaJzy+3i0+oEbROWplMYnyThfT1+YccRZ+wAzR/PwYwWU3vlCONJPavN/58GLRnUQMVPhV61AlFkJs7LDsxo11zji/P2X6OzWQkjltfGmNrX+8wa/PowOVqBxREUNluuF/FMf2MdS4vYVJ9vmlXDcj/KhQ4UIPQYZD3NXdG4cUN3MnTIoTK4n/r89wzB7ayw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNtnO61H0psHcli/53tjKm59wHEvvbNynuXEz+Nd55s=;
 b=ajYuaUJn02g6+gyqe4Ub20FjcWA22ozLq/HSiY6N74H9mcKmsvdOG7em0l0d3bHb1lscv2dwg4LDtTLp8Psz8REiCHISdjRezO0AQG2bHd1v76lYOR5aEhHapFIb7e1sbXV1J8cbx4Ue+3N2qxWaPYDHRTGlYaCwDoe4UqQuVAkLJTxiPQrygxSgiA0eGj86Zyv7Lf0usxLT/b4The0K7hpwB7mhP0NNkm23PzVbiJJ2n8HgpOgsqkh7fzmnLcLYRYRtjKAxqvdCoieqSXc80yXATeIO3wRELmWnk4xH/tN0SD6/jjnSgUBgJFtBap8yAm05Xmfy8tAkMGjwldvEUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNtnO61H0psHcli/53tjKm59wHEvvbNynuXEz+Nd55s=;
 b=driMLVY+TGk11Zcm9xBr+cDoYURO6g0k7PBYxEP1caJ9w9Gew/692zuX1CxPSDkVe6j9W/hdfy+nl6+fuiedEHj3cdc37jIWa6LlmwOeD9tVCyCoTr5/SaD0lDEsDCusMhIBbM0fw0H3Ij+DoRKPm1vkjRuL7+KH/iSyHw9rX/KHwUV+NZH4ofVkhQalHlFUCy3jzPVqQmjlKi/c4OSKUfqTxgbanPAPWFm2TtRFTnT5w/tV12eCwlTfKTeR6WzX/lVu4fhvSP7wXOjuG9kVcIss4B3Ktr3VDKxPwxuJXUOEO3Saqv2oRnDrMBIYVDIao1z02dzUwDQFcJ76pKXDwQ==
Received: from BY3PR05CA0047.namprd05.prod.outlook.com (2603:10b6:a03:39b::22)
 by PH0PR04MB994079.namprd04.prod.outlook.com (2603:10b6:510:43b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 25 Aug
 2026 22:15:52 +0000
Received: from SJ5PEPF000001D5.namprd05.prod.outlook.com
 (2603:10b6:a03:39b:cafe::82) by BY3PR05CA0047.outlook.office365.com
 (2603:10b6:a03:39b::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.7 via Frontend Transport; Tue, 25
 Aug 2026 22:15:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy01.rambus.com; pr=C
Received: from hqxsv-psmtppxy01.rambus.com (192.86.86.210) by
 SJ5PEPF000001D5.mail.protection.outlook.com (10.167.242.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 22:15:52 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy01.rambus.com (Postfix) with ESMTP id 4B7A51801764;
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
Subject: [PATCH v4 07/19] crypto: cmh - add SM3 ahash
Date: Tue, 25 Aug 2026 15:15:26 -0700
Message-ID: <20260825221539.255951-8-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D5:EE_|PH0PR04MB994079:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 7d54f7f9-8254-4a61-1cf4-08df02f66ce5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|82310400026|36860700016|10067099003|56012099006|3023799007|11063799006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	iVfncu+0HXxDRC7w/SY6mK4mDfRvKmqukN0zCunVQHwBvvOsmoLZwAjdmvxoaQ4P3DAzSgb29WGhk7RMAKZ2727n/Ih9uAt8z/cdQbBsg3xVQD3hapFhW3vTeAz/x+Ox8R6mNLWPRpCUhbUpQonZvJbYdh+F/mnjAKgt6p7OKTJhI0nmTa+GBYtGQ4xnoiTjCczNjhSsRNMluIr2+zYTyIayeYos0QQqVm/E8WLGymbSDIz54SfKAeolKoTfEWWp9TEnH9OePWIeqCZEmekUcdL+3aoKmhBlrf8D2R3Pme6EIHiKT/BXRwgVdZy/SvOF4fdR3PyAqbi86Vq6nbhoZrXak2m360CspgAmVRXvBdhPHkDNc7unJtZOhRyAIBIBWuil7zEqLPHGaaYxXFJcYJVqW7M8gZcWt2oMLuZwb3Z8axfa51fJmPouyLL6bN//jMboEDQIveP1uXft50yRkrmYL68FBBYCfldmaVum19ZvLw7Ppl0yy0oIiIh6iLWxXJ9598pqB23jfSR02Jr4nIglKA5u4+QmGkpHrZPaM7BpeVYyJft+1Hebo0QsM93K6TCJt7iPd68BakZ1i/HLh+1dl9W/dnw5q1HYcOH1kWKEMOv7PvF9eOhnnrWevDNv1bI/48AGWIasYhGYHq+Ku/ikpezJuuFzAOr9cangVMaiiw7YxypkLSMN/vV+yCjyxiH3Gn311ZGFBYULcv4XQ7EFkd09VL0M/ITvn/jBsSWqz3ZStF6LM3OlzDcC7Dqk
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy01.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(82310400026)(36860700016)(10067099003)(56012099006)(3023799007)(11063799006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	atfaS55rDuIGWVX+MUa8j8iqtyxCbfR9MiBZP5aVksCYTW2DJXMTznRMButE2cBJ2VLYh/a5xjpxFrW9Fhc5mIw5w4x+jU2o/lo90lNvgkKC7thfJ66OiJyEb2p0AAZGQ3kFPjDVW7ySom2VnKfBBX59vSLdlezwAlYEX290VudzUhO7IMfg6Fd7q9jOcOLcm7ja9Nhb2dFLiLXxNROUxNaASmQRnIc0p23t40e8QtdbgByKs//jRUFQ1RfpRh9D/m329UvidQzJhTmDSIwQTZ4R5aEKeYsi5jK9DKUuDfAYQSF/FLO0kaFrGkJKNlrUThtwL906ihAudz2QLW2//OspoJ4oHYXCet/qzpjqWHkkpQnl+jRc2DImNEbKsLqrmZ/JdjTVyVLoLHHhhMmIlIMOaF1VlhU223mLVoKOK6ZRjrXyz2i5bzfcVkeW4PVd
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 22:15:52.1607
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d54f7f9-8254-4a61-1cf4-08df02f66ce5
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy01.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB994079

Register the SM3 ahash algorithm using the CMH SM3 core (core ID
0x05).  Supports incremental update/finup/final and export/import.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 drivers/crypto/cmh/Makefile          |   3 +-
 drivers/crypto/cmh/cmh_main.c        |   9 +
 drivers/crypto/cmh/cmh_sm3.c         | 687 +++++++++++++++++++++++++++
 drivers/crypto/cmh/include/cmh_sm3.h |  27 ++
 4 files changed, 725 insertions(+), 1 deletion(-)
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
index 000000000000..8dbc46c30a40
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_sm3.c
@@ -0,0 +1,687 @@
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
+ * Incremental HW update model (same pattern as cmh_hash.c):
+ *
+ *   .init()   -> software-only: zero per-request context
+ *   .update() -> buffer data in holdback; when >= block_size bytes:
+ *                SM3_CMD_INIT [+ RESTORE] + UPDATE + SAVE + FLUSH
+ *                -> return -EINPROGRESS  (else return 0)
+ *   .final()  -> SM3_CMD_INIT [+ RESTORE] [+ UPDATE] + FINAL + FLUSH
+ *   .finup()  -> linearise holdback + new data, then final path
+ *   .digest() -> INIT + UPDATE + FINAL + FLUSH (single-shot via finup)
+ *   .export() -> software-only: copy checkpoint + holdback to out
+ *   .import() -> software-only: restore checkpoint + holdback from in
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
+ * .import().  This is what statesize advertises to the crypto subsystem.
+ */
+struct cmh_sm3_export_state {
+	u8  checkpoint[SM3_CONTEXT_SIZE]; /* SM3 context from last SAVE */
+	u8  buf[CMH_SM3_BLOCK_SIZE];     /* holdback buffer */
+	u32 buf_len;                      /* valid bytes in buf[] */
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
+ */
+struct cmh_sm3_reqctx {
+	int    error;
+	u32    hw_started;
+	u32    buf_len;
+	u32    has_checkpoint;
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
+	u8     buf[CMH_SM3_BLOCK_SIZE]; /* holdback for partial block */
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
+	if (total_avail < CMH_SM3_BLOCK_SIZE) {
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
+	full_len = total_avail - total_avail % CMH_SM3_BLOCK_SIZE;
+	tail_len = total_avail - full_len;
+	from_src = full_len - rctx->buf_len;
+
+	/*
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
+	cmh_sm3_free_reqctx(rctx);
+	return ret;
+}
+
+static int cmh_sm3_final(struct ahash_request *req)
+{
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
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
+	return cmh_sm3_submit_final(req, data_buf, data_len);
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
+static int cmh_sm3_finup(struct ahash_request *req)
+{
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
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
+		return cmh_sm3_submit_final(req, NULL, 0);
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
+	return cmh_sm3_submit_final(req, data_buf, data_len);
+}
+
+static int cmh_sm3_export(struct ahash_request *req, void *out)
+{
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
+	struct cmh_sm3_export_state *state = out;
+
+	/*
+	 * Zero the whole exported state first: only rctx->buf_len bytes of
+	 * buf[] are populated below and the struct may carry padding, so
+	 * without this the unused tail/padding would leak kernel memory to
+	 * user space through the ahash export.
+	 */
+	memset(state, 0, sizeof(*state));
+
+	if (rctx->hw_started && rctx->has_checkpoint)
+		memcpy(state->checkpoint, rctx->checkpoint, SM3_CONTEXT_SIZE);
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
+static int cmh_sm3_import(struct ahash_request *req, const void *in)
+{
+	struct cmh_sm3_reqctx *rctx = ahash_request_ctx(req);
+	const struct cmh_sm3_export_state *state = in;
+
+	memset(rctx, 0, sizeof(*rctx));
+
+	/*
+	 * Holdback invariant: buf_len < block size (a full block is always
+	 * processed, never left in the holdback).  Reject a corrupt state
+	 * that violates it.
+	 */
+	if (state->buf_len >= CMH_SM3_BLOCK_SIZE)
+		return -EINVAL;
+
+	rctx->hw_started = state->hw_started;
+	rctx->buf_len = state->buf_len;
+	memcpy(rctx->buf, state->buf, state->buf_len);
+
+	if (state->hw_started) {
+		memcpy(rctx->checkpoint, state->checkpoint, SM3_CONTEXT_SIZE);
+		rctx->has_checkpoint = 1;
+	}
+
+	return 0;
+}
+
+/* Transform init (cra_init) */
+
+static int cmh_sm3_cra_init(struct crypto_tfm *tfm)
+{
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct cmh_sm3_reqctx));
+	return 0;
+}
+
+/* Registration */
+
+static struct ahash_alg cmh_sm3_ahash_alg = {
+	.init    = cmh_sm3_init,
+	.update  = cmh_sm3_update,
+	.final   = cmh_sm3_final,
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
+					   CRYPTO_ALG_REQ_VIRT,
+			.cra_blocksize   = CMH_SM3_BLOCK_SIZE,
+			.cra_ctxsize     = 0,
+			.cra_init        = cmh_sm3_cra_init,
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
index 000000000000..2f73537f9c87
--- /dev/null
+++ b/drivers/crypto/cmh/include/cmh_sm3.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- SM3 Hash Driver
+ *
+ * Registers an ahash algorithm for SM3 (GB/T 32905-2016) with the
+ * Linux crypto subsystem using the CMH SM3 core (CORE_ID_SM3).
+ * Uses the same incremental HW update model as cmh_hash.c:
+ *
+ *   .init()   -> software-only: zero per-request context
+ *   .update() -> holdback partial blocks; submit full blocks via
+ *                SM3_CMD_INIT [+ RESTORE] + UPDATE + SAVE + FLUSH
+ *   .final()  -> SM3_CMD_INIT [+ RESTORE] [+ UPDATE] + FINAL + FLUSH
+ *   .digest() -> INIT + UPDATE + FINAL + FLUSH (single-shot)
+ *   .export() -> software-only: copy checkpoint + holdback
+ *   .import() -> software-only: restore checkpoint + holdback
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

