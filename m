Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792725546;
	b=DGk/Jzu+AcyNpSr3ktUHLjMZQYEU5Kdr7t+x6asXh6pszEQAvCz40F1kf19QVDbF8tLp
	 7PFenxP4DGblb3VX6Sv+kTTZ7l/lqXb8/+WOUeQcl1T/K9Z7pbWXviYbFNCtbhj0Amudn
	 FFeGxS5qX35aKPu4ZAQmBkIxKSA32+7B3ZVDRlr2/YomGgBnNQ18vTaZmmHqP4o6sDigP
	 gwZbCUABan6I6mmWuebLidVv+Guy+pVt5ao1jI1L4nKf8+UThTCGawnOOZ/41H8YpWAVk
	 q+4/6gsnTFjHo1Ljbw8k9C5e6S4Tb5674/1oxlr3Qr6B4dYIljlqT9pFaEFj2Jpv4vQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792725546;
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
	bh=HAvLrDOw/KD8tKGJG5DYUjyUVfEWJ3N4MoqyKYrJhKg=;
	b=QhpPL3tRYMHA0rszx9icL42r8KOJBon6EpZGIdyCo3ciRYYoEULxNj/wJI+s1KEjlISj
	 EJC5dxlQxiFzYNuRtW/K9yUtzOwX/xNLJ+Dr2nOOLWEFL8JEo90+CMs6KdKeuphUleTgk
	 UpZEZ1DXETrFaVIvbb0Xpyj3KeqANJoge2Q87YeF36JSWdKHiQKiRbucTPCmTVKRkQ1gs
	 1w3CG7cGk1v6+DdqGmyN2Vu8HdtL1UdAb+tO6lA4+xNvVL7EYzzL3M0qeUMd4HDkGlWpt
	 fpOC8eiCliT56OiCZbScGnku+IzZbDWbABB5pp3Iqx3zaTvWdzw+4hs9aZuD7tnY8XQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b="I12/8Yba";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.2
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010002.outbound.protection.outlook.com [52.103.12.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0762D606A32E;
	Fri, 23 Oct 2026 03:19:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0762D606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=I12/8Yba
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HgEvAKyeIVD0BdrMITfQyoIcDOJKC0YJ13agPgyvo1bigHSR1kQBsylmoaAMknu15EBiXUnZpXDkeq1bEqOKn8t6w5hvMT/Bkyi/zWhfwY5+hdHkwotpas+8tTd8lJbI/2yJGfUSYWqGdYslhRnYb3d8t+IJ73xlGzfJk3KLpOXMGqsKUL3HCD/vlEcHlJTWyLAOD4FeLYfQFetPJ/h29t3IULxvIDfU6g9HN7KMFpUEYkuUvPutQZ3IOKJFQPTNEW1s9EjBoTsSr2e1bmOaj9DakFDIyi6Me3ovKdnBNEF7NjAYKl1GsH9cSAcjyErHZQ5dZIZhXxzLq0pKOEWmIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=HAvLrDOw/KD8tKGJG5DYUjyUVfEWJ3N4MoqyKYrJhKg=;
 b=kNHJyODzHeOLJyDy12ir+8jDowWXEu+JisOKYtqxCu5oA3SqijtX85KcTEQn0QnBt9URs1N9yJ5JTnL7Z/XVd3HNW6MG6hNMKTRpj1HSILh6+ZvMesMzAjE4yXQple9/sn60dI9g7ROjUZssii8rIq1suDZ0wmHy/AAtDTIRyfg0YWywK2b+heoZ21fIYh4FjAaRLCooyjMB5o1Oy5CYT/asvBS3FiLPqSoyDgoSYtVVGfrq0hVur4QIl8qXo82SSQONjtPzj3V3XYgc7t2sqmxQgcfNkpUtkR5e1PnmMPv8rJm2pW1hpXKj0xB7+P4O6hclEC+MWXjo2QQG4Mc8Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAvLrDOw/KD8tKGJG5DYUjyUVfEWJ3N4MoqyKYrJhKg=;
 b=I12/8Yba9EFFbG4dIpms1LHVnBs5ae/R5KkKnhyD4LXo+p6rcWSGTVksSMcNIiSDhIPdq+jQaQZxVfJvB9YHX6z6yq6gaXdpvGFUnHaRKXsu4Nxr6XikxVcApjZn4u4qEhANBVC6SsJTpChxYAFFKoxJtmLnJTcxqp8gmHr/dpsJyFm24Kus758gZcGzl9eihFGt93h8GOwbIbaeTZk7xMD51PSYM+rYpqqi2hcnfo7dZoobK4rEoP/dH9cJ3PolDkCXLn/kPmG6uI9DNKal/AMr25RpfwLM0Xxjg8FYTTUBOlWE9xN6a+PExrfGcY3DfgB5OqO2+sg99d01DHN6qA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DS1PR05MB10613.namprd05.prod.outlook.com
 (2603:10b6:8:218::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.18; Fri, 23 Oct
 2026 03:19:03 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.012; Fri, 23 Oct 2026
 03:19:03 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: Andrew Morton <akpm@linux-foundation.org>, Manfred Spraul
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
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 2/3] ipc/sem: reject negative SEMOPM values
Thread-Topic: [PATCH v2 2/3] ipc/sem: reject negative SEMOPM values
Thread-Index: AQHdYp0/oGfigbLUF0qBSGFY6huXEw==
Date: Fri, 23 Oct 2026 03:19:00 +0000
Message-ID:
 <4fc7f5cb6bea186c5266415fcadb7e26c7738a85.1792724953.git.x-professor@outlook.com>
References: <cover.1792724953.git.x-professor@outlook.com>
In-Reply-To: <cover.1792724953.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DS1PR05MB10613:EE_
x-ms-office365-filtering-correlation-id: a9fbed8e-4b80-4895-3415-08df30b463e7
x-microsoft-antispam:
 BCL:0;ARA:14566002|39105399006|22091999003|24121999003|12121999013|15080799012|38102599003|31061999003|22141099003|24021099003|41001999006|4140399003|19110799012|8062599012|8060799015|25010399006|12091999003|1602099012|10035399007|41105399003|40105399003|26121999007|102099032|440099028|4302099013|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?4XMSmRMC90fSuNUyvU5Y9B4cYh/edaSlufX7AFUZx0IYtp0I9v7Db6cScm?=
 =?iso-8859-1?Q?EPT6T+bxI9IORQNzXRGpTaxc9mZ3tlOKOWW1ZvAOXav/lhIaL6pu0YLpgZ?=
 =?iso-8859-1?Q?/bTYxlC05GxL0YEYT2D4SKbz3h5acbX9qqYcRhJ9VwGMYgrxoTArCULJnD?=
 =?iso-8859-1?Q?6DCC95dKJZfgeQ00v6+5Wk4e3fyRxKTPrKdzpaHg1w3wX2l7UBj/0zXwfo?=
 =?iso-8859-1?Q?XIFHYG86wHgFsPfItytpGDJFwWlbPSJWl0c9FqcDrJAapvrmdm62wBZDzB?=
 =?iso-8859-1?Q?CGIU9cf22MAY5EQddWCi7aCJAzv5bajcSK0cM/qLc1syo245ZChWmKWqeq?=
 =?iso-8859-1?Q?GmVHd4d7ucegb1pQoFyJGyQa4OCPY04dcs6hmn4ZTjT4Tkw1CwCgWCsOKq?=
 =?iso-8859-1?Q?caKilJsWzZ4Q1vemSagAJIxVi/3UWxE4PImEgYgaeZNvXWSDAB5nJtQZVr?=
 =?iso-8859-1?Q?QWYKV6S3KbENKSu9MDeA+VSwKcjqbdNe+CR0cwY6k5ho9rKRgjRVrAlHhd?=
 =?iso-8859-1?Q?6JFwvxRNfUVxVhqaIPXh0VaymMJ20jraICaRzUF1hbpxdo2uFE1ictBQQ6?=
 =?iso-8859-1?Q?4cq1v6/oFPG5bwKbp1S3ix9LrTP8QxcWW3QDaddoM0TI8pOqLq7OeGaGoI?=
 =?iso-8859-1?Q?GJOMs2iCxTCnXS7UnJ7QPW7afQQLQzKBvC5QJx5ezDiYWDK0JLfDK3X6gh?=
 =?iso-8859-1?Q?3HXBKFmLTnunFy8s1oEA8OV4dIhCc+KQHiOl2YSGE5YftGiOGRm3SDv2uQ?=
 =?iso-8859-1?Q?hpzW7cgDB8n2s7Jv8uYk1vOHZNGwDtW1MeiiWFIA54S+bjn5OeocBcvwHO?=
 =?iso-8859-1?Q?5dX5TXOPowmIv79wwNYl4Njih8qNgzs8+79+DGo5eNMbfczMPuz/hFmxiC?=
 =?iso-8859-1?Q?KpyCBaNIkoQveAqqDe1ir+yoCGYC5NQ7ywgDGPq8cxbuyx1vDGgeNZLMFp?=
 =?iso-8859-1?Q?y7FYg2msm3ejVLEKKtXDMtYRl1BVR2HWL60yQ/aCoT66eAniQ/yQilYE6v?=
 =?iso-8859-1?Q?y/GqJXMqsfBmP+mbbmk8IK7Ms1GNvtIGicTNSihXjck370jJIZR2Hhnfr0?=
 =?iso-8859-1?Q?YFs7UAZ4FmdcfKWRx0MyWvsveWj5iqqJv9xns0aLnFTdLMHAWKjlxb3+eG?=
 =?iso-8859-1?Q?UFFvFruY/46l+QFgoxrVVb62F979JVBm26JAPhScr1rDd8gaW7dXcBCWeP?=
 =?iso-8859-1?Q?EmSiccSIjnOx82WuRu0nszXlPkdbso910kUtYLtjuK6PYaAxlrD8NTUmhh?=
 =?iso-8859-1?Q?aZBebzXd7lH+LpgY25BficvlEcmKHjXlR8vPBhH5J1uP/1ZA1N2vMwW1VT?=
 =?iso-8859-1?Q?bZFoAXvwwlKbw7rA0GrjAUADAPj/o9xt0NoXHG/j6gE4t/c=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?4jEw4IDCPTliopUrZy2HT2nha8iODFT98rdP4tmO4ovmLr/MW1+VuZJ5SH?=
 =?iso-8859-1?Q?mdgh+s7Rr09iCf4VZVZFlMsPzxP9L96Pjfps1dkF1yCGX0b45s7dzfdTKr?=
 =?iso-8859-1?Q?zD/QLTl7les/OWOnTG4RLbfcZ5zU6RCTShYX55ZEobGcytC7XLHzjaPl12?=
 =?iso-8859-1?Q?DLGmR9I5C84MMFQ/dv4nHpGFhtrRAyqL+m0DIGRW63T7AxXt7+Q8MjDhQ5?=
 =?iso-8859-1?Q?L6M7vemOBU8KQs+0cO09G4EKoFZTOwASmww2HUN2O4/rELBxg3Dr8U8rxu?=
 =?iso-8859-1?Q?P4peKzzZWZlQBSGwJ3Gpc1kzc2oZc5mEsZaPnO/agACBprg1konALMVtyn?=
 =?iso-8859-1?Q?h2Bbph4RpUO8zARzfLrC06MGgy+Bu6+Ycqfa4Pcc3DVkQX/BHsTPHIPlIN?=
 =?iso-8859-1?Q?+GzqdEhPqi2J16z59gxWe1bzrHpk83LYUD1hvQsI8gmGcDo3rtm/9MUX/z?=
 =?iso-8859-1?Q?ZjlTf8XiBouMpn/B3s98GzO6t4fNZjUWUabHvsJNABclMdKm/HfjsR11gF?=
 =?iso-8859-1?Q?ZlrgR3NV4t1tulv1bSop4QXMIDs6rlCs3uUjHm91sJ0ozjBugKopkaTySm?=
 =?iso-8859-1?Q?dVE2y1IwUABM2ndFVUcezs0YMeAJAJt88RJ5xh99Itpkwx0r3omQnns9qU?=
 =?iso-8859-1?Q?m1HuuuoWPSfmHflFoL7inywB7bIUpoSpUCFAstQGEXQR5cwEk8OGlbnkQ/?=
 =?iso-8859-1?Q?5e6hXI6owXFKKO6ZBOT++uhNKq5NoNw0i7EcsDXhh0qS5+dvfh1LHxcEAj?=
 =?iso-8859-1?Q?DA4eSMMDw7XFOdbtbC/2D6eiU6rNCU8DU2hSYnHgDaNJ8c3nisuj+waR7q?=
 =?iso-8859-1?Q?5CuOTr1YqtdNJpXUHLGW6kT8EUh/63aLe+ItFEWR4Rf+fcKd/ji3VO+P35?=
 =?iso-8859-1?Q?UOLFO75SYUa9OsA353wtO40hxV48zpAbyD2FSA4Rg/GGr0P9QzJtz1bBK7?=
 =?iso-8859-1?Q?QgojbOU7yM0wIYkr1xLg+0FFWhIt0X94Sx6o7/JWJ18xaNiKPMoFoJb7sO?=
 =?iso-8859-1?Q?2G+gClgdhthgm6dgXq0IPbJ8sxzGA6pQ+yxJf/knbNf+tUr5vai0C+TIi8?=
 =?iso-8859-1?Q?bZEa9f9Qc63tfwEVBcqv7kQNsQVGL0Mj1oYRuk9ydPoWZWBWBISH/hbBfj?=
 =?iso-8859-1?Q?f6HbmY2eKtf8IrhSVIDhz2cwbRH1yx6JzLOMLLA15Ihk1FH36N0SKTmk6O?=
 =?iso-8859-1?Q?0CI1WyTuU/4rYj2Q3h94uN5CYlqpkjB+qioV2sV8iCj2+eaxsv1Ro8fLNZ?=
 =?iso-8859-1?Q?0G2rgihnXTCfaLGpbE0Z86Z41PR/XIdsfIKegNOD3QWw0BWAiW8QvCGSrJ?=
 =?iso-8859-1?Q?2RV4w0iCUAlyIaQ/5DFVKjmZCxLXoMktAcSsOcX2l+ZYgDSxUBUEzLCPCz?=
 =?iso-8859-1?Q?OWvrqw/SObEuKCfNZCu9CDgtocrP515XqzbmFMoOTkLwYYlGncwnET4A9W?=
 =?iso-8859-1?Q?H3KKymyXVfHZn9Gx?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fbed8e-4b80-4895-3415-08df30b463e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 03:19:00.9940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR05MB10613

The SEMOPM field has been stored as an int while semop() receives an=0A=
unsigned operation count since the beginning of Git history. A negative=0A=
SEMOPM accepted by proc_dointvec() is converted to a large unsigned value=
=0A=
in the comparison, defeating the intended operation-count limit.=0A=
=0A=
Commit 50ec499b9a43 ("sysctl: allow change system v ipc sysctls inside ipc=
=0A=
namespace") made kernel.sem writable by IPC namespace owners without=0A=
capabilities in the initial user namespace.=0A=
=0A=
Parse writes against a temporary copy and validate SEMOPM and SEMMNI=0A=
before changing the live settings. Hold a per-namespace mutex from the=0A=
snapshot through publication so concurrent sysctl writers cannot publish=0A=
stale values for fields they did not supply. Access the live fields with=0A=
READ_ONCE() and WRITE_ONCE(), preserving the per-field access semantics of=
=0A=
proc_dointvec(). Read requests continue to use proc_dointvec() directly.=0A=
=0A=
Failed writes leave the live settings unchanged. Successful partial writes=
=0A=
change only the supplied fields relative to the latest locked snapshot.=0A=
The writer mutex retains the existing per-field visibility for readers.=0A=
=0A=
Keep zero and positive SEMOPM values valid. Zero continues to reject every=
=0A=
non-empty semop() request.=0A=
=0A=
Suggested-by: Andrew Morton <akpm@linux-foundation.org>=0A=
Link: https://lore.kernel.org/r/20261016155905.2a659b7bb7d61f33467a3263@lin=
ux-foundation.org=0A=
Link: https://lore.kernel.org/r/51c93c19-f1dd-455f-8698-6b1ee30eb630@colorf=
ullife.com=0A=
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 include/linux/ipc_namespace.h |  3 +++=0A=
 ipc/ipc_sysctl.c              | 38 ++++++++++++++++++++++++++---------=0A=
 ipc/sem.c                     |  1 +=0A=
 ipc/util.h                    |  7 +++----=0A=
 4 files changed, 36 insertions(+), 13 deletions(-)=0A=
=0A=
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h=
=0A=
index 12faca29bbb9c..c06568ccfca88 100644=0A=
--- a/include/linux/ipc_namespace.h=0A=
+++ b/include/linux/ipc_namespace.h=0A=
@@ -4,6 +4,7 @@=0A=
 =0A=
 #include <linux/err.h>=0A=
 #include <linux/idr.h>=0A=
+#include <linux/mutex.h>=0A=
 #include <linux/rwsem.h>=0A=
 #include <linux/notifier.h>=0A=
 #include <linux/nsproxy.h>=0A=
@@ -31,6 +32,8 @@ struct ipc_ids {=0A=
 struct ipc_namespace {=0A=
 	struct ipc_ids	ids[3];=0A=
 =0A=
+	/* Serialize kernel.sem writers. */=0A=
+	struct mutex	sem_ctls_mutex;=0A=
 	int		sem_ctls[4];=0A=
 	int		used_sems;=0A=
 =0A=
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c=0A=
index d038d944257f6..2a542f838a530 100644=0A=
--- a/ipc/ipc_sysctl.c=0A=
+++ b/ipc/ipc_sysctl.c=0A=
@@ -51,21 +51,41 @@ static int proc_ipc_auto_msgmni(const struct ctl_table =
*table, int write,=0A=
 static int proc_ipc_sem_dointvec(const struct ctl_table *table, int write,=
=0A=
 	void *buffer, size_t *lenp, loff_t *ppos)=0A=
 {=0A=
+	struct ctl_table ipc_table;=0A=
 	struct ipc_namespace *ns =3D=0A=
 		container_of(table->data, struct ipc_namespace, sem_ctls);=0A=
-	int ret, semmni;=0A=
+	int sem_ctls[ARRAY_SIZE(ns->sem_ctls)];=0A=
+	size_t i;=0A=
+	int ret;=0A=
+=0A=
+	if (!write)=0A=
+		return proc_dointvec(table, write, buffer, lenp, ppos);=0A=
 =0A=
-	semmni =3D ns->sem_ctls[3];=0A=
-	ret =3D proc_dointvec(table, write, buffer, lenp, ppos);=0A=
+	mutex_lock(&ns->sem_ctls_mutex);=0A=
+	for (i =3D 0; i < ARRAY_SIZE(sem_ctls); i++)=0A=
+		sem_ctls[i] =3D READ_ONCE(ns->sem_ctls[i]);=0A=
 =0A=
-	if (!ret)=0A=
-		ret =3D sem_check_semmni(ns);=0A=
+	memcpy(&ipc_table, table, sizeof(ipc_table));=0A=
+	ipc_table.data =3D sem_ctls;=0A=
 =0A=
-	/*=0A=
-	 * Reset the semmni value if an error happens.=0A=
-	 */=0A=
+	ret =3D proc_dointvec(&ipc_table, write, buffer, lenp, ppos);=0A=
 	if (ret)=0A=
-		ns->sem_ctls[3] =3D semmni;=0A=
+		goto out_unlock;=0A=
+=0A=
+	if (sem_ctls[2] < 0) {=0A=
+		ret =3D -ERANGE;=0A=
+		goto out_unlock;=0A=
+	}=0A=
+=0A=
+	ret =3D sem_check_semmni(sem_ctls[3]);=0A=
+	if (ret)=0A=
+		goto out_unlock;=0A=
+=0A=
+	for (i =3D 0; i < ARRAY_SIZE(sem_ctls); i++)=0A=
+		WRITE_ONCE(ns->sem_ctls[i], sem_ctls[i]);=0A=
+=0A=
+out_unlock:=0A=
+	mutex_unlock(&ns->sem_ctls_mutex);=0A=
 	return ret;=0A=
 }=0A=
 =0A=
diff --git a/ipc/sem.c b/ipc/sem.c=0A=
index 8c9edecc16076..019a736b79316 100644=0A=
--- a/ipc/sem.c=0A=
+++ b/ipc/sem.c=0A=
@@ -248,6 +248,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, vo=
id *it);=0A=
 =0A=
 void sem_init_ns(struct ipc_namespace *ns)=0A=
 {=0A=
+	mutex_init(&ns->sem_ctls_mutex);=0A=
 	ns->sc_semmsl =3D SEMMSL;=0A=
 	ns->sc_semmns =3D SEMMNS;=0A=
 	ns->sc_semopm =3D SEMOPM;=0A=
diff --git a/ipc/util.h b/ipc/util.h=0A=
index a55d6cebe6d3b..b148b5e15fc6e 100644=0A=
--- a/ipc/util.h=0A=
+++ b/ipc/util.h=0A=
@@ -245,13 +245,12 @@ int ipcget(struct ipc_namespace *ns, struct ipc_ids *=
ids,=0A=
 void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,=0A=
 		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));=0A=
 =0A=
-static inline int sem_check_semmni(struct ipc_namespace *ns) {=0A=
+static inline int sem_check_semmni(int semmni)=0A=
+{=0A=
 	/*=0A=
 	 * Check semmni range [0, ipc_mni]=0A=
-	 * semmni is the last element of sem_ctls[4] array=0A=
 	 */=0A=
-	return ((ns->sem_ctls[3] < 0) || (ns->sem_ctls[3] > ipc_mni))=0A=
-		? -ERANGE : 0;=0A=
+	return semmni < 0 || semmni > ipc_mni ? -ERANGE : 0;=0A=
 }=0A=
 =0A=
 #ifdef CONFIG_COMPAT=0A=
-- =0A=
2.43.0=0A=
=0A=
