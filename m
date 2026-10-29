Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793250209;
	b=sL6wUt4WcpDXhXPIObQNiV0m1VMRE/qzG1Dxg2qDjABZNnhcW4gKWIvBrKEh6DHx7Avt
	 H6gAhbjaapg3H8ewcJwJBvPDxco62c04z1c1ooV9oUQah1Rdt3/Q8+LSADDbEteVnwk7Q
	 9w9ep+Q0wJyeBIXOflWayEJk+EJKuZLDSPd5f3RhNAt0Rp5LF2myQLVkdA33RzxE6NKKQ
	 ApFDopfZBKj5GNUrNQxjM2RxQZeJq99NmE0PrsDp4O+W9/xDg9EcVgT41vCQsC9XT0nUH
	 IjtIljPJK+INmRAkGorhxU/sAebCUedNXtALIIrV8QETLXK7xEtf3+tcN7HBEhYwgaA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793250209;
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
	bh=6z2+lcwnTNMK+TXPFvXZSmWKT2dCLGjDpjZ35yEwilA=;
	b=G0LqVf2vouUi11hZdPVZhVikwAO+thpCqrZQtB6shEEY46kTxZw3ufWhitrhsjpBEn8f
	 BxUAF5u8MV6xF8LpOg+Fh2VgdBjJrlYOQ/1v3uZddWR7ZZ2kS/wByAcYxZgo0WolWnSi7
	 nQVffnvekweP68pkg/eOQVnV8Z9xJXroEk14lHPOYqRBjd5fXlxF23X9tQszyE8fqYPaA
	 +ooJ1e22QT34gKqn8ld2WurmSYkFe8LqfryeUQYBibQbB52n7Sr7ecjpawerI3C7Yh2zP
	 ijoxxEITVyhOY/kalc0WnQPvW16q0yM0aXBJjv4RBjRhh/oZjnM4cmw+3kRna126/Og==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b="RVA1/VSD";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.6
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazolkn19010006.outbound.protection.outlook.com [52.103.20.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5467606A32C;
	Thu, 29 Oct 2026 05:03:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5467606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=RVA1/VSD
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NpE7EKXQ8y0Oa6rxKmYx4Ch/2Oj3NGBm/pSa/Eqt+Ljl79vZRBLyhhWzLPlDTA+fr3X9LpQwOX/z2OqNxBc0GA6qDvQxuFZzoY54kY12tJlOSFNKTasaMbMTXxq+0csONWUN6plGr9CUKug3HUYQJdMpf8gX3qjXnKzR6GEKopoP45GdzqHR4PlgVX7RrCtVctvN0RDIggU2rxi4MbNTxd3wElIUM8JTYxpSzVL/oWRWmCkfZXm7MDoVaTpMzOJxVtJ/Hzdvcf/flSkrs4T0Tzuyp2+PuHTBZzEgXW4bP0yyUaeohQZxkypKp0Jcw0ulP3QkYdQRF7hVyLgcecK3Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=6z2+lcwnTNMK+TXPFvXZSmWKT2dCLGjDpjZ35yEwilA=;
 b=MJlS5OHTcbVsttRZtLMhMsd7jS40Rmu47nGhZ1HBPLkO1DGm+mevc/Rh4YsapejoWFi+w0Fxu1jOVh1McMMunWDtQiklLP4r8Cfu4/h82lNmowGYRg9mIZuW2Y5YRrzIvkcyDZe4lo/BGpEhRYauizYAuefyd2ADq3hdz4/O7RkcAOJXwaGNOVAcoJ3dRLnqljs3mj2JyhlaIQdJIaf4ZhzqT0Svns7IsjEjS0WhsRp1bh2tlnm1A5QVIkiw18gAC2r+tqi4T5kHMzawJZpFsP4dzqdKjM+d67TmRSs5H6pTrtFpE2p3D1zrGa3tkYwiHyI9NU9GKX4Y8MCptpiPOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6z2+lcwnTNMK+TXPFvXZSmWKT2dCLGjDpjZ35yEwilA=;
 b=RVA1/VSDthgCdsmxj5MgNGz/qiCA6Hj8ytwVDlJ5g864y596OJ2/VEn4H7GwtzeGe4r3VbPM/wAc2fzD28Mq+v5C0PQ1gEl7AfGKH/+dRaWRxDOlbNy1IwPnqzDTwW5RChULHywKOFvHYWh1UCInIcNk4h8Xe4HrnaCty98IMw1uU94evrxVOmvj7nM4MlGdU3sILzEyhTwFDqX9diMIQ01/C4oK/y91lFccOH+oUcEHapckJChSLLxZovoaR9lzNwGkeUKXug+qy9LcfLqKwoLz+3Pv5HEhWQNOIFzD27Hm0KuA2baiT8QKU56DH18O7ZOi9mrgoQj1UZCM6A4vwg==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SJ0PR05MB8214.namprd05.prod.outlook.com
 (2603:10b6:a03:390::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Thu, 29 Oct
 2026 05:03:25 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Thu, 29 Oct 2026
 05:03:25 +0000
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
Subject: [PATCH v5 1/3] ipc/sem: account dynamically allocated sops arrays to
 memcg
Thread-Topic: [PATCH v5 1/3] ipc/sem: account dynamically allocated sops
 arrays to memcg
Thread-Index: AQHdZ2LUNgBTxImF/0OyY2v2GPuaFw==
Date: Thu, 29 Oct 2026 05:03:25 +0000
Message-ID:
 <07d9034ec1fb5b6fd5eed2cf60ef3c84d5149e51.1793250194.git.x-professor@outlook.com>
References: <cover.1793250194.git.x-professor@outlook.com>
In-Reply-To: <cover.1793250194.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SJ0PR05MB8214:EE_
x-ms-office365-filtering-correlation-id: d66ccbf1-c9a0-449c-80c6-08df3579f696
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|10092599007|12121999013|38102599003|24021099003|4140399003|15080799012|19110799012|8062599012|8060799015|25010399006|2604032031799003|22091999003|41001999006|21061999006|11091999009|24121999003|1602099012|10035399007|52005399003|40105399003|26121999007|102099032|4302099013|440099028|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?tFSayAlT3buO0qTTbYOgEURe+L2XmPMFosF7+gnAMLTi+9GIBCFKwPx0+X?=
 =?iso-8859-1?Q?5FviBfr75Ng44xOOwQzZTy3Uviv9BgJK3NeSwi+aSFFtTJprxA6E5brtga?=
 =?iso-8859-1?Q?oTZlWvXnInlNSTKOqvELsnIaseEcLZe2p6hQ1h1zhX8IAZ/Y5BgW8NFc/1?=
 =?iso-8859-1?Q?OG4E7hFfZEFa+EJuJ0QueY+GwKmdvJkVyieWFIssZ1yk4zyxGEDETjCb7E?=
 =?iso-8859-1?Q?5PDz62L6P9mhDNLe/z/KS0z8Z64WCtPd6Cn5pDEnM7521FcMPzm7QW/Fm+?=
 =?iso-8859-1?Q?uCDavoqJlTQ6d/p9E7H7Ja/jO+2ok1lbKLsM3lRdKtCzg/k+vK2rLc03cb?=
 =?iso-8859-1?Q?NSfILu14UrsGpfoxmRlkboW/Tv2YfzwGAweRAX0jrQeInuOTqM0qS+LumR?=
 =?iso-8859-1?Q?V372bnZAVALBOhvbVyZP46EvklWr/owqB12dunuQiIlP2mFfBwN/QeY9la?=
 =?iso-8859-1?Q?dVjVPTROrUfEsav0GU1Bq2rZ+ezAu2pX12BT1h6quXp1wtovt8cgMZPHT5?=
 =?iso-8859-1?Q?Dez9gFICLhHOtIhF7NC58AFBvDUdZNzVwEyaqHCa57JPdIh+tZqwCJ2AWe?=
 =?iso-8859-1?Q?30z47hGHPk/6lUUheIDxhkZnc+huN2csaHEa0F+A3AyoVkZCtYI+upv8na?=
 =?iso-8859-1?Q?wWbA7fJ6K8phIi/RD8Oa9Z529EtTOw9pbE+pg4hGPN2fLmbwoBpbQP1dAj?=
 =?iso-8859-1?Q?INAKE6sws4+SNYg2B+3PG3ukkfaWv4DhckCCb6ES67QYKVZw/FiXQcsERD?=
 =?iso-8859-1?Q?ourOkifo91JxwPVcR27ofmonWb+Moq9asDSL8WKvUIli+wWaKabvTvw6r6?=
 =?iso-8859-1?Q?whHeJmu8rLjO+40aUD1jTXqK2v4TTX8dAYwYrQBxrm2C22ukl88dR2ko6S?=
 =?iso-8859-1?Q?FAZ9fLITfnecmEiQoEQJ6w2VKdjv63QEmrOveA/kzKbgaVLsbz00Ehkn/W?=
 =?iso-8859-1?Q?SgFtMdvv2sZnB8Mkm5lizs5nPUCu7SsvhvqCJ88LxZm0BMkqODcNblV20u?=
 =?iso-8859-1?Q?IoLevxRuuLCxBe6cVfrD6T9P/GMNbc2Wv3zXu+p0K++yaL+hkmVlNaqj41?=
 =?iso-8859-1?Q?BpSiOpggAwd3dOfZKNDOUYnZKJLfnp/jk5VFwqOTMN1Db6BTG7h6/0i1eK?=
 =?iso-8859-1?Q?MD3CwsJe4L5j15y9h8vJql7Pr+y5kiswJ95RxPDtlyr2Ej6PDV4FyONMiF?=
 =?iso-8859-1?Q?Bgb/G0RTcLKd+KvhYkrdY12YgiKh2dc+ADosjfEzMayraMB1HniQryuU3y?=
 =?iso-8859-1?Q?KhgiAX3gXJfoCdlFtWxdXhRy2Iv6arRtfi9bt6AVRdOLOzgYBL+r2Qy7x8?=
 =?iso-8859-1?Q?FOeH+IasWyOBHr8HM0yxTPeRgmYZmpYUyN2fEh8pUeQdq8MIvrCJ0AofNG?=
 =?iso-8859-1?Q?kJFGQotvBpz64kwRFdHREhNziXQEZoKg=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?BGAU4+3OvCa1ltVi0iFIcXsqdsJpQphV1QZRVcKpavmvmsz8d8/PXfp0tu?=
 =?iso-8859-1?Q?Qnq9Eaeq8qWyQI18s/TuSEIWYUDvkDsWZg+CHUGP0RJs1LnE8VKxysYei6?=
 =?iso-8859-1?Q?wIJx22LqnMIsKRL58EpFKSOgn2kRg6tyOnQnKMpn1A+5kiDDmSZgjwnsNF?=
 =?iso-8859-1?Q?fFN8Psgl+ZgJcEevc97tl7X33/KrPK0puS/u7w8EO4vZNo9fifEOV8i27A?=
 =?iso-8859-1?Q?w//I3Ja/s/1MRKOnB/xPX9gYpmXTTwwN9SgcnxU9WN5sYB7ESybed0o61S?=
 =?iso-8859-1?Q?vzv4/ZIfwgtlADDuHh55T+eC0g1fbcmhEavhp6v6lfQJKuKkEXdPHMbOoR?=
 =?iso-8859-1?Q?bz8thXZoAwBvcH+GMnm/Bu6QIQEdgXFLuYfuQrUAPXIx7Vd4GAhH6oUz+i?=
 =?iso-8859-1?Q?cuxcLFEAoxDQxTrmTFlUe4lfSvFie+CAhVv1+DrOvp5Bz7o9u2w/1oMRjL?=
 =?iso-8859-1?Q?ysG01V5opMDLIyVT4XdmqqCJCMB4RxXO9UXrZQ/739wRmNX+syOOIqYxgR?=
 =?iso-8859-1?Q?NdCaQ0oY4vwt/+vZKQflOP5CMLzfy+PQbvtcrUno1QaM5gbwa9IlZPKGIb?=
 =?iso-8859-1?Q?XGnnveJY/X6NIf8c3H2xYZA8e33nUbSdtYjiC+IMAnKHRshTcifWgWNc0s?=
 =?iso-8859-1?Q?iIxrj7ZTt0UMr9RCeXAvCcuvlCww5LO/ylELtIPQqChmt22ZY3YveEpOA7?=
 =?iso-8859-1?Q?6iMDE/xAwMSbB+K+vRHrkD0alRxodPZtdPfRj+dKARVLEzk3RL2HuRfADM?=
 =?iso-8859-1?Q?7R+FXzTeluq2816NoiCoG3JhXOLVVqjDSDHozhzr3TgLI1kGSThrNZld54?=
 =?iso-8859-1?Q?Ns17cFYz8emF8oHPd0PfhuCxA/K315PB6d3tSz6y722y0bqO9cr4avYCt0?=
 =?iso-8859-1?Q?MOoPoswQtQew1uFG6ZsvXNds4ZqO52Bd9WXh+VRjI0kdkLCnUpSf3aKqCT?=
 =?iso-8859-1?Q?hPy/quNvRXJhbp+LhorqnPs17Cd+9Cw47PIuRJAVW20pZh0fOiOU4b1tO1?=
 =?iso-8859-1?Q?P8w8Zg9v6o1IzbBlWiOK1T1GapJ5lQjV2lLAT06Z6l0+Z+BUSPKYeZnKMF?=
 =?iso-8859-1?Q?Vw1e0Mlrxm1nULKBR8Ncfs4h6hFFPgCaM27/GY8ok4onBpFPMlILnpKlBu?=
 =?iso-8859-1?Q?T0u4aBcV5XM+B/5eI1VxLt34UobzPmNPIZsk4xqIvMnXQRSWsxl5JU1fYr?=
 =?iso-8859-1?Q?Bx+M9bfIgWzdgGKos+X8jzsvD5YfU6Lmmpg48fzMU3/RKdh8BSCKXfsuCJ?=
 =?iso-8859-1?Q?CmYpkjHaAZvI+AKjaGc5ep648kabJhmTvPPYa/qzNpPHq4+KsOhn83UsGK?=
 =?iso-8859-1?Q?PWQpFUOJhyuNow9Fc3kyIAJVJEg/oK7Ao66CXyQpi7pZXt1FJT7+Mh1hsI?=
 =?iso-8859-1?Q?Y0xTKCYyvc5yjpNsEqc/xjFF1TCohOPPp7FxIV+rY9emBe32fM/A8iSFPw?=
 =?iso-8859-1?Q?uEua/6mRvVpF+q9d?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d66ccbf1-c9a0-449c-80c6-08df3579f696
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2026 05:03:25.3183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB8214

Commit 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in=0A=
do_semtimedop()") removed accounting based on the assumption that sops=0A=
arrays would remain small, describing a maximum cost of two pages.=0A=
=0A=
SEMOPM is a UAPI default that can be changed at build time and through=0A=
the per-namespace sysctl. Commit 50ec499b9a43 ("sysctl: allow change=0A=
system v ipc sysctls inside ipc namespace") made that limit tunable by=0A=
IPC namespace owners without capabilities in the initial user namespace.=0A=
=0A=
do_semtimedop() keeps up to SEMOPM_FAST operations on the stack. Charge=0A=
every larger, dynamically allocated operation array to the caller's memory=
=0A=
cgroup. This avoids a second size threshold and prevents a configured=0A=
SEMOPM limit from expanding an unaccounted heap-allocation range.=0A=
=0A=
In a 4-vCPU KVM guest, with the benchmark pinned to one vCPU in a leaf=0A=
memory cgroup, accounting raised the median time per successful semop()=0A=
call by 2.3% to 3.2% for 65, 500 and 1000 operations, compared with=0A=
unaccounted allocation. An invalid semid, which allocates and copies the=0A=
array before returning EINVAL, rose by 5.6% to 11.9%. The 64-operation=0A=
stack path changed by at most 0.9%, and successful calls in the root=0A=
cgroup by at most 2.3%. Each result used 21 samples from three boots.=0A=
=0A=
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>=0A=
Link: https://lore.kernel.org/r/20261016152609.2528805-1-x-professor@outloo=
k.com=0A=
Fixes: 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in do_s=
emtimedop()")=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 ipc/sem.c | 2 +-=0A=
 1 file changed, 1 insertion(+), 1 deletion(-)=0A=
=0A=
diff --git a/ipc/sem.c b/ipc/sem.c=0A=
index 5ec41de7e85b2..ea95cca5bb0ec 100644=0A=
--- a/ipc/sem.c=0A=
+++ b/ipc/sem.c=0A=
@@ -2234,7 +2234,7 @@ static long do_semtimedop(int semid, struct sembuf __=
user *tsops,=0A=
 		return -EINVAL;=0A=
 =0A=
 	if (nsops > SEMOPM_FAST) {=0A=
-		sops =3D kvmalloc_objs(*sops, nsops);=0A=
+		sops =3D kvmalloc_objs(*sops, nsops, GFP_KERNEL_ACCOUNT);=0A=
 		if (sops =3D=3D NULL)=0A=
 			return -ENOMEM;=0A=
 	}=0A=
-- =0A=
2.43.0=0A=
=0A=
