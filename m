Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020112.outbound.protection.outlook.com [52.101.85.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B72734E745;
	Mon,  5 Oct 2026 17:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791219871; cv=fail; b=EQa4QDjYQ3nhuv40V/gQzaGaIfFiaRQlH6+Zt5+qkdHGWNpc7HdlZD09Jct2G2mdA8VttJvN+OC7IDJRA0LP6Py9vWfMrWd5f9aMrSQjnC+BaRq11TXbyhAxjBnvFZZzigonkfif9woAxikB3IuJccZ55sCNctNQWAV3+scVkTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791219871; c=relaxed/simple;
	bh=rA/my2MlkTmkcIQaE/p1EUxZ6jkvJH4zbOF11QIwWx0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DUAz/Ai1i1f95QdjRF67g3DHuDY4OeyCMFG48s2NKQxDl1XHIkS28RNOmcd0Y+L3Cd9J+/R2/Dgz/+CcFh9LFq26/bfwZlwPquYKxOWYyREkYEG10sLgNnpoTyP830paL0Wx/8s1MVzR+LO7NEn0YibXUIm7xbU5h8UngRlaJ5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=29piLxEb; arc=fail smtp.client-ip=52.101.85.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="29piLxEb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y4k30nW8vlysqOD+tegvpygvvVZ5ewiGyRDv0XqkUBT2O3tys5DRQWoCkHq/QRUtjfjbHItzQplYObMMMKmE7zOA1ni9txx4C9ChfAOQFxjTrxoToE2LsZVkm3rnObL3UAXtHzSj99KEfBcpeJkDF4Oy9JsfHnQyYxhlV5VfgPDWV6+9E9DFTzlwDtJPguaiA2kfe+I/MFEoBS+KKXAlc+kNPW7Ka44n8CaEVpnRFMCKmfC5iw+Gt4qs+g7HN27SwUjkOCbPaFapPLos5kl/Cu1Qu19kkD/SCL4Yw0wnSovM0mc6fZ78MNpeOurI0Sc7FGCVyRyvcjgDEjIs9hZDRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfTWZmLKTZLaPNd0GyMSgq6m1WohaMbyoIjQM3jKHwA=;
 b=rDtNNqPN+JfsTjJCgcZVnTLasj25nE42tteDbJ+WWlzhRvlGZez6/xZLkyUsZi+2rxZxDt08mvhxgCU6sXCB6fAIMtV3/rQ/ZfzhsEHLCm9Qn/Hvw6sKXhJohNHpjAQ1YC44eV3N72Hm04PaHiT5RABgDSJj4Z8Uk9r6EhXhtkszB5TdLr86g+J4i11kuAobJ0K7R4BuaaSxmCOYwiT+1GmJbegDDFAyR+eM56M/2Y6gnkdpz2n5qUIy4haGPlziRNCcFsNRLCaZ8uaeGudHJvC/vPcbteud5Kxc6T8lFz99vFWijnSOTEDYSZb5mqRpx/bBCJGLq7/XQCWQZMSpxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfTWZmLKTZLaPNd0GyMSgq6m1WohaMbyoIjQM3jKHwA=;
 b=29piLxEbZqwhYeNJcabVnsWz1yfUnV/irJiTJBYroCap+vpw9KOmKer0tEsf/5fIfXgTHceqgvEukkPhmhl9e2yDn8dTDiYQHglV17Vv2sODZbv4PQw6UF+2hQSHZaW9lWDunLi0e5mV1N40wIVnqcnEtsILetEiGxpp6uHczGbpbTJ8ZGAnfMqWRadTptZKHn9WgWj5tenya8qT52RrIJsDBb5bRxk8beln//Qa6gfE4pjm93mNbIE9dmEzpioxdMQOO1Zg3XYh5iu2LOC4ztT5qM4GXEG/tlNZlWJNaD4kqcV6Sm1ao3tuOnqlJUF32hHTLW6PehZSEOdDU+hOnA==
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com (2603:10b6:a03:3d3::14)
 by BN0PR04MB8032.namprd04.prod.outlook.com (2603:10b6:408:15b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 17:04:25 +0000
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf]) by SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf%6]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 17:04:25 +0000
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
Subject: RE: [PATCH v5 04/19] crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
Thread-Topic: [PATCH v5 04/19] crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
Thread-Index: AQHdRvg30t1+45dAjEm+KmT5OENVbLbbsCeAgAD8JwCABtcDgIALxW1Q
Date: Mon, 5 Oct 2026 17:04:25 +0000
Message-ID:
 <SJ0PR04MB8406AD1C92438FBCBA2EEED4D7962@SJ0PR04MB8406.namprd04.prod.outlook.com>
