Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazolkn19013075.outbound.protection.outlook.com [52.103.7.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A4748AE38;
	Mon, 19 Oct 2026 07:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.7.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792395844; cv=fail; b=Yh0JFe5A/V6Ci9BzydHHYUhWDpGUok9HGo9YqcJqE0uEusTz+QpQ/i+ibMKL/ZJ9TVzy3hBnHYKhBic0UZaSyhc/lGkNyAS9+xchveqL+kMGKtQhJ1FlFkywxobjyQ/eqh6QHmpMakNYzSsQKZgHtMSKpkR5gb2zIEyxMbDMRtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792395844; c=relaxed/simple;
	bh=wnvEHXZrlWrWvOxsj5KXyHok1o5JCCU9MVEWdP34YeA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=njEoXqTOCrBRaQ9QzGm2wWQv0Z0cOOeyUUprQZEGzhO0VadHQ919jonaFGn8hgpgVdI4vqKYWxQR56/gegIHAQ0pzqI6xB41d4VePMutaOhYBprJXmUsQX6LohbHYKJbvyuKLS6UcXOslW9d5H+QjJkESZSjICJuftPoABl/O+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=WnoBCxAK; arc=fail smtp.client-ip=52.103.7.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="WnoBCxAK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cBFzTpYoIz0hzB3N3+L/RHOmSYn/OYSfTL14SslmZCs8nGNh3OgEWzMqj7+ujKChk622eUCUDQappS3NrepfhrlI/jIQnMTtx9mBf8AX5KBTgZVB+qe7I4gZE3+3wtLKnB34/XlqllfXeUOW29qPahrv/hNkEo6dhKVjAfGbBClqd6AAH3XkNlq/Qd864DXOuGQBouizAhMVK1sL1EOPxmcn1ibWv1omJqPexRyqNq0CH5Vfp1ZUqVA14v/i4jMULIgZ6cYBNTtlm0CWWIiSZGkcN1+H7l/6kWz6TBE/MMHCLhYxFzux3cUg50/0PcnjRiouk9+I6wE0baTnlNSZtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=wnvEHXZrlWrWvOxsj5KXyHok1o5JCCU9MVEWdP34YeA=;
 b=hsc0bngjHiPfRCDfKmi0wOfWznIQ3t3McTyyjJB0F873DZizdYJOu3Gd9JdBu8ucvT1xZkkevl/xuTwivgRsiox4Qx6LunqYJrYRk5Z1TsgeLjsoQH+zTq6dHi3BPoB9EVPUuqATd112VbqjBvl1P64TlYzwAgur4WzbVdW4jkD7fqDKhrk2WnwZB2OAE1xdZVSOenDdxgdWoVfpXR20R4PLN6qZ+adlXhCBCz4yS/JvYKpjXwwwfvhV1e5cNs/G/zMcoatuRVI5Luz1YCSPIESAHm8ij9NVDjCOHPyOzRVDFM9kI18NY46uaVfbGnygZNX/pdXBN9QZoUAxN3ULMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnvEHXZrlWrWvOxsj5KXyHok1o5JCCU9MVEWdP34YeA=;
 b=WnoBCxAKgn9XpP6EUARAt5SOX6BCCa699i+eOdOzG2OYW4SYXhf4WNiVasS0kYWtrKJRCNWUdi6a/7hqZS7j636qe2mzOq7WXk6fsKXq6c8EuqI4/OARw8mx/6CP0ZYn0aA49nATLERerWOn/E4MjtR7Q4p2ObXSYuvpKQj0Xkn+tuwrwKRaAJfmcMm8ic178skkTu82mU9wBzLSu9L+1nukuQOsT5QN3W3Vf08tmnKxtCoNy4vRC9vlu7DGzGJUSarVstVJLuNQreIahvwL9vtYXvoFa7tt4b4VfLl756T9iGm9ARRom6G5ObLL8joUbbXi3OcCYgMYbkj/CVYeug==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DSVPR05MB998547.namprd05.prod.outlook.com
 (2603:10b6:8:389::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 07:44:00 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 07:44:00 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: [RFC] scsi: handling negative CDROM_SEND_PACKET timeouts
Thread-Topic: [RFC] scsi: handling negative CDROM_SEND_PACKET timeouts
Thread-Index: AQHdX52aIZq8/qxLv0GDa5GtKEsvSg==
Date: Mon, 19 Oct 2026 07:44:00 +0000
Message-ID: <20261019.cdrom-timeout.13a6f4a2f552@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DSVPR05MB998547:EE_
x-ms-office365-filtering-correlation-id: 8b33a179-d11e-4d37-5667-08df2db4bd73
x-ms-exchange-slblob-mailprops:
 qdrM8TqeFBvhuFgLLe5qs4jWk9CHdv0AE5jv07IGxFHhkM0L1vvX+zUiNP8aOIarkuY7cMBePI4Ha9Ql5hIUSQUQG8vlSk1wvKnbS7CD1iU3b0J5kXLA3xmIFVB6hzhsl3UGOHZLaG9TUoRxID4CNirnGNcLWnROKS6LXiSTvhQ7dcmzrHDn6wKuHLmgRKNa440ehMqNlWob9cSFInDPVK3pp6vPbuen8NWjXEEWuqwJuoRe9N+MfgQA52Nk3G+beJ6S4ErYmrKUIR8wrYLebByu/trZONi8CfKjDCIjRDkkkq/BG3iYA3pxkyEdnQpn/ZzRks5kVkCGd9/51UsSYky8n6ISD3xX6dE9RwDszN9yc36jnh6Ka2dVlPlhyklJ5ZgVHD12SGBOZGIqW0TH0foM+Tr4Q47iDXkUz+MeN59haGN/NPQfN5p8MjFbcd0v1T4tVPZykf0iXm7vvLGwpIaEM5fd3ma3edd59LIZERueZ9j6Hl3Q01wegB06N/60ndX8LkrNKYTQvJbqvwWMMKI3Ceo/qSzcEMPdvnFsBvLK7Ca5/B3TyeHW/Wnw4Sgr5IpthBbIkqnMsHGCUINGl2MsLVajCNSy2KLJWgtC7pEkh/xvCYeUxcdVkkApMc+FtjkhcEVsd6YJQZVq9sMFT4Gr5owSRtGC1FyubR4WEER4F5Tto2Q4VzbvpCl0X7wUzPzgGQTGFvpxGTmvYteGxJ3KW1ZEuYiJEYH6L8YSRVyX1ssHHW2bgvO0uT7q3U6wpZCIh5bwcATMantR0SQo6CVDOwJIGAph
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|15080799012|39105399006|12121999013|20031999006|22091999003|2604032031799003|41001999006|38102599003|8062599012|8060799015|19110799012|24071999003|24121999003|31061999003|5040399003|4140399003|3412199025|440099028|102099032|40105399003|26121999007|3430499035|10035399007;
x-microsoft-antispam-message-info:
 =?utf-8?B?YkpiRDhvVWN6Q2xwMkxWQnZiWG44VHljKy8rSkkzYzltcU9NWjlBQkNGUkRU?=
 =?utf-8?B?MCtaaW5BSHhRM0ZxTHdGeGJoY3ZneVRXUGQ5NGR3QlFnMitBUlJlQlgvSFFE?=
 =?utf-8?B?NW1tSEN0a2ErcmhRWE4vblpnMlgrV3dGVXFSamxEMDFhV2Iyei8ySVpyL0FE?=
 =?utf-8?B?UmxpL3ZHeE5uazJCM3BVWDdNUityNWxLNFBqMWtLNStncEJNczBvOFRIUUVz?=
 =?utf-8?B?UEF5K1lHOVM3S1lMbDg2Q29lSHNnV25vdmtPOCtjZWpvM3RHbUlaeEhmdjMw?=
 =?utf-8?B?VXhRZTE2N2p5WUh1OVJTREVPMkFCRkVkU3RsOVlKVUJmcnFXckk1eEIxUlJE?=
 =?utf-8?B?R1RBV1hZWFZIZFlGaW04ZHgyVXRYRzN6dzlhOUR3enV3bzlocndhTU04MW1D?=
 =?utf-8?B?cUV4MWNhazBySkh4ZWpFRWhFVy9abjlWOFZRQ0RZSjdOdTAraDJ4UGZONGJq?=
 =?utf-8?B?QkY4eGwxYzZyZVhkUWt0Q0dRSnRrcndQUFY3V1BiZC9lQ1UzOFpXU09GZ0dL?=
 =?utf-8?B?N3c5cnczYzZiQW1VSm50Vm5NNXJJWm1saHk0bnlYaVdxaUZPU1NLd0s3eUhr?=
 =?utf-8?B?SmEwb2lBbHlrTG80QVgyYVZEVEtXRDFBeFFFa2gyM01GbDhjejVxUGN4azI4?=
 =?utf-8?B?a25MbTg0d1hGK0FGOWdkbFBhOXE2OWxISHV5ai9UTmlDS05zY2FqWVNlTWM3?=
 =?utf-8?B?RGtDOE1HT3d6dndMYzNnOGZOTDBjeGhLTFZZOW9Wa083eW1mbTd0NkVkTVdC?=
 =?utf-8?B?VmIyVTJYSk5udnVQeit2M05DTzlxYkttNUJOdjE1ZnlRWHRpNVRweFByZDRm?=
 =?utf-8?B?NUMwdjVnWWh0akdBYWpudExKQUN2NWRaT0dxbEpzZDBsdVhuMk1VUUgrZDhs?=
 =?utf-8?B?UkJsSlVjRFlpTUQwQTVxVk9hbTltQ0YrZXM5RXdCYVBDOGNzVkdGekViSENZ?=
 =?utf-8?B?MWxZS3NQNkdERVVFTlZzWGRvRGl3UXQ4ZUNJNWU1Ly96L3JXdWNVZ29KSTJM?=
 =?utf-8?B?Y09IaDd2ZzVvZi8wNjhKSmhyV3ZrSWoxYkFRSzZka3gwc2pmOEZvZkdwaU1Y?=
 =?utf-8?B?RjZMYVBxTnVodDMvZnFDNFluaHBOejNQMzN1cS9BZEVQL2VvamFMMTNkbzlI?=
 =?utf-8?B?d2czbEp2cDZZazhDQytVOGlLNnFrZkNiVUdGd3lYSXIrWXppREpQVDY1M3VS?=
 =?utf-8?B?SEJtNUlRWm1oNnovSXJIZmJMczR6WEh5QWtid0JUT1JjUkpKVW1zaTdxQ0oy?=
 =?utf-8?B?OEpVc1lKSDhPSTFwdHhjalJpRGV3QkZxQUc0VVJDYVNMMlZkVXYyek9jL1d3?=
 =?utf-8?B?aVZPYm5Hc05XQnJDak1FTlpRd0piRXJGcmt6ZGMwY2ZZWXkrckI5R2RaUU5q?=
 =?utf-8?B?N3BzQjIwdVV4YVM3bGZkTERFR1c2MHVpS2VWZ25mcXVTZlkybmdSdUJ2Rjh6?=
 =?utf-8?B?ZWlSVHNYZDc2bGM0dUIwc1pkc015SGlSVjVDNGhFZmJaQW5jRDlyUUpRbWtv?=
 =?utf-8?B?MUR0T3RDTTlOemdXU3dObFBGbFhxdTQxWS9pbWdjQVNFcmhRMFdabnoxWFJN?=
 =?utf-8?B?QmRVVjQzd1Y1WU1PcDFlemI0NHRGQXBDNkpQSkhQR1J3OVAyZk9INDhYeS9j?=
 =?utf-8?B?RERNTWVieHA3M2dYRXJncjE0UlZWaUE9PQ==?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V2w2cjIzdC9sZitRcUJ0R1EvWmJXUW9DdGVER2tpaG1SNG93MVpMenJuSnVD?=
 =?utf-8?B?UnlrSEFCK0YzS1VKZVFJeXBNL0VaaVpPVEVVdnRSeE8xeXhSSXp2eGZKUVZF?=
 =?utf-8?B?UFIrcnVSa3k0Ky9CejRhOFcvcVpsaTFjR1JjUWhzVTQvd2p6bG5DdzFRZTlu?=
 =?utf-8?B?RHl1VG9CdEdpTG5vV1V1VVRyZzAxWkE0d3VvQjBBanJITWYrNk1hRVpQMm93?=
 =?utf-8?B?TU04M0U3ZUZOcE9wZlU5WXgvWk5jVG1maEtFN0g4c2NheDUxN0xsQVB1UHdz?=
 =?utf-8?B?MHZGZTBLWW5kWGVUekw1N25KanhaUWcrRTgySjFqSmtTN1E3M01hTlU1aElo?=
 =?utf-8?B?UTZYWWsxeVdZTXMzRFI0NHhSY0JhWFgyZ0NGdmNGQi82TnUvMWEycldMUDN6?=
 =?utf-8?B?eU9TaWl5ZTQ2bXpRcmxCSnhIQVRCRTV0VlplQktPRVVkWlRneFJGWkoxUnJH?=
 =?utf-8?B?Lzh4SW9zSlJMemFuU3FjZXd0L0Zka3R1OHIwMklJS21GSGo2enBML0kzWmFj?=
 =?utf-8?B?Q2tuY25EcUpMZGZSZFF3WXNQSFVCbkM3MURrOVhTZXpzNlo0Uld1VHZ1UHBu?=
 =?utf-8?B?Und4QkNkb3NyRFo5RzF0YituWEhDTDRpK3Z3dFhxY1YvOG1xRWpsQlFWbjRF?=
 =?utf-8?B?ZDFkWjZybUx5SUk4c1NGaVhiWGVwWDIrUkxNdTJZK0F4QmRkeE9RaitBaS9Q?=
 =?utf-8?B?U2RXSE80NXZoVDVpcklKcE5keHlMdHl1aVQwTG51UzNlUVFScGM5Z3dFS0VH?=
 =?utf-8?B?S0VUaTJTenlpMkpLSVUvNWs3SFlCeUNWN3d4U0pYU21LUXFGUCsvNDd3TTBo?=
 =?utf-8?B?ZXNNdEhYYnJsUVZBVDRqZUhoWU5KaVR6U09VLzVFclp3TndBcnZ2dDdiMVIy?=
 =?utf-8?B?Z0pvNEhOeFkwRTJsUEJXKzRVUzRYdm1jb01PQitPR3lLdmJveEhuL0FTcXRV?=
 =?utf-8?B?aWd5bldmOHVUZDdJRTF6TXgvVkE3dTFMTkU3ODJsQjBVcWlzZVZIdThIdUMz?=
 =?utf-8?B?N2JoczgxRHZJR2ZIUmNBSXcrcm9wS0hTazAwd2N2NHhjVnIvQlB0aDdNTEhW?=
 =?utf-8?B?NzFkbXB3UHJwa21HRUFPMDFNR05sbEllV01RTkdsZlBQVGg5ZmplUGxvYThs?=
 =?utf-8?B?ZXZVRWJ3TVh4OStZNE9zc3gyNTBYbmNPd3RkZ0VLaTJDZldWM2xWbHFJSEFm?=
 =?utf-8?B?SUpjb3pnb2E4TTBwaU5JQmMxWTAxMTFMeEc2ZGtmditRN0Q4RlBBUXlJYWFv?=
 =?utf-8?B?VmU0ZW5yaU11b2hodTJFZFU4ZmxUTTdIRk4vZ3V1N3NJUm5nMVFaQWYxYndB?=
 =?utf-8?B?am5XbmhEbkF4T2JPV3JsVjFUaHMxeWF1cWtSUkdrVlpSUmFwSjhMVnhIcVRw?=
 =?utf-8?B?VjN1SXo2c21vK0h5TnJ3REpOR05ZZHBYaytOalVMbWJDZGh3cm9oMjJ0dmNy?=
 =?utf-8?B?RXp5RGFPRDh4dmR4NVF4WUZ5aUNaTVpXaU1tRmgxbzAzendjb08xMGFBN2pX?=
 =?utf-8?B?UDBlRnVrMEd3dSs1cHNaZTliOEZaZ3lWLzNObDQycG5LWUpmekdEMUlpak1s?=
 =?utf-8?B?RXFabXZ2WG5zN2NyTHdzaVV6amFUWk94THR2WGdWSDFncTNsQ0tZRzJxMkEz?=
 =?utf-8?B?QllaVEREMi9pT1JEdWlqbXJTNW1JQTRxdG56OGRxSHJBMjdiUk5qRUZNYmdn?=
 =?utf-8?B?YVpvWHU4Vllpdndhdk5mTEFBeGUxL0NlektyVWpRVXRBNWl4aDdWRXU2b3Uv?=
 =?utf-8?B?Tk50c2J5dWsvZzlRYXYzVU5nVnA2WUJ1TG93VVlGRW9FL3ZQLzRiejEyQ2Qy?=
 =?utf-8?B?SFI3OEY1UVdrb1NEeHhZcXhqUW9SL2VQcTNZSDFkVVRzT3o5blJMbkdyek1w?=
 =?utf-8?Q?wk2VZc16ueow5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B63B1751944E544B77A10D2F4E51933@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b33a179-d11e-4d37-5667-08df2db4bd73
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 07:44:00.5230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR05MB998547

SGksCgpDRFJPTV9TRU5EX1BBQ0tFVCBhY2NlcHRzIGEgbmVnYXRpdmUgY2djLnRpbWVvdXQgYW5k
IGNvbnZlcnRzIGl0IGludG8gYQp2ZXJ5IGxvbmcgcmVxdWVzdCB0aW1lb3V0LiBCZWZvcmUgc2Vu
ZGluZyBhIGZpbmFsIGZpeCwgSSdkIGxpa2UgdG8gY2hlY2sKd2hldGhlciByZWplY3RpbmcgbmVn
YXRpdmUgdmFsdWVzIHdvdWxkIGJyZWFrIGFuIGV4aXN0aW5nIHVzZXJzcGFjZQpjb252ZW50aW9u
OiBsaWJjZGlvIGRlc2NyaWJlcyAtMSBhcyB0aGUgZGVmYXVsdCB0aW1lb3V0IGFuZCBwYXNzZXMg
aXQKdGhyb3VnaCB0byB0aGlzIGlvY3RsIG9uIExpbnV4LgoKc2NzaV9jZHJvbV9zZW5kX3BhY2tl
dCgpIHBhc3NlcyB0aGUgc2lnbmVkIHRpbWVvdXQgdG8gY2xvY2tfdF90b19qaWZmaWVzKCksCndo
aWNoIHRha2VzIGFuIHVuc2lnbmVkIGxvbmcuIE9uIHg4Ni02NCB3aXRoIEhaPTEwMDAgYW5kIFVT
RVJfSFo9MTAwLCAtNQpwcm9kdWNlcyBVTE9OR19NQVgsIGlzIHN0b3JlZCBiYWNrIGFzIC0xIGlu
IGNnYy50aW1lb3V0LCBhbmQgYmVjb21lcwpVSU5UX01BWCBtaWxsaXNlY29uZHMgaW4gdGhlIFNH
X0lPIGhlYWRlci4gVGhlIHN1YnNlcXVlbnQgY29udmVyc2lvbiBhbmQKYXNzaWdubWVudCBwcm9k
dWNlIHJxLT50aW1lb3V0ID0gNDI5NDk2NzI5NCBqaWZmaWVzLCBub21pbmFsbHkgYWJvdXQgNDku
NwpkYXlzLiBUaGlzIGlzIGEgc291cmNlLWRlcml2ZWQgdGltZW91dCwgbm90IGEgbWVhc3VyZWQg
NDktZGF5IGhhbmcuIFRoZQp1bmNoZWNrZWQgY29udmVyc2lvbiBpcyBzdGlsbCBwcmVzZW50IGF0
IG1haW5saW5lIGNvbW1pdApjMDNjMWExNDUwN2RmYWY4Yjg1NmMyNjA4ZjlhYzIxNjAyMWZjMjIy
LgoKQSBRRU1VIHRlc3Qgb24gNDA1NmIzYzlkM2M5MmVhNDU5NTU2NDFkYmFmZWI5Yjk2MGUxNDZl
ZiB1c2VkIGEgbWFsZm9ybWVkCnBhY2tldCB3aXRoIHRoZSBhbGxvd2VkIFJFUVVFU1QgU0VOU0Ug
b3Bjb2RlIGFuZCB0aW1lb3V0IC01LiBUaGUgY2FsbGVyCndhcyBVSUQgNjU1MzQgd2l0aCBubyBl
ZmZlY3RpdmUgY2FwYWJpbGl0aWVzLCBhZnRlciBiZWluZyBncmFudGVkIGFjY2Vzcwp0byAvZGV2
L3NyMC4gQXQgdGhlIGVpZ2h0LXNlY29uZCBvYnNlcnZhdGlvbiBwb2ludCBpdCB3YXMgaW4gRCBz
dGF0ZSBpbjoKCiAgc3JfYmxvY2tfaW9jdGwgLT4gc2NzaV9pb2N0bCAtPiBzY3NpX2Nkcm9tX3Nl
bmRfcGFja2V0CiAgICAtPiBzZ19pbyAtPiBibGtfZXhlY3V0ZV9ycQoKVGhlIGRldmljZS1ldmVu
dCB3b3JrZXIgd2FzIGFsc28gYmxvY2tlZC4gU291cmNlIHJlcHJvZHVjZXIsIGlzb2xhdGVkCmd1
ZXN0IHNldHVwIGFuZCBsb2dzIGFyZSBhdmFpbGFibGUgcHJpdmF0ZWx5IG9uIHJlcXVlc3QuIFNH
X0lPIGFscmVhZHkKYWxsb3dzIHRoZSBzYW1lIG9wZW5lciB0byByZXF1ZXN0IGEgbGFyZ2UgdGlt
ZW91dCwgc28gdGhpcyBkb2VzIG5vdCBieQppdHNlbGYgZXN0YWJsaXNoIGEgbmV3IHByaXZpbGVn
ZS1ib3VuZGFyeSBieXBhc3MuCgpUaGUgY2FuZGlkYXRlIGJlbG93IHJlamVjdHMgbmVnYXRpdmUg
dmFsdWVzIGJlZm9yZSB0aGUgY29udmVyc2lvbiwgZm9yCmJvdGggbmF0aXZlIGFuZCBjb21wYXQg
Y2FsbGVycy4gRWFybGllciB0ZXN0aW5nIG9uIExpbnV4IDYuMTIuODAgcmVjb3JkZWQKYSBodW5n
LXRhc2sgcmVwb3J0IHdpdGggdGhlIG1pbmltaXplZCBuZWdhdGl2ZS10aW1lb3V0IGlucHV0LCBi
dXQgbm8KaHVuZy10YXNrIHJlcG9ydCBvdmVyIGEgc2l4LW1pbnV0ZSB3aW5kb3cgd2l0aCB0aGlz
IGd1YXJkLiBBIHRpbWVvdXQ9MQpjb250cm9sIGFsc28gY29tcGxldGVkIHRoYXQgd2luZG93IHdp
dGhvdXQgYSBodW5nLXRhc2sgcmVwb3J0LiBUaGUKc2FtZS1iYXNlIG1haW5saW5lIGJlZm9yZS9h
ZnRlciB0ZXN0IGhhcyBub3QgeWV0IGJlZW4gcnVuLgoKVGhlIGNvbXBhdGliaWxpdHkgY29uY2Vy
biBpcyBpbiBsaWJjZGlvJ3MgbW1jX3J1bl9jbWQoKSBhbmQKcnVuX21tY19jbWRfbGludXgoKSBb
MSwyXS4gVGhlaXIgY29tbWVudHMgZGVzY3JpYmUgLTEgYXMgc2VsZWN0aW5nIGEKZGVmYXVsdCB0
aW1lb3V0LCBidXQgdGhlIHVuc2lnbmVkIGFyZ3VtZW50IHJlYWNoZXMgY2djLnRpbWVvdXQgd2l0
aG91dApub3JtYWxpemF0aW9uIHdoZW4gdGhlIHRpbWVvdXQgZmllbGQgaXMgZW5hYmxlZC4gVGhl
IGtlcm5lbCBkb2VzIG5vdApjdXJyZW50bHkgZ2l2ZSAtMSB0aGF0IGRlZmF1bHQgbWVhbmluZywg
YnV0IHJlamVjdGluZyBpdCBjb3VsZCBhbHNvCnJlamVjdCBjb21tYW5kcyB0aGF0IGNvbXBsZXRl
IG5vcm1hbGx5IHRvZGF5LiBJIGhhdmUgbm90IGVzdGFibGlzaGVkCndoZXRoZXIgYSBwYXJ0aWN1
bGFyIGFwcGxpY2F0aW9uIHJlbGllcyBvbiB0aGlzIHZhbHVlLgoKV291bGQgcmVqZWN0aW5nIG5l
Z2F0aXZlIHZhbHVlcyBiZSBhY2NlcHRhYmxlIGhlcmUsIG9yIHNob3VsZCAtMSByZW1haW4KYWNj
ZXB0ZWQsIGZvciBleGFtcGxlIGJ5IG1hcHBpbmcgaXQgdG8gdGhlIGRlZmF1bHQgdGltZW91dD8K
ClsxXSBodHRwczovL2dpdGh1Yi5jb20vbGliY2Rpby9saWJjZGlvL2Jsb2IvbWFzdGVyL2xpYi9k
cml2ZXIvbW1jL21tYy5jClsyXSBodHRwczovL2dpdGh1Yi5jb20vbGliY2Rpby9saWJjZGlvL2Js
b2IvbWFzdGVyL2xpYi9kcml2ZXIvZ251X2xpbnV4LmMKClRoYW5rcywKWWluZ2ppZQoKLS0tCkNh
bmRpZGF0ZSBmb3IgZGlzY3Vzc2lvbiwgbm90IGEgZmluYWwgcGF0Y2ggZm9yIG1lcmdpbmcuIFRo
ZSB1bmNoZWNrZWQKY29udmVyc2lvbiBpcyBhbHJlYWR5IHByZXNlbnQgaW4gdGhlIGluaXRpYWwg
R2l0IGltcG9ydDsgbm8gbGF0ZXIgcmVmYWN0b3IKaXMgY2xhaW1lZCBhcyBpdHMgaW50cm9kdWNp
bmcgY29tbWl0LiBUaGlzIGRpZmYgYXBwbGllcyB0byBtYWlubGluZQozMmM1MmVjODdkNjI0NWVl
MmQxMmVkNWRkNTA5ZTQwMDYyOTM5YjUwLgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3Np
X2lvY3RsLmMgYi9kcml2ZXJzL3Njc2kvc2NzaV9pb2N0bC5jCi0tLSBhL2RyaXZlcnMvc2NzaS9z
Y3NpX2lvY3RsLmMKKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfaW9jdGwuYwpAQCAtODA1LDYgKzgw
NSw4IEBAIHN0YXRpYyBpbnQgc2NzaV9jZHJvbV9zZW5kX3BhY2tldChzdHJ1Y3Qgc2NzaV9kZXZp
Y2UgKnNkZXYsIGJvb2wgb3Blbl9mb3Jfd3JpdGUsCiAJZXJyID0gc2NzaV9nZXRfY2Ryb21fZ2Vu
ZXJpY19hcmcoJmNnYywgYXJnKTsKIAlpZiAoZXJyKQogCQlyZXR1cm4gZXJyOworCWlmIChjZ2Mu
dGltZW91dCA8IDApCisJCXJldHVybiAtRUlOVkFMOwogCiAJY2djLnRpbWVvdXQgPSBjbG9ja190
X3RvX2ppZmZpZXMoY2djLnRpbWVvdXQpOwogCW1lbXNldCgmaGRyLCAwLCBzaXplb2YoaGRyKSk7
Cg==
