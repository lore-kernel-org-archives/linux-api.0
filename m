Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55813D7D88;
	Thu, 27 Aug 2026 22:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787870276; cv=fail; b=RpYG0taGK2cpbOaT13ON8NLowDcLivZxdXI4ke0XesRqdGJif23qJtJ7Q0CEbowOLSqyXWs49KRSJj83JkX4eUxG4g0aJxsWMBMcCUcp3MoApM5ZPXlaLVExvx2x58fYU1A45uNX9oljX69CRxTvuB3TqDVaxN+wENfQWf3pH2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787870276; c=relaxed/simple;
	bh=ta/Ts5Q/q33HQg5+aWHpibtWgyn42w9ol/dr0MWmHx8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j4ZjAgPKPVYPWJMyVQRGlF9Ox2V/L96gEoCvQJe3uzzK48zKzy5GtUwG33u9Vq/LmClcjJG6HeTeUFpZ6mdC5voV+2SK/NHb14/4IDukQrhIVjHBvziYGUhtHPXwoh4LOTNOpmuTn5eBTps7SJ4cmOL71qavzHVCsqgIKrrhEJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ze/NULIN; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ze/NULIN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787870272; x=1819406272;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ta/Ts5Q/q33HQg5+aWHpibtWgyn42w9ol/dr0MWmHx8=;
  b=Ze/NULIN8yMcW8Qf0kxitfNk5CFQ7xjHr+lGJKAFHzo5bLs+EoZE6MEX
   evweS63R8YHN24iC/ig8DxJpVQhGm41mqb1GEocmXTK3T1dCl9WdNGDYu
   Uwksx21x//ltMa1LIPBWt6roNhPJYERNUMvyP6uOhf6yAKRkDAS5pqf/x
   4WrrZDf+/n/WWX75gKiX/crl9+KRLVHTDPsQvDm9YY5Zg7NfF4XOeMjWL
   wGXIuR4y/CCiu4nPAfCXrMQYPkmNnZAt1S7pBmYq5GVS0+/UdN3aRHi39
   zrOG+/QbRAyMWsMrTi4VZizez/tYnL6cIeE/yOCVujuB4ISkv7laHHy0w
   Q==;
X-CSE-ConnectionGUID: 9IU3kdfGQayMZx3dApSDVQ==
X-CSE-MsgGUID: XYrkwFBDRpqfX7F3J7Um0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="92239297"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="92239297"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 15:37:49 -0700
X-CSE-ConnectionGUID: AsjKIJR6QJCi9+x/zUIbRQ==
X-CSE-MsgGUID: ruxL5Le1SYeO2tdkCHFZGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="297898802"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 15:37:49 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 15:37:47 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 27 Aug 2026 15:37:47 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.66) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 15:37:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VaUTLMGoLUUzlevDRts683gizw7+BTOHkZ1bum2O4jwotrXhtARFfnA1peaFL2sTs6uDreDKXl4AgTxYyp7Cg0Nk2BGvrfx6qSz9kAx/mQ6liIBp2wcCm7u1P4ZqStyooH1EgXRkCyn25P2FsKzK2DDwbGrkiMRreyn5clifp/4CFIOD3q2KQAHsNOHnMoK6q/BK9vKfLh27vnLEy6p2agujkMpeFCdAZ9RhoM9kTGYji79njstEoOoJuRKB3nKppslADGA+Z1jmr2VHhLg2Ok6s5ttbmsFFHnw1Utn+ztxtsHM/axYxDzwYjXNqMG83uv+2SDuBfYmhK4IoZi+5pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ta/Ts5Q/q33HQg5+aWHpibtWgyn42w9ol/dr0MWmHx8=;
 b=Jwza6fhK538Pwurgg00VFU7IA2o3mb1o9DQt2Cwp2qfPshMG6NDUe0v9TD83Phk40mAKHGRnw2mrklzFW3z/1FEj9wQyNIS9uC4d/hK1JMYLeFsmDbiv195F7GEiA1/4h6P3Qi3rIez11OCEWNTIAP1E12C2J2gyXKIxbQre/DJ/lSp6NxTCleKPGHUklLQ2eP+p2CQLrvJ6S+v/htpqlX5tXSZ9tHzEg9+lKxbBqnkMsLJ2keF/XCIiyEpW+UwUfhvSwkTf4w5k+K8jLxu7lkFV0MuUobgY4jg99CSt1QNQfYBQmfSpH/Vi1AK1Kj8wGil3Ko8dqtS8TOsTDvkY5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20)
 by SJ5PPF8EC896901.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::844) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Thu, 27 Aug
 2026 22:37:45 +0000
