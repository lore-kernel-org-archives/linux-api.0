Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793250208;
	b=AqGjJqNpQidEGb78PY0GLXJsi/HiIpRXbCBHqjEqFQv/46jlGKAVCOiFgtBmnbJC5JE5
	 bJrW+XvmY0sM85u4Ra7/aJ+zVeFM+DXIkxgIVLo/eyYnzHOlODZWjphxwrOLipqX2eF/W
	 MHEJvG22tNcelVxRevk+kTnvosVHOqdWtlja8E3fPNpiMwlS//E2FCBgy5KmZT7FxJ8vm
	 pNGiCnm5zJ4onvmL1z6wbzuH53RUE1NQamk1D66XpWEfus2pEjV/Vk4vim+m3tmYHhwgN
	 faC51pn6mq4hsGLIWcXB1oGULw0S6G7SWolLm26WnCHc1v+UHfTCtR9gamW441rJyiA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793250208;
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
	bh=DqiFzpc0xHaVGhfwxqUGFRgPJkquueCfeSJ73YunQ7U=;
	b=NF8/DScyvy53XKRwP+viWcpsVyhcB9jsbhHTWuYTp4jkEEBw2IjNLCQ/ejosaQZaxv6g
	 9BMVyXGrRSIGnAypwGcGMuJVdPCaniXHm5hzO+quc5vlFon3mSMgR8mPwyfUmalaMLaSN
	 khnHr9SN9spLRFCqZTz5wLpnmvadRY4Shc2frF2GeyXlGwNpeFeZyBVRP+DPHn7LtYPul
	 itse7KX6lAk8sRsXnZIvj7K1TF1mJUDIgNGq8Mmc0Ued5H3DlNPwjq1ZMlmToa7e/EvyL
	 dxxSnQz6gYb0uIPt5NIEioPGv3E/iKCVvYrBtDCnllldlR57xzYNfNtEim1xWifGrBw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=iwwagKXA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.6
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazolkn19010006.outbound.protection.outlook.com [52.103.20.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEA7606A324;
	Thu, 29 Oct 2026 05:03:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBEA7606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=iwwagKXA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wQD+kwU6+cDduEpL+RNr9JeO6seyyMQ+vPVe20a+MX05hoBi155UWIIaPbF1Wzp0VtqMBAScilSRDDS+a7G0PAh9sfa8ipSHoCaxAkFKYvrTvg31I1iJfVyMWewrxqyx+uVcZMbjLYozTZc5CwX/qAo6ch5ikZ+nNOsk0wvx8sozber5uYXzzHh9r3ua0x8HIHzvB//bdu97SxBV3JFb7IOdLSRHk2oaPJiD8U1/P435I9v3VDYJvC9YOBwUDZ8q28SSHUZeNw+ADdGSNlxYEO69T7swJyMOL4rhu+rz8D36ZgiKzEZAxuX3N64lw651HiepQjzjGwWvNdo1UpUe2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=DqiFzpc0xHaVGhfwxqUGFRgPJkquueCfeSJ73YunQ7U=;
 b=rDTzXKPKr8eWvKghwmFJBvtYedJnCJ6v5F4wmrDR7EaayhTugDIGiF42ews7JSL0RcpcoLH063uvnyM9hESEsIGyIxALkohhafJF3ujmDbPu9IAe+rMd+Djd2O/iocLsKlp/Fc++If9dZwP3/SX7wNOdFyDrMzdTx9Atq5iE6ppZKf94RDfPq+XK0PZyHI1mC5p3gnKOomwyctFWTkmkuWYKXasKFMtG6JYvba1U45MtI371MWQyNuc/WMYB153jAy9b6H/r6JTsE9EajY1oxa4InmPMCekvwl77cumEqEZPOKA48GKmLYjBdbAeQ1T2lAJCZ6CgHk4NWzqm3gQ/Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DqiFzpc0xHaVGhfwxqUGFRgPJkquueCfeSJ73YunQ7U=;
 b=iwwagKXAZrLSw1xZ4Xt7VXy2zjir8HyjgvdHqH3i/QRkDwmzDnNE/MykCouSvOHh8O0whnIBZcedO9QrcJ/UZCSCS+BYV/skZbzWz+IiAmLgV5Y/KA230AW4phRdAtICIMgD8100xcYN1zuWyHgLSuOyMkZ5jNenDirrNY3uRDuqnY+z/qVRrNK/IKcks2maIO7KPrBYzQR2LD35kEHrpkfqwRets0InzfZehcE5k8EZ5KocypaARxcW138V/7uFYgJdNJTCL1GrtFNUL7CXQ/lRefR3lDtL4A57Ulung0uwUCf1UUSSIhfUb45oke8bnF5tsjMndOu7tofZ5KCQpA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SJ0PR05MB8214.namprd05.prod.outlook.com
 (2603:10b6:a03:390::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Thu, 29 Oct
 2026 05:03:24 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Thu, 29 Oct 2026
 05:03:24 +0000
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
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: [PATCH v5 0/3] ipc/sem: account dynamic sops arrays and validate
 SEMOPM
Thread-Topic: [PATCH v5 0/3] ipc/sem: account dynamic sops arrays and validate
 SEMOPM
Thread-Index: AQHdZ2LT/+5o4bKjo02vICQcsvNQYg==
Date: Thu, 29 Oct 2026 05:03:24 +0000
Message-ID: <cover.1793250194.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SJ0PR05MB8214:EE_
x-ms-office365-filtering-correlation-id: 6f74eb51-4ead-4e3e-a0f2-08df3579f5e7
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|12121999013|38102599003|24021099003|4140399003|15080799012|19110799012|8062599012|8060799015|25010399006|2604032031799003|5062599005|22091999003|21061999006|11091999009|24121999003|1602099012|10035399007|52005399003|40105399003|26121999007|102099032|4302099013|440099028|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?/T66Q5us69k/LX5YG+RBFZjjj/HMqSlnoXKuEG5jAF4C5XLatTgGAHYAlv?=
 =?iso-8859-1?Q?58k584IKehcNUPd4bryMpckjFNG18bEDSWXE+NqF2ro+brUqyNNwYO4xuE?=
 =?iso-8859-1?Q?aMQ75TIwY0H5riTF4j6j2tcBnB5VMyBYVrgHeh6eTFWCQyY8yBnH05obXB?=
 =?iso-8859-1?Q?sCOmAWye6MgU8DnGx2v1xl8oOtnRiD09hPYkLuJ5Y7Ad4UynH+HCMEBYhj?=
 =?iso-8859-1?Q?qwhJiLDNFTa7BYVwlMjC0cfNJ/jxBiBMNFxUJ0flHmuENDI1NzqeydFcco?=
 =?iso-8859-1?Q?rDPMnS9L2SWR8U+g06VhQHSlm5QzNGA4IWMuIoZ0PQe0qR2ErJQeNyDD8q?=
 =?iso-8859-1?Q?+2M67iP5AlPVIkdLJ8Kbad2ryg8iQZTk7TJ7DN6bVNjyt+4l5bEr9fbs8M?=
 =?iso-8859-1?Q?+/AJHevdJvH9qMZekUzOcp0rxe6jKz1PK4jMZdIT5ZH+4FZ7PClPmQbQvD?=
 =?iso-8859-1?Q?q23dYt3rLrTVvXpYavLiQkNODnXYLPMwJ4r3VNWmSVroQEG6fnEFwa2SUS?=
 =?iso-8859-1?Q?0kOzaC0hB3N3m+5XdetSIHZGjqHblNB22K2UmLs5mfWRuI/rv5TixZyy5Z?=
 =?iso-8859-1?Q?WslSjckRCKxVDyKzmpKZjTHj/4v80/8mC4Qoenzf3f101bhOMngq35gHLY?=
 =?iso-8859-1?Q?qrWVHitj81SxNPcujbAmTZXlkC1Dj3a1PqUCEMppV9X5/vpBilbUvitvsp?=
 =?iso-8859-1?Q?DGezC7bSjRO2GgBSmaDwx8RFr53QXTN4RYjotWdfd5/I2K+c7vWCbDZC4V?=
 =?iso-8859-1?Q?ZXLtxBPHVjvX5V0OUJDhXmQODLKmuFzSs30gWuVn0bxAZlqSou7kCovci4?=
 =?iso-8859-1?Q?mlcvsdHFeKYIABaBMlzUFUY3hVJxxCfOSV9JUoigFXJFawGC5mTuwJsuGq?=
 =?iso-8859-1?Q?a6NQ4DIf3K5Dn8UCnjcOy1+fDOZmeqH63w4drBH5sjuKa3vEDYd9hZr3dL?=
 =?iso-8859-1?Q?0Y8YkLMkEI1liK77yW1mHFn7sdUr7NXjQGFp8SuG9+phCAeyHkDC9Mbxrn?=
 =?iso-8859-1?Q?3Tcxt/fRFGd6aoJOLuJmfxdiV7O+3AGZoES0YFTSvipM4HnVh+SUmIehsL?=
 =?iso-8859-1?Q?iYIz/iWJtOp6NV08Ih+ktj0MEDKQR3yhwyHzULqIgN6VPsEcWK9Wdgfk7f?=
 =?iso-8859-1?Q?wkuTMRQ75Q31Q6e8du+YQsPBWDytlyg1Nz6AOq4SeuFu0QBjKvMF9RGhZb?=
 =?iso-8859-1?Q?oK57HVZ4ZKk63Qq3rCTix+aD/UvTpV0zndTcwth9zWblWSoxoby/MY2Eju?=
 =?iso-8859-1?Q?BBQ9ovHA8X2qtKYb7fjVwJVsGn5QDJsFhTXNvXq9FDUFST8pvAjIhipJ59?=
 =?iso-8859-1?Q?vAPc2f952M/ZVodk6GFtA3TIWtg2CJy7e6/hNcT6HbXxe9k=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?xUUg8A4AYh1WW1VxZaWVHDbOqwbZJcdhicIx44k7sIVQzwnA20zvmM7yVl?=
 =?iso-8859-1?Q?3KdTHKyHz1YCg4tRH3ArOdDWBYY++wEWcrTw5KpGeDaacq0JISLw2t7vr/?=
 =?iso-8859-1?Q?ojGj91UWkjv+CQ2JMCGrQGaFh7AP30WN8QFkKQqYqQdLUdOibkltzuKgei?=
 =?iso-8859-1?Q?WDojaxAZfvdEGelISOpDp+hBPq2V05++MsXCAFMlJcXZOSVAoPau+WyvDg?=
 =?iso-8859-1?Q?WQOQTmulC8yfkxkBE7ZcySa/i8JdZ5n9f0wv1rwM5hmoxthKxD7klfLdN0?=
 =?iso-8859-1?Q?CbphK5MhEQbCukXtrCarQftcTnQks6nQbWLQ/XtwWuaqGnMOmEvgEfqMFL?=
 =?iso-8859-1?Q?QdBsIUwB3rqCAnwWzdgj/SkvnbDqrNY2vXxo3bYw3o0G8GNs+Yle9/GxkM?=
 =?iso-8859-1?Q?G/aXINipoW8Vn4n5yfjmMlQukwBLgUhCeSZSudVgbQCdSqjOJlUBZUYF1k?=
 =?iso-8859-1?Q?90hCfL/bHDPHrjXanS8liXVLZteZpx9/SwfzgcIPLi1mlzM/dOehIpy8Tb?=
 =?iso-8859-1?Q?w8ebQ7AbX9E26ejOsuFOc+6SlxbKkzzhDB8HNqyjuYRTzjrUL+Jg/nJyPg?=
 =?iso-8859-1?Q?/IPPoxK1jso50maTDBwu+aM60Ki8JhQEHrgMynz/0LKEopayfWcRohtHxR?=
 =?iso-8859-1?Q?smd7/i25DkE4IDtlRkSbegs2tk2bmdpaPe7COvF7RBJ1pj061uYsMSDS1+?=
 =?iso-8859-1?Q?pAJZF4ECgjmhc0eds2gNUfIXHnTFFJjdJFuI8pzbi3+HYZoATCmauDXco8?=
 =?iso-8859-1?Q?h882hVhdx+/MUvWhmK2EwThaWNZGmOFlp0BPgjiJ3CoLJ5ag6yD069hHVi?=
 =?iso-8859-1?Q?/WhhPoqf9R7pyFJ2G4EmhyJO1q4jNs4Yjf4D+F91y+OlE2Kzhy1Z3XKDD8?=
 =?iso-8859-1?Q?+ePzZx0FC42mcSBgcQPe3jlimyOEhU0+LLeIX6aQulyMI1+jxsvN8MN3bK?=
 =?iso-8859-1?Q?9iY9S8K0nOL2JbeLUfb7C6OYvIpUI3l7T/mLFC6bbhsK5XqcwjpOOyo5E+?=
 =?iso-8859-1?Q?m1p9dZGYP6SW046eUz8oNZpDtEF3r32yN802i+gmKfNnHVKjXkTRjlJLVz?=
 =?iso-8859-1?Q?vX3fJQVWDq3Gg3tFZttkiVUT79R33QGB2RXLMHP9c0JZSEw4a75FQD45FK?=
 =?iso-8859-1?Q?L2pWPPt6aoMsR7xZv8gqR6PNXkwG9ja3gC8D6zojfscGn9XqYSNIfPKC6Z?=
 =?iso-8859-1?Q?2vOqLzkqCVxFA6xQZvBJQBL4wD3cYZXLXSMzWql/J86pBadz4ThGLmgr1h?=
 =?iso-8859-1?Q?fupPuNVgMTtnZT347Uv954HN0pXQ4bUOAjzPfrjYkkSPrS+zs9it6RLA9T?=
 =?iso-8859-1?Q?Nj6MVKZumNiOKO5SihHTK41E5o+qNcjLkGf6X0jKc7h3IW+AlsVvvIX6oJ?=
 =?iso-8859-1?Q?BiyX7IjhmzrW/kKOv8SuzDUJZ240lEqj9n3ixGzr1Iv/FWOqWHIiU6l5Qv?=
 =?iso-8859-1?Q?uPpDroksjgsrD3i3?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f74eb51-4ead-4e3e-a0f2-08df3579f5e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2026 05:03:24.2107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB8214

Shakeel, thanks for the suggestion.=0A=
=0A=
Patch 1 now uses GFP_KERNEL_ACCOUNT for every dynamically allocated sops=0A=
array. The first 64 operations still use the existing stack buffer. The=0A=
fixed 1000-operation exemption and its conditional allocation flags have=0A=
been removed.=0A=
=0A=
I compared this version with v4 in a 4-vCPU KVM guest. The benchmark proces=
s=0A=
was pinned to one vCPU. Each number is the median of 21 samples from three=
=0A=
fresh boots of each kernel. In a leaf memory cgroup, the changes were:=0A=
=0A=
                                      65       500      1000=0A=
  successful semop()                   +3.2%     +3.2%     +2.3%=0A=
  allocation-focused invalid semid     +5.6%     +9.1%    +11.9%=0A=
=0A=
The invalid-sem-id case allocates and copies the operation array before=0A=
returning EINVAL, so it emphasizes allocation overhead. The 64-operation=0A=
stack controls changed by 0.9% and 0.5%, respectively. The already-accounte=
d=0A=
1001-operation controls changed by 1.0% and -0.2%. Successful calls in the=
=0A=
root cgroup changed by at most 2.3%, including the controls.=0A=
=0A=
The sysctl handler parses writes into a temporary array while holding a=0A=
per-IPC-namespace mutex. The mutex covers the snapshot, validation, and=0A=
publication, so a failed write leaves the live settings unchanged and a=0A=
partial write cannot restore fields from an older snapshot. The snapshot an=
d=0A=
publication use READ_ONCE() and WRITE_ONCE(), and reads continue through=0A=
proc_dointvec(). The unused sem_check_semmni() helper is also removed.=0A=
=0A=
The UAPI warning about physical fragmentation is obsolete now that the=0A=
operation array uses kvmalloc(). The header describes SEMOPM as the=0A=
compiled-in default and retains the uniform <=3D INT_MAX range comment.=0A=
=0A=
Patches 2 and 3 are unchanged from v4 and retain Manfred's Reviewed-by tags=
.=0A=
The series is based on 7be4bc52fd9e ("Merge tag 'driver-core-7.4-rc1' of=0A=
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core").=0A=
=0A=
Validation completed on v5:=0A=
=0A=
- a W=3D1 full x86-64 bzImage build;=0A=
- W=3D1 i386 builds of ipc/sem.o and ipc/ipc_sysctl.o;=0A=
- three paired boots of v4 and v5 for the root/leaf memcg benchmark, with=
=0A=
  seven samples for every path, cgroup, and operation count in each boot;=
=0A=
- initial and user-owned non-initial IPC namespaces rejected negative SEMOP=
M,=0A=
  invalid SEMMNI, and malformed writes without changing live settings;=0A=
- zero and positive SEMOPM values remained valid, including the 1000/1001=
=0A=
  operation boundary;=0A=
- concurrent partial, full, rejected, and successful sysctl writes complete=
d=0A=
  without stale-snapshot overwrites;=0A=
- successful, EAGAIN, EFAULT, signal-interruption, and IPC_RMID paths relea=
sed=0A=
  operation-array allocations;=0A=
- no BUG, WARNING, KASAN, UBSAN, or lock dependency report appeared;=0A=
- strict checkpatch with the intentional CONST_STRUCT diagnostic ignored,=
=0A=
  and patch application checks passed.=0A=
=0A=
Changes since v4:=0A=
=0A=
- account every dynamically allocated sops array with GFP_KERNEL_ACCOUNT, a=
s=0A=
  Shakeel suggested;=0A=
- remove the separate 1000-operation accounting threshold;=0A=
- add root and leaf memory-cgroup benchmark results for 64, 65, 500, 1000,=
=0A=
  and 1001 operations.=0A=
=0A=
V4:=0A=
https://lore.kernel.org/r/cover.1793207025.git.x-professor@outlook.com=0A=
=0A=
Review of v4 1/3 by Shakeel:=0A=
https://lore.kernel.org/r/565d855cbd81e0f49018da21df00ff0308f646b1.17932070=
25.git.x-professor@outlook.com=0A=
=0A=
Yingjie Wang (3):=0A=
  ipc/sem: account dynamically allocated sops arrays to memcg=0A=
  ipc/sem: reject negative SEMOPM values=0A=
  ipc/sem: remove obsolete SEMOPM fragmentation warning=0A=
=0A=
 include/linux/ipc_namespace.h |  3 +++=0A=
 include/uapi/linux/sem.h      |  7 +++----=0A=
 ipc/ipc_sysctl.c              | 35 ++++++++++++++++++++++++++---------=0A=
 ipc/sem.c                     |  3 ++-=0A=
 ipc/util.h                    |  9 ---------=0A=
 5 files changed, 34 insertions(+), 23 deletions(-)=0A=
=0A=
=0A=
base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614=0A=
-- =0A=
2.43.0=0A=
=0A=
