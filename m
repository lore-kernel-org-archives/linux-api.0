Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844504;
	b=P5cMVqecSuMcJhNCsucVFSm53JT62OVjdlq1ogtawHUefF+M+blAue2ZAP0vkX/mzH70
	 COP6iZ5AxCrwR0K2C089CiVXYiX4p5XCIqDw63JeOXu627Vp1WJV1k/i0qoBpj/xzLgMt
	 UY7G02WJT8TihchD+8oLEFMswuMreDCAzp+iEk0cqYYNejNt2cxuO83j71S3mLU3BBhoK
	 R4r58lGqMf6q/3hhlGkTbicO7eHTRI6sjrzOVJS/c2xhbraeNs+vNPJ9bbAerD9UgbWEU
	 3MHMmM3XYpRJqK/TWWcxRJZk1oLrtSeZvkc5eBOGMslNWHNXZX8DECzw+3IEtOv0dHQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844504;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
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
	bh=X3Dm0hLC9nArvWuqSBl97zzgcb5X+Lp3sM2SxU7epiM=;
	b=WHQ8uVUoCkEYKQrjHX2RZxxsRGdDoGxjbIjAeFsoF8Qav3oEv+plYdJah2ahISM4ecdH
	 rGozMIZ/8kt2NIlM3DYECmsp/fMkarbD3l+00fvOTXSe+u3N5aRhJuvTQ/7G0dtyTXOWQ
	 s/40YdhtB6/ropCaVI/J8FNioDtox/7cTfWXjWdpI5nL/YgtJtN90n4sB5gkD2dF8yruH
	 f4af3uKpUIVn2RVvM06J7831Urh1n+vLLPv+uqpu/dxTZC5WRIlXA3vkxos89eDvbcnRx
	 95bYMoeQa3Dm8Lj1R8DmFVwHTwWtKLXnrYf1Deh8BIoW+547D2gQBTYimY8Mm5XWbnQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=rvyVhE0v;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.10
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19012010.outbound.protection.outlook.com [52.103.23.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65E5606A31A;
	Sat, 24 Oct 2026 12:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B65E5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=rvyVhE0v
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uMG8E/9x6hKniJKSpKRrP1uBqKQ5TfFuo+PUYieS4AuInIyLEIAlR9HUsX+Zsx0dHxa/uPg89ZKcJduTb3vvPgnB20fHbunD8HNnaj04QGSmXxRjG14VvtmlMc3CG7DFgXXIIldBop28CPctkr8QA7paGjU0gcLmGK0metWtYKmz9duIDB1pMGHYwLng4VM6v1MLXSvFbFu8VHx6oOQT9U9ew09L+RAmsh+t/KTCXi6GvymNWR9ZnsTP8wMUxYOJGG+ibtLk8goYT98MXNAJqozJAu1D5cX8/NcTZ3epN6Z9CT/szK2nYdUNtpvK+I1vqFvrfCV5/rPFG4QQrWBjvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=X3Dm0hLC9nArvWuqSBl97zzgcb5X+Lp3sM2SxU7epiM=;
 b=Jf5DsKo2UoMNFIz1/mp7lRNe5gNwwngUwJ8GKWF743FD24TL2ifosx6pSsWjGfhZoIw6058375szmBGf0OSNj7xU9TmRtvvwhvqgi+bFEHmqJOxs3EmXK/7AyjL7ThgoA7TAN2T1FAmCXKadWPe5TMu9yFrwzaxrq9TrtkiPkzEJ1XxwDH7HfMef6WS3q+ofXgVQoBWCrLYOyhN+dLdQ0+2XbhqXACbmykBAwj9P5Nc6WKpbe06PgAH+DQj6nXcTqmw+pUvye9KrNCVqFejLUATsh9XWC42Iia3t34ebJXJbaCua9fl3JGm1iXHIAD3KpEVwQqmAQxKbKhSg4s6ONg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3Dm0hLC9nArvWuqSBl97zzgcb5X+Lp3sM2SxU7epiM=;
 b=rvyVhE0vR1SC/3RcJ6yusboPcn1otKojty9b0XARNc8JMugg/Z/1aVU4//TswP71dgtmA4ynfYb1I8OhS8vRhytODvFjLVx/uk5sJVMDksctxkaz4c9LLg6PpJRebja2eDg2R0g2O16FRxNlxBGOvwP0cB1eK6X2ImsQDCQENsgPyHglmJ5EbCI8Z9q+S+ynnen3RrrzONbWOkuaMGpYsxQmcB++p72tO1lLWR3me2871ZkVTu603MBbCU1W4pI8psxDt6EAQwZich9zNDM40mgT6Vi+1aRfDBJjiAr4KvMMEExuZusYIJ7rHcEQ24oSaaCZ+0jeoJ64Qtcii1yKwQ==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH7PR05MB9058.namprd05.prod.outlook.com
 (2603:10b6:510:1fe::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.20; Sat, 24 Oct
 2026 12:21:40 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 12:21:40 +0000
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
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: [PATCH v3 0/3] ipc/sem: account enlarged sops arrays and validate
 SEMOPM
Thread-Topic: [PATCH v3 0/3] ipc/sem: account enlarged sops arrays and
 validate SEMOPM
Thread-Index: AQHdY7I5wbt/X9q08UiVmhsB5GVyKg==
Date: Sat, 24 Oct 2026 12:21:40 +0000
Message-ID: <cover.1792808260.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH7PR05MB9058:EE_
x-ms-office365-filtering-correlation-id: 91b09f98-b3c2-43b1-46a0-08df31c95b97
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|12121999013|8060799015|8062599012|31061999003|25010399006|4140399003|24021099003|38102599003|15080799012|11091999009|21061999006|24121999003|22091999003|1602099012|40105399003|52005399003|10035399007|26121999007|102099032|440099028|3412199025|4302099013|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?dHlRTDF0N2pYeXFCeGZzb05nQzVucEViN2lkUkpONFVrUTBQdTdkR2NyQ2dK?=
 =?utf-8?B?bTlha3BiK05EVFl5RUF2a0FhN0lFNVprMjdOM20rb1FHRWFDYWgvUmZ2bTlE?=
 =?utf-8?B?Y2VXNW1RQnpDVnFka0FINDZBbG1oaHd4T2Y1ek9WUEg4Ni91ck9iS0JjQ05T?=
 =?utf-8?B?VnlnanMwS21rK1NjTlRoM0c4aDZtV3FleWVwaHkwN01hczhQUzJEY3NTRFJ6?=
 =?utf-8?B?S01GNXlDcnJ6dkJQSkRzNFpPeDBhVWNlL0lTaFF6OGlXMkpaM1EwOHNwaUlG?=
 =?utf-8?B?c1k5MEQ3K1JoVDRqRWFkZ0hrVTY4VkN3NFNwUzJqNzNrMkNjYWY2M3FxV3dq?=
 =?utf-8?B?cVJINExSTHFzM2dJbkdwRTJ1WkZpNk5Ta1NtRHlQblJFZHU1UkY5Qy96MGVh?=
 =?utf-8?B?V25CU2o1blJQMG9FeXRFdjlHK2hHSlp5enhhdE5hWjFrNTJnR1hNRVpVZ3p1?=
 =?utf-8?B?V1NJNlMxZ1lETjluTXh6bEJBTjJDYTdrbktXNmxsTW9qUDFBcndYVnVrT1dZ?=
 =?utf-8?B?R0JrdStxK3g4TWZCZitQL3lYRTB2WFhkcVdvMktEODQ5VlUvdWRCVno5MFdh?=
 =?utf-8?B?ZGlWTkxpSnZVL2Rhb285WFAzSElzNy9zWGJYUStVQ2FmbHNKR0dhdlpHVEVE?=
 =?utf-8?B?WDQyWnk3eUg0VkZtYk9TVG5DeHNObW10eG5wTENiLzlOdlUwcTZwSU9IL20y?=
 =?utf-8?B?K0Fvd1AzaWlKbnZ3WG15dXR6MWxnWTRlaDdTdmJXNDRzZ2lHelFXV2IrdkxB?=
 =?utf-8?B?UHZlbmxOckdLVjMwY1lLNmZKT1pKM0t3ZnZQTWRYck5OMng2Tll1enZVOVVZ?=
 =?utf-8?B?WUVLRU5WWUFXNXFrUUs1bE9mc0VjeFZwTTJtWVRrSWY5R0dPem8wTk1xSkxr?=
 =?utf-8?B?UXVKbXpvTit5NHlZNkt3WVNyYThKTDgxRGg3Z1ZnM2MrQldUdzlKSWd5dGtz?=
 =?utf-8?B?V1VQbFkwNThvSFFYMFEvMG9JNmZNYmx1Y2dYdWI3bHdvRVp1SG1hU1ptVzh1?=
 =?utf-8?B?QkdnSmwyZlBHMitoWGh3Qjd4UGhXZlBIZFRFUGlpWFNxTTM1T0Y2TmR4SWR1?=
 =?utf-8?B?eTV3M2I2cW11SVdhSlp1d3M5Y0tHcWh1cDVySGRYaHozbHAvNENjOHBoN0dz?=
 =?utf-8?B?Ym5rOTRwdmR6VFZzSE1VTjJEMjJnSWs3UGtxTlRHeFhtcElVQTVJZm1kQ3Fl?=
 =?utf-8?B?MTBjcExaZEVBNXZsYlR6dHBraGNpa2VLWDBmU0F1VHlMSUJJaS9sRlc1VndT?=
 =?utf-8?B?ODJzZkxHZTVDNEFoaWNkOHBPQTVSRVIxVUxKcHJOTW5Pb0Q0TUZWU0lhN09y?=
 =?utf-8?B?cU1HZWg0Mm9wclN2Y0F0dCt4ejVFMFEzT3lIaEl6Rm8vMElncXM2R2VDbFNO?=
 =?utf-8?B?eWJQMFA0aGJKdVBWcC8yUDlKSjN1QWs0ektXa0Q5bFdDTDlMQ3prRG04UkFk?=
 =?utf-8?B?OEN5YUllbFJxRUEwT3NzTnpwQXVKamxCZWY2RnRWTjRvL3ZWenpJbGRGcmdz?=
 =?utf-8?B?cStjMHJxRXc3b1hyQ2h2bnNvMnF1dnltT2xnWGRabTMvZTUwTzZtd05oOEx4?=
 =?utf-8?B?a2lSY2R4citMZWtNUDYxazEva1psNzlJeWZtN1lDeUtsbkFweGNncGdZNDMw?=
 =?utf-8?Q?jtDBpz+MFk7eiYMguRhWWNqRrjNymec/IRq1UGD/DstI=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZVQ4Sk5pTlovL0hCak4reVJVVTBvRk1heVdNWnlONFNoRzhLMUltYVFOTzE3?=
 =?utf-8?B?d25ZdnBNMm1Tb2txbUF0L1AwRnE3aHNNeFZXcHp5Z3lScDFrbHRCeW5CL29G?=
 =?utf-8?B?dXp2bXBGZktjYzhXY3VsRTc0aXQvcHFwSU9HM3ZiUjZBcndZeUVMeEtDVlQz?=
 =?utf-8?B?bHNQZVNhcEFvcXR3VVVrNG1VdlhybUhLakdjeEJ5S2dWbXlDaGg4T2k2MzVh?=
 =?utf-8?B?ZjNUd3lCMFllSWsyb0lnMjlEejBhTFNWY0kzeU9pTlpFR3B6dFBqTTFrL2Fm?=
 =?utf-8?B?eXo5NnNOUWNYcDJLTGFrMnQ1RERjU25CdS9xNlcrd0JSU3RGOGJGRkFSeGRo?=
 =?utf-8?B?R1BBeUViZU9qa3NJWGJwQ3ptTzlybWdMZ1UyV2ZZT0lXcXFXUllSZWgvR3oy?=
 =?utf-8?B?MXJDRWdlMXFzZElIanBpMGMvSTlnWGFlTm5YN3pWbFF3cWR1NE0rVTk2SWNj?=
 =?utf-8?B?SXpSa1FUZHd6OFB5ckdERjhtN2dRUFZpVExRS3Y5alRvbWVlbi84U0lSVm8w?=
 =?utf-8?B?THNvZzE2WXQrZ1paUmR5OTBxQ3Y2TzRVUlFNZWtYSHQwSlpkNEltUzhFUXFa?=
 =?utf-8?B?eHQ4YURILzcxTTNSQlQ4L0pUQnJOWWcxOHBKa21pc2ZNZzg3WlFaU1dQOFR0?=
 =?utf-8?B?VjhnQkxZMkFaSHVYNnlTbWE0RjJVSzJYbk9LT2FvcDhyRVI2TURjbU5MTVIw?=
 =?utf-8?B?bk00QzBMYzBUQTR2clJHU2M3cTV5TWlRWjRSWEl4cVhEUTJkamVlVDNSVGZF?=
 =?utf-8?B?ajlnQTFZL2tNSHlUY0d5Uk95ZERxcjJlb1ZoRTA1Si9RUHpqN0ZXbnFxRU83?=
 =?utf-8?B?V3V0OXE5c1M5QTRCWFhEYk9yKzZHNE1PNkQxV2QrcjFaTXZsdEpVdWVubDNV?=
 =?utf-8?B?YmhtZFpuNGlRemJ5YlRiM09XUWUvbnAzb1VFUFhueXpCVkpud2dzLzc1VmN4?=
 =?utf-8?B?dlhYTE5GRUd5WFF0VWRkQ0hpaHcrVEJEMUM2Q0p1bFM5ektJSk5HbEVLcW1Y?=
 =?utf-8?B?RDMvd09rczZ0WHJNWlE0L25mdVlhQUxFbkpDYU4ybzdsUDd3RHFBY3RXa1Mz?=
 =?utf-8?B?L2Jtcnh4aGszNUl6eTg0UWlleGoyU3VRMGlvQ2VhVDlCSDFOdzVIZDI4dkhO?=
 =?utf-8?B?YkJIdGR3UWk5V1FTVEJpVnRjZ0lSV3NzU0QrNGIxR3czTmVrY1AxaU9nWTY3?=
 =?utf-8?B?L0UvRWZKZGxkQ1EvVGkwTWNKUGRQRHpYZDNDK0lvYWRRUGxCMVBhdC85NUxh?=
 =?utf-8?B?bVQ3QTdsbnorV1JsUXNsSnh0VFVrWENLZlNnT3VON3JRaVRoTG9oRWtpNTI2?=
 =?utf-8?B?Szl5Z0hNcDVKSCtick41RXpyWXdMUWZDc2oxcS9UaU5NMjlUaHdrZEpoa0pJ?=
 =?utf-8?B?ZSs0Q2pFVWdsTnNDOTZPTGNzaG1XOHBMaXJ0aDN2eHRlUVluUnVwdy9hU3pW?=
 =?utf-8?B?cTRBR2pYSjVabWtHQ3R2Z0ducG5wb1BGVjNwQ0RtOVEvVkc5dW9xclJ1T1dQ?=
 =?utf-8?B?cDd5ZlRkSXNuVFlLQWxLZEx1SVdzZk9KQmVHSlRKWXlOMllYWDFDZGRZUHlh?=
 =?utf-8?B?SG9ucm1pVEpDcG5PbWVBbWs2dE5mMzVlSURRaS8zNUxpaW5ERElKeHZ3enQy?=
 =?utf-8?B?ZjQ5dHNQMGNWUFpSV0VmbnRGTVgyZWpYUlpZZE42MnVmTjhha2FkUThvMTRm?=
 =?utf-8?B?dEp3ZWRuUmczWnBoNVZrS0FHeTJqMUpOcXZucWhEN0lhY0gySzkwNXcrRHU2?=
 =?utf-8?B?KzczUTJlZVFHRDNSTStaTkp1VDh6QVhvUnZzZUlQRlgrcFlkUENxTlZkRGZ1?=
 =?utf-8?B?cEFIZEZiSFl0RnQ3VmlZWTdmdG8zdkowUWh6RHo3bko3SlVZWGFVc2Z6VkNi?=
 =?utf-8?Q?rMmbUalnXoHTm?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b09f98-b3c2-43b1-46a0-08df31c95b97
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2026 12:21:40.4371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR05MB9058

QW5kcmV3LCBNYW5mcmVkLCB0aGFua3MgZm9yIHRoZSByZXZpZXcuCgpUaGlzIHZlcnNpb24gc2Vw
YXJhdGVzIHRoZSBhY2NvdW50aW5nIHRocmVzaG9sZCBmcm9tIHRoZSBVQVBJIGRlZmF1bHQuClNF
TU9QTSBjYW4gYmUgY2hhbmdlZCB3aGVuIHJlYnVpbGRpbmcgdGhlIGtlcm5lbCwgc28gaXQgc2hv
dWxkIG5vdCBhbHNvCmRldGVybWluZSB3aGljaCBvcGVyYXRpb24gYXJyYXlzIGFyZSBhY2NvdW50
ZWQuIFRoZSBuZXcgaW50ZXJuYWwKU0VNT1BNX05PQUNDT1VOVCB0aHJlc2hvbGQgaXMgZml4ZWQg
YXQgMTAwMCBvcGVyYXRpb25zLiBBbGxvY2F0aW9ucyBhYm92ZQppdCB1c2UgR0ZQX0tFUk5FTF9B
Q0NPVU5UOyByZXF1ZXN0cyBhdCBvciBiZWxvdyBpdCBrZWVwIHRoZWlyIGV4aXN0aW5nCmJlaGF2
aW9yLgoKVGhlIHN5c2N0bCBoYW5kbGVyIG5vdyBwYXJzZXMgd3JpdGVzIGludG8gYSB0ZW1wb3Jh
cnkgYXJyYXkgd2hpbGUgaG9sZGluZyBhCnBlci1JUEMtbmFtZXNwYWNlIG11dGV4LiBUaGUgbXV0
ZXggY292ZXJzIHRoZSBzbmFwc2hvdCwgdmFsaWRhdGlvbiwgYW5kCnB1YmxpY2F0aW9uLCBzbyBh
IGZhaWxlZCB3cml0ZSBsZWF2ZXMgdGhlIGxpdmUgc2V0dGluZ3MgdW5jaGFuZ2VkIGFuZCBhCnBh
cnRpYWwgd3JpdGUgY2Fubm90IHJlc3RvcmUgZmllbGRzIGZyb20gYW4gb2xkZXIgc25hcHNob3Qu
IFRoZSBzbmFwc2hvdCBhbmQKcHVibGljYXRpb24gdXNlIFJFQURfT05DRSgpIGFuZCBXUklURV9P
TkNFKCksIGFuZCByZWFkcyBjb250aW51ZSB0aHJvdWdoCnByb2NfZG9pbnR2ZWMoKS4gVGhlIHVu
dXNlZCBzZW1fY2hlY2tfc2VtbW5pKCkgaGVscGVyIGhhcyBhbHNvIGJlZW4gcmVtb3ZlZC4KClRo
ZSBVQVBJIHdhcm5pbmcgYWJvdXQgcGh5c2ljYWwgZnJhZ21lbnRhdGlvbiBpcyBvYnNvbGV0ZSBu
b3cgdGhhdCB0aGUKb3BlcmF0aW9uIGFycmF5IHVzZXMga3ZtYWxsb2MoKS4gVGhlIGhlYWRlciBu
b3cgZGVzY3JpYmVzIFNFTU9QTSBhcyB0aGUKY29tcGlsZWQtaW4gZGVmYXVsdCBhbmQgcmV0YWlu
cyB0aGUgdW5pZm9ybSA8PSBJTlRfTUFYIHJhbmdlIGNvbW1lbnQuCgpUaGUgc2VyaWVzIGlzIGJh
c2VkIG9uIDdiZTRiYzUyZmQ5ZSAoIk1lcmdlIHRhZyAnZHJpdmVyLWNvcmUtNy40LXJjMScgb2YK
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dyZWdraC9kcml2
ZXItY29yZSIpLgoKVmFsaWRhdGlvbiBjb21wbGV0ZWQ6CgotIFc9MSBidWlsZHMgb2YgdGhlIGNo
YW5nZWQgb2JqZWN0cyBhbmQgYSBmdWxsIHg4Ni02NCBiekltYWdlIGJ1aWxkOwotIGEgVz0xIGkz
ODYgYnVpbGQgb2YgaXBjL3NlbS5vLCBpcGMvaXBjX3N5c2N0bC5vLCBhbmQgaXBjL25hbWVzcGFj
ZS5vOwotIGluaXRpYWwgYW5kIHVzZXItb3duZWQgbm9uLWluaXRpYWwgSVBDIG5hbWVzcGFjZXMg
cmVqZWN0ZWQgbmVnYXRpdmUgU0VNT1BNLAogIGludmFsaWQgU0VNTU5JLCBhbmQgbWFsZm9ybWVk
IHdyaXRlcyB3aXRob3V0IGNoYW5naW5nIGxpdmUgc2V0dGluZ3M7Ci0gemVybyBhbmQgcG9zaXRp
dmUgU0VNT1BNIHZhbHVlcyByZW1haW5lZCB2YWxpZCwgd2l0aCB0aGUgY29uZmlndXJlZAogIG9w
ZXJhdGlvbi1jb3VudCBib3VuZGFyeSBlbmZvcmNlZDsKLSB0aGUgb3BlcmF0aW9uLWNvdW50IGJv
dW5kYXJ5IHdhcyBjaGVja2VkIGF0IDEwMDAgYW5kIDEwMDEgb3BlcmF0aW9uczsKLSBjb25jdXJy
ZW50IHBhcnRpYWwsIGZ1bGwsIHJlamVjdGVkLCBhbmQgc3VjY2Vzc2Z1bCBzeXNjdGwgd3JpdGVz
IGNvbXBsZXRlZAogIHdpdGhvdXQgc3RhbGUtc25hcHNob3Qgb3ZlcndyaXRlczsKLSBzdWNjZXNz
ZnVsLCBFQUdBSU4sIEVGQVVMVCwgc2lnbmFsLWludGVycnVwdGlvbiwgYW5kIElQQ19STUlEIHBh
dGhzIHJlbGVhc2VkCiAgb3BlcmF0aW9uLWFycmF5IGFsbG9jYXRpb25zOwotIGEgY29uc3RyYWlu
ZWQgbWVtY2cgcnVuIHdpdGggZW5sYXJnZWQgb3BlcmF0aW9uIGFycmF5cyBlbnRlcmVkIHRoZQog
IEdGUF9LRVJORUxfQUNDT1VOVCBsaW1pdCBwYXRoIGFuZCByZXR1cm5lZCBhbGxvY2F0aW9uIHBy
b2ZpbGluZyB0byBiYXNlbGluZTsKLSBzdHJpY3QgY2hlY2twYXRjaCAod2l0aCB0aGUgaW50ZW50
aW9uYWwgQ09OU1RfU1RSVUNUIGRpYWdub3N0aWMgaWdub3JlZCkKICBhbmQgcGF0Y2ggYXBwbGlj
YXRpb24gY2hlY2tzIHBhc3NlZC4KCkNoYW5nZXMgc2luY2UgdjI6CgotIHVzZSBhIGZpeGVkIGlu
dGVybmFsIFNFTU9QTV9OT0FDQ09VTlQ9MTAwMCB0aHJlc2hvbGQgaW5zdGVhZCBvZiB0aGUKICBy
ZWJ1aWxkYWJsZSBVQVBJIFNFTU9QTSB2YWx1ZSBmb3IgdGhlIGFjY291bnRpbmcgZGVjaXNpb247
Ci0gcmVtb3ZlIHNlbV9jaGVja19zZW1tbmkoKSBhbmQgaW5saW5lIHRoZSBTRU1NTkkgYW5kIFNF
TU9QTSByYW5nZSBjaGVja3M7Ci0gcmVzdG9yZSB0aGUgdW5pZm9ybSA8PSBJTlRfTUFYIFNFTU9Q
TSBjb21tZW50IGZvcm0gaW4gdGhlIFVBUEkgaGVhZGVyOwotIHJldGFpbiBNYW5mcmVkIFNwcmF1
bCdzIFJldmlld2VkLWJ5IHRhZ3Mgb24gdGhlIHR3byBwYXRjaGVzIHJldmlzZWQKICBhY2NvcmRp
bmcgdG8gaGlzIGNvbW1lbnRzLgoKVjI6Cmh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2tl
cm5lbC9tc2c2NTI3MDUyLmh0bWwKCk1hbmZyZWQncyB2MiByZXZpZXcgb2YgMi8zOgpodHRwczov
L3d3dy5zcGluaWNzLm5ldC9saXN0cy9rZXJuZWwvbXNnNjUyODI0Ny5odG1sCgpNYW5mcmVkJ3Mg
djIgcmV2aWV3IG9mIDMvMzoKaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMva2VybmVsL21z
ZzY1Mjg2NzkuaHRtbAoKQW4gQUkgY29kaW5nIGFzc2lzdGFudCBhc3Npc3RlZCB3aXRoIGltcGxl
bWVudGF0aW9uIHJldmlldywgY29tbWl0LW1lc3NhZ2UKZHJhZnRpbmcsIGFuZCB0ZXN0IHBsYW5u
aW5nLgoKWWluZ2ppZSBXYW5nICgzKToKICBpcGMvc2VtOiBhY2NvdW50IGVubGFyZ2VkIHNvcHMg
YXJyYXlzIHRvIG1lbWNnCiAgaXBjL3NlbTogcmVqZWN0IG5lZ2F0aXZlIFNFTU9QTSB2YWx1ZXMK
ICBpcGMvc2VtOiByZW1vdmUgb2Jzb2xldGUgU0VNT1BNIGZyYWdtZW50YXRpb24gd2FybmluZwoK
IGluY2x1ZGUvbGludXgvaXBjX25hbWVzcGFjZS5oIHwgIDMgKysrCiBpbmNsdWRlL3VhcGkvbGlu
dXgvc2VtLmggICAgICB8ICA3ICsrKy0tLS0KIGlwYy9pcGNfc3lzY3RsLmMgICAgICAgICAgICAg
IHwgMzUgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0KIGlwYy9zZW0uYyAgICAg
ICAgICAgICAgICAgICAgIHwgIDcgKysrKysrLQogaXBjL3V0aWwuaCAgICAgICAgICAgICAgICAg
ICAgfCAgOSAtLS0tLS0tLS0KIDUgZmlsZXMgY2hhbmdlZCwgMzggaW5zZXJ0aW9ucygrKSwgMjMg
ZGVsZXRpb25zKC0pCgoKYmFzZS1jb21taXQ6IDdiZTRiYzUyZmQ5ZTBlNTVkYzlhMmUwMjMyYjg5
NDI3ZDJjNGI2MTQKLS0gCjIuNDMuMAoK
