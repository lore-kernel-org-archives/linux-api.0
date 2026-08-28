Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22910347BD4;
	Fri, 28 Aug 2026 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787935727; cv=fail; b=VDgEFnxSHAgI70Haf/2NQf0INyhubfercXOHuffTSUjKVh+aQCOSD4C9SxIUCUwVal7OOhJhUfFmQ3WwHH3hif1/B+zsCW5f4vBG90xAiqCTtUP8PlQUViXrZACu8ICQw/cdwUMDfcPj85PjdgJmLeXATbuVwtpTPZcCGD2noVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787935727; c=relaxed/simple;
	bh=dqijZOOOl0+1VHzOyFvGyFaZHjAmkCRBr1QoJCRhNog=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CFswRpepWmDG1j7oFIossQBwotz1AIcu2HW1/CQDI6pbpw4zGhAtndsVuLd8YfGswy36NkvgngpHxVoJgmQIc3zOCI0OY9WoxxeNrIbjznFKEKODodj/y4e8AdHBkf0YCtdL1eZVZMnn6uzLq7Ny3kyPbsOtwUtfR0dMxJ3Eivo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NHeQqcQ6; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NHeQqcQ6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787935726; x=1819471726;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dqijZOOOl0+1VHzOyFvGyFaZHjAmkCRBr1QoJCRhNog=;
  b=NHeQqcQ6Idx/sjNUp9Zvf5Dst1GGaR7Alo26wamPcc0xzIML22SAAVk7
   Fy9B7H7Yvzyg8R0PrRJia7MiKj7oFSk6ANCzRbqVCqAeNKEhpj1fPn4UP
   vbOqmgVX6JDglETP1HqYpUB6XUwLC8Ub4MI8RkNAvEQvi5nyqyv0GR9is
   tfMSnS4T/DtK/2jzilBuqDQEqHfdblRbbVnkQc69k7VO7J3t8jf2iys0f
   rlx/iTab8U98C20HhuQaOI4KBjQ7KGg3u+VmfzEaVN4+3ejxk6pHMzn+n
   rM2CWJdpebvo67PIct003Ib88SDC9i7C5mDuOYr8ZWIlJNur3CCTE3Fja
   g==;
X-CSE-ConnectionGUID: BpgTfPbGQiGWeidbjFUFvw==
X-CSE-MsgGUID: Hyf0R1ZmR068srj5p/1ceg==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="88372923"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="88372923"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 09:48:43 -0700
X-CSE-ConnectionGUID: dHESZ9EVQK2x53giWQTqrg==
X-CSE-MsgGUID: xwpsA2jdS/mCqQT5eHrfTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="263921770"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 09:48:43 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 28 Aug 2026 09:48:42 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 28 Aug 2026 09:48:42 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.22) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 28 Aug 2026 09:48:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ayq2CC6ZY4uxtfrViN1G4uBOFQx5qtx+beBV4VkYzuykIL6fi0V9wY+LsddJY8fA9n/i62OmS4B+EZWfB2AbcVT+Sa5+hWTHkT4simWBNEwO/+8+fDkNRl5YogpvrcCKeCT6H5Z7xhYfBv6xW6CRU4fXtzFSnTOoI3L48TXX5T5nCVMcA7eLllaYay69LCAJYWV10rUr9b7F5Bzt/cK8/bvao1I0MiGppgggiO4tjsP2rOyw0KqCDwUASJDNwh9pDHKwoyoi7iz5QUyc7Ili/xKSDPQVqaoox1OYG1gDo4uV2tVS5g9q1MWKFSKZcjMUjtCs0h4bNuyf+G06A/QasQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dqijZOOOl0+1VHzOyFvGyFaZHjAmkCRBr1QoJCRhNog=;
 b=iCnDu1euBNi4CJU0UJBmhcw426OBJHgw5nqUsimJuO4/mpBDHmMi06woySmnPdO75D9B/CTe+JSsjEF7QISc0YtxU6hr1vYQG1A0SNGOarO5AvZVblxWOt4DnwT4pCZ0wjobwGOC3QTgKDwq4I7xo/WZtXNIg5zIepn2cSe2mvmoaill30d8eA2MCxw+3NbB0zjAEHhvUQHid+I9ZFJRrOq4RrPT//mIYeJi4UzxCCOXipUBCfPRRXl5akSHm0xODtwvdt9Puwzy5MyU9/kNu7YzlHEZ5zA3aM9C/GDw5HCr/9wFMo2vyR4vpkyypZMkwxascHG/DVBrB22Yce7AHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20)
 by PH0PR11MB5901.namprd11.prod.outlook.com (2603:10b6:510:143::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.11; Fri, 28 Aug
 2026 16:48:36 +0000
Received: from PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4]) by PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4%4]) with mapi id 15.21.0360.006; Fri, 28 Aug 2026
 16:48:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "broonie@kernel.org" <broonie@kernel.org>
