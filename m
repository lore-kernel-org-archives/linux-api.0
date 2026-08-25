Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020140.outbound.protection.outlook.com [52.101.201.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099CE48D89C;
	Tue, 25 Aug 2026 22:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696167; cv=fail; b=Id24K5f/f91C/ywxCNBihkYqWOiqdS+uuWwF2EgLmhF+OOl/H857cjcsqRclG1r2ZdNT/hTGPPzD30/k3/vrS79rrRdNiP0pK+mYJjREn8fnyPyBEDnR96YMNHw+olETC7ko23eZlphzq210/Jnv773y13QI/6kpHJkX+TU2vGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696167; c=relaxed/simple;
	bh=Gc/BsqA8cpamAIbIsCL8DhU1Td/FGjWPA5ZFRtc+Nhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ngIW7lsuoDBJPiDc6fe9qop+m8uiUVJkDJVPyZUe/eHLK0sBQJhKCQhTULCqCu96WKy6zryjDNX6gthugC547NXnuxzf9SDgqk78k+s7og59YZvmkbTpib0MUI5gX5SRFYyfVLVKuN3gfAc4fTT5F9YazcUsBu6oB62E9LAQ7Wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=Clep5hIu; arc=fail smtp.client-ip=52.101.201.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="Clep5hIu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cskes1XkyBcHLa8hJ6BwRticxbJLugvU9QkFAdZ7Bq6ZmyhhTF/Pev+bmUOjZiQLwQMS6TSQfdIpeA0v+bn7c3GQgOIXrW9SZDGevgFtH/o6dPxct6wzI8KvC6HFgpyphM+KDzFvFIFMdIgc+KK4yrJeRYBkSNT6kJzxCIOdwZQNkoluSXaNVEJXFTH8iUsPvNOquoB51cNhDlClwO5lsshz4/ljpK5WGFH7AWZS8aPB8IP2+57zk3EXTxg8efqTj5BsCQ4QtQFNX+lSWy1idvttKElOh1PWgCDIb86ERIroku+jZ2056peOumAcyfk/ZsbO0iyKjGYVHZL+fbHlmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I7DC1zLVuTEmrUqTVBpLqfBUjx0+5ynetXMMwhllDHQ=;
 b=NJHtH6cbTSvpRku9eWi31EGorOkrJY+5dNljA4Fxk3NSH8EU6wHl4/rYG573CzWubz9/TRWMhXhA519T4efLQLkrYOr0GMLv/3Hai01w/WBHIsNULxuQF7slizbiCA68ThF5A3B2WEpeeKays8/jG8XwtSo/dJ9I7H3ASkLH0QP3HOA4FOLHa3uo5H/3bPjvDSf3luIGPLor4PLrfICvDGqrPxRf8Kr7ZG4sgD45PslAn57somk53YcCrY9E2J0qwahJwAff4YdRmjyFMFhaylGLYpQU7ZvqMnPVTUxWubzIHUmwux+oETVbFentjx88l4wDOIEr/KJ7RNZGGnVjvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7DC1zLVuTEmrUqTVBpLqfBUjx0+5ynetXMMwhllDHQ=;
 b=Clep5hIuaaBenWA17kkIERf+odsovX5H+1W8E6cjOIaVcT0CLDdnv1mKrXCzTeUeKdATJYmsnxupFNAeyEekttHG4wMRK8IS6wC6uIGvcYhNZ15BT8W8gaZB3DNuxe//pgF/e8U9qaNkWhU99jQTnBQiC1K6qwuR1sE9rkPRtBVoMn/35FGFEFJ/EI1aybVoHWQsXTjlScCf+FqcCu5iSLBvtVmMUUz7GHtXVmfRNL4xQC5WmM8ax9jwisP9uj9POSaaNc0M+L9eDEVeoU1W5lje4zEvBdhYb88Rb4khIIa6BpeAjhqM9179B3Q9APfHkYDF1OZVcf2GcJTUkjEhLQ==
Received: from SJ0PR13CA0159.namprd13.prod.outlook.com (2603:10b6:a03:2c7::14)
 by CO6PR04MB8428.namprd04.prod.outlook.com (2603:10b6:303:147::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 25 Aug
 2026 22:15:54 +0000
Received: from SJ1PEPF000023CD.namprd02.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::19) by SJ0PR13CA0159.outlook.office365.com
 (2603:10b6:a03:2c7::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.7 via Frontend Transport; Tue, 25
 Aug 2026 22:15:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy01.rambus.com; pr=C
Received: from hqxsv-psmtppxy01.rambus.com (192.86.86.210) by
 SJ1PEPF000023CD.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 22:15:53 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy01.rambus.com (Postfix) with ESMTP id A17F11801770;
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
Subject: [PATCH v4 16/19] crypto: cmh - add SLH-DSA/LMS/XMSS (HCQ)
Date: Tue, 25 Aug 2026 15:15:35 -0700
Message-ID: <20260825221539.255951-17-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CD:EE_|CO6PR04MB8428:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: d5f84f3e-5613-4be3-73f9-08df02f66dcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|36860700016|82310400026|56012099006|3023799007|10067099003|11063799006|6133799003|921020|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	s8rE4NZRQwnVEOIA21jIpnoYJScCCteIGmWlbUr+gYiEpkMf4gjAJ+ZnUcx2vbHgFzmkGydXU8WMwlYvsn5QzP8ebVvfDNdc+4dQcTu76YJpQ3ltXRFSrbYC31j/CgZe77Ie1vghCBK5edp3zQYtuqHB5mZkkkNBNmH6vEO8Had8JR7IlBZdrP/yuFHU00H9KO4R0b1+hGbVwH1sqbaEpY0Ptr8DfzFMSL6sEoVyqC+DFixFhgFSC6hjMFTFijTl+31Pdkzon7PZanIaCodbrDtfelOnFceYioHqFoUyKxY+NXJkzazzJoqhlKKrtoNGkGoH4AKQ8kAnI2gzN3i60sTGmjfWKOmfSAb8fcWm2LP2MBEIJBZQ1gJ6MqNoOTx3ZoGWm/W7n1KSDqo9kV9B8mxefFOvN+R+QaIq4PjTxO4TCZDMVfG9k1qfEdQFq1HmVRisUarXgBY5E8CoGXMwdWHE4qmgwvP4Km8ViCK/P+sjBjsNwUlc9jq2VpuP3QfCaFItlGQRsMQPM5WqLUXrbPxuuuAQFjv27A2X5q/sE4JZjR2ydtxCtPP9GCNRGQGuQZQ7DdV4zcYFub7SrGPPXVqEhszmy5Thjx7VDQUIO+0FLIKZ20qd8Kly7dtNvF+2qAbRHudhLRu4e81XWcLBJWJVlCxarf5eyAH8t72/oenbatyaqnhnDdWGthPQ8DgGr3Sy2luWm83xti4YPG8YvSEzwQOoGwHZi/13HCeuHJvpSoxyiK+CeFfifIPQMaIq
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy01.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(36860700016)(82310400026)(56012099006)(3023799007)(10067099003)(11063799006)(6133799003)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z8Bm1F97OlJsB96/J3841JWcja6/9tgFTJx/UKcdjMMpxZxU6sxUPib8CXs5AQRpUppnPZRV177p6p49lgEkQsTAMzIbMDG+K1BeXAcj2aDjPpDVK84U5pBsmev+DUxVIxlSUOPQnWwacQuA8uve7oDpb5nyE/ZUDKFa2b5j32ml6jhzjFOq1zZZE62F9IpBTheEmvrxZ4KAj3XNsofpp2zMdjoefdkzvPnR0q4S2k64gv+oOVWRSlV/iStU9PaXsecVfTlMvRGC2O5VclANnYo5TNb4vKOOwOVsM8ztK+hWub22wLabhkGjD+WSVnD0JHTkBvqBz7REMPtTXoo0gc3GzFpetHpeVBcMcdWBH6IVCNd1uHo6fUNOZq19v0PM1olMhwOA/QxAGnNC6Z/62Lzz5jr9teDAk6ljJEJB2AMAt0BLk18mUV9Ky/HUeAn0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 22:15:53.6677
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f84f3e-5613-4be3-73f9-08df02f66dcb
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy01.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8428

Register SLH-DSA, LMS, LMS-HSS, XMSS, and XMSS-MT algorithms
using the CMH HCQ core (core ID 0x08).  SLH-DSA is registered as a
sig algorithm with sign and verify support.  LMS, LMS-HSS, XMSS,
and XMSS-MT are registered as verify-only sig algorithms: their
stateful signing semantics (one-time-key private state the signer
must track) are not modeled by the kernel crypto API, so only
verification is exposed.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 drivers/crypto/cmh/Makefile         |   6 +-
 drivers/crypto/cmh/cmh_hcq.c        | 313 +++++++++++++++++++++++
 drivers/crypto/cmh/cmh_main.c       |  24 ++
 drivers/crypto/cmh/cmh_pqc_lms.c    | 244 ++++++++++++++++++
 drivers/crypto/cmh/cmh_pqc_slhdsa.c | 383 ++++++++++++++++++++++++++++
 drivers/crypto/cmh/cmh_pqc_xmss.c   | 244 ++++++++++++++++++
 6 files changed, 1213 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/cmh/cmh_hcq.c
 create mode 100644 drivers/crypto/cmh/cmh_pqc_lms.c
 create mode 100644 drivers/crypto/cmh/cmh_pqc_slhdsa.c
 create mode 100644 drivers/crypto/cmh/cmh_pqc_xmss.c

diff --git a/drivers/crypto/cmh/Makefile b/drivers/crypto/cmh/Makefile
index 7196d992487e..a78311bf3195 100644
--- a/drivers/crypto/cmh/Makefile
+++ b/drivers/crypto/cmh/Makefile
@@ -36,7 +36,11 @@ cmh-y := \
 	cmh_pke_ecdh.o \
 	cmh_qse.o \
 	cmh_pqc_mldsa.o \
-	cmh_pqc_sizes.o
+	cmh_pqc_sizes.o \
+	cmh_hcq.o \
+	cmh_pqc_slhdsa.o \
+	cmh_pqc_lms.o \
+	cmh_pqc_xmss.o
 
 # Management ioctl device (/dev/cmh_mgmt): key lifecycle, PKE, PQC ioctls.
 cmh-$(CONFIG_CRYPTO_DEV_CMH_MGMT) += \
diff --git a/drivers/crypto/cmh/cmh_hcq.c b/drivers/crypto/cmh/cmh_hcq.c
new file mode 100644
index 000000000000..8fc3a5cb0f9f
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_hcq.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- HCQ Core VCQ Builders
+ *
+ * VCQ builder functions for SLH-DSA, LMS, and XMSS commands.
+ * Each function populates a single vcq_cmd slot.  Callers assemble
+ * complete VCQs with header + command(s) + flush, then submit via
+ * cmh_tm_submit_sync().
+ */
+
+#include <linux/string.h>
+
+#include "cmh_sys.h"
+
+/* -- HCQ flush -- */
+
+/**
+ * vcq_add_hcq_flush() - Build an HCQ flush VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ */
+void vcq_add_hcq_flush(struct vcq_cmd *slot, u32 core_id)
+{
+	vcq_add_flush(slot, core_id);
+}
+
+/* -- SLH-DSA -- */
+
+/**
+ * vcq_add_hcq_slhdsa_keygen() - Build an SLH-DSA key generation VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @param_set: SLH-DSA parameter set identifier
+ * @seed_len: Length of seed buffer in bytes
+ * @pk_len: Length of public key buffer in bytes
+ * @sk_len: Length of secret key buffer in bytes
+ * @seed: DMA address of seed input buffer
+ * @pk: DMA address of public key output buffer
+ * @sk: DMA address of secret key output buffer
+ */
+void vcq_add_hcq_slhdsa_keygen(struct vcq_cmd *slot, u32 core_id, u32 param_set,
+			       u32 seed_len, u32 pk_len, u32 sk_len,
+			       u64 seed, u64 pk, u64 sk)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HCQ_CMD_SLHDSA_KEYGEN);
+	slot->hwc.hcq.cmd_slhdsa_keygen.parameter_set = param_set;
+	slot->hwc.hcq.cmd_slhdsa_keygen.seed_len = seed_len;
+	slot->hwc.hcq.cmd_slhdsa_keygen.pk_len = pk_len;
+	slot->hwc.hcq.cmd_slhdsa_keygen.sk_len = sk_len;
+	slot->hwc.hcq.cmd_slhdsa_keygen.seed = seed;
+	slot->hwc.hcq.cmd_slhdsa_keygen.pk = pk;
+	slot->hwc.hcq.cmd_slhdsa_keygen.sk = sk;
+}
+
+/**
+ * vcq_add_hcq_slhdsa_sign() - Build an SLH-DSA signing VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @param_set: SLH-DSA parameter set identifier
+ * @msg_len: Length of message buffer in bytes
+ * @ctx_len: Length of context string in bytes
+ * @add_random: DMA address of additional randomness buffer
+ * @msg: DMA address of message buffer
+ * @ctx: DMA address of context string buffer
+ * @sk: DMA address of secret key buffer
+ * @sig: DMA address of signature output buffer
+ */
+void vcq_add_hcq_slhdsa_sign(struct vcq_cmd *slot, u32 core_id, u32 param_set,
+			     u32 msg_len, u32 ctx_len,
+			     u64 add_random, u64 msg, u64 ctx,
+			     u64 sk, u64 sig)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HCQ_CMD_SLHDSA_SIGN);
+	slot->hwc.hcq.cmd_slhdsa_sign.parameter_set = param_set;
+	slot->hwc.hcq.cmd_slhdsa_sign.message_len = msg_len;
+	slot->hwc.hcq.cmd_slhdsa_sign.add_random = add_random;
+	slot->hwc.hcq.cmd_slhdsa_sign.message = msg;
+	slot->hwc.hcq.cmd_slhdsa_sign.context = ctx;
+	slot->hwc.hcq.cmd_slhdsa_sign.sk = sk;
+	slot->hwc.hcq.cmd_slhdsa_sign.sig = sig;
+	slot->hwc.hcq.cmd_slhdsa_sign.context_len = ctx_len;
+}
+
+/**
+ * vcq_add_hcq_slhdsa_sign_internal() - Build an SLH-DSA internal signing VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @param_set: SLH-DSA parameter set identifier
+ * @msg_len: Length of message buffer in bytes
+ * @add_random: DMA address of additional randomness buffer
+ * @msg: DMA address of message buffer
+ * @sk: DMA address of secret key buffer
+ * @sig: DMA address of signature output buffer
+ */
+void vcq_add_hcq_slhdsa_sign_internal(struct vcq_cmd *slot, u32 core_id, u32 param_set,
+				      u32 msg_len, u64 add_random,
+				      u64 msg, u64 sk, u64 sig)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HCQ_CMD_SLHDSA_SIGN_INTERNAL);
+	slot->hwc.hcq.cmd_slhdsa_sign_internal.parameter_set = param_set;
+	slot->hwc.hcq.cmd_slhdsa_sign_internal.message_len = msg_len;
+	slot->hwc.hcq.cmd_slhdsa_sign_internal.add_random = add_random;
+	slot->hwc.hcq.cmd_slhdsa_sign_internal.message = msg;
+	slot->hwc.hcq.cmd_slhdsa_sign_internal.sk = sk;
+	slot->hwc.hcq.cmd_slhdsa_sign_internal.sig = sig;
+}
+
+/**
+ * vcq_add_hcq_slhdsa_verify() - Build an SLH-DSA verification VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @param_set: SLH-DSA parameter set identifier
+ * @msg_len: Length of message buffer in bytes
+ * @ctx_len: Length of context string in bytes
+ * @msg: DMA address of message buffer
+ * @ctx: DMA address of context string buffer
+ * @pk: DMA address of public key buffer
+ * @sig: DMA address of signature buffer to verify
+ */
+void vcq_add_hcq_slhdsa_verify(struct vcq_cmd *slot, u32 core_id, u32 param_set,
+			       u32 msg_len, u32 ctx_len,
+			       u64 msg, u64 ctx, u64 pk, u64 sig)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HCQ_CMD_SLHDSA_VERIFY);
+	slot->hwc.hcq.cmd_slhdsa_verify.parameter_set = param_set;
+	slot->hwc.hcq.cmd_slhdsa_verify.message_len = msg_len;
+	slot->hwc.hcq.cmd_slhdsa_verify.message = msg;
+	slot->hwc.hcq.cmd_slhdsa_verify.context = ctx;
+	slot->hwc.hcq.cmd_slhdsa_verify.pk = pk;
+	slot->hwc.hcq.cmd_slhdsa_verify.sig = sig;
+	slot->hwc.hcq.cmd_slhdsa_verify.context_len = ctx_len;
+}
+
+/**
+ * vcq_add_hcq_slhdsa_sign_prehash() - Build an SLH-DSA prehash signing VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @cmd: VCQ command ID (sign-prehash variant)
+ * @param_set: SLH-DSA parameter set identifier
+ * @prehash_algo: Prehash algorithm identifier
+ * @msg_len: Length of message buffer in bytes
+ * @ctx_len: Length of context string in bytes
+ * @add_random: DMA address of additional randomness buffer
+ * @msg: DMA address of message buffer
+ * @ctx: DMA address of context string buffer
+ * @sk: DMA address of secret key buffer
+ * @sig: DMA address of signature output buffer
+ */
+void vcq_add_hcq_slhdsa_sign_prehash(struct vcq_cmd *slot, u32 core_id,
+				     u32 cmd, u32 param_set, u32 prehash_algo,
+				     u32 msg_len, u32 ctx_len,
+				     u64 add_random, u64 msg, u64 ctx,
+				     u64 sk, u64 sig)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, cmd);
+	slot->hwc.hcq.cmd_slhdsa_sign_prehash.parameter_set = param_set;
+	slot->hwc.hcq.cmd_slhdsa_sign_prehash.prehash_algo = prehash_algo;
+	slot->hwc.hcq.cmd_slhdsa_sign_prehash.message_len = msg_len;
+	slot->hwc.hcq.cmd_slhdsa_sign_prehash.context_len = ctx_len;
+	slot->hwc.hcq.cmd_slhdsa_sign_prehash.add_random = add_random;
+	slot->hwc.hcq.cmd_slhdsa_sign_prehash.message = msg;
+	slot->hwc.hcq.cmd_slhdsa_sign_prehash.context = ctx;
+	slot->hwc.hcq.cmd_slhdsa_sign_prehash.sk = sk;
+	slot->hwc.hcq.cmd_slhdsa_sign_prehash.sig = sig;
+}
+
+/**
+ * vcq_add_hcq_slhdsa_verify_prehash() - Build an SLH-DSA prehash verify VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @cmd: VCQ command ID (verify-prehash variant)
+ * @param_set: SLH-DSA parameter set identifier
+ * @prehash_algo: Prehash algorithm identifier
+ * @msg_len: Length of message buffer in bytes
+ * @ctx_len: Length of context string in bytes
+ * @msg: DMA address of message buffer
+ * @ctx: DMA address of context string buffer
+ * @pk: DMA address of public key buffer
+ * @sig: DMA address of signature buffer to verify
+ */
+void vcq_add_hcq_slhdsa_verify_prehash(struct vcq_cmd *slot, u32 core_id,
+				       u32 cmd, u32 param_set, u32 prehash_algo,
+				       u32 msg_len, u32 ctx_len,
+				       u64 msg, u64 ctx, u64 pk, u64 sig)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, cmd);
+	slot->hwc.hcq.cmd_slhdsa_verify_prehash.parameter_set = param_set;
+	slot->hwc.hcq.cmd_slhdsa_verify_prehash.prehash_algo = prehash_algo;
+	slot->hwc.hcq.cmd_slhdsa_verify_prehash.message_len = msg_len;
+	slot->hwc.hcq.cmd_slhdsa_verify_prehash.context_len = ctx_len;
+	slot->hwc.hcq.cmd_slhdsa_verify_prehash.message = msg;
+	slot->hwc.hcq.cmd_slhdsa_verify_prehash.context = ctx;
+	slot->hwc.hcq.cmd_slhdsa_verify_prehash.pk = pk;
+	slot->hwc.hcq.cmd_slhdsa_verify_prehash.sig = sig;
+}
+
+/**
+ * vcq_add_hcq_slhdsa_verify_internal() - Build an SLH-DSA internal verify VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @param_set: SLH-DSA parameter set identifier
+ * @msg_len: Length of message buffer in bytes
+ * @msg: DMA address of message buffer
+ * @pk: DMA address of public key buffer
+ * @sig: DMA address of signature buffer to verify
+ */
+void vcq_add_hcq_slhdsa_verify_internal(struct vcq_cmd *slot, u32 core_id, u32 param_set,
+					u32 msg_len, u64 msg, u64 pk, u64 sig)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1,
+			      HCQ_CMD_SLHDSA_VERIFY_INTERNAL);
+	slot->hwc.hcq.cmd_slhdsa_verify_internal.parameter_set = param_set;
+	slot->hwc.hcq.cmd_slhdsa_verify_internal.message_len = msg_len;
+	slot->hwc.hcq.cmd_slhdsa_verify_internal.message = msg;
+	slot->hwc.hcq.cmd_slhdsa_verify_internal.pk = pk;
+	slot->hwc.hcq.cmd_slhdsa_verify_internal.sig = sig;
+}
+
+/**
+ * vcq_add_hcq_slhdsa_pubgen() - Build an SLH-DSA public key generation VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @param_set: SLH-DSA parameter set identifier
+ * @sk_len: Length of secret key buffer in bytes
+ * @sk: DMA address of secret key input buffer
+ * @pk: DMA address of public key output buffer
+ */
+void vcq_add_hcq_slhdsa_pubgen(struct vcq_cmd *slot, u32 core_id, u32 param_set,
+			       u32 sk_len, u64 sk, u64 pk)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HCQ_CMD_SLHDSA_PUBGEN);
+	slot->hwc.hcq.cmd_slhdsa_pubgen.parameter_set = param_set;
+	slot->hwc.hcq.cmd_slhdsa_pubgen.sk_len = sk_len;
+	slot->hwc.hcq.cmd_slhdsa_pubgen.sk = sk;
+	slot->hwc.hcq.cmd_slhdsa_pubgen.pk = pk;
+}
+
+/* -- LMS -- */
+
+/**
+ * vcq_add_hcq_lms_verify() - Build an LMS/HSS signature verify VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @lms_hss: LMS/HSS mode flag (0 = LMS, 1 = HSS)
+ * @pk_len: Length of public key buffer in bytes
+ * @sig_len: Length of signature buffer in bytes
+ * @dig_len: Length of digest buffer in bytes
+ * @pk: DMA address of public key buffer
+ * @sig: DMA address of signature buffer
+ * @dig: DMA address of digest buffer
+ */
+void vcq_add_hcq_lms_verify(struct vcq_cmd *slot, u32 core_id, u32 lms_hss,
+			    u32 pk_len, u32 sig_len, u32 dig_len,
+			    u64 pk, u64 sig, u64 dig)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HCQ_CMD_LMS_VERIFY);
+	slot->hwc.hcq.cmd_lms_verify.lms_hss = lms_hss;
+	slot->hwc.hcq.cmd_lms_verify.pk_len = pk_len;
+	slot->hwc.hcq.cmd_lms_verify.sig_len = sig_len;
+	slot->hwc.hcq.cmd_lms_verify.dig_len = dig_len;
+	slot->hwc.hcq.cmd_lms_verify.pk = pk;
+	slot->hwc.hcq.cmd_lms_verify.sig = sig;
+	slot->hwc.hcq.cmd_lms_verify.dig = dig;
+}
+
+/* -- XMSS -- */
+
+/**
+ * vcq_add_hcq_xmss_verify() - Build an XMSS/XMSS^MT signature verify VCQ command
+ * @slot: VCQ command slot to populate
+ * @core_id: Hardware core ID for dispatch
+ * @xmss_mt: XMSS/XMSS^MT mode flag (0 = XMSS, 1 = XMSS^MT)
+ * @pk_len: Length of public key buffer in bytes
+ * @sig_len: Length of signature buffer in bytes
+ * @dig_len: Length of digest buffer in bytes
+ * @pk: DMA address of public key buffer
+ * @sig: DMA address of signature buffer
+ * @dig: DMA address of digest buffer
+ */
+void vcq_add_hcq_xmss_verify(struct vcq_cmd *slot, u32 core_id, u32 xmss_mt,
+			     u32 pk_len, u32 sig_len, u32 dig_len,
+			     u64 pk, u64 sig, u64 dig)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(core_id, 0, 1, HCQ_CMD_XMSS_VERIFY);
+	slot->hwc.hcq.cmd_xmss_verify.xmss_mt = xmss_mt;
+	slot->hwc.hcq.cmd_xmss_verify.pk_len = pk_len;
+	slot->hwc.hcq.cmd_xmss_verify.sig_len = sig_len;
+	slot->hwc.hcq.cmd_xmss_verify.dig_len = dig_len;
+	slot->hwc.hcq.cmd_xmss_verify.pk = pk;
+	slot->hwc.hcq.cmd_xmss_verify.sig = sig;
+	slot->hwc.hcq.cmd_xmss_verify.dig = dig;
+}
diff --git a/drivers/crypto/cmh/cmh_main.c b/drivers/crypto/cmh/cmh_main.c
index 7dfcdf395175..bed18321f535 100644
--- a/drivers/crypto/cmh/cmh_main.c
+++ b/drivers/crypto/cmh/cmh_main.c
@@ -308,6 +308,21 @@ static int cmh_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_pqc_mldsa_register;
 
