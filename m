Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022136.outbound.protection.outlook.com [52.101.53.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB64379989;
	Mon,  5 Oct 2026 22:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791239513; cv=fail; b=F115h85/AX5a4fDcpNgUVcUCnRcLJ37SEkDix8DQVWFc/5z5xXFIXPfVOXOPFeRLJpod3YZR4I1iJffZkR04vajVuJhCSlXX9sscGoODAwojX+G6iz9NEc4FyCQfll9oLxGGMbeaaO7gn4fpaxW+YnduNUMNtpzyMbCnP8kmSBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791239513; c=relaxed/simple;
	bh=PVN3umst0Rw2d4SEwZY3HfL/KOd2tpzdlA2kNGw9e2c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OlKHMNPbEoOQ2sgXxsPRYnxJc4IQ20llJw4+D/TaxU/+7kCMX537c0fyh2J81zNRBnq8U/6Ugo4EVy8by8RPpYyJkVdCA5RSlc7j4UtY7JXUtK33RPulLLECBFwExu750LN3HKpgOPdSBM2X3Iecjj0QlB48f+xkQgciKs9Aafw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=OX3TLdVv; arc=fail smtp.client-ip=52.101.53.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="OX3TLdVv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HxFPXHscYxmZ8R+rYOV+nIkwrOUQbpFIzCataMoFj6dmTLJHWa4KnXAO+B7noPVAS4SLLmJzIEA50p9ECHCZ5qaUZv1ZjZcCmuYu4Q/K4BFLm5r9v+VTmYz+ajLZxqz7YJTo6NmYAsUF/SokBA+5s01Kr9XcF2RKXkrBi1JM8lO1XAABkpLvxDE49Iv12vKiaQ6KMCQkKURMQtPGDiJe/v1ueyswvM2f/7LeCOSE0TtSPRH47WKrltQYBMh5Mm00zXubkttWI1Bv2UnTRKSd5hMNJFfaNHHDMKcjHVwwRdZVcTuuj4yC7pitH60V2fMBfunfqwTYxcXhSNvQmSh+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zp372sNjXdidVU9eMo0mHBVsk7vgC9G0xeMWn4WauXk=;
 b=IPCW+yiZb+11JLV0LUOkT1KOzz23SSfKvv9//ZVT5aC7/PzrPB1RrvZT/Y5cKOQz7sXEoZksgvgwAxP7CDmdAjpIWYjCHPjsjNMIBCBxBYIhRqahMXG+Bn6NkYF9g8EOmXe+v51CmFZbNNVa2RE/zPCwM7YpRpBGkwj2rWfWdud84WLJFlIf5thTTVntmDWKgofPqciYaqhSPlovx9yOVL5yKZdaG9fJfHrm2MfoOuBtjYdGtIAF7InKyYC1L0Oxd9Hga6qoPIaWorBE/vLXi+0AUOm8KR9C6+9fLoLeuzMBuse95DyCJXSvyzXRorJSW8prz24VAXAul20KOsT8Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rambus.com; dmarc=pass action=none header.from=rambus.com;
 dkim=pass header.d=rambus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zp372sNjXdidVU9eMo0mHBVsk7vgC9G0xeMWn4WauXk=;
 b=OX3TLdVvWRufn//0bBJfCFYduWz9OXzdDo5BD+v/OX/DOnBAZvJEFZ7JAfi9mwQgykDUMHfQaBVxToikqs8JhXRv54dDiQ3KngZms5Ts/Yhp0sbPZiG7lX8U7jmyaxNLK33r60B6wcfzH0QojulW4jMZX32aI4mHGC8/M+/MszasF0zBbuPd6IMVSep6vVHN1AYwKaDnw5jyKGhatvUttv4JU6OC3p/TnU26Ar0I/r7ejpb+3pXET0ttt60TvxjpAS90UHrPcIBwF0/E3SKARQn/1XL8liMuMGyAO+/gDoO3JtLUvJPhkgpZ0FQ/QCdqNHNQx7zEWSFi+PUhh/npbw==
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com (2603:10b6:a03:3d3::14)
 by MN2PR04MB6720.namprd04.prod.outlook.com (2603:10b6:208:1e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 22:31:47 +0000
Received: from SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf]) by SJ0PR04MB8406.namprd04.prod.outlook.com
 ([fe80::cbad:dfcc:82:7dbf%6]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 22:31:42 +0000
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
Thread-Index: AQHdRvg30t1+45dAjEm+KmT5OENVbLbbsCeAgAD8JwCABtcDgIALxW1QgABRobA=
Date: Mon, 5 Oct 2026 22:31:41 +0000
Message-ID:
 <SJ0PR04MB8406E66A05FB81AB900D96DED7962@SJ0PR04MB8406.namprd04.prod.outlook.com>
References: <20260917225929.2494111-1-aousherovitch@rambus.com>
 <20260917225929.2494111-5-aousherovitch@rambus.com>
 <arNn_fjy4jamSitO@gondor.apana.org.au>
 <LV8PR04MB9006374FD8621EBF3C7E7F6CD7822@LV8PR04MB9006.namprd04.prod.outlook.com>
 <arn4XYwPYt6i2k7d@gondor.apana.org.au>
 <SJ0PR04MB8406AD1C92438FBCBA2EEED4D7962@SJ0PR04MB8406.namprd04.prod.outlook.com>
In-Reply-To:
 <SJ0PR04MB8406AD1C92438FBCBA2EEED4D7962@SJ0PR04MB8406.namprd04.prod.outlook.com>
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
x-ms-traffictypediagnostic: SJ0PR04MB8406:EE_|MN2PR04MB6720:EE_
x-ms-office365-filtering-correlation-id: 588f49d5-232d-4c1c-dbed-08df23306df1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|10067099003|11063799006|56012099006|4143699003|38070700021|18002099003|22082099003;
x-microsoft-antispam-message-info:
 DWnQTEH6V76rfTSyMJD++wvwzvzEroH/ucQvHaXdDkplnbI7/7gPtPJlITtQchKtxsufffgTV34SQnR+4yB5/ixgF0V9O45pf7IqjXuPs0MRxl73vndkVY45Jv2qEXy3M68xH3lcfX95E5VLnsFzhlDL9ax+lHaB/kN48DyEbrNy4uF0WXqhj8dHRR48DiZuArLBfA+m21sI5V/INYXv4PizvOW2bwigsRnAPwuSzCV05cjP0Yf+KuAbNhTelv8ZBh+zzo5HfKEqPZCxBfYPmQkz92JPihIHrbs6fgIKpjm5qf1sbM5fK0zVznI+7qRrVdEEzMR8WdFHOIJn3FuJq9QQkZn1rqab0flK5IdPEDJd2E6gzIAMSdi3THm4i3ZRR4GRnEnq3HHSpA7WJ7mr2xoOMu2qo6jSBeXR6EReNmvypRrOAs822rDi8gDcHGgu6cTUrLB4Susw+nOU21HXcjhFPFptom+BiR5u5kVSbG5Wtz9pM/f6kAoJaV18kiN6ZyBiGcHWg5ur8aiWjgs79FyG1Ia5Q7Xp5uiWnTVMPggorGYtjvMFwEKEc47MV/lAGbpvA+qgHNmnxQV2heP33uo2islXAD97SnFXcjC3MsClVcxP0yV0yLOqpL6H15LiF3oZ6I4LrJdhbUbRWVWAcTT4e0Xcles7bYFLJ473o9Xu0JHG2kfO7/CtWX/XdHs0K8wulsr3sWwCvliGWfT7uok+lbM5oNsfzSYoZ6zKFhE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB8406.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(10067099003)(11063799006)(56012099006)(4143699003)(38070700021)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?TerZ6HYXu8DFbOgcaQQewsTjLy5j9Lbf46JT5Utwgxce392k8Z4x+UHBUPwO?=
 =?us-ascii?Q?BrRJLYGjojKwRRCSQlBlRNGo35auZzxplxUTPLGr1LyhXb8QTjBfmdfKR6jf?=
 =?us-ascii?Q?7iA+w6zR3rC05xUMW6MTIDUuuLwdwByQ/xRjJBWpbrj0epRzOoU+A2lpCWtz?=
 =?us-ascii?Q?uSunicLL/MVoaiwjj6LWgvVM8+j5/MCEtUqWcgHRXv7pb6pTW0HczRtszEnC?=
 =?us-ascii?Q?xk2naj9U4NemRzWIm1C1y7IZnEOqumUc++iwTpkICMnicTi2xrLEKP7lssEF?=
 =?us-ascii?Q?skX/Jzmlth1H3KsQdhGPZPfEbGAxDq/HgvddIimWt4+bx8J2jHcRdCKsohDX?=
 =?us-ascii?Q?RW3wtWdW59SFMwQyPuJt5Q39R6OX4VHWo2vXc6AbgD5HiSdghzTCX002rY6u?=
 =?us-ascii?Q?5lNcVdnHebSebhLbq4qAv69LmidMSnIp7t0X59AVgiONyVJGq0kPSScJSUmh?=
 =?us-ascii?Q?EAzJdZHFGNoppuk5XD8oFgHdMzUFdy+FxDkZjcO5uiNDvlVW1cuD972OpER6?=
 =?us-ascii?Q?qKJVIQvRCFEGUcLKUfqGgSsNK2tlAR7yaGVROACg8SZNW53WHmWvaNvXe/z6?=
 =?us-ascii?Q?NUvC7GIr5VwHPbwaobMh3N0EWXiL+o0fU1cbkOd2qBuC+eWrWa9phgYtDHw3?=
 =?us-ascii?Q?5fCYv15Rq/4AQg8f6I5z1QgsEiVLlqa/FMFAeHDPAPVGiKljLxZgp3/2Xeso?=
 =?us-ascii?Q?lKT0P+tTnNeFTInObuic23vTKurEOcP3S5h83EEgEwaUDl74qLLNU02HHN8c?=
 =?us-ascii?Q?zDWITZ/W04IUjLBys1DL3OcCe+x1tJJ8TmjPNnpSRSbe0S+rPor0DVDoMpKa?=
 =?us-ascii?Q?H80uqx7AfoJNqPcHhDDBR7A3ithWNSyVkUNsYE+X+jRTMJ/nphuEHW0eKrVq?=
 =?us-ascii?Q?1zGrGPU2T2K0EInu9u3XOKQChAiYiXAjqvrT7lSs7ASrxcibKOcKQDODsPGk?=
 =?us-ascii?Q?g6TshPVJgStUi7u7u8W/bzhi/lYXTfn05oz+3kXHZtwPMoVV2ORjStcgWmAR?=
 =?us-ascii?Q?BdlrdotfJ5t1sqRRhtliXZVEvpnfqnEH7czoCOFAZxjHJFBSJWgYvCgQL1BM?=
 =?us-ascii?Q?dxksu75xpX7nTMmAKXzEPFNpczHE5jMWkI1xtoL/BGQ3SUMCs3z2immjGCiG?=
 =?us-ascii?Q?qHLh7AhJ74xrFVGm19g1HKTa338G0UF9xLvV4wtbsmA75j6JSJE2M9aSbDWD?=
 =?us-ascii?Q?8x/UOcgrd1B1FoKDsKM8uclh5su6KixYYc/59FqwAYAlmO0OqtH4uiUbU3u1?=
 =?us-ascii?Q?avH5QlYjXHJV/p5EQDc7okyzGLqZ9J70UkgTSJ6aIyCxXFHninLDawB3XoYI?=
 =?us-ascii?Q?w3G9EupUQQMM9szDW7zDse4gkdXJC5HOhvbAlY15O3Ck4aQJd/yy04Ls1SdC?=
 =?us-ascii?Q?oFqpicRLdw2I6e8BPbXWLcO6V4rSkg0M69CWlH0yWfxfqhdtH3Ni3Fhz1XQX?=
 =?us-ascii?Q?7Et6g88Avvo5PhhlMZ6K6socwPJJdlcfo20/9R78MK2c7Ed68cFNovvDlxMg?=
 =?us-ascii?Q?3FWGVCgyfS4nTNNw4DUhTwswXX0wjs5DntGr3jWPfUfh+d2b+1CkoJgNAdCL?=
 =?us-ascii?Q?8b+VRgtrKQn5XBjhZrwvcbiTjb7bhPmX8cZsAtqL4QPBodLy6bcQxfna0DAI?=
 =?us-ascii?Q?jrwzDpFtZge+tT82S1Jz8M59SHhoASNLciEkeGTUGu8BjvGCUuKwuiZ1a4Yu?=
 =?us-ascii?Q?aHzKFazVqgiS6FVSdkjEzNHOpWWpiGhh2+ORakTGxqPqBkw/JhQXrBkWsltd?=
 =?us-ascii?Q?HhL2ZQBmRA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 588f49d5-232d-4c1c-dbed-08df23306df1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2026 22:31:41.8873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ejUr0IXvEFwEZJO9zKpJul9ZG7Frtzio1q0Jz2JzxFOthJIHeoLJG+5z00SVppPN0KzM5SweTSnywRV1REjSwb0o/dqcBBNnaagLHIvktfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6720

On Mon, Oct 05, 2026 at 05:04:25PM +0000, Ousherovitch, Alex wrote:
> For the algorithms that have a generic provider -- SHA-2,
> SHA-3, SM3, HMAC(SHA-2/SHA-3), CMAC(AES), CMAC(SM4) and XCBC(SM4) --
> v6 switches to the fallback/digest-only model:
>
>   - drop the NO_FALLBACK / BLOCK_ONLY / REQ_VIRT flags [...]
>
> That also answers your NO_FALLBACK question: the flag is gone.

One correction to the above before I post v6, so it doesn't look like a
quiet regression in the patches: that holds for SHA-2, SHA-3, SM3 and
HMAC, but not for CMAC(AES), CMAC(SM4) and XCBC(SM4) -- those three keep
NO_FALLBACK and REQ_VIRT.

The reason is the generic fallback itself. crypto/cmac.c and
crypto/xcbc.c implement only descsize, with no export_core/import_core,
so the core marks them NO_EXPORT_CORE and crypto_ahash_init_tfm() cannot
wrap them as crypto_ahash_fb() -- that allocation carries the bit in its
mask and fails. For an async digest-only MAC that leaves no choice:
ahash_prepare_alg() forces NEED_FALLBACK unless NO_FALLBACK is set, and
the fallback it would otherwise build is unallocatable here. So these
three set NO_FALLBACK, keep REQ_VIRT, and allocate the same generic
cmac/xcbc transform themselves to service the non-digest paths.

Behaviorally they match the hashes -- hardware .digest() only, with
.init/.update/.final/.export/.import forwarded to the generic transform
(crypto_ahash_fb() where the core provides it, a driver-allocated one for
these three) and the virtual-address path in software; only the flag
differs. HMAC does not hit this because crypto/hmac.c provides
export_core/import_core. BLOCK_ONLY is gone everywhere, as described, and
the rest of that message stands.

If you'd rather these three didn't carry the flag, I can drop cmac(aes),
cmac(sm4) and xcbc(sm4) from the driver instead.

Thanks,
Alex
