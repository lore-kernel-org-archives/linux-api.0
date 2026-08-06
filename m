Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022125.outbound.protection.outlook.com [52.101.48.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ACB35838A;
	Thu,  6 Aug 2026 19:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046144; cv=fail; b=gyyd96lm2QvmQKcsNYTbnyfkP3MIyBdWqgFQgngvfHg0D1k0E+2k/HGsLt2DLLpQemT4UUxis+13aVCIh6B1qQYddwv1zUr1ucUu4zhL45dP6qTR1gAZ5oiOfjPOCKa8RrU/6eobBWaYlp8VbZN7daXlvYP4o0K3gHPK7VJ5OhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046144; c=relaxed/simple;
	bh=IZRbANjdzWF/Z/3klJwObwLaYhQ1/lmUC0PwpctNN1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qux9BkSgmwiwGTH1t/lTaHMiUhZ0mFrrECk97/D9KcEzSRkbY3gKf1H6h58jCTM5HiwsDzXJFTGMDCySA1JFyUWmOGw5jhsPaoNzcgkXSAzDijHHX5PHwV4c25Xf0ROpkwq4BTezcKJZ4ShTixlpRiBYacjQZ3Q+zo5or0GWzGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=Khc7VURy; arc=fail smtp.client-ip=52.101.48.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="Khc7VURy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f3U7KPKE/qTBvCbwZ34+IOuxxPAcY89Fuqm/i0Yus9yRVKb4MkrdFHkqVxxKQWpw8YYbAUdTkWxeTAR87xmWleQS0+s/VKNQ44UnFfyP/jJlRpfyOhlu4mh38Z+N6roCKUNpMTzS3iDr7yhVnvdj+x2qjbM1dhSXNvDjOOJWaxTCISrKqYB8wLMLVMQXR52Bz1dT/tqi2XDpK3p9SNnPzzFb5capvS826MfXxEPT/Nez07L1Bw+kB96kM5XrxSbKEEiUUiUfiO3B88yCUsftzsX4XuNy5S/awN21iWGAOhHKlgTL24BDg/RBB3ZU37EHMtN5Mx9TtD1VbZKWDRUlgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRy3IcrUYuXZeYCV2UxYSPO3oVJzLz84j+WY2vspzuU=;
 b=zII4FfC5n83gDXKpcn/s9fnJ0lvfKhYsbtUPcH/Txeyznhi19E+NdSg9dlh/aEslg76w6K8Y3x9cKfAkhU0cpd35sZ/pWY4IupEtjtLvzsWTHDXMqxXy0xnl2YyLcuvk2vSxxbkujiHDwhwWFhipl2mnvj31AQ8YlT094aouSePsuj/iIAyCXBFOEK83SxnEUedRqmeJMmEMKM1OwvTN7UZr0Uv2pJwUMHpnCsksLoDwetP07LjDwhbYjtbYNCOn8VvrrHLUs/bmhaSLAAaMRjaQXBo2EY8VYvf75KHVpXP+gx0Gedg5QhxUOPxBthorLW0JAHLjo/mQ9M6Nt/rzSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRy3IcrUYuXZeYCV2UxYSPO3oVJzLz84j+WY2vspzuU=;
 b=Khc7VURy3mVM0035R+C61El2UfaY8pvLvCqVIhiswASlh68KqYHJgVUgpXaObCubC1Scj+I+f49XKP0ZrqiWJkU7FqtIb2BcPHV9uviussMQAqfLmeOA5nebHvJ7xBYZ6uCP9ki4mZIUAjEBgqvIJOwcIVG9GIOzafxWkUmiiH8yJn3Drf/bBEqYYYN4EtZwfYuhTdWTEWAXhpeVLrGZV8zKgBv7MVFdDVx4pnKe/kxP7g59tFfrB/woVtV8Gsalg7oZAe3q1Iy3b+wOzW9qk/dpG74WR3/hfrWEANqYSVN48lP90u5U6B22CoWTXWnBuuvosEIAShGFsPf+tPzIWA==
Received: from SJ0PR05CA0081.namprd05.prod.outlook.com (2603:10b6:a03:332::26)
 by LV2PR04MB9834.namprd04.prod.outlook.com (2603:10b6:408:34c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Thu, 6 Aug
 2026 19:55:30 +0000
Received: from SJ1PEPF000026C5.namprd04.prod.outlook.com
 (2603:10b6:a03:332:cafe::44) by SJ0PR05CA0081.outlook.office365.com
 (2603:10b6:a03:332::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.8 via Frontend Transport; Thu, 6
 Aug 2026 19:55:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 SJ1PEPF000026C5.mail.protection.outlook.com (10.167.244.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Thu, 6 Aug 2026 19:55:29 +0000
Received: from hqxsv-cmdev3-skrishnamoorthy.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTPS id 29D251801769;
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
Subject: [PATCH v3 14/19] crypto: cmh - add ECDH/X25519 kpp
Date: Thu,  6 Aug 2026 12:55:13 -0700
Message-ID: <20260806195519.2703224-15-skrishnamoorthy@rambus.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C5:EE_|LV2PR04MB9834:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: f1a43b63-c327-4d7c-244e-08def3f4aabe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|82310400026|1800799024|376014|36860700016|10067099003|56012099006|11063799006|5023799004|6133799003|3023799007|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	CDpKAfX8ggnrf218x9gVt20d7FGvf7ac+D5POsT8b2kRLbr7s2uqI8jqIUPxx5Gnyd2U98uFZg32hAX/GnyCIdi0ogRjl+fcvA96SzKdck1KjkL+sG51fzSAA4du7NfkbFoaDB6BScHl672+XbXV+Qpi2UgTe6uPvDvXOl0SP6RRiPqyycRAMgVjrIFwVcaOm6cPjwfxe76I7E+HedUMzaXfwxvyA6up09LbT7ASe4nEErE8FUoZ43LXoB6d+9/mvG3uONi8Y2uslGqsTzRNQr5Zu7EXYLgy10o8voey/wbwTjSpgilDLGkY0aLR6E9lhIFQjJsnhR9saV30rDYxeE7DgzX3f1fnNOVfhn1296NlZeGlk/xcO410J1twIrLgAkraCJxrWhqYQPhxdsFugwPkHD/wE+XHYIKql62FgEBpChzNBhl/p8UnhI3AhiXYWBUG24sVr22GHYgeo7DPQCwXIGqsZOSE5msTLIrk64XjOI2Ru3CRCV+iN2d11XGNlcnVtnlcLdpqMhLwGkvmqg7neHCB+LTkqwGdhYMzb9foDEXRwY471JfeOYGNnjyNBSOiMn95O+8oBnxpQ4riO4/Ymb5rSkQPf9ZGOLs+9O3NJa08Dx73L76rVJf2QuXVOkhYiYMFCb8vzZepwePSnKSwuGzgv5ANMrIOof2CTBAwjFbJ4S6r/E8lBhQY/4ciTeCb+86yp1OB02ubBUlRdwwSQTh9LV0lgcuF3/bUmFn/G29UTCurzyRpE6c3PS2b
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(82310400026)(1800799024)(376014)(36860700016)(10067099003)(56012099006)(11063799006)(5023799004)(6133799003)(3023799007)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MBVK3IiAvGute8MAjT6KAKVVfu1+IOZww8U5gbHWtSp7RkP7nIGr/NqzOYGPLQwE/bDOB1ZibPcBjDDYuE3dpgwzE9DdEKTMFkRJUEIADkbdhOgVbYm/dV6uOF4PV05DGHFSN0+nnEP3svC9OD+crzyv4EcpEnKziia9FxAJf4No9K9zFly5gQJIyTPGc6C0UKNfC6KuC1TqE+o6IawUt4bHKGltfmmR+I80Y+e4rNPSmf6lSccaNleHiwWWzZd25ME31Ryc1vKN1WYtxZlJbwL4JZsMIkPnGQaYlVyAJc1AZTw97f8wERJrAI6cr4nIecrKUKtod5HlcNUeMWP2iW1RZ6vrHuw2TUV5mK/eT8Kthh7bmsx3krjad7o0cF62+bRKu3ljqBoWJq/EdGtrDGUAi9WYzHsnUHPKa7U6e5I08by3HWVDlZuRXs29mKIw
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 19:55:29.4885
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a43b63-c327-4d7c-244e-08def3f4aabe
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB9834

From: Alex Ousherovitch <aousherovitch@rambus.com>

Register ECDH and X25519 kpp algorithms using the CMH PKE core.
Supports P-256, P-384, and Curve25519 for key agreement.

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
Reviewed-by: Thi Nguyen <thin@rambus.com>
---
 drivers/crypto/cmh/Makefile       |   3 +-
 drivers/crypto/cmh/cmh_main.c     |   8 +
 drivers/crypto/cmh/cmh_pke_ecdh.c | 663 ++++++++++++++++++++++++++++++
 3 files changed, 673 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/cmh/cmh_pke_ecdh.c

diff --git a/drivers/crypto/cmh/Makefile b/drivers/crypto/cmh/Makefile
index ae1f74a93e99..da420d0ec1fe 100644
--- a/drivers/crypto/cmh/Makefile
+++ b/drivers/crypto/cmh/Makefile
@@ -32,7 +32,8 @@ cmh-y := \
 	cmh_rng.o \
 	cmh_pke_common.o \
 	cmh_pke_rsa.o \
-	cmh_pke_ecdsa.o
+	cmh_pke_ecdsa.o \
+	cmh_pke_ecdh.o
 
 # Management ioctl device (/dev/cmh_mgmt): key lifecycle, PKE, PQC ioctls.
 cmh-$(CONFIG_CRYPTO_DEV_CMH_MGMT) += \
diff --git a/drivers/crypto/cmh/cmh_main.c b/drivers/crypto/cmh/cmh_main.c
index 82b734b42805..302d975256e8 100644
--- a/drivers/crypto/cmh/cmh_main.c
+++ b/drivers/crypto/cmh/cmh_main.c
@@ -332,6 +332,11 @@ static int cmh_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_pke_ecdsa_register;
 
+	/* Register PKE ECDH/X25519 kpp */
+	ret = cmh_pke_ecdh_register();
+	if (ret)
+		goto err_pke_ecdh_register;
+
 	/* Register key management device (/dev/cmh_mgmt) */
 	ret = cmh_mgmt_register();
 	if (ret)
@@ -344,6 +349,8 @@ static int cmh_probe(struct platform_device *pdev)
 	return 0;
 
 err_mgmt_register:
+	cmh_pke_ecdh_unregister();
+err_pke_ecdh_register:
 	cmh_pke_ecdsa_unregister();
 err_pke_ecdsa_register:
 	cmh_pke_rsa_unregister();
@@ -404,6 +411,7 @@ static void cmh_remove(struct platform_device *pdev)
 	cfg = &dev->config;
 
 	cmh_mgmt_unregister();
+	cmh_pke_ecdh_unregister();
 	cmh_pke_ecdsa_unregister();
 	cmh_pke_rsa_unregister();
 	cmh_ccp_poly_unregister();
diff --git a/drivers/crypto/cmh/cmh_pke_ecdh.c b/drivers/crypto/cmh/cmh_pke_ecdh.c
new file mode 100644
index 000000000000..1b49dd060e52
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pke_ecdh.c
@@ -0,0 +1,663 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- ECDH / X25519 kpp Driver
+ *
+ * Registers "ecdh-nist-p256", "ecdh-nist-p384", and "curve25519"
+ * kpp algorithms with priority 300.
+ *
+ * - set_secret: decodes private key from kpp_secret + ecdh struct
+ *   (NIST curves) or raw 32-byte scalar (Curve25519).
+ *   Stores in cmh_key_ctx: raw keys written via SYS_REF_TEMP.
+ *   Datastore-referenced keys are only reachable through the ioctl
+ *   path (cmh_mgmt.c).
+ *
+ * - generate_public_key: PKE_CMD_ECDH_KEYGEN -> outputs X coordinate
+ *   (NIST Weierstrass) or full public key (Edwards/Montgomery).
+ *   For NIST curves, we generate X||Y by calling ECDSA_PUBGEN instead,
+ *   matching the kernel ecdh.c pattern that outputs uncompressed X||Y.
+ *
+ * - compute_shared_secret: PKE_CMD_ECDH -> shared secret X coordinate.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/scatterlist.h>
+#include <crypto/kpp.h>
+#include <crypto/ecdh.h>
+#include <crypto/internal/kpp.h>
+#include <crypto/internal/ecc.h>
+
+#include "cmh_pke.h"
+#include "cmh_sys.h"
+#include "cmh_sys_abi.h"
+#include "cmh_txn.h"
+#include "cmh_dma.h"
+#include "cmh_key.h"
+
+/*
+ * ECDH key format: kpp_secret header + key_size(u16) + key data.
+ * We decode this inline to avoid depending on CONFIG_CRYPTO_ECDH.
+ */
+#define ECDH_KPP_SECRET_MIN_SIZE (sizeof(struct kpp_secret) + sizeof(unsigned short))
+
+struct cmh_ecdh_tfm_ctx {
+	struct cmh_key_ctx key;
+	u32 curve;		/* PKE_CURVE_* */
+	u32 clen;		/* coordinate length in bytes */
+};
+
+static inline struct cmh_ecdh_tfm_ctx *cmh_ecdh_ctx(struct crypto_kpp *tfm)
+{
+	return kpp_tfm_ctx(tfm);
+}
+
+/*
+ * Per-request context for ECDH/X25519 operations.
+ *
+ * generate_public_key: single-phase async VCQ.
+ * compute_shared_secret: 2-phase async VCQ with callback chaining.
+ *   Phase 1: sys_write(sk) + sys_new(ref) + ecdh(peer) + pflush
+ *            -> phase1 callback reads ref, submits Phase 2.
+ *   Phase 2: sys_data(ref, ss_dma) + sys_flush
+ *            -> phase2 callback extracts shared secret, completes req.
+ *
+ * Both phases target the same mbx_idx so the DS reference remains
+ * valid, since DS objects are MBX-scoped.
+ */
+struct cmh_ecdh_reqctx {
+	/* Buffers */
+	u8 *pk_buf;		/* keygen: output public key */
+	u8 *peer_buf;		/* compute: peer public key */
+	u8 *ss_buf;		/* compute: shared secret output */
+	u64 *ref_buf;		/* compute: DS ref from Phase 1 */
+	/* DMA handles */
+	dma_addr_t pk_dma;
+	dma_addr_t peer_dma;
+	dma_addr_t ss_dma;
+	dma_addr_t ref_dma;
+	/* Sizes and params for Phase 2 re-submit */
+	u32 out_len;		/* keygen: public key size */
+	u32 clen;
+	u32 peer_len;
+	u32 dma_swap;
+	int mbx_idx;		/* pinned MBX for Phase 2 */
+};
+
+/*
+ * set_secret: NIST curves decode kpp_secret + u16 key_size + raw scalar.
+ * Curve25519 uses raw 32-byte scalar directly.
+ */
+static int cmh_ecdh_set_secret_nist(struct crypto_kpp *tfm,
+				    const void *buf, unsigned int len)
+{
+	struct cmh_ecdh_tfm_ctx *ctx = cmh_ecdh_ctx(tfm);
+	const u8 *ptr = buf;
+	struct kpp_secret secret;
+	unsigned short key_size;
+	int ret;
+
+	if (!buf || len < ECDH_KPP_SECRET_MIN_SIZE)
+		return -EINVAL;
+
+	memcpy(&secret, ptr, sizeof(secret));
+	ptr += sizeof(secret);
+
+	if (secret.type != CRYPTO_KPP_SECRET_TYPE_ECDH)
+		return -EINVAL;
+	if (len < secret.len)
+		return -EINVAL;
+
+	memcpy(&key_size, ptr, sizeof(key_size));
+	ptr += sizeof(key_size);
+
+	if (key_size == 0) {
+		/*
+		 * key_size == 0: generate a validated random private key.
+		 * Uses the kernel ECC library (FIPS 186-5 A.2.2) to ensure
+		 * the scalar is in the valid range [2, n-3] for the curve.
+		 */
+		u64 priv[ECC_MAX_DIGITS];
+		unsigned int ndigits = ctx->clen / sizeof(u64);
+		unsigned int curve_id;
+		u8 *rnd;
+
+		if (secret.len != ECDH_KPP_SECRET_MIN_SIZE)
+			return -EINVAL;
+		if (ndigits > ECC_MAX_DIGITS)
+			return -EINVAL;
+		/* Reject non-limb-aligned clen to prevent ndigits truncation */
+		if (ctx->clen % sizeof(u64))
+			return -EINVAL;
+
+		if (ctx->curve == PKE_CURVE_P256)
+			curve_id = ECC_CURVE_NIST_P256;
+		else if (ctx->curve == PKE_CURVE_P384)
+			curve_id = ECC_CURVE_NIST_P384;
+		else
+			return -EINVAL;
+
+		ret = ecc_gen_privkey(curve_id, ndigits, priv);
+		if (ret) {
+			memzero_explicit(priv, sizeof(priv));
+			return ret;
+		}
+
+		rnd = kmalloc(ctx->clen, GFP_KERNEL);
+		if (!rnd) {
+			memzero_explicit(priv, sizeof(priv));
+			return -ENOMEM;
+		}
+
+		/* Convert VLI (native LE-digit-order) to big-endian bytes */
+		ecc_swap_digits(priv, (u64 *)rnd, ndigits);
+		memzero_explicit(priv, sizeof(priv));
+
+		ret = cmh_key_setkey_raw(&ctx->key, rnd, ctx->clen,
+					 CORE_ID_PKE);
+		kfree_sensitive(rnd);
+		return ret;
+	}
+
+	if (key_size != ctx->clen)
+		return -EINVAL;
+
+	if (secret.len != ECDH_KPP_SECRET_MIN_SIZE + key_size)
+		return -EINVAL;
+
+	return cmh_key_setkey_raw(&ctx->key, ptr, key_size, CORE_ID_PKE);
+}
+
+static int cmh_ecdh_set_secret_x25519(struct crypto_kpp *tfm,
+				      const void *buf, unsigned int len)
+{
+	struct cmh_ecdh_tfm_ctx *ctx = cmh_ecdh_ctx(tfm);
+
+	if (len != pke_curve_clen(PKE_CURVE_25519))
+		return -EINVAL;
+
+	return cmh_key_setkey_raw(&ctx->key, buf, len, CORE_ID_PKE);
+}
+
+static void cmh_ecdh_keygen_complete(void *data, int error)
+{
+	struct kpp_request *req = data;
+	struct cmh_ecdh_reqctx *rctx = kpp_request_ctx(req);
+
+	if (error == -EINPROGRESS) {
+		cmh_complete(&req->base, error);
+		return;
+	}
+
+	if (!cmh_dma_map_error(rctx->pk_dma))
+		cmh_dma_unmap_single(rctx->pk_dma, rctx->out_len,
+				     DMA_FROM_DEVICE);
+
+	if (!error) {
+		int nents;
+
+		nents = sg_nents_for_len(req->dst, rctx->out_len);
+		if (nents < 0 ||
+		    sg_copy_from_buffer(req->dst, nents,
+					rctx->pk_buf,
+					rctx->out_len) != rctx->out_len)
+			error = -EINVAL;
+		else
+			req->dst_len = rctx->out_len;
+	}
+
+	kfree(rctx->pk_buf);
+	rctx->pk_buf = NULL;
+	cmh_complete(&req->base, error);
+}
+
+/*
+ * generate_public_key: For NIST ECDH, use ECDH_KEYGEN which outputs
+ * the public key X-coordinate.  But the kernel kpp interface expects
+ * uncompressed X||Y, so we use ECDSA_PUBGEN which gives us (X,Y).
+ * For Curve25519, ECDH_KEYGEN gives us the Montgomery u-coordinate
+ * which is the full public key.
+ */
+static int cmh_ecdh_generate_public_key(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct cmh_ecdh_tfm_ctx *ctx = cmh_ecdh_ctx(tfm);
+	struct cmh_ecdh_reqctx *rctx = kpp_request_ctx(req);
+	u32 clen = ctx->clen;
+	bool is_25519 = (ctx->curve == PKE_CURVE_25519);
+	u32 out_len = is_25519 ? clen : 2 * clen;
+	struct vcq_cmd vcq[PKE_VCQ_CMDS_MAX];
+	struct core_dispatch dd;
+	u32 swap, dma_swap;
+	int ret, idx;
+	gfp_t gfp;
+
+	if (ctx->key.mode != CMH_KEY_RAW)
+		return -EINVAL;
+	if (req->dst_len < out_len)
+		return -EINVAL;
+
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+	      GFP_KERNEL : GFP_ATOMIC;
+
+	memset(rctx, 0, sizeof(*rctx));
+	rctx->out_len = out_len;
+	rctx->pk_dma = DMA_MAPPING_ERROR;
+
+	rctx->pk_buf = kzalloc(out_len, gfp);
+	if (!rctx->pk_buf)
+		return -ENOMEM;
+
+	rctx->pk_dma = cmh_dma_map_single(rctx->pk_buf, out_len,
+					  DMA_FROM_DEVICE);
+	if (cmh_dma_map_error(rctx->pk_dma)) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	/*
+	 * The SYS_REF_TEMP key write uses per-curve dma_swap (0 for the
+	 * little-endian Curve25519 secret), but the PKE compute command
+	 * itself takes PKE_SWAP_FLAGS for every curve: the HW emits the
+	 * public-key / shared-secret coordinate in the order PKE_SWAP_FLAGS
+	 * maps to the expected encoding (the mgmt ECDH keygen does the same
+	 * and matches RFC 7748).  Do NOT switch the command to dma_swap.
+	 */
+	swap = PKE_SWAP_FLAGS;
+	dma_swap = pke_swap_flags(ctx->curve);
+
+	dd = cmh_core_select_instance(CMH_CORE_PKE);
+
+	vcq_set_header(&vcq[0], PKE_VCQ_CMDS_MAX);
+	idx = 1;
+	vcq_add_sys_write(&vcq[idx], SYS_REF_TEMP, ctx->key.raw.dma,
+			  SYS_REF_NONE, ctx->key.raw.len,
+			  ctx->key.raw.sys_type);
+	vcq[idx].id |= dma_swap;
+	idx++;
+	if (is_25519)
+		vcq_add_pke_ecdh_keygen(&vcq[idx++], dd.core_id, ctx->curve,
+					clen, rctx->pk_dma, SYS_REF_TEMP,
+					swap);
+	else
+		vcq_add_pke_ecdsa_pubgen(&vcq[idx++], dd.core_id,
+					 ctx->curve, clen, rctx->pk_dma,
+					 SYS_REF_TEMP, swap);
+	vcq_add_pke_flush(&vcq[idx++], dd.core_id);
+
+	ret = cmh_tm_submit_async(vcq, PKE_VCQ_CMDS_MAX, 1, dd.mbx_idx,
+				  cmh_ecdh_keygen_complete, req,
+				  !!(req->base.flags &
+				     CRYPTO_TFM_REQ_MAY_BACKLOG), 0);
+	if (ret == -EBUSY)
+		return -EBUSY;
+	if (!ret)
+		return -EINPROGRESS;
+
+	if (!cmh_dma_map_error(rctx->pk_dma))
+		cmh_dma_unmap_single(rctx->pk_dma, out_len,
+				     DMA_FROM_DEVICE);
+
+out_free:
+	kfree(rctx->pk_buf);
+	return ret;
+}
+
+static void cmh_ecdh_ss_phase2_complete(void *data, int error)
+{
+	struct kpp_request *req = data;
+	struct cmh_ecdh_reqctx *rctx = kpp_request_ctx(req);
+
+	if (error == -EINPROGRESS) {
+		cmh_complete(&req->base, error);
+		return;
+	}
+
+	if (!cmh_dma_map_error(rctx->ss_dma))
+		cmh_dma_unmap_single(rctx->ss_dma, rctx->clen,
+				     DMA_FROM_DEVICE);
+
+	if (!error) {
+		int nents;
+
+		nents = sg_nents_for_len(req->dst, rctx->clen);
+		if (nents < 0 ||
+		    sg_copy_from_buffer(req->dst, nents,
+					rctx->ss_buf,
+					rctx->clen) != rctx->clen)
+			error = -EINVAL;
+		else
+			req->dst_len = rctx->clen;
+	}
+
+	kfree(rctx->ref_buf);
+	rctx->ref_buf = NULL;
+	kfree_sensitive(rctx->ss_buf);
+	rctx->ss_buf = NULL;
+	cmh_complete(&req->base, error);
+}
+
+static void cmh_ecdh_ss_phase1_complete(void *data, int error)
+{
+	struct kpp_request *req = data;
+	struct cmh_ecdh_reqctx *rctx = kpp_request_ctx(req);
+	struct vcq_cmd vcq[3];
+	int ret;
+
+	if (error == -EINPROGRESS) {
+		cmh_complete(&req->base, error);
+		return;
+	}
+
+	/* Phase 1-only resource: peer -- always clean up */
+	if (!cmh_dma_map_error(rctx->peer_dma))
+		cmh_dma_unmap_single(rctx->peer_dma, rctx->peer_len,
+				     DMA_TO_DEVICE);
+	kfree(rctx->peer_buf);
+	rctx->peer_buf = NULL;
+
+	if (error)
+		goto out_cleanup;
+
+	/* Read the DS reference written by Phase 1 */
+	cmh_dma_sync_for_cpu(rctx->ref_dma, sizeof(u64), DMA_FROM_DEVICE);
+	cmh_dma_unmap_single(rctx->ref_dma, sizeof(u64), DMA_FROM_DEVICE);
+	rctx->ref_dma = DMA_MAPPING_ERROR;
+
+	/* Phase 2: extract shared secret from DS */
+	vcq_set_header(&vcq[0], 3);
+	vcq_add_sys_data(&vcq[1], *rctx->ref_buf, rctx->ss_dma,
+			 rctx->clen);
+	vcq[1].id |= rctx->dma_swap;
+	vcq_add_sys_flush(&vcq[2]);
+
+	ret = cmh_tm_submit_async(vcq, 3, 1, rctx->mbx_idx,
+				  cmh_ecdh_ss_phase2_complete, req,
+				  true, 0);
+	if (ret == -EBUSY || !ret)
+		return;
+
+	error = ret;
+
+out_cleanup:
+	if (!cmh_dma_map_error(rctx->ref_dma))
+		cmh_dma_unmap_single(rctx->ref_dma, sizeof(u64),
+				     DMA_FROM_DEVICE);
+	if (!cmh_dma_map_error(rctx->ss_dma))
+		cmh_dma_unmap_single(rctx->ss_dma, rctx->clen,
+				     DMA_FROM_DEVICE);
+	kfree(rctx->ref_buf);
+	rctx->ref_buf = NULL;
+	kfree_sensitive(rctx->ss_buf);
+	rctx->ss_buf = NULL;
+	cmh_complete(&req->base, error);
+}
+
+/*
+ * compute_shared_secret: PKE_CMD_ECDH.
+ *
+ * req->src = peer public key (X||Y for NIST, raw 32B for Curve25519).
+ * Output = shared secret X coordinate (clen bytes).
+ *
+ * The CMH ECDH command stores the shared secret in a DS object,
+ * not directly to DMA.  We create a DS slot with SYS_CMD_NEW,
+ * reference it via SYS_REF_LAST, then extract the result with a
+ * second VCQ submission using SYS_CMD_DATA with the actual ref.
+ */
+static int cmh_ecdh_compute_shared_secret(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct cmh_ecdh_tfm_ctx *ctx = cmh_ecdh_ctx(tfm);
+	struct cmh_ecdh_reqctx *rctx = kpp_request_ctx(req);
+	u32 clen = ctx->clen;
+	bool is_25519 = (ctx->curve == PKE_CURVE_25519);
+	u32 peer_len = is_25519 ? clen : 2 * clen;
+	u32 ss_type = SYS_TYPE_SET(SYS_TYPE_FLAG_PT, CORE_ID_PKE);
+	struct vcq_cmd vcq[5];
+	struct core_dispatch dd;
+	u32 swap, dma_swap;
+	int ret, idx, nents;
+	gfp_t gfp;
+
+	if (ctx->key.mode != CMH_KEY_RAW)
+		return -EINVAL;
+	if (req->src_len < peer_len || req->dst_len < clen)
+		return -EINVAL;
+
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+	      GFP_KERNEL : GFP_ATOMIC;
+
+	memset(rctx, 0, sizeof(*rctx));
+	rctx->clen = clen;
+	rctx->peer_len = peer_len;
+	rctx->pk_dma = DMA_MAPPING_ERROR;
+	rctx->peer_dma = DMA_MAPPING_ERROR;
+	rctx->ss_dma = DMA_MAPPING_ERROR;
+	rctx->ref_dma = DMA_MAPPING_ERROR;
+
+	rctx->peer_buf = kmalloc(peer_len, gfp);
+	rctx->ss_buf = kzalloc(clen, gfp);
+	rctx->ref_buf = kzalloc_obj(u64, gfp);
+	if (!rctx->peer_buf || !rctx->ss_buf || !rctx->ref_buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	nents = sg_nents_for_len(req->src, peer_len);
+	if (nents < 0 ||
+	    sg_pcopy_to_buffer(req->src, nents, rctx->peer_buf,
+			       peer_len, 0) != peer_len) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	rctx->peer_dma = cmh_dma_map_single(rctx->peer_buf, peer_len,
+					    DMA_TO_DEVICE);
+	rctx->ss_dma = cmh_dma_map_single(rctx->ss_buf, clen,
+					  DMA_FROM_DEVICE);
+	rctx->ref_dma = cmh_dma_map_single(rctx->ref_buf, sizeof(u64),
+					   DMA_FROM_DEVICE);
+
+	if (cmh_dma_map_error(rctx->peer_dma) ||
+	    cmh_dma_map_error(rctx->ss_dma) ||
+	    cmh_dma_map_error(rctx->ref_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	/*
+	 * The SYS_REF_TEMP key write uses per-curve dma_swap (0 for the
+	 * little-endian Curve25519 secret), but the PKE compute command
+	 * itself takes PKE_SWAP_FLAGS for every curve: the HW emits the
+	 * public-key / shared-secret coordinate in the order PKE_SWAP_FLAGS
+	 * maps to the expected encoding (the mgmt ECDH keygen does the same
+	 * and matches RFC 7748).  Do NOT switch the command to dma_swap.
+	 */
+	swap = PKE_SWAP_FLAGS;
+	dma_swap = pke_swap_flags(ctx->curve);
+	rctx->dma_swap = dma_swap;
+
+	dd = cmh_core_select_instance(CMH_CORE_PKE);
+	rctx->mbx_idx = dd.mbx_idx;
+
+	vcq_set_header(&vcq[0], 5);
+	idx = 1;
+	vcq_add_sys_write(&vcq[idx], SYS_REF_TEMP, ctx->key.raw.dma,
+			  SYS_REF_NONE, ctx->key.raw.len,
+			  ctx->key.raw.sys_type);
+	vcq[idx].id |= dma_swap;
+	idx++;
+	vcq_add_sys_new(&vcq[idx++], 0, rctx->ref_dma, clen);
+	vcq_add_pke_ecdh(&vcq[idx++], dd.core_id, ctx->curve, clen,
+			 clen, ss_type, rctx->peer_dma,
+			 SYS_REF_TEMP, SYS_REF_LAST, swap);
+	vcq_add_pke_flush(&vcq[idx++], dd.core_id);
+
+	ret = cmh_tm_submit_async(vcq, 5, 1, dd.mbx_idx,
+				  cmh_ecdh_ss_phase1_complete, req,
+				  !!(req->base.flags &
+				     CRYPTO_TFM_REQ_MAY_BACKLOG), 0);
+	if (ret == -EBUSY)
+		return -EBUSY;
+	if (!ret)
+		return -EINPROGRESS;
+
+out_unmap:
+	if (!cmh_dma_map_error(rctx->ss_dma))
+		cmh_dma_unmap_single(rctx->ss_dma, clen,
+				     DMA_FROM_DEVICE);
+	if (!cmh_dma_map_error(rctx->ref_dma))
+		cmh_dma_unmap_single(rctx->ref_dma, sizeof(u64),
+				     DMA_FROM_DEVICE);
+	if (!cmh_dma_map_error(rctx->peer_dma))
+		cmh_dma_unmap_single(rctx->peer_dma, peer_len,
+				     DMA_TO_DEVICE);
+
+out_free:
+	kfree(rctx->ref_buf);
+	kfree_sensitive(rctx->ss_buf);
+	kfree(rctx->peer_buf);
+	return ret;
+}
+
+static unsigned int cmh_ecdh_max_size(struct crypto_kpp *tfm)
+{
+	struct cmh_ecdh_tfm_ctx *ctx = cmh_ecdh_ctx(tfm);
+
+	/* Max output = X||Y for generate_public_key (NIST) */
+	return 2 * ctx->clen;
+}
+
+static unsigned int cmh_x25519_max_size(struct crypto_kpp *tfm)
+{
+	return pke_curve_clen(PKE_CURVE_25519); /* single coordinate */
+}
+
+static int cmh_ecdh_p256_init(struct crypto_kpp *tfm)
+{
+	struct cmh_ecdh_tfm_ctx *ctx = cmh_ecdh_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->curve = PKE_CURVE_P256;
+	ctx->clen = pke_curve_clen(PKE_CURVE_P256);
+	tfm->reqsize = sizeof(struct cmh_ecdh_reqctx);
+	return 0;
+}
+
+static int cmh_ecdh_p384_init(struct crypto_kpp *tfm)
+{
+	struct cmh_ecdh_tfm_ctx *ctx = cmh_ecdh_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->curve = PKE_CURVE_P384;
+	ctx->clen = pke_curve_clen(PKE_CURVE_P384);
+	tfm->reqsize = sizeof(struct cmh_ecdh_reqctx);
+	return 0;
+}
+
+static int cmh_x25519_init(struct crypto_kpp *tfm)
+{
+	struct cmh_ecdh_tfm_ctx *ctx = cmh_ecdh_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->curve = PKE_CURVE_25519;
+	ctx->clen = pke_curve_clen(PKE_CURVE_25519);
+	tfm->reqsize = sizeof(struct cmh_ecdh_reqctx);
+	return 0;
+}
+
+static void cmh_ecdh_exit(struct crypto_kpp *tfm)
+{
+	struct cmh_ecdh_tfm_ctx *ctx = cmh_ecdh_ctx(tfm);
+
+	cmh_key_destroy(&ctx->key);
+}
+
+static struct kpp_alg cmh_ecdh_algs[] = {
+	{
+		.set_secret		= cmh_ecdh_set_secret_nist,
+		.generate_public_key	= cmh_ecdh_generate_public_key,
+		.compute_shared_secret	= cmh_ecdh_compute_shared_secret,
+		.max_size		= cmh_ecdh_max_size,
+		.init			= cmh_ecdh_p256_init,
+		.exit			= cmh_ecdh_exit,
+		.base = {
+			.cra_name	  = "ecdh-nist-p256",
+			.cra_driver_name  = "rambus-cmh-ecdh-nist-p256",
+			.cra_priority	  = 300,
+			.cra_flags	  = CRYPTO_ALG_ASYNC,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_ecdh_tfm_ctx),
+		},
+	},
+	{
+		.set_secret		= cmh_ecdh_set_secret_nist,
+		.generate_public_key	= cmh_ecdh_generate_public_key,
+		.compute_shared_secret	= cmh_ecdh_compute_shared_secret,
+		.max_size		= cmh_ecdh_max_size,
+		.init			= cmh_ecdh_p384_init,
+		.exit			= cmh_ecdh_exit,
+		.base = {
+			.cra_name	  = "ecdh-nist-p384",
+			.cra_driver_name  = "rambus-cmh-ecdh-nist-p384",
+			.cra_priority	  = 300,
+			.cra_flags	  = CRYPTO_ALG_ASYNC,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_ecdh_tfm_ctx),
+		},
+	},
+	{
+		.set_secret		= cmh_ecdh_set_secret_x25519,
+		.generate_public_key	= cmh_ecdh_generate_public_key,
+		.compute_shared_secret	= cmh_ecdh_compute_shared_secret,
+		.max_size		= cmh_x25519_max_size,
+		.init			= cmh_x25519_init,
+		.exit			= cmh_ecdh_exit,
+		.base = {
+			.cra_name	  = "curve25519",
+			.cra_driver_name  = "rambus-cmh-curve25519",
+			.cra_priority	  = 300,
+			.cra_flags	  = CRYPTO_ALG_ASYNC,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_ecdh_tfm_ctx),
+		},
+	},
+};
+
+/**
+ * cmh_pke_ecdh_register() - Register ECDH kpp algorithms with the crypto framework
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_pke_ecdh_register(void)
+{
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(cmh_ecdh_algs); i++) {
+		ret = crypto_register_kpp(&cmh_ecdh_algs[i]);
+		if (ret) {
+			dev_err(cmh_dev(), "cmh: failed to register %s (%d)\n",
+				cmh_ecdh_algs[i].base.cra_name, ret);
+			goto err_unregister;
+		}
+	}
+
+	return 0;
+
+err_unregister:
+	while (i--)
+		crypto_unregister_kpp(&cmh_ecdh_algs[i]);
+	return ret;
+}
+
+/**
+ * cmh_pke_ecdh_unregister() - Unregister ECDH kpp algorithms from the crypto framework
+ */
+void cmh_pke_ecdh_unregister(void)
+{
+	int i = ARRAY_SIZE(cmh_ecdh_algs);
+
+	while (i--)
+		crypto_unregister_kpp(&cmh_ecdh_algs[i]);
+}
-- 
2.43.7

