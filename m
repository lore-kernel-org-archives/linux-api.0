Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022078.outbound.protection.outlook.com [52.101.48.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A16B37BE7A;
	Tue, 11 Aug 2026 18:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472421; cv=fail; b=kLDa7F3nmlHRq+MVnqvcflOSYHBVvTknwUcNB1WB0HHYFF/AruO1zCfc3fJlkEJn9iiuhcl8zgkNJ+u+xpx9favjqvF+DfSOfqoAvUdjYEy/o5875YUqIHsVkv36iN8PtPfawZ+zlnQxbP3kN7YgMMY9QAUwQ9GCu7/Fn1vBMCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472421; c=relaxed/simple;
	bh=bZQBHqi1EMXwoJYZBQlC5sk0XIWEww21GsBSmVLri7M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lKUyoYcFEk+A99sw4fGovkEu/Dew/WucUVe21wqoCiRVmKjl74k0WuaeF6miT8dyzgAlstCecY4aqdH2IYjopVkRmEN6RfF9Dy9QfhpgLz7eGVHRcduhD6hbhBigoX5s8fHWI/OA9qoVEPtbOcNfboBTGQdMlwOmS04amK5lwvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=mHBU+SQh; arc=fail smtp.client-ip=52.101.48.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="mHBU+SQh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4UTBL6GL+T/K29E2pluidxbtAq26lZAZh4U4byw9HAVbz3x1c1QwHlgBflcEBHDFdVTL57gnt6/oih2/OKsOs3PkEL+bhC+GT/RgT+pfSn341jqmqwjgbAxqrCuYrrJr4+o0VAcvAsYFpAUgTlyKM+3vqWsvdCGp/HIjTFomeYTSGZOoHsRe/lgSTTu3fYVy/NvuFoBPmMGGneFVlMvWl49AtFjkH434RAlKByiR6zDr0p9mmNbnruMi7q6Gk/RTDOrQHELeI2i40TygOqqIGYgfDFYJarSqiVKZCbOcwko5W7YmR/ynp/o5FgwkDf5Apz2EFO2gmXBGDoivq6log==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZQBHqi1EMXwoJYZBQlC5sk0XIWEww21GsBSmVLri7M=;
 b=seZr8TO7JhNViOhNx5a9B7bHyDz4k43v+zVUxLxDtYhs3Orw36dVoRbFeymL6/ZZTIpB849vAeZ0bhTKwv8VCbtBGs2SPBdXG77/Q3xaGFDMOjYtzJf4D4IvxuI6fn8y22J8Of4Hpu+GhZ56gH1stlEbRCiGSS8yGtx06Sik8hWJ/0H9CsqG0ll04bXQocK9QS1sWGb2sdbw+/IlULMQxe9SkozTVE2xq4v6yrPvAio4mwpeOVq6hERBcsPVADUZWv2dC3y5vBM6rme0RlynuMNJnaiDnAyAGPi9xcr+TD6aAWnhgkBDTQmXK7Bu1K5LthU2o85TMyqf3V2DRq/tYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZQBHqi1EMXwoJYZBQlC5sk0XIWEww21GsBSmVLri7M=;
 b=mHBU+SQhWeDStyDRubcIOcaxTMGnrscySWWwxq+GnV5FF5BW9vV5ofA7+1xSCt/VLYznCvVvLuvG4FCRNyVkVN7hPY/20aoZdEojiAfVOd3dag9OyW+0dHPDspgNznQmg9S0o9HDoypcp3Bj2lo/HuINK8Nizs7OwLGG4Dr/swrkGdDACLH8pM0W2aqXQCT/VYobPdYSyLGZyxFg8rm/QlJe7ImpZDxpJyERbQyy+Y4xIql4VqLcxdB52ANykt6jcUpBDiocnuGfw2g9ZZWYhpfVz4+Obek2M4YgKnvJMWDPQ+wPP9HEMm8D6YFIngnj5Aga5tAlYGPzubShxpNtfA==
Received: from SA3PR04MB9001.namprd04.prod.outlook.com (2603:10b6:806:398::17)
 by SA3PR04MB8692.namprd04.prod.outlook.com (2603:10b6:806:2f0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 18:20:12 +0000
Received: from SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196]) by SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196%4]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 18:20:11 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Krzysztof Kozlowski <krzk@kernel.org>, "Krishnamoorthy, Saravanakrishnan"
	<skrishnamoorthy@rambus.com>
