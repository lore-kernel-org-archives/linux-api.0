Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023113.outbound.protection.outlook.com [40.93.201.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D2E2D738F;
	Tue, 11 Aug 2026 16:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786466999; cv=fail; b=R4Tejq5H384UIzCm5hGv7ZQLh6Q5Rdtu1TwtmsGhpFx5LdXfafCpApEtqvjSFn+XmOu3kY7vuOh77jk66JiQpZywhf7G8WSD57UsTgglqbwFRYe1K3mo8N3LSu+jJ934cj3HsRhDLdIWCSvG/RJK2+V2ja7deiSmwNrABjRPk70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786466999; c=relaxed/simple;
	bh=VFkJYcvQ/wCULA5rkuBrnHOGIEOLTaOxoEZ96MwasFE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GD2B11FlY43yiNxV4V2zzIqgYXWIM1UaukdaS7Y8RYLir0ev1iMIBy3Qc9TST8p1MIEz9U3YskwUBd8C5n0mLo2QPlsWiNeG8gvODNq3fyH0uCkyNV8UEqZB9AwU8j3wp7xWJYLahNAlzyp0Gu7ZJKlEFggR2zIcDWZk7RroFKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=L5bnu795; arc=fail smtp.client-ip=40.93.201.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="L5bnu795"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YgyQ767pUcnNVgr7+SCyf12TUvx9efvoU7Q45/p0MuiNriK3w2l4hn9kj/CcRfOYzUFLQDbrm3C0/jZ19GXk1RmAkltEaOJhIS8Bac3RQ0wgYqJBKVxyh5sNty+rJzHT1arlZhoQaTeyIc6+LVZNwsX+MXjUwCc/og9xVBPNLJAd6qMCmjkuWEMxuqofTVfCLXCdqDaLkzBc8GWXqCeVsaX5rgtdNETHjvVonkqOxmbxBs00EkzTStlkwOJN23qYjqP9RglK6J1L75vv/HteXImvBtZtEm9SKtPI8yw71NFd9tg26HeJsRPTWy3vLyzEadZMNoHMfDuKG4VAWc240w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFkJYcvQ/wCULA5rkuBrnHOGIEOLTaOxoEZ96MwasFE=;
 b=a83/WNRteObYuihK3aMk61MiYnptUEL9UeDuQDHwM004TTYeNTtFU3J+mpcS2huxIYx9TMPGVHkrVZ7H+zBNhW+64yuoFdsDTCXUleccqkmDqBx1yMihTzRXqOaZaQuigJcLtvtQ81HzpkmNl8Ro5seIn4FpBvUdXcH3/oIBV+TerNJN3tY4di2haE6F+0DYgK9Uo2Nc06Kqi5wvEisPLkEofnvz8id/KTJGc+R4z62IJmuFach7ugVrGPK+fbiDRVwHtrUp05wpLzzeKliN7WV95zyBMw+ZIxs1EtdyihJ7v0NP2LXqF52I5lx67EBTibhOQQua1ah69LJxrikX2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFkJYcvQ/wCULA5rkuBrnHOGIEOLTaOxoEZ96MwasFE=;
 b=L5bnu795Z1tqd4GASJkLnSrPDemTbrZ0bZatapcBsH7++b9BWv6wsZTef1YEBBmAYjYt/PDymrFygyuM34CStTGtUz8jrlaXkkyyB8Y1FgCwIsxOnVSgP5XIMFCUI9qC7bYJ5zV/G6DV0pheMePBs/M4PVxy3tPjla/+uqQSvVbN60s3joDooxXnQfKXwFkF+UAVQ4QHs0/PdPf7jNqwfmwPqN2G5y1UoG3wciN/AZcIiXi6bWGNJz83x5Ui8UhD7OJNeD5tyxPlTSRxSTEmZW8guEd+kXZSwjUIsdFT2FnrwpTcZZPCM3hE6FDGweuC3eeWT2zP/Z01h8nPXJP11w==
Received: from SA3PR04MB9001.namprd04.prod.outlook.com (2603:10b6:806:398::17)
 by PH0PR04MB7899.namprd04.prod.outlook.com (2603:10b6:510:ee::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 16:49:54 +0000
Received: from SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196]) by SA3PR04MB9001.namprd04.prod.outlook.com
 ([fe80::3da3:45d7:8860:e196%4]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 16:49:53 +0000
From: "Ousherovitch, Alex" <aousherovitch@rambus.com>
To: Krzysztof Kozlowski <krzk@kernel.org>, "Krishnamoorthy, Saravanakrishnan"
	<skrishnamoorthy@rambus.com>, Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley
	<conor+dt@kernel.org>, "David S. Miller" <davem@davemloft.net>, Herbert Xu
	<herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul
 Walmsley <pjw@kernel.org>, Rob Herring <robh@kernel.org>, Shuah Khan
	<shuah@kernel.org>
CC: Alexandre Ghiti <alex@ghiti.fr>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "Wittenauer, Joel"
	<Joel.Wittenauer@cryptography.com>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, Shuah Khan <skhan@linuxfoundation.org>,
	"Nguyen, Thi" <thin@rambus.com>
Subject: RE: [PATCH v3 01/19] dt-bindings: crypto: add Rambus CryptoManager
 Hub
Thread-Topic: [PATCH v3 01/19] dt-bindings: crypto: add Rambus CryptoManager
 Hub
Thread-Index: AQHdJd2KxV2i0y3L3ES0fC17MQpCTraW9VgAgAGWx4CAAH8HkA==
Date: Tue, 11 Aug 2026 16:49:53 +0000
Message-ID:
 <SA3PR04MB90016379260AE6C1E70E9374D7DD2@SA3PR04MB9001.namprd04.prod.outlook.com>
References: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
 <20260806195519.2703224-2-skrishnamoorthy@rambus.com>
 <778fef91-0610-4ddc-9d64-e6b45b30127f@kernel.org>
 <20260811-lyrical-aromatic-mouse-bbbd42@quoll>
In-Reply-To: <20260811-lyrical-aromatic-mouse-bbbd42@quoll>
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
x-ms-traffictypediagnostic: SA3PR04MB9001:EE_|PH0PR04MB7899:EE_
x-ms-office365-filtering-correlation-id: b0994b31-cbdc-467a-3cd0-08def7c8915f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|22082099003|18002099003|56012099006|11063799006|3023799007|38070700021|6133799003|4143699003|10067099003|921020;
x-microsoft-antispam-message-info:
 oYlCasjFLi6QsQCelYu4qtG8e1oxOBYWhIFtUTU3iHd1WeZGl6QBz4858VxyhKVtw4KJyvspFyzFDBzecPtyUoUeHarFf68LubCEoKXyvqhGzcqHfuToL1iQVetR/nuUKHKPy4LAhBeY7LHjaD3u61EKRKIHYWYm2BhE3voTlGIMbh3Osx/T+mTCd6Ym2i1CIU7y6Mi/Rlwysp+aI68xEJ1hc9Pe0+Jbv7mh8RCpS7kY8Ku6yWA29OSqKD+iFzQSmqw1aH8NiRlGoUOvlko+uDz7liOXLW+1N9ZWfwUnBO46dImeYa+RlJNyXORAgY9MK4KUVGaRtZ6JZhPEN4eDdsKyDzPsScSB1vF14FW5gDGer3XhWAdsJXuaKWcp+DYBFNRgRg5RADDIx3fBhllhE8AmVzFA1sFjWPp1PLXV8kHE0TdBtcTPcbyx7GqybR+W+eObT0JMaG3lltZIWberC5zcjn3mOfDGOtoldXO8jLXyZeakz6Xxd4ENkVjSxe3J11xy6U7e8NaaYeDRllYvZ+AvgiNVf7NjPqEtYl4e/ndWnRh5lM+PKGdM/4D4eaT666naSRw/6JO+CUKlUPq+T7f2eGdaO1WrZ/W8E0QnPc2PtxwyY2rig3gfpUX9eBNZsXhBge/3cSWpNQ5fxvCZXXvM8JA0oNazP36Y+r3IFUc52QKKUDJStMIO26rZHA2lNgdwb4OV9HpuXzgP2Ob6yPj8ZpAmj9BGFi/e8UHtzI+XvvwQb2pjMOvB+fKMfwwG
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR04MB9001.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007)(38070700021)(6133799003)(4143699003)(10067099003)(921020);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dlBDTU9zcTdlcXlYa09IWS9NZWZrM1A5ZUFndU1NZHUyQmI5WndGalY1djRt?=
 =?utf-8?B?WkdnSndxZVU1dmZQdmlTOGh0cS9kUFFINU5SNk44L1JqTzMvZW9MQURJQXNx?=
 =?utf-8?B?RTRYOGxBU01VSzZQTXcxVndxQlg3ZDdMTGRPanU5QTloLzRpQWRCZnJiQlc4?=
 =?utf-8?B?R2RLTmlHbWVvcTUwb0VlcWRoZ0R2UmxvSzRCaHdTejk5b0p5M2RSZ1I1cis3?=
 =?utf-8?B?Y1FUNFZyOFRmVzB0QmUrWFpKdmR2NG1IejBvMlRjN29IWWM1RmhqZkpDUW8r?=
 =?utf-8?B?TUlzcHRTbnZ6SVpXdjFKV3dpd2FqKzE1UWxBdmtnTWhYY0RZMkRHaG9NbnNC?=
 =?utf-8?B?WFYvVE1wWlF0UStEWmxpVTZ0b3ZjeVlVK0FkNGFMZEZ5NGpxNXdEVE93c1FX?=
 =?utf-8?B?c21OK3lLKytXcEptY2t2R0t6K0swektNUjBvbTdMbFUxRnhzck1xQldMc0V1?=
 =?utf-8?B?b0VZQUxIR1BKYXFkK1JwQklWY2ZGc05kVnVtbVpzdi9vTjMvNWttVldXL0xw?=
 =?utf-8?B?MlpTRE5MNkh1Yk45UXQ3T05jSUZTMHZyZTdwN1JlOHdhcm82bU8xcUJmMWJU?=
 =?utf-8?B?L0Q2QVM3bTRiRDk0M3lFZE9za2pxSzYxcDJEUmpWbWtYQlp0Ti93SUJ1cy9D?=
 =?utf-8?B?NFloMlo0c2hrNDk2dU8xc05ZRTBvYWExQXFaQ3o5eEVSd2x4Mk8ySTVFTGN6?=
 =?utf-8?B?Y0xEMUpqblc2MHdxQ1VRUUlVK3dtejNkV2ErdE9QR1d3V1V2S1hlckg0MXlv?=
 =?utf-8?B?TnRjbytlaGUrQklhMFRwVDNHN2wwekVSVVlXUEUrOFZkMlZLQnEvdHdJc3kr?=
 =?utf-8?B?Lzk4NGFHdzFBVjF0ejVuZVR3VW5rcVQ5dHdwNXFtQlJPa0w0anZiZVlJU0E5?=
 =?utf-8?B?aG8xMTBZbFhIY1pFeXFVT3VPbDVZbHBGWnRab29NSktRYU1LR2gyRDIyRVdU?=
 =?utf-8?B?aVdFRnFsNWZSdGh2OWJhSDVjVTEyL29ET0RUd2l4Ykh1S0F3ZjJYbkJKZGtl?=
 =?utf-8?B?UG1TanE2K00yN0tRQi8xN2xRbGRWeklrZEhkSXV5VTZOUDVlYVJ4MnVBT0Nq?=
 =?utf-8?B?L0pEWnI0RnN3bmYvN09mMXFxdzVzVW9XL0p0TXJ3ZFg0QW5qR0M5d0R3MTlG?=
 =?utf-8?B?ZTliNTJPbEFjcE90Uzh6OWZOTVdTay9XRHcvUGZ5TWtEYUp2MGtBTEVyNi9D?=
 =?utf-8?B?dm0vUU90WDVxcFNoOU9IRXhwL05ldkFGYjhCdklZcXZTclFENU8zdXBCa0ht?=
 =?utf-8?B?QmQ1RHAyZFVPZXJ3Mjgxb3ZUemk0NElZT0RBOFM0ak1ROHJXZVBTMGJsbHZs?=
 =?utf-8?B?YnBoL0Zxb3FrUDlJYWM3ZUhCb0hyUEdZMjVWTm14RWVsR283bnVXc2szeFVn?=
 =?utf-8?B?T1hGWDg3ek1ObTFBYUpZWVpjRjg5czg2aXFSc3lzaTNxSXIxOTJDam83K0tr?=
 =?utf-8?B?ZHl4RGpWU01wWFptZGFZQU8yV096VFNtVzFWRzFaTDBwRVlkVjBlVkgzc1Qv?=
 =?utf-8?B?cjZleURubnVCT3RCVUpRM3FVYnVGc0lYNTBNUEpMQjhDNVRvNVFDd0E3QytJ?=
 =?utf-8?B?Q2loeHZiNUNLWWVndFFtYkNPQzd0bnB1K3hxYTFiYjROQ2V2UmUwU21OTm1Y?=
 =?utf-8?B?YUd0QmhGVS9iUkxGSDVkTHJHT0Z4UUZIL1B4clFzekY2enM4ZzNRTU5wRUUr?=
 =?utf-8?B?TU1MT2VkYWc1T2Y1azVzT05jSXc4NjUwenlCOWNCZVY3L0dobVg2VkF2ZUty?=
 =?utf-8?B?Zk1oQTNhYy9uZys2R0xSZlEzTjBvTW9VVm1zc0hzOHhsODZrYm1vNDJ5N0lu?=
 =?utf-8?B?NmpBNXdnVENEWmJxRkhldkhGcHF0dHhZbnlRekFzYnp2ZWlqaHBGQ0N4ZEZJ?=
 =?utf-8?B?QXpzWVFTVHNXSE9qMmw2blUxWFRpUVBNS3BVRjNvelp4dW9jR2pzUWNkampI?=
 =?utf-8?B?bDdIVEt6MVZXa2FIUjBUdDJNdmhva01EV3pZTWVSWDZpbEs5MHNMeFZ1R2JZ?=
 =?utf-8?B?UWJQUnVWUEF2dUJ5NllYQlhieks1dzVkM2dwMGIybFFiVXpvQ1U5SEZRb3Zp?=
 =?utf-8?B?NUV4RzdzLzc5RG4rYVAwb2svVDdreStYaUNtRkJaUkNYVE1MZkZDcWoyVUph?=
 =?utf-8?B?dHBmdWtvZDZMNTRERDg3SS9KMFVpSFErT0JmdzVXQTk4amY4SmhHRk5ha2NY?=
 =?utf-8?B?SEkxZkJ1cFh4YUNZeEVJV3RmelBXK0ZmYUFWckJVc2Z3T05iU3hGK3JBNVNF?=
 =?utf-8?B?eWs2bmNLM2l4QllXVWM3VDY5V3dRTng4Tlh5MXArekZNeDA0Q1I3QjlEcjFp?=
 =?utf-8?B?VnZHT2ZLSGFRaGl0RHQrOXV0cm1UeWtzb3BFZ2lWZTkrT1lSLzdYUT09?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b0994b31-cbdc-467a-3cd0-08def7c8915f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2026 16:49:53.7182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eRd0mB28Xd/0fy7LujJdLprvxLroQFsx230QcaHafmcJEJsyk0eR3jFCaBMjZEL8i/QXw6jhpXjIK5SR7tOCHjMLVEKlYqeuE74UDTKqwMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7899