+	/* Register PQC SLH-DSA */
+	ret = cmh_pqc_slhdsa_register();
+	if (ret)
+		goto err_pqc_slhdsa_register;
+
+	/* Register PQC LMS */
+	ret = cmh_pqc_lms_register();
+	if (ret)
+		goto err_pqc_lms_register;
+
+	/* Register PQC XMSS */
+	ret = cmh_pqc_xmss_register();
+	if (ret)
+		goto err_pqc_xmss_register;
+
 	/* Register key management device (/dev/cmh_mgmt) */
 	ret = cmh_mgmt_register();
 	if (ret)
@@ -318,6 +333,12 @@ static int cmh_probe(struct platform_device *pdev)
 	return 0;
 
 err_mgmt_register:
+	cmh_pqc_xmss_unregister();
+err_pqc_xmss_register:
+	cmh_pqc_lms_unregister();
+err_pqc_lms_register:
+	cmh_pqc_slhdsa_unregister();
+err_pqc_slhdsa_register:
 	cmh_pqc_mldsa_unregister();
 err_pqc_mldsa_register:
 	cmh_pke_ecdh_unregister();
@@ -382,6 +403,9 @@ static void cmh_remove(struct platform_device *pdev)
 	cfg = &dev->config;
 
 	cmh_mgmt_unregister();