CC: "debug@rivosinc.com" <debug@rivosinc.com>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"bill.roberts@foss.arm.com" <bill.roberts@foss.arm.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>
Subject: Re: Shadow Stack Locking Semantics between arch's
Thread-Topic: Shadow Stack Locking Semantics between arch's
Thread-Index: AQHdNkfbtZ5ZknJJAkKNElU5hV4EXbayLRYAgAAGJgCAADXRgIAABBmAgAAPo4CAAPh4gIAAOFGA
Date: Fri, 28 Aug 2026 16:48:36 +0000
Message-ID: <e126b2a52321c0a9a6e9de425304e01a62256634.camel@intel.com>
References: <a1946d93-370e-4ca9-85d6-60b4a20ffd47@arm.com>
	 <3bb672e0-7bc3-434f-904e-aa00394dd01f@foss.arm.com>
	 <d20ccb74-69ed-45d7-a810-846904873588@sirena.org.uk>
	 <01b0fe86d5700847f78b0e6f839119f54ac88b04.camel@intel.com>
	 <apCvGct9U1yprAUE@sirena.org.uk>
	 <f2819c4f1a86845b5b2f2b6f0e03f4c334e84eaa.camel@intel.com>
	 <c4ac49d9-1fdb-46c4-9303-f17a517ac4c1@sirena.org.uk>
