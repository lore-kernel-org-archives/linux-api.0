Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794817257;
	b=Evbn7Dfq4Jx10ouYcCC25SjugX58VwixqbXgyDj3f4zi8xvn21wYN/enhOurDcl5V465
	 G7IEHz22FEc250ypU32RFBPRcENL5j0HCzy/z9inAL4qHg4TXBdAQxVTRALelufIGA6Kl
	 WayX213p9gLsJndi6yOB0rv0X/XvUcTykjZgxQjmxiOoi+kCS4lX9c8fFTaAJI+OQvTwD
	 iIJ92QNMZoYEv59IK3V/Vj9ljKkfz9jizwEiCnuEG9bXEexfRfkkkT6bdf7C+dx70XIJK
	 SSm90/Y6WmIZUrZdAuqmfW2tEpmgMlHe7gVxWN/iz7YDuOFc2PvmYFMggrjxwyFBmOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794817257;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ukvq9B/7TTemoB1pKWvGa6rNUTjuaVxe+7q9ne8vWYg=;
	b=F082bdRytYvaBapIYSt1AU2sOqF8O0i7Vkw2HhFtdemVTUQ7i7uP5S55mPyELOCk+6ds
	 CRNsyywd/TGo+8g36/Xbgqs856v+f/VfX2NAi67f9YplaJAKE0PyWGx3VtVHACejoat6I
	 AI+xDBgto1KbAxsokiNFMgTyDQp4KapG3auxkq4LAhf+CpBArrR+EgEYlytoQ2r2dlO3B
	 6BvBArK+qotsDNnYTpE9kO6h3xJ3LulCLsrOOp25wFYvHDJ/msA7na7S/jIg8b36zQ5te
	 qhX0/N9TXQbLTVt/e9pWw7AoR5rLCergd6Mut/3HO7KmnLvHa8n38QImna8JUlBO3qQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=he0kfw3c;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.12
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazolkn19012012.outbound.protection.outlook.com [52.103.14.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A95A606A334;
	Mon, 16 Nov 2026 08:20:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A95A606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=he0kfw3c
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oiz13MkiOM7Wh7zfKSpiIzGbetdy6NgLDXOG1hfgwqxyA+9Ve044wwcw77nuDEFNM7YetUGo9uPy7BRmx/faL4tjD+tbUvoQanZdvxPD/ZKmtrLBzFo+NOTLs0Nwbp3Y5yxeMAeZpAPD+NO4Y0cHJJLEssNYqtxmiFjSMh0trVu4zMZbbxLqg61lPHKU5u3Qyfglxrc7zjhsHNY6YFl30R2sPaed5CM/Cl4dHZZtim7n79ORH5wr+tupV0InXzmhxTC1taYGw5DyRQObsGwjOV2n6HdyRk4Q8Wp9AIb3eiVmnnnBaqo4YW1UdXfCiumJA16zdaPm/0BTOIu/jfhsHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=ukvq9B/7TTemoB1pKWvGa6rNUTjuaVxe+7q9ne8vWYg=;
 b=r2lohP93fESs/STaJuJoP4HbV0fUn7GGt0kmgNBSFVJAKS+w+VRWjbOft4a/QsLU6/PeNe/91KHLYO2bKg76t2DbTjD5AlUID8RCqs7RBbsJHWwmPuZ66UE7whXtL0dW85hhekUMhb6d35I4UNa8FoQfV1GNGqfvnnieuwy8FCwkmORoW/fEb4e+nUkT2bZcaVgWMpkjKj1oqXgn/pubmQdxPh+6siQPfhAAvH6Hupwwx06kudaAaQ7XqmK7/ZrBuU0hevimbMh/QkN56e2s4G3Z7R+GzNhFk+8JnK6Q0nXyAPijiY1Od1DMtEzfS8kqH947z6p/g5o/HBzw1MFopw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukvq9B/7TTemoB1pKWvGa6rNUTjuaVxe+7q9ne8vWYg=;
 b=he0kfw3cqz5mlWYOlbc2kFvxvMHqxjtMEhU/SMSpRQ8A9waehFu/2EsJw0lN3Njdus3WdLt/jXcQZ8skEiEv4ywBq/7eQzH8PdT0kYNL5poxUD+NII4RIzzW05KfWoOWLZqCtVH4oJF4l9dYyP5rL08COfleb/8IviARqQxBIgUREggA2fXe1Dqb2sfX7d9nM5AJPSFHKFb1fHACZKq382ZLhUXiwor/Ld7DD4SqBUtD8U9KaYuslCu8XMPak52XU33dCzmLF1bwNk6Z7IJ7WII9XoqaEaCvLlV8EAvZKdnPXT0IPpcwTYxZlSemnZ//GvOBjOsv7pZAi/WIX8n1rQ==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH0PR05MB7948.namprd05.prod.outlook.com
 (2603:10b6:510:75::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 08:20:52 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 08:20:52 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"manfred@colorfullife.com" <manfred@colorfullife.com>, "legion@kernel.org"
	<legion@kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>,
	"vasily.averin@linux.dev" <vasily.averin@linux.dev>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "mkoutny@suse.com" <mkoutny@suse.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "alx@kernel.org" <alx@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-man@vger.kernel.org"
	<linux-man@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] ipc/sem: account dynamically allocated sops arrays
 to memcg
Thread-Topic: [PATCH v5 1/3] ipc/sem: account dynamically allocated sops
 arrays to memcg
Thread-Index: AQHdZ2LUNgBTxImF/0OyY2v2GPuaF7cwNH4AgABDhIA=
Date: Mon, 16 Nov 2026 08:20:52 +0000
Message-ID:
 <179481695440.274194.11951572532773505066.semopm-shakeel@outlook.com>
References: <cover.1793250194.git.x-professor@outlook.com>
 <07d9034ec1fb5b6fd5eed2cf60ef3c84d5149e51.1793250194.git.x-professor@outlook.com>
 <avqD2Z3KJwPsCcVG@linux.dev>
In-Reply-To: <avqD2Z3KJwPsCcVG@linux.dev>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH0PR05MB7948:EE_
x-ms-office365-filtering-correlation-id: fdbc80ab-46d7-4538-3a27-08df43ba87a6
x-microsoft-antispam:
 BCL:0;ARA:14566002|22091999003|24121999003|15080799012|24021099003|11091999009|21061999006|38102599003|31061999003|8062599012|8060799015|12121999013|19110799012|4140399003|25010399006|102099032|3412199025|440099028|40105399003|53005399003|26121999007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?bB548cMbH/MBpQ/sEhMS8PAebagPYBvUNqI2kE2m4a2Bjb1mw3AadrJSFTPR?=
 =?us-ascii?Q?o2DHbV/wHdqhoRcL5OaWvEZ+1BpDiRkOVkjtxAIGub+32DmAjWtTtTL4mP03?=
 =?us-ascii?Q?Gfx3nOBijv4WZXZE1S2qo+38brBgZakzulslkJyZx+dPNWw/qSOCz005Sv6v?=
 =?us-ascii?Q?TqPEINYRrG+eA3MgKWJ1MPu2/k2B91Ei69y799btl4wa+rF8Buv+1yWVAPHL?=
 =?us-ascii?Q?hl5+peBt1Ud4rw7v7NxhWH6QrMcofb1BGa/vvNcOjFt7izydxmMH3wlvG610?=
 =?us-ascii?Q?9vkwulh7BE+8ckDoI3lZjUy/RV5azqF/RQE9/VbTd9E4Rrgsm5N0JrZFOJ5f?=
 =?us-ascii?Q?t3baQq6BYURiEQ4N1ppTvINHKMQ8vz88QMl0Ecune/EfjKvz6hfW7dnCXRV+?=
 =?us-ascii?Q?7PjO4Y6ZHTMd7KmHRGdsrTJZKAAgWxGRSQNbjpwhLTFbZBBEkk/u+SLSClM1?=
 =?us-ascii?Q?MaaB9osDEJ6qPj3GI49yr70V8xRKsQTkAgqxO4NpM+oc9ZRZXB7zNmAzyXxo?=
 =?us-ascii?Q?v/1EnI0097gp8HItx0QxvtoXQdBpExdBfuVFQ3cN4w8h6OEMWOFDZLe32BwD?=
 =?us-ascii?Q?nKf1hSqQXy1nn/F+Ovyq6gD8B7IX8DX29j93Bcsz5V7/AY4baKptCGKxfCi8?=
 =?us-ascii?Q?u1hLujsNdNWQzcQwMmg45nNoiCw+8Ki4KSVrFMbbGMJL5dTvvQX8R2WUdjww?=
 =?us-ascii?Q?Iu8PLGyor/UjrIZ/5PXuhnvC5ySqvlEtIFwkncoXjuvNHIdScj5sxTRNgoYo?=
 =?us-ascii?Q?4cSuWCsSUqUVjAVgW/oIqEKxtz4K5+4eZg83a838Ce2XGZQHtduAItnI/7EN?=
 =?us-ascii?Q?GN3TJRn0zJdP5bo3b0NGZiO3aMQVelHfqiI/XNZn9+uzVPAqgyR64IO7sDlH?=
 =?us-ascii?Q?8wH3dNelwsh/Zu2FNXmNE/AM9wXorvCFOJqr9QfoLbd6T2dNy7EFyKEVyV71?=
 =?us-ascii?Q?aufQGgXs4bnPpwZJXtd4G+6luIpuwRA6CwfBsE812IGPZ+KMS1BElwBiWRKQ?=
 =?us-ascii?Q?UjVNxuNxF6WDtoofCRNWJlhKKTH+QgMTEA/drxRgnBqzrWzHIzs4ewpSCGy3?=
 =?us-ascii?Q?k30gKsnKMwck2N0moEgCqNIw6Z/RZYSAQgMb/NA4s7qBBFj5o2B5hHpa5yZc?=
 =?us-ascii?Q?/w7uVF8X8DmcgpLXIJ52zUW0fOuo6xGSRa5usvk9Wmi8mDJNAdYTOow=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ZCUMQeCiWQtlE5LSW7iBv9nsycq/cV05DUsnxbaOH/bCDVh8oCC3Q+8xu1kn?=
 =?us-ascii?Q?BxJLLjQpyW2MHr5kC1xr6d0qdVzFRBQXiajpmLFNVU/4/32th6pe9p5TxGCM?=
 =?us-ascii?Q?b5I/0upOMbI4AmxWMLxxXKvXRIAtoQf353XS9yh+NHUudl6XRYP6tKDmQQrc?=
 =?us-ascii?Q?cSFQgaISZlPPmJe7+AWIttlvokOWN/WXLHYWCiQe5ja5XFOf9XrIwlpx6FT0?=
 =?us-ascii?Q?oRH4kS2hGPkH0+nZ2BX9oaV2pbA12yFSZtQPbv7vAAsM6b7ZZ0SG4SUVIGig?=
 =?us-ascii?Q?02QP0Z8fmpj8rMMoHy4iYRlkGro/5TGepbN2N0lCLdMnSWcgsOAyR+r3IFkP?=
 =?us-ascii?Q?GSP114boYCIvwxycwUTBEy4e7sujzAVG0/61hAJprz42tCmmXay4hlgNI0Gh?=
 =?us-ascii?Q?8WTRzykFkljJDL0EEGZ2dBBvTSEdWJ3USfFGFKlkThSPXm9I6Hq4jwiNiXIc?=
 =?us-ascii?Q?nuCC/t7CI3GnMK93BnenfPimbtAsDb21GhoovRBRcgqfK8lN75yAOMGtMnsH?=
 =?us-ascii?Q?IBudhgHBT0UEHjYJpoUu3/YhIZZwG2x4jsjJi7Z0SR3VdK/RQytgrDmMJc4l?=
 =?us-ascii?Q?9tjUH+hNpPk6C8P5wrDeICkkawuek6x7VUcvnWkgalRJ3/6MqkNpYadu5uF1?=
 =?us-ascii?Q?0/tJnu6qPaChsab3KilsV7GraTgXHhNsyz7C77Woi/f6B6p3L8hOkMrkZi0/?=
 =?us-ascii?Q?+vBtUwXV9oCs7TomHKsyHs4XxYPAbBmEQMk9hI9+nD1AXdzh/GD0bD22nf0R?=
 =?us-ascii?Q?OgPuV3UUR49Ve1TRFVW6Riggz2rtSG9FvqAzfYAB4JIPOWbgdZn2D0Uxtl1D?=
 =?us-ascii?Q?ffbAuG++8nd2+qgGee9XNrA3klFHZRci+jsxwuChEPAKJH4hxsQzq7ivhulN?=
 =?us-ascii?Q?+Ob46rJ/k4+iCDeLP/dA8vEhnhBjTndT/XLvv8XGz60d7m+kDdnG7DYxZ+a3?=
 =?us-ascii?Q?TIMjXI5Rj7v14O0hdHJ9OJmfdeaGE2OIK+MYWc3VLyYDhv0QvdagiDMBD+9+?=
 =?us-ascii?Q?xq5eBlRCs5wI8xn/XmLnVL5v3/B6WFU9H/8UpP0qA0zUBGwhhN07lCuy18Oc?=
 =?us-ascii?Q?YZJ+/qcNuD65WsZmeWagOkSwA5bBgtsuqHusHcmyflxb+6uVMg0rSdBVMgjZ?=
 =?us-ascii?Q?TjnbNWUpZK7msFDcOwJ7+uNgoFE30NJTlLUNGOG9Gi+AP4pbWBSpOaSy6Gtz?=
 =?us-ascii?Q?gdW5qO4pjJaIx3Kyj02iabACYGl8rNOq/gQRUuZMFxwGAWV12pxpC1Kn4JQ5?=
 =?us-ascii?Q?NbLxhOlDY3bBYy3bZhf03GXgDm/gn1vljLNVcw8Fd2CVQBKrF7wYF5MZwrRB?=
 =?us-ascii?Q?GGf0kK6xn+J7sGaeel8aXDxhiwIXPQqbcl5KfSosiKBstnTpX8fo5IOiNYUz?=
 =?us-ascii?Q?P1VqHh+KZ0m5KeZ+OCFwR+ZVky9r?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B2CD27E99C27F44B764ADFC29F759E6@namprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fdbc80ab-46d7-4538-3a27-08df43ba87a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2026 08:20:52.8470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB7948

> There is no kmem accounting in root cgroup, do you know why there is an i=
ncrease=0A=
> of 2.3% there?=0A=
=0A=
I think the 2.3% mainly reflects boot-to-boot variation. The unchanged=0A=
64-operation stack path also slowed down by 1.9%, even though it does=0A=
not reach the changed allocation.=0A=
=0A=
For successful calls, the per-boot medians were:=0A=
=0A=
  nops  V4 boots (ns)           V5 boots (ns)=0A=
  64    230.5 229.4 230.0       231.2 235.0 235.4=0A=
  65    546.0 551.2 548.2       551.2 562.6 566.3=0A=
=0A=
The first V5 boot was very close to the upper end of the V4 results at=0A=
65 operations, while the later two boots were slower at both sizes.=0A=
That is why I interpret the increase mainly as boot-to-boot variation,=0A=
rather than root-cgroup charging.=0A=
=0A=
__GFP_ACCOUNT does still change the allocation path, including selecting=0A=
the kmalloc-cg cache, so a small contribution from that is also possible.=
=0A=
=0A=
Andrew, could we clarify the root-cgroup result in the [1/3] changelog?=0A=
Please change=0A=
=0A=
  and successful calls in the root cgroup by at most 2.3%.=0A=
=0A=
to=0A=
=0A=
  and successful calls in the root cgroup by at most 2.3%, which=0A=
  appears to be mainly boot-to-boot variation.=0A=
=0A=
Thanks,=0A=
Yingjie=0A=
