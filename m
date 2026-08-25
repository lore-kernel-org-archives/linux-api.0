Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021135.outbound.protection.outlook.com [40.93.194.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF43249504E;
	Tue, 25 Aug 2026 22:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696170; cv=fail; b=nT65qUoutPY9Eo9C9gonkfxmdVZcEoFzer0K6pShbcVk+T209cwTKl+0jLNv/Bno8gwvVo4XPmj1XGFzqBtBFwUyWX3Jejuo0R7GcBeHR9LX0UO8cqYTDl63QtAkXamuTIhPM7ABeXh+W4dZ5MU7h31XItw5D3gxAlzMc6Vas0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696170; c=relaxed/simple;
	bh=1B2gta500JZeA+yoUjbExcL7NVm2RNYOZohnml9gM60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BdF0HpHoKYxnuTmVEp8Z9bB6MHQbmPAk+Wj4u6oOJc8ipR98zCHTv/DtsxsrVbtnNFNYdKFnq023AcdIwnJLVIoQkrBD0aKJ7PVCrd2x27xrU8rqk2ym/zvXkx6esmy609trDqT54sRFt3/V5yI9V2IVfu7XGyTcLiiwJRmW2OM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=4V2KL3lQ; arc=fail smtp.client-ip=40.93.194.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="4V2KL3lQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sKnJTf3zXnviB0WYpyGiylkTLZBaMNJGTGaw6WX07D/2blAwTcGa6DyMRdXK0lRzaaZIww1a2vKSqsah5dR2frsmjOWdaFdZjLK2qtP0KvODpJF9UZ8ReqHJtHsncyUnk4bmz8XXv+r67jOxOiFqgfEZq4G+tqQyyhlKAA0WNSpjMC+ou0r+lmNGaSoQ+9yUdqdalHeSQfPLAQwJFy1ndND50O9H+1QHznOHfcwV5Za5sGKM9E2zilZnCnQNb7fbPHWCWtHGKxeddLtzHoeKRHOuk1J8V0cFSjZJLA/C6S9593xqRZiKYp1D2MPfHSvxA0I7CqIfTO1TgT0EWfetjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X2VX9lKohkPpnh4eRIAnB5oaBaH3obl+RR6aSz4YAPk=;
 b=H+7ZrYNAKtJngmzOpiCoZxMupuEsSrfQ/NKu4f9KUEWnpF+hORk8tfeQJRTTaJRo/wkqMVzMrh7jI3/qkBEhr//AaEMt5RoYZNptbRxmorg/tIipEJrggd4/9AhJMSFHxKP8mXDMsCF2PPXMdOxaOOx4vX0e87FM1p6kcv8TR/vHuGg5haD7T2cllRyqFj5qXwBmeNaLNgRGkEBsY0VHutc9lTZsFm8LQzf2EoosKjC6I0oxUBz8GraHZXILNef1wiRDg9G3GoYZ0rxj9ujyXRNJ/Cok/Jot3/MQr0kr83FAeNWa2yrKPs7lPWKzDl7hGOsWsIC86Ewra7+ZJtZ0Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2VX9lKohkPpnh4eRIAnB5oaBaH3obl+RR6aSz4YAPk=;
 b=4V2KL3lQGkzukKbapHfEVVX8J6GZbdkiW+eKuHYPGn2iUrZx3PBo62PQrDXaseS5Vi15rEjs5irlyXfLJonobHY79paot7nKXcvoRAKpRqhiHVBN7QDGQpyff9pXiL7R3AclgiNdwTel8hQlpG8Gd7xKUTF9OxDq5oIaPXLEBc05ClOswSCbjIfCBPO/E1ntiDNgtkIzGTaUYoGrgqh8rGaxZ4nP8PWt6kjMec5BQf9JdIfBNnX8Rx1J1b0vI7g1VSL8dhJBRVZk2aJ5gV4qBK3mgFI9FuaRt+7x9KvkHVX0c3ygF2N2NybgQPLNpo8bQ1FbSE2UQgQjll5GoOji3w==
Received: from SJ0PR13CA0154.namprd13.prod.outlook.com (2603:10b6:a03:2c7::9)
 by SA1PR04MB8887.namprd04.prod.outlook.com (2603:10b6:806:386::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Tue, 25 Aug
 2026 22:15:55 +0000
Received: from BY1PEPF0001AE17.namprd04.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::99) by SJ0PR13CA0154.outlook.office365.com
 (2603:10b6:a03:2c7::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.7 via Frontend Transport; Tue, 25
 Aug 2026 22:15:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy01.rambus.com; pr=C
Received: from hqxsv-psmtppxy01.rambus.com (192.86.86.210) by
 BY1PEPF0001AE17.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 22:15:52 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy01.rambus.com (Postfix) with ESMTP id 88A8B180176C;
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
Subject: [PATCH v4 13/19] crypto: cmh - add ECDSA/SM2 sig
Date: Tue, 25 Aug 2026 15:15:32 -0700
Message-ID: <20260825221539.255951-14-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE17:EE_|SA1PR04MB8887:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 0af3d043-fcad-4b02-fc6e-08df02f66d26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|1800799024|82310400026|376014|36860700016|22082099003|18002099003|56012099006|3023799007|11063799006|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	if0esJTwbDlLV7gHqX6L2F8XwAT+OwmiKSsuXsSjKU7apsjBXzMQ4RIXSLHFZcGP4hYwFQiB2loMarczywsTWEOtU7fsnER0ukkZT+pUpJT9poDbqsmTe/nDVxs2O4WW92HRKSoNsYetL2lMdiixl9qnBrhrYFazJe+HV8m5WG51qPwZ8h8G2bZH21KEsSg38C6mq4f6WyaZm6mZTg3FAuPK052Z9l0d6DV7SpiQLwy48JaICxyHKUE7brpmOW9iEpPhlw8TZ/7Ry/oj/yua4mxew+ZbnlAARP/u0+06+YOgEG2a2Q6GXMfyapZPUcBqi5HvWhIxYFa1a3BzzRTir5IGTc489Tn/JSKrJLYTU4BQjLwLskG++hf7tG7QuOL/OG9t1q/rbPUgEc4KZxsnyJNvzepM2hd6QZjO3Z6N8hIN64GJnhwaPrqM5xx49BNX5K3hTwhmX2PLzhQwDG+W6G3ho9LBETsqlJLNh6Fk7JA7tyvv3g1mFyOzBDNGl+R6RzqRWo2N1nA9VuwrGGPua/sJwzlGFY3Ck/sW5S+BV1aWxIpsYsWMkh3jdgdrtTQJhepHcP5ths/LM5kzHOeeTHZR3+w4lo55p7ZTIvZuX5favVZ2woe4Z/MJVuvwrgH0T16gFhpR+iYXd1cNKiToIih6EkSkH5FkRF0sgZF+K27BpC4Ki/6e7L7e6NALv1rQaSlRAWZWNC1UF9IDUPoiaQt19g9MMaVCSVD207jt7icOXScK6SyxgE5Dcb8wGo7l
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy01.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(82310400026)(376014)(36860700016)(22082099003)(18002099003)(56012099006)(3023799007)(11063799006)(10067099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aMMLYhwq9VtwZ3Jy8y1/3I9tOfnN0zKZ8aIUQPOfw8hNTK028vmh6raKbLYoeFKXDAlWtwthGqzYuz/xlULGTMA6Ku+xsp5edkxv8+tpmx0rTyXKP6vXcIUhzjgPMTP/1OMjjV3CicTKYR5gUvv3/5FrHVBjZWZhBfrf59/cpCBv1KoOMJ5VD0PIJosXRGp5W2MhmZH+VYsmLTBQm0jjkXx43S5CdN8uRtD8wPIV/uwuHFHm715Fv5zW1En/sD9WjnqZt0Bb5g2ji/4y02Ekhl2iRIfAXUIIruRSYNS+EK5eV1+AJYqS5IPdog3nhdpOFdjDNYGsbW5h79awhyTTMlklQtgpKoosB8xCVK3HX5Hz061LNAAz+m+UIyeQl8sNXxDmgktvcZILuW9V+488/Uy3v+XvlD9GoMap2IaVPTxerrqmYmy2HYJSE6jKMrc1
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 22:15:52.5894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af3d043-fcad-4b02-fc6e-08df02f66d26
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy01.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE17.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB8887

Register ECDSA and SM2 sig algorithms using the CMH PKE core.
Supports P-256, P-384, P-521, and SM2 curves for sign and verify
operations.  SM2 is registered as verify-only via the crypto API;
full SM2 operations (encrypt, decrypt, key exchange) are available
through the /dev/cmh_mgmt ioctl interface.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 drivers/crypto/cmh/Makefile        |   3 +-
 drivers/crypto/cmh/cmh_main.c      |   8 +
 drivers/crypto/cmh/cmh_pke_ecdsa.c | 610 +++++++++++++++++++++++++++++
 3 files changed, 620 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/cmh/cmh_pke_ecdsa.c

diff --git a/drivers/crypto/cmh/Makefile b/drivers/crypto/cmh/Makefile
index cdbcc8cdac5f..ae1f74a93e99 100644
--- a/drivers/crypto/cmh/Makefile
+++ b/drivers/crypto/cmh/Makefile
@@ -31,7 +31,8 @@ cmh-y := \
 	cmh_ccp_poly.o \
 	cmh_rng.o \
 	cmh_pke_common.o \
-	cmh_pke_rsa.o
+	cmh_pke_rsa.o \
+	cmh_pke_ecdsa.o
 
 # Management ioctl device (/dev/cmh_mgmt): key lifecycle, PKE, PQC ioctls.
 cmh-$(CONFIG_CRYPTO_DEV_CMH_MGMT) += \
diff --git a/drivers/crypto/cmh/cmh_main.c b/drivers/crypto/cmh/cmh_main.c
index 23346bbf11b0..b5b12f56a68e 100644
--- a/drivers/crypto/cmh/cmh_main.c
+++ b/drivers/crypto/cmh/cmh_main.c
@@ -292,6 +292,11 @@ static int cmh_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_pke_rsa_register;
 
+	/* Register PKE ECDSA/SM2 sig */
+	ret = cmh_pke_ecdsa_register();
+	if (ret)
+		goto err_pke_ecdsa_register;
+
 	/* Register key management device (/dev/cmh_mgmt) */
 	ret = cmh_mgmt_register();
 	if (ret)
@@ -302,6 +307,8 @@ static int cmh_probe(struct platform_device *pdev)
 	return 0;
 
 err_mgmt_register:
+	cmh_pke_ecdsa_unregister();
+err_pke_ecdsa_register:
 	cmh_pke_rsa_unregister();
 err_pke_rsa_register:
 	cmh_ccp_poly_unregister();
@@ -360,6 +367,7 @@ static void cmh_remove(struct platform_device *pdev)
 	cfg = &dev->config;
 
 	cmh_mgmt_unregister();
+	cmh_pke_ecdsa_unregister();
 	cmh_pke_rsa_unregister();
 	cmh_ccp_poly_unregister();
 	cmh_ccp_aead_unregister();
diff --git a/drivers/crypto/cmh/cmh_pke_ecdsa.c b/drivers/crypto/cmh/cmh_pke_ecdsa.c
new file mode 100644
index 000000000000..a23828750368
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_pke_ecdsa.c
@@ -0,0 +1,610 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- ECDSA / SM2 Signature Driver (sig_alg, synchronous)
+ *
+ * Registers "ecdsa-nist-p256", "ecdsa-nist-p384", and "ecdsa-nist-p521"
+ * sig algorithms with sign, verify, set_pub_key, and set_priv_key callbacks.
+ * Registers "sm2" as verify-only (set_pub_key + verify); SM2 sign is
+ * provided via the cmh_mgmt ioctl path in cmh_pke_sm2.c.
+ *
+ * In-kernel consumers typically use verify-only (module signatures, IMA),
+ * but we provide sign as well for completeness -- matching the CMH eSW
+ * capability.
+ *
+ * Key format: Public key = raw 04 || X || Y (uncompressed).
+ * Signature format: struct ecdsa_raw_sig (two u64[ECC_MAX_DIGITS] arrays
+ * in VLI format -- native byte order, LE digit order) for both sign
+ * output and verify input.  This matches the kernel crypto sig API.
+ *
+ * Private key via cmh_key_ctx: raw keys written via SYS_REF_TEMP.
+ * Datastore-referenced keys are only reachable through the ioctl
+ * path (cmh_mgmt.c).
+ *
+ * SM2 note: The SM2 sig entry is verify-only (no sign/set_priv_key).
+ * SM2 signature verification requires the digest to be SM3(ZA || M)
+ * where ZA = SM3(ENTLA || IDA || a || b || xG || yG || xA || yA).
+ * The ZA identity pre-hash is the caller's responsibility; the driver
+ * passes the digest directly to the CMH eSW SM2 verify engine.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <crypto/sha2.h>
+#include <crypto/sig.h>
+#include <crypto/internal/sig.h>
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
+ * Number of ECC digits needed for a given coordinate byte length.
+ * P-256: 4, P-384: 6, P-521/SM2(clen=68): 9.
+ */
+static inline unsigned int clen_to_ndigits(u32 clen)
+{
+	return DIV_ROUND_UP(clen, sizeof(u64));
+}
+
+struct cmh_ecdsa_tfm_ctx {
+	struct cmh_key_ctx key;		/* private key (raw only) */
+	u8 *pub_key;			/* uncompressed (x, y) without 04 prefix */
+	u32 pub_key_len;
+	u32 curve;			/* PKE_CURVE_* */
+	u32 clen;			/* coordinate length in bytes */
+};
+
+static inline struct cmh_ecdsa_tfm_ctx *cmh_ecdsa_ctx(struct crypto_sig *tfm)
+{
+	return crypto_sig_ctx(tfm);
+}
+
+/*
+ * Convert one VLI component (u64 array, LE digit order, native byte order)
+ * to big-endian byte array of @out_len bytes.  The VLI value is right-aligned
+ * in the output (leading zero padding added if ndigits*8 < out_len).  If the
+ * VLI is wider than @out_len, the skipped leading bytes must be zero; a
+ * non-zero leading byte is malformed caller input and returns -EBADMSG.
+ *
+ * Return: 0 on success, -EBADMSG if the value does not fit in @out_len.
+ */
+static int ecdsa_vli_to_be(const u64 *vli, unsigned int ndigits,
+			   u8 *out, unsigned int out_len)
+{
+	unsigned int full_len = ndigits * sizeof(u64);
+	unsigned int i, skip;
+
+	memset(out, 0, out_len);
+
+	if (full_len <= out_len) {
+		/* VLI fits entirely -- write at right end of out */
+		u8 *dst = out + (out_len - full_len);
+
+		for (i = 0; i < ndigits; i++)
+			put_unaligned_be64(vli[ndigits - 1 - i],
+					   &dst[i * sizeof(u64)]);
+	} else {
+		/*
+		 * VLI wider than out -- the skipped leading bytes MUST be
+		 * zero.  This runs on caller-supplied signature data, so a
+		 * non-zero high byte is malformed input: reject it with
+		 * -EBADMSG rather than WARN_ON_ONCE (which would let an
+		 * unprivileged caller trip panic_on_warn).
+		 */
+		u8 tmp[ECC_MAX_BYTES];
+
+		for (i = 0; i < ndigits; i++)
+			put_unaligned_be64(vli[ndigits - 1 - i],
+					   &tmp[i * sizeof(u64)]);
+		skip = full_len - out_len;
+		if (memchr_inv(tmp, 0, skip))
+			return -EBADMSG;
+		memcpy(out, tmp + skip, out_len);
+	}
+
+	return 0;
+}
+
+/*
+ * Convert big-endian byte array to VLI (u64 array, LE digit order).
+ * Output is zero-filled to @max_digits entries.
+ */
+static void ecdsa_be_to_vli(const u8 *in, unsigned int in_len,
+			    u64 *vli, unsigned int max_digits)
+{
+	u8 tmp[ECC_MAX_BYTES];
+	unsigned int full_len;
+	unsigned int i;
+
+	if (WARN_ON_ONCE(max_digits > ECC_MAX_DIGITS))
+		max_digits = ECC_MAX_DIGITS;
+
+	full_len = max_digits * sizeof(u64);
+
+	memset(tmp, 0, full_len);
+	if (in_len <= full_len)
+		memcpy(tmp + (full_len - in_len), in, in_len);
+	else
+		memcpy(tmp, in + (in_len - full_len), full_len);
+
+	for (i = 0; i < max_digits; i++) {
+		unsigned int off = (max_digits - 1 - i) * sizeof(u64);
+
+		vli[i] = get_unaligned_be64(&tmp[off]);
+	}
+}
+
+/*
+ * Extract raw (r || s) big-endian byte arrays from struct ecdsa_raw_sig.
+ * Each component is written as @clen bytes into @raw_rs.
+ */
+static int ecdsa_sig_to_raw(const void *src, unsigned int slen,
+			    u8 *raw_rs, u32 clen)
+{
+	const struct ecdsa_raw_sig *sig = src;
+	unsigned int ndigits = clen_to_ndigits(clen);
+	int ret;
+
+	if (slen != sizeof(struct ecdsa_raw_sig))
+		return -EINVAL;
+
+	ret = ecdsa_vli_to_be(sig->r, ndigits, raw_rs, clen);
+	if (ret)
+		return ret;
+	return ecdsa_vli_to_be(sig->s, ndigits, raw_rs + clen, clen);
+}
+
+/*
+ * Encode raw (r || s) big-endian byte arrays into struct ecdsa_raw_sig.
+ * Returns sizeof(struct ecdsa_raw_sig) on success.
+ */
+static int ecdsa_raw_to_sig(const u8 *raw_rs, u32 clen,
+			    void *dst, unsigned int dlen)
+{
+	struct ecdsa_raw_sig *sig = dst;
+
+	if (dlen < sizeof(struct ecdsa_raw_sig))
+		return -ENOSPC;
+
+	memset(sig, 0, sizeof(*sig));
+	ecdsa_be_to_vli(raw_rs, clen, sig->r, ECC_MAX_DIGITS);
+	ecdsa_be_to_vli(raw_rs + clen, clen, sig->s, ECC_MAX_DIGITS);
+	return sizeof(struct ecdsa_raw_sig);
+}
+
+/*
+ * ECDSA verify (synchronous sig_alg)
+ *
+ * @src:    struct ecdsa_raw_sig (VLI format)
+ * @slen:   signature length (must be sizeof(struct ecdsa_raw_sig))
+ * @digest: hash digest
+ * @dlen:   digest length
+ *
+ * Returns 0 on successful verification, negative errno on failure.
+ */
+static int cmh_ecdsa_verify(struct crypto_sig *tfm,
+			    const void *src, unsigned int slen,
+			    const void *digest, unsigned int dlen)
+{
+	struct cmh_ecdsa_tfm_ctx *ctx = cmh_ecdsa_ctx(tfm);
+	u32 clen = ctx->clen;
+	u32 sig_raw_len = 2 * clen;
+	u32 copy_len = min_t(u32, dlen, clen);
+	struct core_dispatch d = cmh_core_select_instance(CMH_CORE_PKE);
+	struct vcq_cmd vcq[PKE_VCQ_CMDS_MIN];
+	u8 *sig_raw = NULL, *dig_buf = NULL, *pk_buf = NULL, *rp_buf = NULL;
+	dma_addr_t pk_dma, dig_dma, sig_dma, rp_dma;
+	int ret;
+
+	if (!ctx->pub_key)
+		return -EINVAL;
+
+	sig_raw = kzalloc(sig_raw_len, GFP_KERNEL);
+	dig_buf = kzalloc(clen, GFP_KERNEL);
+	pk_buf = kmemdup(ctx->pub_key, ctx->pub_key_len, GFP_KERNEL);
+	rp_buf = kzalloc(clen, GFP_KERNEL);
+	if (!sig_raw || !dig_buf || !pk_buf || !rp_buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	/* Extract raw (r, s) big-endian from VLI signature */
+	ret = ecdsa_sig_to_raw(src, slen, sig_raw, clen);
+	if (ret)
+		goto out_free;
+
+	/*
+	 * Truncate or zero-pad digest to clen bytes, right-aligned.
+	 * Matches ECDSA bits2int: use leftmost min(dlen, clen) bytes,
+	 * zero-pad on the left when dlen < clen.
+	 */
+	memcpy(dig_buf + (clen - copy_len), digest, copy_len);
+
+	pk_dma = cmh_dma_map_single(pk_buf, ctx->pub_key_len, DMA_TO_DEVICE);
+	dig_dma = cmh_dma_map_single(dig_buf, clen, DMA_TO_DEVICE);
+	sig_dma = cmh_dma_map_single(sig_raw, sig_raw_len, DMA_TO_DEVICE);
+	rp_dma = cmh_dma_map_single(rp_buf, clen, DMA_FROM_DEVICE);
+
+	if (cmh_dma_map_error(pk_dma) || cmh_dma_map_error(dig_dma) ||
+	    cmh_dma_map_error(sig_dma) || cmh_dma_map_error(rp_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	vcq_set_header(&vcq[0], PKE_VCQ_CMDS_MIN);
+	vcq_add_pke_ecdsa_verify(&vcq[1], d.core_id, ctx->curve, clen,
+				 pk_dma, dig_dma, sig_dma, rp_dma,
+				 pke_swap_flags(ctx->curve));
+	vcq_add_pke_flush(&vcq[2], d.core_id);
+
+	ret = cmh_tm_submit_sync_mbx(vcq, PKE_VCQ_CMDS_MIN, 1, d.mbx_idx);
+
+out_unmap:
+	if (!cmh_dma_map_error(rp_dma))
+		cmh_dma_unmap_single(rp_dma, clen, DMA_FROM_DEVICE);
+	if (!cmh_dma_map_error(sig_dma))
+		cmh_dma_unmap_single(sig_dma, sig_raw_len, DMA_TO_DEVICE);
+	if (!cmh_dma_map_error(dig_dma))
+		cmh_dma_unmap_single(dig_dma, clen, DMA_TO_DEVICE);
+	if (!cmh_dma_map_error(pk_dma))
+		cmh_dma_unmap_single(pk_dma, ctx->pub_key_len, DMA_TO_DEVICE);
+
+out_free:
+	kfree(rp_buf);
+	kfree(pk_buf);
+	kfree(sig_raw);
+	kfree(dig_buf);
+	return ret;
+}
+
+/*
+ * ECDSA sign (synchronous sig_alg)
+ *
+ * @src:  hash digest
+ * @slen: digest length
+ * @dst:  output buffer for struct ecdsa_raw_sig (VLI format)
+ * @dlen: output buffer length
+ *
+ * Returns sizeof(struct ecdsa_raw_sig) on success, negative errno on failure.
+ */
+static int cmh_ecdsa_sign(struct crypto_sig *tfm,
+			  const void *src, unsigned int slen,
+			  void *dst, unsigned int dlen)
+{
+	struct cmh_ecdsa_tfm_ctx *ctx = cmh_ecdsa_ctx(tfm);
+	u32 clen = ctx->clen;
+	u32 sig_raw_len = 2 * clen;
+	u32 copy_len = min_t(u32, slen, clen);
+	struct core_dispatch dd;
+	struct vcq_cmd vcq[PKE_VCQ_CMDS_MAX];
+	u8 *dig_buf = NULL, *sig_buf = NULL;
+	dma_addr_t dig_dma, sig_dma;
+	int ret, idx;
+
+	if (ctx->key.mode != CMH_KEY_RAW)
+		return -EINVAL;
+	if (dlen < sizeof(struct ecdsa_raw_sig))
+		return -EINVAL;
+
+	dig_buf = kzalloc(clen, GFP_KERNEL);
+	sig_buf = kzalloc(sig_raw_len, GFP_KERNEL);
+	if (!dig_buf || !sig_buf) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	/*
+	 * Truncate or zero-pad digest to clen bytes, right-aligned.
+	 * Matches ECDSA bits2int: use leftmost min(slen, clen) bytes,
+	 * zero-pad on the left when slen < clen.
+	 */
+	memcpy(dig_buf + (clen - copy_len), src, copy_len);
+
+	dig_dma = cmh_dma_map_single(dig_buf, clen, DMA_TO_DEVICE);
+	sig_dma = cmh_dma_map_single(sig_buf, sig_raw_len, DMA_FROM_DEVICE);
+
+	if (cmh_dma_map_error(dig_dma) || cmh_dma_map_error(sig_dma)) {
+		ret = -ENOMEM;
+		goto out_unmap;
+	}
+
+	dd = cmh_core_select_instance(CMH_CORE_PKE);
+
+	idx = 1;
+	vcq_add_sys_write(&vcq[idx], SYS_REF_TEMP, ctx->key.raw.dma,
+			  SYS_REF_NONE, ctx->key.raw.len,
+			  ctx->key.raw.sys_type);
+	vcq[idx].id |= pke_swap_flags(ctx->curve);
+	idx++;
+	vcq_add_pke_ecdsa_sign(&vcq[idx++], dd.core_id, ctx->curve, clen,
+			       dig_dma, sig_dma, SYS_REF_TEMP,
+			       clen, pke_swap_flags(ctx->curve));
+	vcq_add_pke_flush(&vcq[idx++], dd.core_id);
+	vcq_set_header(&vcq[0], idx);
+
+	ret = cmh_tm_submit_sync_mbx(vcq, idx, 1, dd.mbx_idx);
+	if (!ret) {
+		/* Sync bounce buffer so CPU sees the DMA-written signature */
+		cmh_dma_sync_for_cpu(sig_dma, sig_raw_len, DMA_FROM_DEVICE);
+
+		/* Encode raw (r||s) into VLI ecdsa_raw_sig for kernel API */
+		ret = ecdsa_raw_to_sig(sig_buf, clen, dst, dlen);
+	}
+
+out_unmap:
+	if (!cmh_dma_map_error(sig_dma))
+		cmh_dma_unmap_single(sig_dma, sig_raw_len, DMA_FROM_DEVICE);
+	if (!cmh_dma_map_error(dig_dma))
+		cmh_dma_unmap_single(dig_dma, clen, DMA_TO_DEVICE);
+
+out_free:
+	kfree(sig_buf);
+	kfree(dig_buf);
+	return ret;
+}
+
+static int cmh_ecdsa_set_pub_key(struct crypto_sig *tfm,
+				 const void *key, unsigned int keylen)
+{
+	struct cmh_ecdsa_tfm_ctx *ctx = cmh_ecdsa_ctx(tfm);
+	const u8 *d = key;
+	u32 clen = ctx->clen;
+	u32 raw_clen;
+
+	/* Accept 04 || X || Y (uncompressed point) */
+	if (keylen < 1 || d[0] != 0x04)
+		return -EINVAL;
+	d++;
+	keylen--;
+
+	if (keylen & 1)
+		return -EINVAL;
+	raw_clen = keylen / 2;
+
+	/*
+	 * Kernel passes ceil(bits/8) per coordinate (e.g. 66 for P-521),
+	 * but our HW ABI uses clen (ALIGN(66,4)=68 for P-521).
+	 * Accept raw_clen <= clen and zero-pad on the left.
+	 */
+	if (raw_clen > clen || raw_clen == 0)
+		return -EINVAL;
+
+	kfree(ctx->pub_key);
+	ctx->pub_key = NULL;
+	ctx->pub_key_len = 0;
+
+	ctx->pub_key = kzalloc(2 * clen, GFP_KERNEL);
+	if (!ctx->pub_key)
+		return -ENOMEM;
+
+	/* Right-align each coordinate to clen bytes */
+	memcpy(ctx->pub_key + (clen - raw_clen), d, raw_clen);
+	memcpy(ctx->pub_key + clen + (clen - raw_clen), d + raw_clen,
+	       raw_clen);
+	ctx->pub_key_len = 2 * clen;
+	return 0;
+}
+
+static int cmh_ecdsa_set_priv_key(struct crypto_sig *tfm,
+				  const void *key, unsigned int keylen)
+{
+	struct cmh_ecdsa_tfm_ctx *ctx = cmh_ecdsa_ctx(tfm);
+	u32 clen = ctx->clen;
+	u32 api_len = DIV_ROUND_UP(pke_curve_bits(ctx->curve), 8);
+	u8 padded[ECC_MAX_BYTES];
+	int ret;
+
+	/*
+	 * The crypto sig API passes the scalar as ceil(field_bits/8) bytes
+	 * (e.g. 66 for P-521), which may be shorter than the HW width clen
+	 * (ALIGN(.,4) = 68 for P-521).  Accept exactly that width and
+	 * left-pad to clen.  A strict "keylen == clen" wrongly rejected the
+	 * valid 66-byte P-521 key; accepting "keylen <= clen" wrongly
+	 * admitted malformed short keys.
+	 */
+	if (keylen != api_len)
+		return -EINVAL;
+
+	if (keylen == clen)
+		return cmh_key_setkey_raw(&ctx->key, key, keylen, CORE_ID_PKE);
+
+	memset(padded, 0, clen);
+	memcpy(padded + (clen - keylen), key, keylen);
+	ret = cmh_key_setkey_raw(&ctx->key, padded, clen, CORE_ID_PKE);
+	memzero_explicit(padded, clen);
+	return ret;
+}
+
+static unsigned int cmh_ecdsa_key_size(struct crypto_sig *tfm)
+{
+	struct cmh_ecdsa_tfm_ctx *ctx = cmh_ecdsa_ctx(tfm);
+
+	/* crypto_sig_keysize() returns bits, not bytes */
+	return pke_curve_bits(ctx->curve);
+}
+
+static unsigned int cmh_ecdsa_max_size(struct crypto_sig *tfm)
+{
+	return sizeof(struct ecdsa_raw_sig);
+}
+
+static unsigned int cmh_ecdsa_digest_size(struct crypto_sig *tfm)
+{
+	/*
+	 * Accept digests up to SHA-512 (64 bytes).  Digests longer
+	 * than the curve order are truncated per ECDSA bits2int.
+	 * Matches kernel ecdsa_digest_size().
+	 */
+	return SHA512_DIGEST_SIZE;
+}
+
+static int cmh_ecdsa_p256_init(struct crypto_sig *tfm)
+{
+	struct cmh_ecdsa_tfm_ctx *ctx = cmh_ecdsa_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->curve = PKE_CURVE_P256;
+	ctx->clen = pke_curve_clen(PKE_CURVE_P256);
+	return 0;
+}
+
+static int cmh_ecdsa_p384_init(struct crypto_sig *tfm)
+{
+	struct cmh_ecdsa_tfm_ctx *ctx = cmh_ecdsa_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->curve = PKE_CURVE_P384;
+	ctx->clen = pke_curve_clen(PKE_CURVE_P384);
+	return 0;
+}
+
+static int cmh_ecdsa_p521_init(struct crypto_sig *tfm)
+{
+	struct cmh_ecdsa_tfm_ctx *ctx = cmh_ecdsa_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->curve = PKE_CURVE_P521;
+	ctx->clen = pke_curve_clen(PKE_CURVE_P521);
+	return 0;
+}
+
+static int cmh_sm2_init(struct crypto_sig *tfm)
+{
+	struct cmh_ecdsa_tfm_ctx *ctx = cmh_ecdsa_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->curve = PKE_CURVE_SM2;
+	ctx->clen = pke_curve_clen(PKE_CURVE_SM2);
+	return 0;
+}
+
+static void cmh_ecdsa_exit(struct crypto_sig *tfm)
+{
+	struct cmh_ecdsa_tfm_ctx *ctx = cmh_ecdsa_ctx(tfm);
+
+	cmh_key_destroy(&ctx->key);
+	kfree(ctx->pub_key);
+	ctx->pub_key = NULL;
+}
+
+static struct sig_alg cmh_ecdsa_algs[] = {
+	{
+		.sign		= cmh_ecdsa_sign,
+		.verify		= cmh_ecdsa_verify,
+		.set_pub_key	= cmh_ecdsa_set_pub_key,
+		.set_priv_key	= cmh_ecdsa_set_priv_key,
+		.key_size	= cmh_ecdsa_key_size,
+		.max_size	= cmh_ecdsa_max_size,
+		.digest_size	= cmh_ecdsa_digest_size,
+		.init		= cmh_ecdsa_p256_init,
+		.exit		= cmh_ecdsa_exit,
+		.base = {
+			.cra_name	  = "ecdsa-nist-p256",
+			.cra_driver_name  = "rambus-cmh-ecdsa-nist-p256",
+			.cra_priority	  = 300,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_ecdsa_tfm_ctx),
+		},
+	},
+	{
+		.sign		= cmh_ecdsa_sign,
+		.verify		= cmh_ecdsa_verify,
+		.set_pub_key	= cmh_ecdsa_set_pub_key,
+		.set_priv_key	= cmh_ecdsa_set_priv_key,
+		.key_size	= cmh_ecdsa_key_size,
+		.max_size	= cmh_ecdsa_max_size,
+		.digest_size	= cmh_ecdsa_digest_size,
+		.init		= cmh_ecdsa_p384_init,
+		.exit		= cmh_ecdsa_exit,
+		.base = {
+			.cra_name	  = "ecdsa-nist-p384",
+			.cra_driver_name  = "rambus-cmh-ecdsa-nist-p384",
+			.cra_priority	  = 300,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_ecdsa_tfm_ctx),
+		},
+	},
+	{
+		.sign		= cmh_ecdsa_sign,
+		.verify		= cmh_ecdsa_verify,
+		.set_pub_key	= cmh_ecdsa_set_pub_key,
+		.set_priv_key	= cmh_ecdsa_set_priv_key,
+		.key_size	= cmh_ecdsa_key_size,
+		.max_size	= cmh_ecdsa_max_size,
+		.digest_size	= cmh_ecdsa_digest_size,
+		.init		= cmh_ecdsa_p521_init,
+		.exit		= cmh_ecdsa_exit,
+		.base = {
+			.cra_name	  = "ecdsa-nist-p521",
+			.cra_driver_name  = "rambus-cmh-ecdsa-nist-p521",
+			.cra_priority	  = 300,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_ecdsa_tfm_ctx),
+		},
+	},
+	{
+		.verify		= cmh_ecdsa_verify,
+		.set_pub_key	= cmh_ecdsa_set_pub_key,
+		.key_size	= cmh_ecdsa_key_size,
+		.max_size	= cmh_ecdsa_max_size,
+		.digest_size	= cmh_ecdsa_digest_size,
+		.init		= cmh_sm2_init,
+		.exit		= cmh_ecdsa_exit,
+		.base = {
+			.cra_name	  = "sm2",
+			.cra_driver_name  = "rambus-cmh-sm2",
+			.cra_priority	  = 300,
+			.cra_module	  = THIS_MODULE,
+			.cra_ctxsize	  = sizeof(struct cmh_ecdsa_tfm_ctx),
+		},
+	},
+};
+
+/**
+ * cmh_pke_ecdsa_register() - Register ECDSA/SM2 sig algorithms with the crypto framework
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_pke_ecdsa_register(void)
+{
+	int ret, i;
+
+	if (!cmh_core_present(CMH_CORE_PKE))
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(cmh_ecdsa_algs); i++) {
+		ret = crypto_register_sig(&cmh_ecdsa_algs[i]);
+		if (ret) {
+			dev_err(cmh_dev(), "cmh: failed to register %s (%d)\n",
+				cmh_ecdsa_algs[i].base.cra_name, ret);
+			goto err_unregister;
+		}
+	}
+
+	return 0;
+
+err_unregister:
+	while (i--)
+		crypto_unregister_sig(&cmh_ecdsa_algs[i]);
+	return ret;
+}
+
+/**
+ * cmh_pke_ecdsa_unregister() - Unregister ECDSA/SM2 sig algorithms from the crypto framework
+ */
+void cmh_pke_ecdsa_unregister(void)
+{
+	int i = ARRAY_SIZE(cmh_ecdsa_algs);
+
+	if (!cmh_core_present(CMH_CORE_PKE))
+		return;
+
+	while (i--)
+		crypto_unregister_sig(&cmh_ecdsa_algs[i]);
+}
-- 
2.43.7

