Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.13
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794333788;
	b=p0pVo7HWC1Lk4dKs88MTI6iv9/tyOe1M7w1cDfPKnELK3OvkqU5oh5DD3YSS/bY1DUPO
	 cAxz/mqkgvIzYaMfaFANzmnuKgpV3H2yqDcQTEnrW7ziBfF2qAcqZ55p1WBeDydT2j5j4
	 smIzeN9VoHqcj5i++RODPOc7VBIfTg/8PGpEz8aJEc7fXsRHGARaQ+I0dFEkG4ODI85Ol
	 sfLfc346rWqorBZSPObD6qgOEA8uG+ej2VuM0E8bXaAG/lcMfCIzz693mLc5rwhPEMxiD
	 AOdW6xlP2Ey6eS38rb7hzzOtP/BtvPQ6/eaFOmCf7oO/UTN50OYD5bni8pwRQ/JuBxQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794333788;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=WNNYOECojNV/C+XBgjr7yic8xl8vrz2n+/YTgimd8GA=;
	b=UqsYpGdazBv+AWQInd/rA+PftahXBf4yCM6gl3zzUcTTP1rI3wWHUNs7p4VAQSJSabVJ
	 Bnns3bS+kbzjML+VDNNTqVIP6MiT935ST6X4IwFubgYRAAefkUQhSgMiaYd/mkdJWgjsJ
	 nKLJvtgrRfbqIg9Q7yi1NHppRsE7Foi7zdgu3/tR7dayvlQ4nII3qLs4jJ8nZ6IybfFCO
	 k6KePBbm7K/aKHF8L9ROwURURrjCbX+FXLkxPHhHAGtvlFJPhxaOnEKkuGLEe4gYLjp+E
	 MsvO/Aw3kQLMtLxeuY7RXBwzZaXEWOm0SgN8wH/xPTt/5XRL+A8ZGg6PoI+6cTAWFgw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="Ab6De/1c";
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B10606A330;
	Tue, 10 Nov 2026 18:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11B10606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ab6De/1c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794333786; x=1825869786;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WNNYOECojNV/C+XBgjr7yic8xl8vrz2n+/YTgimd8GA=;
  b=Ab6De/1cXI4WjjtRx9VOs/7y6a/pjrAHdVSRE2yIv3bzl6k66Wzekejx
   cdo9RL7aTAcI1HncHF10Neq825AT5mqUfApbvgjG+KcrndXlYIvP+9vLP
   cye3UFvKQlI94h4gM2e6ddzn1x9NcBKUQQpYm9H5IbGWB/LyBMObXREWl
   +/Dax4v3J87aWJJrpXA2rvcPDq0BX0Is9GCK4zwtgdPjsnPxbw4pndp67
   EFqCyBgQW7gRs3cLjQf9VRK1g4rzDW+DG75h/mfuZ8yTvB1AjVLiSSg9/
   TVt8FmmUFiEWk4SBjV+q4wNHo4YOWP/lMCib083g6QGu5YkRHkBaY4nJs
   Q==;
X-CSE-ConnectionGUID: OoDL6h+VTkCDAc/8APoAxQ==
X-CSE-MsgGUID: Km6q77h6Tpi//qUEFRoQ4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11962"; a="2970906"
X-IronPort-AV: E=Sophos;i="6.27,206,1787036400"; 
   d="scan'208";a="2970906"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 10:03:05 -0800
X-CSE-ConnectionGUID: +y46eNGkSU6o+zMG9XI2RQ==
X-CSE-MsgGUID: avsBTkF8Rp2eSDsJaR3q6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,206,1787036400"; 
   d="scan'208";a="8652946"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 10:03:04 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 10:03:04 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 10 Nov 2026 10:03:04 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.37) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 10:03:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L6bLKlkcpvXSQGKlB5pUhlHFB2YMs5Ut7OQ4YVK5mGKdyDwPEu5I4t7nIy9S22cjiMWg8vOcLCQkiVKDpq5cDoqHl1DNBAS0OUv8ajgNq8uG6KpzdEFE6NdYlyWpVoa9ULbjcbj8v907kdgwKePEEEqTnAr8wsdgjEn9ihaJIvD6/0XxOjZyzPAVgdBmCfi/q/9xQGGUwqBJ5yrSJvs7dXMVZDneFC9rYrurv+1fDIFo/glNQDrg/lxs8uWzcAC9Cxcgt/BHa2UmVp7t7pyXl67QWwQEKUpNVTfV2HcNDGipNgfJpcvbiTcrdK5WQm1w8ytBvGslm48rF5Eu5T8MZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNNYOECojNV/C+XBgjr7yic8xl8vrz2n+/YTgimd8GA=;
 b=hLT6K4Txde7A0uE2ab9zGQZAkZ3rk/6mVff5f7RIjF/YPG93ZnQSND5Q8DtSIpWtk4g3t2PogtQxzKbmA2Dd4IhNg/Ddu6f+AFmdVWJlcMnxG7uLMdK9OZh6xKcbXpFZHeuspK+MddiEagspvJs4eJdF2BGdyt/zRr+SkH2SvNzWJhYanNdJgdVE8NmK64XjFLcUIIv+xV54X52DIkOU2IouU5hx8O2Y0QG1Zhv5uq9GvPLgkX4QRHWewEpV8MN44ysMidk7plQrh85Vd1ROlfIsTkYigAZc16GSEw3sC+zCEFLBlQJRHy8t3AqPm4vk6b/MqrrEJVfxTtgg6dz9zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 (2603:10b6:208:549::23) by DM3PPF6C1A2BDF1.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f2b) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:01:54 +0000
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57]) by IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57%5]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 18:01:53 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jgg@ziepe.ca" <jgg@ziepe.ca>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "ksinyuk@kernel.org" <ksinyuk@kernel.org>,
	"drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Xing, Cedric" <cedric.xing@intel.com>,
	"alistair.francis@wdc.com" <alistair.francis@wdc.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "ankita@nvidia.com" <ankita@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jiri@resnulli.us" <jiri@resnulli.us>, "kas@kernel.org" <kas@kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>, "Quigley, David"
	<david.quigley@intel.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "pgonda@google.com" <pgonda@google.com>,
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "lukas@wunner.de" <lukas@wunner.de>, "Vivi,
 Rodrigo" <rodrigo.vivi@intel.com>, "Fang, Peter" <peter.fang@intel.com>,
	"jic23@kernel.org" <jic23@kernel.org>, "aik@amd.com" <aik@amd.com>,
	"sameo@meta.com" <sameo@meta.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "qinkun@google.com" <qinkun@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Topic: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Index: AQHdXLTTjrGSfVTT6UCa8v4N/LvKxbcKKgoAgAENkgCAAFvTgIAAJv0AgA+FnACAAGOJgIAGE/cAgARqFgCAAGa/gIAABksAgAAeAYCAAMPaAIAAUTQA
