Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.13.36
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793207091;
	b=R+VyWbdkqa+7iSTOIkbvAOsO2WGgDJOYrZwP6L9FABratiuMrPFoK/sQOLzALLwuiuEw
	 uvktBz32mqDvi67q8vOepjM+k+LfAVzVzhFDjQc/vP1iTMDwy2BKwi0L/UXK5NwG+QU+J
	 WUJuJy261jQPnfS8/ROiCO7kSAEoZ/IQnH2NwP6Pe4+G3onsLiXO8PLUGKbyitMlxp97R
	 cgSE3UGEKo0vZZegY8UKMG1BXBPCf0bZUCka+yL4t2PipexS+THWj4ttgmKxiki32Bl6v
	 9fXvXHDpsjvrzV2xCJdkO5u4CCpg0+OIBhxHDNnI/HAdZYOc4QvXtdFqV36mqVUxtUA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207091;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-slblob-mailprops:x-microsoft-antispam:
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
	bh=/dO0CvrBADtofHrqHCV5qDDe0cJ5TebMtcY0bxEjOC4=;
	b=yyU/ExN7DaI5JqBAjtxOoVcOCAKTCHksPELICbzqjnLCzWdM6f08S1UUzgoP7oXtpJXP
	 EbncMgrcH8NCaKpGW9m4mPUsfNFh6TED1f0gcjDVqpCFzM4jzX5Y6PdGei1pNISeR/q7d
	 3W7pSbWjrSZO6eFg5tPLvcU1o6xcFAQ46uaAcZFKvVMBijQkrt431Ne1orb9wnJlcXfmP
	 fa1s0aOT4cwPlRjW8bJ6rFxqbUb8bON4eezBFDxiZr6pKW0m1XD5aUWfSsHoOt4xjMcat
	 2wc+tfLr+vEb5Hhylkhm+EqkMaqKN+tHk+bu+NGo9KooJMBPIcwq0jCHPL2noEEmR8g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Zr4aV9Rv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.13.36
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazolkn19011036.outbound.protection.outlook.com [52.103.13.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A95D606A322;
	Wed, 28 Oct 2026 17:04:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A95D606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Zr4aV9Rv
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t2x2v6qHo+bUfB/KPz3f/VoFGmpeRPHlzePzNDZHkDgBQi49QRab1tyt9YynhaLib1kpSNEN3heEFbMwmsuIApRw+ePhA0yEUqBRENSCmT/ieCAYfvtyFty4v1p9WiYPyNryyvDTWg9/RHphRcoo8KBLzxYYbV+2Pd4UF4TODP+M+Jt8odtHMk1ccan5Dig0PYues+odW1WJbk+MG9nLCJoFNljf+R/jJ5fjcJZj2TpbxJ67KdcevzNoHoZ9pDKye1GYdULIa9oPcIYBXpVWCs1/eLw+IcRa3KTaUdOQg0jAG2MoC0viVle6eELnfBioGnHeLXkalth8dQcfeYY2Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=/dO0CvrBADtofHrqHCV5qDDe0cJ5TebMtcY0bxEjOC4=;
 b=vcoGcN8km1/xhqJ7ARjqyEGV2TRLEbqceo7yYNDhMWOC/KrDuYTcQEpBUP/eL2P7SXQBo5Z/HVtGngMw086Mit+2+Xw/+P2cwKmJEbs//WvgXHAG7sAPxdGn+/5Ln8XKO79/5LCVmzzZR6EQEHLXocfcPTbSlQtaKyoF0nmBwQZjWuHWJxuSx+5E9Sat4lKlafcEebFmJWlaUwJbhA2OWxLFLTKu1Z9Wsxu3dNIoBFNxwnSQgB2CiMRVxqQfxRcCVJBsLj2DVHgL9esaT5TQnm/fKGcPUD/vqy7ZzwXk3G/eBljT/G+uH6Te83fx+XcWyioqudQLx7CDT58cXLJzkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dO0CvrBADtofHrqHCV5qDDe0cJ5TebMtcY0bxEjOC4=;
 b=Zr4aV9Rv8V0wygCYCEx13T0QUmHKjTH1S1poEb2Db2r3KxMG5fpA8HJVK7NGInoFdAAIhaFjzW/Bcg9rz0vF2FtO53eZFCF5srwLAh+bq3IfVoU+LhYidKcWwEmSuI7ZiHItRo5+Zqyj1lB8nxJhitshixBGdYsAQgJcf3xR96WVwyma1C8Pi67B8JMdi/1NWD7LoZEKm3t5P9CuRvuSS0ZUTU8F4G2yTqvvsu1+j25w11E1l2l6C6HU3LjARqJ59mY78akS9+fJ6v3LvjmKW4//nyrHH1lZi5id0S70VW//lHcprr1FK1xnt5+47IF0uiRQ59h+H/wGHHwfpW8DGA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by MN7PR05MB211011.namprd05.prod.outlook.com
 (2603:10b6:208:633::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 17:03:57 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 17:03:57 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Manfred Spraul
	<manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, "Eric W .
 Biederman" <ebiederm@xmission.com>
CC: Yingjie Wang <x-professor@outlook.com>, Vasily Averin
	<vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, =?iso-8859-1?Q?Michal_Koutn=FD?=
	<mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Alejandro Colomar
	<alx@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v4 1/3] ipc/sem: account enlarged sops arrays to memcg
Thread-Topic: [PATCH v4 1/3] ipc/sem: account enlarged sops arrays to memcg
Thread-Index: AQHdZv5RQqsMUAAPckG7++9LTV+AxA==
Date: Wed, 28 Oct 2026 17:03:57 +0000
Message-ID:
 <565d855cbd81e0f49018da21df00ff0308f646b1.1793207025.git.x-professor@outlook.com>
References: <cover.1793207025.git.x-professor@outlook.com>
In-Reply-To: <cover.1793207025.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|MN7PR05MB211011:EE_
x-ms-office365-filtering-correlation-id: ee5908e9-88c8-4ec3-c1be-08df35157461
x-ms-exchange-slblob-mailprops:
 iS5pQZgsAQDZd5pLvsexcGXRgbvG27NW+B8L0HwCttYw7HGLoa+UHHybvHZo8DgaHrc7zZVddGhABIfIk3SU7q7ndKYLvr8BXA5eWM60v/MEFFqzbD0Pd4Ha2jkr5M6y0Mx/vo6toXoS3x2xWEsWLdUkq3cVCwKkOdWdfibPiPd4vWcb3pzKvjxBowSG8qTaNkgJkeCu0bEi+pkpnjnFzBVc8QVxBv8Yh/y5m/6V67MrN35c9qW2p4q0V63QLSMeVqNex/Qs978eWg8Xn4b8nxSblJtuiO3+oNgwZJ4zKfEDyNhkYfA45G0Lc9C9YmepGK6Zt0uPlWlEMTsq8N3on70BiQZ6YzCrvHCxKvxhpobEMVVTgev/558JPWBPZmDEM1VwhdOwz9HJOjSnXxGdilXDxbNftlch/d4vy+550xbzdBOZiYlC3AmDMuGQUzwY75nH5+T65ei2i/TX6hCSVRs3OhV5v8urTkkudTSMJJBa8/7F+4RMomGmdoxkpfMg3qVesRA79oC9BRF3oXUl3mWpkFE7LXW6SJdtfYcY8NvXaFdop62UldrVMAFq1YwwOme682Qp6HAXsPMHjU/PrVO+cJNt/8kM1JEZwznpmUA946laoOcZsBUNUv5nYYM2zwXGULTZDuFT0g+JuN+HQVxiA2Hg2pvvcjXDcKvOXin2CBOId/CD0O4NYWD7i7Mz66/lS9/YMu7F7M/S3WYf5rbritHrnjOEkWEQzTozsrO61H12SY/ZBcoqheeNBkzbCyfYCoiT279u8rT2wtnz7yscvKN3mrXP0NJJ3EB+FSsGaLzkggfnCtCOpK7gxmUh
x-microsoft-antispam:
 BCL:0;ARA:14566002|22091999003|15080799012|24121999003|24021099003|31061999003|8062599012|12121999013|8060799015|21061999006|11091999009|41001999006|38102599003|4140399003|25010399006|19110799012|102099032|3412199025|4302099013|440099028|1602099012|52005399003|40105399003|26121999007|10035399007|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?qR97iVvaZtAL3Rsup5adfo2lpm0UGFvOUwFfneWoaUYLyVB+YBaUQy0HEO?=
 =?iso-8859-1?Q?MNno4KamrhlBCy3kgTumrZS4hgCF86RdDFrmQc4w2QTb83utfOPy381FHj?=
 =?iso-8859-1?Q?9AbOMSn8HnlX/gjd6iZYXUsiU63Cs+Po6dtReuAHb4TLEXwPZQO0QaMJkR?=
 =?iso-8859-1?Q?lFs4ieGsnfgqXdaW2ho0bqi2m2TNjw9dphDQl2bODm7JKKvcfSMQbV2aGW?=
 =?iso-8859-1?Q?L/G6lMB/sf+TeUcAgv+HjClhTydXeotugo71gptjDahIgq1rJ09gLqHpPg?=
 =?iso-8859-1?Q?H3jRduU2J/cYYPn3s54lem+o8PQDrzIIGIWcO1PzVLvwl2L+bl4r++0iOp?=
 =?iso-8859-1?Q?nMYUgYS/f81Jqqi4AyO47jvuXBno4iw2yJJ7YjjJ42jSoPw9YbeLkynGBR?=
 =?iso-8859-1?Q?DkgqRPJPE8vZQhYjd26Ts0F1KE8ji2ABIpWd7WKQAgHcM8p2Gaz4W8XroR?=
 =?iso-8859-1?Q?U1YGHIwgLcebSZGzfGk2ahf3bqfEteXq9AxXuCjYonh6ma+S1QNsUzJbMi?=
 =?iso-8859-1?Q?8Qnzvv3ml6HQSRcFFyhs5Sh5h57y4LXL3tXEZDCbJFJqtiqF290RzFG8nt?=
 =?iso-8859-1?Q?ZOGs9vQ2J6aBgLuOZ62Bvvj68wTFNfYYup70VJW3Ev1S45/A5dkabhswam?=
 =?iso-8859-1?Q?xY5gIAe7waWZdSxlXwcw+uEEnlnxXXChr3Lsy3M/A7fklrdtFKB30LOC0z?=
 =?iso-8859-1?Q?o5UnmhRCkleKMoXnhti010KG6F2Y1JMhpKjeN2JnSAtfTK06NuX6szz8rK?=
 =?iso-8859-1?Q?0w81tZ7q6ZX9vHHSQ59Eg+tySFrdlHgizkZUl4Pwrke5w98u9AvCw/YPeQ?=
 =?iso-8859-1?Q?BUbp4kn8gIEa3HYt4tAGwU/G7GZvofoS8D9p+jJjed3gkRX1IaaH1ozxAC?=
 =?iso-8859-1?Q?rNEL+72SNIEsflLkFMXCmSuTBBLuD5NFNlfghczQjhLMfVYT/ZrMlWgkdF?=
 =?iso-8859-1?Q?7EA1eBygu5NMfuxPXXgVAB+VsUT//n4ezQonkuzzr0DjqxQtebiSCl0eJ2?=
 =?iso-8859-1?Q?cOaPGMSngOFvV7WnfQek17TxKcfXaRea3nE8QYDyJP6TIX6kHyD0Z42817?=
 =?iso-8859-1?Q?pdrdPiTfFdamnysJNmoHkMre6MbnNcxTXWjN4vPvw9Yrcn9/R2EryWPFqB?=
 =?iso-8859-1?Q?nBRc8NiKsXTRznXL2RYo3xmGZaQRm5LbHtgpR7Lrr3V2MUjMcwneoKmIcD?=
 =?iso-8859-1?Q?3bETYEnnf+EXZvNU7yw2sh1z+XwQ8GsRVM9iMCOG9YLssKFyDhUeq/Jaqf?=
 =?iso-8859-1?Q?yxvWqdvzEwSMO0KDCcSyvUGuQbAi21Ewp+A+bh4xaHU0LCDYfjs9YpvBv+?=
 =?iso-8859-1?Q?1Rjn?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?evoD54N9B3aiK5/1cTtFn/P3siuqf+aR4ZjVojbsTv70Vn9lpSpdxDAtw5?=
 =?iso-8859-1?Q?+Ay4tW9jtmfaUOpzkMnuzLjODAdf0lCDvlNIkWRyQNdWOyWG+E984KC5PZ?=
 =?iso-8859-1?Q?KC9JUnMaa2RQzOlihAtjovIKQ4rUQYnvjDuqSb+DREReEhrEFMg7GRY2wk?=
 =?iso-8859-1?Q?nklk40OoVqmz3MlN+K4s6WDVlvl43o1Gk0lb9axNXN7hmvJE/WjgMHxe1s?=
 =?iso-8859-1?Q?1V8F0e5t+19acVRsRj5RPcHxISZxTHMJMC+P63qW4p0BRFoYrbY67g0xhz?=
 =?iso-8859-1?Q?h9W79AZCqBGr2Rgz+WdZN1gIQ0ibKoRECrEFYMwxdPw5hUhjWZE2glRMYA?=
 =?iso-8859-1?Q?stBH38KlE5ffPYwYeq23RCm0qLdcqUNVHbomHFfP+otuys+uigeXANtDty?=
 =?iso-8859-1?Q?C4nbac2DaWXljDuxkMzr088K8FFR28PrhwpgxerFrG62Pd0itj+QEBauBc?=
 =?iso-8859-1?Q?5WoQsBHJcijUvybh07qYVJ04pRD11xrrRP6orKsjjPSzZZs9uvUo6S6bGV?=
 =?iso-8859-1?Q?Y/miiZMZAsQSujogObCNzcw4Pf+oj3BRnrvW4m3WmKsk2vP+5aUNQpGrrr?=
 =?iso-8859-1?Q?q46Ke/GS7DEFj4k5J2KoY4HWHnlCp3PLvodSUk5NB0celHqNYrnhSF/5mI?=
 =?iso-8859-1?Q?CmyPJ42uJvqezjkRkJ+y29u2KQKF9aihXqrda0UwQRk34/ljGH8RvbPPEw?=
 =?iso-8859-1?Q?T+csFgmzor8cr+e5zILyIF9Jwjr4FGXkUEgC9OZi0cM2qdfUVhfRhUrHFN?=
 =?iso-8859-1?Q?SUpq/qJnwzFLqQOlpfHRFENypC08i4fdXYomlBC5gEjPigAPZBaekjCEYc?=
 =?iso-8859-1?Q?jjfCt43X7Mfxi+Mkgq2tHwlDt+/XErGCc5i2IIwkxB4UUxD3BUk9y3bJgF?=
 =?iso-8859-1?Q?ArJapuVvgSehMo8IS7mpNXIpHc5VqgcqBBpwPEvqE2+zUuStDTf+d44TYz?=
 =?iso-8859-1?Q?hJ8ZYqhqhpQ6BqgLbCJxoy9e+gThyjIpp9z8H0rrXZ4XhDGjsbxlHMmhnD?=
 =?iso-8859-1?Q?bJTek4kc8Sw9B+t6kDCAt3R9WEbrv+LJTn/ECbiUttmGo5TOK8LvbeE9P2?=
 =?iso-8859-1?Q?s0xwHJt2v2vCkAkHENmCMia96agF8pG6qiv0oHtnV9lFJ0QGnlV0M33IC2?=
 =?iso-8859-1?Q?quAX8G9K/rnX3G1bO3dQM7C0z6w4rXicBzosCH1RkWFJ9tT3bKWIgTq9Xm?=
 =?iso-8859-1?Q?7GLSJKPZy03zZ9FuJA0+xYLxhR+0nWrgkh8DTeuLGEb9tw52rC1UbxyqfR?=
 =?iso-8859-1?Q?EjfGywK8r8aY8nW0d3slDuhu5MnLKLPzpgMp9RXXJQGyPWTOlFRXIuOftH?=
 =?iso-8859-1?Q?AuC2E3Wzap/h3Xx8TIqeOCp/ozayvsSja96/BN+RgcXem3jvQECSpteA73?=
 =?iso-8859-1?Q?5tgvFLW/QTwWep8LzSYPr2+PZxl/P0nwbip5PhLqxGuale2YTnRgFmpMQ7?=
 =?iso-8859-1?Q?7jdmLs6di7nlmqJ9?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5908e9-88c8-4ec3-c1be-08df35157461
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2026 17:03:57.2729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR05MB211011

Commit 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in=0A=
do_semtimedop()") removed accounting based on the assumption that sops=0A=
arrays would remain small, describing a maximum cost of two pages.=0A=
=0A=
SEMOPM is a UAPI default that can be changed when rebuilding the kernel.=0A=
It must not also define the accounting policy, since changing that default=
=0A=
would enlarge the unaccounted range.=0A=
=0A=
Keep the historical small-array range unaccounted with a fixed internal=0A=
threshold of 1000 operations, and use GFP_KERNEL_ACCOUNT when the actual=0A=
nsops exceeds it. Requests within that range retain the existing allocation=
=0A=
behavior, while larger user-controlled arrays are charged to the caller's=
=0A=
memory cgroup.=0A=
=0A=
Commit 50ec499b9a43 ("sysctl: allow change system v ipc sysctls inside ipc=
=0A=
namespace") later made the per-namespace limit tunable by IPC namespace=0A=
owners without capabilities in the initial user namespace.=0A=
=0A=
Link: https://lore.kernel.org/r/20261016152609.2528805-1-x-professor@outloo=
k.com=0A=
Fixes: 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in do_s=
emtimedop()")=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 ipc/sem.c | 6 +++++-=0A=
 1 file changed, 5 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/ipc/sem.c b/ipc/sem.c=0A=
index 5ec41de7e85b2..a8c9807175520 100644=0A=
--- a/ipc/sem.c=0A=
+++ b/ipc/sem.c=0A=
@@ -176,6 +176,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, vo=
id *it);=0A=
 =0A=
 #define SEMMSL_FAST	256 /* 512 bytes on stack */=0A=
 #define SEMOPM_FAST	64  /* ~ 372 bytes on stack */=0A=
+#define SEMOPM_NOACCOUNT	1000 /* ~ 2 pages for struct sembuf */=0A=
 =0A=
 /*=0A=
  * Switching from the mode suitable for simple ops=0A=
@@ -2234,7 +2235,10 @@ static long do_semtimedop(int semid, struct sembuf _=
_user *tsops,=0A=
 		return -EINVAL;=0A=
 =0A=
 	if (nsops > SEMOPM_FAST) {=0A=
-		sops =3D kvmalloc_objs(*sops, nsops);=0A=
+		gfp_t gfp =3D nsops > SEMOPM_NOACCOUNT ?=0A=
+			GFP_KERNEL_ACCOUNT : GFP_KERNEL;=0A=
+=0A=
+		sops =3D kvmalloc_objs(*sops, nsops, gfp);=0A=
 		if (sops =3D=3D NULL)=0A=
 			return -ENOMEM;=0A=
 	}=0A=
-- =0A=
2.43.0=0A=
=0A=