References: <20260917225929.2494111-1-aousherovitch@rambus.com>
 <20260917225929.2494111-5-aousherovitch@rambus.com>
 <arNn_fjy4jamSitO@gondor.apana.org.au>
 <LV8PR04MB9006374FD8621EBF3C7E7F6CD7822@LV8PR04MB9006.namprd04.prod.outlook.com>
 <arn4XYwPYt6i2k7d@gondor.apana.org.au>
In-Reply-To: <arn4XYwPYt6i2k7d@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.11.2.117
dlp-reaction: no-action
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=rambus.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB8406:EE_|BN0PR04MB8032:EE_
x-ms-office365-filtering-correlation-id: 529269b6-74ea-4048-1c33-08df2302b574
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|366016|18002099003|22082099003|10067099003|3023799007|38070700021|4143699003|56012099006|11063799006;
x-microsoft-antispam-message-info:
 3Zjv3WHoOvXtirZW77/U4Z6YT4qYclr7DPlqLQ6x6YZC32CU6IMzjSC/OcJMtmISJo80VDfI3PNbUeS/0yxHMtdVrVzd9Sv3XNT6tiT6iIeNyLwFtZcJQ52wycbmU1P5UU8ph6dSB5dvCOuO8iU+WIowfORnFZfFtyqGEeDvl/NXOmkpy4epgAul0qjxnnMPb2X8ESkS/lWqqYCC9tBaetuoi9RYxnZb2csQwP/L6z1KLTwPYtLKJJEy8vDO3nZmBJRK90XpbfjYxjdiG6y9yI+FaJfZWH3ZXJ7EDYbL/HI0vUJIFaNNh1I8uC70CDzV+oZxQpndislsYMuZy56fWvWRUMGze/T/QBdPg9TQQIX6zPJp9MHlxA+zhrr8GnvIUI/Es6t6sKqn6pNhj+Him5qcm/OeqV7jEmJki2/vXmmLhsmc31ktKUWg6SpLF/q5xmJ3SHlAak3hHAFIzcwC2RjlpRLgSL60X0Ww9bqCBPwlFqI7cb7mgRl+uNpNdWxK0kvrWpVR4vvRSDi0yjntm9LIZYI/qRELwYnRgTEvBT47g+6bCKWX3LKxy92uA5s/UxM8HlI6TJqj2Bq/D2qDPjuJk51Qsk2k6vYMdTqh65ezTPNZup8mXpz89QJCD2QnjwXehsVp4IT2i1WISbPSrxjSz+WlIPq82F8B9Fs5kry6CaLz+A15DZz2hMtgHemJKwF8gJV7hxKmHVgRdqbs5b/HYRw/jGxzVqiOjJunO1E=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB8406.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(366016)(18002099003)(22082099003)(10067099003)(3023799007)(38070700021)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?8OT9OS4Vm83hSkCYv2nySyx91k13fmMk6z+WvaR2QJJvRs3qNJ9jnNBQ1VFB?=
 =?us-ascii?Q?c5j+4VZp5C07UFF4hWYucq9RT9nHX5Z6BTzN/hnaAomUT4y1vq33eYqUkNDP?=
 =?us-ascii?Q?lv/aHAVSt+2qwiTjj2qVu/PrrAd0a+3u7VbSLLo3rZdZ+q44v6OsDgmxy7Jq?=
 =?us-ascii?Q?YCXM/QPANs0mSd4E21IRsXnYnoyePEgogHlDbujS4qB4waTXhA24qJmN2Xhl?=
 =?us-ascii?Q?Pd+Dn2c7eB5IXTdmSawPz4GbzWz+rwcKBnVDSM1azCNeaYcqrfBnVb/tQ038?=
 =?us-ascii?Q?RUYUplC0XUsFQpD8E51oVnYqj+W6BcYbZQ9LUF4P/cHZvxu7lwWFddrVOEDP?=
 =?us-ascii?Q?68CcLOzRNFiJHfXVsYUwsIJLpI3eidOeSZfHk5ARTxhX/A7JR85g69vOfpC+?=
 =?us-ascii?Q?d1hqd/ayfwRgFArIJYoGZ1j03wiAaNUlmKHOAKo5Pbk1tfLUy1RboLkDGr7+?=
 =?us-ascii?Q?YX+Y92ZITXByYNWwGvxqumTNcnM8vB9HBiSngi2y/9j9iR0Pkkzqq3YZG+1l?=
 =?us-ascii?Q?Ryq8hGdn8dVXEXBLtHXFYJsJ6tuRzQNSBh5CO7PXgHtCG8Cs2qzt7X3HoFBN?=
 =?us-ascii?Q?5Ag0Fnk74v6uXDCJ1Cq/jrOx5pUdClEQTdFFA8Q5koX0v6H8W9mm/QmcMl/o?=
 =?us-ascii?Q?qlJmHOqct0CnhPVat3CRlIHFnM88rMxq7XwbIAY6WGMCAxOlOkicy1rofgoR?=
 =?us-ascii?Q?e+ADK3k9Z1HdrhQf38ber483C1Vd3jxUrNt9fFH9vsnQkw5ei6F9JhTL3cLT?=
 =?us-ascii?Q?/yQOtRRnJiFV0nI4EhkCtePy1AJelZSMiwuLTdyxjFMpW9Ha5tZLyMgl1CkG?=
 =?us-ascii?Q?ABngTKpn0r9STbw/EYEiKBeD6nbkrLvQ5v8totWjbwR9R633vlWspn/9iEU0?=
 =?us-ascii?Q?wOAD685KHKL5QWJgxS1RlFMlmjn/AW1nbJbXTCNNuUo9VuwtQmJHqxTJ1ULg?=
 =?us-ascii?Q?1X31s2TdgEIh7Ojv37QJnvRFUHvEPj3haiUyLVvs/MvkjXBzqzVBs6T00Jdc?=
 =?us-ascii?Q?d9tXGdsx5vfisZKHHsFKkYXHYQWEoCjcqqCmE2URPdC14KNEVPVFjmYeCk+Q?=
 =?us-ascii?Q?JJMT4rcVlVf4jlf8zQyOnOS9KlfGOmiuTl1JCMcqRBJtrlNiz+LpryduOOzd?=
 =?us-ascii?Q?hF2UqknnFYG2Xqod3r86RbpGR3Yff230bu4Rtl+yk51ex3Yedcp6aQN3UR+4?=
 =?us-ascii?Q?6K65erILpQ4tmf0FSexKnXexp2XrCZKmT0IDXLzqgRpImAw03mF851E0Mn5F?=
 =?us-ascii?Q?togqXDAuUGjiwz1qe4yS5V5Q9as6ODhQ7sOToVtpt248X0Z+CMdpgulNpZxq?=
 =?us-ascii?Q?Bh04DQoMS9FXS1JCwbYRftiLFDBc+1lY+iDxhOhtouO2deOXC62tD11Png24?=
 =?us-ascii?Q?skhimaE+XVBG4P51RhdGYxNN+oH+ujWmoGE1lFoRI08bJDdhAimR4GSCGVuX?=
 =?us-ascii?Q?YoINieIUa6O081k/Q9QcBHcIgO0C9yisqYBCisuWysIXmvOEPUojI2xaPe/E?=
 =?us-ascii?Q?g9BFAqamdWMvis6eAQLYsB6KHJTgEjn0vD9i5u2WAViDdOkVsMdAHKdMtarG?=
 =?us-ascii?Q?rFJz5zbw3w/57FAD6dCYzQIwQsqNk3lHFm0kIKLS5uEfiJlCGheC/CI+u+Nv?=
 =?us-ascii?Q?SnwD0pdbr2OCAyns65tAJFePMyL0PXbaBv2mhWtQRdey7zbykvfF2Aa3bDhI?=
 =?us-ascii?Q?+DJGi2IYaSLbaHRoR2SQKxYt2VL/mVqFgBDRIL9mWzVYeb0WFzL8XHgk7h9O?=
 =?us-ascii?Q?HqZm5aVmaA=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB8406.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 529269b6-74ea-4048-1c33-08df2302b574
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2026 17:04:25.0666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HYjXi+pDqBRb0M4Po1Ei3IkjOSxMUIv7Hndm2wtJ3ix2G+tP/OF+hB4eNeWnz/mKdl38rov643pAqx3qOS6YTjho67cYzYUW++nNL4N/qXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8032