CC: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Herbert Xu
	<herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul
 Walmsley <pjw@kernel.org>, Rob Herring <robh@kernel.org>, Shuah Khan
	<shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "Wittenauer, Joel"
	<Joel.Wittenauer@cryptography.com>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, Shuah Khan <skhan@linuxfoundation.org>,
	"Nguyen, Thi" <thin@rambus.com>
Subject: RE: [PATCH v3 02/19] crypto: cmh - add core platform driver
Thread-Topic: [PATCH v3 02/19] crypto: cmh - add core platform driver
Thread-Index: AQHdJd2LtMX2FjDMV0GCzBlfTeqwP7aYjSsAgACjEFA=
Date: Tue, 11 Aug 2026 18:20:11 +0000
Message-ID:
 <SA3PR04MB9001E53F3731CFBC9ECE7EF3D7DD2@SA3PR04MB9001.namprd04.prod.outlook.com>
References: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
 <20260806195519.2703224-3-skrishnamoorthy@rambus.com>
 <20260811-notorious-humorous-frigatebird-ed4637@quoll>
In-Reply-To: <20260811-notorious-humorous-frigatebird-ed4637@quoll>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.11.2.117
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR04MB9001:EE_|SA3PR04MB8692:EE_
x-ms-office365-filtering-correlation-id: 599d8704-f141-4e32-3806-08def7d52ec6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|11063799006|56012099006|10067099003|4143699003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 7VLe9JF+xbz63vVs8ICGZGIOn4tX51rCaNsdjk44cR3xxRu9MP2Ra7CxKHR1iHlOdQIPoYaU8fqtwKByAnwvqIRRjayJVbcw8Q5K/pG2Fk+/S5jSqa/7E9BomglUyNByztvazdYjviY/5K7tz/vurcOxvQyDaWwk03F6N8adPmUBQK1hcjP3zo7Gz+eSMiVqNmsxzikc0lsx1Hv7eTSoDYH6W0ANnzf+1/Rtv/iymdRPQLZV06nb51YUkzNQPUBPd5b+DPNkWfQ0gTN3FBYaeOi4UnsaN+DMNjuf4MDFvKVoHKf3/FfLAitoWOAjxZnq4MwmZWvpRoM8byjnIujijC7ZEvoiqA1rEKtq+KF6lMVF6AfUMbI4jSnkoPOmeHytwiW4Dw/tfi80tNvfvxO3ZqxHUlUpNnKrdWXl1cuYBHlDNoYZ6EM9lveYBmprVnKzwRuH3QVhdrvuUFCeV1iknn59qnG5DSOm6BKvJH97OQuzfu4xv5GZscTKgW/pNyXn2wWE057i9y7qwa9Dr/JCncAXbmk4rqh46hmqlZHD+h/wkSaGjBFpqHQ2wxCzh2v4XFBVIWMNQmRokXTUVEstCSi0pi9nOIL6mSaE5ZUBMHEMSLK3OTAEZT6W3a08g9kqtVi4ArsgrKQA8OolNdfTuv+EA+czFBkmzOleRWx44SV5fQiGaRFyrASZlBBpF/DsNJqwU8pkIeybT3s1HMp33j8Liv1G0ax83s6OaBsm5dw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR04MB9001.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(11063799006)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RGtPdjk1N1Y0dTMwOGlDUmtmR0Q4L2hLK0E0NzdEMU1EcW4yd1ZxSDJscklZ?=
 =?utf-8?B?Ync5MDh0T0Q0aksvUGxYVHZVbHhMSjVDa3RJQnNwcnEvcUdHUjl2Z1A5R2s0?=
 =?utf-8?B?L3BZOU9MRndmRGxlYzZ1c1Z3VnpzWDllKzF3QnFNTUxtMnIxNThYdlhoUExq?=
 =?utf-8?B?azRGbWhhSytWQ1FPRzAwMUs5R25xRjQ2aXpmdDVDYjlxM0xNV2xjQ2txdGhm?=
 =?utf-8?B?d2Z0Zmt3UklGdlBwOU1jZzh0STEyQXU5VkFadlVOWDdrbGtmM0NkZm96bjBu?=
 =?utf-8?B?OHU0djl1K0Vaam4zTWlBcVhwek84L0U4NGdsWGtxcWU1cHhISVg0anIxbWgr?=
 =?utf-8?B?YmRQVFUvMGUvY0JSVEUzSC9YUEtBL09CdkpLdHA4VHJpOWFhZlNEejBvRC9R?=
 =?utf-8?B?QlNZVDBOWFZPRTJhbHRST1J1TElxTUd4S3dIbktYajZUbWVtZjdreTdwS0dr?=
 =?utf-8?B?Sk1IQWVqVFc4TUxzdTg3d25zem9IQTVOcEgxZWpNZHJEVG1xWnpqeXFhcnp2?=
 =?utf-8?B?WGdqR2lXcG1zZmppbTJoZnFZa2w0cFRZNVpPSDZoVWhsTDFjNUNKTWtDbm4z?=
 =?utf-8?B?ZkRlYmxlQ29GZ2Nac2pZOGY4Nm1qOENkRHNFd3RvS25JRXk3aTdodW1YSXQv?=
 =?utf-8?B?c2dSS25CRm9OREpBRTF4RzB0WGxhWk5jVzZ3U2hLeEpBTllOOUdLdGlERkl6?=
 =?utf-8?B?cHdDV3k5YitNYlNNMFZqeWtSamh6UFNSZlE3amgvcFpJNlRWZGQ1SGNJWlhl?=
 =?utf-8?B?YUtNdEY3UlE2cFczMTZvT3NMVWprUmI2Y2VHN05iTGsvSlc4eGgzTUNWQm9n?=
 =?utf-8?B?QVVEL09lSzdEbnVKTW1qVUc1WHVHNmFoK2pEYVpwWW1IdXJhM0svbmI2dzQv?=
 =?utf-8?B?SVZWcHFLeUJBalpwNHd0T3FwQkdGb1hhdmpjODlJR2w4WFBJQW8vYXdQeU1Z?=
 =?utf-8?B?MDdoNjdwYWhhUmlpbkpWZGZkdGMzSXhqTmdoRy81RTBZYlB0bzZEV2FaTDM1?=
 =?utf-8?B?c3RUMWJYMTF3NnBiVjhFdG4zRDA5cDlYUHRhNUY5OGtpN2QyQmUyN3hWNENR?=
 =?utf-8?B?K016cnRtNitIV3IxcXpuMWhickpqeXBRdVMyWG9UUUo4Mi9rZ2dySWIya1Zm?=
 =?utf-8?B?MjNoUlJOdE9XenI3d1gwZmYxblRreWhUWUQzR1ppQ0NlRVNqeFBESjVBb0Ja?=
 =?utf-8?B?ckJJN0J1cmlWZU9WeVZzemdLblhOa09qRGZzbGdaL250NUxaWFRYdlAxdWFR?=
 =?utf-8?B?SGgxb2l2TXBxSDVBRmRLMmdCVkZ0ajJKM3lLeWZpbnFQOWIra1Bwc0xUZGlr?=
 =?utf-8?B?b0p5M0ZmWHY2RWZtVEFKdVFsblQ4STd5S09WUzJvZG93eG9qSHFjMnZPRE5r?=
 =?utf-8?B?Qmpud05mSXNHMEFLSWttQ2JhSVpSdWE5ZlNoYkQvc2ozY1plUlVkQk00Sm9I?=
 =?utf-8?B?VjJqOGJodkVNb2hvVUFFRDZCYm1QMGxNT25GNXRaK3pEWGlZU3MvSDhqZmFO?=
 =?utf-8?B?QkZ0b0JicGxzVjMrclpXSWp4L251NzdqcnN0d1BNK1ZWY2RNeW5QL3UxM29C?=
 =?utf-8?B?Zi9ONFB1ejF6ME1DNjQ3NXJpTlZJcGJPZzFvbEh6R1plOFh3UHJVVVdrYkgz?=
 =?utf-8?B?Q3J1VDZuaE9BWGZsQzJRYkkxYjZNQmdkYmo4WVZGSEtXZWsvamF6U0xXL0V5?=
 =?utf-8?B?bExzRVE0QVRvVEhlTUg0c1gxd2VTOFNpTzlqek1nWjZPd21aK3R5Ykl6S1Nj?=
 =?utf-8?B?VGF2UWUxemtndjRwNGNLSXVEMEFCSlFxSGJyZUpkU25lZUZrSlJPSGFFb0Fk?=
 =?utf-8?B?TlZXdEw4TnVtU2Z3T1pJVFl1cjhad3E4UGJsVHh1Z0hIVTRWYXFuLzdlUy9R?=
 =?utf-8?B?NUY3M21GOFNDUmFMWisrRmVPcitDWEdaQU1SSDkrQnJ5eTBiQkZ3LzV3VWtz?=
 =?utf-8?B?NzlPdjh0L3B1NjVqaVBwWHRKZHJTSGFJemkvMGk1MEJLdTZySXdGeXBmVTB5?=
 =?utf-8?B?TXd0WXkwMCtpcHBiU0ZzYXRrSmEvenRuVDA3QzlFajBQa3hzdm11aGVsY0t0?=
 =?utf-8?B?MWJtSTMyc2x6U0NiWkZjbm01MVAvaU45aHNjRmRNK3prM0JZUEFCYXRybnNl?=
 =?utf-8?B?b2U4ajI5bXh6M01xKzgrQ2VwOEpCRXRBcHVzRW9tQXN6cXlSZUdrRVVOV200?=
 =?utf-8?B?STB3RjU2RDhtUlgzVExHL25MRDJBVEdiTkdrZDJRMkNwUnUva0lnOTMvbmN0?=
 =?utf-8?B?ZnNnRzdDUGxBZjlCNmtrNy9XZC92dTc5ZzJwaytsOFM3YTF0emd1WlZ0SU8w?=
 =?utf-8?B?aTRtdWpaUlNpRjNCQ0gxZXdTMzFLd0V0c2FMdThsdXJjVXhYS1B5UT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR04MB9001.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 599d8704-f141-4e32-3806-08def7d52ec6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2026 18:20:11.7375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IMMRCSqHVskUJ9SzXjxbVFYMrRwJ60yqADc4pjc60msqOcNtdMyCdDTw3LQiMoQ2BsnH6ajJ/O+N9hXuhxsS2vIhtTPDxIWvVEmgaOqAoaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8692

T24gVHVlLCBBdWcgMTEsIDIwMjYgYXQgMTA6MzY6MDZBTSArMDIwMCwgS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6a0BrZXJuZWwub3JnPiB3cm90ZToNCj4gRW50aXJlIHBvc3RpbmcgaGFzIG11bHRp
cGxlIGhpZ2ggYW5kIGNyaXRpY2FsIHJlcG9ydHMgZnJvbSBTYXNoaWtvLg0KDQpVbmRlcnN0b29k
LiBXZSBoYXZlIHRyaWFnZWQgYWxsIG9mIHRoZSB2MyBTYXNoaWtvIHJlcG9ydHM7IHRoZSBnZW51
aW5lDQppc3N1ZXMgYXJlIGZpeGVkIGFuZCB2NCB3aWxsIGNhcnJ5IHRoZSBmaXhlcy4NCg0KUmVn
YXJkcywNCkFsZXgNCg==
