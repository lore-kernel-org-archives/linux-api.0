Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794817257;
	b=w+tDoTmZpvxD7DVaQ3dcfykWQzzrVF/g0dQMIEgw+7YCLrdv9WrNAOcAUfyiX6b3EI1D
	 ajLgBXxChV/yOjgudsWxs++Vd/tnCg08+TS78+iFe431EJFh85+2NgH4yk60yk7VLyQh+
	 4MsAxJH4W6NmumzX/7BrVORTTUKcRg3GX82Lc8QNP90w4jw99HrIdKE0W1ayfQdnTTry1
	 yhOegxgoFEb9plUdN4vGxHZ+myeHv5Xw1EvDHjSDFOtPrlROm6Zo9fdVWIrcB+YmnPiuR
	 p38oWRxuzetThg4eCST6ILxO9Ff2QPj31rh3LpBm51T8t1Fn22kWtyYFfWQAFoYq5NA==
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
	bh=LV75gPEq/TFRQa8+5SqUEjip1P/9VCGH8F9Te3QlPIg=;
	b=GJh2XaZO6awsyaOzEqrxKbclh+GOxziKIPqK9YducKtjGJV/X3R5jmYzq4kv3BMiPsjc
	 d/bYvElyazXIYW2BIGzGPiFZ1mK2xUxYxp06v31pFN5mohbLCsNcJaloHS74Zx3Y7YtXq
	 H1kxm8xCWs7Zb5iQ2vDw/Zo+ENLFVk9rSL5jXvHiWHydNjzw0nCRi9Q6AelkOBLlS76/Q
	 VRPouY8rq7HrRs8gFr9n8Tpg+7O1ajZQFSC1s126imnXsDJ0kGgClP6RjsjD1mplQiszs
	 LBoGLLjkrx2g7DsPfminFChSMq8avwgXXA+DVneFYctA/+Y7G4V+3kGJB4RANbWP+eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=n9wJ9V26;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.12
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazolkn19012012.outbound.protection.outlook.com [52.103.14.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C00606A880;
	Mon, 16 Nov 2026 08:20:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57C00606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=n9wJ9V26
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QUI0gGm6crwXRsN9YpO6lt1h1EA5uO9dQKNRbj62jHub9wFNQ4+y9BdZqdftGzqejMu+6UhL7aMvvZBuNcrZ34I0KnaCdBarqADAVzYBZj+FovWXoMdQhAqn9NeZmrCZZqfburH3afdk51BwQP6ko7x+vKr0Vk65TZCkmpE8DSN4ffhW9dNTCGmI29aZibqAEJd8imneD5WRBjhkUktfkyGMRfYVwKZ53SQZxTNI7kJYNZJaw2ei5XZetO1M4zP71tqUDil2+OaNAZaC+r04/G719j/AgulkxTzWPq9xodrAq2KBPh7YuIfZ3EJgiBEvZ8wEDDwGdRxKvugjiblByw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=LV75gPEq/TFRQa8+5SqUEjip1P/9VCGH8F9Te3QlPIg=;
 b=OwwZ/dm7vRVMQK3y4p5coidWTqjtLt91fShGQKxCRTKkXuQnWUH+Le/UA06wAgjnp99L7yp3rX2iXWRBQ5ZvQhHvsgBO0JO/MBrkJyV6ZOw+AFfcuLEWITHEh/nj1F+eC+MIQhBkVlYxlp2XB3As/EKlV4SMNPxt/NvPVZ7JVNrhES3QvCKCHApAvuoj0SBCqkxJFc9rvuLXM/AXas5SE3QNyboxe6lmpN9YJk1lJQR3dVTyvwa1MM/pRaQe9x/q+VymguilAoYFcoEJZQl57/xSu35xRAPEXu/euAWogMlSF2rWA1i/ow9/yE1gjLncoMzM3JsLi6aZgvDyHdwf9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LV75gPEq/TFRQa8+5SqUEjip1P/9VCGH8F9Te3QlPIg=;
 b=n9wJ9V26ZLAKogD8Cuuir0e4cfljb2PzS/Ukc3zTzpgxm9FO8cJ+FCLj6t1hDdChzAj2J2BcV3CWvOygPr8+twYlF3N3MN0XQbAQdHwfXP/tq5YKWa/6ZJs8scgBqt3REFYwrhD6u9PM358HZEdfnlIqnbEuZZs2wnPqEbbNZj9VmcrkzmXF4TGtpaBxhXsrWol2h5xSD330sn0y/K3nH6CXJc8fQPKOxeW8b65jh8PxvvD8MLjhljnzBXx3dRhnkc7nCbtTHQLS5Jo8+TxhtOaRyL9/xZcmhfFrjHJ+LKu0NhhfvwTsBC3leif1wGc+lwndqbVKw+RvTG2Ob68W6w==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH0PR05MB7948.namprd05.prod.outlook.com
 (2603:10b6:510:75::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 08:20:51 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 08:20:51 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "manfred@colorfullife.com" <manfred@colorfullife.com>, "legion@kernel.org"
	<legion@kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>,
	"vasily.averin@linux.dev" <vasily.averin@linux.dev>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "mkoutny@suse.com" <mkoutny@suse.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "alx@kernel.org" <alx@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-man@vger.kernel.org"
	<linux-man@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "dave@stgolabs.net" <dave@stgolabs.net>
Subject: Re: [PATCH v5 0/3] ipc/sem: account dynamic sops arrays and validate
 SEMOPM
Thread-Topic: [PATCH v5 0/3] ipc/sem: account dynamic sops arrays and validate
 SEMOPM
Thread-Index: AQHdZ2LT/+5o4bKjo02vICQcsvNQYg==
Date: Mon, 16 Nov 2026 08:20:51 +0000
Message-ID:
 <179481695440.274194.12546320832881142047.semopm-andrew@outlook.com>
References: <cover.1793250194.git.x-professor@outlook.com>
 <20261115141206.920bdc8c5a84073712bb5c3b@linux-foundation.org>
In-Reply-To: <20261115141206.920bdc8c5a84073712bb5c3b@linux-foundation.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH0PR05MB7948:EE_
x-ms-office365-filtering-correlation-id: b9232794-801c-44d3-a651-08df43ba86c1
x-microsoft-antispam:
 BCL:0;ARA:14566002|22091999003|24121999003|15080799012|24021099003|11091999009|21061999006|38102599003|31061999003|8062599012|8060799015|12121999013|19110799012|4140399003|25010399006|102099032|3412199025|440099028|40105399003|53005399003|26121999007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?C6pG2AgYRCzn9fF7EBX6yTv3okPOW9wguCmpOFW+A9HmIcJHCw5z/XRhvyHP?=
 =?us-ascii?Q?23oylwdVmZoXoPdQIjsh1yOzIHRBI3N05xM5C6TXxV72RTlJ2Va/I2Ov2pMB?=
 =?us-ascii?Q?ErGmYBK7tB1iwcRp6ffwCq04+zN0sFlA0nCZttqIIH+R+f0a0Hb1TGAcP3NV?=
 =?us-ascii?Q?EPBheFz8lni0l1FoHW9TbyVl4PxmVbOh2IxOGF2tNjIu+YxvKKmTHeJD4+hC?=
 =?us-ascii?Q?5hpI/3I33uyIcw19r+Ux2PSXzui+Gd6mhrZqwic4vAgonjUTV+WsONNDIJTu?=
 =?us-ascii?Q?lH5Ter5Bzm61tOZCg+2MVC9Clu0uc3S0mc02ARNvNG/tL6v3hzKCkbat+7Le?=
 =?us-ascii?Q?bBWV839Y+gCp1W16LNAnuM40mjsyabzygeBAr1908yujCCBORiwfYisnPhYU?=
 =?us-ascii?Q?aBAQvjZ8S+Jp2jfKiqNeDgpjmkOgBzJ8m+8ZCGq3m0Zze/hFpm6Th49ZG4HU?=
 =?us-ascii?Q?fo5R5WsLgk0HfR3XQduBsXecE64h0h4jzdoajLkmSYVB8KH7QWuSOLwPbfr7?=
 =?us-ascii?Q?X555zUf62rSHCP9ycIwnJKmDSkIfLUnbyG7MxdMmDFD0yPfgYVG9hHgC+ADb?=
 =?us-ascii?Q?ZH4cuWbCK30Z+Vql1sGcaf8Xrrj1Aaqpkqvbj1wOJSala89A4R/wfEG24Te4?=
 =?us-ascii?Q?nT9n/JmlDyYzefFvcAx6/RB4J/0FJ94dThfX5lOgTqqw055Wii0wSgVRA9zl?=
 =?us-ascii?Q?TnmMpR/IPSLc4OV1TMMVrNmvAuU4YraVBlCngj6JLqIhWJLGYrFCNOP85K2H?=
 =?us-ascii?Q?3jv7eVqDSu+79DcG3EK3ay8dW52Xo/Km50Mqk9JVQmiov2AjMYTQdvKonIi6?=
 =?us-ascii?Q?G/RtR+1zUa3Q9yR5Rit8BNYtxHXks14+i04+bQJpkpW0kba96rt1+wbaUO6B?=
 =?us-ascii?Q?TeLWAGgB7yrikAfmUyMK2xLmD/ruoK4F2QyJ42DndX8FHwCc+BHf5mp559dw?=
 =?us-ascii?Q?omwF7ylRrZP7HMYe3dkwX1k7DmAlD6aWrw279+XoQaBcplyeQZm+43pgUkSE?=
 =?us-ascii?Q?MboVa9/mI/pddaJ9aYt4gqs5nVWI5hHpdslZsqI8vEB7IkpAw5UrJvD5H15a?=
 =?us-ascii?Q?gxQVo3dzCAYBxt0/aQ45sCjXX2Q7Qvii/iBdxY1CE5ncNGGAsJ/rLArZLA2f?=
 =?us-ascii?Q?FTaADfzgglU77TPp0tsfyG8wU7UmfWzJst9t5RJTx8kf8UhoZVq+CH0=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ACMExILoYiHqcisHxPKY///l26R2K/ZDCxEVBKdDA5iB0J/Zb+L1tNtGXKEY?=
 =?us-ascii?Q?QxQUqDj/OMjUJ82WBKSxw3mf6ynEn6WIl4qZyc22VQ/zjXDaWVkxiC7s+EYr?=
 =?us-ascii?Q?lK20/FOMH1jKoPoaYUlAP5eaa2PRxjxQb9XcFqrZCdCLcOVdPFO3/Vs/JCZD?=
 =?us-ascii?Q?PLboLTUCDehEFByBakwQyzWOt2w4PDQxQYH6QOjpl9sS6ReDiLMkNJNnqBhd?=
 =?us-ascii?Q?xJexYdxRK2jYM5jIZaVIaxKfH+LFaEaO2uRyJCfo0GGW+YIRzH80jmzgTdbq?=
 =?us-ascii?Q?xoqQzNR7E4OKm8zgTTpjAazRv+GukAaa9H2TAI9OzzmlsRfW/0RLxOchmFh8?=
 =?us-ascii?Q?mJRu4Kjah0kBVVNwKR7qGZ+Fd+w/HMu8QAAuqDbpIq3eBBZg3fcVq0lJGMRV?=
 =?us-ascii?Q?aKHP/O9S0E6NedKI9aDHg30tBs6rl+y2Bl6sW5C/houSEbriFb78aqAkeJA9?=
 =?us-ascii?Q?LZBPm40Et5mtwI51Zeqh4HFzk/ZEClsenIkZ/CTGQ1hSdFmuIVI5tRqIgMCy?=
 =?us-ascii?Q?UvTLXfEVI8WCK/ZLxt18RPjomwK/zV6AhxsupHh+uuDkF9VHVnx9SMvFp0/P?=
 =?us-ascii?Q?JCZJ5OirEzJ6p7BXvMCK/g5f6cDVCtvarHRlBzfL6z0yOUrx74L/JYMjQH7i?=
 =?us-ascii?Q?6j4SwebeGQ/+e7dgwe4gZaQUeaJprJUYdLqvFZiqbmpi6adbrYwFSwa8Rix2?=
 =?us-ascii?Q?RbBpWxAUoIdwOSxeMxGUu8Bo89xJi1Lp6lXx/iINH04PHqyZbZr4viRtixl7?=
 =?us-ascii?Q?LgdDH2ahzyRQglK8J/vFniAkeS2hXb1pt0pwpWgNCu7yMV4RkfED6peG+xBI?=
 =?us-ascii?Q?EqkUV2sXKH3QpiP4jkoeLGOwRxpe6qhOgaQc+lX+CL+fRfLtmewll/jWyF+S?=
 =?us-ascii?Q?WnRjsjK8eaLPptfd45ocpkJFHqcpo4liJldTyF7rZPd3hCJZtrcdOZLDCbib?=
 =?us-ascii?Q?C3taLtdGIs4240Aj2PXtsaUisEHwRxkRKKg0IL8Qyh/P1YAX6SqlwVIAavAY?=
 =?us-ascii?Q?srS2FfKVVBzKPtee8W1AATi2r7UJe8mbIos9Ba9UXEkEkwWdMBX77KptzWvr?=
 =?us-ascii?Q?cWv/GwGsr7A/QeXF47F7LVdQ52mf+p+VsLePoS6YuvyQVeQHDGPlZLWA1vdc?=
 =?us-ascii?Q?0IQHaKFHWOLXIIJxIeTyuPzuh9UTLAiw5trBWHhSGoTupoVQwa+jPSBEUCZJ?=
 =?us-ascii?Q?IbXUs7EY1oPcenjyVRwrPoq87jbO2c3MouXhw4J4W+bCweoTbDLUxf06TSTk?=
 =?us-ascii?Q?wFyBFbzB5+X1qiLpnllIRATm9Ys5SUTxx5S2kXh3i3BndeTZHyE7Z9AyShrt?=
 =?us-ascii?Q?lLo1qFsQgIf6jUedN/pp+SLiMpNhCYryJHZZGGlcFyvnpDdcn3u7OnFzrpiJ?=
 =?us-ascii?Q?MAWV9k+smi15DC37hhum1mIH1ZCc?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CF59DE4BDEA1B54DA6E9E3B47BB4259F@namprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b9232794-801c-44d3-a651-08df43ba86c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2026 08:20:51.3612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB7948

Hi Andrew,=0A=
=0A=
> I had LLM suggest a replacement [0/N].  wdyt?=0A=
=0A=
Looks good. One small clarification: in "The series does not impose a=0A=
maximum on positive SEMOPM values", please change "a maximum" to "a new=0A=
upper bound", since the existing INT_MAX bound still applies.=0A=
=0A=
> Please check these also.=0A=
=0A=
The additions to [1/3] and [2/3] both accurately describe the=0A=
user-visible consequences.=0A=
=0A=
Thanks,=0A=
Yingjie=0A=