Received: from PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4]) by PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4%4]) with mapi id 15.21.0339.012; Thu, 27 Aug 2026
 22:37:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "broonie@kernel.org" <broonie@kernel.org>
CC: "debug@rivosinc.com" <debug@rivosinc.com>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"bill.roberts@foss.arm.com" <bill.roberts@foss.arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>
Subject: Re: Shadow Stack Locking Semantics between arch's
Thread-Topic: Shadow Stack Locking Semantics between arch's
Thread-Index: AQHdNkfbtZ5ZknJJAkKNElU5hV4EXbayLRYAgAAGJgCAADXRgIAABBmAgAAPo4A=
Date: Thu, 27 Aug 2026 22:37:45 +0000
Message-ID: <f2819c4f1a86845b5b2f2b6f0e03f4c334e84eaa.camel@intel.com>
References: <a1946d93-370e-4ca9-85d6-60b4a20ffd47@arm.com>
	 <3bb672e0-7bc3-434f-904e-aa00394dd01f@foss.arm.com>
	 <d20ccb74-69ed-45d7-a810-846904873588@sirena.org.uk>
	 <01b0fe86d5700847f78b0e6f839119f54ac88b04.camel@intel.com>
	 <apCvGct9U1yprAUE@sirena.org.uk>
In-Reply-To: <apCvGct9U1yprAUE@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6771:EE_|SJ5PPF8EC896901:EE_
x-ms-office365-filtering-correlation-id: 705be719-c20a-47de-6c67-08df048bd067
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|38070700021|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info: lqECK5KCeBSuoIMnuHmThKa8roD3bRL7Gv2icmsSZg16ZodtfpWLv/tc/pVREfulV3fFziMfnXb9p6GesAcaLIHRA3Kee5nMrmFtpgCSsloAr65Ca/uF5S9pkZXqqCVHfAY1/3Imu9UjE7SEshujXJ8Dt1UEB4PahvGmG2L9gjoDbZ0XjiBopuehPY/PYqxttUlyEofOZhH2HJW5PYWpkWoF630GUvmpUV1jjpuIeMm/Ujev0pTlbI2fbYwbauWml3zOSWUbWAVpCJDYrS9I4sDQNfT6V8c+c+ZJ1js4NWSF2NL9vbZ/+GQyP4Rr1Y3hBDrCCJ8kXWbIvYpvXWG+Dq3lB9/RDLOQKEmqhf2cn4fm+UkHOgzfwYa1JJM6BaFqohnzDlRHe4AhF+8mD6m80nvbwvoxkxcgUdsK1hXTcmutw6vesnkvlO7obV7CZLXaNmJcthhuGT4rvM5r1+QqW0KY5zWkzS2xwxTEkUz/Kcny9uF4wQSE1VcIGtv0GunnmuvFzkWj03Fzr3gztoYIffzL0K12SoB+81xgu6aPyEwGt8gsHiZcHlxKLqTDHEE8ufSSYRmmU1TtEqkL24JIErPrnZm0Kgec2wIQTlN01gRT6Zj3JgsWhwPtq7/DR0KI1g/NgAx/mLFy90npNQtMdWX15mq/9q7B0RgMMnIrAKGE9w+F/zIbTdD0w/iouVJOYm/ivobgxl7EwjnO1W1bi3wOoN8FpjwoaPI7K3WdL04=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(38070700021)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2toQmpLeG02L2dnNHZhbnRVakJLamVDNlZCUlZlM1orY1h4QmFNS0psOGVK?=
 =?utf-8?B?K1BlVWFUc3pGQ3Zra0paeWRtdTBiczdoU25zdzIyT1NBZCt4MjR6Y1ZMQU41?=
 =?utf-8?B?NXpINVB3ZWtEWjcwRUJ5SzVndzZGYlJKMk1RelI3RG92SU9HUndUUjBBTzN5?=
 =?utf-8?B?ZVBaY3V4Tyt5TmJUZjVrMEVGQUlKZjVpblR1YkJkemNHSTg3ajFQVVFnNTVM?=
 =?utf-8?B?Q3grSTNLeitKSUdhcC9paUJVSkZSZjhQU3dadG51VUhOcGhKUi9OSVo0VDgx?=
 =?utf-8?B?LzdVNXVoM0dBdEtMbW41QVVVa3JSVm9IemdzVmxvMG9MVHBwLzJqL0Q0Nk9v?=
 =?utf-8?B?V2RYV1plWkhiNlpwRXBPZUs0MGhobWRlNDNZSit5U2hpQzR6YkFOQU1wTUt3?=
 =?utf-8?B?Wjd4RE5KNkFHKy8rMllIM2phOGRDT2dNT2ZucEVwQW9paFVFUWNtemlJUitO?=
 =?utf-8?B?K0dPSWg2RXBwNFNRL011aFBLZWVLUmwxUFM5UE11QVA1eVFoWGJIYVY3dHVC?=
 =?utf-8?B?VkFTay9oZW0vVVJhbmZkeEdTc0VzbFYxMHQyYzMyenJSaGxnWW84S2ttTXF4?=
 =?utf-8?B?QUhSV1VWcjZ0OFc5RDc0TWpLZ3k3bmlLcm52V3lpOURuaG9lZUkxSk8xM1Bz?=
 =?utf-8?B?bG41akZSZElDUWJrOXhTUC9rcnR2eG56NFFWYmtSRlhSWGE2NTI3VnhLSHpC?=
 =?utf-8?B?a3JDUUdINXlLaU5FajZodWlYWVVsT1lKbEU3VWdhV2Z1M1RJU1lVOTBZU3Nl?=
 =?utf-8?B?cysvQ29KZTRNb1pzU2lKRUc4Q2pmTGtQZUM4MTRMRkd2ZkhwS0FwY1BZVzl2?=
 =?utf-8?B?Q1FqeG5sakRZRGNTV0JhVmhJeXYweFg0TFVXMVhnMXF2b2Q5WFd5dkFNSHZw?=
 =?utf-8?B?KzlSMVdJLzJBRVYzVTUyT0pyTEpVRjNmNHhFL2s5QkRpNzA4QmZGQzVvcldS?=
 =?utf-8?B?SFZCUU1wRkhLYm1SWmtBRWlQWU9TYndxcWVTZXRCMlJQQVBZSVp5UWpnV2Vj?=
 =?utf-8?B?UHNvT0RNSlc0blZIT2RhaUIwZFBkVnI1dmFHKzBwQlNFZ2VjK3d0dk1LWVd6?=
 =?utf-8?B?S1JTckc5RTZRSEs4aDkyazlXM2lTMVV3a2NHYlgxTVp4dHZuM1RoVEN6NXJi?=
 =?utf-8?B?ODhVdysxS29jZFZzV3Fuay9mZ0svQVluUzNQcnE4emJleFBXd3RaRFJaS0VY?=
 =?utf-8?B?NmFOL1FFUURQWmZaQm9HRzFoRFdjemNHYXNGOStEZjRYTFBYbHJLRGlrdlJy?=
 =?utf-8?B?ZDBJY1NWNnFBVXBHYWIyR25pN0hmR1pLR3BwYkhYcWd6cTRvbFNtamtIYVhI?=
 =?utf-8?B?cXFrbEtFam1lTkpQVE1NMzRmWG9lYzlycTNNNmY1c1JFb0NHUXM4RTZEZmdn?=
 =?utf-8?B?ME45ZUlmclRoaXZnRGdYSWJDU21mMjV3cGtKSEFCakpwZFB6N2pQKzRoNTV5?=
 =?utf-8?B?RzVDcWgrU3ZJTGpLOENBY3JSdjZNUHY2TFJtaDBWODAwbmRidHJOUWlYUmFa?=
 =?utf-8?B?VGlsT1R4V3NISnR2aTBJZElWc3dqOUlWMDA3ejU5THdEa21KaGN1RWtOTGY0?=
 =?utf-8?B?elJrYXdmaVM3L21VeHp6SkkvOWNRbndvTUw0M1VvcDBMM0VUb01lcTNDZ3Mw?=
 =?utf-8?B?TnlabjFoS3dZZkFtOFc3NEwyd0xVQXFTY2hhWGI1TnFqNWdXV3QybGY4UTlX?=
 =?utf-8?B?VFc1UVdKUExEWjFBcUFXcEJXQkV4dDVjb3cwSnFsbEJ5UmVzU0hYUUJ3WkdI?=
 =?utf-8?B?bmxyS2JLU2s4bzFrN3RIM095UENCOTU3ZHlPNElpRVRjWG9pYk0vU1dhT2oy?=
 =?utf-8?B?cHpxUlRJMGIrMVhaR3oyc3ZBeFVrQlVka044S1FIY2V1MmZwaTJpaE92OTVy?=
 =?utf-8?B?MEZVK2pRN29Cayszdnh6Wk9LcWpzdFBYVTJBYnhvR2diS2Y1SEpXZ1NtWHRQ?=
 =?utf-8?B?TUt1YXhlcjNsZDhQZXhsQTFLb3BIaUgvR2NDRjRiWE1tUFlaNkQvYXFpZVFm?=
 =?utf-8?B?S29JQzA1SnZZdkF6TmFrVmRVcXY2VW42cGJKNzlFVGk4c2lSUTlaQy9lZXVn?=
 =?utf-8?B?WW5DOG9FN3pROGpWZTdvMkJITXFTdG9OclNDOXB6TWp1b2tmN1huODNQOFNk?=
 =?utf-8?B?U2JtZ1ZjUlR6TUI5NURDNFVGaHJhVXoyczRsNFhGQVpLSkZ2KzdDWWxiaGVi?=
 =?utf-8?B?VWV2MnRaT0Y2a0RqdEh6ODhzNGlnck9yV1d1VjQ1Zm43a20zSDJoN2lJY05R?=
 =?utf-8?B?ZEZjaDVJN0RVa085OVkrS0FrWHlRQnBSelNhSit2VUtXbEw4VjNVMGJ2VHZj?=
 =?utf-8?B?YUNBWFEzeWdVVnJtOEovNGM3U01BSUtDck9LU1dWTUU0M2JtaG5UTHhQcnJv?=
 =?utf-8?Q?H5G3C+AC4/J69lbE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0833CBF11ABE554EB635ABBB063DAC77@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: eyDrcZKcneA0XPTNkp8MNmLsDKVeCzaemBDjXO93gJ/OJC7UEeDNUExVz4L/AndyNrgJyHFLRBalmcBOiXjxTAZ5TVkamkDEL8M/U86dNn1Qqvb1VwiddWnNr7zmHLlYYMoljTnJn2/zqQjN950Zz7eU1wWdcIgVdeTMowaFJ6m9HdiND4aAsg0j644zWv+Iw3DfvIhtloHXEsDb/4MHOKiy/+YDti1nZ980Rr//qiw252JB0Ggl4ptAl6rdVTCwmqqimBDBJ0TUsgII2Y/z018XtAxPU03drK72RJk7BlWv2+6Ir6MgRmr3mps6TQ8weqDLAKzeCat51vkzAJqmLg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 705be719-c20a-47de-6c67-08df048bd067
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2026 22:37:45.2325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D0J4Or4DdARmuZ8YWZdPzaicLR0vsdH6XMDHwkwV6jJi3XLZlpeRjPyAnsQuW1+GxO0aVDus7sni9A4xMZYEVSPzO3RRV+QzciouVgf0SD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8EC896901
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTA4LTI3IGF0IDIyOjQxICswMTAwLCBNYXJrIEJyb3duIHdyb3RlOg0KPiBP
biBUaHUsIEF1ZyAyNywgMjAyNiBhdCAwOToyNzowNlBNICswMDAwLCBFZGdlY29tYmUsIFJpY2sg
UCB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMjYtMDgtMjcgYXQgMTk6MTQgKzAxMDAsIE1hcmsgQnJv
d24gd3JvdGU6DQo+ID4gPiBPbiBUaHUsIEF1ZyAyNywgMjAyNiBhdCAxMjo1MjoyOFBNIC0wNTAw
LCBCaWxsIFJvYmVydHMgd3JvdGU6DQo+IA0KPiA+ID4gPiBJIGFtIHByb3Bvc2luZyBhbmQgaGF2
ZSBxdWVzdGlvbnMgb3ZlciB0aGUgZm9sbG93aW5nOg0KPiA+ID4gPiAxLiBXaGF0IHNob3VsZCB0
aGUgYmVoYXZpb3IgYmUgaWYgeW91IGhhZCB3cml0ZSBsb2NrZWQgYW5kIGRpc2FibGUgdGhlDQo+
ID4gPiA+IHNoYWRvdyBzdGFjaz8NCj4gPiA+ID4gwqAgLSBJIGNhbiBhcmd1ZSBib3RoIHdheXMg
aGVyZSwgLUVQRVJNIG9yIHN1Y2Nlc3MuIEkgdGhpbmsgSSBhbmQgbW9zdCBhcmNoZXMNCj4gPiA+
ID4gbGVhZCB0byBmYWlsdXJlLg0KPiANCj4gPiA+IEdpdmVuIHRoYXQgUklTQy1WIGRvZXNuJ3Qg
c3VwcG9ydCBjb250cm9sIG9mIHdyaXRlcyBpdCdzIG1vb3QgdGhlcmUNCj4gPiA+IGF0IHRoZSBt
aW51dGUsIGFuZCB4ODYgY3VycmVudGx5IHVzZXMgYXJjaF9wcmN0bCgpIHNvIHdpbGwgbmVlZCBh
bg0KPiA+ID4gYWRkaXRpb25hbCBBUEksIGl0IHNlZW1zIHRoZSBwYXRoIG9mIGxlYXN0IHJlc2lz
dGFuY2UgaXMgdG8gYWxsb3cgaXQuDQo+ID4gPiBUaGlzIGFsc28gYXZvaWRzIGxvY2tpbmcgd3Jp
dGVzIChvciBwdXNoZXMsIGZvciBhcm02NCkgb24gZWZmZWN0aXZlbHkNCj4gPiA+IGFsc28gbG9j
a2luZyBlbmFibGUgd2hpY2ggc2VlbXMgbmVhdGVyLg0KPiANCj4gPiBIbW0uIEkgY2FuJ3QgdGhp
bmsgb2YgYSByZWFzb24gdG8gbG9jayB3cml0ZXMgYW5kIG5vdCBsb2NrIHNoYWRvdyBzdGFjayB0
b28uDQo+ID4gR2l2ZW4gbGlrZWx5IG5vIG9uZSBpcyBkb2luZyB0aGlzLCBJIHdvbmRlciBpZiB3
ZSBjb3VsZCBjaGFuZ2UgeDg2J3MgYmVoYXZpb3IgdG8NCj4gPiBtYXRjaCB0aGUgb3RoZXJzPw0K
PiANCj4gPiBUaGUgQVBJIHdvdWxkIG1ha2VzIG1vcmUgc2Vuc2UgdG8gcHJldmVudCBkaXNhYmxp
bmcgc2hhZG93IHN0YWNrIGlmIHdyaXRlcyB3ZXJlDQo+ID4gZW5hYmxlZC4gSXQgY291bGQgcmV0
dXJuIGFuIEVJTlZBTCByZWdhcmRsZXNzIGlmIGl0IGlzIGxvY2tlZCBvciBub3Q/IElzIHRoYXQN
Cj4gPiB0aGUgYXJtIGJlaGF2aW9yIChmb3JnZXR0aW5nIGFib3V0IGxvY2tlZCk/DQo+IA0KPiBh
cm02NCBjdXJyZW50bHkgdHJlYXRzIGVhY2ggYml0IGluZGVwZW5kZW50bHkgZm9yIHNpbXBsaWNp
dHkuICBUaGUgbWFpbg0KPiB1c2UgY2FzZSBJIHNlZSBmb3IgYWN0dWFsbHkgZG9pbmcgdGhhdCBp
cyBmb3IgcHJldmVudGluZyBlbmFibGluZyB3cml0ZXMNCj4gb3IgcHVzaGVzLCB0aG91Z2ggaW4g
cHJhY3RpY2UgSSdkIGV4cGVjdCBzb21ldGhpbmcgZG9pbmcgbG9ja3MgdG8ganVzdA0KPiBmdWxs
eSBsb2NrIGV2ZXJ5dGhpbmcgYWZ0ZXIgaGF2aW5nIGVuYWJsZWQgdGhlIHNoYWRvdyBzdGFjay4N
Cj4gDQoNCkxvY2tpbmcgd3JpdGVzIGFzIG9mZiBtYWtlcyBzZW5zZSB0byBtZS4gQnV0IGxvY2tp
bmcgd3JpdGVzIG9uLCB3aGlsZSBsZWF2aW5nDQpzaGFkb3cgc3RhY2sgdW5sb2NrZWQuIEknbSBu
b3Qgc3VyZSB3aHkgeW91IHdvdWxkIGRvIHRoYXQuIEkgdGhvdWdodCB0aGF0IHdhcw0KQmlsbCdz
IHNjZW5hcmlvLg0KDQoNCj4gICBXZSBjYW4gY29tcG9zZQ0KPiB0aGUgZmVhdHVyZXMgZWFzaWx5
IGVub3VnaCBzbyBpdCBzZWVtZWQgbW9zdCBzdHJhaWdodGZvcndhcmQgdG8ganVzdCBsZXQNCj4g
dXNlcnNwYWNlIGRlY2lkZSB3aGF0IGl0IHdhbnRzLCBpdCBrZWVwcyB0aGUgaW1wbGVtZW50YXRp
b24gc2ltcGxlci4NCj4gDQo+ID4gPiBJdCBoYXMgYmVlbiBvbiBteSBsaXN0IHRvIGxvb2sgYXQg
dGhpcw0KPiA+ID4gcmVwaXRpdGlvbiBhdCBzb21lIHBvaW50LCBpdCBoYWQgYmVlbiBoZWxkIHVw
IGJ5IHRoZSBjbG9uZTMoKSBzdHVmZiBidXQNCj4gPiA+IHRoYXQgc2VlbXMgdG8gaGF2ZSBkaWVk
IGEgZGVhdGggZm9yIG5vdy4NCj4gDQo+ID4gT2g/IFdoYXQgd2FzIHRoZSBibG9ja2VyPw0KPiAN
Cj4gQmFzaWNhbGx5IHRoZSBnbGliYyBwZW9wbGUgd2VyZW4ndCBjb252aW5jZWQgdGhleSdkIGV2
ZXIgd2FudCB0byByZXVzZSBhDQo+IHNoYWRvdyBzdGFjayBhdCB3aGljaCBwb2ludCBoYXZpbmcg
dGhlIGtlcm5lbCBmcmVlIGFuZCByZWFsbG9jYXRlIGVhY2ggdGltZQ0KPiBpcyBqdXN0IGFzIGVh
c3kuICBJdCBzYXZlcyBoYXZpbmcgdG8gaGFuZGxlIGNvcm5lciBjYXNlcyB3aXRoIHRocmVhZHMg
dGhhdA0KPiBkaWRuJ3QgZXhpdCBjbGVhbmx5Lg0KDQpJIHRob3VnaHQgaXQgd2FzIGFsc28gYmVj
YXVzZSB0aGV5IHdhbnRlZCBmaW5lciBncmFpbmVkIGNvbnRyb2wgb2Ygc3RhY2sgc2l6ZXMNCnRv
bz8gQnV0IHllYSwgaWYgbm8gbGliYyB3YW50cyBpdCwgaXQncyBhIGhhcmQgc2VsbC4NCg0K
