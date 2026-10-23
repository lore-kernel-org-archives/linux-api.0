Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.95
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792725543;
	b=dLhsevmqcj2eK6BcMkTAR3tERNCh2FHPV95I8sdT7U25oDRChpOz1K0Ve4XzxLEX+fDr
	 ez18Tc47tcBWlnsqs55RcuixRp4KHQPiRZ668mH69GN1eA3E88hKz9IPwxXfbvpHB+M6N
	 EOA/UWIjCmJCA0QdKdupZ4wxrNs/0V3Vyi7UfgnhFO9o088sfFODCga0ltBKg/pvpRxqx
	 HGkwRoHb2iNYXb7fd+xz3ahcqgUgr4GAGiY0SwByxkor/4ykwm/e+p2d2nhk50fOsEiVg
	 d20rqq1LfNpJXF+3k//cqCyg0NrWr3hjP0ECa/2nUL7And25ZGSX1Bk0W1mi0uvtyTg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792725543;
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
	bh=cOUL/bz2ROtsvNDpZQNOQ8+gwr/lWtawvD0vtG7s10U=;
	b=OQzOW2BfppCt1BMxDTHC1gBbCsY/NazQpy6pa6Lv4QnwIspLcARb5iTcky0ARjDHz7G+
	 s+jdpxI5jtFSzLjI58WPDUJTLbA2lfjg66uoHHgQNRwOS6LFvwVtDoTkxN35cn93k5Elj
	 M553PxvoK3rcEKVHQ/ONE/181B0pFe3zK/RgOR4hQzAJWnC+jdytc3TDyIVWjxB886L4b
	 aOnVT137+5LMsxZV4y1tkDmdEuHLSeoAo5kVuZVIdLqYEZ4VrSgWM72+zcrhheyq0Dl9X
	 AZwMckjPqCkC5r6RR2sHlkYo4paaQJ9UBA9nqFh1EonMY/jhrnGiW1mDokXLOdgOlvA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=lolW+Tvs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.95
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19011095.outbound.protection.outlook.com [52.103.23.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE11606A31A;
	Fri, 23 Oct 2026 03:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FE11606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=lolW+Tvs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KuGmSblIB/DYsKhWb+qmn8q2CJWGd0UihcGWzOr5DCksAv2D66AKO5U0OvrvSUsPxb485w9D91x71auMdvSwHy+wWlgutY1+auE+IEUr6V+jBxuBNXO6mfoxKlcXqNHt/QBgW0qmoHaj1UkPZUG69jZY9U4A9yDoGpS6S4VYMcBcNsG0Wpi5OhTVUh0LuPIUowxbsbhscUNgI4kCNJr1uooDrl2cG8eguaaAbUeKtQZKKGsK7vhUmt0Io9BOjMVQPKOXHS1f6mgIpVynRCwK4TNd9GCVyT/v4tkjvJ1d5v6cEXUznsSELW5UkasH/Gd5waFppKcQJil6dZVwF+x9Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=cOUL/bz2ROtsvNDpZQNOQ8+gwr/lWtawvD0vtG7s10U=;
 b=Yi58CrRX7pUm9cjLc4W5WaPzuGFFDW4JYgnzpA7t4gzqGc9Hoj0WiOO/iJsHiXyvQCK/oX+5bGxO6P++Xnbo0YMcAILstI6PFh+ZWcmuNnOXdA9WDLevzRf4MjTtHL3aCaw73ZaHN9IjBWrhB3RYS5sluDhgAb1OoC5UFsl++7x99fyoldHYvPnJENLicK6Yb0AtY1nM55f61c9kF4K2bMGsh1Wp+PDcI+Q/smxaW570Cdx7jtQ3g9NhtatzyTLOlW989QD97GI/qyyYxLeWuXh8HCNULHc7rp08CiFkyo10UVOj1RipyhiWPtxqHkbLsA3uFDxnvpqJgA4cTXOuPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOUL/bz2ROtsvNDpZQNOQ8+gwr/lWtawvD0vtG7s10U=;
 b=lolW+Tvs0F5ldAjqI4b/b7LXlDgdASaKZiOaVMvnO6AjMf13pF9ctxMlCV8ClNqCW4FnXgCX8aVEzJlpzpdtxAmempOEhe8Wy3Vn6Iz7kSgWTbZD3rGwhjBjuq7l0cFi2TlUwy+Uv57P/CegyCUjrcTEJxo4/lYkq/nMC4gqNX63yQaEqTCD3Xg7aFb5TX9vjwHKLma1GV8zIK6TpVnDgb06HM1q1952qLZ0kf43T1uva6D4TsxX2udRaE4laEtUjo5BvI8yJRR/Gb5dibHlwiexOW4L9LgR9ovdVyqUOqVTahGnpIuiKD5gClYB9MTa3oyhn3G5mCW3zXYe7TZD6Q==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DS1PR05MB10613.namprd05.prod.outlook.com
 (2603:10b6:8:218::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.18; Fri, 23 Oct
 2026 03:19:00 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.012; Fri, 23 Oct 2026
 03:18:59 +0000
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
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: [PATCH v2 0/3] ipc/sem: account enlarged sops arrays and validate
 SEMOPM
Thread-Topic: [PATCH v2 0/3] ipc/sem: account enlarged sops arrays and
 validate SEMOPM
Thread-Index: AQHdYp0+T6/nysx9KUKhv/p8p2d/9g==
Date: Fri, 23 Oct 2026 03:18:58 +0000
Message-ID: <cover.1792724953.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DS1PR05MB10613:EE_
x-ms-office365-filtering-correlation-id: bf77cc52-e8b9-4ad1-522a-08df30b460ef
x-microsoft-antispam:
 BCL:0;ARA:14566002|39105399006|22091999003|24121999003|12121999013|15080799012|38102599003|11091999009|31061999003|21061999006|22141099003|24021099003|41001999006|4140399003|5062599005|19110799012|8062599012|8060799015|25010399006|1602099012|10035399007|41105399003|40105399003|26121999007|102099032|440099028|4302099013|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?AaIuYLbZc4JRzf51W5nca/KhbnmXr8a8Ym8du4UeblvuwKxxQArM6X4DHo?=
 =?iso-8859-1?Q?Vv398i0CCpyIdlnTLnoslG9O7jMztA5TbFC6qZyGUclaMY0sIVJjE5b0PJ?=
 =?iso-8859-1?Q?PnCRsqPmdlEn/0DOJlmRSMV2kLhCJUtUtoyVDcIro5ViAqyG9AHMcn00Vf?=
 =?iso-8859-1?Q?cSk9gA2Ix1hXsMz1cRyPYxX2eiZ8czzMr+jfsvSDY0fKxpDJekg5oGQD+c?=
 =?iso-8859-1?Q?POoLoFttlcKpDKZWSmvI6dOCofPWtX3fDKylWHAKN8mQak8qhs899a14Dh?=
 =?iso-8859-1?Q?HpJ+EHcu0aMWR60py5R226oHPvHQDYVAKLe8dz88L1vHxQe/zH53G4wJWZ?=
 =?iso-8859-1?Q?NtlU6ANJ2z9FIhXl7nlCaeIEjVqLs2L0E6Ha8RvffFX+ElKOOKcjfEUGk+?=
 =?iso-8859-1?Q?LrIpAVT7nUnTrFceMJvOYUuVb47r3II4Ym7YblB+9s/zjyZYp4NIIjMPQb?=
 =?iso-8859-1?Q?/9eW6jKXIzeqsnrdirgt4gn+63Oed3fwhV6WN7rpHBiPvaFd1+tNeRS2hq?=
 =?iso-8859-1?Q?8b+jMyK+cKmCEurZIQZCClJ+Huo4ziMTRBywXh4AzKzyL0AagKABQDmXXR?=
 =?iso-8859-1?Q?/nhKSKl+PFqrwVRivILFND0aWtIAt/G/+fmiCan/fLogzymUskcbPlFbOq?=
 =?iso-8859-1?Q?En0qad1x8fKfigpmCtofIAewPQ1kJehMyUzE3rp0ib6q8pGer6J5OprJjS?=
 =?iso-8859-1?Q?r7O7SeATjbt4nzCjVaFieg6artVzH9xnpSC9zMpl5Zr0YnpYl9E5LHl9wG?=
 =?iso-8859-1?Q?DHfxxYNk9fMToh9LsCYhJlGTxu8zupvpSPNLUL7QOWZd3dcqXgxGijbMY2?=
 =?iso-8859-1?Q?Mf9Rbdv113uQNN8PVGX4NP74jZ3yHSlAyyRm4GatDrudm62bnFwxDCnRZY?=
 =?iso-8859-1?Q?cxi64XmGFr+fpRNMjb24q6mEHpo8AOXldefrpgumwMwExT/4V01Oi/NuOV?=
 =?iso-8859-1?Q?KnvOkrpz7KiSDf+2Nv5T4bOs8VeIT4sZulwQ8izbC1wgR3q7VqxeaEAUmw?=
 =?iso-8859-1?Q?PC+MXEMvYW0odZmQIu2YuUzgJqnUqUUvzWRcOhoRrlK9c1dkl1rnajLEVY?=
 =?iso-8859-1?Q?/nyogL61qCKrTxMrCiZICNSNZU/LtQMFcN1s7PoQADuoNybBdGNgRDaCnP?=
 =?iso-8859-1?Q?KwT+CHyMRAcdQ9vzGkfC3jQHV3LEhW7nw55dWC1Twt3HKqCc1B41SaZBKS?=
 =?iso-8859-1?Q?aQwvR0Ja9Cph3wnqSeZr6z5WjqaQW4WzeRa4n9Ay/8T8LEUKw4gwGeYRH0?=
 =?iso-8859-1?Q?fmXQyOyuDzgwoE2FogI1A1qgAAop7LDKUClNFQI0zhfpJjyTvUhyC7vdVJ?=
 =?iso-8859-1?Q?18WXnls4h81NBikd6Q3t5Ja/E2mV8g4PehXIM6fhIbHEVP8bGQOGBDap0I?=
 =?iso-8859-1?Q?Tg9qzxkGfx37HPg0ubvkIc54BVjHsoB/nGzHV611L2PZj8Abf/PYg=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?2mda+YXYUsG08hK0QoO2PDmi/zFy3uNlQIAPJN44T50z6+e263Vx8E7dcB?=
 =?iso-8859-1?Q?MULMB5MTDJrI7ozGqR/iCEc2Ikgb8bVe3ss2+hcZ8zl3uYu0TrSD0MScRm?=
 =?iso-8859-1?Q?dShI8VE8VnAPucBfOtiikgQpNiP2t0cOur62glmRzwHRdPUlxe/uN2MI2V?=
 =?iso-8859-1?Q?97jaHDO12OEL5zcJmMWd45iZ+F8iooJR8QlVk47aPSb5HZN1ETwuK59guy?=
 =?iso-8859-1?Q?iGnsJYOhOyLuC3gAFIzgD/3iWC1q6ANwXcd3/OPhJ14YGt5LRjEenP6oVk?=
 =?iso-8859-1?Q?/7jLeXoX65lbU5TRe6IcacgyMnKHuM4b5zowO3o32Hm7KoXSDJNu3qsHDJ?=
 =?iso-8859-1?Q?N++H+boI/8mq0FRfbppM0V+C1+l4dCeybdBKaAIQXP1WRAM5bcneLQEgZS?=
 =?iso-8859-1?Q?hoAJMZre8VuKtRTDCQ8R+8wDf+7vPLK3T2TM9J6FMbNH4/UBKA3bk+j/ad?=
 =?iso-8859-1?Q?cFdZI27TO7XF0WDUAyy/wbY8b2ayQMEd0Wk5p8vJY8R2XkQF2Nh9ye5fpx?=
 =?iso-8859-1?Q?/kX+wNxbwqYW8M1kh0lMt8L5jlGAC6b6A36oOra4qB9tZFGGUeFnoXf5/+?=
 =?iso-8859-1?Q?f3O0ZbGONN8NZAtO8iH2h/2ZpegYW2kC21BvWFV7+TKpj+0FWGyV30r7WX?=
 =?iso-8859-1?Q?Q0JPJpvNjM7RzCfidjPGJFfyFiOrC9gc9Hj6fH513NfQzbmtVRxwuZ7ZhL?=
 =?iso-8859-1?Q?LkYpyikrDZIxw8C/DtpDqReAZ18MyfjHqc9HfU/W26pecnxlDv2xoPq0Jz?=
 =?iso-8859-1?Q?4f4sU11veTvqmZ2jXRVXTRv/pWcoOPMwe7Q/hZFvp3ytH9gy3AIQKbKF3E?=
 =?iso-8859-1?Q?EW/sL4fxMUDxoOLLQw6qQLlqTNEaz4p4heVeypn1RIIAFcOUN03A9w0w5U?=
 =?iso-8859-1?Q?J7iyfXYH38BPwsrJJLYxR4OtdO5RBaGHfv8iHVztu0nxKCl/iGZChQnq5J?=
 =?iso-8859-1?Q?70OtZZMnSk5kB7u8islSd31R9kr0K2FA8gbhQfXV4HsGsZzKAtQ+5prAZm?=
 =?iso-8859-1?Q?jUJvoVff60JR8bzO/7LBcak/orHoX9cUWYKfn1t5DH5sC5amDcQMnTVDuC?=
 =?iso-8859-1?Q?9N9PGkaRG8HQBWCwQQqkWqKwxaGtYexnNn21pCuLbztGCEaFhfITZzEpkY?=
 =?iso-8859-1?Q?7N22fMvCm28eeuzKCViuHes5NHOc/qrFzXIW+NYLDjiuTgFjQihYimVn5z?=
 =?iso-8859-1?Q?QGwovfYu1SfApqPbrTY3B5gdRMZyzDeSh00UmDmftFdqqd6t80IUvFbw5B?=
 =?iso-8859-1?Q?JfTqGaUguYV+feadteqjJyX9rzbibIjcWB5cR3l+3Y6bbFNNaeiIpXu9As?=
 =?iso-8859-1?Q?zMrnN437Jcin/qXB245KRtNDu/JhlV5Cu4HOSDT3VabCCHY7EosrGHe0dj?=
 =?iso-8859-1?Q?RumkAwHmfeYs7yH4OpVVFBiMg/KA5aZj4dPyF0CgLLhfFqLBz3ywqu+Muw?=
 =?iso-8859-1?Q?FfS3tvyRs8HuVtaa?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bf77cc52-e8b9-4ad1-522a-08df30b460ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 03:18:58.8002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR05MB10613

Andrew, Manfred, thanks for the review.=0A=
=0A=
This revision keeps the memcg accounting fix independently applicable,=0A=
makes the SEMOPM validation safe under concurrent sysctl writers, and moves=
=0A=
the UAPI comment cleanup to a separate follow-up patch.=0A=
=0A=
Patch 1 charges operation arrays to the caller's memory cgroup only when=0A=
the actual nsops exceeds the compiled-in SEMOPM default. Requests within=0A=
the default limit retain the existing allocation behavior.=0A=
=0A=
Patch 2 rejects negative SEMOPM values. Writes are parsed and validated in=
=0A=
temporary storage while a per-IPC-namespace mutex serializes writers from=
=0A=
the initial snapshot through publication. Shared settings are accessed=0A=
with READ_ONCE() and WRITE_ONCE(). Failed writes leave the live settings=0A=
unchanged, and a partial write cannot restore fields from a stale snapshot.=
=0A=
Readers retain the existing per-field visibility.=0A=
=0A=
Patch 3 removes the obsolete UAPI warning about physical fragmentation for=
=0A=
SEMOPM values above 1000. The operation array has used kvmalloc() since=0A=
commit e4243b8062c1 ("ipc/sem: play nicer with large nsops allocations").=
=0A=
=0A=
The series is based on 7be4bc52fd9e ("Merge tag 'driver-core-7.4-rc1' of=0A=
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core").=0A=
=0A=
Validation completed:=0A=
=0A=
- W=3D1 builds of the changed objects and full x86-64 bzImage builds for=0A=
  patch 1 alone and the final series;=0A=
- a W=3D1 i386 build of ipc/sem.o, ipc/ipc_sysctl.o, and ipc/namespace.o;=
=0A=
- initial and user-owned non-initial IPC namespaces rejected negative=0A=
  SEMOPM, invalid SEMMNI, and malformed writes without changing live=0A=
  settings, accepted zero and positive SEMOPM values, and enforced the=0A=
  configured operation-count boundary;=0A=
- both namespaces completed 10,000 rounds of concurrent partial and full=0A=
  writes and 10,000 rounds of concurrent rejected and successful writes;=0A=
  the same test reproduced the stale-snapshot overwrite on the superseded=
=0A=
  implementation in round 1;=0A=
- SEMOPM limits of 500 and 501 accepted requests at their exact boundary=0A=
  and rejected the immediately larger request;=0A=
- allocation profiling returned to its baseline after successful semop(),=
=0A=
  EAGAIN, EFAULT, signal interruption, and IPC_RMID wakeup paths;=0A=
- with patch 1 alone, a test using sixteen 1,000,000-operation calls in a=
=0A=
  32 MiB memory cgroup observed memory.peak reach 33,554,432 bytes, one=0A=
  memcg OOM kill, and allocation profiling return to its baseline after=0A=
  the caller exited.=0A=
=0A=
Strict checkpatch reported only the CONST_STRUCT warning for the local=0A=
ctl_table copy in patch 2. That copy must remain writable because its data=
=0A=
pointer is redirected to the temporary array.=0A=
=0A=
Changes since v1:=0A=
=0A=
- account only requests whose actual nsops exceeds the compiled-in SEMOPM=
=0A=
  default and place this independently applicable fix first;=0A=
- reject negative SEMOPM values before changing live settings;=0A=
- serialize kernel.sem writers across snapshot, parsing, validation, and=0A=
  publication, while preserving per-field READ_ONCE()/WRITE_ONCE() access;=
=0A=
- attribute the long-standing signed/unsigned limit bug to the initial Git=
=0A=
  commit and retain commit 50ec499b9a43 as the reachability explanation;=0A=
- move the UAPI comment cleanup into a separate follow-up patch;=0A=
- add concurrent-writer, accounting-boundary, cleanup-path, and i386 build=
=0A=
  validation.=0A=
=0A=
An AI coding assistant assisted with implementation review, commit-message=
=0A=
drafting, and test planning.=0A=
=0A=
V1:=0A=
https://lore.kernel.org/r/20261016152609.2528805-1-x-professor@outlook.com=
=0A=
=0A=
Andrew's review:=0A=
https://lore.kernel.org/r/20261016155905.2a659b7bb7d61f33467a3263@linux-fou=
ndation.org=0A=
=0A=
Manfred's review:=0A=
https://lore.kernel.org/r/51c93c19-f1dd-455f-8698-6b1ee30eb630@colorfullife=
.com=0A=
=0A=
Yingjie Wang (3):=0A=
  ipc/sem: account enlarged sops arrays to memcg=0A=
  ipc/sem: reject negative SEMOPM values=0A=
  ipc/sem: remove obsolete SEMOPM fragmentation warning=0A=
=0A=
 include/linux/ipc_namespace.h |  3 +++=0A=
 include/uapi/linux/sem.h      |  7 +++----=0A=
 ipc/ipc_sysctl.c              | 38 ++++++++++++++++++++++++++---------=0A=
 ipc/sem.c                     |  5 ++++-=0A=
 ipc/util.h                    |  7 +++----=0A=
 5 files changed, 42 insertions(+), 18 deletions(-)=0A=
=0A=
=0A=
base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614=0A=
-- =0A=
2.43.0=0A=
=0A=
