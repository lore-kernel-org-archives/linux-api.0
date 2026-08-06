Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11020085.outbound.protection.outlook.com [40.93.198.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A37E230BE9;
	Thu,  6 Aug 2026 19:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046142; cv=fail; b=lWRTlZMiTroCulPe/mcICgjRGx4x4wz7glzFdC10foUpyrZsNLsQdwo/FL+pcBXdLx6/0eHm8TS1xoVkqTilTWuenQJ6GR2khvPT+DYRilea3h5FfqFNCqjNjGvUBTZfiZbve8nGm6uIzKKYRQSYrbGwHFp58wFodAqOhwETD0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046142; c=relaxed/simple;
	bh=iyZlbVZ0IC+7YsNkij2RcFAGSfzAQFHbs7kdfxi5pnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wb9278ukNMnrWOh/KzUGvMv2f0VzLXcp0JaufSA2W6L4EyMdlA/qoAvQTVEu24hIcCoSJrqCsiyZE2AMCQg0SfeKg8qrYsIkIGMfadmQFHJdi1dSE36w433U84euKzyQFCXzl9/l4BT22CGd4zIFkcTjeudx+R0A7UTY1rXDhIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=PuR0EEwx; arc=fail smtp.client-ip=40.93.198.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="PuR0EEwx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uw+cuoMbgnctqXWTCJC3AjbuQ96cP51HXy3EEcEuTYIHKqBPgMnVjz+mS6lCt6RZyIxqbX7MjmBnfk9xn5F2IcQPPhyQrFELpdkmgsRC0Pz6wb2PpSae4lnzLtttQ01p3ZoLSYlUZajhuN5NaWLpEa8QEIYaBkwriwrjYt1aiZtwyC2YFx5tjqrkclacvvNZNy/P5eZF5EO3eQ8k5d0Yq8PC8FDCanIbsMfRt1AVA/WQa2wqJtJ6cy/3DetTc2AzJN9HALNgHQ4ClbHqYmquBE4/4JCgdm3K2AE51LoILbOKTHWI0WVMo6LbpeL2qgRYLCpmo0icRPOWp/A8rKaQAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgFPcISEyp68QcoHHGqQXtgpq2BDrk4RLpoaIOoecEc=;
 b=h1vXqmx52a48TPN4MXv16BeLAJBuUNWkAvy+xMZcho7HWklOp/84IK6E0a4cZZ/Pz6GQAcdFAlSYltrDcnOmI/O627olqgWn6IDzJvYlsUzc/euyB9+TPAonZHwfX3sc0EFw7RBHPxx+vuAUcpQAXhsgSPVeSL6fymS3mVx9eOdBGujyBe7RWj9E931D9OsXgrz47axdPOpXb5YbpUiDh0UQOk4qJtHqFcypia30H4Hyn8tW6VT7HVM2YXopM/i8ZyIIgOy46G9+U7Nt6NOgBLDDo4nz3LPa3KfZx+ZTW47sOO7nSWp7dL7uoCHAOy0SFIDDyyZP43C9QvUjxyOs1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgFPcISEyp68QcoHHGqQXtgpq2BDrk4RLpoaIOoecEc=;
 b=PuR0EEwxTxEx9cB1D6TyycdRqv3wDQewkikFXUfDcJzT+DbthY3sv0Ioy8383FhZPCtZnQ1VgByWDODJhCPP1SSwztcaPFG3+NM1q2MGh0xkRlDxIVXXMjytEx+aohSXWuzpp0o3qKSo6WmdeF/iaD7o78ZLPg18TcAuIWsnhoyniMcXTiZxMf2/CdHv6QH4Tw0twuHzdZk9y2AZt3F6Sugb9BdcqSjagPcBb0HhGzXjYgTrQIzRBaUOMxrI4wGgIYXm7of81JFYh8rYtd+z8RiFcEndKrvU0VwIie6d5SqpEBtbYpz+PazGSuN+6ZbZP8M3byEWpxnrDAkkqOhurA==
Received: from CH0PR03CA0241.namprd03.prod.outlook.com (2603:10b6:610:e5::6)
 by DSVPR04MB10152.namprd04.prod.outlook.com (2603:10b6:8:3ab::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Thu, 6 Aug
 2026 19:55:31 +0000
Received: from DS3PEPF0000C37F.namprd04.prod.outlook.com
 (2603:10b6:610:e5:cafe::6e) by CH0PR03CA0241.outlook.office365.com
 (2603:10b6:610:e5::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.20 via Frontend Transport; Thu, 6
 Aug 2026 19:55:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 DS3PEPF0000C37F.mail.protection.outlook.com (10.167.23.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6 via
 Frontend Transport; Thu, 6 Aug 2026 19:55:30 +0000
Received: from hqxsv-cmdev3-skrishnamoorthy.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTPS id 6E697180176F;
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
Subject: [PATCH v3 18/19] selftests: crypto: cmh - add kselftest for management ioctl
Date: Thu,  6 Aug 2026 12:55:17 -0700
Message-ID: <20260806195519.2703224-19-skrishnamoorthy@rambus.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37F:EE_|DSVPR04MB10152:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: ad3b3dd6-59a1-4015-91a7-08def3f4ab6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|82310400026|1800799024|36860700016|921020|6133799003|11063799006|56012099006|10067099003|18002099003|3023799007|22082099003;
X-Microsoft-Antispam-Message-Info:
	24ygl+sa3zMBBVGJN1c5SYMqjKotY9BXkuk/WqFWfpMjSHTcssQsrK7z+V9vQeinRinAa/tJTqROCKQMBL7LMLUJ5TZwt9unSz9Fv09Ce/2/2gX4c9PfZCZEhdUYqU9HEzaoEkhF0g7/YG4Xa/j2zocXTXtIdonuz3sAtNKuEsdnBGWQhS0R9B/aRkLoSYkCOeXYiT6qqZiiG+B3XRADOKMPDbd1QEKaPbmC6crEi8ChbWg96lfAWQIMe/e6ACx/+rUhABswTftV2q98ZTeK+qLKdi53781cGe0H0zkTmQHBAkojO0EbeaJ/BOlYToFCVIBfdf0jfLQyiR8uj5WCXbsXG4VoEwCCzj+c8V2LdJdTgoJQHIKsCQg610h/A0CatQew3wRrnnLnnd1vu6LEHJivQRITnLu77zi4UpGLjL7SPrPUlXtIreBt26VItFuZiyi7B0TFydsiPO0K+BNykucAVMmluzWpVOIadaJTH6JEWpbwBWbNmFyKAb9Pp5zro07FMGZAEiRc8YUeb5nra3TpGp4soA619/y+uX0n8QGUXGrYBdHqDWACRcFtSI01gvZl4ZGQ0OWWHWLEgBf6eHNgkkcpRK/LEhuNt63tGdyA9NLZzGV1mjJHbXt1/ztOREyr846uIcC8S7Rk7rksE+i+MEbStMcmZqt+3jNhLZhxOIa+gmE5G80vfpnVepIJ1JXC5ZZva7Ksoa+tj+D3EVf5Nku5v3UjBfUpX6RY4uAERJQ242x+xc3NHgxHr+6u
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(82310400026)(1800799024)(36860700016)(921020)(6133799003)(11063799006)(56012099006)(10067099003)(18002099003)(3023799007)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bKnbhq94ZSlTOTtTX0MrERq4eMB3M6AyS+8Z9EaR+ocBSFHAsXa50i2Rm0x0W4NxExMUYB6i84x45pOao8OYFTKdsXdnI1VVwrEBIcYx0OQ/8A5UqvcZF1xun0MRQiu7uQbKln3Ym3NJDANar8waFj67XfWS8QSK3hRIFiWvZRSOioPhV0q3lNfhPOzXOVhQn50f7U/za7io0NYBmz+A7cbhZHjbgKUduK5i41trAGsNUSea1MnCSMfNw6dAzyP8OZ+Qc+BSjXGoe1yQ7R/kpHCGpB2D6BCjuIG+s9NW1Y2xp7KCcJ77ulBZnTQzXHmnDa0yCI5+6JxaMo52K5THQQNO+bGr0kbHKesVccuBeDdq/JjO0VwRDZ7oQAyPOCAfxcSFqzPaIVzdHR+4MaXnXtpcPw1y1Q7HDY2naLOByFhuUVtd2R+RL3VA/5Wir3SP
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 19:55:30.4103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad3b3dd6-59a1-4015-91a7-08def3f4ab6f
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR04MB10152

From: Alex Ousherovitch <aousherovitch@rambus.com>

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

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
Reviewed-by: Thi Nguyen <thin@rambus.com>
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
index 8d4db2241cc2..fe0b3a5b9769 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -17,6 +17,7 @@ TARGETS += damon
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

