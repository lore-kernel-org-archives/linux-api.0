Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022081.outbound.protection.outlook.com [40.107.209.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75274BA1F4;
	Fri, 11 Sep 2026 21:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789162151; cv=fail; b=txw/WP2Md0Bqkm/yvG9Z/dlPAIh/9CmKFICBxX6HFns3SQBHBTRS0HKhXcih8Zm16hlyAJ5b6YYrz5QJaK6GwgAM3WUTun5YulRsAG784YqnMeGgt35G+LBGu4EprlIEcSOfAq+3i0wop2xpr9+oQc0NTqL39d5q7h2d6xXRia4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789162151; c=relaxed/simple;
	bh=zxxiHFeoTFgxoc0spEtnWDt7lbs3P+gGcOlYkyel8+I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NS4jQ96R2er264idXeLCwZleuZRTyPXARLI4iGtkKGCDd5ztESPIrkhfWGpOF5slepJhWAd5iE0HQPjeeN13vwppE+F2h+GwXL6pUvcqCz9RC35Wxl3a7xM1TkfZlYAEO+eUao81+o/aK28m41/WD4VXThpd0ewMW3icjAhOBog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=JSm1wBdy; arc=fail smtp.client-ip=40.107.209.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="JSm1wBdy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JwTEebsCniZ2ROnBBac5lsh+Cd1e3GMzVooq4AwS/fpVEwJkkEFL9yuSHNe6XCh3lDhwXTxHm4WFFM8JcdjKizqXZUhWRJ3E0nv4ZMYs4fT24QCSe3XIj21/g6qoMoEqyFDExBAy+4ywYoYysS9VMzDsYG9z5gxrW0KtezE2GmSoL9OPV/v1HhRLEtEFMgvqB5SY+r+KzkqLUjnytcmOapi1PlKFk4KxRJEH9FhJeVfSj6uTWj7uG5+isdtUIvpgeLbXGt1pPogtUsRXUE605iXVyCrLGoOwW0eN5r/35mBIluOEzFtznbkFb84cLfUVYKKI9ToXlA+wL9sIs4untw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVB56YhnglpNFEROeYGpD4J4uZsyLLIQMC7gA4CtWCU=;
 b=J3FiXjlVdvbBXZcfKpuTyJjOt4sOCQ75QK8mCiTUpTtNfFEp4hYuhTO1laUWCSo2zbJHuEr5bPLNKpvKrGPeg7E6kLPE0bZEHQVoGzqH4pBvPnXlM6R0pIYmFOF/NfLtFdutgKN9/eJeyNDyRKI210jMGNkAvT5CfYJyHg770Qc7agm5KQl1l5IN4KSIxFDWZZy0kTwXyNqr0yLtFcZ8JSdBUGNiRi2FR2vpWdMek/zigUPA6thsq34ZnCe4HinlcWZ1bQ2TQZzu+F5+aF4nsRtJO93jcnlF/HB1VWvsziHU9A3DoEnvpWr8NerdFPmzYRHT+maphQ/7wFH2Le3aHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVB56YhnglpNFEROeYGpD4J4uZsyLLIQMC7gA4CtWCU=;
 b=JSm1wBdyTJ0aV55Qlm2W45gpYT0fgTDYGlg6O0VdPXG3O1DMUFv83DnzV4KVtT+6RkQvys9SWzzVbayobcz0jLzYusGSPmdEu0U8bgaTiw6k0h1uKXq2u/fIBiAYcD5wkUtfoJ75NfzOqHx35M70KOLY1RHywT07YH1TqLOhb2UYc+9+AJuCzWAMXYGhDZ9zmNtPnpAL74EOz//3vlITd6JqMNLsTCYLIZxMZjfVCRiOuw5LEXgiUcSrzxQH0LYknD8YZgmMsKJTJoLf8S2uXePVvKBvz0Wu95Bkbj5iTF0nX3brkm6/4RBcXSZMqf9eFL7LQGST33m2rw9GHampgQ==
Received: from SA3PR04MB9001.namprd04.prod.outlook.com (2603:10b6:806:398::17)
 by BY5PR04MB6836.namprd04.prod.outlook.com (2603:10b6:a03:21b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 21:29:06 +0000
Received: from SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196]) by SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196%4]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 21:29:06 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Palmer Dabbelt
	<palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Rob Herring
	<robh@kernel.org>, "Krishnamoorthy, Saravanakrishnan"
	<skrishnamoorthy@rambus.com>, Shuah Khan <shuah@kernel.org>, Alexandre Ghiti
	<alex@ghiti.fr>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"Wittenauer, Joel" <Joel.Wittenauer@cryptography.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, Shuah
 Khan <skhan@linuxfoundation.org>, "Nguyen, Thi" <thin@rambus.com>
