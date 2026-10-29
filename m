Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793250209;
	b=DCgojIo752Fd7NHGOGzwxC+JuInEyZqcEBIjGaetpvUjrd+zHcStUnnNktiphYZySMDx
	 AqLDFYgxE6q1adKgUtnAIW4MGI7qfrxWaqKuJDCEOnIkLIx69z8FQYJbu/y6rJcz1y+VP
	 0Bxur0OxzugdhwBVRxcGNrCvLM+KJkwUFo0YDSPCapEr8g7lOM7gU3cIWpGONp3HZL4HZ
	 7HLzdtnCC80qm09WWY/0Yz7q5bj1Nr0+vt1w9fg2m4AxW8jH/2Cw05yWvAXQM6O90RMle
	 2Grq+ncU7aVFUcyjDYPMGjk0t1OOMCzkQY/JKrxolZHshDpMie1nnXVEyQNUkVbUdwA==
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
	bh=OeqvTs33sllOBmoFkFB/V/hJuGmDt0nmu4aOzin5sZo=;
	b=uaBVOCspiheG4Bb9c674r38afnTCP9fkElFX+I9+S2LsF8GwzVsUYUi5Fi9ZI38zP2FJ
	 wldZx8HXTFcDPFZIeDPfSnoBUQITxxP6brAO2nhWN7c5amombiVVu0xPQaGRSJs6y/JBy
	 8lQ/Dl2y3I69kMCXlUoKrFSf5hp5c7LgYp+oR3bWV6rvJC9qKHFT4IBjb2lA4ZLT2srgm
	 2NAGhRuWPA5HrvAyH+kaJvye4GmEeUSw7QfctUlaF07KB3fazmdwi9dTZX7W5DgYBMF8t
	 8GhrauyKmRv7s7laFzEGP0lI4v1+/UMWBTNLAjvLHNkZBLSt+U2tNnfhQUy95cwhgww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=tg3hpjTN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.6
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazolkn19010006.outbound.protection.outlook.com [52.103.20.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E309606A339;
	Thu, 29 Oct 2026 05:03:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E309606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=tg3hpjTN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qm23j+x64ZyyEymXQQWG2iehwCczFNtFy/zW/1olLyWQ/iRZB4BOlSYnoB3DnD7v65uqSHfYuAlgTARe+uToT3mGuQ84id5J1If3rbxoPYQct/7z+JxdoBW7P5WCzmq0UBahcw8pWjmk7ttSuo/mm6yW3Zy+WjPwM/6FcRVT7F9YpENEaoFILKIj+/rNBuhwm2V74zJ8uPxWrlD2mM570XMfXnNx3ysjW6F4fsEkZUWOcrrAxFC7G2xiHwYJklM+uiTDXanpY0MAZYLC7ANnXL0PKL4zMPnu3BCBMBXMw/01uiJF/lJEq7EPaesCtXcRbnHcLZBu11jU2F3P3bsdRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=OeqvTs33sllOBmoFkFB/V/hJuGmDt0nmu4aOzin5sZo=;
 b=jp4I5JYU45EzRaZJg/2Ipug82SG2g0v4R0/UsI5iNSfgj4Illo3lHZ4ZKmnyKxXQ/yn+MdT7LpP/Pn/yOwILmdJnH7m08IUskAVruQdAJc37efpXOv2I7+f2ZSoN9BTcoQYhbVWC50OAG5OK3vfS5bkbVnqzuOesE3iqmfKMzc/6z1vmFfWW1ZhjsIJQefj1g/C1KslOzSdrjIrXcPWyY7CukgqfmqMPWP4bMmu++RXvU+UHIn9NuvLkwGNtORWKbnWMNJtyR70n6rwKOfqzeKNC+jBV32gbCzyflq4fd2AzLafNqyN2b/WHMkMG5u2yR/5UtwvsCe4SB6avZB+wwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OeqvTs33sllOBmoFkFB/V/hJuGmDt0nmu4aOzin5sZo=;
 b=tg3hpjTNALaZVSiZCuZFZjoYqay08qkVTBqReYGr98TqyEMU5+8Sl2VmvpQrNHFri3jMtDtKtaL27p6ULs7xc9KXXJUbwFxJmJGnznA4yOXZ6bEBZCL3NzApY4Bbju14INPZcFjxOSmTM8bTM/tRcC0rnAhf404W+AlGdF3JzglItl/JdjlP0w1LJ1K/a7yi1CU66I+GzYxJx8+L32Y5HnXubABPCMZjutn0+1u6FYYIOySg3a81Mizsmr1aA3YEt6FPIVbI/l7m0VCfogEi9WEgeZ7g1nauhl7tFi3L3ZKgqHZV+xcLfNSMFgFShx0pYdDOVNQSImd7KnjB7RVE2g==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SJ0PR05MB8214.namprd05.prod.outlook.com
 (2603:10b6:a03:390::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Thu, 29 Oct
 2026 05:03:27 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Thu, 29 Oct 2026
 05:03:26 +0000
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
Subject: [PATCH v5 2/3] ipc/sem: reject negative SEMOPM values
Thread-Topic: [PATCH v5 2/3] ipc/sem: reject negative SEMOPM values
Thread-Index: AQHdZ2LU22t+v9LvPUKy5B2M3Dxj6g==
Date: Thu, 29 Oct 2026 05:03:26 +0000
Message-ID:
 <16988f0510fc9ebe56c4f337facf92071fb52355.1793250194.git.x-professor@outlook.com>
References: <cover.1793250194.git.x-professor@outlook.com>
In-Reply-To: <cover.1793250194.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SJ0PR05MB8214:EE_
x-ms-office365-filtering-correlation-id: 9d1a1a8b-c81a-4d17-ed59-08df3579f77b
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|12121999013|38102599003|24021099003|4140399003|15080799012|19110799012|8062599012|8060799015|25010399006|2604032031799003|22091999003|41001999006|24121999003|12091999003|1602099012|10035399007|52005399003|40105399003|26121999007|102099032|4302099013|440099028|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?tqouZ+bTC4O3E9z0Aizflzh+O5KMw43XLvdNPSwOe6+CpRL/r/jO3grgSq?=
 =?iso-8859-1?Q?Qeq5RjpfAWWsg6GbKE6P5ZZznb/0G1D0wVnYeb/5slcDHW/LaBjAVX1QE0?=
 =?iso-8859-1?Q?HMq/f5WZi6ZW+o5+w0S8b9Q18/QXrT+wcXaq2jcAEzTgQDkQglHFDxRerC?=
 =?iso-8859-1?Q?AsY0Sq+TJd7Qza7VimMK26JzwU0rsQZyFWgGNAtgWf95GnHKFtk3TMsw91?=
 =?iso-8859-1?Q?QmCbzwbO7fzJw4VOEYSZJyhht4KKek17Ns74SHmL+GAexXbS8dctCX6xks?=
 =?iso-8859-1?Q?vqUqsGCboCso/tjsi9a/UsQCgSdEpH6Goftrr69t+PBPv0nfr9tfa+CrNh?=
 =?iso-8859-1?Q?Fk08bKkK1E5vYudkilzxvRQznXcMS3DZKJClFnaFd4cKfTDXfJHAhdQA17?=
 =?iso-8859-1?Q?OWmkCgB4emGBjzYLNxRRN9wncHcTKAIaz85x/0wepRI73o5bW3tvNSGnY4?=
 =?iso-8859-1?Q?517EC24rArTTWu/TUIxkQcQRS3IKCQsNXrAI2FJ1THxpRCz2SN9egic5jM?=
 =?iso-8859-1?Q?oxn6H1Ht60vs89A2ZHSJQ03s15pX33/Og5AkY+mMfXFlwjylU4P/Rk7sPT?=
 =?iso-8859-1?Q?9HZ+hWshP8SVY5EUNnhOWjxIiKH0RSg4UlIRugifWdZTYUxaHKhNF5ay7K?=
 =?iso-8859-1?Q?jvzTMD81EeC9crwkBuMhCiGDBLJOz8O2OuJyHBeQLQA9Mm02GLtl/bub3t?=
 =?iso-8859-1?Q?BkFxZ6JDzNQV/jSn+yEzHewqYxof6dW4qn3AOZinUa/9Dthd7Wlqa4JE4G?=
 =?iso-8859-1?Q?yxIRGavU8MP2lCy71JxUnDiNrzc+M8a3kSb6Q4fRI5AZOsIk1UENwwch9p?=
 =?iso-8859-1?Q?l83Kg1AG0zVbiQ2pPjjXakOvjHP7CWma9dlMmVf9D1PWw3H08dYe9MVyuM?=
 =?iso-8859-1?Q?iNvAM4l47bre33oqXOaXZDDXBBeEi13o7o5woGD8nGyAX1autWXZOF3fxL?=
 =?iso-8859-1?Q?NtSwScHNteDJoIghuqOGeLu+SIdj+OVj4HyVl792rWnq2tdlViK7t3tb3d?=
 =?iso-8859-1?Q?tvl9TIMuEEHxUepSatLPdcOO4J4TVdj9LgOSKKQ76XBhU5+5UVNrhfkzva?=
 =?iso-8859-1?Q?K7aR0ar3FbHjYDEER3lACFETurBhPMroz1xFKOd5ECnmGYylLrUXWyEycu?=
 =?iso-8859-1?Q?/ftOtmLHNwxZtyznZz2hnjfRMT2XwRzoas83p1JKIwt/d2cyWohgH/Zfh5?=
 =?iso-8859-1?Q?eCr88q3Ra5SNKaajWB+op4VlFk4BTNqDV17AVZ8wPVC5KLbW6S3X2bFGZf?=
 =?iso-8859-1?Q?eQwnTvGco9Sx37yjEDfAlX3vZkX1C9CB/j9/y81zlqIUsi12zAwvPlp3tp?=
 =?iso-8859-1?Q?+flVXirnv0scSRT07sE5fht/Rg=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?4LdFYKcNnaHWIj+EWkw7oJeTUqI/uSWezlcVu2Z3txpwCq0kh2owLhkuFA?=
 =?iso-8859-1?Q?p6m79azonk8C8HW7yZbmL94YUsIfe3ez1Mx7yx1AeD0Rbhu6rSd2qGcG74?=
 =?iso-8859-1?Q?SvpenmzJpFdKJeIyz/WVPabwTeuZSHn4OGIliD4ZZkmS4+SDfz2yozebk+?=
 =?iso-8859-1?Q?SptzmCFapQZi64+r3nD6SzRahQXjOTNDQJLNTip5yY6aKSXCmeeI0PZe5O?=
 =?iso-8859-1?Q?dTNhwC+X7JKkHMsaJlj1/kkdBaZh8pWW+3v/T2FFQa/HyTe5c2B7ri0Zq7?=
 =?iso-8859-1?Q?749r2WuNQh8U4y5XJqBd/WKtqiYfWrAX+XcAlWok+uKttutPlnggtM0xXp?=
 =?iso-8859-1?Q?Nj1za3miievfQzixf/uBwAACZQ6wv1Xetb6NNMpdM1ja2/qLNOIU/qlvCM?=
 =?iso-8859-1?Q?yFHH2JMpgwdU0mqR9PiXtiWiMVQUhTij1vmq8l2zJTP0sp5MdPxHmyrYnG?=
 =?iso-8859-1?Q?80rwlAuWQJeGvcmk/F3WkFee1VPCrFpd2g0Dg2pVP7fmFtGATqT4jt4Wfv?=
 =?iso-8859-1?Q?njMUpo82xE0cxcIhe9fau7ZXmmTzZ/OuKSkNfZRcjVlkE3hPrjsEY0QkGA?=
 =?iso-8859-1?Q?UoCkca/6CyNIRs9TVsD6duobMvZzHSY0gWNoBnft+LK7kioaxFTuN4gup/?=
 =?iso-8859-1?Q?pMvoevAyGNRGrfq+YQjMnae1uhqDwCmWQ/sxn41YlkNjzAIFmIG4bH0qvm?=
 =?iso-8859-1?Q?8iX/5HkHbq3tE5YkrXVuF0q3OyT6l6oi5erMzWjaZzKY4ihvrZPym5lg7y?=
 =?iso-8859-1?Q?o9trYM9DXG3wW9Ku8mz9YwxuCaTLBY76r6Foygud4mjLl2ZacNww1GxQfL?=
 =?iso-8859-1?Q?hD43p/mbzsFlAyNB05ARVGimqTc+I+cuoz4N3xFhgLc+xslxuXWyDVvzxy?=
 =?iso-8859-1?Q?ZJERwBy7Ag4zELswasgSbgYGXOgb6xhcXQjLai6oo6e7v0rPGoD48dAoiU?=
 =?iso-8859-1?Q?9R/HexuvBKTp8YSkoYkBgDa6GjkMDbfdAWqQOyDphA5vaszLHGi6HY0EE3?=
 =?iso-8859-1?Q?r41fDDa2UqMlCuRrkg8IlDIbf6mxCEwl8nmfRBQ3M4hIEFixBWYEOrgCp2?=
 =?iso-8859-1?Q?R9VOwj3U8IabZLRSeIEPzmcpsPgSJxdvGto2pox74+1UMpJNWRVM3q+OvY?=
 =?iso-8859-1?Q?HlJXetrWY27GcxpuTVEpqDsnH1mXKxbTIFjZ+cAaVCgio84TWOaLjJp+kz?=
 =?iso-8859-1?Q?K9VtuvTFQqtotymULCSnNGqlTwynOxSvsNdTpHLyDVAGuFt9NnwTXnzwXI?=
 =?iso-8859-1?Q?3nOhH7WQ4GThWJGL6Epk17XIMXqhgcBOwJyjs5rMjJM8G0SrCyVZX3C89M?=
 =?iso-8859-1?Q?8q0FLR6/9sxfWf9XP/btx+YHiO2qMQwo97Rxts3eY3mMVBTQith8cV6h+n?=
 =?iso-8859-1?Q?E51/bC4u+8IFpP0LUo1uYweyIxT9/DIJx8Jya5TLXCNBKQJX7QZvqYAS+G?=
 =?iso-8859-1?Q?NfGWifTqkDRaJPdz?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1a1a8b-c81a-4d17-ed59-08df3579f77b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2026 05:03:26.8895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB8214

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
Reviewed-by: Manfred Spraul <manfred@colorfullife.com>=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 include/linux/ipc_namespace.h |  3 +++=0A=
 ipc/ipc_sysctl.c              | 35 ++++++++++++++++++++++++++---------=0A=
 ipc/sem.c                     |  1 +=0A=
 ipc/util.h                    |  9 ---------=0A=
 4 files changed, 30 insertions(+), 18 deletions(-)=0A=
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
index d038d944257f6..0e3608258fe29 100644=0A=
--- a/ipc/ipc_sysctl.c=0A=
+++ b/ipc/ipc_sysctl.c=0A=
@@ -51,21 +51,38 @@ static int proc_ipc_auto_msgmni(const struct ctl_table =
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
+	ipc_table =3D *table;=0A=
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
+	if (sem_ctls[2] < 0 ||=0A=
+	    sem_ctls[3] < 0 || sem_ctls[3] > ipc_mni) {=0A=
+		ret =3D -ERANGE;=0A=
+		goto out_unlock;=0A=
+	}=0A=
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
index ea95cca5bb0ec..098e483ae8d3c 100644=0A=
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
index a55d6cebe6d3b..51b4efa3d6db0 100644=0A=
--- a/ipc/util.h=0A=
+++ b/ipc/util.h=0A=
@@ -245,15 +245,6 @@ int ipcget(struct ipc_namespace *ns, struct ipc_ids *i=
ds,=0A=
 void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,=0A=
 		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));=0A=
 =0A=
-static inline int sem_check_semmni(struct ipc_namespace *ns) {=0A=
-	/*=0A=
-	 * Check semmni range [0, ipc_mni]=0A=
-	 * semmni is the last element of sem_ctls[4] array=0A=
-	 */=0A=
-	return ((ns->sem_ctls[3] < 0) || (ns->sem_ctls[3] > ipc_mni))=0A=
-		? -ERANGE : 0;=0A=
-}=0A=
-=0A=
 #ifdef CONFIG_COMPAT=0A=
 #include <linux/compat.h>=0A=
 struct compat_ipc_perm {=0A=
-- =0A=
2.43.0=0A=
=0A=
