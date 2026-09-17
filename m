Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022107.outbound.protection.outlook.com [52.101.43.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36304B0E49;
	Thu, 17 Sep 2026 22:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789685987; cv=fail; b=SndzG10/yxUtl6YWIIAmhnwoKYfd9X7ZUlID+sNWsobacol0Q1WSOSztlMXP15Pl6H/B4LIKPEXs6c+EK3yLF3b/3LlInbSbFkbAK+2k9g0YqBtDbDu1nRu40rPFj3QIR0OTCULgsTJr0y79zqkS086duNVjUqtb76Db0iFGKLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789685987; c=relaxed/simple;
	bh=pq9qDZb1y7iUwkrb8udABt2TRDiarngJsZtOyamc3T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KaMZHrghDPosqG0t2Q07gEehUFypJjNZA6kKiP5x+eTYbFS+sOIDwvRLAcZsg/U55qxKdOkOtz2YCA2bz5ft5O9IrqzEa2a7UHbr9BGeoMH4VjT907FrbI0aJRxPdjC9ak8fcAAXQcv9E3cdZTYhamOQTIMNYZi1ueIop1LI7BQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=yjKVZfvj; arc=fail smtp.client-ip=52.101.43.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="yjKVZfvj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S6okVh1VBv/L9SWHLVM7TYh3JFE0LrRCQPkF5TDiwCigjd0OXwTDj9eqehuWc9qtH8lzeTdRy8Th3qwiy47BY6MSulWeFfDjZx35inNUZrwEBENBMomcvNv30RCD8fwzmxaOTAMIDseNecdQnFFbuYOeImqIt7UInTHQLwBZgtIYUEkGIxQ5L1Qz4yZAdIDPP/cFx1LD8X1l4ZW4Bc2pMOWemnBmI2ADTkBaXOius/MGLqZhnR2RKeJkiHHuaL6RZTMEmKBK+0HWSGCNi6hc22DsCb9ceXwD90RqpK9Z9ekwzal41nnjs7cy2Mpw5UDzKlA4l0bdhqWlQbZCAbW5OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x67nJblAhtktgljYbUc3Jl9/SnurDy8yuIGdUCdZl5M=;
 b=u4VGeqZaiHK8Dm3PPNnzl5Zgdv5jJGYcb1qF4jyGij68FnuOAF4xqnX6d5v8A3z68TKGvwH/Sgkl/ivwh3N7BntWHzYGWImYeBWw+MmgE7ZnmYXzZlKngfKi3wVTV9phWdfzE7CsL3j+LdH4sr5xe0xF5lQt958gR/CFfux0zfcJ8IKREc/jayMiiBpAe/Ocov/tMJ9wGzi1BBsoFdy3KudKV2+2ZUD0UQrReRMkYCMlqV8ycB0VWBafWABpVYWoG7b2lqmEbCEZYEv5oXaWzG18dXEdkSnSdBx+TI7o/7NB1s6Vadf0u8b+Tp0IlqF4Yj6OZNtBSYNm9W0GzUYEyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x67nJblAhtktgljYbUc3Jl9/SnurDy8yuIGdUCdZl5M=;
 b=yjKVZfvje4iQf5En3EMbHMnojXNbPV0sYYgSvM5ZdQSNu4IktcV4FRkPD+rDpRzSDiecdt++4qKrgm0K3x5oiuCM+weds/zZkao1CRNElLUu7M7x3WUddc2KNJ5K/gooG0qnpIWmJvVAphizkPAbGaPD2/5HXVUKBfDKZxnWxgX/d30zIRbobumuQvpk90aZ/knDX9WfUt0JqzXupP52sWMwlpwHTpw/mD1czrrB9a9Rz50oglrTJhEfhVEmaqrS7dw5hyI8vpyKsoiOAFXoFw3A3P8vGQ5Do/9gsQVXKHi2KQhFp8W9NXrQNsHghD2U39tdqwx7cM+BX9ujjJJb1Q==
Received: from BN0PR10CA0029.namprd10.prod.outlook.com (2603:10b6:408:143::7)
 by PH0PR04MB8293.namprd04.prod.outlook.com (2603:10b6:510:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 22:59:35 +0000
Received: from BN2PEPF0000A800.namprd02.prod.outlook.com
 (2603:10b6:408:143:cafe::81) by BN0PR10CA0029.outlook.office365.com
 (2603:10b6:408:143::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 22:59:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BN2PEPF0000A800.mail.protection.outlook.com (10.167.245.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Thu, 17 Sep 2026 22:59:34 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id 6E658180176C;
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
Subject: [PATCH v5 14/19] crypto: cmh - add ECDH/X25519 kpp
Date: Thu, 17 Sep 2026 15:59:23 -0700
Message-ID: <20260917225929.2494111-15-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A800:EE_|PH0PR04MB8293:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 132b42bc-18de-4378-2902-08df150f57b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|7416014|376014|36860700016|10067099003|6133799003|3023799007|22082099003|18002099003|5023799004|56012099006|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	HHAZ55Z4ZUi2UWJGbRuj5ctfGihZ239LFvmyarPcBsxW3QohBbLsuycHJ2GWZgJDTFpwnAeqiLLyybiI+al6+2CrfLu5k6c29dB/JfMCNuFKxe/F+lF5g88POmGMh0akwkZC0X8itgreJlfKrGy38rWWoRMyl9hgfKHARsr/iImiuvm+Ql8Y0hnmWukfDyWNoB1fPxGoZaWCTPpJTMwgEeOg4DqXITJm8jdKxUH8sxEvLTD5lAFMCnq3846QPyigmtvXrb0qxHB9QDU7XJ1o72yBJ4rdjiw0K0Ho9JVpVUcSYgU65d4ExKV+14kf9dxwRLV/L1cD/cuGhE9gpYypqvanullXDFIoBwPe8NTTU3WlGAPlgzZYn+RRfby73Ww609BdNsp38KERC4r/86tm3CZkK+7anSzi7FpqXLc1NwfP3XvmM0hwvFfeROsKhvAujkMcYFHAqNCg9++MBukxHiggpOwMseqt2rH28eauL2MJKP6TaVLP8d1iFjF8SZWPzuTzD2q1KJj8qmj86QgKx2d7X7U5QgmByO5kHBir7LRKzGfqyIuiu6me5/CwPjpfo8bBK550osy9C+u6DhdPuA5hFkEEyfUUSDlw9CCZ9EUg8cHPnZzVK3uC+ih0X+gBUbY6hQ0imh8TuWwnNrqJrCA3XV/qc4zc2PIODGvfF2QDxFmA+5bFQDUWb0jhPoKACzT60BjoQkeXLX/AlesVN2Xuako2J9/0klX/MqTg9wEhaHiQI7VMWa/P/OB0Fk2G
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(7416014)(376014)(36860700016)(10067099003)(6133799003)(3023799007)(22082099003)(18002099003)(5023799004)(56012099006)(11063799006)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9IM5FyIlSKVVRqpjsctPDAGgIJsgDgW4VoBqM6LWDZTyuL9C1yvoXPsub00evOSulz3exjPp+T7NohFXh2Yyq5VznOd5Rfk0IBotJSVvrR8A3UcMIwFFCjDE2J7S27aqXbk7axvXkm4cy16McQKXpsah/etfC2DJ9AYAUp/SCUdfzRpkDBRhu5I8cz2ktjA7nt9i0BKpDUIQUQVrbRSNxul6s2JNxeyytcVY1sKDkVr2/bgf+/iLE0UwOOt49gSL8K/O4GZb1WK1PNh5W9aZqVm8n5u/fLGu2WVtfaIY5fV5mqu7gc66IjQbiiLIAUdh+Xts2pEatze1x3FXmKbVeBnipK9FEt1Oyif2xTIfXijBer5JAWS+FgDm0nOfDnHm3UfBb/0iqAURXsYbvZEkRX3nzA4NfTSWICyTr55oSJtDy+niRyuzfJtaqmj/umY0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 22:59:34.7700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 132b42bc-18de-4378-2902-08df150f57b4
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A800.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8293

Register ECDH and X25519 kpp algorithms using the CMH PKE core.
Supports P-256, P-384, and Curve25519 for key agreement.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 drivers/crypto/cmh/Makefile       |   3 +-
 drivers/crypto/cmh/cmh_main.c     |   8 +
 drivers/crypto/cmh/cmh_pke_ecdh.c | 817 ++++++++++++++++++++++++++++++
 3 files changed, 827 insertions(+), 1 deletion(-)
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
index b5b12f56a68e..93d939e8fc4e 100644
--- a/drivers/crypto/cmh/cmh_main.c
+++ b/drivers/crypto/cmh/cmh_main.c
@@ -297,6 +297,11 @@ static int cmh_probe(struct platform_device *pdev)
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
@@ -307,6 +312,8 @@ static int cmh_probe(struct platform_device *pdev)
 	return 0;
 
 err_mgmt_register:
+	cmh_pke_ecdh_unregister();
+err_pke_ecdh_register:
 	cmh_pke_ecdsa_unregister();
 err_pke_ecdsa_register:
 	cmh_pke_rsa_unregister();
@@ -367,6 +374,7 @@ static void cmh_remove(struct platform_device *pdev)
 	cfg = &dev->config;
 
 	cmh_mgmt_unregister();
+	cmh_pke_ecdh_unregister();
 	cmh_pke_ecdsa_unregister();
 	cmh_pke_rsa_unregister();
 	cmh_ccp_poly_unregister();
diff --git a/drivers/crypto/cmh/cmh_pke_ecdh.c b/drivers/crypto/cmh/cmh_pke_ecdh.c
new file mode 100644
index 000000000000..56c0f2629c6b
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pke_ecdh.c
@@ -0,0 +1,817 @@
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
+#include <linux/mutex.h>
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
+ * generate_public_key and compute_shared_secret are both single-phase
+ * async VCQs.  compute_shared_secret writes the private key into a
+ * per-mailbox scratch datastore object and targets SYS_REF_TEMP for the
+ * shared secret (see cmh_ecdh_key_scratch below).
+ *
+ * Both operations reference the transform's persistent private-key DMA
+ * buffer (ctx->key.raw.dma) directly in their VCQ, and that buffer is
+ * mapped for the lifetime of the transform (set_secret) and freed only by
+ * a re-key or cmh_key_destroy().  This is safe because the crypto KPP API
+ * serialises operations on a single transform: a caller must not re-key
+ * (set_secret) while a request is in flight, and async callers wait for
+ * the request completion before issuing the next operation.  There is
+ * therefore no window in which an in-flight VCQ can reference a key buffer
+ * that a concurrent set_secret has freed.
+ */
+struct cmh_ecdh_reqctx {
+	/* Buffers */
+	u8 *pk_buf;		/* keygen: output public key */
+	u8 *peer_buf;		/* compute: peer public key */
+	u8 *ss_buf;		/* compute: shared secret output */
+	/* DMA handles */
+	dma_addr_t pk_dma;
+	dma_addr_t peer_dma;
+	dma_addr_t ss_dma;
+	/* Sizes and params */
+	u32 out_len;		/* keygen: public key size */
+	u32 clen;
+	u32 peer_len;
+};
+
+/*
+ * Per-mailbox scratch datastore object holding the private key for
+ * compute_shared_secret.
+ *
+ * The CMH ECDH command writes its shared secret into a datastore object,
+ * not directly to host DMA.  Allocating that object per request via
+ * SYS_CMD_NEW permanently consumes a slot every call, because the eSW
+ * datastore is a bump allocator with no per-object free.
+ *
+ * Instead we sys_write the private key into a persistent per-mailbox
+ * object (owned by that mailbox) and target SYS_REF_TEMP for the shared
+ * secret, which the eSW reclaims when sys_data reads it back.  One object
+ * per mailbox preserves the round-robin PKE dispatch; the eSW runs a VCQ
+ * and its children to completion per mailbox, so concurrent requests on
+ * the same mailbox never observe each other's key in the shared object.
+ *
+ * Created on the first key set (deferred from register) and scrubbed at
+ * unregister, so a bring-up that never keys ECDH leaves the datastore
+ * empty for a DS import.  Indexed by mbx_idx; entries for mailboxes
+ * without a PKE instance stay zero.
+ */
+static u64 *cmh_ecdh_key_scratch;
+static u32 cmh_ecdh_scratch_count;
+static bool cmh_ecdh_scratch_ready;		/* DS objects created (one-shot) */
+static DEFINE_MUTEX(cmh_ecdh_scratch_lock);
+
+static int cmh_ecdh_scratch_ensure(void);
+
+/*
+ * cmh_ecdh_commit_key() - Ensure the key scratch exists, then stash the raw
+ * private key.  Deferring scratch creation to the first key set keeps the
+ * datastore empty until ECDH is actually used.
+ */
+static int cmh_ecdh_commit_key(struct cmh_ecdh_tfm_ctx *ctx,
+			       const u8 *key, u32 len)
+{
+	int ret = cmh_ecdh_scratch_ensure();
+
+	if (ret)
+		return ret;
+	return cmh_key_setkey_raw(&ctx->key, key, len, CORE_ID_PKE);
+}
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
+		ret = cmh_ecdh_commit_key(ctx, rnd, ctx->clen);
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
+	/*
+	 * Validate the raw NIST scalar is in range for the curve, matching the
+	 * key_size==0 path (which uses ecc_gen_privkey).  Rejects degenerate /
+	 * out-of-range keys the HW might otherwise accept.
+	 */
+	{
+		u64 priv[ECC_MAX_DIGITS];
+		unsigned int ndigits = ctx->clen / sizeof(u64);
+		unsigned int curve_id;
+
+		if (ctx->clen % sizeof(u64) || ndigits > ECC_MAX_DIGITS)
+			return -EINVAL;
+		if (ctx->curve == PKE_CURVE_P256)
+			curve_id = ECC_CURVE_NIST_P256;
+		else if (ctx->curve == PKE_CURVE_P384)
+			curve_id = ECC_CURVE_NIST_P384;
+		else
+			return -EINVAL;
+
+		ecc_digits_from_bytes(ptr, key_size, priv, ndigits);
+		ret = ecc_is_key_valid(curve_id, ndigits, priv, key_size);
+		memzero_explicit(priv, sizeof(priv));
+		if (ret)
+			return ret;
+	}
+
+	return cmh_ecdh_commit_key(ctx, ptr, key_size);
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
+	return cmh_ecdh_commit_key(ctx, buf, len);
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
+static void cmh_ecdh_ss_complete(void *data, int error)
+{
+	struct kpp_request *req = data;
+	struct cmh_ecdh_reqctx *rctx = kpp_request_ctx(req);
+
+	if (error == -EINPROGRESS) {
+		cmh_complete(&req->base, error);
+		return;
+	}
+
+	if (!cmh_dma_map_error(rctx->peer_dma))
+		cmh_dma_unmap_single(rctx->peer_dma, rctx->peer_len,
+				     DMA_TO_DEVICE);
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
+	kfree(rctx->peer_buf);
+	rctx->peer_buf = NULL;
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
+ * The CMH ECDH command stores the shared secret in a datastore object.
+ * We write the private key into the per-mailbox scratch object, run the
+ * ECDH with the shared secret targeting SYS_REF_TEMP, and read it back
+ * with SYS_CMD_DATA in the same VCQ -- the eSW reclaims the temp store on
+ * read, so no datastore slot leaks per request.
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
+	struct vcq_cmd vcq[6];
+	struct core_dispatch dd;
+	u64 key_ref;
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
+
+	rctx->peer_buf = kmalloc(peer_len, gfp);
+	rctx->ss_buf = kzalloc(clen, gfp);
+	if (!rctx->peer_buf || !rctx->ss_buf) {
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
+
+	if (cmh_dma_map_error(rctx->peer_dma) ||
+	    cmh_dma_map_error(rctx->ss_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	dd = cmh_core_select_instance(CMH_CORE_PKE);
+	if (dd.mbx_idx < 0 || (u32)dd.mbx_idx >= cmh_ecdh_scratch_count ||
+	    !cmh_ecdh_key_scratch[dd.mbx_idx]) {
+		ret = -EIO;
+		goto out_unmap;
+	}
+	key_ref = cmh_ecdh_key_scratch[dd.mbx_idx];
+
+	/*
+	 * The private-key write uses per-curve dma_swap (0 for the
+	 * little-endian Curve25519 secret), but the PKE compute command
+	 * itself takes PKE_SWAP_FLAGS for every curve: the HW emits the
+	 * shared-secret coordinate in the order PKE_SWAP_FLAGS maps to the
+	 * expected encoding (the mgmt ECDH path does the same and matches
+	 * RFC 7748).  Do NOT switch the command to dma_swap.
+	 */
+	swap = PKE_SWAP_FLAGS;
+	dma_swap = pke_swap_flags(ctx->curve);
+
+	vcq_set_header(&vcq[0], 6);
+	idx = 1;
+	vcq_add_sys_write(&vcq[idx], key_ref, ctx->key.raw.dma,
+			  SYS_REF_NONE, ctx->key.raw.len,
+			  ctx->key.raw.sys_type);
+	vcq[idx].id |= dma_swap;
+	idx++;
+	vcq_add_pke_ecdh(&vcq[idx++], dd.core_id, ctx->curve, clen,
+			 clen, ss_type, rctx->peer_dma,
+			 key_ref, SYS_REF_TEMP, swap);
+	vcq_add_pke_flush(&vcq[idx++], dd.core_id);
+	vcq_add_sys_data(&vcq[idx], SYS_REF_TEMP, rctx->ss_dma, clen);
+	vcq[idx].id |= dma_swap;
+	idx++;
+	vcq_add_sys_flush(&vcq[idx++]);
+
+	ret = cmh_tm_submit_async(vcq, 6, 1, dd.mbx_idx,
+				  cmh_ecdh_ss_complete, req,
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
+	if (!cmh_dma_map_error(rctx->peer_dma))
+		cmh_dma_unmap_single(rctx->peer_dma, peer_len,
+				     DMA_TO_DEVICE);
+
+out_free:
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
+/*
+ * cmh_ecdh_scratch_free() - Scrub and release the per-mailbox key scratch
+ *
+ * Best-effort: sys_grant with no access wipes the key bytes and clears the
+ * CID on each object (the datastore stack space is only reclaimed by a full
+ * reset).  The grant runs on the owning mailbox so the eSW access check
+ * passes.
+ */
+static void cmh_ecdh_scratch_free(void)
+{
+	u32 i;
+
+	if (!cmh_ecdh_key_scratch)
+		return;
+
+	for (i = 0; i < cmh_ecdh_scratch_count; i++) {
+		struct vcq_cmd vcq[3];
+
+		if (!cmh_ecdh_key_scratch[i])
+			continue;
+
+		vcq_set_header(&vcq[0], 3);
+		vcq_add_sys_grant(&vcq[1], cmh_ecdh_key_scratch[i], 0, 0, 0);
+		vcq_add_sys_flush(&vcq[2]);
+		cmh_tm_submit_sync_mbx(vcq, 3, 1, (s32)i);
+		cmh_ecdh_key_scratch[i] = 0;
+	}
+
+	kfree(cmh_ecdh_key_scratch);
+	cmh_ecdh_key_scratch = NULL;
+	cmh_ecdh_scratch_count = 0;
+	cmh_ecdh_scratch_ready = false;
+}
+
+/*
+ * cmh_ecdh_scratch_ensure() - Create the per-PKE-mailbox key scratch on the
+ * first keyed use.
+ *
+ * Deferred from register time so that a bring-up which never sets an ECDH
+ * key leaves the datastore empty (a DS import requires an empty store).
+ * Idempotent and safe against concurrent set_secret callers; on failure it
+ * leaves cmh_ecdh_scratch_ready clear and any objects already created in
+ * place, so the next key set retries and skips them.  Runs in process
+ * context (set_secret), so the synchronous submit may sleep.
+ */
+static int cmh_ecdh_scratch_ensure(void)
+{
+	u32 key_len = pke_curve_clen(PKE_CURVE_P384);
+	u32 n_pke = cmh_core_num_instances(CMH_CORE_PKE);
+	u64 *ref_buf;
+	u32 i;
+	int ret = 0;
+
+	mutex_lock(&cmh_ecdh_scratch_lock);
+	if (cmh_ecdh_scratch_ready)
+		goto out;
+
+	ref_buf = kzalloc_obj(u64, GFP_KERNEL);
+	if (!ref_buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < n_pke; i++) {
+		struct core_dispatch d = cmh_core_get_instance(CMH_CORE_PKE, i);
+		struct vcq_cmd vcq[3];
+		dma_addr_t ref_dma;
+
+		if (d.mbx_idx < 0 || (u32)d.mbx_idx >= cmh_ecdh_scratch_count) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+		if (cmh_ecdh_key_scratch[d.mbx_idx])
+			continue;
+
+		*ref_buf = 0;
+		ref_dma = cmh_dma_map_single(ref_buf, sizeof(*ref_buf),
+					     DMA_FROM_DEVICE);
+		if (cmh_dma_map_error(ref_dma)) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+
+		vcq_set_header(&vcq[0], 3);
+		vcq_add_sys_new(&vcq[1], 0, ref_dma, key_len);
+		vcq_add_sys_flush(&vcq[2]);
+		ret = cmh_tm_submit_sync_mbx(vcq, 3, 1, d.mbx_idx);
+		if (!ret) {
+			cmh_dma_sync_for_cpu(ref_dma, sizeof(*ref_buf),
+					     DMA_FROM_DEVICE);
+			cmh_ecdh_key_scratch[d.mbx_idx] = *ref_buf;
+		}
+		cmh_dma_unmap_single(ref_dma, sizeof(*ref_buf),
+				     DMA_FROM_DEVICE);
+		if (ret)
+			goto out_free;
+		if (!cmh_ecdh_key_scratch[d.mbx_idx]) {
+			ret = -EIO;
+			goto out_free;
+		}
+	}
+
+	cmh_ecdh_scratch_ready = true;
+out_free:
+	kfree(ref_buf);
+out:
+	mutex_unlock(&cmh_ecdh_scratch_lock);
+	return ret;
+}
+
+/**
+ * cmh_pke_ecdh_register() - Register ECDH kpp algorithms with the crypto framework
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_pke_ecdh_register(void)
+{
+	u32 n_mbx = cmh_tm_mbx_count();
+	int ret, i;
+
+	if (!cmh_core_present(CMH_CORE_PKE))
+		return 0;
+
+	/*
+	 * Host-side index array only; the per-mailbox datastore objects are
+	 * created lazily on the first key set (cmh_ecdh_scratch_ensure) so a
+	 * bring-up that never keys ECDH leaves the datastore empty for a DS
+	 * import.
+	 */
+	cmh_ecdh_key_scratch = kcalloc(n_mbx, sizeof(*cmh_ecdh_key_scratch),
+				       GFP_KERNEL);
+	if (!cmh_ecdh_key_scratch)
+		return -ENOMEM;
+	cmh_ecdh_scratch_count = n_mbx;
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
+	cmh_ecdh_scratch_free();
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
+	if (!cmh_core_present(CMH_CORE_PKE))
+		return;
+
+	while (i--)
+		crypto_unregister_kpp(&cmh_ecdh_algs[i]);
+
+	/*
+	 * Safe to free the shared scratch now: crypto_unregister_kpp() above
+	 * blocks until every TFM is released and no request is in flight, so
+	 * no cmh_ecdh_compute_shared_secret() can still be reading it.
+	 */
+	cmh_ecdh_scratch_free();
+}
-- 
2.43.7

