Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020095.outbound.protection.outlook.com [52.101.193.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B443451A7;
	Thu,  6 Aug 2026 19:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046143; cv=fail; b=qAsi0EUOLhDz124eyT1TuwMIp4N1TWfvSUUKClVadv23wTjdo3Qo5cK2oiJHK63mWK50tAuIjjIbkJ6ZeQX/L9XsEi9K/1tKGCA3cE9Qp/j3dhEuc+z8OG52a28EfsodD6mW0xkNNfuNkuja8ylOQQ8wpfQD1h1B9wD4mktaXYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046143; c=relaxed/simple;
	bh=Fu7b6pyLerMSzLJ7LCQ53mlUgkWzfDb1qLzTGDquesU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IiI2Sqky8ChTubGjA6QNXnXSUjB2jGp/lF5tV+e9016ySrHwBJUCqd3RldQtZW65iMsetGw1zOoZoxYMWNS2JWG/Ym+NInw5ek7OUrY+aPa06VPi4D72jrJarHRSdfNZx8GtP//WYHCZm4DmmARcC1gF1bUuywtd4Kq64qODf0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=LEY7dlhD; arc=fail smtp.client-ip=52.101.193.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="LEY7dlhD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vd8ryEE8oLwtIUxMxy8vZ8I4hdf24mmuSkWOeA2pWsa//F7vfxY3jGEI509aQUEAJbEtWEI6cnNwx7sI/7OAN7CsmMgzZ8eF8vmRakc43Xw978D050XzaiGT68SlIiH0l30b1h0Mx/NE3D5Cq3ovY/CDd1W19fgvx8pssk/rNvVDcV6XIUinX3t06ZPvS2CwDIdYuMhZ6QwFUKwo1WGdq2T3rxFPsnR8wTobVsSQnXbhoBSJ/ch4L8tEhiFwEZXtnJNWpOHQDLSCi72jwM6Q03zZFn/BXIAs/JN19Gf8FcuvOT4RN/a9CJ55/Rm+aUaF7415xLwzSZSyAGH/Nq/r1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t3bsTs8lBAKBXnWu6jN5hXi8+m6Tslq0TF8RttTlV3g=;
 b=SUiBcxj+cEiH0QvlhOu3zJlB5yJWAe22gXkkSN40pizzh/Kp2wI+mVe7nJDFTMo1XjLeddIcE82u6pVw1x0biNaJ1jZrai9IhVEZviN1FIRV41mFgicdZtOR96SSKsKcWWUPzA+oiIGAWA+J+KqbDfk2hhezG7emDTpOHzQehq6/yyzI+yfDafODGxYKhDObL6e0JdYxtf17TXtlNUSwMXMn4Gmei4u2JVoxQSwmBufm6uIPh8DCUbyUFeliv/+/HmSsPQWJDDkvCzlN6Uw8qLQHMxiPcRY0/sXYSXsjcyaoP+DzT+mi84XG8RUXZUXC6Uw5zEi1hzXzxR6k/Y/evA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3bsTs8lBAKBXnWu6jN5hXi8+m6Tslq0TF8RttTlV3g=;
 b=LEY7dlhDUa2PXPDS9lfsddpl2MlB3WPEO3TZBBvgQ/hsmqMLeTJa6M7hTp/1BqqoTbXzzWdg6BHhiGnHs0VDeif00iXunoO0reqtgg7LSiQhGAXd5AxVh73sxiwhKHDcHQ9LfzKUwLmYLtOOIPDgHErCy3HcmrcHW+dLBtGeOdBFiJGYD1P+A/KpgMmKXcRdPIuXCBpRZUAxU7Hx7hpBbGULXb1CwJ7FQOxe0+jxezhmQqcadmuFwzgAw7YNXWrzIdBh9dbCWrJn0JYxRBgEGR+bzrHNJ31SkfXLtrjFYUXb8CU7V2Ddp4R1SnlYf6+usxDUXPR3BLMW/6bFS3iDYA==
Received: from BL1PR13CA0445.namprd13.prod.outlook.com (2603:10b6:208:2c3::30)
 by MW4PR04MB7252.namprd04.prod.outlook.com (2603:10b6:303:76::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Thu, 6 Aug
 2026 19:55:31 +0000
Received: from BL02EPF0001A103.namprd05.prod.outlook.com
 (2603:10b6:208:2c3:cafe::51) by BL1PR13CA0445.outlook.office365.com
 (2603:10b6:208:2c3::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6 via Frontend Transport; Thu, 6
 Aug 2026 19:55:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BL02EPF0001A103.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Thu, 6 Aug 2026 19:55:30 +0000
Received: from hqxsv-cmdev3-skrishnamoorthy.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTPS id 7A1661801770;
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
Subject: [PATCH v3 19/19] MAINTAINERS: add Rambus CryptoManager Hub (CMH)
Date: Thu,  6 Aug 2026 12:55:18 -0700
Message-ID: <20260806195519.2703224-20-skrishnamoorthy@rambus.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A103:EE_|MW4PR04MB7252:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 51e3a96a-6ae6-4afe-0a8a-08def3f4ab83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|23010399003|36860700016|7416014|56012099006|11063799006|10067099003|6133799003|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	CQ5quxuV5Gp51+3Ubjr/Op767mub3I/mtBRRcwYsiHLVDFn2bSgsvGziWHDa1sfoJ5HLQVJ2jhFd+VmXBXR5GP0B4WQIqlLg8XQyMwf2Dtf5mR4aZh+e4KFIAUaznXlC7nZKY1FTSPde5E7PI4IBbtxr4zSQl28PBeZw7NHod4xp/F/sro8H90Ps2kP4PPrrMnOgq5uSqoV4kARqDklandn6HfrAdeRGYkblqVJyappZVGD2Mp8m63gpopJSQUm6+E+uRSuirWisG6qq45Eeat/5TmVOxr9tFKALCpWmB+4wiUoySHvHw9YEkkZ5cBrjRgR+p8KwxPkYX6Q9dWNiac4MvVAv60sv11nq37oqmADaZsG1RCCgZ+vX7Dz3AuSjai7uDCfZJbtC8Bs25pYsyikkxQ4BNyzfYIC9IWAqjBhbGLijCvsh3FDlMGI5QUZmYSIRi/kcYwY1o6oJyhhFsh6FO5oN2p03b0nSR8ECw6kawOh7yggzcgDqCWtBZfSkR5sXMNQVnhw4oJaYD3s9tzCgwd8oyaAFtXOQlg9BDaENonoKr+PcBoDWV4Sqomtd6XLafwNYnrWkdjl43qsJvwRmwAmJIeTIe7bQg85fJME+sjKcHRbY8ZXvBjX7SitUtSBmxneeFZPzLXUQyg3W7FaRHWvij+phIWwrb4FVo+xH0Eudqu4Ao4ECfNJ3e16a3UXWAd1TV2WZjfN6+BcC4cGYKYvgBObSKY3J4PUT2g0W+dNMua/Wcvifeq1vkk+o
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(23010399003)(36860700016)(7416014)(56012099006)(11063799006)(10067099003)(6133799003)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mK+CahJtVD8N9gH9eJ3Ll38PELHssY5dpZODSEukC5zahxL+PV+k9nlhPWrXV8D2o8eaWQN8b920PINdxlTynCYLwFeB6Fo9TWXYrXLAqlJ2ZopFGUV/wM8X53TFpPKSY0T3flE05K6SwV9vHFzwKhq9ArlHDCQD0u54zHG/EwT9myP1q2uhXqJJm2agcEdnMIA4LS9rCwq1JXmEdOZHHjtOe2fJNS63+ckw2Jzm+I0ShwD0pzM2MvsXaUheQ/fefgFqP+3ebsvINF2WS8aMO2UTRL7X8XIuPDu1YRf24TSfpCLTETF4csN0jQL2Dc9vdUILqojywdtpTeoIAvgnW10F1UxRkR7kW8l3zbMX1HV517/GyML10sZR+3GO5iu2Xx/5hwJckT8mCxlltHQbrZxX6hSkBksxf/uZYuqPEr+RCefU9JvLkQR5+NxmvOGr
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 19:55:30.6411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e3a96a-6ae6-4afe-0a8a-08def3f4ab83
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A103.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7252

From: Alex Ousherovitch <aousherovitch@rambus.com>

Add MAINTAINERS entry for the Rambus CryptoManager Hub (CMH) hardware
crypto accelerator driver under drivers/crypto/cmh/.

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
Reviewed-by: Thi Nguyen <thin@rambus.com>
---
 MAINTAINERS | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d1dbf2f07104..ec613b0ca492 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22489,6 +22489,23 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/ralink/
 
+RAMBUS CRYPTOMANAGER HUB (CMH) HARDWARE CRYPTO ACCELERATOR
+M:	Alex Ousherovitch <aousherovitch@rambus.com>
+M:	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
+R:	Joel Wittenauer <Joel.Wittenauer@cryptography.com>
+R:	Thi Nguyen <thin@rambus.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	Documentation/ABI/testing/cmh-mgmt
+F:	Documentation/ABI/testing/debugfs-driver-cmh
+F:	Documentation/ABI/testing/sysfs-driver-cmh
+F:	Documentation/crypto/device_drivers/cmh.rst
+F:	Documentation/devicetree/bindings/crypto/rambus,cmh.yaml
+F:	Documentation/userspace-api/ioctl/cmh_mgmt.rst
+F:	drivers/crypto/cmh/
+F:	include/uapi/linux/cmh_mgmt_ioctl.h
+F:	tools/testing/selftests/drivers/crypto/cmh/
+
 RAMDISK RAM BLOCK DEVICE DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
 S:	Maintained
-- 
2.43.7

