Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022127.outbound.protection.outlook.com [52.101.48.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8203B2D14;
	Wed, 23 Sep 2026 17:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.127
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790185376; cv=fail; b=FDaxNT3w26WkQbuE69vOBu6c0t90GXKdHZxHJwi9TfB2n8ca/fshOr78sRHi/3JC4Le6yV/szzuKv7BJPNxGdam6J1+8En/XJo5N2O9Nz4pNOo4DZS2+PUHd8kKyQhKvR5sIcKYTP6FxwEfY2Vyt3eHIRgFvQ2SsEQv3tPUhhSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790185376; c=relaxed/simple;
	bh=vhd488LrxN3h7wyb7hXsw6U7Jo5LfgVIRQ30TKqdN2U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hs4AO+LGJixqECwzzEYYFgvnQXjdZ4DZWNqUeV3JA7MXQdZTV0yHzVVX4pkkvyCZ89eR48TkwFLyUfFeeWmH7Ub8DoNLG+zn7H6Xsb8OH9cUAhNB/l+icqnzWjt6a0vs2zFjtysjOWO464NoukPIN2Z1eJ3igaY5DN/KCQZSe6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=fhoLWvEN; arc=fail smtp.client-ip=52.101.48.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="fhoLWvEN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EHLuSVHjJKmTU1JpjmwBo6SX1PKzljhLtzbfAgIvoeKTcnk1B6ZkOh8zDvGMvFF9kn2I12zsg5PFu8d1w8+oKaqBsvSao22H5B2HWwf2GyAzbj4+GbMABBsZaUSvuJ2SivHtf+6d4/nzqXBMVgM14aJzJb2xo9A3k59jm7xL9kjJKNkfEGEKsR0ykZJpk2iDgJOmUsKD6Hw7a1g3QjwBMBy+a5RvIL6A80wo8pHgncHhakd15v4Qs1GC2Ix6RvKr0FmXjH7BhKlqVWt14akIAp/AddwAalNzSaAEZ+YD0JDhsGZuMThq9E5AQVdchkSbVwOYoSKezp/ougUIqy/Sng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vhd488LrxN3h7wyb7hXsw6U7Jo5LfgVIRQ30TKqdN2U=;
 b=XHpGcrGGFU12ZVI6QDIUgRLjH2Z5W+ONcI4krHzl2DhSp0Tsqpu+1Sv4cKr7R7MXGxwBUMups4TxGHNr2fLg7kZbkjBJ7AK5+JHwVms/beG+HTHBYPhJReyJ7HFnRBm8rgzBJI4zXbJR+R0uNSHMoCyvnYJzhSMIvkmhfvBrDzy+m3LnAeX0U9NmWio4PMASX+p+2k2ekvmBbND2JFwirjDHbL7q/Jn8GWcNjzMlbkdlQM5bTlomKwFrSknFfEee4FwGrE45MBzZH4IQAgCfQVgssa6+UZ6BGI7kwiy+pJ+o5Lp/hvYz7GUXRVqmM6eVe4js/1eew5vet1qOXIVhcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhd488LrxN3h7wyb7hXsw6U7Jo5LfgVIRQ30TKqdN2U=;
 b=fhoLWvENDyyaYeC3GOhxS9fF1ESvOe8fF6b7fjntA4z4OdPCTdBGUAbOwFfQyJTuVpoUtZaJB2gQj8Yu58/Adgb8k/GfJNkfV2qBZaoLWDEG0qhvGPdWjbC5z5WoR7D44+jxcBtcEHYezWi4GowgbTieTWCjskWc9jICg6b/LxZnXmwtHh/A6V9vidhlt/f9rz2845Uq1tRFFL0u8MQ2v9pQjVkl1GuP6yqH+rQbh9VoOLkMRQLYH/qXzBxITdCVueF18QGMpzrwhudM+EZtnjfBZdlQA2qxLC4VZfNvrWrpE254cU25L5JatuglxHr/zUU5dZf7HErnMgKO9BZxGQ==
Received: from LV8PR04MB9006.namprd04.prod.outlook.com (2603:10b6:408:186::11)
 by LV2PR04MB994231.namprd04.prod.outlook.com (2603:10b6:408:41a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 17:42:52 +0000
Received: from LV8PR04MB9006.namprd04.prod.outlook.com
 ([fe80::3e2f:2514:159c:85b2]) by LV8PR04MB9006.namprd04.prod.outlook.com
 ([fe80::3e2f:2514:159c:85b2%3]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 17:42:52 +0000
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
Subject: RE: [PATCH v5 00/19] crypto: cmh - add Rambus CryptoManager Hub
 driver
Thread-Topic: [PATCH v5 00/19] crypto: cmh - add Rambus CryptoManager Hub
 driver
Thread-Index: AQHdRvg424EW0KLhSEqDYKZZxF3uXLbbsHSAgADHPeA=
Date: Wed, 23 Sep 2026 17:42:51 +0000
Message-ID:
 <LV8PR04MB9006E60F2527002AF2B2F42BD7822@LV8PR04MB9006.namprd04.prod.outlook.com>
References: <20260917225929.2494111-1-aousherovitch@rambus.com>
 <arNoPcxJqrE7BwK9@gondor.apana.org.au>
In-Reply-To: <arNoPcxJqrE7BwK9@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB9006:EE_|LV2PR04MB994231:EE_
x-ms-office365-filtering-correlation-id: c582dab9-6a8e-460c-c97e-08df199a1799
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|10067099003|11063799006|22082099003|18002099003|56012099006|4143699003|38070700021;
x-microsoft-antispam-message-info:
 0xf2NhohMc5s+hBeuREXD2dD2kshaB9WtNJNoJd2BNNJvx63KEPDOL1htgFXEA3n1Moxz6DkYdsZHAqlXGyFLGTUNbJSsWSxs/mLkiLxgupZnFQK6OR5Ak+MFXRI7nn2GtGGYCSAsdrbQ9To0wFMD7MxHNpJ5WI9bYX9Z5utmpchH5hILM4if0Os2XOfZz5xiAbjdyPRpafiCG74qz6A/88f2aXGmpQqXYBYO0ON48v3RVF9d3asXIGezdJd+ZX3BUL7yFXm/lq4lrnpJHup4gNnqKymtPxYPcpRY4CuTvfkdfB160ISRA2zvPpExGXZo+zOd0HNU0dOInjN+t8AU4qqkGoJl3QA5op1faWAqJfE/UlLiqf+/SVDAJMihcILs3sJDLXHihTmPhsb/+mp/klV04YPMpC8zdOMMKRFhWL8j40PvEbwwHSjPWZ7JNEdUSC0iYzlaKb8kxEGCllrQrbBn0/rXs/vJ2TnM4PITR26Bm0UV4jq2sedGXtiaSZAefdkAospXQMvyfuKxJMTdnbnR6jzIov2ZWjsAteC30jkNxaBfcmQ/mGZBG9NVlp/67CWyLDCqoNQslS53J4twD6FMZwfmlT0yJGsu+euRa1qUHzH51AEHnVs7VL+DyfNZB3SYePHy9h/BIdOMH45OXIgn7SjCbhggKXj4BzizL4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB9006.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(10067099003)(11063799006)(22082099003)(18002099003)(56012099006)(4143699003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?s2qDllrrr09iV05TSFz9lSA/NxVB4uzqAcZHa8lUFexnajkhRJCgXtcn8uYv?=
 =?us-ascii?Q?oTOTaRsbtNgsXgLpEO0018jcvnN2hX6QiUiV7YW0YPFcHU4z40+ncBrtjO/K?=
 =?us-ascii?Q?ue8Ehyrqh4V5Isw+bF8qDFJp4rDUZaulvPLLS+fkNgdegExRgRIE57xD/F9w?=
 =?us-ascii?Q?/4S64Lvb03hY8CbhC9mmv20ek2R6/YJMn86VPr/IEhkfrtZ5BYrrD3hbYtTt?=
 =?us-ascii?Q?FcfJ2qv/BHExrfjQYu7dcZy3wnPwkM7+wFP30Lx/hKpXeHmG1ecsO+GV/tNJ?=
 =?us-ascii?Q?42XYovDf//2+ve2TEdhBnXeFaXYdPtgcJ1LYW8FkD1O1e4ilhZyHt219Kl41?=
 =?us-ascii?Q?YhFfvzSX1cytyPsx5TXlPoyF6bYXqd+vrsfKr3Pm+IiGQy+iwUf4kRozSynC?=
 =?us-ascii?Q?Sr40/m9dcOICYaQjhsfTf4zWdaytyW2usp4yOurPI9JMg5p6z8FtojH42jNf?=
 =?us-ascii?Q?7qqkUxpsPyW+VSfr4c9Hqf+vwHhvnvW+VBuoHR4SXrDx69cO7rgp7p1ZWtjA?=
 =?us-ascii?Q?1rQXWw2ClYo5nTQx7WIdYh19KLx7x16Ht5jDiIxs24LuRmX6uegBMapXuwX4?=
 =?us-ascii?Q?E8fHoA5sQel3YrSg0tXFTU0PkEpTCeON31lH+p+9asGPbEjQvKXscMl2Sfil?=
 =?us-ascii?Q?pstXvzOWFPoKBSiAXFYM7mpzgNMqVT7RphPETZDmxYIPWDk4aZz1IY3hdv/S?=
 =?us-ascii?Q?Mj3JEqjKCF8+sYHOQVc/KVaK8rCxfjeYHtvAJDeui0r1MYE0E/S8OJV5iB/b?=
 =?us-ascii?Q?776gJTc1RiqGN3BcOY+OuW8xI1tIL5QZvMyoPybB3vPX7+Ug7AYggkfTyTNc?=
 =?us-ascii?Q?ArDauicuhFr+Jl8Xi2AWUAy648Q9SW6+aEimtGZsAMCWiSUGKvXSnVJPfvX1?=
 =?us-ascii?Q?bJoeLYqS16r3zaYndz1pkbeC8EL1DESvPLvkz/kTJiibrUW7JrcMdVhyNNex?=
 =?us-ascii?Q?51Uxlfw0gz0toUsQb4m/SHXEGfAbwg5smn8DQhXMDWEFrlx6AaORn54am5IF?=
 =?us-ascii?Q?Hofe/vmPFqPgQqVHD+7ZM15bAMa2TrFEEYCDI7+GRgT8z49oyehEMHVlISGs?=
 =?us-ascii?Q?oULrOaAkc6SjsCRJWiF80h8lNr0CXdfi5UjvMcIgzmVNS6V3M57QMWQGovwi?=
 =?us-ascii?Q?y68pXWU95UCJKxYsaUd/CzjNkAv30ro1UpcXxx1wytXMtu3XQS3GhiYv+hwR?=
 =?us-ascii?Q?cKknlDD2Rn31ELPhnhbpHKlVuUYGIJ1xrif9ZWGTW8EsqIPByDJvc6cxdfRB?=
 =?us-ascii?Q?/faoOuOq0y8LTh23E5wbVBda8sRQk8CJ4dLwVawUktcifpKGi5Nzj6WU/dYL?=
 =?us-ascii?Q?fUCEARuuorkzSunMfeoCguFIrWWM6QI3lx5Em4nmyRtleATWzIvaJClOpYHI?=
 =?us-ascii?Q?zSFe12xqK1zeNT16j1lF6NzlDWhMLKDwQTntnhvSsKxxIzGhKqDaL6E58uLz?=
 =?us-ascii?Q?3dwz8P9WelqM/IEhFQLPC8soDs2d65tvPmtZqi/ETxXH3ZPdBwvhk5AlQz6k?=
 =?us-ascii?Q?dmubd/fs8RWOTSZoPPh9YDSKjEBGNQ9F7DkHBZi9+c5w71AO/kpy3ThsHM7o?=
 =?us-ascii?Q?U3HdaoJTlMSbfWJEK7bbXRCKo6NZataZaSAlqwGL0Cqsh+SvOy3tCxfYbDEN?=
 =?us-ascii?Q?PWEPHp36CjGbDRGIYOfm4FtNncqhlaJwAAQYY4A5LwjOBmhWmIT0arctMX+P?=
 =?us-ascii?Q?sGD97FIqngLhgASCqvYnnuhxgps/nSsPnRoBxS9NxmJSE7q4tGTNAINO5Yq1?=
 =?us-ascii?Q?EmbnR9CGLw=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB9006.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c582dab9-6a8e-460c-c97e-08df199a1799
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2026 17:42:52.0950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oxj1wM/mcVF3RTbSKO584bjL2h67ljcjiowW+28D73EU2MC4TXPIqJp8d2m7ryuRxzOfvhO1OM4HJwGbV7gfC9IeJybaBB3EWnjOpJQNTZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR04MB994231

On Wed, Sep 23, 2026 at 03:48:45PM +1000, Herbert Xu wrote:
> Please check the Sashiko review, it is not happy with your patches:
> https://sashiko.dev/#/patchset/20260917225929.2494111-1-aousherovitch%40r=
ambus.com

Thanks, we went through the whole Sashiko list. A number of the findings ar=
e
false positives against this tree -- e.g. the dt-bindings "unsatisfiable
compatible"/"missing example" items are the eip93 idiom Conor asked us to
follow, "kzalloc_obj undefined" is a real slab.h macro, and most of the
"unprivileged AF_ALG OOM" DoS class isn't reachable because AF_ALG bind is
closed for KERN_DRIVER_ONLY|ASYNC algorithms on this kernel.

The substantive ones we did address for the next reroll: the MAC/hash
.import() accounting symmetry (incl. a poly1305 counter underflow), several
DMA-unmap-of-address-0 guards on PQC/KIC error paths, lost-interrupt orderi=
ng
in the ring handler, a wedged-mailbox -EIO path, and the MAC finup
idempotency fixes. A residual class around async-cancel DMA teardown is
called out explicitly rather than papered over. Details will be in the v6
changelog.

Thanks,
Alex