In-Reply-To: <c4ac49d9-1fdb-46c4-9303-f17a517ac4c1@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6771:EE_|PH0PR11MB5901:EE_
x-ms-office365-filtering-correlation-id: 92b4ecf2-73cc-4419-0dee-08df05243485
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|18002099003|22082099003|4143699003|56012099006|11063799006|38070700021;
x-microsoft-antispam-message-info: aOjFXwTGEjH+64eouyx5Y84LNmoNnWs+kbtAqhMb74N9a+RkXaRDxnQir0TT6sOX8r22XCFAUFca4sHu449aRVMq5Q4qG0+7Pbz4qfKncOATzK4x0KRoVSpQwLApYYr9A0zgu5UCgvv4+VwmXPVyyN+e/kk3J1yZyGepyK6l/wEYnVwdq4zWMauH7kltoyroSrV/Kmyc//GEYlcXMjuJuKZ9ZDfWjnsHvmcia5Xe8iAT7QNhMOKuxwQoVvoBmJarn2L04HUJRAlvImWpJpSeI3Uif4UTWScMr2hdKlYQsAbw/J9MqSB9YigEesMkYljeBeJjVYd2a5EVIacUQUMOA1syVXekwsIgKBdYKVHnv/LX7nArPKZ8PHnHXVm7yfdSIYI1zun3qlzK7XSTqfW21mJkEQsaPD8zrzEQ905E3jCyv70ev4/7NR/k4hUQ5MN71Dr2tdTD/DJhHjnz5qJvF063LNikEvtSIGM8hUcgJuMzpq2yu0rjiudr9Dolwk5KZTia0+zwVpGiQTu5ZXdntz8RFxypwkkXwNuXz2u8Ir88nUp8c0FiXZwhh1wO2xErXZRo9sRqf+VAGUXrBME6NxXB7FzzLxd/1JpQGp6uFVvAwXY6LMmJxqn53KVDiHRa4mqE2oJgAaVXsMr/udKQXAgq85J78M4dp4hPPVD9vVxnQ2CoSoNrAKGh0/+4ftG+YvHLxSXiYZn93KvLd0Wb3++yT2dvdBvkfr/S1gLWd08=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aE5RcC9aV004KzI0dE9CUnFrR2lzbzMyQm42MFpvM3MvbDZhM3dvdUxSb3kz?=
 =?utf-8?B?MEN4OFRYTTNFc0pIKzdEMXcxMDU2d21USFhkVkZqVXFEeEx2Q05heThjYVdI?=
 =?utf-8?B?Rk1BR3htWHdqd0xvUUMzTjhzQXRrcnYzbUwzMW5DWkltR29xcG40OTBKc2VI?=
 =?utf-8?B?SlJWOTdIMEUrOVJLUXpPdUl5U1E4SS92NzhoMU9XRFhzZWZlRFRWcmFCRng5?=
 =?utf-8?B?ZGp5bEFXVUVEazYxYXRJWnlYeExDN1lOZ2ZzQyticWdsTjNMWjJsMjN3ZzhN?=
 =?utf-8?B?bUdkejFEQWtpdDNHb0t1N1NCNHNKdEdqN2ZIZzIwbm9mS1ZHNStzMTRBVW01?=
 =?utf-8?B?UDhnTVBJcGNIMkQycVlHZndIUi9LL1Y5a3BoSHV3SUp6N1FMNFZhYXRkN2N2?=
 =?utf-8?B?NkcvaHFGNXdSY21seXFOYlRtTjRjQmR0Zk1ObHMybFp0Wk13bEd0NVVRZElL?=
 =?utf-8?B?Y2xXQjZxL1VKNy8yc09tNXh4Nng0cU9LMlNvTXhHV3FTbmQyVmdvMkRTdXln?=
 =?utf-8?B?R2M0T2FBSkN3VzV1NnZiZWZVeGJEK0dnYm5nQ24zTklJZUxIZmVlWU16Wm52?=
 =?utf-8?B?NVZLeUs3RkswQlQ0dlV0M1lkaSs5MndWM2M5UTRXa095YXk5UGEwTmN2UmdR?=
 =?utf-8?B?WFZteWFtczVoZ1U3T1dvbUpSRHBUK0g4K0FDblg1SXNBS2R3NE1PcEYzL1dE?=
 =?utf-8?B?cnM5c2dFWXhXQWc0R3R4cG55emJyRnBUK2Q2VmJISGJiRDJXUnM4eWhidlNn?=
 =?utf-8?B?Q0lQY3lNcmE4QkJtNHQwS2w4bEg0OEs1TjUxd0FVZ1pDR2lmQTE2WGFjUjJK?=
 =?utf-8?B?bUhRMldqMUhtQ2hYRVB4cWNKYjU4MzRQdDBWSTVKQ0xhOFRUYTg1K2FVc3lo?=
 =?utf-8?B?d0dtVlJhNWFvRFlsR2lZaE9OZk5GVmwwV2tFTDZaaURWaGJRUWJaRE41THli?=
 =?utf-8?B?WFoxa3pRdkU2cW03UGhpMURzNnJYM0VrV2Q5VnJtSW9DdUFaNFNjdnJpSUFm?=
 =?utf-8?B?UTh4ckFJYmF0VFFFZ0lRZ2hZY0tsbkozeGQvd2lIUytnS3owNktmM2hxNllY?=
 =?utf-8?B?aUlFWHhqZks2dlFrdDdWK1krN2FCUGx3emsyNk02UnlDczA4Y1B1c2VBVHRX?=
 =?utf-8?B?Q01BRU1GeFRBUmZEZ0J1UEJ0UFhaUmFjdHU2cFlNb2EzNkp5elBxT2xTU1Jx?=
 =?utf-8?B?TGdrZ3p3NURlSVRUZWNHYlhSVnI0V3cyME5kei95UVFQenB2T2w2Zys0NDJa?=
 =?utf-8?B?NjZpTFdXd1I3Skx1VTlsNzlJRUVuTjJJSjJ5RkhKcjhvWUIrdU82QWREa0I5?=
 =?utf-8?B?aUl3N2pQbkNlTDJQN1NXd0ZzU3ZsNFBjRTVFUmRPZDFBemtKOTRvaFpEaTh6?=
 =?utf-8?B?amwrd3Y2d3YzRS9oL1R0VTNuRmVvSUUwdlkvUm5OcklRV2VQWTM0eHFjTG9H?=
 =?utf-8?B?T1VkWXk3cldpWVZpMk40d2ZyNXFBc0IzV2JUVHdZc0RpczJMS0szSjRoaEZW?=
 =?utf-8?B?QVZUMlhPaFN4VEZTRlV4RjQ2Nmh3WW1BaHNOOVN0MEgxUmcxQ1RFcHFOSm9P?=
 =?utf-8?B?bzN4R3drMXhOaXFtYlJCR3J2SGxFYy9jZmwxYzBDUDRTMkwzRndYdlFMdnFI?=
 =?utf-8?B?TnVIVXpCeEd6N2h2dmtYRG5KRkErbE8zWmhBZnBPL3ZaZlZkVitiNGpkTDBH?=
 =?utf-8?B?ZnJoTkNaNmpNU3MrR0k2WFpxSU16TnhKUmJsdGhtT1dQdVBGM2tEbGQ5ZlFV?=
 =?utf-8?B?VkMvcXo4Tyt0NVpnZS9mQU92WThJWkhtQTZPelFuUngxTFBEWHRCZHpTZTJH?=
 =?utf-8?B?bTNNbWlIb282aFpzc0VNQ2REWkdodEoxRHkxMVlYT0lVQm9RZElsTnVGTGV3?=
 =?utf-8?B?VWlidWNpZGhXQ1NKYVFnZ2wwdjN4QnlLN1VxSlJTQVdYeFJnMDZYdU9qN3JH?=
 =?utf-8?B?WE4vYno1WlBBMlZuOXkrU3oyUTIzd2Jkam41VjFCVUR6R0NJM3R6U2tiSyt0?=
 =?utf-8?B?UE5zZ2hCalkrQUY5TnYxTE9vVUtkcldYN2E1NG9TajFNaG1QZy9NaTRBQXJy?=
 =?utf-8?B?SkFpcmtSdkdPNG9vWkJWM05lYXdKNXFRaXpzYmorSVBaNEZUNnNVQ2dXOTgr?=
 =?utf-8?B?VUxESFdpcUVjVHBlN0huVjVJV2toeTdzTVFZQ25icDFzcGJ2aUpLMWx4YU5F?=
 =?utf-8?B?eHFjK2VNb3pjWUM1VGNTMEFQOUNTaFc1QVg0MTAwSzhFUTJzdE40bW9jU3lI?=
 =?utf-8?B?T2E1dWFmRDVUZ1Y5T3hrV3ZralhEUkNja01vbFVKVm1Zc0JvdDBlU2VmSUVT?=
 =?utf-8?B?V0RnTEtrTnIvS3I1dGwvaHJneXV4bUJLM2FxUjdlQ2ZEcGpKRHI5RTRTL2hS?=
 =?utf-8?Q?fvk8BkmV4N+Ks9HI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56FCA18828E8664F8A1675BE308F6F98@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: kotsjPPhVSNf1rTVr1egZRx1t3z+aVGSuxERgrFjR8YM3yyf5BUhPQ/xFdur+AGb1AcVoygw0tHt4aIdMyh+W/MCQLHUCNQuznBNo2lGNgBcnTR5aVNKV9oRX/0FCl1iYoKwcwceD4uMP0r1jT/XeTXfuiYYwEHpWXKVI2uBYXuK9MNXmkyoa3So1vbardVYBqgoqEYg/K4Y0+OuI+YCYFrhC+RbFnjmPhlqFiQ1bcHVhYEPBXal+s0Z15OLSRv93AJQpqVHmi0ivjhL852BqZsR8e1MoWZJsEFzF4REJqpEPUWxink7US5dLgIpwiHRge7zby/uxd0cet9/oGvxxg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b4ecf2-73cc-4419-0dee-08df05243485
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2026 16:48:36.7377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J6RPsX44C+2cCLKINpon15+pJwn3hr2qUG/UQg1t++DBboxKU7Fh0MXhqrzvIN/FSCDoQ0DptycRqNpApUT75C0vkDzPCyRnWBAEhslGE/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5901
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTA4LTI4IGF0IDE0OjI3ICswMTAwLCBNYXJrIEJyb3duIHdyb3RlOg0KPiBZ
ZWFoLCBpdCBpcy7CoCBJIGNhbid0IHRoaW5rIHdoeSBzb21lb25lIHdvdWxkIGFzayBmb3IgdGhh
dCBlaXRoZXIsIGJ1dA0KPiBlcXVhbGx5IGl0J3MgbW9yZSB3b3JrIHRvIGV4cGxpY2l0bHkgaGF2
ZSBhIGxpc3Qgb2YgY29tYmluYXRpb25zIHdlDQo+IHJlamVjdCBmb3IgcG9saWN5IHJlYXNvbnMu
wqAgQXQgbGVhc3Qgb24gYXJtNjQgZWFjaCBwZXJtaXNzaW9uIGp1c3QgY29tZXMNCj4gZG93biB0
byBhIHNlcGFyYXRlIGJpdCBpbiBhIGNvbnRyb2wgcmVnaXN0ZXIgc28gdGhleSdyZSBmdWxseQ0K
PiBpbmRlcGVuZGVudCBhbGwgdGhlIHdheSBkb3duIHRvIHRoZSBoYXJkd2FyZS4NCg0KSWYgd2Ug
d2FudCB0byBoYXZlIGEgdW5pZmllZCBBUEkgKEJpbGwgY29udmluY2VkIG1lIHRoYXQgd2UgZGlk
LCBidXQgbWF5YmUgd2UNCnNob3VsZCBoYXZlIG1vcmUgZGlzY3Vzc2lvbiBvbiB0aGlzIHBvaW50
KSwgd2Ugd2lsbCBuZWVkIHRvIGhhbW1lciBvdXQgdGhlIHNtYWxsDQpkaWZmZXJlbmNlcyBiZXR3
ZWVuIHRoZSBhcmNoJ3MuIEZvciB0ZWNobmljYWxseSBzdXBwb3J0ZWQsIGJ1dCBub25zZW5zaWNh
bA0KY29tYm9zLiBJJ2QgdGhpbmsgdG8gcmVzb2x2ZSB0aGUgZGlmZmVyZW5jZXMgYnkgbm90IHN1
cHBvcnRpbmcgdGhlbS4gQnV0IEkgbWVhbiwNCml0J3Mgbm90IHRoZSBlbmQgb2YgdGhlIHdvcmxk
LiBJbiB0aGUgZW5kIHdlIGFyZSBqdXN0IHRhbGtpbmcgYWJvdXQgY29uZnVzaW5nIGENCmhhbmRm
dWwgb2YgbGliYyBkZXZlbG9wZXJzLiBUaGV5IGNhbiBiZSBwcm9iYWJseSBoYW5kbGUgdGhpbmdz
Lg0KDQo+IA0KPiA+ID4gPiA+IEl0IGhhcyBiZWVuIG9uIG15IGxpc3QgdG8gbG9vayBhdCB0aGlz
DQo+ID4gPiA+ID4gcmVwaXRpdGlvbiBhdCBzb21lIHBvaW50LCBpdCBoYWQgYmVlbiBoZWxkIHVw
IGJ5IHRoZSBjbG9uZTMoKSBzdHVmZg0KPiA+ID4gPiA+IGJ1dA0KPiA+ID4gPiA+IHRoYXQgc2Vl
bXMgdG8gaGF2ZSBkaWVkIGEgZGVhdGggZm9yIG5vdy4NCj4gDQo+ID4gPiA+IE9oPyBXaGF0IHdh
cyB0aGUgYmxvY2tlcj8NCj4gDQo+ID4gPiBCYXNpY2FsbHkgdGhlIGdsaWJjIHBlb3BsZSB3ZXJl
bid0IGNvbnZpbmNlZCB0aGV5J2QgZXZlciB3YW50IHRvIHJldXNlIGENCj4gPiA+IHNoYWRvdyBz
dGFjayBhdCB3aGljaCBwb2ludCBoYXZpbmcgdGhlIGtlcm5lbCBmcmVlIGFuZCByZWFsbG9jYXRl
IGVhY2gNCj4gPiA+IHRpbWUNCj4gPiA+IGlzIGp1c3QgYXMgZWFzeS7CoCBJdCBzYXZlcyBoYXZp
bmcgdG8gaGFuZGxlIGNvcm5lciBjYXNlcyB3aXRoIHRocmVhZHMgdGhhdA0KPiA+ID4gZGlkbid0
IGV4aXQgY2xlYW5seS4NCj4gDQo+ID4gSSB0aG91Z2h0IGl0IHdhcyBhbHNvIGJlY2F1c2UgdGhl
eSB3YW50ZWQgZmluZXIgZ3JhaW5lZCBjb250cm9sIG9mIHN0YWNrDQo+ID4gc2l6ZXMNCj4gPiB0
b28/IEJ1dCB5ZWEsIGlmIG5vIGxpYmMgd2FudHMgaXQsIGl0J3MgYSBoYXJkIHNlbGwuDQo+IA0K
PiBUaGV5J2QgcmF0aGVyIGhhdmUganVzdCBhIHNpemUgY29udHJvbCBmb3IgdGhhdCwgcHJvYmFi
bHkgYSBwcm9jZXNzIHdpZGUNCj4gY29udHJvbCB3b3VsZCBiZSBtb3N0IHVzZWZ1bCBzaW5jZSBp
dCdzIGxpa2VseSB0byBiZSB0aGUgc2FtZSBudW1iZXIgZm9yDQo+IGFsbCB0aHJlYWRzLsKgIEkg
c3VzcGVjdCB0aGUgbWFpbiB1c2UgY2Fzc2Ugd291bGQgYmUgc29tZW9uZSB0cnlpbmcgdG8gZG8N
Cj4gZ3JlZW4gdGhyZWFkcywgd2hlcmUgdGhlcmUncyBhbiBleHRyYSByZWFsIHRocmVhZCBiZWlu
ZyBjcmVhdGVkLg0KDQpPaywgZG9uJ3Qgd2FudCB0byByZS1saXRpZ2F0ZSBhbnl0aGluZy4gQnV0
IGF0IHNvbWUgcG9pbnQgc29tZW9uZSB3YXMgdGFsa2luZw0KYWJvdXQgYSBjYXNlIHdoZXJlIHlv
dSBuZWVkZWQgdG8gY3JlYXRlIGEgc3BlY2lhbCBsYXJnZSBzdGFjay4NCg0KSW4gZ2VuZXJhbCBp
dCBtYWtlcyBzZW5zZSB0byBub3QgYWRkIHRoaXMgaWYgbm8gb25lIGlzIHBlc3RlcmluZyBhYm91
dCBpdC4NCg==
