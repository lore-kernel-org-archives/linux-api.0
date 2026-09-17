Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020136.outbound.protection.outlook.com [52.101.61.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDAE47D927;
	Thu, 17 Sep 2026 23:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789686036; cv=fail; b=j9owCvXmKmQoSh2QpWpPiQHrwyOwMdu6AGoSwE4vQvVuWWdkQDRLX0NoKBkTE9Rqo1g+n0j1uY/y3guglHWDs1xRS5U1HdCQCiOuCXADP2aJWi5Z929RvLixyPOkL8bawXcmuEATBEFE5Lt5Gbd5mw/ok9yDa91ICVlLZL659Lo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789686036; c=relaxed/simple;
	bh=0Cnc1DkAptjYYIsYGfbGXqUQxiPms2HEG2hq+5FiZ68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lFunwSKx+CsZ6zmqNk3tMAwnro+Dyijo6GFLY2RtJgY5T1hvNVZKeRBSlkZS6C4hv3PlMrEjvbfeE7n+gYdKHXQJq/Dp3G1N5O90QsonJv8bW4lxCc5yCpc296EIatNhVo+Gt7LRaHQTZwO9lu2pOnW1u0Wj7lPbL+5nKbJ3TGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=xHiSU6fq; arc=fail smtp.client-ip=52.101.61.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="xHiSU6fq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kZD3BPsS7Q1LBrwLzcgYaPlrAJLzwMHfSc6MWCZgAhCbC/dGeXQNCJpxjA10XZBrAQOaBX7jodbM95TGg1OaP6Oq71H97FaRvdRfJkbcW7sNxlnDRs38hADgMBXxCTdhflqgiYapjG/ITKRZFRuGWvQz71zaVlIcG66FMbNCoflJfD9k9O/WIoUKi1g90w0IbfwxiNeJw5X1IaVVooZvMstx0gqCFywjamwrt0C+FaahYG1bE0sRoDnmgZQF0hSUc9IkZ1MiMH/ypUVVIcLxlWrWiGhYWVD90lv+jhkJYNMOrgBZkFR/R8Q+X4p9QccxU4hnsAIgqboY8U/LiN5SPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23jVenue7GBFJK9hg5/EylL7K6WSTFd308Je/a2McuU=;
 b=HOfx9IQsY/M1XqXKscKs/kTUKxBCIckmGncqoC2aMZpfnUY4RafHpaAH45YC7QKa0RBnB5FcUT59huI9oivv/hFlkInlIwLrlv1Ykj75spahQvwMlSjNYx189ZJPb2YKFEhvzBL6K4ntPIAcDgI16KCeQZoTXw3wra2HhjffLTVn8jGMXMcCXPyxbrGon4RjIAQo6D7oz4P4Imtyh6uvpWGcLslqMq1MJ/H1jWjdAbvgye7LRWBR2iSIxocLKu8ryj9LsUPAl5WME4CeVkFoFci3KCEcz7qkDwMKc+n7gr7jQVJP2oaazpIbn98vxDwUwpXWge84DcNAqpLL3MAf5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23jVenue7GBFJK9hg5/EylL7K6WSTFd308Je/a2McuU=;
 b=xHiSU6fqo+pdZ8h1i8XwrSE+osUBWmEQkgDADfQqOKt00lynpRV5pKflHNY0uEwH934vd8qv3j+R6tVwfz/Ry4EGzCcUZDQgcC8UxVSA91h9s6nSmqD0UU3dATKSRNloASXcPH1p8EnXr7OOSvd6fjDgVsHeD+6M0pk32n1DDC/9zQ4d1vkjhJso8KC+E54YzFHbtazWZ1liqK0wXQxk2uMbfThq9ztjE79SBmy2MKkAlVBRXA/nrABxTpMfO/FrerU0c4SAzjr0TYKAAKEMZYZUFF0zcFbB2p15ilePH6Qy6vRUroFg278bMRoIU8cHj12WVRUR8LhshZaKkjiz5Q==
Received: from SJ0PR13CA0226.namprd13.prod.outlook.com (2603:10b6:a03:2c1::21)
 by SN4PR04MB10229.namprd04.prod.outlook.com (2603:10b6:806:216::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 22:59:35 +0000
Received: from BY1PEPF0001AE1A.namprd04.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::71) by SJ0PR13CA0226.outlook.office365.com
 (2603:10b6:a03:2c1::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8 via Frontend Transport; Thu, 17
 Sep 2026 22:59:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BY1PEPF0001AE1A.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Thu, 17 Sep 2026 22:59:34 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id 7AA45180176D;
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
Subject: [PATCH v5 15/19] crypto: cmh - add ML-KEM/ML-DSA (QSE)
Date: Thu, 17 Sep 2026 15:59:24 -0700
Message-ID: <20260917225929.2494111-16-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE1A:EE_|SN4PR04MB10229:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 07577089-6300-49a0-46ca-08df150f576e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|82310400026|36860700016|921020|6133799003|56012099006|11063799006|18002099003|22082099003|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	f85clLlK7xRuhX2+cBV3b/u3t6Lfuuzk7nQVpB8dCevU863Fx2l3y284BbHOs/6TPIkWuM0BBCHfgXp/GHjKpp9Wq+RBOkG/H+pJvYmRrstjtgYVW8IZEqSpQSq/Coc8Qukv2YyST26dqXU3zNgAhy6gV8Fssvoy7nrExU7bO44mwB8KMNDJUdEyWPS5Pi50Awy2s+6eJ6Mw4n9+ntoGKrfUR5p4PSBiUwAOgeSQ/EXnyyojScfESaQ7hJly/O6fpGK7C7neuRoBvSJND1L1mjl9HpA3fVLp8wpAv4I1YF3fWtVu2nwSsOkGkDUSKtcAkwjzASacPRX4jEcmLbnrgLOqFmkVzV8UfQ2Ka6hkaz7eEFUasvCUgujXWUf/gJwvNnOJjKfhnyiFfqpEqM3VdX5sB6vOoWX70mEUPTMcp5/8JhZ96hLpRWO7csyhk4+340PpEhdV0wzORPUvWoYUsXiznV/G55X/0Yzas0MmPsXhRh+jKTjqv3GU7x2/qk3lF2fe1e0H8I7lqiYNiasMAMfD3DP4/XXI0VVtunk5RK0nP6qo4UY8edFxPbeEwvIN4k22wGo2De7d1xafhSv/mv6RleXijeC+Oxuho4HmRjjLuGOro6B76UuYkmP2/lZEWmgQB1FopH6+xgCDYjFHeGek8sV0OxUmZ1OjgOH4aa4ajHOfyIH4e0Nyj4d3lwyR4Cb6jVocc8YlYWoXFPfSgoz35wuFmNURjB29SB6MmBj6q1hWf3D5zIU3ynY+6tGs
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(921020)(6133799003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	S7UoPM129yUKGNoI9gUFCJuKNk5YiymE8UDjpy1ec1ZhqSkSfZSGQ4UrHxWU5+kY+XFgOCtUC774UXI9io9/22BH2f28nzm+THWsxT9TFkLKVL1NZFqpf0cLiJvOx9ApP2LSAptdqR//3UZe7VRQ2B6+CahEI/zv8VevcHhqgrT+b62AUpoxpsYlFzSzOrDgBsC2W6N6j6/kRRnaTE1wVAEcvO6nOg/7v2XdRKfpFlMw3DX3uAX4Q12nGez8YMl8bSd2eNL8X2qdxe8Acid+VfNlLP5ZTkOEKArgNaD0olM/8+r6bKIMNjPd7dWoFMjAk7WlDDA0uiO64Blj/Y0d+ixQkDqf33FUtu3YwwbP94J3M6TsGq0uSZgd8N22+YPoXEZLLoVrXWmox2S5ICO2lOlPEwjgqGdUJCN8pnfgZuj8Dd0xZo6FE1K2OHRkaNEO
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 22:59:34.4984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07577089-6300-49a0-46ca-08df150f576e
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE1A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR04MB10229

Register ML-KEM (Kyber) and ML-DSA (Dilithium) algorithms using
the CMH QSE core (core ID 0x09).  ML-KEM is ioctl-only (keygen,
encaps, decaps).  ML-DSA is registered as a sig algorithm with
priority 5001 to override the kernel's verify-only mldsa
implementation at priority 5000.  This follows the established
pattern where hardware drivers override software-only fallbacks
(e.g. ccp at 300 over generic AES at 100, qat similarly).  The
CMH driver provides full HW-accelerated sign + verify vs the
kernel's verify-only software implementation.

Includes cmh_pqc_sizes.c with compile-time tables of PQC key and
signature sizes for all supported parameter sets.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 drivers/crypto/cmh/Makefile        |   5 +-
 drivers/crypto/cmh/cmh_main.c      |   9 +
 drivers/crypto/cmh/cmh_pqc_mldsa.c | 415 +++++++++++++++++++++++++++++
 drivers/crypto/cmh/cmh_pqc_sizes.c |  39 +++
 drivers/crypto/cmh/cmh_qse.c       | 211 +++++++++++++++
 5 files changed, 678 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/cmh/cmh_pqc_mldsa.c
 create mode 100644 drivers/crypto/cmh/cmh_pqc_sizes.c
 create mode 100644 drivers/crypto/cmh/cmh_qse.c

diff --git a/drivers/crypto/cmh/Makefile b/drivers/crypto/cmh/Makefile
index da420d0ec1fe..7196d992487e 100644
--- a/drivers/crypto/cmh/Makefile
+++ b/drivers/crypto/cmh/Makefile
@@ -33,7 +33,10 @@ cmh-y := \
 	cmh_pke_common.o \
 	cmh_pke_rsa.o \
 	cmh_pke_ecdsa.o \
-	cmh_pke_ecdh.o
+	cmh_pke_ecdh.o \
+	cmh_qse.o \
+	cmh_pqc_mldsa.o \
+	cmh_pqc_sizes.o
 
 # Management ioctl device (/dev/cmh_mgmt): key lifecycle, PKE, PQC ioctls.
 cmh-$(CONFIG_CRYPTO_DEV_CMH_MGMT) += \
diff --git a/drivers/crypto/cmh/cmh_main.c b/drivers/crypto/cmh/cmh_main.c
index 93d939e8fc4e..7dfcdf395175 100644
--- a/drivers/crypto/cmh/cmh_main.c
+++ b/drivers/crypto/cmh/cmh_main.c
@@ -41,6 +41,7 @@
 #include "cmh_sm4.h"
 #include "cmh_ccp.h"
 #include "cmh_pke.h"
+#include "cmh_pqc.h"
 #include "cmh_mgmt.h"
 #include "cmh_registers.h"
 #include "cmh_debugfs.h"
@@ -302,6 +303,11 @@ static int cmh_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_pke_ecdh_register;
 
+	/* Register PQC ML-KEM/ML-DSA */
+	ret = cmh_pqc_mldsa_register();
+	if (ret)
+		goto err_pqc_mldsa_register;
+
 	/* Register key management device (/dev/cmh_mgmt) */
 	ret = cmh_mgmt_register();
 	if (ret)
@@ -312,6 +318,8 @@ static int cmh_probe(struct platform_device *pdev)
 	return 0;
 
 err_mgmt_register:
+	cmh_pqc_mldsa_unregister();
+err_pqc_mldsa_register:
 	cmh_pke_ecdh_unregister();
 err_pke_ecdh_register:
 	cmh_pke_ecdsa_unregister();
@@ -374,6 +382,7 @@ static void cmh_remove(struct platform_device *pdev)
 	cfg = &dev->config;
 
 	cmh_mgmt_unregister();
+	cmh_pqc_mldsa_unregister();
 	cmh_pke_ecdh_unregister();
 	cmh_pke_ecdsa_unregister();
 	cmh_pke_rsa_unregister();
diff --git a/drivers/crypto/cmh/cmh_pqc_mldsa.c b/drivers/crypto/cmh/cmh_pqc_mldsa.c
new file mode 100644
index 000000000000..c37ba4bae89c
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pqc_mldsa.c
@@ -0,0 +1,415 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- ML-DSA Signature Driver (sig_alg, synchronous)
+ *
+ * Registers "mldsa44", "mldsa65", "mldsa87" sig algorithms
+ * with sign, verify, set_pub_key, and set_priv_key callbacks.
+ *
+ * Key format:
+ *   Public key  = raw pk bytes (1312 / 1952 / 2592 bytes)
+ *   Private key = raw sk bytes (2560 / 4032 / 4896 bytes)
+ *
+ * Sign: src = message bytes (up to 10240 bytes), dst = raw signature
+ * Verify: src = raw signature, digest = message bytes
+ *
+ * Non-masked mode only for sig_alg API.
+ * Masked mode available through /dev/cmh_mgmt ioctl.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <crypto/sig.h>
+#include <crypto/internal/sig.h>
+
+#include "cmh_sys.h"
+#include "cmh_qse_abi.h"
+#include "cmh_txn.h"
+#include "cmh_dma.h"
+#include "cmh_key.h"
+#include "cmh_pqc.h"
+
+struct cmh_mldsa_tfm_ctx {
+	struct cmh_key_ctx key;		/* private key (raw only) */
+	u8 *pub_key;
+	u32 pub_key_len;
+	u32 mode;			/* ML_DSA_MODE_44/65/87 */
+	int mode_idx;			/* index into size tables */
+};
+
+static inline struct cmh_mldsa_tfm_ctx *cmh_mldsa_ctx(struct crypto_sig *tfm)
+{
+	return crypto_sig_ctx(tfm);
+}
+
+/*
+ * ML-DSA sign (synchronous sig_alg)
+ *
+ * @src:  message bytes
+ * @slen: message length
+ * @dst:  signature output buffer
+ * @dlen: output buffer length
+ *
+ * Returns signature length on success, negative errno on failure.
+ */
+static int cmh_mldsa_sign(struct crypto_sig *tfm,
+			  const void *src, unsigned int slen,
+			  void *dst, unsigned int dlen)
+{
+	struct cmh_mldsa_tfm_ctx *ctx = cmh_mldsa_ctx(tfm);
+	int mi = ctx->mode_idx;
+	u32 sig_size = ml_dsa_sig_size[mi];
+	u32 sk_size = ml_dsa_sk_size[mi];
+	struct vcq_cmd vcq[QSE_VCQ_CMDS_MIN];
+	struct core_dispatch dd;
+	u8 *m_buf = NULL, *sig_buf = NULL;
+	dma_addr_t m_dma = DMA_MAPPING_ERROR;
+	dma_addr_t sig_dma = DMA_MAPPING_ERROR;
+	int ret, idx;
+
+	if (ctx->key.mode != CMH_KEY_RAW)
+		return -EINVAL;
+	if (dlen < sig_size)
+		return -EINVAL;
+	if (slen > ML_DSA_MAX_MLEN)
+		return -EINVAL;
+
+	sig_buf = kzalloc(sig_size, GFP_KERNEL);
+	if (!sig_buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+	/* ML-DSA permits an empty message (FIPS 204); skip 0-length DMA. */
+	if (slen) {
+		m_buf = kmemdup(src, slen, GFP_KERNEL);
+		if (!m_buf) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+	}
+
+	if (ctx->key.raw.len != sk_size) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	if (slen) {
+		m_dma = cmh_dma_map_single(m_buf, slen, DMA_TO_DEVICE);
+		if (cmh_dma_map_error(m_dma)) {
+			ret = -ENOMEM;
+			goto out_unmap;
+		}
+	}
+	sig_dma = cmh_dma_map_single(sig_buf, sig_size, DMA_FROM_DEVICE);
+
+	if (cmh_dma_map_error(sig_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	dd = cmh_core_select_instance(CMH_CORE_QSE);
+
+	vcq_set_header(&vcq[0], QSE_VCQ_CMDS_MIN);
+	idx = 1;
+	vcq_add_qse_ml_dsa_sign(&vcq[idx++], dd.core_id, ctx->mode,
+				QSE_FLAG_USE_RNG,
+				0, slen ? m_dma : 0, ctx->key.raw.dma,
+				sig_dma, slen, false);
+	vcq_add_qse_flush(&vcq[idx++], dd.core_id);
+
+	ret = cmh_tm_submit_sync_mbx(vcq, QSE_VCQ_CMDS_MIN, 1,
+				     dd.mbx_idx);
+	if (!ret) {
+		/* Sync bounce buffer so CPU sees the DMA-written signature */
+		cmh_dma_sync_for_cpu(sig_dma, sig_size, DMA_FROM_DEVICE);
+		memcpy(dst, sig_buf, sig_size);
+		ret = sig_size;
+	}
+
+out_unmap:
+	if (!cmh_dma_map_error(sig_dma))
+		cmh_dma_unmap_single(sig_dma, sig_size, DMA_FROM_DEVICE);
+	if (!cmh_dma_map_error(m_dma))
+		cmh_dma_unmap_single(m_dma, slen, DMA_TO_DEVICE);
+
+out_free:
+	kfree(sig_buf);
+	kfree(m_buf);
+	return ret;
+}
+
+/*
+ * ML-DSA verify (synchronous sig_alg)
+ *
+ * @src:    raw signature
+ * @slen:   signature length
+ * @digest: message bytes
+ * @dlen:   message length
+ *
+ * Returns 0 on successful verification, negative errno on failure.
+ */
+static int cmh_mldsa_verify(struct crypto_sig *tfm,
+			    const void *src, unsigned int slen,
+			    const void *digest, unsigned int dlen)
+{
+	struct cmh_mldsa_tfm_ctx *ctx = cmh_mldsa_ctx(tfm);
+	int mi = ctx->mode_idx;
+	u32 sig_size = ml_dsa_sig_size[mi];
+	u32 pk_size = ml_dsa_pk_size[mi];
+	struct core_dispatch d = cmh_core_select_instance(CMH_CORE_QSE);
+	struct vcq_cmd vcq[QSE_VCQ_CMDS_MIN];
+	u8 *sig_buf = NULL, *m_buf = NULL, *pk_buf = NULL;
+	dma_addr_t sig_dma = DMA_MAPPING_ERROR;
+	dma_addr_t m_dma = DMA_MAPPING_ERROR;
+	dma_addr_t pk_dma = DMA_MAPPING_ERROR;
+	int ret;
+
+	if (!ctx->pub_key)
+		return -EINVAL;
+	if (slen != sig_size)
+		return -EINVAL;
+	if (dlen > ML_DSA_MAX_MLEN)
+		return -EINVAL;
+
+	sig_buf = kmemdup(src, slen, GFP_KERNEL);
+	pk_buf = kmemdup(ctx->pub_key, pk_size, GFP_KERNEL);
+	if (!sig_buf || !pk_buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+	/* ML-DSA permits an empty message (FIPS 204); skip 0-length DMA. */
+	if (dlen) {
+		m_buf = kmemdup(digest, dlen, GFP_KERNEL);
+		if (!m_buf) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+	}
+
+	sig_dma = cmh_dma_map_single(sig_buf, sig_size, DMA_TO_DEVICE);
+	pk_dma = cmh_dma_map_single(pk_buf, pk_size, DMA_TO_DEVICE);
+	if (dlen) {
+		m_dma = cmh_dma_map_single(m_buf, dlen, DMA_TO_DEVICE);
+		if (cmh_dma_map_error(m_dma)) {
+			ret = -ENOMEM;
+			goto out_unmap;
+		}
+	}
+
+	if (cmh_dma_map_error(sig_dma) ||
+	    cmh_dma_map_error(pk_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	vcq_set_header(&vcq[0], QSE_VCQ_CMDS_MIN);
+	vcq_add_qse_ml_dsa_verify(&vcq[1], d.core_id, ctx->mode, 0,
+				  dlen ? m_dma : 0, pk_dma, sig_dma, dlen);
+	vcq_add_qse_flush(&vcq[2], d.core_id);
+
+	ret = cmh_tm_submit_sync_mbx(vcq, QSE_VCQ_CMDS_MIN, 1, d.mbx_idx);
+
+out_unmap:
+	if (!cmh_dma_map_error(pk_dma))
+		cmh_dma_unmap_single(pk_dma, pk_size, DMA_TO_DEVICE);
+	if (!cmh_dma_map_error(m_dma))
+		cmh_dma_unmap_single(m_dma, dlen, DMA_TO_DEVICE);
+	if (!cmh_dma_map_error(sig_dma))
+		cmh_dma_unmap_single(sig_dma, sig_size, DMA_TO_DEVICE);
+
+out_free:
+	kfree(pk_buf);
+	kfree(m_buf);
+	kfree(sig_buf);
+	return ret;
+}
+
+static int cmh_mldsa_set_pub_key(struct crypto_sig *tfm,
+				 const void *key, unsigned int keylen)
+{
+	struct cmh_mldsa_tfm_ctx *ctx = cmh_mldsa_ctx(tfm);
+	u32 expected = ml_dsa_pk_size[ctx->mode_idx];
+
+	if (keylen != expected)
+		return -EINVAL;
+
+	kfree(ctx->pub_key);
+	ctx->pub_key = NULL;
+	ctx->pub_key_len = 0;
+
+	ctx->pub_key = kmemdup(key, keylen, GFP_KERNEL);
+	if (!ctx->pub_key)
+		return -ENOMEM;
+
+	ctx->pub_key_len = keylen;
+	return 0;
+}
+
+static int cmh_mldsa_set_priv_key(struct crypto_sig *tfm,
+				  const void *key, unsigned int keylen)
+{
+	struct cmh_mldsa_tfm_ctx *ctx = cmh_mldsa_ctx(tfm);
+	u32 expected = ml_dsa_sk_size[ctx->mode_idx];
+
+	if (keylen != expected)
+		return -EINVAL;
+
+	return cmh_key_setkey_raw(&ctx->key, key, keylen, CORE_ID_QSE);
+}
+
+static unsigned int cmh_mldsa_key_size(struct crypto_sig *tfm)
+{
+	struct cmh_mldsa_tfm_ctx *ctx = cmh_mldsa_ctx(tfm);
+
+	/* crypto_sig_keysize() returns bits, not bytes */
+	return ml_dsa_pk_size[ctx->mode_idx] * 8;
+}
+
+static unsigned int cmh_mldsa_max_size(struct crypto_sig *tfm)
+{
+	struct cmh_mldsa_tfm_ctx *ctx = cmh_mldsa_ctx(tfm);
+
+	return ml_dsa_sig_size[ctx->mode_idx];
+}
+
+static int cmh_mldsa_44_init(struct crypto_sig *tfm)
+{
+	struct cmh_mldsa_tfm_ctx *ctx = cmh_mldsa_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->mode = ML_DSA_MODE_44;
+	ctx->mode_idx = 0;
+	return 0;
+}
+
+static int cmh_mldsa_65_init(struct crypto_sig *tfm)
+{
+	struct cmh_mldsa_tfm_ctx *ctx = cmh_mldsa_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->mode = ML_DSA_MODE_65;
+	ctx->mode_idx = 1;
+	return 0;
+}
+
+static int cmh_mldsa_87_init(struct crypto_sig *tfm)
+{
+	struct cmh_mldsa_tfm_ctx *ctx = cmh_mldsa_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->mode = ML_DSA_MODE_87;
+	ctx->mode_idx = 2;
+	return 0;
+}
+
+static void cmh_mldsa_exit(struct crypto_sig *tfm)
+{
+	struct cmh_mldsa_tfm_ctx *ctx = cmh_mldsa_ctx(tfm);
+
+	cmh_key_destroy(&ctx->key);
+	kfree(ctx->pub_key);
+	ctx->pub_key = NULL;
+}
+
+/*
+ * Priority 5001: the kernel's software ML-DSA (crypto/mldsa.c) registers
+ * at priority 5000 but only implements verify -- sign returns -EOPNOTSUPP.
+ * We provide full HW-accelerated sign + verify, so we must override.
+ */
+static struct sig_alg cmh_mldsa_algs[] = {
+	{
+		.sign		= cmh_mldsa_sign,
+		.verify		= cmh_mldsa_verify,
+		.set_pub_key	= cmh_mldsa_set_pub_key,
+		.set_priv_key	= cmh_mldsa_set_priv_key,
+		.key_size	= cmh_mldsa_key_size,
+		.max_size	= cmh_mldsa_max_size,
+		.init		= cmh_mldsa_44_init,
+		.exit		= cmh_mldsa_exit,
+		.base = {
+			.cra_name	  = "mldsa44",
+			.cra_driver_name  = "rambus-cmh-mldsa44",
+			.cra_priority	  = 5001,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_mldsa_tfm_ctx),
+		},
+	},
+	{
+		.sign		= cmh_mldsa_sign,
+		.verify		= cmh_mldsa_verify,
+		.set_pub_key	= cmh_mldsa_set_pub_key,
+		.set_priv_key	= cmh_mldsa_set_priv_key,
+		.key_size	= cmh_mldsa_key_size,
+		.max_size	= cmh_mldsa_max_size,
+		.init		= cmh_mldsa_65_init,
+		.exit		= cmh_mldsa_exit,
+		.base = {
+			.cra_name	  = "mldsa65",
+			.cra_driver_name  = "rambus-cmh-mldsa65",
+			.cra_priority	  = 5001,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_mldsa_tfm_ctx),
+		},
+	},
+	{
+		.sign		= cmh_mldsa_sign,
+		.verify		= cmh_mldsa_verify,
+		.set_pub_key	= cmh_mldsa_set_pub_key,
+		.set_priv_key	= cmh_mldsa_set_priv_key,
+		.key_size	= cmh_mldsa_key_size,
+		.max_size	= cmh_mldsa_max_size,
+		.init		= cmh_mldsa_87_init,
+		.exit		= cmh_mldsa_exit,
+		.base = {
+			.cra_name	  = "mldsa87",
+			.cra_driver_name  = "rambus-cmh-mldsa87",
+			.cra_priority	  = 5001,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_mldsa_tfm_ctx),
+		},
+	},
+};
+
+/**
+ * cmh_pqc_mldsa_register() - Register ML-DSA akcipher algorithms with the crypto framework
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_pqc_mldsa_register(void)
+{
+	int ret, i;
+
+	if (!cmh_core_present(CMH_CORE_QSE))
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(cmh_mldsa_algs); i++) {
+		ret = crypto_register_sig(&cmh_mldsa_algs[i]);
+		if (ret) {
+			dev_err(cmh_dev(), "cmh: failed to register %s (%d)\n",
+				cmh_mldsa_algs[i].base.cra_name, ret);
+			goto err_unregister;
+		}
+	}
+
+	return 0;
+
+err_unregister:
+	while (i--)
+		crypto_unregister_sig(&cmh_mldsa_algs[i]);
+	return ret;
+}
+
+/**
+ * cmh_pqc_mldsa_unregister() - Unregister ML-DSA akcipher algorithms from the crypto framework
+ */
+void cmh_pqc_mldsa_unregister(void)
+{
+	int i = ARRAY_SIZE(cmh_mldsa_algs);
+
+	if (!cmh_core_present(CMH_CORE_QSE))
+		return;
+
+	while (i--)
+		crypto_unregister_sig(&cmh_mldsa_algs[i]);
+}
diff --git a/drivers/crypto/cmh/cmh_pqc_sizes.c b/drivers/crypto/cmh/cmh_pqc_sizes.c
new file mode 100644
index 000000000000..39e3d56f4312
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pqc_sizes.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- PQC Algorithm Size Tables
+ *
+ * Centralised ML-DSA and SLH-DSA parameter-size arrays.  Declared
+ * extern in cmh_qse_abi.h / cmh_hcq_abi.h, defined here once to
+ * avoid per-TU duplication.
+ */
+
+#include <linux/build_bug.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+#include "cmh_qse_abi.h"
+#include "cmh_hcq_abi.h"
+
+/* ML-DSA size tables (indexed by ml_dsa_mode_idx()) */
+const u32 ml_dsa_pk_size[3]  = { 1312U, 1952U, 2592U };
+const u32 ml_dsa_sk_size[3]  = { 2560U, 4032U, 4896U };
+const u32 ml_dsa_sk_size_masked[3] = { 3360U, 5472U, 6368U };
+const u32 ml_dsa_sig_size[3] = { 2420U, 3309U, 4627U };
+
+static_assert(ARRAY_SIZE(ml_dsa_pk_size) == ARRAY_SIZE(ml_dsa_sk_size));
+static_assert(ARRAY_SIZE(ml_dsa_pk_size) == ARRAY_SIZE(ml_dsa_sk_size_masked));
+static_assert(ARRAY_SIZE(ml_dsa_pk_size) == ARRAY_SIZE(ml_dsa_sig_size));
+
+/* SLH-DSA n-values and signature sizes (indexed by param_set - 1) */
+const u32 slhdsa_n[12] = {
+	16, 16, 24, 24, 32, 32,		/* SHAKE 128s/f, 192s/f, 256s/f */
+	16, 16, 24, 24, 32, 32,		/* SHA2 128s/f, 192s/f, 256s/f */
+};
+
+const u32 slhdsa_sig_size[12] = {
+	7856,  17088, 16224, 35664, 29792, 49856,	/* SHAKE */
+	7856,  17088, 16224, 35664, 29792, 49856,	/* SHA2 */
+};
+
+static_assert(ARRAY_SIZE(slhdsa_n) == ARRAY_SIZE(slhdsa_sig_size));
diff --git a/drivers/crypto/cmh/cmh_qse.c b/drivers/crypto/cmh/cmh_qse.c
new file mode 100644
index 000000000000..257dc3ee29a8
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_qse.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- QSE Core VCQ Builders
+ *
+ * VCQ builder functions for ML-KEM and ML-DSA commands (plain and masked).
+ * Each function populates a single vcq_cmd slot.  Callers assemble
+ * complete VCQs with header + command(s) + flush, then submit via
+ * cmh_tm_submit_sync().
+ */
+
+#include <linux/string.h>
+
+#include "cmh_sys.h"
+
+/* -- QSE flush -- */
+
+/**
+ * vcq_add_qse_flush() - Build a QSE flush VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ */
+void vcq_add_qse_flush(struct vcq_cmd *slot, u32 core_id)
+{
+	vcq_add_flush(slot, core_id);
+}
+
+/* -- ML-KEM -- */
+
+/**
+ * vcq_add_qse_ml_kem_keygen() - Build an ML-KEM key generation VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @k: ML-KEM security parameter (k = 2, 3, or 4)
+ * @flags: Command flags
+ * @seed: DMA address of seed input buffer
+ * @z: DMA address of implicit rejection value buffer
+ * @ek: DMA address of encapsulation key output buffer
+ * @dk: DMA address of decapsulation key output buffer
+ * @dk_type: Decapsulation key datastore type
+ * @masked: Use masked (side-channel protected) variant
+ */
+void vcq_add_qse_ml_kem_keygen(struct vcq_cmd *slot, u32 core_id, u32 k, u32 flags,
+			       u64 seed, u64 z, u64 ek, u64 dk, u32 dk_type,
+			       bool masked)
+{
+	u32 cmd_id = masked ? QSE_CMD_ML_KEM_KEYGEN_MASKED
+			    : QSE_CMD_ML_KEM_KEYGEN;
+
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, cmd_id);
+	slot->hwc.qse.cmd_ml_kem_keygen.k = k;
+	slot->hwc.qse.cmd_ml_kem_keygen.flags = flags;
+	slot->hwc.qse.cmd_ml_kem_keygen.seed = seed;
+	slot->hwc.qse.cmd_ml_kem_keygen.z = z;
+	slot->hwc.qse.cmd_ml_kem_keygen.ek = ek;
+	slot->hwc.qse.cmd_ml_kem_keygen.dk = dk;
+	slot->hwc.qse.cmd_ml_kem_keygen.dk_type = dk_type;
+}
+
+/**
+ * vcq_add_qse_ml_kem_enc() - Build an ML-KEM encapsulation VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @k: ML-KEM security parameter (k = 2, 3, or 4)
+ * @flags: Command flags
+ * @coin: DMA address of encapsulation coin/randomness buffer
+ * @ek: DMA address of encapsulation key input buffer
+ * @ct: DMA address of ciphertext output buffer
+ * @ss: DMA address of shared secret output buffer
+ * @ss_type: Shared secret datastore type
+ * @masked: Use masked (side-channel protected) variant
+ */
+void vcq_add_qse_ml_kem_enc(struct vcq_cmd *slot, u32 core_id, u32 k, u32 flags,
+			    u64 coin, u64 ek, u64 ct, u64 ss, u32 ss_type,
+			    bool masked)
+{
+	u32 cmd_id = masked ? QSE_CMD_ML_KEM_ENC_MASKED
+			    : QSE_CMD_ML_KEM_ENC;
+
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, cmd_id);
+	slot->hwc.qse.cmd_ml_kem_enc.k = k;
+	slot->hwc.qse.cmd_ml_kem_enc.flags = flags;
+	slot->hwc.qse.cmd_ml_kem_enc.coin = coin;
+	slot->hwc.qse.cmd_ml_kem_enc.ek = ek;
+	slot->hwc.qse.cmd_ml_kem_enc.ct = ct;
+	slot->hwc.qse.cmd_ml_kem_enc.ss = ss;
+	slot->hwc.qse.cmd_ml_kem_enc.ss_type = ss_type;
+}
+
+/**
+ * vcq_add_qse_ml_kem_dec() - Build an ML-KEM decapsulation VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @k: ML-KEM security parameter (k = 2, 3, or 4)
+ * @flags: Command flags
+ * @ct: DMA address of ciphertext input buffer
+ * @dk: DMA address of decapsulation key input buffer
+ * @ss: DMA address of shared secret output buffer
+ * @ss_type: Shared secret datastore type
+ * @masked: Use masked (side-channel protected) variant
+ */
+void vcq_add_qse_ml_kem_dec(struct vcq_cmd *slot, u32 core_id, u32 k, u32 flags,
+			    u64 ct, u64 dk, u64 ss, u32 ss_type,
+			    bool masked)
+{
+	u32 cmd_id = masked ? QSE_CMD_ML_KEM_DEC_MASKED
+			    : QSE_CMD_ML_KEM_DEC;
+
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, cmd_id);
+	slot->hwc.qse.cmd_ml_kem_dec.k = k;
+	slot->hwc.qse.cmd_ml_kem_dec.flags = flags;
+	slot->hwc.qse.cmd_ml_kem_dec.ct = ct;
+	slot->hwc.qse.cmd_ml_kem_dec.dk = dk;
+	slot->hwc.qse.cmd_ml_kem_dec.ss = ss;
+	slot->hwc.qse.cmd_ml_kem_dec.ss_type = ss_type;
+}
+
+/* -- ML-DSA -- */
+
+/**
+ * vcq_add_qse_ml_dsa_keygen() - Build an ML-DSA key generation VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @mode: ML-DSA mode (44, 65, or 87)
+ * @flags: Command flags
+ * @seed: DMA address of seed input buffer
+ * @pk: DMA address of public key output buffer
+ * @sk: DMA address of secret key output buffer
+ * @sk_type: Secret key datastore type
+ * @masked: Use masked (side-channel protected) variant
+ */
+void vcq_add_qse_ml_dsa_keygen(struct vcq_cmd *slot, u32 core_id, u32 mode, u32 flags,
+			       u64 seed, u64 pk, u64 sk, u32 sk_type,
+			       bool masked)
+{
+	u32 cmd_id = masked ? QSE_CMD_ML_DSA_KEYGEN_MASKED
+			    : QSE_CMD_ML_DSA_KEYGEN;
+
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, cmd_id);
+	slot->hwc.qse.cmd_ml_dsa_keygen.mode = mode;
+	slot->hwc.qse.cmd_ml_dsa_keygen.flags = flags;
+	slot->hwc.qse.cmd_ml_dsa_keygen.seed = seed;
+	slot->hwc.qse.cmd_ml_dsa_keygen.pk = pk;
+	slot->hwc.qse.cmd_ml_dsa_keygen.sk = sk;
+	slot->hwc.qse.cmd_ml_dsa_keygen.sk_type = sk_type;
+}
+
+/**
+ * vcq_add_qse_ml_dsa_sign() - Build an ML-DSA signing VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @mode: ML-DSA mode (44, 65, or 87)
+ * @flags: Command flags
+ * @rnd: DMA address of signing randomness buffer
+ * @m: DMA address of message buffer
+ * @sk: DMA address of secret key buffer
+ * @sig: DMA address of signature output buffer
+ * @mlen: Length of message in bytes
+ * @masked: Use masked (side-channel protected) variant
+ */
+void vcq_add_qse_ml_dsa_sign(struct vcq_cmd *slot, u32 core_id, u32 mode, u32 flags,
+			     u64 rnd, u64 m, u64 sk, u64 sig, u32 mlen,
+			     bool masked)
+{
+	u32 cmd_id = masked ? QSE_CMD_ML_DSA_SIGN_MASKED
+			    : QSE_CMD_ML_DSA_SIGN;
+
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, cmd_id);
+	slot->hwc.qse.cmd_ml_dsa_sign.mode = mode;
+	slot->hwc.qse.cmd_ml_dsa_sign.flags = flags;
+	slot->hwc.qse.cmd_ml_dsa_sign.rnd = rnd;
+	slot->hwc.qse.cmd_ml_dsa_sign.m = m;
+	slot->hwc.qse.cmd_ml_dsa_sign.sk = sk;
+	slot->hwc.qse.cmd_ml_dsa_sign.sig = sig;
+	slot->hwc.qse.cmd_ml_dsa_sign.mlen = mlen;
+}
+
+/**
+ * vcq_add_qse_ml_dsa_verify() - Build an ML-DSA signature verify VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @mode: ML-DSA mode (44, 65, or 87)
+ * @flags: Command flags
+ * @m: DMA address of message buffer
+ * @pk: DMA address of public key buffer
+ * @sig: DMA address of signature buffer to verify
+ * @mlen: Length of message in bytes
+ */
+void vcq_add_qse_ml_dsa_verify(struct vcq_cmd *slot, u32 core_id, u32 mode, u32 flags,
+			       u64 m, u64 pk, u64 sig, u32 mlen)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, QSE_CMD_ML_DSA_VERIFY);
+	slot->hwc.qse.cmd_ml_dsa_verify.mode = mode;
+	slot->hwc.qse.cmd_ml_dsa_verify.flags = flags;
+	slot->hwc.qse.cmd_ml_dsa_verify.m = m;
+	slot->hwc.qse.cmd_ml_dsa_verify.pk = pk;
+	slot->hwc.qse.cmd_ml_dsa_verify.sig = sig;
+	slot->hwc.qse.cmd_ml_dsa_verify.mlen = mlen;
+}
-- 
2.43.7