Date: Tue, 10 Nov 2026 18:01:53 +0000
Message-ID: <3860f37059d4c8807fa588c9f03b3a18e9449cec.camel@intel.com>
References: <20261023141218.GD3977851@ziepe.ca>
	 <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>
	 <20261023220030.GM3977851@ziepe.ca>
	 <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>
	 <20261103005851.GH3889730@ziepe.ca> <au5LCE1jau0yDo5S@intel.com>
	 <20261109171236.GP663069@ziepe.ca>
	 <cbef9bda9241ffe98652172edb67fab3eb1c35ee.camel@intel.com>
	 <20261109234252.GR663069@ziepe.ca>
	 <4c75b369b68c98c5c35e296895b6935342dc7dc1.camel@intel.com>
	 <20261110131114.GV663069@ziepe.ca>
In-Reply-To: <20261110131114.GV663069@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB634048:EE_|DM3PPF6C1A2BDF1:EE_
x-ms-office365-filtering-correlation-id: 9e955f97-73dd-4f7a-766b-08df3f54b3eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|261009223027099003|10067099003|3023799007|261028144727099003|261102123227099003|261026140227099003|261026121527099003|261022113327099003|261021135927099003|261022075727099003|261022105027099003|261021121427099003|56012099006|5023799004|38070700021|4143699003|11063799006|22082099003|18002099003;
x-microsoft-antispam-message-info: 1aArj7lRKHwEtWC5dJbGSPJ+78t+rdZz0Y8+1U8uj+6M3AyujYfonHEgJwjST9YShFG1HG5vlSDz7jq7ueJ48NA/QAuX/D1gGYY5p3QClmjOpWBwvUzVOmsnls3m77uPvitgs2HeXQX6La7LlRcmU+C4YCE23u3DgkDO7hNHpdWbBsgozD4UBigpBwcrRS7D9jauH4VTzY2V3ykN40GWXALqRcbpmZsbNUVH5nGUrNRN9ROtnOzFohQm0fMYv2ORGfkvL3luUrfFnRg+lnoPBQfKIoz8BNCNSrXc/wl1uPFIwf47P00y/t/n+iNmjEiXAqgidNY7VG4vN2LML/2GH0KQ2mc/+W9SxsnNtQjwVjrzE1rWasrEgBxZtcDucqYIamJQTMYyctMd2itg5yd1/WkRgaadHfwIZ21Uk6Ulu1b0jOS7FeiIdeA+A0Cz3InayXR+8TVJJ2u32NFPTSgHvmftnHPmR01uIDFScQbdZY+mzlpXslIWkIJXY/NFy7Aessk650I4ClwbG2yVcAJtNI1fVvoHYu0OM9sDGV8OHJJjfTJNKujD+jwTG7yoaDFmS4+HfKmoTo5Ke6o2xjdKUXqIARVCdyw1AcL/LOZ/BS/CPwwjfYPQgf56EzsmAH5ga4OTbVb11t2VI+l+GtRg0k8s90pThyAjgsD5GX0og3E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB634048.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(261009223027099003)(10067099003)(3023799007)(261028144727099003)(261102123227099003)(261026140227099003)(261026121527099003)(261022113327099003)(261021135927099003)(261022075727099003)(261022105027099003)(261021121427099003)(56012099006)(5023799004)(38070700021)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVN2bEp3eGwvYkQyd1RzZjBScXp4cEswS1VySm5acTRGTTBzRnJkdVR0QmdC?=
 =?utf-8?B?WWNsckdmMHBHbUg2S2FJejJmSHAvK2cwYVJEZnJob0tabThDbG54enZUQU9G?=
 =?utf-8?B?SW5nUVBUbVpYenppUFlwdUVTdW9ZNUlId0dOVDh4d3MyOVgrRFpZWWdma2E1?=
 =?utf-8?B?YmN5Y3FvcjBJMTRKT0pKSmlmdUlvNWFzR2dmbWNtajFSam1NbFM2Zlg0OHYz?=
 =?utf-8?B?VW1kTEZnZzNuSnluNk01V2RQeTB5SmY0eE5XZC9rb015c3lFK0hCb1dEeWk0?=
 =?utf-8?B?NmUxNDZGbUU1K05qUW9iMVRENUQ4MFNXY3B6WnA0ckdWRnlBU2xTZEVJeGlX?=
 =?utf-8?B?NDc2K1NkUCtWdFFlNnFRRTBiRGdHUEFpOXpFbWdsNXVvSTNhM0JkblFoYktJ?=
 =?utf-8?B?VmluZ2lKY2cyQUhKbjlIaVRtUzhlSmxmWlFKMUtZRHcvQlRTZDJzczZqRmc0?=
 =?utf-8?B?WlpYbFR5VWhzR1FpYml1ZUpUc1VNZGZrV1B2Z1VDSFJqRHF0alZ0Q09qWHBZ?=
 =?utf-8?B?UzlCUU5lL2hPVTRmWmZZaGpQSWh6NkVibVVrRU5majM5T3B6ODVtN21RVnhW?=
 =?utf-8?B?TEpHbEJYWDdFajV5RTZiYTBUNlVPazdBejBSZEdpWkVDdmp0RE05T1I3Q0ph?=
 =?utf-8?B?UUYwbmw5TmtFa3ViMWVrTmxnb3NaWlNQTkhBTys2VDMwQ05aa1RoY1RNbXNm?=
 =?utf-8?B?U0Q4MWEzSTlRVUl1ZTZ0R1htd1NZbG5oSXpQWkkrVENTL21GOEY4aTJ2Vkcv?=
 =?utf-8?B?Zk81aVM2WUJEZjl5cWpEb1FqV2NUUldjMlZ6SDBxdGh2MnRSMDU1RUNjTVc5?=
 =?utf-8?B?N0dBUGZxamZBNE9PN1ZMSVQya0JjMzRacHNqdTNzMmlYbnZsY2FyV0hwK3RN?=
 =?utf-8?B?VFNuQjlEbXVNMHJ4YWw1YjJEUzI0YXI1WGltN200Yy80djZ0QU9vRys3QXp4?=
 =?utf-8?B?Q1hITXFYTWpkSG1aNktXdVF4QWhoZzRDc0lHWUJnY3Nkc1MwT1o3ck5KckV1?=
 =?utf-8?B?R3VPdGNsK1Brd1B2N01sTFd0MVZqVndRckQ0TVlsektQY0w0dkhsd3VwZ0JE?=
 =?utf-8?B?cDdaY0p1VmFoSjE2bWJHMFN2N2M0U1F3dWUvSGNjK2Jma2dHaVBoR09OelpP?=
 =?utf-8?B?UXJkZ1RkU2FDQm5Xd1l1d2doaDBndUE4d0w3S2JCTDlxcStKK0M5cjVTVWJ0?=
 =?utf-8?B?cWVtb0dqM0NJOWlKY3lWNVNDYkcyVTg4SWt0QW9sV1ZZRjJDTUwzZWdKd2xC?=
 =?utf-8?B?T00vRVNJU0JkdFdDaXFaRXhBVDltWXVCbmR0aUpoR0ROYkJtRWNxbzhZTERv?=
 =?utf-8?B?Z2VweXpLN2RhanlxdEhrUHFRdFRBZi9jTldsNThDdVhIMlg1WFhyNm9rMzJU?=
 =?utf-8?B?Y2RISXBFeGY0ZGVDMzZkc2RrVklBenlxVEJKSC9iOTJGaFNMcWx1bS9FTmZZ?=
 =?utf-8?B?Q3dRYmJIemJIWjJhQzIvQVlFb2w1MEI3Y2Y1eEZVWUpGMEdkWHJuUlJDRmpE?=
 =?utf-8?B?aVhtL1hQeHRlUkt5akRMMy80RkU0T2YzZkxDZjVTVjY4VVAweUEyQjNjbWIr?=
 =?utf-8?B?Z2hXRDhZa1BoR2NmRUxSY2NkeUFGSjd2RTV3LzREZkR3Nzc5aVVKdlJFUzZ0?=
 =?utf-8?B?SnJoTVFiSTBoS0ovZTVvdVVGMGJyTVJ5eE1yV25iZU5vekwyQlFjUllSNHJl?=
 =?utf-8?B?bHJ1SW5xZkVFYWxZbGdIMlZZRUhwWVdwVitVak5wVDROY0dUbjN6SVplN2dQ?=
 =?utf-8?B?WU02NEJHMEVmYityTVZyalZYY1ljN01ST3k2U0w2VU1tWWVUOU44b1Q1bkhy?=
 =?utf-8?B?T3p1WjErQWFPWk9GZEk3QWk2bnljaHdnOXdnc1dtOTJieFpoaUlWcUtVRTl5?=
 =?utf-8?B?cHVCOUErKzBuL01pNmVuSWZ2UWc3ejk3QmRuNGU3ckZPN3NEaEhDamQ2TlNH?=
 =?utf-8?B?cmhYaVNWUUhiaWZuYlNSbGtpSjl4UDBCcThxMDdYbFJWQmtRK1VJSFJYdE1M?=
 =?utf-8?B?WGFwQWNqeFhCR1pCd3E1Q1ZTZTNoUE1YZXBkZ2dEcGducnpMdjNlSGpqWnI4?=
 =?utf-8?B?SlFjUVQ5UzhlVk9vSitTSjMzWVBhRGpnaTZ1L3ZtR24wYnc5M3E5RytVc042?=
 =?utf-8?B?OGJaTmtiYk9mSzVFcWdWVG1SYUNsVTdmVjR3bk9ITTZYR0t1VGNjWUlnWG5r?=
 =?utf-8?B?dkN1RHo5WnpraFhpZHM1VGNPWW9lWHdZem9nUDhBQzJXSC9ZemhXc1hLWWJT?=
 =?utf-8?B?WDN1aG0rZ0plSTR4aXh0TkJVUjBZSDBMdmx0WWtSRzN3aDNRTVBIQnhFdDQr?=
 =?utf-8?B?N1hIQ25LT1NqSjVBUzhlWXhkV3lQZkZRZmFsVkttaGluZVl4LzVBaEk4U2pC?=
 =?utf-8?Q?u9xV/9gzTo++N/tA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53481E60C9C89A49A06380276B5ABE4C@namprd11.prod.outlook.com>
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
X-Exchange-RoutingPolicyChecked: U0+1wXC2EJZFk6E93rZuhb0/Bs08/xcT0UJQRHMeZfI1fIRcaO1L35Axiw0ANtqNtS7aeNzdTkUP6OiWI+UgLWMUxGu8PdLoa8LTFiQQz4b3lLSLC4HaiUCM8o5cqRl6tXXeFG9KP4h9f4LVcQuLFcmQnkpIbwa5NDE6hwbAsXmo8qz3sn0J56uLk7UDq4WuJgQV6Dzl8ARBx6LJBOSmi/P1WnEIEosOrjt3j3pAwA6UxqQlmKcckRs8eig2Oj0Qtclz+aus+W3RTmtfZw6zgU+QzQUe0n6ecSUB/uXYhYHWMe5V6wWUfFM49bureknqTLVhFUhjdoLnvv2oJYqT2Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB634048.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e955f97-73dd-4f7a-766b-08df3f54b3eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2026 18:01:53.7794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PFz6mKfSjpBRF9CNlBxWc5cNL5jcfVYFJTUhrkc6Fu5HR0uf25nbl9xsVX/d/pDsraEZZoZrP7ivDRHY4RKn2Myxbql/36WKhOHhjIO1uhc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF6C1A2BDF1
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI2LTExLTEwIGF0IDA5OjExIC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFR1ZSwgTm92IDEwLCAyMDI2IGF0IDAxOjMwOjE2QU0gKzAwMDAsIEVkZ2Vjb21iZSwg
UmljayBQIHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyNi0xMS0wOSBhdCAxOTo0MiAtMDQwMCwgSmFz
b24gR3VudGhvcnBlIHdyb3RlOg0KPiA+ID4gPiBTbyB3ZSBoYXZlIHRoaXMgU0dYIGJhc2VkIHF1
b3RlIGZvcm1hdCB0aGF0IGlzIGZpeGVkIGJlY2F1c2UgaXQgYWxyZWFkeQ0KPiA+ID4gPiBleGlz
dHMgaW4gdGhlIHdpbGQuIEdvaW5nIGZvcndhcmQgd2UgYXJlIG1vdmluZyB0byBESUNFLCBidXQg
dGhhdCBpcyBhDQo+ID4gPiA+IHN0YW5kYXJkIGZvcm1hdC4NCj4gPiA+ID4gU28gYWxzbyBzb21l
d2hhdCBmaXhlZC4gSSBndWVzcyB0aGUgcXVlc3Rpb24gaXM6IGlzIHRoZXJlIHNvbWUgY29tYm8g
b2YNCj4gPiA+ID4gYml0cyBpbiBlYWNoIGJsb2Igd2UgY291bGQgY2hlY2sgdGhhdCBjb3VsZCBk
ZXRlcm1pbmlzdGljYWxseQ0KPiA+ID4gPiBkaXN0aW5ndWlzaCBiZXR3ZWVuIHRoZQ0KPiA+ID4g
PiB0d28/IFRvIGRvIHRoaXMgd2Ugd291bGQgbmVlZCB0byBhbmFseXplIHRoZSBxdW90ZSBmb3Jt
YXRzLg0KPiA+ID4gDQo+ID4gPiBZb3UgZ3V5cyByZWFsbHkgZGlkbid0IG1ha2UgaXQgZGlzY292
ZXJhYmxlIHdoZW4geW91IGFkZGVkIERJQ0U/IDooIDooDQo+ID4gDQo+ID4gTGlrZSBpbmZsdWVu
Y2UgdGhlIERJQ0Ugc3BlYyB0byBpbnRlcm9wIHdpdGggbGVnYWN5IFNHWCBiYXNlZCBhdHRlc3Rh
dGlvbj8NCj4gPiBJJ20gb3V0IG9mIG15IGRlcHRoIHRvIHRyeSB0byBzYXkgaG93IHBvc3NpYmxl
IHRoYXQgaXMuDQo+IA0KPiBObywgSSBtZWFuIGp1c3QgaGF2ZSB0aGUgU0dYIGZpcm13YXJlIHRl
bGwgdGhlIE9TIGlmIGl0IHByb2R1Y2VkIGENCj4gRElDRSBvciBsZWdhY3kgYmxvYiA6KA0KDQpU
aGUgU0dYIGZpcm13YXJlIG9ubHkgcHJvZHVjZXMgU0dYIHF1b3Rlcy4gSSBndWVzcyB0aGF0IGNv
dWxkIGh5cG90aGV0aWNhbGx5DQpjaGFuZ2UuDQoNCkRJQ0UgcXVvdGVzIGNvbWUgZnJvbSBhIGRp
ZmZlcmVudCBjb21wb25lbnQgb24gdGhlIGhvc3Q6IHRoZSBURFggbW9kdWxlLiBTbyB0aGUNCmhv
c3QgY2FuJ3QgYWNjaWRlbnRhbGx5IGdldCB0aGUgd3JvbmcgcXVvdGUuIFRoZSBob3N0IHNpZGUg
VERYIG1vZHVsZSBBUEkgYWxsb3dzDQpmb3Igc2VsZWN0aW5nIHRoZSBxdW90ZSB0eXBlIHRoYXQg
Z2V0cyByZWNlaXZlZC4gU28gdGhlIGhvc3Qgc2hvdWxkbid0IGdldA0Kc3VycHJpc2VkLg0KDQpU
aGUgZ3Vlc3Qgb24gdGhlIG90aGVyIGhhbmQgcmVxdWVzdHMgYSBxdW90ZSB0aHJvdWdoIGEgc3Bl
YyBjYWxsZWQgdGhlIEdIQ0kuDQpSZWNhbGwgaXQgZG9lc24ndCBnZXQgdGhlIHF1b3RlIGRpcmVj
dGx5IGZyb20gU0dYIG9yIHRoZSBURFggbW9kdWxlLiBTbyB0aGUgaG9zdA0KZGVjaWRlcyB3aGF0
IHR5cGUgb2YgcXVvdGUgdG8gZ2l2ZSB3aGVuIGl0IHJlY2VpdmVzIHRoYXQgcmVxdWVzdC4NCg0K
SW4gQ1NQIGluc3RhbGxhdGlvbnMgdGhlcmUgaXMgYSBmYWlyIGFtb3VudCBvZiBpbmZyYXN0cnVj
dHVyZSBpbnZvbHZlZCBpbg0Kc2VydmluZyB0aGUgZW5kIHVzZXIgZm9yIGFsbCB0aGlzIGF0dGVz
dGF0aW9uIHN0dWZmLiBTbyB0aGlzIGdldHMgdG8gc29ydCBvZiB0aGUNCmNydXggdGhlIGlzc3Vl
LiBUaGUgZ3Vlc3QgY2FuIHJlcXVlc3QgYSBxdW90ZSB0eXBlLCBidXQgdGhlIENTUCBpcyBwcm92
aWRpbmcgdGhlDQpzZXJ2aWNlIGFuZCBtYXkgbm90IGV2ZW4gd2FudCB0byBzdXBwb3J0IFNHWCBx
dW90ZXMgZm9yIGV4YW1wbGUuIFRoaXMgbWVhbnMgdGhlDQpob3N0IGhhcyB0byBoYXZlIHNvbWUg
c2F5IGluIHRoZSB0eXBlIG9mIHF1b3RlLg0KDQpUb2RheSB0aGVyZSBpc24ndCBhIHdheSBmb3Ig
dGhlIGd1ZXN0IHRvIHJlcXVlc3QgYSBzcGVjaWZpYyBxdW90ZSB0eXBlLiBCdXQgaXQncw0KdW5k
ZXIgZGlzY3Vzc2lvbi4gSSB0aGluayB0aGF0IGlzIHRoZSB0aGluZyB0byBkbyBoZXJlLiBXZSBj
YW4gaGF2ZSB0aGlzIHRoaW5nDQpyZXF1ZXN0IGEgc3BlY2lmaWMgcXVvdGUgdHlwZS4gVGhlIGd1
ZXN0IGFsc28gbmVlZHMgdG8gbGVhcm4gd2hhdCBxdW90ZSB0eXBlcw0KYXJlIHN1cHBvcnRlZCBi
eSB0aGUgaG9zdC4gSSB0aGluayB0aGF0IGlzIGVub3VnaD8gU2VlIHRoZSBib3R0b20gZm9yIGEg
bW9yZQ0KZXhwbGljaXQgcHJvcG9zYWwuDQoNCj4gDQo+ID4gSSdtIGFsc28gdW5kZXIgdGhlIGlt
cHJlc3Npb24gdGhhdCB0aGUgcXVvdGUgd2FzIG5vdCBkZXNpZ25lZCBmb3IgbG9jYWwNCj4gPiBw
cm9jZXNzaW5nIGluIHRoZSBndWVzdC4gQnV0IHJhdGhlciByZW1vdGUgYXR0ZXN0YXRpb24gd2hp
Y2gsIHVzdWFsbHkNCj4gPiBpbnZvbHZlcyBhIGhlbHBlciBzZXJ2aWNlIHRoYXQgcHJvY2Vzc2Vz
IHRoZSBxdW90ZS4gSSd2ZSBuZXZlciBiZWVuIGNsZWFyIG9uDQo+ID4gd2h5IHRoYXQgd2FzIGRl
c2lyZWQuIEJ1dCBpdCBwcm9iYWJseSBpcyBwYXJ0IG9mIHRoZSByZWFzb24gYXR0ZXN0YXRpb24N
Cj4gPiBkb2Vzbid0IGZpdCB0aGlzIHVzZSBjYXNlIHBlcmZlY3RseS4NCj4gDQo+IEV2ZW4gdGhl
IHJlbW90ZSBoZWxwZXIgbmVlZHMgdG8gdGVsbCB0aGUgdHdvIGNhc2VzIGFwYXJ0IHNvIGl0IGNh
bg0KPiBwYXJzZSB0aGVtDQo+IA0KPiBBZ2FpbiBpZiB5b3UgZXhwZWN0ZWQgdGhlIHVzZXIgdG8g
cHJlLXRlbGwgdGhlIGhlbHBlciB0aGF0IHRoaXMgaXMgYQ0KPiBsZWdhY3kgdnMgRElDRSBWTSB0
aGVuIHRoYXQncyBleGFjdGx5IHRoZSBiYWQgdXNlciBleHBlcmlhbmNlIEkgd2FudA0KPiB0byBh
dm9pZC4NCg0KWWVhIEkgZXhwZWN0IGl0IGNhbi4gSSBkb24ndCBrbm93IGhvdyB0aGUgdmVyaWZp
ZXIgY291bGQgd29yayBvdGhlcndpc2UuIFN0aWxsDQpuZWVkIHRvIGNvbmZpcm0uDQoNCj4gDQo+
ID4gPiA+IElmIHRoZXJlIGlzbid0LCBJJ20gbm90IHN1cmUgd2hhdCB3ZSBjb3VsZCBkbyBhdCB0
aGlzIHBvaW50LiBUaGVyZSBpcyBhDQo+ID4gPiA+IGxpYnJhcnkgSW50ZWwgcHVibGlzaGVzIChy
aWdodCBQZXRlcj8pIHRoYXQgY2FuIHZlcmlmeSB0aGUgcXVvdGVzLiBJJ2QNCj4gPiA+ID4gZ3Vl
c3MgaXQgbXVzdCBoYXZlIHNvbWUgd2F5IHRvIGRpc3Rpbmd1aXNoIGJldHdlZW4gdGhlIHR3by4g
Q2FuIHlvdQ0KPiA+ID4gPiBjaGVjayBob3cgaXQgZG9lcyBpdCBQZXRlcj8NCj4gPiA+IA0KPiA+
ID4gU2VlIHRoaXMgaXMgZXhhY3RseSB3aGF0IEknbSB0YWxraW5nIGFib3V0LCBJIGRvbid0IHdh
bnQgdG8gcmVwZWF0ZWRseQ0KPiA+ID4gZ2V0IGludG8gdGhpcyBzaXR1YXRpb24gZG93biB0aGUg
cm9hZCBvdmVyIHRoZSBuZXh0IGRlY2FkZS4NCj4gPiANCj4gPiBJJ20gbm90IHN1cmUgaWYgSSdt
IG1pc3Npbmcgc29tZXRoaW5nLiBOZXcgaW5jb21wYXRpYmxlIHN0YW5kYXJkcyBzZWVtDQo+ID4g
cHJldHR5DQo+ID4gbm9ybWFsPyBTb21ldGltZXMgdGhlcmUgaXMgYSBjb250YWluZXIgdG8gc3Bl
Y2lmeSB3aGljaCB0eXBlIG9mIGJsb2IsIGFuZA0KPiA+IHNvbWV0aW1lcyBpdCBpcyBqdXN0IGRp
c2NvdmVyYWJsZSBieSBjbHVlcyBpbiB0aGUgYml0cy4NCj4gDQo+IFllcywgY29tcGxldGVseSBu
b3JtYWwuIFRoZSB0aGluZyB0aGF0IGdlbmVyYXRlcyB0aGUgZGF0YSBzaG91bGQgaGF2ZQ0KPiBh
biB1bmFtYmlndW91cyBjb250cmFjdCB3aXRoIHRoZSBPUyBvbiB3aGF0IGtpbmQgb2YgZGF0YSBp
dCB3aWxsDQo+IGdlbmVyYXRlLg0KDQpUaGVyZSBhcmUgdHdvIE9TcyBpbnZvbHZlZCBpbiBndWVz
dCBhdHRlc3RhdGlvbi4gVGhlIGhvc3QgY2FwYWJpbGl0aWVzIG1lZXQgdGhpcw0KY29udHJhY3Qu
IFRoZSBndWVzdCwgd2hpY2ggd2UgY2FyZSBoZXJlLCBkb2Vzbid0Lg0KDQo+IA0KPiBJZiB5b3Ug
d2FudCB0byBjaGFuZ2UgaXQsIHRoYXRzIGZpbmUsIGJ1dCB0aGUgT1MgcGFydGljaXBhdGVzIGlu
IHRoZQ0KPiBjaGFuZ2UgYW5kIGlzIGF3YXJlIG9mIGl0Lg0KPiANCj4gPiBJIHRoaW5rIHRoZSB0
aGluZyB0aGF0IGlzIGEgYml0IGRpY2V5IChubyBwdW4pIHdpdGggdGhpcywgaXMgdGhhdCB0aGVy
ZSBpcw0KPiA+IGtpbmQgb2YgYSBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eSBhZGphY2VudCBjaGFu
Z2UgZm9yIHN5c3RlbXMgZ2l2aW5nIHRoZSBuZXcNCj4gPiBESUNFIHF1b3Rlcy4gVGhpcyBjYW1l
IHVwIGluIGluIGJvdGggZGlzY3Vzc2lvbnMgd2l0aCBEYXZlL3g4NiBhbmQgU2Vhbi9LVk0uDQo+
ID4gVGhlIHJlYXNvbiB3aHkgaXQgd2FzIGNvbnNpZGVyZWQgZ3J1bWJsZS1vayBpbiB0aGUgZW5k
LCB3YXMgYmVjYXVzZSB0aGUgZnVsbA0KPiA+IHZlcmlmaWNhdGlvbiBkZXBlbmRzIG9uIHVwZGF0
ZXMgdG8gdGhlIGxpYnJhcnkgZm9yIGVhY2ggbmV3IHBsYXRmb3JtIGR1ZSB0bw0KPiA+IG5lZWRp
bmcgdG8gYmUgYXdhcmUgb2YgbmV3IGtleXMuIFNvIHRvIGFjdHVhbGx5IGF0dGVzdCBldmVuIFNH
WCBxdW90ZXMgb24gYQ0KPiA+IG5ldyBwbGF0Zm9ybSwgbGlicmFyeSB1cGRhdGVzIGFyZSBuZWVk
ZWQgdG8gd2hhdGV2ZXIgdG9vbCBvciBzZXJ2aWNlIGlzDQo+ID4gYmVpbmcgdXNlZC4gU2luY2Ug
dGhlIGxpYnJhcnkgbmVlZHMgdG8gYmUgdXBkYXRlZCBpbiBhbnkgY2FzZSwgaXQgY2FuIGFsc28N
Cj4gPiB1bmRlcnN0YW5kIHRoZSBuZXcgZm9ybWF0cyB3aXRob3V0IGFueSBpbXBhY3QgdG8gdGhl
IHVzZXIuDQo+IA0KPiBJIGRvbid0IGtub3cgd2hhdCB5b3UgZ3V5cyBoYXZlIGRvbmUgaGVyZS4g
VGhlcmUgYXJlIElFVEYgc3RhbmRhcmRzDQo+IGZvciBhbGwgb2YgdGhpcyBhbmQgd2VsbCBkZWZp
bmVkIGNvbnRhaW5lciBmb3JtYXRzLiBTdXJlIHRvIHBhcnNlDQo+IGV2ZXJ5IGJpdCBvZiB0aGUg
dG9rZW4geW91IG1pZ2h0IG5lZWQgYSBuZXcgbGlicmFyeSwgYnV0IHlvdSBzaG91bGQgYXQNCj4g
bGVhc3QgYmUgYWJsZSB0byBnZXQgYSBzaWduYXR1cmUgdmVyaWZpZWQgYW5kIHBhcnNlIHRoZSBn
ZW5lcmljDQo+IGluZm9ybWF0aW9uIHJlbGlhYmx5Lg0KDQpXaGF0IGhhcHBlbmVkIHdhcyB0aGF0
IHRoZSBTR1ggZm9ybWF0IHdhcyBmaXJzdC4gVGhlbiB0aGlzIHN0YW5kYXJkIGNhbWUgb3V0IGFu
ZA0KdGhleSB3YW50IHRvIHN3aXRjaCB0byBpdC4NCg0KPiANCj4gSWYgeW91ciBwbGFuIGlzIFRE
WCByZWxlYXNlcyBhcmUgQUJJIGluY29tcGF0aWJsZSB3aXRoIHRoZSB2ZXJpZmllcnMsDQo+IHRo
ZW4gdGhhdHMgYSBob3JyaWJsZSBwbGFuIGFuZCAqbXVjaCogd29yc2UgdGhhbiB3aGF0IEFSTSBp
cyBkb2luZywNCj4gZm9yIGluc3RhbmNlLg0KDQpTR1gtPkRJQ0UgdHJhbnNpdGlvbiBpcyBpbmNv
bXBhdGlibGUuIEFuZCB0aGVyZSB3YXMgc2lnbmlmaWNhbnQgaGFuZCB3cmluZ2luZyBvbg0KdGhp
cyB0aGF0IHdhcyByZXNvbHZlZCBiZWNhdXNlIHdlIHdlcmUgY29udmluY2VkIG5vIGV4aXN0aW5n
IHVzZXJzIHdvdWxkIGJlDQppbXBhY3RlZC4NCg0KUGxhdGZvcm0tPnBsYXRmb3JtIHdpbGwgaGF2
ZSBuZXcga2V5cy4gU28gdGhlIG9sZCB2ZXJpZmllcnMgd291bGRuJ3QgaGF2ZSB0aGUNCm5ldyBr
ZXlzLiBTbyB0aGlzIGNhc2UgaXMgbm90IGxpa2UgYSBuZXcgZm9ybWF0LCBidXQgcmVxdWlyZXMg
YSB2ZXJpZmllciB1cGRhdGUNCmFueXdheS4gSSB3b3VsZCBoYXZlIGV4cGVjdGVkIHRoZXNlIGtp
bmQgb2Yga2V5IGNoYW5nZXMgd291bGQgYmUgdGhlIGNvbW1vbiBjYXNlDQpmb3IgYWxsIHNvbHV0
aW9ucy4NCg0KTmV3IHBsYXRmb3JtcyB3aWxsIGFsc28gaGF2ZSBuZXcgZmVhdHVyZXMgdGhhdCBj
YW4gYmUgYXR0ZXN0ZWQuIFNvIHRoZSBmb3JtYXQNCnNob3VsZCBncm93IGluIGJhY2t3YXJkIGNv
bXBhdGlibGUgd2F5cyB0byBsZWFybiBhYm91dCB0aGVtLg0KDQpJIGRvbid0IHRoaW5rIGFkbWlu
IGRlYnVnZ2luZyB3YXMgYSB1c2UgY2FzZSBjb25zaWRlcmVkLiBJdCBzZWVtcyBsaWtlIHlvdSBh
cmUNCmFyZ3VpbmcgdGhhdCBpdCBkb2Vzbid0IG1hdHRlciBiZWNhdXNlIGl0IGlzIGFuIGltcHJv
cGVyIGRlc2lnbi4gSSBjYW4gZmluZCBhDQpsb3Qgb2YgZmF1bHQgaW4gdGhlIFREWCBhdHRlc3Rh
dGlvbiBmbG93IHdlJ3ZlIGVuZGVkIHVwIHdpdGguIFNHWCBiZWluZyB0aGUNCm9yaWdpbmFsIHNp
bi4gQnV0IEknbSBub3Qgc3VyZSBvbiB0aGlzIG9uZS4gKEJUVyBJIGRpZG4ndCBwZXJzb25hbGx5
IGRlc2lnbiBhbnkNCm9mIHRoaXMpDQoNCkluIGFueSBjYXNlLCBJJ2Qgc3VnZ2VzdCB0aGF0IHJl
c29sdmluZyB0aGF0IGlzIHVubmVjZXNzYXJ5LCBhbmQgc29tZXdoYXQgb2YgYQ0KYmFycmllciB0
byBtYWtpbmcgc3VyZSB3ZSd2ZSBjYXB0dXJlZCB0aGUgcmVxdWlyZW1lbnRzLiBURFggaXMgYSBs
aXZlIHRoaW5nLiBXZQ0KY2FuIG1ha2UgY2hhbmdlcyB0byBpdCByZWxhdGl2ZWx5IHF1aWNrbHkg
Y29tcGFyZWQgdG8gSFcsIHNvIGxldCdzIG1ha2Ugc3VyZQ0Kd2UndmUgZ290IHRvdGFsIGFsaWdu
bWVudCBvbiB3aGF0IGlzIG5lZWRlZC4gTW9yZSBiZWxvdy4NCg0KPiANCj4gQnV0IGl0IHNvdW5k
cyBsaWtlIHlvdXIgbGlicmFyeSBjYW4gc29tZWhvdyBwYXJzZSB0aGUgYmxvYiBhbmQgZmlndXJl
DQo+IGl0IG91dCwgc28gbWF5YmUgaXQgaXMganVzdCBhIG1hdHRlciBvZiBkZXNjcmliaW5nIGhv
dyB0aGF0IHdvcmtzLg0KDQpUaGUgU0dYIGZvcm1hdCBpcyBkb2N1bWVudGVkLg0KaHR0cHM6Ly9k
b3dubG9hZC4wMS5vcmcvaW50ZWwtc2d4L2xhdGVzdC9kY2FwLWxhdGVzdC9saW51eC9kb2NzL0lu
dGVsX1REWF9EQ0FQX1F1b3RpbmdfTGlicmFyeV9BUEkucGRmDQoNCkhvdyB0aGUgVERYIGZlYXR1
cmVzIGFyZSBhcHBsaWVkIHRvIHRoZSBESUNFIGZvcm1hdCBpcyBkb2N1bWVudGVkIHRvbyBJSVJD
LCBidXQNCkknbSBub3QgZmluZGluZyBpdCBpbW1lZGlhdGVseS4NCg0KDQo+IA0KPiA+IEJ1dCB0
aGlzIGRpZG4ndCB0YWtlIGludG8gYWNjb3VudCB0aGlzIGdlbmVyaWMgQVBJLCBsb2NhbCBxdW90
ZSBwcm9jZXNzaW5nDQo+ID4gdXNlIGNhc2UuIFdoaWNoIGlzIGtpbmQgb2YgYSBzdXJwcmlzZSBh
bmQgSSdtIGFjdHVhbGx5IHN0aWxsIG5vdCAxMDAlIGNsZWFyDQo+ID4gb24gaG93IGl0IHdpbGwg
YmUgdXNlZC4NCj4gDQo+IEl0IGlzIG5vdCBsb2NhbCBxdW90ZSBwcm9jZXNzaW5nLiBUaGlzIGlz
IGxhYmVsaW5nIGRhdGEgcHJvcGVybHkgc28gYQ0KPiB2ZXJpZmllciBpcyBwb3NzaWJsZSB3aXRo
b3V0IHRoZSB1c2VyIGhhdmluZyB0byBtYW51YWxseSBhbmQgZGlyZWN0bHkNCj4gaW5mb3JtIHRo
ZSBzeXN0ZW0gd2hhdCB2ZXJzaW9ucyBvZiBJbnRlbCBDUFVzIGFuZCBURFggbW9kdWxlcyBpdA0K
PiBzaG91bGQgZXhwZWN0IHRvIGhhdmUuDQo+IA0KPiA+IEkgdGhpbmsgd2Ugd291bGQgaGF2ZSB0
byBjaXJjbGUgYmFjayB3aXRoIGV2ZXJ5b25lIHRoYXQgcHVzaGVkIGZvciB0aGUgaG9zdA0KPiA+
IGNvbnRyb2xsZWQgcXVvdGUgdHlwZS4gTGV0J3Mgc2VlIGlmIHRoZSBsaWJyYXJ5IGNhbiBkaXN0
aW5ndWlzaCB0aGVtIGFscmVhZHkNCj4gPiB0b28uIFRoaXMgYXR0ZXN0Y3RsIHRvb2wuLi4gaXMg
dGhhdCBzb21ldGhpbmcgdGhhdCBjb3VsZCBjb25zdW1lIGEgbGlicmFyeQ0KPiA+IGxpa2UNCj4g
PiB0aGlzPyBPciBzb21ldGhpbmcgdGhhdCB3b3VsZCBoYXZlIGEgbm8gZGVwZW5kZW5jeSBpbXBs
ZW1lbnRhdGlvbj8NCj4gDQo+IEkgd291bGQgaG9wZSBmb3Igbm8gZGVwZW5kZW5jeSwgdGhlIGlk
ZWEgd291bGQgYmUgdG8gcHJvdmlkZQ0KPiByZWZlcmVuY2VzIGZvciBhbnlvbmUgd2FudGluZyB0
byBtYWtlIHZlcmlmaWVyIHNvZnR3YXJlLCBhbmQgYSB0b29sDQo+IGZvciB0aGUgYWRtaW4gdGhh
dCB3YW50cyB0byBkZWJ1Zy91bmRlcnN0YW5kIHRoZWlyIHN5c3RlbXMuLg0KPiANCj4gQXMgd2Vs
bCBhcyBhIHBvaW50IHRvIGhhdmUgYSBzdHJpY3QgaW5qZWN0aW9uIG9mIHNhbml0eSBpbnRvIHdo
YXQNCj4gcGVvcGxlIGFyZSBkb2luZyBzbyB3ZSBkb24ndCBnZXQgcmVwZWF0ZWQgQUJJIGJyZWFr
aW5nIGluc3RhbmNlcyBpbg0KPiBmdXR1cmUuDQo+IA0KDQpSZWdhcmRpbmcgQUJJIGJyZWFrLCBp
dCB3b3VsZCBoZWxwIGlmIHlvdSBjb3VsZCBiZSBtb3JlIHNwZWNpZmljLiBIZXJlIGlzIGhvdyBJ
DQp0aGluayBpdCBzaG91bGQgZ28uIFBsZWFzZSByZXZpZXcgYW5kIHJhaXNlIGFueSBpc3N1ZXMu
DQoNCjEuIFRoZSBob3N0IGFscmVhZHkgY2FuIHJlcXVlc3QgZGlmZmVyZW50IHF1b3RlIHR5cGVz
LiBCdXQgdGhlIGd1ZXN0IG5lZWRzIHRvDQpnYWluIHRoZSBhYmlsaXR5IHRvIGVudW1lcmF0ZSBz
dXBwb3J0ZWQgdHlwZXMgYW5kIHJlcXVlc3Qgc3BlY2lmaWMgdHlwZXMuDQoyLiBPbmNlIGEgc3Bl
Y2lmaWMgdHlwZSBvZiBxdW90ZSBpcyByZXF1ZXN0YWJsZSBieSB0aGUgZ3Vlc3QsIHRoZXJlIGRv
ZXNuJ3QgbmVlZA0KdG8gYmUgYSBsYWJlbCBpbiB0aGUgYmxvYiB0byBkaXN0aW5ndWlzaCBpdCBm
cm9tIG90aGVyIGZvcm1hdHMuDQozLiBOZXcgZm9ybWF0cyBjYW4gdG90YWxseSBjaGFuZ2UgdGhl
IGJsb2IgbGF5b3V0LiAobGlrZSBpZiBhIERJQ0UyIGNvbWVzIGFsb25nLA0KaXQgY291bGQgYmUg
YWRkZWQgYXMgYSBuZXcgdHlwZSkNCjQuIEV4aXN0aW5nIGZvcm1hdHMgY2FuIGdyb3cgaW4gYmFj
a3dhcmQgY29tcGF0aWJsZSB3YXlzLiBMaWtlIHVzaW5nIHVudXNlZCBiaXRzDQp0byBleHByZXNz
IG5ldyBmZWF0dXJlcy4gQmFzaWNhbGx5IGdyb3cgbGlrZSB0aGUga2VybmVsIEFCSSBkb2VzLg0K
NS4gTmV3IGtleXMgY2FuIGJlIHJlcXVpcmVkIHRvIHZlcmlmeSB0aGUgcXVvdGUgYW5kIHRoaXMg
aXMgbm90IGFuIEFCSSBicmVhay4NCldoaWNoIG1lYW5zIGEgbG9jYWwgb25seSB2ZXJpZmllciBj
YW4ndCBiZSBleHBlY3RlZCB0byBmdWxseSB2YWxpZGF0ZSBhIHF1b3RlDQp0eXBlIGZvcmV2ZXIu
DQoNCkkgbmVlZCB0byBjaXJjbGUgYmFjayB3aXRoIG91ciBhdHRlc3RhdGlvbiBwZW9wbGUgYmVm
b3JlIGNvbW1pdGluZyB0byBhbnkgb2YNCnRoYXQgdGhvdWdoLCBiZWNhdXNlIGl0IG1heSBjaGFs
bGVuZ2Ugc29tZSBhc3N1bXB0aW9ucyBvbiB3aGF0IGtpbmQgb2Ygc2xhY2sgdGhlDQp2ZXJpZmll
ciBsaWIgd291bGQgYmUgYWJsZSB0byBwaWNrIHVwLiBJIHRoaW5rIHdlIGFsc28gbmVlZCB0byBj
aGVjayB0aGVzZQ0KcmVxdWlyZW1lbnRzIHdpdGggdGhlIHVzZXJzIG9mIHRoZSBtYWluIHVzZSBj
YXNlLCB3aGljaCBpcyByZW1vdGUgYXR0ZXN0YXRpb24uDQpUaGUgZXhpc3RlbmNlIG9mIGEgdmVy
aWZpZXIgc2VydmljZSBhbHdheXMgc2VlbWVkIHN0cmFuZ2UgdG8gbWUgYW5kIEkgd29uZGVyIGlm
DQppdCBpcyBkb2luZyBzb21lIGV4dHJhIGpvYnMgdGhhdCBhIHN0YXRpYyBhZG1pbiB0b29sIHdv
dWxkIHN0cnVnZ2xlIHdpdGguDQoNCg==
