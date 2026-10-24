Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844506;
	b=oSLVdf0QAzSn87lGQmPxBoy3VygslKVmR0IoDkUESjjqN+W7kZRf6ZmEJW3fhHZ+IcYG
	 JL7oFk2owvpVOIPopTjMeg6RWr1wLhLHdXcI28RQv4RcL7DRFji27eKc7Bv669LtWuhjO
	 qg4S36hJXBwIjZRw/INJPOvuVGJMWsLwinuzqCGvcYq4Nu0/PuMvV4stmHT9ovZSydmiI
	 t2Ed6zkG2Lehj/KqOcc6yubWrdkfE4J9pXXGZIHs4VWvxaXKhEODPquWlpm7VrY7FB9Ku
	 3b52u26rHNxKGfGcziZ9bk/j2rfPNV/6/N4zyoOLUHBseKzrcB2YSV5R+hVsm1JOZjA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844506;
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
	bh=gOmA1ZeGF8a3S6Vxtj6eyuD9Thm+qTYkpGAnGLekx8Y=;
	b=enQ/AR0Hmp+wmCQb8hEc1isqP+5mEzz1G9htexaziT9evpZJFoYHb+j4sHuIK7g6k4fx
	 gYGHgg224IPIdflBoZHed1dLLdvndXTe3ZDDMs+Ic0XA4Jyup+rgT0yslofyqPd/T6vQD
	 rZgIUFF0KOS0vM5hfAvytbcKAhHFRktlmpI7UggVMbHS/M2u+rMqKKNE45YEzh6EpY0I6
	 HHankQOJ8+bWP2mRLIu17j2r13yGeipMq6sNbLXx4SAJCezkDSeeMLmPGEM7ZGOGAIgoV
	 0tGwW8qyIUmL5hBgpEeZ/A/WrEX3kYvj8AF3u76Z9J3qkjo0ZKpboA9TH0kDIhv7DOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=vRFw8ujB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.10
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19012010.outbound.protection.outlook.com [52.103.23.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03BF606A337;
	Sat, 24 Oct 2026 12:21:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D03BF606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=vRFw8ujB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NvpkLtYHf8F28dcj6mEml/DZPFAgi9YoE4+HAe9OnX9Lw5xF1cE6gkHbkmBaIpF5lDVm55oa9PTSzexjiy67R3ZlYAZI+Fmz6/LrNv1hQVSgRPI8ExkO3iaqQzPI6w9CiWCHWanTdyxy+mYm/rzzuNMY4MLxDMAaeUr0PvIDwFhtifRu++YjssLPmGn3gDUZm7BzGA/LLLiPV8KVKThNdz4Q4UgBAWvOw5uZetSuCa177ZuoGZ6+BBLp0GWc1cUlqTZESxE8Ie8QM32cAJOrULkVCKvuMjJ+e3DoTjDc5M3qt2+HnqqynU3TVEtzIRsF1Q2JbjT3P70GizTAIGQnhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=gOmA1ZeGF8a3S6Vxtj6eyuD9Thm+qTYkpGAnGLekx8Y=;
 b=kcv3I+b6PfbBAe6NOgjU9pRS2e8STRHsWym63rFBGEi+jdGGEJSorliUTYtx2RNOaWLf6cL0i5yWhAAl71uoUg2WffdHM08RX/A4Gn4RvtyeMTW4agDp1qM+7cEZyeLvigA93CTvZxWWX7O9dgGoHWvdwSaJDgDhZDUEJDzrRIGL1ouvx9vnLUdXYGlHVm+O4SA51FYdak7LuN4gpAB8fI+6nxY5JnvN3s6JjSdrahUf4VrKn+leex40YmnCufuqVFDLahSsVwkC0iDv6eD4NoHeFLfWPoEKRKgMB1l3IClV/vMMUkQGLBOEFeFWy6vEYFi3FEaJqjhhyTZSHtWh+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOmA1ZeGF8a3S6Vxtj6eyuD9Thm+qTYkpGAnGLekx8Y=;
 b=vRFw8ujBXi20xwulJcaHIG+Hn74bbHu1C+GBsyT3iQcVv/j3B+LWcLyOMxR1Nr95ED+lZhTzaceF9QAqR5Yd8pu1VopZjyejU+WLyR4Qx1IgVnIdr+yRM4nQx/cEyA8MvCLndK2cgNwPczWRWkHzAmc5fT+ZCKA11Lpc/DHg3NpJHY1oIaD1Yxp1XSURVie0heRkzQOv9+sGkJKiq+SiwfoxdcRJ5x/g9hMJQ8gcRZuLqnVVLncRODJFh6G9hFoSudOYwnFNd73gEV7Q8hsylmQibi0jZayFva82A23+DlYWdtebtiBebs/pitqbvEzBayWPXBxFAqHSlB79hclInA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH7PR05MB9058.namprd05.prod.outlook.com
 (2603:10b6:510:1fe::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.20; Sat, 24 Oct
 2026 12:21:43 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 12:21:43 +0000
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
Subject: [PATCH v3 3/3] ipc/sem: remove obsolete SEMOPM fragmentation warning
Thread-Topic: [PATCH v3 3/3] ipc/sem: remove obsolete SEMOPM fragmentation
 warning
Thread-Index: AQHdY7I78TSz9U0Vs0GMc6gS5bS33A==
Date: Sat, 24 Oct 2026 12:21:43 +0000
Message-ID:
 <7959bcd834d1579c13f244d4aea7ab655d2b0051.1792808260.git.x-professor@outlook.com>
References: <cover.1792808260.git.x-professor@outlook.com>
In-Reply-To: <cover.1792808260.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH7PR05MB9058:EE_
x-ms-office365-filtering-correlation-id: 0979b97e-1d04-426e-04d8-08df31c95d92
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|8060799015|8062599012|31061999003|25010399006|4140399003|24021099003|16051099003|38102599003|15080799012|24121999003|22091999003|40105399003|52005399003|26121999007|102099032|440099028|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?RmZuQkRiVlhvSmh3U3JHUGUvMG53c0FsTHFWWHNIY3RRYi9XZk53L1Q3NUpF?=
 =?utf-8?B?Ym9sTUdIK05kSEhNU0FaV2RyczhiRlpSTk91c3BycENCbWRNL0laSTJwWm5k?=
 =?utf-8?B?ZW9RL2F0NFdpellMQkhqNDFTL0RBUFpBK0JhcURQYldVVnNPOGliaVRCdDJi?=
 =?utf-8?B?R3M3SElSd1p2anE5MzhjT0tPKzJuNEhkbDQvVGN6UjdnQVQ0VmdkelNuTlNx?=
 =?utf-8?B?Ull6b0dlcCtpL1FWRWZycGhtVTRQM29vbUxaY0wrL2s2ZDZhSVBiQys2QkZs?=
 =?utf-8?B?dlkwRXpmSGVTeDJMbTBPWnl6VzFadzh1ODl5Y1FmSzRnc3NjUXdJbWNjNzl1?=
 =?utf-8?B?REVlUkhXaWx2MEF3N0JaS0tKSFRqaVRzYStDZ2lUSDllNGp5emVwQjJPZ1dm?=
 =?utf-8?B?dkNvQ2dyUk1Rc3dsdHhONU93MUE5MTdLbXNnWFZWRnp6NnFZWFM0eDlCUlRa?=
 =?utf-8?B?OUlXVUpXSkRmR05sMi94ZERZd1pPdVNjOHVUTUtwUU1YWmpySjVwR0RzSEVU?=
 =?utf-8?B?RXJ0WU9oRmh0M3dub0Q2amtOanZSS0RtTkwwOFYvSDQzMWdOS01HT29ETkpt?=
 =?utf-8?B?QkU2ZWlQVTdia0xjZ08rdU5yTzk3T2liUDd6aUhUMFRiWTRHdSsyeFZHdEJu?=
 =?utf-8?B?d0NpenYzZERISTRmZVNNWmJoOEZ2a0krdWhNRGhiU3o5Y0ZEd3dSVWRWYm1F?=
 =?utf-8?B?RVpwM2JFdVN4ajArWTQ1dGFmMjdEKzFPbE9BU3FWRWdMUTQvSFg3RTZmT3FB?=
 =?utf-8?B?VkxsdXRuYkdkRWI4WTZUMWFtNjVTRlNxaWdsazZQelkyRk9PNy9yM1BrZFpo?=
 =?utf-8?B?eUdNR2p6bU5aQjZCcldMQjhuVUVmUU16RVZOMFJ3ZWJJSjRHK0t5Q0xUZEpm?=
 =?utf-8?B?eW5LRXp0cUtLNTJCZmEzSmRsaWpsNTh0WnRyMGd5ZFNJU04yUERjeDZmcmNJ?=
 =?utf-8?B?Z3VqaGZtVm5NQjVEK1A2VjY0TU96QjU3a2l3REtkMjUzamNPempsSndhYkdZ?=
 =?utf-8?B?Rkd0cUUyQzMwZ0ovQm5zNmxScm43b29NQmlsMUZ0Z0FHbXlZMElCTExHRk9F?=
 =?utf-8?B?eXlubS9Ma1JQOHFiNXlFWUl4ZStLRzdhdHdtaXRMZi9LdEtoWEF6b1AxeEh1?=
 =?utf-8?B?QWcvdkQ4RmVtMnNxZUJ3UW9rd3NqczJDaTd0R1VJYkM2aEp6OTlmUGJ1OUxv?=
 =?utf-8?B?SEtwTStxQUZHSjkraE5LTUhoalRxeGQxdGZXbWRNMUNPU0FycE41eTZnNUJo?=
 =?utf-8?B?N3BwNEJ2bEc3cmRDS1pWd0RBQ1ZMRGlXK1orTTZkQ3hNWHVoVFZiM2E3Qnpz?=
 =?utf-8?B?NUNwMnBHNnBrWmxPZFduc0FqL2Z1K042NHp2YzZ1YkxMK0pLK3diVm5FWG1a?=
 =?utf-8?B?WDN1d0d1RlVMN2oyOFQ1Vm13bmdHcDNkTWVFWGo5MHNXVUxZdGpkZkJLRXVr?=
 =?utf-8?B?SnprZnoyZFdEWDMyVlBIWDN3bEFWMFcxYWVrWVJ0MmxjWFFRLzVNVW5tUllF?=
 =?utf-8?Q?0OxTMGiCW3BHFstuZUjjo2meAGe?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MHZJS1grR21xOUp5eTIwTnpnTHRuQm1CWTYySTR3N1JzVUxYbDc2ZEdHZU1I?=
 =?utf-8?B?VC9POFA5MXN2OUxoWWVST1ZYLzZFNzFYRFdRc3lRNWMzRERFbzdFKzRWY29T?=
 =?utf-8?B?Qm5ITzhRWEp0Z1ZjMG9jcVB0R3ZKQmRWdVhJakxydDhPZmpmZDBoT2FITWZY?=
 =?utf-8?B?OUhJM1MraXV3enE2bFNNK1liR1lhQm1MTXhjWWtJRUlXK0VPVjdlTW1aOHRD?=
 =?utf-8?B?dkJNZlZWVkhOTk4rbG9vYy96MGw1bVBES1pmcDdZbUdxc1MxRGFtb1NVcEZM?=
 =?utf-8?B?OHNXV0VaRk9XdDNBbVkxc21VeG81WVJDUWRnb1lGOWpLemJidGdSeFlaZU8x?=
 =?utf-8?B?cG5lQ0NIVHRkcGhFd25FNDRtNDFqbnc3MHRZMXVZemw5Ymx4ODNTZlJ6bGJh?=
 =?utf-8?B?OHhCSkk2OFFSNGJ5VFk5VzZFRzBFYTZMMnRReFd5enhOajF6VTRxaHdEUHNR?=
 =?utf-8?B?c2haN2NQNVVCQlZSQnlhMmVERlIyRUR6WUlrYlk1enQ5dC9wVzBOZlhWWnRu?=
 =?utf-8?B?RFgvWnRCK0xlbm5RdzdxVHh2cFBWUUdKRUM4R0ZLSHdvVUZrSnBpdExBTHF1?=
 =?utf-8?B?bUZHUDd5TkswNXM0UkhVYTRTWm1SUlg3UXZuUFBQRjdPWkF5NkVBTHl0azIr?=
 =?utf-8?B?cVFkZUVVY0VwT1lQNmR0UUNhbHpSQUpvYlV5SjF2c09PVDM4Z0RsSldIL0Fi?=
 =?utf-8?B?cjZkRWQ1SHZvenJmc1FhdDFPcC9PRC9FcTV4Zmx1SjdUb0dHWWkwZ2dRdnU0?=
 =?utf-8?B?SjUwbW5EcGJjc2tQQzNhSkltNnh2UmlJODl6dkVucVBQWlVScUhGZXN4WjhV?=
 =?utf-8?B?ZWdCWjluN1kxaVg2L3J0OFVoMUJCM3FBdVQwallCYmVONmFXb05pMTM5Sjlj?=
 =?utf-8?B?SXdHeG4wb0doNkg0Z1RQNG9zTm1yYUZ1V2FDcGdoRXk4UEVEZ1RxSStBYmNj?=
 =?utf-8?B?THJES0xKZnNNTlpMQ3FKWjR5Z2pJZzlwcElFY1FQeHF1RXRzZmJnL2VVdmc4?=
 =?utf-8?B?ZWY1a1hUSzh3R2d1RnRpRGx6RnlhanB0bVhLMWVuRVZVQndkVTJXTHlwUTlK?=
 =?utf-8?B?OTlZU3k3QVFiaUVxSjdzaElVcjY4QmFRaUZuMDllRVpaQkQxdU50YnVTTmRr?=
 =?utf-8?B?MGxMYXRrUnRNbkI5UmwzWlJtbHRpVDVjSUlINWNaZ0NxbXczTDlNcElyc3FH?=
 =?utf-8?B?bVQ5b1d4elNRVGdBZ282MC8yR1ZCWkdVQVB2N2kwVEIva3NUcE9ucng5SVBs?=
 =?utf-8?B?aUtpQ1Q3U3VvZFNvNC8xUzdibXU0UlJVL0d3ZGY2NDdkd21mYU5lS1pKYVZS?=
 =?utf-8?B?ajJaUmd0cnVNMHpQdFgyb1NVejNRRm1OdWtQbGhMSFRId0lkWUxXc3dhVGVB?=
 =?utf-8?B?OXY3eHVtemx6VlNVd0ZsanJvY2lpSldOc2dra1lqa3g3K1ZWQ3N0T2ZBbVRF?=
 =?utf-8?B?ZWx3NVFFSm93dUF1S0lYK2ZCVWcrblhlOGpVZm9wWHNDcHN3bnhLV3UvdlVK?=
 =?utf-8?B?QkhJNER5RUV3aDRlYnAxdVhlbHVrd01qSVROc3k2V0IzQmJDangzVE9PdE9K?=
 =?utf-8?B?TkYvc202R0JacVpOaFdnU3FmVVQxcUo3U0V4TmFHN0VzcUpIamFKTVptcWpZ?=
 =?utf-8?B?R21sZG1rMWNmeUxXc050amltdXRseGNlV0MxM0lYRVloYThBSEJ2WUdjclZ5?=
 =?utf-8?B?alMxV1lncTVYMytCYUpEbGNqR1VBRWpJSWVLZHhUVGozdlFraEd0Zmd4NFdo?=
 =?utf-8?B?cEhQeTNXcDB5RmExUWphbCtKZVJpcFpNMXBKYWhnUWk1dGhGWFlUSERDSitF?=
 =?utf-8?B?WWNRK3IwVUJjVDRkRlA1NFRFTFpXVFRRTnFLRXZMN1hQS1RCU2RETjk1U0tn?=
 =?utf-8?Q?ewY5ANLcIgXdM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0979b97e-1d04-426e-04d8-08df31c95d92
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2026 12:21:43.7422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR05MB9058

VGhlIFVBUEkgY29tbWVudCBhZHZpc2VzIGtlZXBpbmcgU0VNT1BNIGF0IG9yIGJlbG93IDEwMDAg
YmVjYXVzZSBhIGxhcmdlcgpvcGVyYXRpb24gYXJyYXkgbWF5IGZhaWwgZHVlIHRvIHBoeXNpY2Fs
IG1lbW9yeSBmcmFnbWVudGF0aW9uLgoKQ29tbWl0IGU0MjQzYjgwNjJjMSAoImlwYy9zZW06IHBs
YXkgbmljZXIgd2l0aCBsYXJnZSBuc29wcyBhbGxvY2F0aW9ucyIpCmNoYW5nZWQgdGhlIG9wZXJh
dGlvbiBhcnJheSB0byBrdm1hbGxvYygpIHNwZWNpZmljYWxseSB0byBzdXBwb3J0IGxhcmdlcgpj
b25maWd1cmVkIGxpbWl0cywgd2l0aCB2bWFsbG9jIGZhbGxiYWNrIHdoZW4gYSBwaHlzaWNhbGx5
IGNvbnRpZ3VvdXMKYWxsb2NhdGlvbiBpcyB1bmF2YWlsYWJsZS4KClJlcGxhY2UgdGhlIG9ic29s
ZXRlIHdhcm5pbmcgd2l0aCBhIGRlc2NyaXB0aW9uIG9mIHRoZSBjb21waWxlZC1pbgpkZWZhdWx0
IGFuZCB0aGUgcnVudGltZSBzeXNjdGwuCgpTaWduZWQtb2ZmLWJ5OiBZaW5namllIFdhbmcgPHgt
cHJvZmVzc29yQG91dGxvb2suY29tPgpSZXZpZXdlZC1ieTogTWFuZnJlZCBTcHJhdWwgPG1hbmZy
ZWRAY29sb3JmdWxsaWZlLmNvbT4KLS0tCiBpbmNsdWRlL3VhcGkvbGludXgvc2VtLmggfCA3ICsr
Ky0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3NlbS5oIGIvaW5jbHVkZS91YXBpL2xpbnV4
L3NlbS5oCmluZGV4IDc1YWEzYjI3M2NkOTkuLmQ5Zjk2MWExNTkyYzcgMTAwNjQ0Ci0tLSBhL2lu
Y2x1ZGUvdWFwaS9saW51eC9zZW0uaAorKysgYi9pbmNsdWRlL3VhcGkvbGludXgvc2VtLmgKQEAg
LTcxLDE2ICs3MSwxNSBAQCBzdHJ1Y3QgIHNlbWluZm8gewogICogVGhlIHZhbHVlcyBoYXMgYmVl
biBjaG9zZW4gdG8gYmUgbGFyZ2VyIHRoYW4gbmVjZXNzYXJ5IGZvciBhbnkKICAqIGtub3duIGNv
bmZpZ3VyYXRpb24uCiAgKgotICogU0VNT1BNIHNob3VsZCBub3QgYmUgaW5jcmVhc2VkIGJleW9u
ZCAxMDAwLCBvdGhlcndpc2UgdGhlcmUgaXMgdGhlCi0gKiByaXNrIHRoYXQgc2Vtb3AoKS9zZW10
aW1lZG9wKCkgZmFpbHMgZHVlIHRvIGtlcm5lbCBtZW1vcnkgZnJhZ21lbnRhdGlvbiB3aGVuCi0g
KiBhbGxvY2F0aW5nIHRoZSBzb3AgYXJyYXkuCisgKiBTRU1PUE0gaXMgdGhlIGRlZmF1bHQgbWF4
aW11bSBudW1iZXIgb2Ygb3BlcmF0aW9ucyBwZXIgc2Vtb3AoKSBjYWxsLiBUaGUKKyAqIHJ1bnRp
bWUgbGltaXQgY2FuIGJlIGNoYW5nZWQgdGhyb3VnaCAvcHJvYy9zeXMva2VybmVsL3NlbS4KICAq
LwogCiAKICNkZWZpbmUgU0VNTU5JICAzMjAwMCAgICAgICAgICAgLyogPD0gSVBDTU5JICBtYXgg
IyBvZiBzZW1hcGhvcmUgaWRlbnRpZmllcnMgKi8KICNkZWZpbmUgU0VNTVNMICAzMjAwMCAgICAg
ICAgICAgLyogPD0gSU5UX01BWCBtYXggbnVtIG9mIHNlbWFwaG9yZXMgcGVyIGlkICovCiAjZGVm
aW5lIFNFTU1OUyAgKFNFTU1OSSpTRU1NU0wpIC8qIDw9IElOVF9NQVggbWF4ICMgb2Ygc2VtYXBo
b3JlcyBpbiBzeXN0ZW0gKi8KLSNkZWZpbmUgU0VNT1BNICA1MDAJICAgICAgICAvKiA8PSAxIDAw
MCBtYXggbnVtIG9mIG9wcyBwZXIgc2Vtb3AgY2FsbCAqLworI2RlZmluZSBTRU1PUE0gIDUwMAkg
ICAgICAgIC8qIDw9IElOVF9NQVggbWF4IG51bSBvZiBvcHMgcGVyIHNlbW9wIGNhbGwgKi8KICNk
ZWZpbmUgU0VNVk1YICAzMjc2NyAgICAgICAgICAgLyogPD0gMzI3Njcgc2VtYXBob3JlIG1heGlt
dW0gdmFsdWUgKi8KICNkZWZpbmUgU0VNQUVNICBTRU1WTVggICAgICAgICAgLyogYWRqdXN0IG9u
IGV4aXQgbWF4IHZhbHVlICovCiAKLS0gCjIuNDMuMAoK
