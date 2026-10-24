Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844505;
	b=VQLK9yy1WOP4ouersKSiOlUB2kMKXD4rUIVjqE/OnpquTTOcF3rRvtJfgxfpZJt9L6Iy
	 61+881VILjwM++VoVDgtBgABAo3k1edKZHE2jsnT9ZwAFHZBf9a+mhvaJ4StuquDyyUSO
	 cI3e9ISI16rrlsF+P+QSXiXYIVWw7KTjaAW5uiPk9Usa82xmfwfr9Uvt60PGvTfhnOfcT
	 TLptgPlv+z397mRcY83Vimzx14Hrm1bGFwJyFeGHsMzas3EbB4yWDTpA1A0ijsg0VFi1R
	 WmyCbRyD7pXw9Q5Xmh6FXdQi0vK3SHdNKBjmGli+WG+FdM+nGrWwz9bcpV0DsPcwLnQ==
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
	bh=Hyl5+lDZqnN5PTRLGAgGuKcIgPNcV2DQrwDC9MAalaQ=;
	b=AuP/y5nM9lPZwnqxl4+NgDdtUnVtotvoSwzpqHu63sLmCIpqq0XnmTvK7Q4UvCSeobMM
	 9UKEDkz0XUhONcBZ9kGAwx2o2aoEqZhty9TMTJ2ckbCRja5XK1T4pWvtikOdB8Q3ihX50
	 WwXL8bAKjQyMZsEk+wqDd+L2p6X8GtBQnGWZFizSZvJTuqx92PBU8y24mLKKpNXav0hrh
	 0QTzCAUM6lj5Gh1P74a5OThPtW+pL9000Wv8XYTMn1jZ0MQyu+vVzexLbXrPos0GOXZ5E
	 yeVkcW/j5Riwx8MB+hOxNNuPYxgqAyd8+W5PX5hJL0n1dwSKjKR3s/LXfhsEqw3RwlQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=halRmGou;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.10
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19012010.outbound.protection.outlook.com [52.103.23.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441DB606A32A;
	Sat, 24 Oct 2026 12:21:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 441DB606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=halRmGou
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AopElePuodRH9MBQtfiNSaNd6Dy5NjchCAkfW+38zsuTqgVoRmxDI1LPIqXpnDwnnOusfBi7plUtxhnVt48pHFDMxJls8bke5+izdO8WC5EXXvWs6bwxcYqicRlaqhBXJOOegnBDSlby2I7XksLtNKbJiCLoeWZQiO6CzoowLrqq44LAp+PPe9mKaz3J0saDU54SuUrdQ9JLGQmSFDU9SangHD5Kzg5hSN6JbzNzv69/+QHmMb+bh8XxrR7w2l2ujHK+DFeMN9303gQzEaQuPHCuXT/I7agGu0fX0XqWwZ+AYUYb/TzmQRumtBQZOOS+J/0pTb/4TprsB8iEN7ecPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=Hyl5+lDZqnN5PTRLGAgGuKcIgPNcV2DQrwDC9MAalaQ=;
 b=vlXOtF6pZ9oCd6K7J38seRk6Nw0X79OYvRV+qSjXaYxl7Kwm0QkZ8L16bPMt2GtfKG5eKhnWS27lNgw8shN2ImSK7F2ram0tjNYky6IHRj6pe71FaXXUU+Kl0X0UFNMbtMeMSfJbLQSciMKGF6yN2Hn26qagGvO6e9z02ngwtIWojBWaOUiKN2BDIKV6VGsfFOva9DmkgT1leMbbBhWTZoHrPH4t+MBSmJ7NzhVcdzsOvvfMjKFZMuB0iA+05p/V0m+U131DaSQJpwy97+qvUlZXtpjyEU6z3hPNOmaD7mjz/SRPSK7oEyp1A5Gar+ZGcbAJ9Ojq4MpGTbWHkngGVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hyl5+lDZqnN5PTRLGAgGuKcIgPNcV2DQrwDC9MAalaQ=;
 b=halRmGouvSIG9hyWBP9Ky0hEZSJZviQZvUbUyA58dKtMBDZF5KoKmNhkiuE75rh9Ip53vs90Cx3ZvIfA3hlJTErTueLDpsdoKZpu/OYX5QPp7peMZ9Q2YDYrnO2FTHC80SmVjm6qcrgVez5IVDmVf2qelHNcFp6oGjHcCuvMHOPnPzJbBbWD/TR0ddCZbz9j0zcmK1D7l85EgPSWPn63Uj8xnQQu/nRcJXlV8jamDJfONyzlrTM+hQ2WFglTxCbxfHPvBWVF7Qcgte0U5iXUPvBTUzUCPKzf3rkH1+lFnZVzRRrRmu/zf2SqfVokB8iEthIEEqHTsYTiUZNKKrj5Ng==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH7PR05MB9058.namprd05.prod.outlook.com
 (2603:10b6:510:1fe::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.20; Sat, 24 Oct
 2026 12:21:42 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 12:21:42 +0000
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
Subject: [PATCH v3 2/3] ipc/sem: reject negative SEMOPM values
Thread-Topic: [PATCH v3 2/3] ipc/sem: reject negative SEMOPM values
Thread-Index: AQHdY7I6LntOHf/t90O3n+4uwtcljQ==
Date: Sat, 24 Oct 2026 12:21:42 +0000
Message-ID:
 <c2c9cb6d741fd9290c835679f9c209b147f74f64.1792808260.git.x-professor@outlook.com>
References: <cover.1792808260.git.x-professor@outlook.com>
In-Reply-To: <cover.1792808260.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH7PR05MB9058:EE_
x-ms-office365-filtering-correlation-id: 10381183-8c44-49e6-f7ab-08df31c95cf3
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|12121999013|8060799015|8062599012|31061999003|25010399006|4140399003|24021099003|38102599003|15080799012|41001999006|24121999003|22091999003|12091999003|1602099012|40105399003|53005399003|10035399007|26121999007|102099032|440099028|3412199025|4302099013|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?U1VDSzBkbU5XQmh3c3MyZ3psSnlHZU45QmwwalJHQjBGM0RBWnM5YmVRL0dh?=
 =?utf-8?B?TzBJSnE2cTlBRkt3c2FRSGh1UmpVTXZ4U2o5VkpFditqeWRvQVUyc3NzdGpK?=
 =?utf-8?B?L1JmaTZ5cUZ5dVB5U0J3akRVd1dFZmZWV3BieHNrdVlxRW5WdTNydnJRVHcx?=
 =?utf-8?B?NzU0YkNjdktjclMyKzJMUEdrMFl3OUxzNWw2enZnU3hEdnBQV3JKM2NiVEUw?=
 =?utf-8?B?RHpWU3NNNnV3a3lXUWQ4L3hrckZHOWw2SlQzVWhBTTJlMjFJYWJyT3Bndjlv?=
 =?utf-8?B?ME1URzFXVkNoMDBJVk82T1B6T0Rna3NQU2pZdXVkODFrRmpHdzhZY0ZpVngy?=
 =?utf-8?B?VlNZYXFXS1dNT2xlNngyZW82RTNweXlMdm15bHNoMEZiYmJUTTdrREFjY3FE?=
 =?utf-8?B?SFl3RzNGQkhxK1FvOWx1VGFqYXAyd1drWjZDYk5qcEIvWDFDTlRYOFZKd084?=
 =?utf-8?B?NkVzYktsSzh2R2Urc2s4T3dRU1JVZzFYb2Y0aFFlbjRoYzRTZUtITFNzREsr?=
 =?utf-8?B?MDRxSGZqbTh2aFdQRFVEZ0ZpM1JrU0taQ3hTcjBkUUtRQ1ZPZE5aTVk5aE8y?=
 =?utf-8?B?TDFZR3g2dEZDRTBzVWZ3RXEvd1g4a0hXUTVlbTRBaXpXVmxROXh3NGZCOEhw?=
 =?utf-8?B?VmlIeG5FMUxRZEJIQXZqUGE5QWdpRHdJRlJqeDN4L3lIeHBUdE56ellmQTUv?=
 =?utf-8?B?dlVlMnlhQlcyQUQ3dzNGaXhML3ZEYlFEallGZkN1bmo0d2swRGVTeTBONFFi?=
 =?utf-8?B?Zm5pUEcwN2d5WFBjQVhMdCtoVWc2SUhjMmpLL2pxaitqekhYaXdFaDRZVXkz?=
 =?utf-8?B?OVJBaUlpNEFMNzd2YW5kVy8xNHMveUtIOXZYTnhZUHJuOFBqQ3k2bjk1LzZr?=
 =?utf-8?B?M2UzY0h2UWZvT21MM2ZWTzMzVjNuczBXeC9GSG0vTWdKa2ErVWFGMksvVDRJ?=
 =?utf-8?B?aXdLbXdibHZ5YzdpWlRjdUs4allCYVIrdXdJdGdSdk40RytUNWduWFpaMU9m?=
 =?utf-8?B?OUVUc2taSUZPbjRpN3dveVVZUlVLMEpNSGhzWkNWbnhzd2lXQ1RKcm9hTnRY?=
 =?utf-8?B?ZldaYUNWZ0JQVVVsTGptOTFTZkdzRW1xa0NqbHZJNDJwWFErNmd4STRqU3M2?=
 =?utf-8?B?T3RMak5lbjB6S09SWElyR0VMd1VuTk10cXZ6T0FmUjdCL0Y2aHZNUXNrWjRn?=
 =?utf-8?B?S0hkZUY5NVBkTG5lUkF4OE1KM0wwTGlmZ2UydytkRTg5dE1qR1NUWmxSRk80?=
 =?utf-8?B?SGN6MTJTS2l0aStYRlptamFGQk9yNm5IbkZKTTZhc0d4VjVmWlZndVdJY3lv?=
 =?utf-8?B?eTdhVWI5K0svSGtGTlFyL280Y0hMMmhXQzFreUFuSytvaWpTRll5RnBybzYw?=
 =?utf-8?B?cEZaUG0rTWdGaG5kaXVvYkZ5YlY2dlAzOXg5ZmVrVmdDdVF0UHV5a2dOa0lz?=
 =?utf-8?B?RFdJOHVlV0Mvb1BtdWN0UHd3bW1mR1l0RFdKTGtuQlpiRmgvcTBtYXdEU25n?=
 =?utf-8?B?UzJGK3R5ai9FS1Y3Wkw4TExScG9ZR2NndlZuN2RnNkozenJWZkp5Z3JvTmJO?=
 =?utf-8?B?UnBjZWZUL0kvcUhxRStGOHEzZ21oZmU4Y1VBYSt0RkYwb1JlbVo3dGdHeEZj?=
 =?utf-8?Q?NdnIISmA8C/8npkIStlqr2rp17mNXV1RLrf89dLgBxVs=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dFNjUzc2alFaTHVabGxsK1ZqMDBXYW5Rek01UnFlYUhFSkZPS0VtKzdMYjNX?=
 =?utf-8?B?R1lLdzdWbmxuenVvakFwdEMweFRWbklJbkc3S21TMUlpZG1yYlpNcFJqNitS?=
 =?utf-8?B?eEIxQndPelIvT2k0ZXk5MDVjdGNMWnhWQkQzT3lHUnJROTlwMllHMEJZQzJJ?=
 =?utf-8?B?b1d2S0J5RTVzSGkwb1F2SGxvMUExaGYzR0twSmNTaGloM1JXNlg4RFk0Rk5k?=
 =?utf-8?B?eks2UGQzc0JhSzU3Z1l3alZxaHNOU1NreDU1ZlN1ZGwrS2F6SEttc21rMjNr?=
 =?utf-8?B?TjZaK2luVCtqak95Zy9xbVRFTEcyTkhUSDNhbmZ3eGRTWEFKK1pZOXBnb05w?=
 =?utf-8?B?Njhsb25IM3YxYmNlUEJyR3Q1K3hqVXFoc2IvQjJaZUtkTXJydVdkTWRCeUpM?=
 =?utf-8?B?bG1xc0xvaGpkR3FFeXRVbllwSjh5OFRSdDBWWlpCTjRnNm1BQjkvV0wzWCtl?=
 =?utf-8?B?bFZnQm5vYXVRVTRqRi9kcmRwNGJZNStQWnl4RFdocWIzNzY0TUlvTlZ5MU5q?=
 =?utf-8?B?ZTZ3VzhKRlJJQU1hMWdCd0wzZmJkajdBVmJSRnl1QkcrVHpSM2dTWDlic3Vh?=
 =?utf-8?B?a1FoYUozbm9EeGZjTXQ4TUFrc3VpNzdhbDljR2xtTE1rMGtXeUFtTnd2WEg0?=
 =?utf-8?B?T0d0endTaFlqWFFMNGxzSVcvZUNGcGlBdzUzL3dXTHlZNVVDM203Y1lXY2Vw?=
 =?utf-8?B?blcxK0NhOWJ4c0JmcklkaDNVcTdzMiswc3FoZ0NwL1p5TWpmaUJPTno1QUhn?=
 =?utf-8?B?WTZlRGxSQkpPS1p1WFAycHdGWkVkOWFMUG5RL0UvTWplL0Vma28xL0gzeWNX?=
 =?utf-8?B?aTNNVGhOeStDQlA4UGZ0RWNSb1lEdytZeElocU1kT0xwTXEva2hoWE8xNkV4?=
 =?utf-8?B?cUJQSnJKVUc2b3dzcG5WSllCM1BhMG1jb1RnaE5NUEg0dG1JM0IwbTNlWXhw?=
 =?utf-8?B?VFU2S3ZINUI5RkVJajg4angxYUFMVG1xK1BKYVJRMXd1ODh0VEU4M2hrbWpz?=
 =?utf-8?B?TmFTc1JkMnU4U2RkYWwrZXlYWE40RlBINmx3MitBakNkNVg2NGNHSjhESFo4?=
 =?utf-8?B?N0gxZnNkdlBIK0RSb1hYdk9mWm0vMGpLNzNETGRnOTBaNHI4a2tURXQyVlVj?=
 =?utf-8?B?bUVwaEJmOXd3SzF2a0tPRUtsOTBnZ0w0VkJzZkhkL2c2cVFZN1dQd3Bxc2tz?=
 =?utf-8?B?WVNXWEhMSy9ZTEZMelB5R3krbm10elhuQ1pjWURuRkpaSDU5VEpWOWtrSTlV?=
 =?utf-8?B?Zm9UYXFpaTNMdVJJdStFaVhHdlNQWjgvTU5qaTJNZmdZcUgwVjhWUTRuL2to?=
 =?utf-8?B?bU1uQzRCaGcxbVR6UjQwLzZ2UmdBa283cU1BWGtwR3MxSHFZaTBpZGVTQzZI?=
 =?utf-8?B?c00wUDFTRmNwamFmZFgyOExjM2tiUE9pN2VtVVRia2NXQU9OSWFiajZXNnpj?=
 =?utf-8?B?WFhVWmFKNDFHUnY0Tng0T0RESFZaQjltSVB4aXQ5UitzaCtpL05qa3J6Nmc3?=
 =?utf-8?B?b2VUbTMrZGNpTi96dFZlQ3AwL0hid3JxaHpUQnJSL2VrNzAzblFjZVdxRjUz?=
 =?utf-8?B?dlV0WGc5RGhkRGpFZFF6b0lIakppU3JseUZtZVprdHU2aVFYSDl4cU9kVW84?=
 =?utf-8?B?b2xJZlJ1cVdZT0FRa3Z0d25vMlFXL1VwaTMvZEt1SFhjSWpZbFFMcjNObEQ4?=
 =?utf-8?B?M1lreEtOOUpGcXgxWGd6SEtQRTdOaFlPOFgzRE5iaEpZZDIyeVNtcmpOUTdr?=
 =?utf-8?B?aXk0NkJudHdLVXhJNGFrYjNSY2pWUHZKQVI5NkQrSnRpb21XRVdtMUc0K2g5?=
 =?utf-8?B?elljYWJ6SUJSNzJBSTVPVVF0V09SbkNsRGthUGw4YkRhRkJEVEFJOXUvUXlB?=
 =?utf-8?Q?jGtsSOu+Kovv6?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 10381183-8c44-49e6-f7ab-08df31c95cf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2026 12:21:42.7006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR05MB9058

VGhlIFNFTU9QTSBmaWVsZCBoYXMgYmVlbiBzdG9yZWQgYXMgYW4gaW50IHdoaWxlIHNlbW9wKCkg
cmVjZWl2ZXMgYW4KdW5zaWduZWQgb3BlcmF0aW9uIGNvdW50IHNpbmNlIHRoZSBiZWdpbm5pbmcg
b2YgR2l0IGhpc3RvcnkuIEEgbmVnYXRpdmUKU0VNT1BNIGFjY2VwdGVkIGJ5IHByb2NfZG9pbnR2
ZWMoKSBpcyBjb252ZXJ0ZWQgdG8gYSBsYXJnZSB1bnNpZ25lZCB2YWx1ZQppbiB0aGUgY29tcGFy
aXNvbiwgZGVmZWF0aW5nIHRoZSBpbnRlbmRlZCBvcGVyYXRpb24tY291bnQgbGltaXQuCgpDb21t
aXQgNTBlYzQ5OWI5YTQzICgic3lzY3RsOiBhbGxvdyBjaGFuZ2Ugc3lzdGVtIHYgaXBjIHN5c2N0
bHMgaW5zaWRlIGlwYwpuYW1lc3BhY2UiKSBtYWRlIGtlcm5lbC5zZW0gd3JpdGFibGUgYnkgSVBD
IG5hbWVzcGFjZSBvd25lcnMgd2l0aG91dApjYXBhYmlsaXRpZXMgaW4gdGhlIGluaXRpYWwgdXNl
ciBuYW1lc3BhY2UuCgpQYXJzZSB3cml0ZXMgYWdhaW5zdCBhIHRlbXBvcmFyeSBjb3B5IGFuZCB2
YWxpZGF0ZSBTRU1PUE0gYW5kIFNFTU1OSQpiZWZvcmUgY2hhbmdpbmcgdGhlIGxpdmUgc2V0dGlu
Z3MuIEhvbGQgYSBwZXItbmFtZXNwYWNlIG11dGV4IGZyb20gdGhlCnNuYXBzaG90IHRocm91Z2gg
cHVibGljYXRpb24gc28gY29uY3VycmVudCBzeXNjdGwgd3JpdGVycyBjYW5ub3QgcHVibGlzaApz
dGFsZSB2YWx1ZXMgZm9yIGZpZWxkcyB0aGV5IGRpZCBub3Qgc3VwcGx5LiBBY2Nlc3MgdGhlIGxp
dmUgZmllbGRzIHdpdGgKUkVBRF9PTkNFKCkgYW5kIFdSSVRFX09OQ0UoKSwgcHJlc2VydmluZyB0
aGUgcGVyLWZpZWxkIGFjY2VzcyBzZW1hbnRpY3Mgb2YKcHJvY19kb2ludHZlYygpLiBSZWFkIHJl
cXVlc3RzIGNvbnRpbnVlIHRvIHVzZSBwcm9jX2RvaW50dmVjKCkgZGlyZWN0bHkuCgpGYWlsZWQg
d3JpdGVzIGxlYXZlIHRoZSBsaXZlIHNldHRpbmdzIHVuY2hhbmdlZC4gU3VjY2Vzc2Z1bCBwYXJ0
aWFsIHdyaXRlcwpjaGFuZ2Ugb25seSB0aGUgc3VwcGxpZWQgZmllbGRzIHJlbGF0aXZlIHRvIHRo
ZSBsYXRlc3QgbG9ja2VkIHNuYXBzaG90LgpUaGUgd3JpdGVyIG11dGV4IHJldGFpbnMgdGhlIGV4
aXN0aW5nIHBlci1maWVsZCB2aXNpYmlsaXR5IGZvciByZWFkZXJzLgoKS2VlcCB6ZXJvIGFuZCBw
b3NpdGl2ZSBTRU1PUE0gdmFsdWVzIHZhbGlkLiBaZXJvIGNvbnRpbnVlcyB0byByZWplY3QgZXZl
cnkKbm9uLWVtcHR5IHNlbW9wKCkgcmVxdWVzdC4KClN1Z2dlc3RlZC1ieTogQW5kcmV3IE1vcnRv
biA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvci8yMDI2MTAxNjE1NTkwNS4yYTY1OWI3YmI3ZDYxZjMzNDY3YTMyNjNAbGludXgtZm91bmRh
dGlvbi5vcmcKTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci81MWM5M2MxOS1mMWRkLTQ1
NWYtODY5OC02YjFlZTMwZWI2MzBAY29sb3JmdWxsaWZlLmNvbQpGaXhlczogMWRhMTc3ZTRjM2Y0
ICgiTGludXgtMi42LjEyLXJjMiIpCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1v
ZmYtYnk6IFlpbmdqaWUgV2FuZyA8eC1wcm9mZXNzb3JAb3V0bG9vay5jb20+ClJldmlld2VkLWJ5
OiBNYW5mcmVkIFNwcmF1bCA8bWFuZnJlZEBjb2xvcmZ1bGxpZmUuY29tPgotLS0KIGluY2x1ZGUv
bGludXgvaXBjX25hbWVzcGFjZS5oIHwgIDMgKysrCiBpcGMvaXBjX3N5c2N0bC5jICAgICAgICAg
ICAgICB8IDM1ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tCiBpcGMvc2VtLmMg
ICAgICAgICAgICAgICAgICAgICB8ICAxICsKIGlwYy91dGlsLmggICAgICAgICAgICAgICAgICAg
IHwgIDkgLS0tLS0tLS0tCiA0IGZpbGVzIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKyksIDE4IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvaXBjX25hbWVzcGFjZS5oIGIv
aW5jbHVkZS9saW51eC9pcGNfbmFtZXNwYWNlLmgKaW5kZXggMTJmYWNhMjliYmI5Yy4uYzA2NTY4
Y2NmY2E4OCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9pcGNfbmFtZXNwYWNlLmgKKysrIGIv
aW5jbHVkZS9saW51eC9pcGNfbmFtZXNwYWNlLmgKQEAgLTQsNiArNCw3IEBACiAKICNpbmNsdWRl
IDxsaW51eC9lcnIuaD4KICNpbmNsdWRlIDxsaW51eC9pZHIuaD4KKyNpbmNsdWRlIDxsaW51eC9t
dXRleC5oPgogI2luY2x1ZGUgPGxpbnV4L3J3c2VtLmg+CiAjaW5jbHVkZSA8bGludXgvbm90aWZp
ZXIuaD4KICNpbmNsdWRlIDxsaW51eC9uc3Byb3h5Lmg+CkBAIC0zMSw2ICszMiw4IEBAIHN0cnVj
dCBpcGNfaWRzIHsKIHN0cnVjdCBpcGNfbmFtZXNwYWNlIHsKIAlzdHJ1Y3QgaXBjX2lkcwlpZHNb
M107CiAKKwkvKiBTZXJpYWxpemUga2VybmVsLnNlbSB3cml0ZXJzLiAqLworCXN0cnVjdCBtdXRl
eAlzZW1fY3Rsc19tdXRleDsKIAlpbnQJCXNlbV9jdGxzWzRdOwogCWludAkJdXNlZF9zZW1zOwog
CmRpZmYgLS1naXQgYS9pcGMvaXBjX3N5c2N0bC5jIGIvaXBjL2lwY19zeXNjdGwuYwppbmRleCBk
MDM4ZDk0NDI1N2Y2Li5hMDVlMjhlNjdjMzA1IDEwMDY0NAotLS0gYS9pcGMvaXBjX3N5c2N0bC5j
CisrKyBiL2lwYy9pcGNfc3lzY3RsLmMKQEAgLTUxLDIxICs1MSwzOCBAQCBzdGF0aWMgaW50IHBy
b2NfaXBjX2F1dG9fbXNnbW5pKGNvbnN0IHN0cnVjdCBjdGxfdGFibGUgKnRhYmxlLCBpbnQgd3Jp
dGUsCiBzdGF0aWMgaW50IHByb2NfaXBjX3NlbV9kb2ludHZlYyhjb25zdCBzdHJ1Y3QgY3RsX3Rh
YmxlICp0YWJsZSwgaW50IHdyaXRlLAogCXZvaWQgKmJ1ZmZlciwgc2l6ZV90ICpsZW5wLCBsb2Zm
X3QgKnBwb3MpCiB7CisJc3RydWN0IGN0bF90YWJsZSBpcGNfdGFibGU7CiAJc3RydWN0IGlwY19u
YW1lc3BhY2UgKm5zID0KIAkJY29udGFpbmVyX29mKHRhYmxlLT5kYXRhLCBzdHJ1Y3QgaXBjX25h
bWVzcGFjZSwgc2VtX2N0bHMpOwotCWludCByZXQsIHNlbW1uaTsKKwlpbnQgc2VtX2N0bHNbQVJS
QVlfU0laRShucy0+c2VtX2N0bHMpXTsKKwlzaXplX3QgaTsKKwlpbnQgcmV0OworCisJaWYgKCF3
cml0ZSkKKwkJcmV0dXJuIHByb2NfZG9pbnR2ZWModGFibGUsIHdyaXRlLCBidWZmZXIsIGxlbnAs
IHBwb3MpOwogCi0Jc2VtbW5pID0gbnMtPnNlbV9jdGxzWzNdOwotCXJldCA9IHByb2NfZG9pbnR2
ZWModGFibGUsIHdyaXRlLCBidWZmZXIsIGxlbnAsIHBwb3MpOworCW11dGV4X2xvY2soJm5zLT5z
ZW1fY3Rsc19tdXRleCk7CisJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoc2VtX2N0bHMpOyBp
KyspCisJCXNlbV9jdGxzW2ldID0gUkVBRF9PTkNFKG5zLT5zZW1fY3Rsc1tpXSk7CiAKLQlpZiAo
IXJldCkKLQkJcmV0ID0gc2VtX2NoZWNrX3NlbW1uaShucyk7CisJbWVtY3B5KCZpcGNfdGFibGUs
IHRhYmxlLCBzaXplb2YoaXBjX3RhYmxlKSk7CisJaXBjX3RhYmxlLmRhdGEgPSBzZW1fY3RsczsK
IAotCS8qCi0JICogUmVzZXQgdGhlIHNlbW1uaSB2YWx1ZSBpZiBhbiBlcnJvciBoYXBwZW5zLgot
CSAqLworCXJldCA9IHByb2NfZG9pbnR2ZWMoJmlwY190YWJsZSwgd3JpdGUsIGJ1ZmZlciwgbGVu
cCwgcHBvcyk7CiAJaWYgKHJldCkKLQkJbnMtPnNlbV9jdGxzWzNdID0gc2VtbW5pOworCQlnb3Rv
IG91dF91bmxvY2s7CisKKwlpZiAoc2VtX2N0bHNbMl0gPCAwIHx8CisJICAgIHNlbV9jdGxzWzNd
IDwgMCB8fCBzZW1fY3Rsc1szXSA+IGlwY19tbmkpIHsKKwkJcmV0ID0gLUVSQU5HRTsKKwkJZ290
byBvdXRfdW5sb2NrOworCX0KKworCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHNlbV9jdGxz
KTsgaSsrKQorCQlXUklURV9PTkNFKG5zLT5zZW1fY3Rsc1tpXSwgc2VtX2N0bHNbaV0pOworCitv
dXRfdW5sb2NrOgorCW11dGV4X3VubG9jaygmbnMtPnNlbV9jdGxzX211dGV4KTsKIAlyZXR1cm4g
cmV0OwogfQogCmRpZmYgLS1naXQgYS9pcGMvc2VtLmMgYi9pcGMvc2VtLmMKaW5kZXggYThjOTgw
NzE3NTUyMC4uMGY3ZDMyYzEyOTkzZiAxMDA2NDQKLS0tIGEvaXBjL3NlbS5jCisrKyBiL2lwYy9z
ZW0uYwpAQCAtMjQ5LDYgKzI0OSw3IEBAIHN0YXRpYyBpbnQgc3lzdmlwY19zZW1fcHJvY19zaG93
KHN0cnVjdCBzZXFfZmlsZSAqcywgdm9pZCAqaXQpOwogCiB2b2lkIHNlbV9pbml0X25zKHN0cnVj
dCBpcGNfbmFtZXNwYWNlICpucykKIHsKKwltdXRleF9pbml0KCZucy0+c2VtX2N0bHNfbXV0ZXgp
OwogCW5zLT5zY19zZW1tc2wgPSBTRU1NU0w7CiAJbnMtPnNjX3NlbW1ucyA9IFNFTU1OUzsKIAlu
cy0+c2Nfc2Vtb3BtID0gU0VNT1BNOwpkaWZmIC0tZ2l0IGEvaXBjL3V0aWwuaCBiL2lwYy91dGls
LmgKaW5kZXggYTU1ZDZjZWJlNmQzYi4uNTFiNGVmYTNkNmRiMCAxMDA2NDQKLS0tIGEvaXBjL3V0
aWwuaAorKysgYi9pcGMvdXRpbC5oCkBAIC0yNDUsMTUgKzI0NSw2IEBAIGludCBpcGNnZXQoc3Ry
dWN0IGlwY19uYW1lc3BhY2UgKm5zLCBzdHJ1Y3QgaXBjX2lkcyAqaWRzLAogdm9pZCBmcmVlX2lw
Y3Moc3RydWN0IGlwY19uYW1lc3BhY2UgKm5zLCBzdHJ1Y3QgaXBjX2lkcyAqaWRzLAogCQl2b2lk
ICgqZnJlZSkoc3RydWN0IGlwY19uYW1lc3BhY2UgKiwgc3RydWN0IGtlcm5faXBjX3Blcm0gKikp
OwogCi1zdGF0aWMgaW5saW5lIGludCBzZW1fY2hlY2tfc2VtbW5pKHN0cnVjdCBpcGNfbmFtZXNw
YWNlICpucykgewotCS8qCi0JICogQ2hlY2sgc2VtbW5pIHJhbmdlIFswLCBpcGNfbW5pXQotCSAq
IHNlbW1uaSBpcyB0aGUgbGFzdCBlbGVtZW50IG9mIHNlbV9jdGxzWzRdIGFycmF5Ci0JICovCi0J
cmV0dXJuICgobnMtPnNlbV9jdGxzWzNdIDwgMCkgfHwgKG5zLT5zZW1fY3Rsc1szXSA+IGlwY19t
bmkpKQotCQk/IC1FUkFOR0UgOiAwOwotfQotCiAjaWZkZWYgQ09ORklHX0NPTVBBVAogI2luY2x1
ZGUgPGxpbnV4L2NvbXBhdC5oPgogc3RydWN0IGNvbXBhdF9pcGNfcGVybSB7Ci0tIAoyLjQzLjAK
Cg==