On Mon, Sep 28, 2026 at 03:17:17PM +1000, Herbert Xu wrote:
> Hang on, if an algorithm isn't even implemented in generic C for
> the Crypto API, then it should not be implemented by a driver
> either.
>
> The reason these algorithms aren't in the Crypto API is because
> they have no users.
>
> So please drop them.

Understood.  v6 drops SHAKE-128/256, cSHAKE-128/256, KMAC-128/256 and
the standalone Poly1305.

> Sorry, that is not supported by our API.  If you cannot export the
> hash state in a compatible format, then you will have to switch over
> to fallbacks and only support digest operations.

Will do.  For the algorithms that have a generic provider -- SHA-2,
SHA-3, SM3, HMAC(SHA-2/SHA-3), CMAC(AES), CMAC(SM4) and XCBC(SM4) --
v6 switches to the fallback/digest-only model:

  - drop the NO_FALLBACK / BLOCK_ONLY / REQ_VIRT flags and the
    hand-rolled partial-block and fallback handling, and let the Crypto
    API install the generic fallback;
  - hardware-accelerate .digest() only;
  - route everything else -- .init()/.update()/.final()/.finup()/
    .export()/.import(), and .setkey() for the keyed ones -- through the
    fallback, so the statesize and the exported state are the generic
    ones.

That also answers your NO_FALLBACK question: the flag is gone.

> Please also elaborate what you mean by opaque checkpoint, does it
> contain the entire hash state or not?

It holds everything needed to resume, but not in a portable layout.  The
SAVE output is a fixed-size hardware container (600 bytes worst case)
holding the core's internal state, the buffered partial block, the block
counters, the mode and a CRC.  The state portion varies by algorithm:

  - SHA-3/SHAKE: the 200-byte Keccak state is stored as two shares (the
    core is DPA/side-channel protected), so it is not the canonical
    state.
  - SHA-2: a single 64-byte register block plus the partial block and
    byte count, in a hardware-internal layout.
  - Keyed SHA-3 HMAC state cannot be saved by the hardware at all.

None of these is the canonical export format the API needs, so the
fallback/digest-only model above is the right fit and we are not pursuing
incremental hashing upstream.

One process question, if you don't mind: we would like to fold as much as
possible into v6 rather than spinning several revisions.  Have you had a
chance to look at the rest of the series, or should we expect further
comments on the remaining patches?  No rush at all -- it would just help
us decide whether to post v6 now or hold it until the rest of your
feedback has landed.

Thanks for the review.

Alex