T24gMTAvMDgvMjAyNiAwMToxNiwgS3J6eXN6dG9mIEtvemxvd3NraSB3cm90ZToNCj4gPiBDby1k
ZXZlbG9wZWQtYnk6IFNhcmF2YW5ha3Jpc2huYW4gS3Jpc2huYW1vb3J0aHkgPHNrcmlzaG5hbW9v
cnRoeUByYW1idXMuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhcmF2YW5ha3Jpc2huYW4gS3Jp
c2huYW1vb3J0aHkgPHNrcmlzaG5hbW9vcnRoeUByYW1idXMuY29tPg0KPg0KPiBDb21wbGV0ZWx5
IG1lc3NlZCBvcmRlciBvZiB0YWdzLg0KPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFsZXggT3VzaGVy
b3ZpdGNoIDxhb3VzaGVyb3ZpdGNoQHJhbWJ1cy5jb20+DQo+DQo+IEhvdyBBbGV4IGNvdWxkIHNp
Z24gYWZ0ZXIgeW91Pw0KPg0KPiA+IFJldmlld2VkLWJ5OiBKb2VsIFdpdHRlbmF1ZXIgPEpvZWwu
V2l0dGVuYXVlckBjcnlwdG9ncmFwaHkuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBUaGkgTmd1eWVu
IDx0aGluQHJhbWJ1cy5jb20+DQo+DQo+IFlvdXIgU29CIGlzIHRoZSBsYXN0Lg0KPg0KPiBBcmUg
eW91IHN1cmUgdGhlc2UgcGVvcGxlIHJldmlld2VkIFRISVMgY29kZSBpbnN0ZWFkIG9mIGJsYW5r
ZXQtcmV2aWV3DQo+IGZvciBldmVyeXRoaW5nPw0KPg0KPiBEaWQgdGhleSBmaW5kIGFueSBpc3N1
ZXMgaW4gdGhlIHNjaGVtYSB3aGljaCB5b3UgZml4ZWQ/DQoNClJpZ2h0IC0gQWxleCBhdXRob3Jl
ZDsgU2FyYXZhbmFrcmlzaG5hbiBjby1kZXZlbG9wZWQgYW5kIHN1Ym1pdHRlZC4gV2Ugd2lsbA0K
Zml4IHRoZSB0cmFpbGVyIG9yZGVyIGFjcm9zcyB0aGUgc2VyaWVzIHRvOg0KDQogIFNpZ25lZC1v
ZmYtYnk6IEFsZXggT3VzaGVyb3ZpdGNoIDxhb3VzaGVyb3ZpdGNoQHJhbWJ1cy5jb20+DQogIENv
LWRldmVsb3BlZC1ieTogU2FyYXZhbmFrcmlzaG5hbiBLcmlzaG5hbW9vcnRoeSA8c2tyaXNobmFt
b29ydGh5QHJhbWJ1cy5jb20+DQogIFNpZ25lZC1vZmYtYnk6IFNhcmF2YW5ha3Jpc2huYW4gS3Jp
c2huYW1vb3J0aHkgPHNrcmlzaG5hbW9vcnRoeUByYW1idXMuY29tPg0KDQpXZSB3aWxsIGFsc28g
ZHJvcCB0aGUgaW50ZXJuYWwgUmV2aWV3ZWQtYnkgdGFnczsgcmV2aWV3ZXJzIGNhbiBhZGQgdGhl
bQ0Kb24tbGlzdCBpZiB0aGV5IGNob29zZS4NCg0KPiA+ICsgICAgICAiPHZlbmRvcj4sPHNvYz4t
Y21oIiBjb21wYXRpYmxlIGZpcnN0IHdpdGggInJhbWJ1cyxjbWgtdjEwMzAiIGFzIGENCj4gPiAr
ICAgICAgZmFsbGJhY2s7IHRoYXQgZXh0ZW5kZWQgZm9ybSB3aWxsIGJlIGFkZGVkIHdoZW4gc3Vj
aCBhIHBsYXRmb3JtIGlzDQo+ID4gKyAgICAgIHVwc3RyZWFtZWQuDQo+DQo+IENvbnNpZGVyaW5n
IGhvdyB2YXJpYWJsZSB0aGUgYmluZGluZyBsb29rcyBsaWtlLCB0aGlzIG5lZWRzIHJlYWwgU29D
DQo+IGNvbXBhdGlibGVzLg0KDQpBZ3JlZWQgLSB3ZSB3aWxsIG5vdCBrZWVwIGEgZ2VuZXJpYy1v
bmx5IGJpbmRpbmcuIFRoZSBTb0Mtc3BlY2lmaWMNCiI8dmVuZG9yPiw8c29jPi1jbWgiIGNvbXBh
dGlibGUgKHdpdGggInJhbWJ1cyxjbWgtdjEwMzAiIGFzIGZhbGxiYWNrKSB3aWxsIGJlDQphZGRl
ZCB0b2dldGhlciB3aXRoIHRoZSBjb3JyZXNwb25kaW5nIGluLXRyZWUgRFRTIHVzZXIgb25jZSB0
aGUgaW50ZWdyYXRpbmcNClNvQyBpcyB1cHN0cmVhbWFibGUuIFdlIHdpbGwga2VlcCByZWZpbmlu
ZyB0aGUgc2VyaWVzIG9uLWxpc3QgaW4gdGhlIG1lYW50aW1lDQpzbyBpdCBpcyByZWFkeSB0byBs
YW5kIHdpdGggdGhhdCB1c2VyLg0KDQo+ID4gKyAgICAgIHNpZGUtY2hhbm5lbC1wcm90ZWN0ZWQg
Y29yZXMpIGFuZCAicnQiICh0aGUgcmVhbC10aW1lIHRpY2sgY2xvY2sNCj4gPiArICAgICAgZm9y
IHRoZSBpbnRlcm5hbCB0aW1lcikuICBBYnNlbnQgb24gaW50ZWdyYXRpb25zIHdoZXJlIGEgc2Vw
YXJhdGUNCj4gPiArICAgICAgbWFuYWdlbWVudC9wb3dlciBjb250cm9sbGVyIG93bnMgdGhlIGNs
b2NrcyBhbmQgTGludXggaGFzIG5vIGNsb2NrDQo+ID4gKyAgICAgIGhhbmRsZS4NCj4NCj4gRG9u
J3QgcmVwZWF0IGNvbnN0cmFpbnRzIGluIGZyZWUgZm9ybSB0ZXh0Lg0KPg0KPiBMaXN0IHRoZSBp
dGVtcyBpbnN0ZWFkIHdpdGggZGVzY3JpcHRpb24uIG1pbkl0ZW1zIHN0YXlzLg0KDQpXaWxsIGRv
IC0gd2Ugd2lsbCBkcm9wIHRoZSBjb3VudC1yZXN0YXRpbmcgYW5kICJBYnNlbnQgb24uLi4iIHBy
b3NlIGFuZA0KZGVzY3JpYmUgdGhlIGNsb2NrcyBwZXIgaXRlbSwga2VlcGluZyBtaW5JdGVtczog
MS4gVGhlIGNsb2NrcyBhcmUgbm90IGENCnN0cmljdGx5IHBvc2l0aW9uYWwgbGlzdCAoY29yZS1k
aXYyIGlzIHByZXNlbnQgb25seSBvbiBTQ0EtY29yZQ0KY29uZmlndXJhdGlvbnMsIHdoaWxlIHJ0
IG1heSBiZSBwcmVzZW50IHdpdGhvdXQgaXQpLCBzbyB0aGUgdmFsaWQgbmFtZQ0KY29tYmluYXRp
b25zIHN0YXkgZW51bWVyYXRlZCBpbiBjbG9jay1uYW1lcyAob25lT2YpLg0KDQo+ID4gKyAgICAg
IE9uZSBub2RlIHBlciBoYXJkd2FyZSBtYWlsYm94IG93bmVkIGJ5IHRoaXMgaG9zdC4gIFRoZSBt
YWlsYm94ZXMgYQ0KPiA+ICsgICAgICBob3N0IG93bnMgYXJlIGFzc2lnbmVkIGJ5IHRoZSBtYW5h
Z2VtZW50IGhvc3QgYXQgaW50ZWdyYXRpb24gdGltZQ0KPg0KPiBTbyB0aGV5IGFyZSBTb0MtZGVk
dWNpYmxlLg0KPg0KPiA+ICsgICAgICBhbmQgY2Fubm90IGJlIHByb2JlZCwgc28gdGhleSBhcmUg
ZW51bWVyYXRlZCBoZXJlLg0KPg0KPiBXaGVyZSBhcmUgbWJveC1jZWxscz8NCg0KQ29ycmVjdCAt
IHRoZSBtYWlsYm94IHNldCBpcyBmaXhlZCBhdCBpbnRlZ3JhdGlvbiBhbmQgbGl2ZXMgaW4gdGhl
IFNvQyAuZHRzaTsNCldlIHdpbGwgcmV3b3JkIHRoaXMgYXMgYSBoYXJkd2FyZSBkZXNjcmlwdGlv
biBhbmQgZHJvcCB0aGUgImNhbm5vdCBiZSBwcm9iZWQiDQpmcmFtaW5nLiBUaGlzIGlzIG5vdCBh
IExpbnV4IG1haWxib3ggcHJvdmlkZXIgKGl0IGV4cG9zZXMgbm8gY2hhbm5lbHMgdG8gb3RoZXIN
CmNvbnN1bWVycyksIHNvIHRoZXJlIGFyZSBubyAjbWJveC1jZWxscy4gVG8gYXZvaWQgdGhhdCBj
b25ub3RhdGlvbiwgd2Ugd2lsbA0KcmVuYW1lIHRoZSAibWFpbGJveEAiIGNoaWxkIG5vZGVzIHRv
ICJxdWV1ZUAiLg0KDQo+ID4gKyAgICAgICAgICBDb21wbGV0aW9uL2Vycm9yIGludGVycnVwdCBm
b3IgdGhpcyBtYWlsYm94LiAgT3B0aW9uYWw7IHdoZW4gbm8NCj4NCj4gRG9uJ3QgcmVwZWF0IGNv
bnN0cmFpbnRzIGluIGZyZWUgZm9ybSB0ZXh0Lg0KPg0KPiBUaGUgc2NoZW1hIHRlbGxzIGlmIHNv
bWV0aGluZyBpcyBvcHRpb25hbCBvciBub3QuDQo+DQo+ID4gKyAgICAgICAgICBtYWlsYm94IGhh
cyBhbiBpbnRlcnJ1cHQgdGhlIGRyaXZlciBmYWxscyBiYWNrIHRvIHBvbGxpbmcuDQo+DQo+IERy
aXZlciBpcyB1c3VhbGx5IGlycmVsZXZhbnQgaGVyZSBhbmQgdGhhdCBpbnRlcm5hbCByZXZpZXcg
d2hpY2gNCj4gc3VwcG9zZWRseSBoYXBwZW4gZm9yIHRoaXMgY29kZSBzaG91bGQgdGVsbCB5b3Ug
dGhpcy4NCg0KQWdyZWVkIC0gd2Ugd2lsbCBjdXQgdGhpcyB0byAiQ29tcGxldGlvbi9lcnJvciBp
bnRlcnJ1cHQgZm9yIHRoaXMgbWFpbGJveC4iIGFuZA0KZHJvcCB0aGUgb3B0aW9uYWxpdHkgcmVz
dGF0ZW1lbnQgYW5kIHRoZSBkcml2ZXItYmVoYXZpb3IgZGVzY3JpcHRpb24uDQoNCj4gPiArICAg
ICAgICAgIGxvZzIgb2YgdGhlIG51bWJlciBvZiBWQ1EgcmluZyBzbG90cyB0aGUgZHJpdmVyIHBy
b3Zpc2lvbnMgZm9yDQo+DQo+IERyaXZlciBzdHVmZiBkb2VzIG5vdCBiZWxvbmcgdG8gRFQuDQo+
DQo+ID4gKyAgICAgICAgICA2ICg2NCBzbG90cykuDQo+DQo+IE1pc3NpbmcgZGVmYXVsdC4gQW55
d2F5LCBJIGRvIG5vdCB1bmRlcnN0YW5kIHdoeSBzdGFuZGFyZCBudW1iZXIgeW91DQo+IGV4cHJl
c3MgYXMgbG9nLiBzbG90cy1udW0gaXMgYSBudW1iZXIuIE51bWJlciBpcyAxLCAyIG9yIDQgZXRj
LiBOb3QNCj4gbG9nYXJpdGhtIG9mIHNvbWV0aGluZy4gRG8geW91IHNheTogSSBoYXZlIGxvZy04
IGRvbGxhcnMgaW4gbXkgd2FsbGV0Pw0KDQpVbmRlcnN0b29kIC0gd2Ugd2lsbCBleHByZXNzIHRo
ZXNlIGFzIHBsYWluIG51bWJlcnMgd2l0aCBkZWZhdWx0cyBpbnN0ZWFkIG9mDQpsb2cyOg0KDQog
IHJhbWJ1cyxudW0tc2xvdHM6ICAgICAgICAgZW51bSBbMiwgNCwgOCwgLi4uLCAzMjc2OF0sIGRl
ZmF1bHQgNjQNCiAgcmFtYnVzLHNsb3Qtc3RyaWRlLWJ5dGVzOiBlbnVtIFsxMjgsIDI1NiwgNTEy
LCAxMDI0XSwgZGVmYXVsdCA1MTINCg0KVGhlIGRyaXZlciBjb252ZXJ0cyB0byB0aGUgcmVnaXN0
ZXIncyBsb2cyIGVuY29kaW5nIGludGVybmFsbHkuIFdlIHdpbGwgYWxzbw0KZHJvcCB0aGUgImRy
aXZlciBwcm92aXNpb25zIiAvICJpbXBvc2VkIGJ5IHRoZSBoYXJkd2FyZSIgd29yZGluZyBhbmQg
ZGVzY3JpYmUNCnRoZW0gYXMgdGhlIHBlci1ib2FyZCBob3N0LW1lbW9yeSByaW5nIGdlb21ldHJ5
LiBUaGUgc2FtZSBhcHBsaWVzIHRvDQpyYW1idXMsc3RyaWRlcy1sb2cyLg0KDQpPbiB5b3VyIGZv
bGxvdy11cDoNCg0KPiBBbHNvIGZpbGVuYW1lIHNob3VsZCBtYXRjaCBjb21wYXRpYmxlLg0KDQpB
Z3JlZWQgLSB3ZSB3aWxsIHJlbmFtZSB0aGUgYmluZGluZyB0byByYW1idXMsY21oLXYxMDMwLnlh
bWwgdG8gbWF0Y2ggdGhlDQpjb21wYXRpYmxlLg0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoN
ClJlZ2FyZHMsDQpBbGV4DQoNCg==
