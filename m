Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844505;
	b=LjO/6UbuEyDjAgdZfDdmhqI4SXGO+oy12nReC8UMRb/Y6nWwW6PwkcBmBvVi+9TQ2A4n
	 kOTBdcHdJQolwziIpFgmw+lEP94pjdkHarqrEexgJ+9i5z3wjpEEQisSD6QeZseXG9v12
	 Dgmo7TOmFsyPMqnQ32YS17LT7tyQdtU7iW130CbHhm/ykDvyz75RjM+lTnkrHRLGFl7la
	 MbIS0bvr3+8G2mDe4XjII139JkBXgnOEJ8lUZqcXgsKrCO/uJt/par6Y+ZRT/h6w4pVSq
	 2NYlo8a9bMl8gh0QKpl3kM2bM0pw80gOcbWS6u8qxO/5F/OzXeRQuiRaJMVaeUykebg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844505;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=OwDPfwbuPswJhCNRDJlO9rvOVCSCy+LBNbyYHF2t2TU=;
	b=optgNPbvALngt751S/p+OTP+A1oQwBZi62MRLalWRQCJ2rroVmGD5BcMy1SPm41oX2a2
	 mGlXDCNtYBP5XLTZnnMg04EZjyIZPhHMwc4BhGTs+b4i7wj3kS7sFz3aTatw28Pem/vfw
	 SZrvs52Ciaxz9WDHyIMcZ7ldHkA6vJN/MEx/7TQR8gCpbuzOJ3Xavfav4Zwg/nCdba1vo
	 xM+ZsF/YhH/YKytHn5+8RFNovzOBr5QJh8Kbw6fysK79J2bVD2gAzjuqY15cQabjx4s2M
	 /Kt863AuymF4Q3i3wFGVMJna+T04bFN2XVUaYCxl1qCIbaYESIwlaPTl++5Nwu6Ku4w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=sC7zG9B4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.10
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19012010.outbound.protection.outlook.com [52.103.23.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F0C606A320;
	Sat, 24 Oct 2026 12:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9F0C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=sC7zG9B4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TgamToQuEyBhhYOakWrYySnt/Kz+UlEzROwYmj3q1j+gAgwAgGv4F247W9wdDwwN3i2GIpbjTk7B6dOyNV4jBICt1wOz/ymSAt3JQ7NhMJge2eehWX65guHsrS96Gq/UURp7kuNK4JApsUbQJkPo2kCkmc4hT3kDYrCoaPR6uKaAMdbBHFmDQvfeIfjCNFEhcmwCHT159cx4S+qcO0mH1/MEl4Xe6PNvqWmjFc+C207WYFDjbpOy4Wrr3elrdhKC6Kzp9PwSuJ/snj8yIhclnQ296K0J123RybVXtysGlJJlFyUoU3I4NclYidiLH1eQ+AJryvgXTHcMVUiVgJDkmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=OwDPfwbuPswJhCNRDJlO9rvOVCSCy+LBNbyYHF2t2TU=;
 b=KP9JbKmmmAUG6ivcVBfu8ahjCc2fJhUdXtJsVciI2yXdRayfRbKV5uVN0zi5eOkaVyFMX37uFYSLEY46aAXSL21swTU56zMiYMp4MBufQ1UWsbJykefZDRsg7AHsx8+BOhKjseWZOnuC+/kEroWf1E+G3gEElccbev5ZpImgxqj7AndydN1jAEb1xzmPyeKvzFA+xu7wBMsMHK3UH6HtBnd/yyNKx8BjlKQxnsE6qm/P7k2LYtMMhBEBaStHGgrO3Iyy1UbWyCQU77Gpl1iJ1Zy1iQeJQc/jE34+/VbAnnie6RLKURO3r0UemCxtx97eos+QTkIWrZ6WWdp4G31+og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwDPfwbuPswJhCNRDJlO9rvOVCSCy+LBNbyYHF2t2TU=;
 b=sC7zG9B4BqoHTV4C+ti4j2o/akT001WGldUDMcpC2GpYk9QmYbp/cU6HcLaFOqgCdpz7qvh+OvAdwk72anI7UYtbJLN2TST0ZHqleoRuVj7gum/CkDW2V6YScpOwwQ1uRt3rnDzpPyZgdeLgEdXHHCa8Mf4XRjgKVFcJq6ysuyB8NQFeQqG/wCzskVn1vmio2UboezPBu2BVXI8g6o0VJxTDbpM6fafw5DjjO4HQ5KpAi8NgYlyEjVexkaqCQA5FNXD+elBuA2VRAwTeGAJM+d0Py+dZpQnsBNxk9KtmbStbTVpAEot2uK+xDslvAwFrfWogpMAxmO/oFVog+IJlJg==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH7PR05MB9058.namprd05.prod.outlook.com
 (2603:10b6:510:1fe::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.20; Sat, 24 Oct
 2026 12:21:41 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 12:21:41 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Manfred Spraul
	<manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, "Eric W .
 Biederman" <ebiederm@xmission.com>
CC: Yingjie Wang <x-professor@outlook.com>, Vasily Averin
	<vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, =?utf-8?B?TWljaGFsIEtvdXRuw70=?=
	<mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Alejandro Colomar
	<alx@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v3 1/3] ipc/sem: account enlarged sops arrays to memcg
Thread-Topic: [PATCH v3 1/3] ipc/sem: account enlarged sops arrays to memcg
Thread-Index: AQHdY7I5+7KGvRyM9Eaj2Ub3pY3rbQ==
Date: Sat, 24 Oct 2026 12:21:41 +0000
Message-ID:
 <edbb4aa04440205874d8a02a7f18e82d8188b937.1792808260.git.x-professor@outlook.com>
References: <cover.1792808260.git.x-professor@outlook.com>
In-Reply-To: <cover.1792808260.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH7PR05MB9058:EE_
x-ms-office365-filtering-correlation-id: 5f46a94d-72ca-4a8c-cddb-08df31c95c4d
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|12121999013|8060799015|8062599012|31061999003|25010399006|4140399003|24021099003|38102599003|15080799012|11091999009|21061999006|41001999006|24121999003|22091999003|1602099012|40105399003|53005399003|10035399007|26121999007|102099032|440099028|3412199025|4302099013|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?aDg5ZEFhZjFMblVUc0c1VFRjaUdGYXg2b0VLbG9oZktvemw1dy82YW02KzFr?=
 =?utf-8?B?REU4dmxISUdFZi9KVUJVT2RRL1FJL3ZPWXZEbXhrTytPbFVzenpicjA4TzNK?=
 =?utf-8?B?YWc1VDU5bmplNDJIa3RsSXUvUkNZekpYQWxBdWl0WWlRMlpaaEFYNDRCWDhm?=
 =?utf-8?B?eWNLQkxadjJGaWNaSG9yU0F3ZGhYQlVmbXFTdmVTeVYvdHZWeGcxcDdxQkF2?=
 =?utf-8?B?L1dQVjR1QTdEV2ZiQW5CdWtYRUZHekdDeDNiRkdRLzR3cEhxKzhWTEJaMjNH?=
 =?utf-8?B?dTdkeld6a09MTWljVVFSNWQvcVh6QXdFTDcyYnZJUWVTZm1OUzR0Ky9nNWlp?=
 =?utf-8?B?STc5UUlsYjhsTURJTVUzdmtkVEgrclVWdUkxM0JMbU96RnVOaVppOXI1YzVZ?=
 =?utf-8?B?L2x1MUhHVldvaFpCc21xdjBVZC9tcmF5ZW5WZEJicEZWMy9jc0FVOTk1T0l3?=
 =?utf-8?B?V2ZvMXM5TXFPTFRNS0wrd0Jpem9yZElFZXlUWDJGZitIc1d1NUZTdjg3OW04?=
 =?utf-8?B?MmVJcnMzeGQ4cHlqTTJZN3l0djREekQ1UHFrQXQwaldOTzFBRnkzeFBTcWkv?=
 =?utf-8?B?a2d2ei9qWWlSTkNqU1BsWXdlUlBHQmZ0blBwTCtOdzlqM1NXSmtBYzZYV0lB?=
 =?utf-8?B?VS9CbGhHWFN0UTdLL2phbmgwdkNRMzBpV0pISzY0RkNKQVNDQnlUa0RRQW0r?=
 =?utf-8?B?L2l5YXV1akVMVUhIVTlnek5MR1M1WDVlaHZLbEpGVlhnRnlaOENiL3Ntbyt4?=
 =?utf-8?B?UDVBY25HeGd1QWd2eVVhaXpkOVp2Q1NRem4ydmY5VnpzbEJYRFlTc0gzNmFt?=
 =?utf-8?B?UkNMZzM2VHBFbFBhN3g3MG4zODFYZmZjVlg2Q01lQTFLb3c4REdFNVFBQ1NF?=
 =?utf-8?B?N09RYlFEVFNTQWRoWVRyQ0dZQWttQUI1TUtxZWZoYWFTWk9VSDJIVUt4VnlX?=
 =?utf-8?B?VFdRQjdJU3JacEZWR2FyNExEWWFSRDR0V2FNTHJQTVlwcTRyZDlseDhsQXdQ?=
 =?utf-8?B?czZ4WXhlN000Y3hBK0dNR01lZTRuWXVYazNCekMxbHBXUFYzQ0l5VG43eTNP?=
 =?utf-8?B?aEhSd3ZKbHBtNFh2OEdsYnNjcDNvTEZVTG9RUXhDWnVSazBYSWRsMWNVZFVF?=
 =?utf-8?B?Q3FKOFM5VVJnT2N4cG9HL01aQlJZMHI1d0U5dTc1UEQ2OVZIVTF4bmVPb3VP?=
 =?utf-8?B?OE1yRGpWN0pqTDQrZXRNbGFQZnZ3TThFSkMyMTJuWjJvaGxJMklYUmdVL0hC?=
 =?utf-8?B?NmlzaTk5N25Ya21KRkUvdUVvUDVJYUpHak9mM1dGU0lsSE9OV2w1QXpHdjE2?=
 =?utf-8?B?eEpDMjhodGY0V1IzYUJoc2lTS3NHazBvc1pocm9HeHVuZ2ZqclU3OGtKRmNN?=
 =?utf-8?B?Y2toZnZoUkhlSklBRm9mR0lQOWxpeHF4Znl3K1o3K0g5VGhiY0s2ZERrbUtI?=
 =?utf-8?B?VGUrdlhZRHppVHZySzRwUERQYi9oR0VCbjQ5b1krVy9tTE5TeHVjcU5nWDVk?=
 =?utf-8?B?dk1hR1JYV3FmRXFkcEg0N2JnVWkwWUlhWDcyYlEyOG12bW50OHEwRE5PNXUw?=
 =?utf-8?B?cVFad1FPby9hL1FlV0NIOTVRYklGaXlYTDN0bGxlZS9CVkhzTEJnWERrNXRC?=
 =?utf-8?B?SUtuMEdMWjlpQk42RVlxR1VlV3NPME4ra2wvMEE3dUtBN0I2Qk5vK3dyWXBv?=
 =?utf-8?Q?QnM3u6cNZ3QIQDWGKJRv?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VVl6Mlk1OVR6M1B6QldObXZhY3hKTDVEaFEwMmF3Z0k3MFdXQk0ydHNoUGVF?=
 =?utf-8?B?Q28wZ0xYc0dMR0lyeUZsb3pUczgxbkVpR3NGdm9UeVRjeVhHZ2Z4V3hCN3lD?=
 =?utf-8?B?NWlsdjJLekM1NnlMcVRNZStXN1plY3VNSkdCbXZ0bXczMzIxNEF6THA3MmRy?=
 =?utf-8?B?a3F2OFZwQWR0NVloVFVKNm1ObFFyZ2VXVHFwOFBTSjl2c3FFcmZTMlZZekxP?=
 =?utf-8?B?UVp6Q0I2THN2bmdiSDJxNTJ2S1RoR1ZHdGVEUFF0bnU5RG9zL1RIY2hCRHF4?=
 =?utf-8?B?Nk9RUlVjRUtzV2g0V21FdmtueEtsV3doWmY0SGxWa0ovdVpzUXY1TkRUU3JP?=
 =?utf-8?B?cldjSElZVlZTeG9zeDN2blk3a2xzMFp1VVo2Q1Jlc1J6dlh5NmR5bERXY29z?=
 =?utf-8?B?djh1Nklzbjd1MmFZOWp1aTZFMXRuZVRkMUJuQTFpQ2JPTE1Bemk2L2w5QXhq?=
 =?utf-8?B?YWQwamJIa0dxMGNianhOcTl0bnBQM0p2MGdBQXYrWTJFaGFLa1p1Tm02b3lm?=
 =?utf-8?B?MnB6eUU1eFZHT3Z1MlEyYlp4Uk9nOWtvNGYwa0tMKzRpbVVuUitZbjBDTHVG?=
 =?utf-8?B?aE5kNGprVHdoYVNyZFJiUlJxMnFaZUlZU2dPY0NjeUg4RExpY2o5WVZCclZP?=
 =?utf-8?B?eHRXcEs1bXpwQlRlRzg2T1JodzdqOXZqdDBlS0FFa1JLTUZBVVgvdktXTCtK?=
 =?utf-8?B?RlBld0NTQmFQRUExVzlodG9BbEp1d0I2NUwydTRUWEMzcGx0LytMWHVHMGpY?=
 =?utf-8?B?TFYvTmF6dk0vTFJJNTd4VGhla013L0xrRWVkeXNyUTBhNnoyNXFSMWkwWC8z?=
 =?utf-8?B?WnZOZUJxdXR2SURFQkhrU2lKSS9hMHcyVCtQbGllbGc0TWxlTUhKRTZxYU5q?=
 =?utf-8?B?U2dKd2ZjbUQvTFgwa3UydkJKcXVuWTBmMWk0T2lQUE50eE5TU1QySmt6ZjYr?=
 =?utf-8?B?ZzNONmlmbjdHWCtrSEgrblZkd2kvL2ROVFp1WnhoMERISnNWcjdETnQvdG8r?=
 =?utf-8?B?KzFLUndUN1p6VjN3WTVXRFdtSzFENW53cEltQlJHVzJOQ2pLK1ZqeHEyb3A1?=
 =?utf-8?B?cVlsMlZSYVF3MTREUFpleUJBWml4RzErWmczWmY5VnE5NmszVytZc1N5VDZ4?=
 =?utf-8?B?eVUxUXFtRi9LSlUzWnZTS2VoRG9yM0N1T0NkNWVueWNhMmN3VWJvZ0lTZHl6?=
 =?utf-8?B?UU9rQVNJb09CU29WN1BWT2dnTW4zVWhwZTV4M3dYUjBSNE81R1NBdVM1dEtv?=
 =?utf-8?B?K04vK3ByWFM2WUQ2Ry9UNkttWisxRW9LdTZxWjNYVUR5SXQxOFZmSkEzcXZC?=
 =?utf-8?B?aENOeVJ5RkkrOHBQZUlBVVNDaTZRSmtxVFN2OEtEOUpyenRDck5EODdNRFBJ?=
 =?utf-8?B?NWl4eXQ3OXlqcUtzaTBYeDluYUxJMU1EK1Z4aXlXcUNTMTFIdmsrRE5GeVJy?=
 =?utf-8?B?MC9rUkF3cVQzRlpidDM0TkNOUGRHSjhjS1dxMXJReitWODhVVWt4Z2RmZ3Rs?=
 =?utf-8?B?YThvV1RoQjY2bUlyRE1Ib09hcWtBa3BwcW9GOUl0cWZ0dlNCbldrYUt0SHJr?=
 =?utf-8?B?Ym0zajBZT3M2T21pbGZmMEdMRFBuQ3d0SzZiWXFTcTBVaytnb3IvbVR5OGMw?=
 =?utf-8?B?V2tpTTcrcEJ2STNGQzdScUthSGtHaENwV1ZESURCdVhTNlBYSTV3L3J6UVBn?=
 =?utf-8?B?U1dvU1B1YlFJWG1ibkx5dEdRV3pvRGtjZllNVWVTalY2VEF1VW50TUtwUUFq?=
 =?utf-8?B?dE1wVnlGdzR5SmZIYUhraEtSUDY0MXA2bmtZd3RZTy9saEk0MjNuSStWMDNo?=
 =?utf-8?B?US9tZndhU05QdHJUZ1l3V0xhRHlWWnoraVlvWHcrNk9vQ3luWmpPcU1OS2hN?=
 =?utf-8?Q?2Akgl6MC34fe3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f46a94d-72ca-4a8c-cddb-08df31c95c4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2026 12:21:41.5661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR05MB9058

Q29tbWl0IDZhNDc0NmJhMDYxOSAoImlwYzogcmVtb3ZlIG1lbWNnIGFjY291bnRpbmcgZm9yIHNv
cHMgb2JqZWN0cyBpbgpkb19zZW10aW1lZG9wKCkiKSByZW1vdmVkIGFjY291bnRpbmcgYmFzZWQg
b24gdGhlIGFzc3VtcHRpb24gdGhhdCBzb3BzCmFycmF5cyB3b3VsZCByZW1haW4gc21hbGwsIGRl
c2NyaWJpbmcgYSBtYXhpbXVtIGNvc3Qgb2YgdHdvIHBhZ2VzLgoKU0VNT1BNIGlzIGEgVUFQSSBk
ZWZhdWx0IHRoYXQgY2FuIGJlIGNoYW5nZWQgd2hlbiByZWJ1aWxkaW5nIHRoZSBrZXJuZWwuCkl0
IG11c3Qgbm90IGFsc28gZGVmaW5lIHRoZSBhY2NvdW50aW5nIHBvbGljeSwgc2luY2UgY2hhbmdp
bmcgdGhhdCBkZWZhdWx0CndvdWxkIGVubGFyZ2UgdGhlIHVuYWNjb3VudGVkIHJhbmdlLgoKS2Vl
cCB0aGUgaGlzdG9yaWNhbCBzbWFsbC1hcnJheSByYW5nZSB1bmFjY291bnRlZCB3aXRoIGEgZml4
ZWQgaW50ZXJuYWwKdGhyZXNob2xkIG9mIDEwMDAgb3BlcmF0aW9ucywgYW5kIHVzZSBHRlBfS0VS
TkVMX0FDQ09VTlQgd2hlbiB0aGUgYWN0dWFsCm5zb3BzIGV4Y2VlZHMgaXQuIFJlcXVlc3RzIHdp
dGhpbiB0aGF0IHJhbmdlIHJldGFpbiB0aGUgZXhpc3RpbmcgYWxsb2NhdGlvbgpiZWhhdmlvciwg
d2hpbGUgbGFyZ2VyIHVzZXItY29udHJvbGxlZCBhcnJheXMgYXJlIGNoYXJnZWQgdG8gdGhlIGNh
bGxlcidzCm1lbW9yeSBjZ3JvdXAuCgpDb21taXQgNTBlYzQ5OWI5YTQzICgic3lzY3RsOiBhbGxv
dyBjaGFuZ2Ugc3lzdGVtIHYgaXBjIHN5c2N0bHMgaW5zaWRlIGlwYwpuYW1lc3BhY2UiKSBsYXRl
ciBtYWRlIHRoZSBwZXItbmFtZXNwYWNlIGxpbWl0IHR1bmFibGUgYnkgSVBDIG5hbWVzcGFjZQpv
d25lcnMgd2l0aG91dCBjYXBhYmlsaXRpZXMgaW4gdGhlIGluaXRpYWwgdXNlciBuYW1lc3BhY2Uu
CgpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjYxMDE2MTUyNjA5LjI1Mjg4MDUt
MS14LXByb2Zlc3NvckBvdXRsb29rLmNvbQpGaXhlczogNmE0NzQ2YmEwNjE5ICgiaXBjOiByZW1v
dmUgbWVtY2cgYWNjb3VudGluZyBmb3Igc29wcyBvYmplY3RzIGluIGRvX3NlbXRpbWVkb3AoKSIp
CkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFlpbmdqaWUgV2FuZyA8
eC1wcm9mZXNzb3JAb3V0bG9vay5jb20+Ci0tLQogaXBjL3NlbS5jIHwgNiArKysrKy0KIDEgZmls
ZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9p
cGMvc2VtLmMgYi9pcGMvc2VtLmMKaW5kZXggNWVjNDFkZTdlODViMi4uYThjOTgwNzE3NTUyMCAx
MDA2NDQKLS0tIGEvaXBjL3NlbS5jCisrKyBiL2lwYy9zZW0uYwpAQCAtMTc2LDYgKzE3Niw3IEBA
IHN0YXRpYyBpbnQgc3lzdmlwY19zZW1fcHJvY19zaG93KHN0cnVjdCBzZXFfZmlsZSAqcywgdm9p
ZCAqaXQpOwogCiAjZGVmaW5lIFNFTU1TTF9GQVNUCTI1NiAvKiA1MTIgYnl0ZXMgb24gc3RhY2sg
Ki8KICNkZWZpbmUgU0VNT1BNX0ZBU1QJNjQgIC8qIH4gMzcyIGJ5dGVzIG9uIHN0YWNrICovCisj
ZGVmaW5lIFNFTU9QTV9OT0FDQ09VTlQJMTAwMCAvKiB+IDIgcGFnZXMgZm9yIHN0cnVjdCBzZW1i
dWYgKi8KIAogLyoKICAqIFN3aXRjaGluZyBmcm9tIHRoZSBtb2RlIHN1aXRhYmxlIGZvciBzaW1w
bGUgb3BzCkBAIC0yMjM0LDcgKzIyMzUsMTAgQEAgc3RhdGljIGxvbmcgZG9fc2VtdGltZWRvcChp
bnQgc2VtaWQsIHN0cnVjdCBzZW1idWYgX191c2VyICp0c29wcywKIAkJcmV0dXJuIC1FSU5WQUw7
CiAKIAlpZiAobnNvcHMgPiBTRU1PUE1fRkFTVCkgewotCQlzb3BzID0ga3ZtYWxsb2Nfb2Jqcygq
c29wcywgbnNvcHMpOworCQlnZnBfdCBnZnAgPSBuc29wcyA+IFNFTU9QTV9OT0FDQ09VTlQgPwor
CQkJR0ZQX0tFUk5FTF9BQ0NPVU5UIDogR0ZQX0tFUk5FTDsKKworCQlzb3BzID0ga3ZtYWxsb2Nf
b2Jqcygqc29wcywgbnNvcHMsIGdmcCk7CiAJCWlmIChzb3BzID09IE5VTEwpCiAJCQlyZXR1cm4g
LUVOT01FTTsKIAl9Ci0tIAoyLjQzLjAKCg==
