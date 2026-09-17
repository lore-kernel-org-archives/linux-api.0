Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021115.outbound.protection.outlook.com [52.101.62.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B484B4864;
	Thu, 17 Sep 2026 22:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789685994; cv=fail; b=FxOBARCS6rprGc2A9bE/yb3I4ShjulVBrbx3i/8lJYUwQp2DGEfvd2rLKmzWQBn4HTwiazWY80t87nZMCk6ENcU0AkbGD5Htsu6DUrRxU0jHS2Yjmjm2q+9xwhasbCmkuxl1RvHeyo396XOPLLupJ8ob7T6lyWrJcDydD340678=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789685994; c=relaxed/simple;
	bh=zmm8d7v6SuOSeaEZ2OQrsdvrrSc+3yTFtZpg5jDML8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A8dt/kiBCjdD5kC/GfC+UtTEi4rf3bhHHb/ammFSGKmdw4qCAni8vNO4Fo+HaATzu7uqA3ENHiOWUZlH7KbL+32NY0d+WGWREpwM88Ai6ao8b9QLvwbUwTmpJJ0/D1ofn1mo2O8nzvAo6I3whFJhqJD0Kc0PlDPzp/WAkTVTyhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=Z7mepCfO; arc=fail smtp.client-ip=52.101.62.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="Z7mepCfO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fgf6e23A1xYebIq0zHSiSbiQz4dOp9hBRNC+OreS2w0c8kNq97ArvMIUaqBgtqlSZJ5ABG2d95d/mHzYMLhRhlnXX47mIC714k+aKxxxDuUNtWG7g41ym5nlFaB/jiNwWqDAvyOzQV1M3FmjrOFSU18Xt7CcCzPq/BpRSYCcL50did8S5ymCj3KOyYYVHW39snFFb3AOty4xBOMH0eqHXe4I+VQ4q1ry8T/Lm5UCFCqRwmiKowF+3zZnOtsV9pmpyfEzAn4xWcTxziviApmU5KH315gGZTFlwbD19cffQYYYPbVom/PnnFSm8uk3cihQ8sw+IdI380HPbk+InsB5RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcFfijZeV2dayzaTQy1HddPt3o0QadNbDV9JFToJgbg=;
 b=A94/z5TRqzWnDzqWCCRcMngUJ29EfVpxAstgEYLz9Gmpo1dR2b5h8KjzmMYr+bwFF4dj2O3c63gi6qBp4UmIUeJ8OPijcvwkX+mm+oeWFGZkyjoGtAi+8JjBkbaCLwiIn0n95BviymDLpF7ZcRl6bDqYv03RfjiSqbmwYwQFasyGve0WCe9aRlWPoBLo+41Znh5tVXmfDqDO1uYqVSPqkM73Ueuk5q8Bb3VbRVgbLzN8WfsGYxmPk8pMwQEDkE5g7SvPViQY4L2yuRZJPkoiVet3lAbrCh0CLDVfvEGv0/46eKPr0pNxTjQFKyEsKY7d/nzTl6vpRpo+cDMf5xvPQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcFfijZeV2dayzaTQy1HddPt3o0QadNbDV9JFToJgbg=;
 b=Z7mepCfOJV34+zQ8wfOSb4u+Tc90oQdS1ghg6A7ui9OW+QzmZ6+f5CIv9c2fBuH7kKQI5dyCkAZ/ROE6t5S4I9yHd0etxmSWCu+fMMAyMXJcQFIMvLOAbzG9QBUVHtC2FH1U7/fhc5Yfmq5E15a3KVYR7AK8xMBCD7JFdssIE0OexGMVyRHyiw33vLlZSMv3bwFhb/t67um+sauMGadO3N6oR0N0T+h/0EIEl5BSj5PNAj3cdPvAQmD9HkjtPMNyUbAUOdwWF1XSupL6JvCaX7J2Cw84rCYDl80RmYQrKaQIVG0ePGjhpN2f+8fvda3p7apvR35o8L41X8j7ZLmX9w==
Received: from BY5PR04CA0027.namprd04.prod.outlook.com (2603:10b6:a03:1d0::37)
 by DM6PR04MB6778.namprd04.prod.outlook.com (2603:10b6:5:24c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.14; Thu, 17 Sep
 2026 22:59:35 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::5e) by BY5PR04CA0027.outlook.office365.com
 (2603:10b6:a03:1d0::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Thu,
 17 Sep 2026 22:59:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Thu, 17 Sep 2026 22:59:34 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id A045E1801771;
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
Subject: [PATCH v5 18/19] selftests: crypto: cmh - add kselftest for management ioctl
Date: Thu, 17 Sep 2026 15:59:27 -0700
Message-ID: <20260917225929.2494111-19-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|DM6PR04MB6778:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 2df82056-0781-49b1-61ad-08df150f5779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|23010399003|82310400026|376014|1800799024|6133799003|921020|18002099003|22082099003|11063799006|56012099006|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	DlognZQEuK92YC0QLvHriAGiVtnBoCSwSWOfbUS0Yf9RiFnhRjLsIeW9DPDFUuCUNKZ04WgY2vIFfCiR4W7EBjiWSRivOWJta1Me/zB0azGGkfOCi59FGadmgkSdFtJ3+75eSpxqsj+XJZA6+uUab3V5aAzqIfzhQipi7oHwOD1fi6yPgBD+C9PqcDcGfw5Q1ZEW4CM70JaBrJBXbNRnkE8gKHInEGlIVH158McdF2h+OxAFWBsRoAOxg1QziEp19qrf9l6hGS9fJ1cIVIsKccLugelaCF+3FPS9Ls21DtfHL8Q1JGv1RVYRXE4qU+B3SARmCwkTa9jdjxFLahXeeLBMS8L3mmaJW9ilcr9CYdZ6MM9TALNVAkeRqI3T0nPPh+mXAhepGkjJu+4M1pFFogLOl0XsL91z6buWMHd7oQ+W2gnlbnKryVcyw6JTRJcpUNN1jJAMZwwefdi60iS4HBEsDLRKMGVy4Z4m1VxaDBP4taMyW36aHtZi3f4hbV2TYE3AdgJigNh/fGO+nDxWvJAgIhruLlvaeTh8E1Qb34DrmDVzs7AjBiYSOzUK7Vs4C73/e0ZJujYmrPN2teQEyn1QRU62G4rXUTyPAEn80gmXpGOB6nMEfXAKHf+A8NpTdwCtqs4wvdsY4B1myVwqboPS/3Ri9qOAFSFLjWA4u2G0imVWRD7Hb3cA1bGJhLKJL/f2i72qjSpCCfhapqXSizASL1uocclRScmlzv26+N5a5FJ25BO7iw4ivYL44g0o
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(23010399003)(82310400026)(376014)(1800799024)(6133799003)(921020)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IzQ+yxG1aQsgyugswv3/T1l7YW9hPu/iKqV76J2OboUZ5mS/rfE7KBBZ3O5XOQjz25wKCMoMVk8TQ+7I5N/N/Jd5cYzs1WAoWQ7AHG71my5b7Xu0exnRkocMheY9M3gmt/MOHEHXqezAc82UonXa5yQEdbbYMS+TrF6pUOd7svZnoNs19653BECcxZlTNRPOLY+vzJ3hcQVy0Y6zQIg6vMuRVXnmBDBj18bhLf7umEfRPVdrQ2WkzTmlFp+4KO6owJIxi4cgVd4OPSxme+HIvlDd9Y1osaYzcacnGOfvRRGsjdHyT3Azc3RUHQai9X/WjO10HBedYiUkRhd3L5rKsgpmmY+uyrccG7XUK2Q5ZKtznVvVpMysdAorlzi3RLy4AIManyTBWkmmDnvBtWt1GEN93KE5760xxII6KBTkgPrB/rNYbMRF/mJW/8fZrUTk
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 22:59:34.5710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df82056-0781-49b1-61ad-08df150f5779
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6778

Add a minimal kselftest exercising the /dev/cmh_mgmt ioctl interface:

  - open/close the device node
  - invalid ioctl returns -ENOTTY
  - bad version field returns -EINVAL
  - KEY_NEW + KEY_DELETE lifecycle
  - KIC HKDF1 key derivation
  - ML-KEM-768 keygen via hardware RNG

Tests use the kselftest_harness.h fixture framework and output TAP.
Tests that require hardware features not present on the device under
test are gracefully skipped (SKIP).

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/drivers/crypto/cmh/Makefile     |   6 +
 .../drivers/crypto/cmh/cmh_mgmt_test.c        | 183 ++++++++++++++++++
 .../selftests/drivers/crypto/cmh/config       |   1 +
 4 files changed, 191 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/crypto/cmh/Makefile
 create mode 100644 tools/testing/selftests/drivers/crypto/cmh/cmh_mgmt_test.c
 create mode 100644 tools/testing/selftests/drivers/crypto/cmh/config

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 2d960626750e..71eed3f8b591 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -19,6 +19,7 @@ TARGETS += dax
 TARGETS += devices/error_logs
 TARGETS += devices/probe
 TARGETS += dmabuf-heaps
+TARGETS += drivers/crypto/cmh
 TARGETS += drivers/dma-buf
 TARGETS += drivers/ntsync
 TARGETS += drivers/s390x/uvdevice
diff --git a/tools/testing/selftests/drivers/crypto/cmh/Makefile b/tools/testing/selftests/drivers/crypto/cmh/Makefile
new file mode 100644
index 000000000000..86cb63839b27
--- /dev/null
+++ b/tools/testing/selftests/drivers/crypto/cmh/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+TEST_GEN_PROGS := cmh_mgmt_test
+
+CFLAGS += -Wall -Wno-misleading-indentation -O2 $(KHDR_INCLUDES)
+
+include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/crypto/cmh/cmh_mgmt_test.c b/tools/testing/selftests/drivers/crypto/cmh/cmh_mgmt_test.c
new file mode 100644
index 000000000000..8c2269a3cd13
--- /dev/null
+++ b/tools/testing/selftests/drivers/crypto/cmh/cmh_mgmt_test.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Kselftest for /dev/cmh_mgmt ioctl interface.
+ *
+ * Tests basic ioctl operations on the Rambus CryptoManager Hub management
+ * device.  Requires the cmh module loaded on real or emulated hardware.
+ *
+ * Run:  ./cmh_mgmt_test
+ * Output: TAP format (compatible with kselftest harness)
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdint.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+
+#include "kselftest_harness.h"
+#include <linux/cmh_mgmt_ioctl.h>
+
+#define CMH_DEV "/dev/cmh_mgmt"
+
+FIXTURE(cmh_mgmt)
+{
+	int fd;
+};
+
+FIXTURE_SETUP(cmh_mgmt)
+{
+	self->fd = open(CMH_DEV, O_RDWR);
+	if (self->fd < 0 && errno == ENOENT)
+		SKIP(return, "Device " CMH_DEV " not present (module not loaded?)");
+	if (self->fd < 0 && errno == EACCES)
+		SKIP(return, "Permission denied -- run as root or with CAP_SYS_ADMIN");
+	ASSERT_GE(self->fd, 0);
+}
+
+FIXTURE_TEARDOWN(cmh_mgmt)
+{
+	if (self->fd >= 0)
+		close(self->fd);
+}
+
+/*
+ * Test 1: open and close succeed.
+ * If we get here, FIXTURE_SETUP already validated the open.
+ */
+TEST_F(cmh_mgmt, open_close)
+{
+	ASSERT_GE(self->fd, 0);
+}
+
+/*
+ * Test 2: invalid ioctl number returns -ENOTTY.
+ */
+TEST_F(cmh_mgmt, invalid_ioctl)
+{
+	int ret;
+	unsigned long bogus_cmd = _IOC(_IOC_READ, 'J', 0xFF, 4);
+
+	ret = ioctl(self->fd, bogus_cmd, NULL);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENOTTY);
+}
+
+/*
+ * Test 3: KEY_NEW with bad version field returns -EINVAL.
+ */
+TEST_F(cmh_mgmt, bad_version)
+{
+	struct cmh_ioctl_key_new req;
+	int ret;
+
+	memset(&req, 0, sizeof(req));
+	req.version = 0; /* invalid */
+	req.ds_type = CMH_DS_AES_KEY;
+	req.len = 32;
+	req.flags = CMH_FLAG_PT;
+	req.cid = 0xDEAD;
+
+	ret = ioctl(self->fd, CMH_IOCTL_KEY_NEW, &req);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+}
+
+/*
+ * Test 4: KEY_NEW creates a key, KEY_DELETE destroys it.
+ */
+TEST_F(cmh_mgmt, key_new_delete)
+{
+	struct cmh_ioctl_key_new new_req;
+	struct cmh_ioctl_key_grant del_req;
+	int ret;
+
+	memset(&new_req, 0, sizeof(new_req));
+	new_req.version = CMH_MGMT_V1;
+	new_req.ds_type = CMH_DS_AES_KEY;
+	new_req.len = 32;
+	new_req.flags = CMH_FLAG_PT;
+	new_req.cid = 0x5E1F7E57ULL; /* "SELFTEST" */
+
+	ret = ioctl(self->fd, CMH_IOCTL_KEY_NEW, &new_req);
+	ASSERT_EQ(ret, 0);
+	ASSERT_NE(new_req.ref, (uint64_t)0);
+
+	/* Delete the key */
+	memset(&del_req, 0, sizeof(del_req));
+	del_req.version = CMH_MGMT_V1;
+	del_req.ref = new_req.ref;
+
+	ret = ioctl(self->fd, CMH_IOCTL_KEY_DELETE, &del_req);
+	ASSERT_EQ(ret, 0);
+}
+
+/*
+ * Test 5: KIC HKDF1 key derivation from hardware base key.
+ * Requires at least one KIC base key provisioned (KIC_KEY1).
+ */
+TEST_F(cmh_mgmt, kic_hkdf1)
+{
+	struct cmh_ioctl_kic_hkdf1 req;
+	static const char label[] = "kselftest-label";
+	int ret;
+
+	memset(&req, 0, sizeof(req));
+	req.version = CMH_MGMT_V1;
+	req.key_len = 32;
+	req.base_key = CMH_KIC_KEY1;
+	req.cid = 0x4B534C46ULL; /* "KSLF" */
+	req.label = (uint64_t)(uintptr_t)label;
+	req.label_len = sizeof(label) - 1;
+	req.flags = CMH_KIC_FLAG_TEMP;
+
+	ret = ioctl(self->fd, CMH_IOCTL_KIC_HKDF1, &req);
+	if (ret < 0 && errno == EIO)
+		SKIP(return, "KIC base key 1 not provisioned on this device");
+	ASSERT_EQ(ret, 0);
+	ASSERT_NE(req.ref, (uint64_t)0);
+}
+
+/*
+ * Test 6: ML-KEM-768 keygen using hardware RNG.
+ * Verifies the PQC keygen path end-to-end.
+ */
+TEST_F(cmh_mgmt, ml_kem_keygen)
+{
+	struct cmh_ioctl_ml_kem_keygen req;
+	/* ML-KEM-768: ek = 384*3+32 = 1184, dk = 768*3+96 = 2400 */
+	uint8_t ek[1184];
+	uint8_t dk[2400];
+	int ret;
+
+	memset(&req, 0, sizeof(req));
+	req.version = CMH_MGMT_V1;
+	req.k = 3; /* ML-KEM-768 */
+	req.flags = CMH_QSE_FLAG_HW_RNG;
+	req.seed = 0; /* HW RNG */
+	req.z = 0;    /* HW RNG */
+	req.ek = (uint64_t)(uintptr_t)ek;
+	req.dk = (uint64_t)(uintptr_t)dk;
+	req.dk_cid = 0;
+	req.dk_ref = 0;
+
+	memset(ek, 0, sizeof(ek));
+	memset(dk, 0, sizeof(dk));
+
+	ret = ioctl(self->fd, CMH_IOCTL_ML_KEM_KEYGEN, &req);
+	if (ret < 0 && errno == ENODEV)
+		SKIP(return, "QSE core not available on this hardware");
+	ASSERT_EQ(ret, 0);
+
+	/* Verify output is non-zero (extremely unlikely for random keys) */
+	{
+		int i, nonzero = 0;
+
+		for (i = 0; i < 64; i++)
+			nonzero += (ek[i] != 0);
+		ASSERT_GT(nonzero, 0);
+	}
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/drivers/crypto/cmh/config b/tools/testing/selftests/drivers/crypto/cmh/config
new file mode 100644
index 000000000000..063c1dd0e23b
--- /dev/null
+++ b/tools/testing/selftests/drivers/crypto/cmh/config
@@ -0,0 +1 @@
+CONFIG_CRYPTO_DEV_CMH=m
-- 
2.43.7

