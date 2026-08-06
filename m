Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020142.outbound.protection.outlook.com [52.101.61.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB494D8DA1;
	Thu,  6 Aug 2026 19:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.142
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046148; cv=fail; b=TN6BIEFchRzaZFmwp7VzIAHwCXKceXcHQN4HlHEzKCJsSW8Gfl6DQq+bl3VWgUk42VICWp8kye1t0SVW4ysFkEwyCNDAMfu0vIs3+fRvZ0i7Fpvx69L9ZYh+S4uOlzfSAMlnXhcATglBlQa3FWUvdNcEC2HPmdqTAaBPUWwEI4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046148; c=relaxed/simple;
	bh=QD8AETO4dTFMPIpi1Tmxw9/88Nh86Y7kJUsCnGEZIEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R0jO4EzI5WyX/fHSKJuvJhrhvAeQExQAHcXHqWENAHiEb6f/lyn9Xv5CvZ9dPZguAhgHOXaYWrxhl0irXORXIA8wz9l+ViXkkE7HuBMZVeSoVbzOeGZvHpb1mIzQuFTDbdcrMQkAjncybsRrEFIxD+ec0SfkXcQPSxvNZSkiSvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=nFk29+80; arc=fail smtp.client-ip=52.101.61.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="nFk29+80"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cq3/q9YK3Mn7pwUQ6diGhPUzMyRp9eJgdFxgkXWIL+UfbnI1KtOqxMP+QnUY7WV0C5wRYpdqa7Y2p5c3G7iTjeQj5pWk8qOgGvNC9mcUijGWRNHVQgdukpXUJ7sQL4KIMrXIZCnAbb+jCvA8A86fn7poRu0Km5Lp50Od/mCHsICNxNx+Vd9+xnfOCfxeI2LTIxAkjqqtseFk4fzv/BSa3wMnaS2ThiEQHyWz6gTn3jW8lBXaWWJF6AWrDyhESAVFv/7pe6OwOAYvLVIbChePjMakV9coWq6ohLgMDlcLs0D9srBqBypUA5tG+VQnCF+ULMi6VbojcSez9m5j/jokww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jkMQGDJV9wcyxCduhnvfbaib2nXybb7RCwYf0W3oFDY=;
 b=nq4nCBfP7IfJRe8q90btQPJWTory4kfSkRYxk9GYYYVXYtkMqYe2ygkIyF/Upq1Ur+K+cX1OKJGs193V/grWizgZZ4khZc4ozvoCfv9w0B+cH0q1s1nuJGYX0i6t2hHZ5jKsG+r493PlcAxu98Fgp/Vx/bRx5JGegwrQDh1MnK78A+8g2qn6x/x/rQLeENSbWZyxAHG6sO1iQe6IdHeV0Pl3op0h4gc9H0fDpJWh4bEiVNwSPMh8N37uCj7Z2tadSVOeFZKZ6X8xzzf9ivIcsrLBu/sYbUgJ6tMtCwL+dHyqwCCird9mi0SCMDjCMOovBm/sou1FTzUCkLFSwF2m+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkMQGDJV9wcyxCduhnvfbaib2nXybb7RCwYf0W3oFDY=;
 b=nFk29+80MXulAHfz2Rx2mVpapdS/qkA8GPKmPFmlLiPq5+q/0A1p6GMl64ih+bAj6uht+91pN75h/l7gFQ20ACZN5dHTav5k+PWVmdwWwnllqjhtu58hd5nX2Jei3QMof5Tr2uvyreLKjZVKI1ao4NmQla1eXRjlu7fKVtXpWoTp1mBMV5wSJH5czZxfVnYtgiB8zGjfTSg4MgxFG+vM+++Yp+9yx2Ga+twrFYxsAv0aWP5yWCgszz4tqD6MR+uo7vutLsF5h1lN4Ks/9QrexdOvlpX7vIFkDS2ituZ8Nu4ed/ORiQG+IhseSKjeTpU0skFac8c/KRalINMo/6d7zw==
Received: from BY1P220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::11)
 by PH7PR04MB8633.namprd04.prod.outlook.com (2603:10b6:510:245::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 19:55:29 +0000
Received: from SJ1PEPF000026C9.namprd04.prod.outlook.com
 (2603:10b6:a03:59d:cafe::16) by BY1P220CA0011.outlook.office365.com
 (2603:10b6:a03:59d::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Thu, 6
 Aug 2026 19:55:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 SJ1PEPF000026C9.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Thu, 6 Aug 2026 19:55:29 +0000
Received: from hqxsv-cmdev3-skrishnamoorthy.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTPS id 3A1A7180176B;
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
Subject: [PATCH v3 15/19] crypto: cmh - add ML-KEM/ML-DSA (QSE)
Date: Thu,  6 Aug 2026 12:55:14 -0700
Message-ID: <20260806195519.2703224-16-skrishnamoorthy@rambus.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C9:EE_|PH7PR04MB8633:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 8abb10a3-76fb-4d01-1758-08def3f4aac3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|7416014|1800799024|82310400026|921020|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	tcKfNi8uKMYbEHqzis42YANeAdLlbFHgqzp5EiiWjsbwfzBndcyjme84CYH+flPUCK5xH8Xl2WWTzzcSz+N1RlpNgfkVeEZHurbq7T0B+4VgWb9W4h6mxRDmglQP14R8njLfhiSAM2KR0eHRNKRN1dVETiT/MOAKM+YaGtGCEjN7QNLF+WeTWkO+mzNzGKVjFRFlWrU5nGc/4Tqahqh2hA8iztxjHr96gvn68eg7ZG3wymG4XJ/bEmL1A5nYxJjoYYtUZmj2XMo7ZGPAHrpvrVriNHxTBTXMlT+pZxLAL6Z2Y0JExfEYv8QJWOiUXwpIEUDG81B1BzepwcSFX/F6yO+3OxDCYzYZtD7tC8dVq6OAKzDorzqVDgnP5C1ttMQe9D322xlxzaYL5ZhMlcGXcCaqiagGuY7nxshZcy9ysMBuUDCz4i2dgqkmqlAdirWz9nSzax4C/AeL/HbRq83eDTJUe8g03KJb+SelnZcNig6mrIivzQvNH8bZ1w12faz/ImhMPiVewHFwD6PCA57mUym2z4+xg4uNMRyIMjLUpAARS5X8tmTtvufP8iJLa6kQCmYUIE7m5YRn6k7lJhFRH+jh2eAudl2Bd1nlGTXzchFj11LClHy5okk5G1ZnksDNE2Aa0V6MxPAxGoFk2yR3tbSS+Dk8YKWYVQWy/9AnoYRHWLiGiHJyfQPPcPtfbHHbaoK8xwV8Dg/+kSKaC9Atlaugg2SrEmLzVsywHkFa1Hm/5DdhMUo0tO+284wy9KNF
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(7416014)(1800799024)(82310400026)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	c2Hs/vxnt+CZG49d2fi5xW9vUk+YE5K4KSU98fUWcKcEUIHeUQ3LHZkF/degaM6aaEbsebC3gwX9ZPExxWIJYSl/EkhXnkLJ/VZ1Hm74jEqoLtNvzDe/Ic8QoQzCg9ad5PdfWcGf6BqpL/Z0Yq1bRErgfWBloPI2uPNuc55rN7feVzcTNJJXcGAQTkxGYsXC8RfSQUFVpcwe58fYjmywYBwEy1/rAm/NrQSwZRnGWgky0iHc0liZSGLpN70Vz0EbuKXk3hw734ODNDisxn/Euzc4Jz1V7zzlzKHBVbW40xV66gxzVXg0HPSB/VJEBmt9MUbbuPUXcDi8QG4tvjB2VWDGJuRrlbZDfFw4CO8Z+Xl5xUnqv3jTTn+rsl7T/y0K4KA6wHmaox4s+NOzbRtPGl8hxkfZ6seESdopQO+WeW/nya+L53uaiLW0u5zhP3ZB
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 19:55:29.5210
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8abb10a3-76fb-4d01-1758-08def3f4aac3
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8633

From: Alex Ousherovitch <aousherovitch@rambus.com>

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

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
Reviewed-by: Thi Nguyen <thin@rambus.com>
---
 drivers/crypto/cmh/Makefile        |   5 +-
 drivers/crypto/cmh/cmh_main.c      |   9 +
 drivers/crypto/cmh/cmh_pqc_mldsa.c | 383 +++++++++++++++++++++++++++++
 drivers/crypto/cmh/cmh_pqc_sizes.c |  39 +++
 drivers/crypto/cmh/cmh_qse.c       | 211 ++++++++++++++++
 5 files changed, 646 insertions(+), 1 deletion(-)
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
index 302d975256e8..74d2b3672d2a 100644
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
@@ -337,6 +338,11 @@ static int cmh_probe(struct platform_device *pdev)
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
@@ -349,6 +355,8 @@ static int cmh_probe(struct platform_device *pdev)
 	return 0;
 
 err_mgmt_register:
+	cmh_pqc_mldsa_unregister();
+err_pqc_mldsa_register:
 	cmh_pke_ecdh_unregister();
 err_pke_ecdh_register:
 	cmh_pke_ecdsa_unregister();
@@ -411,6 +419,7 @@ static void cmh_remove(struct platform_device *pdev)
 	cfg = &dev->config;
 
 	cmh_mgmt_unregister();
+	cmh_pqc_mldsa_unregister();
 	cmh_pke_ecdh_unregister();
 	cmh_pke_ecdsa_unregister();
 	cmh_pke_rsa_unregister();
diff --git a/drivers/crypto/cmh/cmh_pqc_mldsa.c b/drivers/crypto/cmh/cmh_pqc_mldsa.c
new file mode 100644
index 000000000000..8f9bdf67aea2
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pqc_mldsa.c
@@ -0,0 +1,383 @@
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
+	if (!slen || slen > ML_DSA_MAX_MLEN)
+		return -EINVAL;
+
+	m_buf = kmemdup(src, slen, GFP_KERNEL);
+	sig_buf = kzalloc(sig_size, GFP_KERNEL);
+	if (!m_buf || !sig_buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	if (ctx->key.raw.len != sk_size) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	m_dma = cmh_dma_map_single(m_buf, slen, DMA_TO_DEVICE);
+	sig_dma = cmh_dma_map_single(sig_buf, sig_size, DMA_FROM_DEVICE);
+
+	if (cmh_dma_map_error(m_dma) || cmh_dma_map_error(sig_dma)) {
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
+				0, m_dma, ctx->key.raw.dma, sig_dma, slen,
+				false);
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
+	if (!dlen || dlen > ML_DSA_MAX_MLEN)
+		return -EINVAL;
+
+	sig_buf = kmemdup(src, slen, GFP_KERNEL);
+	m_buf = kmemdup(digest, dlen, GFP_KERNEL);
+	pk_buf = kmemdup(ctx->pub_key, pk_size, GFP_KERNEL);
+	if (!sig_buf || !m_buf || !pk_buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	sig_dma = cmh_dma_map_single(sig_buf, sig_size, DMA_TO_DEVICE);
+	m_dma = cmh_dma_map_single(m_buf, dlen, DMA_TO_DEVICE);
+	pk_dma = cmh_dma_map_single(pk_buf, pk_size, DMA_TO_DEVICE);
+
+	if (cmh_dma_map_error(sig_dma) || cmh_dma_map_error(m_dma) ||
+	    cmh_dma_map_error(pk_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	vcq_set_header(&vcq[0], QSE_VCQ_CMDS_MIN);
+	vcq_add_qse_ml_dsa_verify(&vcq[1], d.core_id, ctx->mode, 0,
+				  m_dma, pk_dma, sig_dma, dlen);
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

