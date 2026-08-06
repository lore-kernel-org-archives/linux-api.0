Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022122.outbound.protection.outlook.com [40.107.200.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5CF41837C;
	Thu,  6 Aug 2026 19:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046146; cv=fail; b=m1K9VnQ1JIboBu8qbk2EdSTPPG5KhxzsU6gA1Nqlw2Tfzn3q8UTHK47ord1Zj82u5/c6XnRsyk0s3fGCYZcQPq2Q4nLxsB0Oajt2WVyiZ7JpZD0lZsLF7FsBq+nD18A2gWeUpkl4EaUA8Dufkum/EIdvKMf9atb8jnhgPqc3KU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046146; c=relaxed/simple;
	bh=IozKaU5ln276mrQQiP7XT3gepdSCBrC1SntIuHcheok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQpyXN1oMqkkpGmMnu/Ev82Y9we496FTWb8e2FqsTyRu0mLRjOKinnzR176TDht3Rxjh3tZXRFFQ5D+8vYsfXNkpd99EBp/aqb8aZ1nMTieadok3F1tKgy9oh3GmpUi//QV9ik2OHBCzHmm0wECC27QxaH27IrkqKZjrvLghB9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=ErOjhvge; arc=fail smtp.client-ip=40.107.200.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="ErOjhvge"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sVgcHd0RmzyflSqalmZa2Z3xp5tuZHXowqZJOdtWJJ0mihxqPBF/Uc9iiiU9rro7Pb874T/RHV6j7ec1XnOZ+7em5HHGs8zabjcMdrpeWd/UnZEqQOPnSzsI5sHYtcXW4w/1ZAYZ77X6Hizqo0WPnrz15ktWykDju6c7HnPDdTFrJ8koMFqXOBhzBwW2dbrux4vlRJmsyQkiIXOYp/t8q/VDaQqSXO8gQpq1fTij2aydnIpVdfx1v49IPFNPSfqAPlq3tJ3ue0qPbfi13wf3pkgcC0JLYsYcGa2ffqP7EZYpL2x9whFnvjAcmAJ3VPqRfqUnlvvtiMUs1ubpakcxLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7pOKvXPpYU267ok/w4eyECj3E2Ne/BIPSGmFfV7+Bs=;
 b=EIbTwoznjKemyCS0eAQItiGb5zflJSvM9/GDnvaVNkKNDRXv1u/HkH9JDwooDEzzCVmnW3rFay0RRV9CAwE7x1INVqeb2UTEGCELedbO593+sZHAUc87mmVizTCjd7n5V1oVJiZXKzS7MjBChrKoBQ3dOSblOtgWHLTm0ctYoZikuYShLOesFSfLbFRIYSVKNtCkocVFaJyiFbTiEs7+iwoGil/0zHl/0lsCa/Oo/WFH3vuTyNmjgAFvdI3ar8n4j96HXXsQFgJYbrEtjoCkNw4f5n+EFym32xH/2zBOacfV3h8wVYrcjwxmYVNnb0obTLxEMRw3jSP2FUoHuzQRgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7pOKvXPpYU267ok/w4eyECj3E2Ne/BIPSGmFfV7+Bs=;
 b=ErOjhvgeL4HV9+VI3AF4ASugZn31Zs3oTQInOB7uCsBugatXAAzMv4jOXwg8/qpL3jeGnXPBJKXBj/p7A3w/huAt+Takcs+css1U9DeMScLy2uwnK1Uic/E23uXP0lZ2oaad5pREibLknXP4oUtyId6VGtqL3mbqQDGvbdu5emt1j/c4BP1sgb6tmYgHwL+Ai6gfA3t1A7gvOuZTxzy9Di4DFiFwvI6RhTpLBcbyxEpx3gQ349STr7y+PFh4jHZ9DQ80bLVipLnzujYuLbMLGJN/m93lwE3iRyCFMpY99R/MBmWH5S8L293i7gcTWdUT2awOY96ElqEU/gT8yFNRXg==
Received: from MN2PR07CA0018.namprd07.prod.outlook.com (2603:10b6:208:1a0::28)
 by IA3PR04MB9183.namprd04.prod.outlook.com (2603:10b6:208:522::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Thu, 6 Aug
 2026 19:55:30 +0000
Received: from BL02EPF0001A101.namprd05.prod.outlook.com
 (2603:10b6:208:1a0:cafe::67) by MN2PR07CA0018.outlook.office365.com
 (2603:10b6:208:1a0::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.20 via Frontend Transport; Thu, 6
 Aug 2026 19:55:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BL02EPF0001A101.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Thu, 6 Aug 2026 19:55:30 +0000
Received: from hqxsv-cmdev3-skrishnamoorthy.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTPS id 47F74180176C;
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
Subject: [PATCH v3 16/19] crypto: cmh - add SLH-DSA/LMS/XMSS (HCQ)
Date: Thu,  6 Aug 2026 12:55:15 -0700
Message-ID: <20260806195519.2703224-17-skrishnamoorthy@rambus.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A101:EE_|IA3PR04MB9183:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 05bc38de-a515-4752-a798-08def3f4ab52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|376014|7416014|36860700016|18002099003|22082099003|56012099006|11063799006|3023799007|6133799003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	Nkg9RSUZ8rm0woygrK0VB8jkgFnmY2MgF0MM4iwf54CkA39aeoc+F9dp7q5yQ5Fi226WF7aw4Kd8aV3AqP8oQd7Gc360lYtuYCILWXIRVYqMvFomJ+TV1+90dR2skWl5VCEg37K5Sl11Mje4MYGGIAtEyC9CAzETBGxAvPrNA8F+nyl4LZpwGHf8S/YqzUdT7XC9ZNX6IaWumOznJ0Lbvc3ssZ1SotQXwYcx0NgyMC6KmKu786lEuTD65BVuHhRTqYpVKleYJTz6QG24IJsKtU76azbo2lJBdJMADCHi0dQtUtEmoEw+toIwSkubP+RilV5ckNzch3HcqaXUgBsjrTW6iCv5pEwvOXqT9XHSOSyEvGNfnYAbGwnmhS7QUOGOcx8skY7KKqsN/yrqaP1bP3GAIElqEE5pHPRwl7j/gTL3orP+6LufBk+HP/xCohRmYZbUVwGqlcMSL9VTlJNLECs1qKePgE9DkcfaHYm1Us8wXs5y+d3OuIK31f2HnwqQ5WU1Qwqq6LTj8yVc2YcuNlK2LCdtaNLu1I2bB0Z7ucQtBmg3dCi0b6agv08URbV0PkUVH9Q8c74U4DoH0YEf8lhiyn5JHSAAcU5N3DkOxhnkgwexoxB9Pf5BFzF+e3ZVwcIZFHK5M/c39Y74gtAVDXimTzL8iociAp8tdrw5Y/r+vcd4lTWU+txrh4MLlM+OCvrpg1B5kWive7DzQx/qHd+2UcCBFMWUb4zgi+UB/sgC3T7tO6eAkateTkseeBaO
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(376014)(7416014)(36860700016)(18002099003)(22082099003)(56012099006)(11063799006)(3023799007)(6133799003)(10067099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BIfydMObhzgDLgPOaFVV278kj06tbajBvTEh2lOyEhrpqj0o8Bg88um/6Ca0q9Bgi3a1FXj/mPu3nbA4MAbdeJTdFy4Wt1hVGozYzucF6c+xlN8BWf1H6U1ZFvkwO9zMRn5dH2VnFTb/RXjWw8zn6gh6dYOJ+8P2m3o/b/xys1ToRJVjtfWOWH//Io96yKg8SKJMTSz7AgkDec7eRZIBTJ2iflI38w+bWqRvssWEfvIfOThRFnvsO+368jkKW+gIYoMwkeg75ezTc/8ETaCYxr7TWRyyyU6r9kindHaEWSeew1e2OXUSmDjqT4YcxeQ/qmmkHTN8jiVxKKD9pLrWcTO33aH/hHQC3taTT87ZerfBG/ZzIzEleUK3JejTkd2mpLyfo1o2/4AqWjvdFzRGnI+qQQ4udgOVeiR31VaSc0K7fwaT6Fc0arGAih3b3FSG
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 19:55:30.2540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05bc38de-a515-4752-a798-08def3f4ab52
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A101.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9183

From: Alex Ousherovitch <aousherovitch@rambus.com>

Register SLH-DSA, LMS, LMS-HSS, XMSS, and XMSS-MT algorithms
using the CMH HCQ core (core ID 0x08).  SLH-DSA is registered as a
sig algorithm with sign and verify support.  LMS, LMS-HSS, XMSS,
and XMSS-MT are registered as verify-only sig algorithms: their
stateful signing semantics (one-time-key private state the signer
must track) are not modeled by the kernel crypto API, so only
verification is exposed.

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
Reviewed-by: Thi Nguyen <thin@rambus.com>
---
 drivers/crypto/cmh/Makefile         |   6 +-
 drivers/crypto/cmh/cmh_hcq.c        | 313 +++++++++++++++++++++++
 drivers/crypto/cmh/cmh_main.c       |  24 ++
 drivers/crypto/cmh/cmh_pqc_lms.c    | 238 ++++++++++++++++++
 drivers/crypto/cmh/cmh_pqc_slhdsa.c | 377 ++++++++++++++++++++++++++++
 drivers/crypto/cmh/cmh_pqc_xmss.c   | 238 ++++++++++++++++++
 6 files changed, 1195 insertions(+), 1 deletion(-)
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
index 74d2b3672d2a..3008d623eb04 100644
--- a/drivers/crypto/cmh/cmh_main.c
+++ b/drivers/crypto/cmh/cmh_main.c
@@ -343,6 +343,21 @@ static int cmh_probe(struct platform_device *pdev)
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
@@ -355,6 +370,12 @@ static int cmh_probe(struct platform_device *pdev)
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
@@ -419,6 +440,9 @@ static void cmh_remove(struct platform_device *pdev)
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
index 000000000000..3a17ca478660
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pqc_lms.c
@@ -0,0 +1,238 @@
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
+	while (i--)
+		crypto_unregister_sig(&cmh_lms_algs[i]);
+}
diff --git a/drivers/crypto/cmh/cmh_pqc_slhdsa.c b/drivers/crypto/cmh/cmh_pqc_slhdsa.c
new file mode 100644
index 000000000000..4bec4278cd9c
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pqc_slhdsa.c
@@ -0,0 +1,377 @@
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
+	while (i--)
+		crypto_unregister_sig(&cmh_slhdsa_algs[i]);
+}
diff --git a/drivers/crypto/cmh/cmh_pqc_xmss.c b/drivers/crypto/cmh/cmh_pqc_xmss.c
new file mode 100644
index 000000000000..50de1ef0f488
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pqc_xmss.c
@@ -0,0 +1,238 @@
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
+	while (i--)
+		crypto_unregister_sig(&cmh_xmss_algs[i]);
+}
-- 
2.43.7