+	cmh_pqc_xmss_unregister();
+	cmh_pqc_lms_unregister();
+	cmh_pqc_slhdsa_unregister();
 	cmh_pqc_mldsa_unregister();
 	cmh_pke_ecdh_unregister();
 	cmh_pke_ecdsa_unregister();
diff --git a/drivers/crypto/cmh/cmh_pqc_lms.c b/drivers/crypto/cmh/cmh_pqc_lms.c
new file mode 100644
index 000000000000..882142229981
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pqc_lms.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- LMS/HSS Signature Driver (verify-only, sig_alg, synchronous)
+ *
+ * Registers "lms" and "lms-hss" sig algorithms with verify-only
+ * callbacks.  Sign is not supported (stateful signature -- key
+ * management must happen externally).
+ *
+ * Verify: src = raw signature, digest = message bytes
+ * Public key: raw pk bytes (variable length, set via set_pub_key)
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <crypto/sig.h>
+#include <crypto/internal/sig.h>
+
+#include "cmh_sys.h"
+#include "cmh_hcq_abi.h"
+#include "cmh_txn.h"
+#include "cmh_dma.h"
+#include "cmh_pqc.h"
+
+#define LMS_VCQ_CMDS	3	/* header + cmd + flush */
+
+struct cmh_lms_tfm_ctx {
+	u8 *pub_key;
+	u32 pub_key_len;
+	u32 lms_hss;		/* 0 = LMS, 1 = LMS-HSS */
+};
+
+static inline struct cmh_lms_tfm_ctx *cmh_lms_ctx(struct crypto_sig *tfm)
+{
+	return crypto_sig_ctx(tfm);
+}
+
+/*
+ * LMS/HSS verify (synchronous sig_alg)
+ *
+ * @src:    raw signature
+ * @slen:   signature length
+ * @digest: message bytes
+ * @dlen:   message length
+ *
+ * Returns 0 on successful verification, negative errno on failure.
+ */
+static int cmh_lms_verify(struct crypto_sig *tfm,
+			  const void *src, unsigned int slen,
+			  const void *digest, unsigned int dlen)
+{
+	struct cmh_lms_tfm_ctx *ctx = cmh_lms_ctx(tfm);
+	struct core_dispatch d = cmh_core_select_instance(CMH_CORE_HCQ);
+	struct vcq_cmd vcq[LMS_VCQ_CMDS];
+	u8 *sig_buf = NULL, *m_buf = NULL, *pk_buf = NULL;
+	dma_addr_t sig_dma = DMA_MAPPING_ERROR;
+	dma_addr_t m_dma = DMA_MAPPING_ERROR;
+	dma_addr_t pk_dma = DMA_MAPPING_ERROR;
+	int ret;
+
+	if (!ctx->pub_key)
+		return -EINVAL;
+	if (!slen || slen > LMS_MAX_SIG_LEN)
+		return -EINVAL;
+	if (!dlen || dlen > LMS_MAX_MSG_LEN)
+		return -EINVAL;
+
+	sig_buf = kmemdup(src, slen, GFP_KERNEL);
+	m_buf = kmemdup(digest, dlen, GFP_KERNEL);
+	pk_buf = kmemdup(ctx->pub_key, ctx->pub_key_len, GFP_KERNEL);
+	if (!sig_buf || !m_buf || !pk_buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	sig_dma = cmh_dma_map_single(sig_buf, slen, DMA_TO_DEVICE);
+	m_dma = cmh_dma_map_single(m_buf, dlen, DMA_TO_DEVICE);
+	pk_dma = cmh_dma_map_single(pk_buf, ctx->pub_key_len, DMA_TO_DEVICE);
+
+	if (cmh_dma_map_error(sig_dma) || cmh_dma_map_error(m_dma) ||
+	    cmh_dma_map_error(pk_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	vcq_set_header(&vcq[0], LMS_VCQ_CMDS);
+	vcq_add_hcq_lms_verify(&vcq[1], d.core_id, ctx->lms_hss,
+			       ctx->pub_key_len, slen, dlen,
+			       pk_dma, sig_dma, m_dma);
+	vcq_add_hcq_flush(&vcq[2], d.core_id);
+
+	/* LMS verify traverses Merkle hash chains -- inherently slow */
+	ret = cmh_tm_submit_sync_tmo(vcq, LMS_VCQ_CMDS, 1, d.mbx_idx,
+				     cmh_tm_slow_op_timeout_jiffies());
+
+out_unmap:
+	if (!cmh_dma_map_error(pk_dma))
+		cmh_dma_unmap_single(pk_dma, ctx->pub_key_len, DMA_TO_DEVICE);
+	if (!cmh_dma_map_error(m_dma))
+		cmh_dma_unmap_single(m_dma, dlen, DMA_TO_DEVICE);
+	if (!cmh_dma_map_error(sig_dma))
+		cmh_dma_unmap_single(sig_dma, slen, DMA_TO_DEVICE);
+
+out_free:
+	kfree(pk_buf);
+	kfree(m_buf);
+	kfree(sig_buf);
+	return ret;
+}
+
+static int cmh_lms_set_pub_key(struct crypto_sig *tfm,
+			       const void *key, unsigned int keylen)
+{
+	struct cmh_lms_tfm_ctx *ctx = cmh_lms_ctx(tfm);
+
+	if (!keylen || keylen > LMS_MAX_PK_LEN)
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
+static unsigned int cmh_lms_key_size(struct crypto_sig *tfm)
+{
+	struct cmh_lms_tfm_ctx *ctx = cmh_lms_ctx(tfm);
+
+	return ctx->pub_key_len * 8;
+}
+
+static int cmh_lms_init(struct crypto_sig *tfm)
+{
+	struct cmh_lms_tfm_ctx *ctx = cmh_lms_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	return 0;
+}
+
+static int cmh_lms_hss_init(struct crypto_sig *tfm)
+{
+	struct cmh_lms_tfm_ctx *ctx = cmh_lms_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->lms_hss = 1;
+	return 0;
+}
+
+static void cmh_lms_exit(struct crypto_sig *tfm)
+{
+	struct cmh_lms_tfm_ctx *ctx = cmh_lms_ctx(tfm);
+
+	kfree(ctx->pub_key);
+	ctx->pub_key = NULL;
+}
+
+static unsigned int cmh_lms_max_size(struct crypto_sig *tfm)
+{
+	/* Verify-only; report the max signature length for API parity. */
+	return LMS_MAX_SIG_LEN;
+}
+
+static struct sig_alg cmh_lms_algs[] = {
+	{
+		.verify		= cmh_lms_verify,
+		.set_pub_key	= cmh_lms_set_pub_key,
+		.key_size	= cmh_lms_key_size,
+		.max_size	= cmh_lms_max_size,
+		.init		= cmh_lms_init,
+		.exit		= cmh_lms_exit,
+		.base = {
+			.cra_name	  = "lms",
+			.cra_driver_name  = "rambus-cmh-lms",
+			.cra_priority	  = 300,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_lms_tfm_ctx),
+		},
+	},
+	{
+		.verify		= cmh_lms_verify,
+		.set_pub_key	= cmh_lms_set_pub_key,
+		.key_size	= cmh_lms_key_size,
+		.max_size	= cmh_lms_max_size,
+		.init		= cmh_lms_hss_init,
+		.exit		= cmh_lms_exit,
+		.base = {
+			.cra_name	  = "lms-hss",
+			.cra_driver_name  = "rambus-cmh-lms-hss",
+			.cra_priority	  = 300,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_lms_tfm_ctx),
+		},
+	},
+};
+
+/**
+ * cmh_pqc_lms_register() - Register LMS/LMS-HSS sig algorithms with the crypto framework
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_pqc_lms_register(void)
+{
+	int ret, i;
+
+	if (!cmh_core_present(CMH_CORE_HCQ))
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(cmh_lms_algs); i++) {
+		ret = crypto_register_sig(&cmh_lms_algs[i]);
+		if (ret) {
+			dev_err(cmh_dev(), "cmh: failed to register %s (%d)\n",
+				cmh_lms_algs[i].base.cra_name, ret);
+			goto err_unregister;
+		}
+	}
+
+	return 0;
+
+err_unregister:
+	while (i--)
+		crypto_unregister_sig(&cmh_lms_algs[i]);
+	return ret;
+}
+
+/**
+ * cmh_pqc_lms_unregister() - Unregister LMS/LMS-HSS sig algorithms from the crypto framework
+ */
+void cmh_pqc_lms_unregister(void)
+{
+	int i = ARRAY_SIZE(cmh_lms_algs);
+
+	if (!cmh_core_present(CMH_CORE_HCQ))
+		return;
+
+	while (i--)
+		crypto_unregister_sig(&cmh_lms_algs[i]);
+}
diff --git a/drivers/crypto/cmh/cmh_pqc_slhdsa.c b/drivers/crypto/cmh/cmh_pqc_slhdsa.c
new file mode 100644
index 000000000000..89bb6141406f
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pqc_slhdsa.c
@@ -0,0 +1,383 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- SLH-DSA Signature Driver (sig_alg, synchronous)
+ *
+ * Registers SLH-DSA sig algorithms for all 12 parameter sets
+ * (SHAKE/SHA2 x 128/192/256 x s/f) with sign and verify callbacks.
+ *
+ * Key format:
+ *   Public key  = raw pk bytes (2*n bytes)
+ *   Private key = raw sk bytes (4*n)
+ *
+ * Sign: src = message, dst = raw signature
+ * Verify: src = raw signature, digest = message bytes
+ *
+ * Private keys are raw (written to SYS_REF_TEMP per-operation).
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/unaligned.h>
+#include <crypto/sig.h>
+#include <crypto/internal/sig.h>
+
+#include "cmh_sys.h"
+#include "cmh_qse_abi.h"
+#include "cmh_hcq_abi.h"
+#include "cmh_txn.h"
+#include "cmh_dma.h"
+#include "cmh_key.h"
+#include "cmh_pqc.h"
+
+struct cmh_slhdsa_tfm_ctx {
+	struct cmh_key_ctx key;		/* private key (raw sk bytes) */
+	u8 *pub_key;
+	u32 pub_key_len;
+	u32 param_set;			/* HCQ_SLHDSA_SHAKE_128S .. SHA2_256F */
+};
+
+static inline struct cmh_slhdsa_tfm_ctx *cmh_slhdsa_ctx(struct crypto_sig *tfm)
+{
+	return crypto_sig_ctx(tfm);
+}
+
+/*
+ * SLH-DSA sign (synchronous sig_alg)
+ *
+ * @src:  message bytes
+ * @slen: message length
+ * @dst:  signature output buffer
+ * @dlen: output buffer length
+ *
+ * Returns signature length on success, negative errno on failure.
+ * Uses raw private keys written to SYS_REF_TEMP per-operation.
+ */
+static int cmh_slhdsa_sign(struct crypto_sig *tfm,
+			   const void *src, unsigned int slen,
+			   void *dst, unsigned int dlen)
+{
+	struct cmh_slhdsa_tfm_ctx *ctx = cmh_slhdsa_ctx(tfm);
+	u32 sig_sz = slhdsa_get_sig_size(ctx->param_set);
+	u32 sk_sz = slhdsa_sk_size(ctx->param_set);
+	struct vcq_cmd vcq[HCQ_VCQ_CMDS_MAX]; /* raw: hdr+write+sign+flush */
+	u32 vcq_count;
+	u8 *m_buf = NULL, *sig_buf = NULL, *sk_buf = NULL;
+	dma_addr_t m_dma = DMA_MAPPING_ERROR;
+	dma_addr_t sig_dma = DMA_MAPPING_ERROR;
+	dma_addr_t sk_dma = DMA_MAPPING_ERROR;
+	int ret, idx;
+
+	if (ctx->key.mode == CMH_KEY_NONE)
+		return -EINVAL;
+	if (dlen < sig_sz)
+		return -EINVAL;
+	if (!slen || slen > SLHDSA_MAX_MSG_LEN)
+		return -EINVAL;
+
+	m_buf = kmemdup(src, slen, GFP_KERNEL);
+	sig_buf = kzalloc(sig_sz, GFP_KERNEL);
+	if (!m_buf || !sig_buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	m_dma = cmh_dma_map_single(m_buf, slen, DMA_TO_DEVICE);
+	sig_dma = cmh_dma_map_single(sig_buf, sig_sz, DMA_FROM_DEVICE);
+	if (cmh_dma_map_error(m_dma) || cmh_dma_map_error(sig_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	sk_dma = DMA_MAPPING_ERROR;
+	idx = 0;
+
+	struct core_dispatch d;
+
+	d = cmh_core_select_instance(CMH_CORE_HCQ);
+
+	if (ctx->key.raw.len != sk_sz) {
+		ret = -EINVAL;
+		goto out_unmap;
+	}
+	sk_buf = kmemdup(ctx->key.raw.data, ctx->key.raw.len,
+			 GFP_KERNEL);
+	if (!sk_buf) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+	sk_dma = cmh_dma_map_single(sk_buf, sk_sz, DMA_TO_DEVICE);
+	if (cmh_dma_map_error(sk_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	vcq_count = HCQ_VCQ_CMDS_MIN + 1;
+	vcq_set_header(&vcq[idx++], vcq_count);
+	vcq_add_sys_write(&vcq[idx++], SYS_REF_TEMP, sk_dma,
+			  SYS_REF_NONE, sk_sz,
+			  ctx->key.raw.sys_type);
+	vcq_add_hcq_slhdsa_sign_internal(&vcq[idx++], d.core_id,
+					 ctx->param_set,
+					 slen, 0,
+					 m_dma, SYS_REF_TEMP,
+					 sig_dma);
+	vcq_add_hcq_flush(&vcq[idx++], d.core_id);
+
+	ret = cmh_tm_submit_sync_tmo(vcq, vcq_count, 1, d.mbx_idx,
+				     cmh_tm_slow_op_timeout_jiffies());
+
+	if (!ret) {
+		/* Sync bounce buffer so CPU sees the DMA-written signature */
+		cmh_dma_sync_for_cpu(sig_dma, sig_sz, DMA_FROM_DEVICE);
+		memcpy(dst, sig_buf, sig_sz);
+		ret = sig_sz;
+	}
+
+out_unmap:
+	if (sk_buf) {
+		if (!cmh_dma_map_error(sk_dma))
+			cmh_dma_unmap_single(sk_dma, sk_sz, DMA_TO_DEVICE);
+		kfree_sensitive(sk_buf);
+	}
+	if (!cmh_dma_map_error(sig_dma))
+		cmh_dma_unmap_single(sig_dma, sig_sz, DMA_FROM_DEVICE);
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
+ * SLH-DSA verify (synchronous sig_alg)
+ *
+ * @src:    raw signature
+ * @slen:   signature length
+ * @digest: message bytes
+ * @dlen:   message length
+ *
+ * Returns 0 on successful verification, negative errno on failure.
+ */
+static int cmh_slhdsa_verify(struct crypto_sig *tfm,
+			     const void *src, unsigned int slen,
+			     const void *digest, unsigned int dlen)
+{
+	struct cmh_slhdsa_tfm_ctx *ctx = cmh_slhdsa_ctx(tfm);
+	u32 sig_sz = slhdsa_get_sig_size(ctx->param_set);
+	u32 pk_sz = slhdsa_pk_size(ctx->param_set);
+	struct core_dispatch d = cmh_core_select_instance(CMH_CORE_HCQ);
+	struct vcq_cmd vcq[HCQ_VCQ_CMDS_MIN];
+	u8 *sig_buf = NULL, *m_buf = NULL, *pk_buf = NULL;
+	dma_addr_t sig_dma = DMA_MAPPING_ERROR;
+	dma_addr_t m_dma = DMA_MAPPING_ERROR;
+	dma_addr_t pk_dma = DMA_MAPPING_ERROR;
+	int ret;
+
+	if (!ctx->pub_key)
+		return -EINVAL;
+	if (slen != sig_sz)
+		return -EINVAL;
+	if (!dlen || dlen > SLHDSA_MAX_MSG_LEN)
+		return -EINVAL;
+
+	sig_buf = kmemdup(src, slen, GFP_KERNEL);
+	m_buf = kmemdup(digest, dlen, GFP_KERNEL);
+	pk_buf = kmemdup(ctx->pub_key, pk_sz, GFP_KERNEL);
+	if (!sig_buf || !m_buf || !pk_buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	sig_dma = cmh_dma_map_single(sig_buf, sig_sz, DMA_TO_DEVICE);
+	m_dma = cmh_dma_map_single(m_buf, dlen, DMA_TO_DEVICE);
+	pk_dma = cmh_dma_map_single(pk_buf, pk_sz, DMA_TO_DEVICE);
+
+	if (cmh_dma_map_error(sig_dma) || cmh_dma_map_error(m_dma) ||
+	    cmh_dma_map_error(pk_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	vcq_set_header(&vcq[0], HCQ_VCQ_CMDS_MIN);
+	vcq_add_hcq_slhdsa_verify_internal(&vcq[1], d.core_id, ctx->param_set,
+					   dlen, m_dma, pk_dma, sig_dma);
+	vcq_add_hcq_flush(&vcq[2], d.core_id);
+
+	/* SLH-DSA verify recomputes hyper-tree hashes -- inherently slow */
+	ret = cmh_tm_submit_sync_tmo(vcq, HCQ_VCQ_CMDS_MIN, 1, d.mbx_idx,
+				     cmh_tm_slow_op_timeout_jiffies());
+
+out_unmap:
+	if (!cmh_dma_map_error(pk_dma))
+		cmh_dma_unmap_single(pk_dma, pk_sz, DMA_TO_DEVICE);
+	if (!cmh_dma_map_error(m_dma))
+		cmh_dma_unmap_single(m_dma, dlen, DMA_TO_DEVICE);
+	if (!cmh_dma_map_error(sig_dma))
+		cmh_dma_unmap_single(sig_dma, sig_sz, DMA_TO_DEVICE);
+
+out_free:
+	kfree(pk_buf);
+	kfree(m_buf);
+	kfree(sig_buf);
+	return ret;
+}
+
+static int cmh_slhdsa_set_pub_key(struct crypto_sig *tfm,
+				  const void *key, unsigned int keylen)
+{
+	struct cmh_slhdsa_tfm_ctx *ctx = cmh_slhdsa_ctx(tfm);
+	u32 expected = slhdsa_pk_size(ctx->param_set);
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
+static int cmh_slhdsa_set_priv_key(struct crypto_sig *tfm,
+				   const void *key, unsigned int keylen)
+{
+	struct cmh_slhdsa_tfm_ctx *ctx = cmh_slhdsa_ctx(tfm);
+
+	/* Raw sk (4*n bytes) */
+	if (keylen != slhdsa_sk_size(ctx->param_set))
+		return -EINVAL;
+
+	return cmh_key_setkey_raw(&ctx->key, key, keylen, CORE_ID_HCQ);
+}
+
+static unsigned int cmh_slhdsa_key_size(struct crypto_sig *tfm)
+{
+	struct cmh_slhdsa_tfm_ctx *ctx = cmh_slhdsa_ctx(tfm);
+
+	/* crypto_sig_keysize() returns bits, not bytes */
+	return slhdsa_pk_size(ctx->param_set) * 8;
+}
+
+static unsigned int cmh_slhdsa_max_size(struct crypto_sig *tfm)
+{
+	struct cmh_slhdsa_tfm_ctx *ctx = cmh_slhdsa_ctx(tfm);
+
+	return slhdsa_get_sig_size(ctx->param_set);
+}
+
+static void cmh_slhdsa_exit(struct crypto_sig *tfm)
+{
+	struct cmh_slhdsa_tfm_ctx *ctx = cmh_slhdsa_ctx(tfm);
+
+	cmh_key_destroy(&ctx->key);
+	kfree(ctx->pub_key);
+	ctx->pub_key = NULL;
+}
+
+/* Generate init functions for all 12 parameter sets */
+#define SLHDSA_INIT(ps_val)						\
+	static int cmh_slhdsa_init_##ps_val(struct crypto_sig *tfm)	\
+	{								\
+		struct cmh_slhdsa_tfm_ctx *ctx = cmh_slhdsa_ctx(tfm);	\
+		memset(ctx, 0, sizeof(*ctx));				\
+		ctx->param_set = ps_val;				\
+		return 0;						\
+	}
+
+SLHDSA_INIT(HCQ_SLHDSA_SHAKE_128S)
+SLHDSA_INIT(HCQ_SLHDSA_SHAKE_128F)
+SLHDSA_INIT(HCQ_SLHDSA_SHAKE_192S)
+SLHDSA_INIT(HCQ_SLHDSA_SHAKE_192F)
+SLHDSA_INIT(HCQ_SLHDSA_SHAKE_256S)
+SLHDSA_INIT(HCQ_SLHDSA_SHAKE_256F)
+SLHDSA_INIT(HCQ_SLHDSA_SHA2_128S)
+SLHDSA_INIT(HCQ_SLHDSA_SHA2_128F)
+SLHDSA_INIT(HCQ_SLHDSA_SHA2_192S)
+SLHDSA_INIT(HCQ_SLHDSA_SHA2_192F)
+SLHDSA_INIT(HCQ_SLHDSA_SHA2_256S)
+SLHDSA_INIT(HCQ_SLHDSA_SHA2_256F)
+
+#define SLHDSA_ALG(name, drv, ps_val) {					\
+		.sign		= cmh_slhdsa_sign,			\
+		.verify		= cmh_slhdsa_verify,			\
+		.set_pub_key	= cmh_slhdsa_set_pub_key,		\
+		.set_priv_key	= cmh_slhdsa_set_priv_key,		\
+		.key_size	= cmh_slhdsa_key_size,			\
+		.max_size	= cmh_slhdsa_max_size,			\
+		.init		= cmh_slhdsa_init_##ps_val,		\
+		.exit		= cmh_slhdsa_exit,			\
+		.base = {						\
+			.cra_name	  = name,			\
+			.cra_driver_name  = drv,			\
+			.cra_priority	  = 300,			\
+			.cra_module	  = THIS_MODULE,		\
+			.cra_ctxsize	  = sizeof(struct cmh_slhdsa_tfm_ctx), \
+		},							\
+	}
+
+static struct sig_alg cmh_slhdsa_algs[] = {
+	SLHDSA_ALG("slh-dsa-shake-128s", "rambus-cmh-slh-dsa-shake-128s", HCQ_SLHDSA_SHAKE_128S),
+	SLHDSA_ALG("slh-dsa-shake-128f", "rambus-cmh-slh-dsa-shake-128f", HCQ_SLHDSA_SHAKE_128F),
+	SLHDSA_ALG("slh-dsa-shake-192s", "rambus-cmh-slh-dsa-shake-192s", HCQ_SLHDSA_SHAKE_192S),
+	SLHDSA_ALG("slh-dsa-shake-192f", "rambus-cmh-slh-dsa-shake-192f", HCQ_SLHDSA_SHAKE_192F),
+	SLHDSA_ALG("slh-dsa-shake-256s", "rambus-cmh-slh-dsa-shake-256s", HCQ_SLHDSA_SHAKE_256S),
+	SLHDSA_ALG("slh-dsa-shake-256f", "rambus-cmh-slh-dsa-shake-256f", HCQ_SLHDSA_SHAKE_256F),
+	SLHDSA_ALG("slh-dsa-sha2-128s",  "rambus-cmh-slh-dsa-sha2-128s",  HCQ_SLHDSA_SHA2_128S),
+	SLHDSA_ALG("slh-dsa-sha2-128f",  "rambus-cmh-slh-dsa-sha2-128f",  HCQ_SLHDSA_SHA2_128F),
+	SLHDSA_ALG("slh-dsa-sha2-192s",  "rambus-cmh-slh-dsa-sha2-192s",  HCQ_SLHDSA_SHA2_192S),
+	SLHDSA_ALG("slh-dsa-sha2-192f",  "rambus-cmh-slh-dsa-sha2-192f",  HCQ_SLHDSA_SHA2_192F),
+	SLHDSA_ALG("slh-dsa-sha2-256s",  "rambus-cmh-slh-dsa-sha2-256s",  HCQ_SLHDSA_SHA2_256S),
+	SLHDSA_ALG("slh-dsa-sha2-256f",  "rambus-cmh-slh-dsa-sha2-256f",  HCQ_SLHDSA_SHA2_256F),
+};
+
+/**
+ * cmh_pqc_slhdsa_register() - Register SLH-DSA akcipher algorithms with the crypto framework
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_pqc_slhdsa_register(void)
+{
+	int ret, i;
+
+	if (!cmh_core_present(CMH_CORE_HCQ))
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(cmh_slhdsa_algs); i++) {
+		ret = crypto_register_sig(&cmh_slhdsa_algs[i]);
+		if (ret) {
+			dev_err(cmh_dev(), "cmh: failed to register %s (%d)\n",
+				cmh_slhdsa_algs[i].base.cra_name, ret);
+			goto err_unregister;
+		}
+	}
+
+	return 0;
+
+err_unregister:
+	while (i--)
+		crypto_unregister_sig(&cmh_slhdsa_algs[i]);
+	return ret;
+}
+
+/**
+ * cmh_pqc_slhdsa_unregister() - Unregister SLH-DSA akcipher algorithms from the crypto framework
+ */
+void cmh_pqc_slhdsa_unregister(void)
+{
+	int i = ARRAY_SIZE(cmh_slhdsa_algs);
+
+	if (!cmh_core_present(CMH_CORE_HCQ))
+		return;
+
+	while (i--)
+		crypto_unregister_sig(&cmh_slhdsa_algs[i]);
+}
diff --git a/drivers/crypto/cmh/cmh_pqc_xmss.c b/drivers/crypto/cmh/cmh_pqc_xmss.c
new file mode 100644
index 000000000000..4e6c464521d6
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pqc_xmss.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- XMSS/XMSS-MT Signature Driver (verify-only, sig_alg, synchronous)
+ *
+ * Registers "xmss" and "xmss-mt" sig algorithms with verify-only
+ * callbacks.  Sign is not supported (stateful signature -- key
+ * management must happen externally).
+ *
+ * Verify: src = raw signature, digest = message bytes
+ * Public key: raw pk bytes (variable length, set via set_pub_key)
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <crypto/sig.h>
+#include <crypto/internal/sig.h>
+
+#include "cmh_sys.h"
+#include "cmh_hcq_abi.h"
+#include "cmh_txn.h"
+#include "cmh_dma.h"
+#include "cmh_pqc.h"
+
+#define XMSS_VCQ_CMDS	3	/* header + cmd + flush */
+
+struct cmh_xmss_tfm_ctx {
+	u8 *pub_key;
+	u32 pub_key_len;
+	u32 xmss_mt;		/* 0 = XMSS, 1 = XMSS-MT */
+};
+
+static inline struct cmh_xmss_tfm_ctx *cmh_xmss_ctx(struct crypto_sig *tfm)
+{
+	return crypto_sig_ctx(tfm);
+}
+
+/*
+ * XMSS/XMSS-MT verify (synchronous sig_alg)
+ *
+ * @src:    raw signature
+ * @slen:   signature length
+ * @digest: message bytes
+ * @dlen:   message length
+ *
+ * Returns 0 on successful verification, negative errno on failure.
+ */
+static int cmh_xmss_verify(struct crypto_sig *tfm,
+			   const void *src, unsigned int slen,
+			   const void *digest, unsigned int dlen)
+{
+	struct cmh_xmss_tfm_ctx *ctx = cmh_xmss_ctx(tfm);
+	struct core_dispatch d = cmh_core_select_instance(CMH_CORE_HCQ);
+	struct vcq_cmd vcq[XMSS_VCQ_CMDS];
+	u8 *sig_buf = NULL, *m_buf = NULL, *pk_buf = NULL;
+	dma_addr_t sig_dma = DMA_MAPPING_ERROR;
+	dma_addr_t m_dma = DMA_MAPPING_ERROR;
+	dma_addr_t pk_dma = DMA_MAPPING_ERROR;
+	int ret;
+
+	if (!ctx->pub_key)
+		return -EINVAL;
+	if (!slen || slen > XMSS_MAX_SIG_LEN)
+		return -EINVAL;
+	if (!dlen || dlen > XMSS_MAX_MSG_LEN)
+		return -EINVAL;
+
+	sig_buf = kmemdup(src, slen, GFP_KERNEL);
+	m_buf = kmemdup(digest, dlen, GFP_KERNEL);
+	pk_buf = kmemdup(ctx->pub_key, ctx->pub_key_len, GFP_KERNEL);
+	if (!sig_buf || !m_buf || !pk_buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	sig_dma = cmh_dma_map_single(sig_buf, slen, DMA_TO_DEVICE);
+	m_dma = cmh_dma_map_single(m_buf, dlen, DMA_TO_DEVICE);
+	pk_dma = cmh_dma_map_single(pk_buf, ctx->pub_key_len, DMA_TO_DEVICE);
+
+	if (cmh_dma_map_error(sig_dma) || cmh_dma_map_error(m_dma) ||
+	    cmh_dma_map_error(pk_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	vcq_set_header(&vcq[0], XMSS_VCQ_CMDS);
+	vcq_add_hcq_xmss_verify(&vcq[1], d.core_id, ctx->xmss_mt,
+				ctx->pub_key_len, slen, dlen,
+				pk_dma, sig_dma, m_dma);
+	vcq_add_hcq_flush(&vcq[2], d.core_id);
+
+	/* XMSS verify traverses Merkle hash chains -- inherently slow */
+	ret = cmh_tm_submit_sync_tmo(vcq, XMSS_VCQ_CMDS, 1, d.mbx_idx,
+				     cmh_tm_slow_op_timeout_jiffies());
+
+out_unmap:
+	if (!cmh_dma_map_error(pk_dma))
+		cmh_dma_unmap_single(pk_dma, ctx->pub_key_len, DMA_TO_DEVICE);
+	if (!cmh_dma_map_error(m_dma))
+		cmh_dma_unmap_single(m_dma, dlen, DMA_TO_DEVICE);
+	if (!cmh_dma_map_error(sig_dma))
+		cmh_dma_unmap_single(sig_dma, slen, DMA_TO_DEVICE);
+
+out_free:
+	kfree(pk_buf);
+	kfree(m_buf);
+	kfree(sig_buf);
+	return ret;
+}
+
+static int cmh_xmss_set_pub_key(struct crypto_sig *tfm,
+				const void *key, unsigned int keylen)
+{
+	struct cmh_xmss_tfm_ctx *ctx = cmh_xmss_ctx(tfm);
+
+	if (!keylen || keylen > XMSS_MAX_PK_LEN)
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
+static unsigned int cmh_xmss_key_size(struct crypto_sig *tfm)
+{
+	struct cmh_xmss_tfm_ctx *ctx = cmh_xmss_ctx(tfm);
+
+	return ctx->pub_key_len * 8;
+}
+
+static int cmh_xmss_init(struct crypto_sig *tfm)
+{
+	struct cmh_xmss_tfm_ctx *ctx = cmh_xmss_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	return 0;
+}
+
+static int cmh_xmss_mt_init(struct crypto_sig *tfm)
+{
+	struct cmh_xmss_tfm_ctx *ctx = cmh_xmss_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->xmss_mt = 1;
+	return 0;
+}
+
+static void cmh_xmss_exit(struct crypto_sig *tfm)
+{
+	struct cmh_xmss_tfm_ctx *ctx = cmh_xmss_ctx(tfm);
+
+	kfree(ctx->pub_key);
+	ctx->pub_key = NULL;
+}
+
+static unsigned int cmh_xmss_max_size(struct crypto_sig *tfm)
+{
+	/* Verify-only; report the max signature length for API parity. */
+	return XMSS_MAX_SIG_LEN;
+}
+
+static struct sig_alg cmh_xmss_algs[] = {
+	{
+		.verify		= cmh_xmss_verify,
+		.set_pub_key	= cmh_xmss_set_pub_key,
+		.key_size	= cmh_xmss_key_size,
+		.max_size	= cmh_xmss_max_size,
+		.init		= cmh_xmss_init,
+		.exit		= cmh_xmss_exit,
+		.base = {
+			.cra_name	  = "xmss",
+			.cra_driver_name  = "rambus-cmh-xmss",
+			.cra_priority	  = 300,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_xmss_tfm_ctx),
+		},
+	},
+	{
+		.verify		= cmh_xmss_verify,
+		.set_pub_key	= cmh_xmss_set_pub_key,
+		.key_size	= cmh_xmss_key_size,
+		.max_size	= cmh_xmss_max_size,
+		.init		= cmh_xmss_mt_init,
+		.exit		= cmh_xmss_exit,
+		.base = {
+			.cra_name	  = "xmss-mt",
+			.cra_driver_name  = "rambus-cmh-xmss-mt",
+			.cra_priority	  = 300,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_xmss_tfm_ctx),
+		},
+	},
+};
+
+/**
+ * cmh_pqc_xmss_register() - Register XMSS/XMSS-MT sig algorithms with the crypto framework
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_pqc_xmss_register(void)
+{
+	int ret, i;
+
+	if (!cmh_core_present(CMH_CORE_HCQ))
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(cmh_xmss_algs); i++) {
+		ret = crypto_register_sig(&cmh_xmss_algs[i]);
+		if (ret) {
+			dev_err(cmh_dev(), "cmh: failed to register %s (%d)\n",
+				cmh_xmss_algs[i].base.cra_name, ret);
+			goto err_unregister;
+		}
+	}
+
+	return 0;
+
+err_unregister:
+	while (i--)
+		crypto_unregister_sig(&cmh_xmss_algs[i]);
+	return ret;
+}
+
+/**
+ * cmh_pqc_xmss_unregister() - Unregister XMSS/XMSS-MT sig algorithms from the crypto framework
+ */
+void cmh_pqc_xmss_unregister(void)
+{
+	int i = ARRAY_SIZE(cmh_xmss_algs);
+
+	if (!cmh_core_present(CMH_CORE_HCQ))
+		return;
+
+	while (i--)
+		crypto_unregister_sig(&cmh_xmss_algs[i]);
+}
-- 
2.43.7