Subject: RE: [PATCH v4 04/19] crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
Thread-Topic: [PATCH v4 04/19] crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
Thread-Index: AQHdNN9iaUPmaZ+DjEW1WtISsJVxD7bI4yWAgAEbzvA=
Date: Fri, 11 Sep 2026 21:29:06 +0000
Message-ID:
 <SA3PR04MB900105B881F46FD7B90F7E3BD7BE2@SA3PR04MB9001.namprd04.prod.outlook.com>
References: <20260825221539.255951-1-aousherovitch@rambus.com>
 <20260825221539.255951-5-aousherovitch@rambus.com>
 <aqOEL-YUVFuThcmf@gondor.apana.org.au>
In-Reply-To: <aqOEL-YUVFuThcmf@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR04MB9001:EE_|BY5PR04MB6836:EE_
x-ms-office365-filtering-correlation-id: ec3da269-a28c-4916-f681-08df104bb573
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 K62nuIPoWtqRidPJAkIkPf1vKJPKZrr8zvO7O5qmhpMEcNIsURiMSC4IselObxhka3JAWnHwSPaFjeWVKBK9z3AaDAH/vH9PWwu8kpZydsKweS5i8ZU833oUQQnuye0I6lG0IwyYAaOJV8noX4YH4Q+3EVcmJD6i0HSV34KXUWoZF0p2LrTbaPU1iTN00FxEFmcBRwLPHTu+sKOp4PtYEFHD1gC2XNFtgkKKLb79e/IRfc6isg8PXR1HZR7z6stFjPPDNaK9y+lTepWuERo1D82KvIrSqjqkVcD39OGdlOcY9E8eb2JngVm+SAKbuc0WA47NWt+ZlnJzRaD4IfFr9wYi7Q4Y0o9VLwhtdInJgoKvfHU0s2gDDazKWjZM1GEdAf26T9SR/AadRql2NYPnw1dYsB0blWf875R45h9Lbe75gH3ul8odxfIjLX9JA1WCX+laQZFQONpb5KAx9Sv/Bt8FNKSU+S1KvoUV0EUKJazygckdqXrzUj7n+Zxsr9crSGcpMsi2tSDDpSS0lBfdtpr4m3N7OOH9fpOrCBQ9HpZS5RzQLGBpdePtXfygv8DUoMS26iSkmCAP02v+s+lBrnxaJykPCTowqH8Ku1u7Ta/R+GOipUSrCfNOYH86uYSXZKF2uwEEuCVdOQrfvBe6+f5oNG+7+XFRwyAefhZitujNosT3v+sbV2nCVBdeKEtCicGXJO/pQ2Ku0etV6w1FKpdhXAsqayLztR5rK+9km94=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR04MB9001.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?bBhwwm/bI6NcnbMZwkGILQFqR/cwZYge3EBtrSZ1Z8HwEz79YlXDXAd8PdSZ?=
 =?us-ascii?Q?hnXQQw1ytS2C75xWXklZnkmi+C6PBL/fRsY9PuP5NtowT5MRe8wWI6mTtGx5?=
 =?us-ascii?Q?9zux4TM9aqFZlFCMoNJR6q5JwgFpZo6WlxYfZ/r+e2XkHpux96M95mvjFBzq?=
 =?us-ascii?Q?x8B+No5WKQPBhByJ2JObfsoejGUFd7NZuTFq8/gTPlgp59ZnI3CrvXgFB8Nx?=
 =?us-ascii?Q?kNIQQVwg0JrVbLmBHF9Iuj2Un+cmcicaZdffkISMHeQ2iVpODw31JsQ+m7sO?=
 =?us-ascii?Q?OHCnX5yGBKJRUmSeiim4sr7g3uLpeFa7uJ4G9GxfY1tY6GWCOUtIgPJrq2dG?=
 =?us-ascii?Q?JQZC9wU3heVRUSYcH8qVZP/Bx/Rr3KWUqiKW/6YCtUr6Qshn7HbAYdklEInD?=
 =?us-ascii?Q?f9WP7thkLHDHkKF8zbWICtVAg2RofkEJrpQAAjaX1Me0H2GTsno0wqwxqE+Y?=
 =?us-ascii?Q?2SjBQR3L9wJvbrIe6Zzo5Y1SPM6/IhD8piOHRvKvT07zJn8K/hoxxJ2ajduT?=
 =?us-ascii?Q?98ej7hjW1tdThiM/N4NG32EX6BtLzFOve9bainvr4w4YkJ5xw4KeStvo2B9+?=
 =?us-ascii?Q?uzPznL815vQsUKo4mYxulhi3Pt+gnDm8PBzVdlsP7x31aMppG68287J7SqzA?=
 =?us-ascii?Q?V5PSarZAiN7t6qChswRkQfaz6ILQzbkLajCZs8H7m2jUEb4Ozol8yGSkt+Cy?=
 =?us-ascii?Q?MEcuwJSHYqzK+boJ1/Ra43zVJA70ikEGEx1kYC5Pqsqxu1CLzWUfck2z8m3w?=
 =?us-ascii?Q?h19fN3IRtnWkS/oyOoBs5dDg9IYQEjd4vv/CQN/vZiX7fqRbLf5o3kHOM2un?=
 =?us-ascii?Q?2KDCPPxs8V84MUcoWNPdTA3mWFuuidDPntwz7SH8LfFK3uekiPer1dmaz13V?=
 =?us-ascii?Q?C/Z5XRkN1j67Ptf1pYSZNuu7RyVwHsdwKcLHzwWFkOkLAJ4q75owyDkzS67F?=
 =?us-ascii?Q?NHucn0oFp2KuP2H+MjDeQztO6sjl1JU09oL2PrmDOQkrF4RGZaEWnYrVttAx?=
 =?us-ascii?Q?G4cZnHNu0ycLwORuSfRS6HCq4y9Ke+JorNUxW21y56LNG+dQ+wyDl1ygy2Mx?=
 =?us-ascii?Q?Vm5O06O5gshAYNmHFTTu/WWAzErUw3+fmSWPIbou4b/v3KgbZyM2YQwzOUeS?=
 =?us-ascii?Q?N/C+u66Tk7IIxtDOc/gW8/vWaON6TwNnDfaOMJGa7oim9iwukUIBfFEE5Rmo?=
 =?us-ascii?Q?7bbjBaZNSiT+EohnI/xk8EQPQCI8vgDxduJDfD4lCZSLXShVaQUnCJx1wcr8?=
 =?us-ascii?Q?206onyq90oacmam2TDD/3jxymS9y/uLyzg/u6uXLy6NBa06879qRY/VMjjJR?=
 =?us-ascii?Q?DlpuXUUS5o/eykdc/y5/VL1tP8o0JAMu/hz3+boJuGLtNke89ly4uRwUMyxL?=
 =?us-ascii?Q?z5AYZenl1iy4AKcpvFT+lmaX6qhqrVnxXcLuYAecK1QwESi9I41RoFjnsrZq?=
 =?us-ascii?Q?sQxmX5IbhjSI/t6MKGAH4ylAmvqg8E4IHUgfYmuuY2QSwglZIWVuSgi5kAM8?=
 =?us-ascii?Q?/lZTOy8857q7IFybyV+kHDsVyEUX7NBT3glvfd8wHBI4VABbPDgYVENb2flS?=
 =?us-ascii?Q?JRA6C8NhON/veiiAjHxzaa3Xjyttcy8ObwDxLbkHGfOgG1mHZ9I0g964yH0i?=
 =?us-ascii?Q?UABbDGR1BiGOy0fVhSaYTWoYNbtkD/CJ8MzHJgQr+kQpDwBPiRXuYXQ3N3g0?=
 =?us-ascii?Q?r551MDeDD/1ZjgIhwLyQ1uql1qBKNGs0nVmxPlfNFP+viVcUBWdbWgCyU6+7?=
 =?us-ascii?Q?PpLnnUf7nA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR04MB9001.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3da269-a28c-4916-f681-08df104bb573
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2026 21:29:06.2137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: utTWSI8OSUGXLBt894sZh2rit7D8lJbLq7CqLyuEREJ9CGGIsR/R72EAoMfT4DR8pchHYyn3R9hvIzWDJ9NmIXRSUWhe+792Ni7n9GdltS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6836

On Fri, Sep 11, 2026 at 02:31:43PM +1000, Herbert Xu wrote:
> Please drop block buffering in new drivers.  The Crypto API handles
> this for you.  Take a look at the aspeed driver for an example.

Done for v5.  The SHA-2/SHA-3/SHAKE, SM3 and cSHAKE ahash drivers now
set CRYPTO_AHASH_ALG_BLOCK_ONLY and let the Crypto API buffer partial
blocks (modelled on drivers/crypto/aspeed).  The hand-rolled holdback
is gone.
Since BLOCK_ONLY's buffering is scatterlist-based, these drivers also
drop CRYPTO_ALG_REQ_VIRT.
cSHAKE stays cra_blocksize 1 as an XOF, so the HC core buffers the
sub-rate remainder across its context save/restore.

Thanks,
Alex
