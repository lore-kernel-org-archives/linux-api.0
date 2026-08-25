Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020076.outbound.protection.outlook.com [52.101.61.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8A44908CC;
	Tue, 25 Aug 2026 22:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696165; cv=fail; b=PsOWWFAMcnJJuiuoyg3VDoSrpuFnabc7ifsKf2fcSXbDivrb0771CX1zUKBk4gPls3Y9NeDdLWPFd0FinANrWSCXvUcArKlmDGGRQ83+m3pcMGpNjPIX7M9sYech2Oo0VZQUkK3ggECEEyOUR3agKZMmcEquR6IEhOo7ooYJI0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696165; c=relaxed/simple;
	bh=uZmpbuQYvX0HJMUTouBh2WZmhqhEizQIzM2ykms4M80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcrq7Brruju2+tLcadPfN4d84CsXiz0hNAQ9hdXjTcB8b+rkwI/DvAktIPAqJKRxZHlFBf7uY/bfqU4yadNwdkMjUACf1JECcKm4LGpR/VpeKLJrbWjU6Nx3u8t2y2u+ZJekoqIMIdUvWc170eMxH8BdxITX7mjCSU0sL1+tPGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=n0vhTDy6; arc=fail smtp.client-ip=52.101.61.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="n0vhTDy6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lpcsz4kHHLoQ9miBoeYzgn88Op78hCMdE0VFM0f5tkBOxuYn5UtVUMB03C30djpPlhF7ARBeMrA2XuR2gJdOQiFTGge+vSfUlabiWxBOCfQVo3Aa3ChTaI1v0FvTvA5+hjU57vOBrDUx1T1sXGd52TKxMgJSdYlUN8Tpxsb4nt4K6pW2uU99kHvk86MK9C23QHrVLgfVz0ItF3X/tPCtNPSZx8l506zMjVA+SowzedXy82DTKkKty59XhLS4QHEVIsQPShZUFrNnp0EOTjJnT7hSSCCYKe4r2IYydKKOdKY9dNo0pLOWX3Xlv4IbGfAXBBWP2ZNaw4FWZgo/KoRESw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/AC3TYSXfBCxbos9Y+/nIVRSNFQywnLuEG5oDa7cqI=;
 b=y+d7Gj5nmzFYc4Eh2NkrTZrA/q/7PQ+vDZLAdj5aXW6SMcH54Nuc2ztSMLQiiu+FX8KEvJz2dQ82KL2UJa8mHFLWSAtpJ6fbZOqto3egDA8hoRRkKyjKGVA4XKaLt7kK8gy4auedflao/sduvPNfzwVmsLv49knrP8CAciBoPKue4+tzVSOY81NZu8ujv6fosMZOhC8p3niPEz/j9WzhQoI37hRie85WAm47SGQA4hVmRS5buvmHb3z+atI97NM4XnEUV9fDRRdeGt1DdnM8MwbceRdGoj6SSY6mW6jcLMi6+y2irRiR4C9PN0qt8zHKbKhzQQFf+oNGVc9V0Wagvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/AC3TYSXfBCxbos9Y+/nIVRSNFQywnLuEG5oDa7cqI=;
 b=n0vhTDy6laachxadMbjTuk7U30lLRXEN1XwlIHhDpwso1hQkK4Ttbl3DSfZ3XnvAppXV6iuZE66/Lqg71kFnW8xH4/0skZMkHOtsebULByhNcN+ENkWvFTUhQbh69NqnUaTi0Goeg1PgTyX198Dh+C5yBLtK4xvCt0pGv2D47FmuSBhHQzSfFZby2GQpNYwVFF+ypx+pShA+u5sbluj0g5PySx1roHWWnOsB/CUPP/wA79qWlhN1CRFanUn+drYuMCpzcFhat2Q3n8LAjkiBoxXbDR3PUODo0fClKP0Y2Z9z363Nno9PZUZqRMtevuSSRHzEyl/9pmch8mczVjm1Fg==
Received: from BY3PR05CA0039.namprd05.prod.outlook.com (2603:10b6:a03:39b::14)
 by PH0PR04MB8322.namprd04.prod.outlook.com (2603:10b6:510:d9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Tue, 25 Aug
 2026 22:15:55 +0000
Received: from SJ5PEPF000001D5.namprd05.prod.outlook.com
 (2603:10b6:a03:39b:cafe::58) by BY3PR05CA0039.outlook.office365.com
 (2603:10b6:a03:39b::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.7 via Frontend Transport; Tue, 25
 Aug 2026 22:15:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy01.rambus.com; pr=C
Received: from hqxsv-psmtppxy01.rambus.com (192.86.86.210) by
 SJ5PEPF000001D5.mail.protection.outlook.com (10.167.242.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 22:15:53 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy01.rambus.com (Postfix) with ESMTP id BDEC81801774;
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
Subject: [PATCH v4 19/19] MAINTAINERS: add Rambus CryptoManager Hub (CMH)
Date: Tue, 25 Aug 2026 15:15:38 -0700
Message-ID: <20260825221539.255951-20-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D5:EE_|PH0PR04MB8322:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 0f8aeea5-5c14-4fa8-a7de-08df02f66dca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|82310400026|1800799024|36860700016|56012099006|10067099003|6133799003|18002099003|22082099003|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	Qm0mC3FTxLpevrR0HXE8pk93cr7fdtIVSoSmmZOHaBPI9M2x11n0z2D7BMcM3BMk/xvpMLtg/Bz224oA8EWUOsulY6Cpa0P5nPeDSG4oDTmNzeiaYec5iK5pD8djkWKkTk36G9yzCMlO/A86t32QkZniK6PrkdklSEt46wyPMHg0FAhX4zoIxdD6v/avO+vvPasMD+q238Jnah/qLUnuN2xnbwtdp13rLPTfvXlNpbLGUiPFvc5kwYcaOFIZuktwuXj2B55OtOSikjAW9QyLHzAoTJJTEY2vhqhS4tcVFo0Xiy6XcD4ap8qFikfwFyYQX6ZSis5kN5g3J32y3FFmhOeioT3PMOQiWeZ4I/EhjP1AmeltNVtMNqcdFnZIvfgDX3wlw3H/HpCtugfoBMC9l8CT/KJyDyuCKOIxO2tMeEneojQRDDc+3ynF5fxOQp67dA6P20290KAkUwT2ipf32rsussh/6z8l1Wh5SF5pkhS1s0/bweXnHlTc0mBxs/Nb4pkjkeG4hPUG676fxqeZpJvemQ/HGpgWIECYourwdRc0ALZGMEzmetmkI1rmBxvLk7Dzfl1bl99/pAxfnDBiihf0aybEyg4C9kjAHpCb5oQ1QA9oni9553peaHPlNgCnzDiCCXVD/0Sh/IfQkkjdiLs2gPPsuHodmidBNCuw+ql75kVUaI54I6qDdn9uZNUA+pMUOninM0wJXkvRdy8Ep1Kvb+lwcoHI6I0ax5ZuLmaG/DnN4TrZNOffCjyKCxHf
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy01.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(82310400026)(1800799024)(36860700016)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003)(11063799006)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fvqc7CdlRpg+1XxKRlaYhQlSr7rpb0bw/QhzfyAdvzPlW783uUiksDk6Z0zjMPV7evh2SVH3eT0N+X3IoHvWeg8zU22hj3X6L7ZMRgIYgugOuNjo+vbUXwCcnSH+rpI9oLVkG7batr51NWNOHfH4koZyqq+8lduaFeQEpsXVlx4hQOlpxtw0cTlMtfcAQ4rdFUfDQ+JLVg7JtB4Vn9nkSPR1IkoVHqJ4wjFHn4yyVCJdAbsk77FRf9F2NcVvM3IC8Dpj4N1UueamoPLhqdZCxYsdeZUCdTnXY55hNMUZYJNeC+Mx7R9JrUJENvnLYGG5CVp2s+vz9Xf4I0RqXg9rGcv8T2Grcp7SRxdbFb1BmdaRyrc5E02K8N6b0SRUKAsZfwy5J9jjkqfgh5/lTBVIBkPH+FLdj13jGMCyLyrQak0jNWwb3RPxuw9aXk+imjmF
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 22:15:53.6646
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8aeea5-5c14-4fa8-a7de-08df02f66dca
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy01.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8322

Add MAINTAINERS entry for the Rambus CryptoManager Hub (CMH) hardware
crypto accelerator driver under drivers/crypto/cmh/.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 MAINTAINERS | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d1dbf2f07104..4af6412323e5 100644
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
+F:	Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
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

