Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022113.outbound.protection.outlook.com [52.101.43.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FEA4AFE32;
	Thu, 17 Sep 2026 22:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789685983; cv=fail; b=eHwAOsayoGhiKwhFj7AksgATBA1y2a8qz6E/hIFxQsGgn3GOpyJ1qXVbGnTUEd9mzAE79e7xSsfwFicYmyboU9USJtJQ45fVWMuJ6Z4sgyfU4oyZQaB5Xd3VOAvqs4VRcVf6quCY/QEXCgbn5qwjLSQlQL3jAthd28HJoaLTi5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789685983; c=relaxed/simple;
	bh=Tn8pRExeiR8E40eWcYWAXOOiT7BnACMD13Ttw0WsxJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJ/73+mmmGygkJEQW7+pnOC9y6aEnkFavwuA1ZqZ/umviXz0wLGekdK6lmzI7CESJ+hwO7m0n4A/M/18n/le0+IB9BwZZpEttFMjMsPcW4lGZr78YgZ1Rch73h7h4l6G11dv7gCGckssO7CfjrOoNzJuDpBpTPKLQv3Anm8GNrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=DgLhoNRA; arc=fail smtp.client-ip=52.101.43.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="DgLhoNRA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tN7lqNyT+fSwOn3yvdhQ1MhzORs4dr7a27u8Mk0l0pNOe56qAFA/dMA2oiq7l/FrDSIblf3Zb51zbALKmWr43LerOlfxBFoZcuITXasqIHzI21sSXZlsV62aGS9NAgrTsKN4Rzvz077xCc2hm2wWC+sZdN1uRORnAMrvinnwhNhUaTl5GApK4H1eNs+uOolHAqwJxyNg8K2obJfZQYeAIw1jb4boFvEmNes3yEoZRj7AUTSisCelLmi+Q4DzI1+/WP/7zyCtNEaAgXX0JTyv1/BEJKseBDxVYIs8Jb/JQgJ3S4lwihQ8X1oXlQcVaCrV06aHwFL7dEsujFT8xrGWHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZtj1DDYvUW8oiuad6xKilGPwnsefmueMCv1X6ZHsLk=;
 b=omCukHw0omDdvc/FnRvqTbvyv0hLV4PHVzKrvS2SoI/VuPBbhdjfh2KEzhgjpMsmZJ+CDpFg5yTzgq4YXFpA8T3VSPJhXksNu3olkxqbJcaFC6BGrRDutxoy41lItpbgkl28kOKtQySDKZFa6u8KZZclFQwxZgioKPd/OYJEHwEKFZhqeIDIyKiHwEfg7mjNIFEcgtTF+UA7UuB4Gr1VpSAAVc30x+iY7kCotNteP42pK0I6C7NhCs+YvvwBNNAD+BO3WcxUykKWyoTABn94T8NdbI+UEFPnKuiqwh+JwbcbcjwJ+axBfC2yCPLggDGE/vdXpPQLf2Jwr5g//Jqp/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZtj1DDYvUW8oiuad6xKilGPwnsefmueMCv1X6ZHsLk=;
 b=DgLhoNRAjEYqCT1Yh6eottyjeyrPtcKB7dc5ztdI3f62vtl6HKCZneub3u7e+xvNV915lmytEBQoQENcCqhPxJmLWPxTf+xOGxNcyMVONR/7fZFFbvptEEcKTRlRJplahNKZU47l5RD/UPfNonDYg6+gWfthfpVoegENXCHzLul634Ag5bItV0nfeLGPkZ+Om8t/asyq0eO4xF7lcM1WmQY7BRElbyaJpEVjP8Oil4eYQA+tTrUFmQ6uOYXwcN4QkhPM9f7vjdHtMCuBCgDBBkHY0hfRQl1tgJIACivjIk8f0FDAxIqJ+PUf2SxNmdHYmyHeuaRQKNSAwO9du6ZSQg==
Received: from CYZPR20CA0020.namprd20.prod.outlook.com (2603:10b6:930:a2::25)
 by LV2PR04MB994088.namprd04.prod.outlook.com (2603:10b6:408:426::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Thu, 17 Sep
 2026 22:59:37 +0000
Received: from BN7PEPF00000096.namprd03.prod.outlook.com
 (2603:10b6:930:a2:cafe::3a) by CYZPR20CA0020.outlook.office365.com
 (2603:10b6:930:a2::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Thu,
 17 Sep 2026 22:59:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.86.86.210)
 smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 BN7PEPF00000096.mail.protection.outlook.com (10.167.245.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Thu, 17 Sep 2026 22:59:35 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id AF665180174C;
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
Subject: [PATCH v5 19/19] MAINTAINERS: add Rambus CryptoManager Hub (CMH)
Date: Thu, 17 Sep 2026 15:59:28 -0700
Message-ID: <20260917225929.2494111-20-aousherovitch@rambus.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF00000096:EE_|LV2PR04MB994088:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 964510c7-5de6-4dc5-601d-08df150f5805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|23010399003|36860700016|921020|22082099003|18002099003|10067099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	pUDXKUYtUCTFsYnP9goUQSr0v3JVyjqRFL99iRK+JkwrRCtgGjs92tMZDyEXigWkeIJ4Vt5xwxdSYgutuoE5hwNVHguenMof/enl2c+mS9y4Xkv3srydVJfxaOAwsuu0gMV+/+HBnodhmFGchZAIBwHgZCBYxaUJpFquoeGARRQpBP8kESof6TRG95vIGCRu/ymTHNcT7MB4miAUJCwxSoz4p5U8QsJfOk9C2NjTV7QK0w2y2MeLyMKJ0px1WeHK6gifibbdx7Y8UFS75QyOJ3Kx+36dQiRUMwZZ0Vh4aRwL5NKmMmo9EIJ1BfPE9uquDICbAUhCjnQI9CUs9cB9/xmYgw7ItJY6eDowi8iGPWBZfmZsvSaXSLUT6yGhOv2VCrcDWabUQFG3Y+DqPFGi7jyG7ilRvGE6QKQQ6KApuKghM0aaOe/1yZsilvNsMttnlQyf0I5Fo2SERMYUwlUKjTOmrMI7BpWXXJT8f5jTtm1HeRhW2RoZGuRDaPebMAbjQaTCbWdC0vzWsSCDGCV2F6PHFZo00vvWoUMOoknRnKHzpboXj1cEciNEJcSLcbWDUkOfLyQFJ9TlavRqvW/XSG00PAudNBegCTiXT2vBNwc2oTofsme8ImhpHEr2JvmCybru0XLHS+iAn1aAnx15faHWOqoE7V0cmuMHUq18yTW2y/5/9Q2zCZT0FXx99PGw5qjSgQ56kS0Wu+izatzxhIXgMqOsV1XzgU0OafHwfyCkm+I+75KrWIS/x5SyQWcI
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(23010399003)(36860700016)(921020)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZgEPzbraCTw6w66xnMD0x5AiIA/VwZPibwGcutr14/tn7C7f8fgdNjInAmu4SJzvyfqETlKrAgwSjmstkx7UfddGr2p+Iy8YnXPuxoWbOaEJiVK4X6/QPQukdTQZoZLH7NVjIjBiHjNlRdgO/Aa5IaKJM7K6cVs1IWufjthV4fLF5SHEwOtgYbbiEKDmy97zqhkQRwGNBjkm2v85Nb67odQHMjv2ldkK0If/Tu/VjNkz4UrXnv/GyKq/ORY1KwU5ZTrTfV00xGZ4npM21pfx9eTcAWrjbsBoaahqdEwfLDpaIoB9aH354zJU888FOUptXStMXyE52+3QQZl0nR7RaXU08qQg6MSmbV3TRbbhj79DpFhRjlHX94wg4vKl5nNGDgyBj7qAYepvJqk3EkTx4EdLWnGh+x72eR/Yfs8oL1xWLtc+BxPION3JaBKIyGrv
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 22:59:35.3656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 964510c7-5de6-4dc5-601d-08df150f5805
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000096.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB994088

Add MAINTAINERS entry for the Rambus CryptoManager Hub (CMH) hardware
crypto accelerator driver under drivers/crypto/cmh/.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
---
 MAINTAINERS | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c3bcdcaa9b92..9e7bcc4ba834 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22760,6 +22760,23 @@ L:	linux-wireless@vger.kernel.org
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

