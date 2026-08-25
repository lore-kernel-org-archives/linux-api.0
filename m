Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021110.outbound.protection.outlook.com [52.101.62.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAC648CD72;
	Tue, 25 Aug 2026 22:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.110
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696164; cv=fail; b=hYK3TCdOtvT3ul3IEub5IOkVaEIbQgyRNU/C7jPZz29gN0KzKr3IC2K8y5Lp0be+5GKWqV1+JSs2AZlfI3melGpMKBwcgmwGTeWPB99fVPcQijMU3+Vc/8IMnFFMR18dNyjjC3yeuQSwiZVt46bGKPR+a56s6KXqVlKRV+yK+I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696164; c=relaxed/simple;
	bh=RNoQNRsXtlfhrvszaDytZ0UlISaqtbut40FpkcsZZrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SGYchv/rhMjMEmbmFPMAawghflHi65CJV3VOVR54NFpybYjvhZHtu0r92VdkHtgv0AKKibqDbVD85kRA3zTI/WO3bEfuGTBKomy9IFORp1yF5yjYSsSYxBefy+a3m7WNTnm51Yo7xlGPuHCnML6OxcXz8W81Fx/7vcMVYa4b/qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=Ud7dJkkK; arc=fail smtp.client-ip=52.101.62.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="Ud7dJkkK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J4+GBRC+KtsM2tMX5TMS7rmik9SvVg6kGPvOk/OHhQe8V7yfYazPHmxmNjrjmRqAhc/nm+xT+1vR+SEFe4MW1hyjZE4XetRU99/PsbJoDsWtaskGZHDpm6wAPpSGsxdcqke62AId7xcixDsC2Q0qM5XzELJMGngN3xs4NviREIVP1OZnHYqoVM6cvkW07PONENhA5DpWvgzVI4Y9HHFLufpQi7HRtUBMazf5ELseWKpUs5Bri1N4LHfV6vuBm8q3xM1Z5ieINzk9s6HLWz1vhqDCdq+6iMlM/l9zqzNI8pR0S+gO27XyzsP3Ls5mpwn1Gj0ch7lfgpXzGPywAiGO8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsikQopX1A5jSdr6jPENDWHQuZSwk67EMDRKQPbSrz8=;
 b=d8UpOeza3uoRYPCOcr/LKaS0pMXLw5VL13Vo3M+N4A4qSLwQaQGDPUeXz0TFQodDHOeF2Ddku2tWfvssNhipBcW9ELBMzl6L3/H+iLCb4vQC7nskM9VUl24hq+YUP4H7l2GpcceBDo9oppMPqdO/e3b0yKodqrEJpf3TtaydYg/ZzXfKNffqRNYGvHv8JnGK7HA5B/nRT9sUmD8InzuI3Jod5Ws+4O6/ipdEQYuB8V2pWg5RWelrjdJwSoqyAyzkLiuSX2OtENbcj/WByW/1yP22gPF95IIlPDaSlHawFtzBr1sXiQE9gF62BeX4NioCM1+a5pEk9AF89WS0q/1wNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsikQopX1A5jSdr6jPENDWHQuZSwk67EMDRKQPbSrz8=;
 b=Ud7dJkkKdGgFQdUqMaIJ67yet9jkr/FSsdA/Bq6TNBVdJx7vyXlJvuyFL2PhMY4K+n7NbsRd0TRuT2lDxrB667y6HQZvqHn48FbwplmKIasj2HV9WiWajbimiNweqP7YCFZ3dE8SoRJ2NkOSeMgukuTqSLxvhAiciC7TAEMWThvwLJC69s48ZqOM2AMYYaxR42/A03SW1Ik6e5q6AK9vYfiPnH0tZlaSkPemDOLUloiqzPNgCXSq+3c1Y5V8VzQ+ejBAf97pnsoIPw9VKJhWeXVqM2som/apUT1CwunipUyEFFrdCmHHZtQlzCrlXjwrYpgKvmPp/DZlkKWo4AkkBQ==
Received: from BL1P222CA0006.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::11)
 by SN4PR04MB8383.namprd04.prod.outlook.com (2603:10b6:806:202::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Tue, 25 Aug
 2026 22:15:54 +0000
Received: from BN1PEPF00018072.namprd04.prod.outlook.com
 (2603:10b6:208:2c7:cafe::4c) by BL1P222CA0006.outlook.office365.com
 (2603:10b6:208:2c7::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.12 via Frontend Transport; Tue,
 25 Aug 2026 22:15:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy01.rambus.com; pr=C
Received: from hqxsv-psmtppxy01.rambus.com (192.86.86.210) by
 BN1PEPF00018072.mail.protection.outlook.com (10.167.245.200) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 22:15:53 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy01.rambus.com (Postfix) with ESMTP id B590F1801773;
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
Subject: [PATCH v4 18/19] selftests: crypto: cmh - add kselftest for management ioctl
Date: Tue, 25 Aug 2026 15:15:37 -0700
Message-ID: <20260825221539.255951-19-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018072:EE_|SN4PR04MB8383:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 4ceb6ca0-32d9-44f9-a169-08df02f66e0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|36860700016|376014|7416014|10067099003|56012099006|6133799003|3023799007|22082099003|18002099003|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	lSd9PizQulByMcHurY69Ch79ssxZzRxfzEHsKsEA2G7bXfsrQm5eiUDUqw3+9+EE825n7f2oBlq7GD1hyav9Mv3TRP4XFQ6B+V+uER2pTNh2kjZGaNjXk3p1qIqNjsw2dfJfHhSjaAzfHl9fTQcTZPuRL4RfWZo1B4NjYQRHBqTGo/YQxmBXJrEK+j9sJAO6tt5vzejAMGPieMWprzv6HmGBralY6NnDvy2PZPwoWcxA8hvxfW3EKjb8HcXTK90SOU9MGgv7b8RzDNDOcNaHyJnHnL6PKIYt/DzYEIqU+d9ILW6k3mN6lm4O/8eTamgsJ4DjZkq3rmxOpoAGjwVIsS5iCn9TZ2O6EVzhHIbVxOuANeEToiLbyjanjVu5hx1BH/+xJotd8bcE2mIlRN+tBpgZALW5Fmn88Wh7GW4Dav5LJNz4dEiS5D8g6bPKughp2f7L/xAXqNy6BWSbCzNLxU2FJEzX0v9zXlJckQIxT5+q9hQenjM3WvFlqTPv0s4pLQ5l0kVsbW5uMtcF/B6wJVjVTsb8NS4n0H5WUg0tXtKvRqtw2iZe9k/p15MJx3CGkWGA7jK+cfrW6gaf4KL0JTuLa5cGs6iCcnLL2vnWW78oUxjSQq8LVUQpv2SEAs2FmuovNO2DBgbjZgjzZD9SxjglLY8zhLhT/lu9n+4a+ci8XcYC0QzkwiZ3BaDLTj3mfIkFgq5OIwC+ILoeRCh+PD/YSH3l2V0dzSOn+YqJOQii/yb6zoMW5zAMENskE+HI
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy01.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(36860700016)(376014)(7416014)(10067099003)(56012099006)(6133799003)(3023799007)(22082099003)(18002099003)(11063799006)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HRqE1OlprFF9ASyv4o4fpU4+9Sghnl6/xysD0Dcl3Dv8GXxM/P9Y1kQ+f2wKImoQtgOgkwFQkcp8bdiPkrnY4u0aWdmJLIXalpNyksPi34PNoCWYBC4r9kGJzYPtWdAavsaDfU4GMGxwhqEmXVS7y1UcE3GoasexPmb53w4nQKXZsvaUK3fy6z8Rq7Xsv20hE9fS8ZBfEot1JKX51C9XFG1W4HEF8kf/R5q7pXxy4kL66F0fj882xpYmCEteuz14vsWueIxRRw7DT8NRrVVAPScDwJoU6QPjHh6xg9JThwL8456KsHUgnfq89HUSZXmJeeRCWKcMQAVZ7ODphBUhubytmJpXoQ0Kt2CbBm/tUAeHOJvu9iSrKJh75tuypvTe9f9vupJEbkspe81SpMafxH6YugznmPsVngJelTMplp+kdDMUVEHzH69Ie0SKg2Yi
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 22:15:53.9680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ceb6ca0-32d9-44f9-a169-08df02f66e0b
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy01.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR04MB8383

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

