Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794274228;
	b=ogErHtz+GGvNzh6VcbYmhyHjJlEYaeded8IGI2vsiDX2ikKY7pQY2+FJNH8VSQ0TEB09
	 umaNOURnZju/TAiEMYmXtS25gmSzHR969LGVT+Kjmzm/QeJad4ql5/IUDDBu1ur9Jx3Uc
	 3mJVlnB9OxFie2b3KjPPjzEXFNLmj/dYlD78cim6qZ4qxPk0F2cLZVFPhuhO5Lc7BqcpF
	 qI9/T7fR4J5pkFzLUOg+oi+x9kR+zGSN9vAoip9PrcI2/D8j7AB5WqfmfnB6Wn30QsL65
	 8v2eRVdoY9qGO5HI0mVHNzQ8yvblAugcsk3G3uiIRE3BNUdtPt6X42rBgFeU7vnXaNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794274228;
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
	bh=FGEcX1orlEu//eNeWVUPJlEsoz9V75vnG1fr4rX7zns=;
	b=RiKMbJlR9gRq01TMj6BD/4MzTneLjl795PFT2SVJx5wUky2tpPSTIx0C6wYc/4RRKTI5
	 YYgm6/wbLLWolIVxXOC7AEZUc2nUMyCWoss1zdu1skksUeb040vbD+06EaAVZxv1weVjT
	 AALokDGrADv0VxTlUlIgntQO93uS4IaeqWSeVmVLKP+YpMxOICvOe2YEnAFRvdZHjxnbD
	 9rr4ItWHrVXHbDRLlPnb5I3FGQDglQClTWAXheSbgJZWAFQBsAxLm+RQV7rAJJu5ajUyI
	 35WKIunhhwybXc921H5vsekLzC2iGaKeWeG3Jo5XvnRFC2jed0jJ/rFY3wQLIr/REwg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=coBEhLoy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F90606A339;
	Tue, 10 Nov 2026 01:30:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63F90606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=coBEhLoy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794274222; x=1825810222;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FGEcX1orlEu//eNeWVUPJlEsoz9V75vnG1fr4rX7zns=;
  b=coBEhLoy1xw66AWmLpc6dBZoewkpjaWkCFzJbFD/HIY3Hz8Y6krHYkpP
   xCmR7t3hfhgsQv6daRE386k4SnR9J/UxyOgc86/bPl370bByiW42gBiDX
   ex5nBx9RzDLKUHEHfhUdzprn6JBR8RhBU+OK6QPIhQmMCHaQIRhj9WN3p
   FRLhDIhaSi/VmYYuJ2AihtFBAHVvN1q+MjaDIex1Vd7z9IXifabNgsK6K
   BOpgX+oBI0O8l85Eql9OcSiMtei5ZtgYjW+KWrayComjWMyAdaGC17G2P
   CAfILQG+z1lk/00gU871sPrJk+ljRnyb55WCQtKThlb0Q7eIQsusKQ186
   w==;
X-CSE-ConnectionGUID: 92aOdVVBTF+zcuZk+0TfCg==
X-CSE-MsgGUID: 7WaLWikzQRCa+/YLJBwc1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2909478"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2909478"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 17:30:20 -0800
X-CSE-ConnectionGUID: ZHezD9wDTvahEKpQZYjQ6Q==
X-CSE-MsgGUID: i0figI7aTNK6zv8pf/POWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="8592172"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 17:30:20 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 9 Nov 2026 17:30:19 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 9 Nov 2026 17:30:19 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.48) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 9 Nov 2026 17:30:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=opksjcDjz1zXo9Y0kYgWAOfyRfVZeccesTHve4U6jWKnt8ZMaimy9mmNC7ZJwhVnUuhlE2n38kEiHxwFdz8D5hO1AuwmmZiZIDJWkaWfC2py0cqGeQSkAjlAYyFkpP4ZHtqxqEUPpCMv8pKZHpZjooxLf2XqCoiW+U5tUuxwP6UbyLq1x+LQBONWuNFoY1VOE0FbgOpE557axehVqNRCoS+OTyHOny+qazEy0nF1wqjyrfofr9+WoWmcNd1Ar4QRXynzWmOOG7fm4ySir+LP97rkktbEtSIV9Pb45juC1FXoyuMXWcrDCg27DFIY1QHd9da1H5cbNf5BogEpAqgm2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FGEcX1orlEu//eNeWVUPJlEsoz9V75vnG1fr4rX7zns=;
 b=aJ/YOO+TalxFaTx9/0ZkHuBqY8PFg7c7eX47eF9aQFN3vShUOK8LzJemQwXY94kQqra+9f+OX5HZjzylMy8/Akdzu+6f4+aEH4rbIaUktvNre1j3I+5hR9UEN0U2O91rd5fSrBDNraYnGq+HMxuhYWRtK0ehPpb37gFglpxsVYMWWY/OhcTCid3dLwRBt4jeg1lxDwVZm+svzmV88V7/FxOo5tWmDmH3Mpojapq12tT0c0ZAt4fkrhT/7w9CkX5WDkw/4z7RY1+xicalvSG9pPdFtH6Z9k9ZqBdEN6R5Ahf//33buZrsn7IFvVtvbqDiszhH4o6nSEBi96G4noj41A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 (2603:10b6:208:549::23) by DS0PR11MB7972.namprd11.prod.outlook.com
 (2603:10b6:8:124::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 01:30:16 +0000
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57]) by IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57%5]) with mapi id 15.21.0592.012; Tue, 10 Nov 2026
 01:30:16 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jgg@ziepe.ca" <jgg@ziepe.ca>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "aik@amd.com" <aik@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Xing, Cedric"
	<cedric.xing@intel.com>, "alistair.francis@wdc.com"
	<alistair.francis@wdc.com>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "Reshetova, Elena" <elena.reshetova@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "ankita@nvidia.com" <ankita@nvidia.com>,
	"jiri@resnulli.us" <jiri@resnulli.us>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>,
	"Quigley, David" <david.quigley@intel.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "lukas@wunner.de" <lukas@wunner.de>, "Vivi,
 Rodrigo" <rodrigo.vivi@intel.com>, "Fang, Peter" <peter.fang@intel.com>,
	"jic23@kernel.org" <jic23@kernel.org>, "ksinyuk@kernel.org"
	<ksinyuk@kernel.org>, "sameo@meta.com" <sameo@meta.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "qinkun@google.com"
	<qinkun@google.com>, "pgonda@google.com" <pgonda@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Topic: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Index: AQHdXLTTjrGSfVTT6UCa8v4N/LvKxbcKKgoAgAENkgCAAFvTgIAAJv0AgA+FnACAAGOJgIAGE/cAgARqFgCAAGa/gIAABksAgAAeAYA=
Date: Tue, 10 Nov 2026 01:30:16 +0000
Message-ID: <4c75b369b68c98c5c35e296895b6935342dc7dc1.camel@intel.com>
References: <20261015145053.3664509-21-jiri@resnulli.us>
	 <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>
	 <20261023141218.GD3977851@ziepe.ca>
	 <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>
	 <20261023220030.GM3977851@ziepe.ca>
	 <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>
	 <20261103005851.GH3889730@ziepe.ca> <au5LCE1jau0yDo5S@intel.com>
	 <20261109171236.GP663069@ziepe.ca>
	 <cbef9bda9241ffe98652172edb67fab3eb1c35ee.camel@intel.com>
	 <20261109234252.GR663069@ziepe.ca>
In-Reply-To: <20261109234252.GR663069@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB634048:EE_|DS0PR11MB7972:EE_
x-ms-office365-filtering-correlation-id: 5723e2e2-0bad-4983-5f7b-08df3eca2cdb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|22082099003|18002099003|10067099003|38070700021|5023799004|11063799006|4143699003|261102123227099003|261026121527099003|261028144727099003|261022105027099003|56012099006|261022075727099003|261021121427099003|261026140227099003;
x-microsoft-antispam-message-info: QnQr0u8x290IV+2nXcN+1NUovZ3g9RZSUsKeL58VhPVVrohClzTkuRFx4qLpZ+T+2BR9IguC5oD+X6GZ6514Dm/5I9Nlo89y9leE+vFxyu53Mhr7vkeeBvNp/4atQVWnbgGj3T85wSJsntlPJ7a4XcLm/j//1/GTyyfBLvNsp7IFAGj0cvzVnvPA1fEo3LqWxstU2FMgiBQDaHFNhLMcfiqhKCRdlhvsUn3J6WIuf+9T4TGg/sz5oD2zvRwNKIYegGXS7ggaj7DyoPA2s8byaIm61VWkS0p6DUECxJCV/N9Bqtsgr4QCX1xyaEcoQ95hQfGJUjLXfpDfZ3UB0UnrjzIWZIe4ri6rHgl7PZLuSY0nye32w1L3Hco9s890U57qf9MlgZcMLoI6dgMJpAuDt7FlIIMFRmGjMNWVIgvqnyARHnMpH19cEx5+wNOPeWTQOn6PEI0T4A3um0UuoQCZrOzyFihyO9/gTcmpOwK4tlJ5VrCK5ul/t6Q4aE2OpGa90T21fB3OZG14KicdDay9ozn+M2yq3xfHhwzSctCVETrrQnnIjLSaUBSclvsEmQVNtFFRDwUU0T3p9rtWvsfK16dHuGXsFgJ0OoUl5wfySUOIVWWyrqNd3wNJBaRyLKH6Nz/7Ny7Q1Hphilq2yXMlHm5xP1x6cno/ydB+MFRaWTNIEd6He1HS8le63o9uwagS1ou8nz92tkwdL8/173zJ5l4eYP9SEVmyAjybq0Dy1wg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB634048.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(22082099003)(18002099003)(10067099003)(38070700021)(5023799004)(11063799006)(4143699003)(261102123227099003)(261026121527099003)(261028144727099003)(261022105027099003)(56012099006)(261022075727099003)(261021121427099003)(261026140227099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFRVZFloVVVqSkk3Y2VneTlJbjNvOHVoMm1xQTR0Mng4UjN5RnN3eDRpOG5V?=
 =?utf-8?B?N3JaL0p5NWR5Vi9DR3d5QUNOMzdra3lBc3lva3dLTGRMK3JyNUQybG41L1Br?=
 =?utf-8?B?K0NHbGRlb0xyeHluR2ZCdW05Q3NwNzhKMDc0U1JFNG5vNHl3TCtyUGNIa0Fu?=
 =?utf-8?B?R0JYVThmK2dKVG5GM3R3K0h2M3czWkhQb2xDZmk1enpid2p0YnBManRPeHox?=
 =?utf-8?B?bU9Ya29PcWU5VVV0a2dMb3JnUjRaa1lZL3UwNU5qZ0YvTXVoWVFocXc4Y2Fw?=
 =?utf-8?B?dXowWnJ4L2p3VGpQaCtzY2l3UEt1K0dVc0pwYzVrbmxOczBLaEtxK0RpZEV6?=
 =?utf-8?B?S2s1UFdueSs1UXVNbXBWM1p5d205ajJsQVAwSnhqeEpQTW54ZXllWlhyeU5S?=
 =?utf-8?B?VkVCdG96TktVMXlBRnVuVDJQUGlzQ1Nxbzl5Z0xDa2FIYVpoTXAvbVYwN3g1?=
 =?utf-8?B?a0YvVzhUWGRvVit6NURnOSt6VnBrVkJnSFN5SEt2cHJhakkzYTVyL3UwQWs0?=
 =?utf-8?B?WVJGb3d4M2IwWnFibG9CNUY3RUYzS28xWGdHaTFMYlJRenBRVmwzcVVDRjNt?=
 =?utf-8?B?RllLUnlnTVJxdlJYcTg4bWtPaVhEVnpBK2FtUHlmZ0ZVQlc3RW1QWDR5VlJh?=
 =?utf-8?B?M3dDWHFkbWJTU2JMWEJyaU5XMU96MVRVUTNjTk5peW5GajBOSi9YekM1Nk9V?=
 =?utf-8?B?enlWYXNSY01BcTNzdFpnL2F3VE9Zd2hOeStUemJSUnljNVk0cG9CbXJPOSt5?=
 =?utf-8?B?MURjWUxObDU3SnQ4MmRkTGU2TU95ZmJKZGFmcTFNdnJoZEdjOE5CcThlZC8w?=
 =?utf-8?B?ZUp5S1lKRyt3WkRnaTZvUjlhclRnb0JYV2lOK0krNFo2KzVXMXd4ZmxmMzls?=
 =?utf-8?B?VDhibFJLbytDNytOdmlPQ2FXdUpFdGRtendQV2tlTE92Q0t4ZzRZZEV5Zmw0?=
 =?utf-8?B?Nm5EYnRLVkg2a2NwcHhJcGJyNlZBQXVQUk5iVkNBOEJKRm5ZaHJseTlkbWkr?=
 =?utf-8?B?bGFscjJwR1dtQkZEY1BwMUlCdWRmSG9SZzR5eFJMZjZoWC9naGhpRjY5WTIx?=
 =?utf-8?B?S0t0ZHhMU2gvcUtXa21pVHd4TUo2UVFKR3Q2UjNUMSt0Z0NhYzA3M0RKdE9X?=
 =?utf-8?B?ZmdMajhRdTZidWFidmgybzAvUWF3REJYM1V4NmgwclBuMlErM1ZTQkZDTkZp?=
 =?utf-8?B?WFlPZUUxdjkzSUlCN0tyalpUa3hBS1NrWUNtZGFKVGM3YU05SlJsS3l1ZGs3?=
 =?utf-8?B?TGFQWnJmN1ZHeCsvTFNEb2plYzJJTExJK3FjYlJVRkVBcVNOblhrZmRReWtI?=
 =?utf-8?B?ajFUM1BZeDhyblhsMXN0MHU4ZkJrS0laSFExRlZzUnFUbmt1SlZYWUd5dzlM?=
 =?utf-8?B?d3h0WTlCY21KUE1ucFB4OGpvWGZMTnl0NlNRVUVMd094RC9XTEFONVBnYm5S?=
 =?utf-8?B?RDFsSzhSNjlEVzJVYVdhMXJDNVc3azBodHZSUEdpVE9IcGFLSWpvVklYN0gv?=
 =?utf-8?B?dUtiT0o3RUpQTFdxSU5KdGw5azJ3TXd4R1RDS2dhS2JFY3RCR3g5ckxESFBE?=
 =?utf-8?B?eGRMN1NtOHIrSjZuVVV5Yk5oekEvZkFxZkxyYXlTVDIzbUpadUxJZktqZ3Ir?=
 =?utf-8?B?eGJ1bmdsa3Jway9zekVpdnlac2oyRnJJdHJPNVFCSW5HODhKQStuSVhzejgx?=
 =?utf-8?B?a3didWFGYXk4Q1EzMU9iVTNrOVVEYi91b1FhOWQxd0c4Y0JJVmZ1ZDZuanpm?=
 =?utf-8?B?VGczbmVyTXRDRUhIbnRFSDBWUVZoREMwZkFIWkk5SW41NHY5d0RlemowQkhl?=
 =?utf-8?B?T1JuMU9ySTBycVBsNHd4bkhuTGMvZ3JUL1h1R3NpWWNjSlZmMEQxd1J1QllG?=
 =?utf-8?B?UUxZdlNZclpTRDExOXBYMmFJaHgvTGFIVU1vSHYxUlRrbjNQaWhhSUpwQzVQ?=
 =?utf-8?B?UXdtT05vRGlsekV0dDZ6R3FDckEyUGJITzdOMDNtaWNqVXdwVVMzdEt5Rm95?=
 =?utf-8?B?eGh5dG9VZzZnaEEyZHRTTFBxMG1GaDEvRlphZWNjZ1JwVElvK2pwUTJoU2x5?=
 =?utf-8?B?ckRoQ3Q5b3NteGhNRFdUdzh3d0FEVGJoSGx2TTRrdm95WFhEdm1ub2V0VmNG?=
 =?utf-8?B?dklLUGM2dVVib0sxVHY2M0RocTBUZmxKcUNUQzZPaGtVN0xVYzFydlhxQzVa?=
 =?utf-8?B?dmdmcFVkWGgrMEdaVjZ0WW5FRzNqUUpKTmp2NnR6dmoxTWlmaEkyMnhwaUdh?=
 =?utf-8?B?cmx4N3hUUmlXZUphNGNjZEhscngyQjRxRk1QUnJ2cjI3Y2lib25GdFdjVURw?=
 =?utf-8?B?eE8vUDJPSE8wby9yM2Q5QXdzUnJDNW1oTFhSMmtIQ0srYUZidXBlVWlacFA3?=
 =?utf-8?Q?vrZMkoBQotB9XeXU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4F1DEBFEEB9C2489DCD9074533216FF@namprd11.prod.outlook.com>
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
X-Exchange-RoutingPolicyChecked: Nww4VUBSKJQVyRxKBmCJPdRa1yfKuMbZ2ALhG4HBRvr+qTpwWps++yapJ2Gw5nk1E1UjjKsg396xoC2KU8QcXisDsFiN0CRcM/JRPYaR2tX5b9kkpnzeJo1eZHDBmClJsNWrusl57MXCgDwDTWaBzrYMh1RLIlHZnHwtIY81VzKQgx6zi8+fQLluSO1oMmVIX9zjF+WyTOysjD5hJI6rWR5Qd48E8yuKvMOkT+kxZtgJtJOYjcXGH+LY1le5F8ef4Hots1T/mqC89pg/SxhBxSehjxy7Gc2lD7g1ztLpWt39AWtPa5T4evbJVUMUiJRwaW27e8mDlfQQLQ+jqbaP0Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB634048.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5723e2e2-0bad-4983-5f7b-08df3eca2cdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2026 01:30:16.6730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 77+PoJU4y2VT3cxmxq0JYG/Hk6MwFFpOAoGq4WHlj4iqEB6b/ZSNWRPIiNHxFf32RAAqhnvJg12UQcwSY813mdOGYYBGhPEHaNDYgeB169U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7972
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTExLTA5IGF0IDE5OjQyIC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+ID4gU28gd2UgaGF2ZSB0aGlzIFNHWCBiYXNlZCBxdW90ZSBmb3JtYXQgdGhhdCBpcyBmaXhl
ZCBiZWNhdXNlIGl0IGFscmVhZHkNCj4gPiBleGlzdHMNCj4gPiBpbiB0aGUgd2lsZC4gR29pbmcg
Zm9yd2FyZCB3ZSBhcmUgbW92aW5nIHRvIERJQ0UsIGJ1dCB0aGF0IGlzIGEgc3RhbmRhcmQNCj4g
PiBmb3JtYXQuDQo+ID4gU28gYWxzbyBzb21ld2hhdCBmaXhlZC4gSSBndWVzcyB0aGUgcXVlc3Rp
b24gaXM6IGlzIHRoZXJlIHNvbWUgY29tYm8gb2YgYml0cw0KPiA+IGluDQo+ID4gZWFjaCBibG9i
IHdlIGNvdWxkIGNoZWNrIHRoYXQgY291bGQgZGV0ZXJtaW5pc3RpY2FsbHkgZGlzdGluZ3Vpc2gg
YmV0d2Vlbg0KPiA+IHRoZQ0KPiA+IHR3bz8gVG8gZG8gdGhpcyB3ZSB3b3VsZCBuZWVkIHRvIGFu
YWx5emUgdGhlIHF1b3RlIGZvcm1hdHMuDQo+IA0KPiBZb3UgZ3V5cyByZWFsbHkgZGlkbid0IG1h
a2UgaXQgZGlzY292ZXJhYmxlIHdoZW4geW91IGFkZGVkIERJQ0U/IDooIDooDQoNCkxpa2UgaW5m
bHVlbmNlIHRoZSBESUNFIHNwZWMgdG8gaW50ZXJvcCB3aXRoIGxlZ2FjeSBTR1ggYmFzZWQgYXR0
ZXN0YXRpb24/IEknbQ0Kb3V0IG9mIG15IGRlcHRoIHRvIHRyeSB0byBzYXkgaG93IHBvc3NpYmxl
IHRoYXQgaXMuDQoNCkknbSBhbHNvIHVuZGVyIHRoZSBpbXByZXNzaW9uIHRoYXQgdGhlIHF1b3Rl
IHdhcyBub3QgZGVzaWduZWQgZm9yIGxvY2FsDQpwcm9jZXNzaW5nIGluIHRoZSBndWVzdC4gQnV0
IHJhdGhlciByZW1vdGUgYXR0ZXN0YXRpb24gd2hpY2gsIHVzdWFsbHkgaW52b2x2ZXMgYQ0KaGVs
cGVyIHNlcnZpY2UgdGhhdCBwcm9jZXNzZXMgdGhlIHF1b3RlLiBJJ3ZlIG5ldmVyIGJlZW4gY2xl
YXIgb24gd2h5IHRoYXQgd2FzDQpkZXNpcmVkLiBCdXQgaXQgcHJvYmFibHkgaXMgcGFydCBvZiB0
aGUgcmVhc29uIGF0dGVzdGF0aW9uIGRvZXNuJ3QgZml0IHRoaXMgdXNlDQpjYXNlIHBlcmZlY3Rs
eS4NCg0KPiANCj4gPiBJZiB0aGVyZSBpc24ndCwgSSdtIG5vdCBzdXJlIHdoYXQgd2UgY291bGQg
ZG8gYXQgdGhpcyBwb2ludC4gVGhlcmUgaXMgYQ0KPiA+IGxpYnJhcnkNCj4gPiBJbnRlbCBwdWJs
aXNoZXMgKHJpZ2h0IFBldGVyPykgdGhhdCBjYW4gdmVyaWZ5IHRoZSBxdW90ZXMuIEknZCBndWVz
cyBpdCBtdXN0DQo+ID4gaGF2ZSBzb21lIHdheSB0byBkaXN0aW5ndWlzaCBiZXR3ZWVuIHRoZSB0
d28uIENhbiB5b3UgY2hlY2sgaG93IGl0IGRvZXMgaXQNCj4gPiBQZXRlcj8NCj4gDQo+IFNlZSB0
aGlzIGlzIGV4YWN0bHkgd2hhdCBJJ20gdGFsa2luZyBhYm91dCwgSSBkb24ndCB3YW50IHRvIHJl
cGVhdGVkbHkNCj4gZ2V0IGludG8gdGhpcyBzaXR1YXRpb24gZG93biB0aGUgcm9hZCBvdmVyIHRo
ZSBuZXh0IGRlY2FkZS4NCg0KSSdtIG5vdCBzdXJlIGlmIEknbSBtaXNzaW5nIHNvbWV0aGluZy4g
TmV3IGluY29tcGF0aWJsZSBzdGFuZGFyZHMgc2VlbSBwcmV0dHkNCm5vcm1hbD8gU29tZXRpbWVz
IHRoZXJlIGlzIGEgY29udGFpbmVyIHRvIHNwZWNpZnkgd2hpY2ggdHlwZSBvZiBibG9iLCBhbmQN
CnNvbWV0aW1lcyBpdCBpcyBqdXN0IGRpc2NvdmVyYWJsZSBieSBjbHVlcyBpbiB0aGUgYml0cy4N
Cg0KSSB0aGluayB0aGUgdGhpbmcgdGhhdCBpcyBhIGJpdCBkaWNleSAobm8gcHVuKSB3aXRoIHRo
aXMsIGlzIHRoYXQgdGhlcmUgaXMga2luZA0Kb2YgYSBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eSBh
ZGphY2VudCBjaGFuZ2UgZm9yIHN5c3RlbXMgZ2l2aW5nIHRoZSBuZXcgRElDRQ0KcXVvdGVzLiBU
aGlzIGNhbWUgdXAgaW4gaW4gYm90aCBkaXNjdXNzaW9ucyB3aXRoIERhdmUveDg2IGFuZCBTZWFu
L0tWTS4gVGhlDQpyZWFzb24gd2h5IGl0IHdhcyBjb25zaWRlcmVkIGdydW1ibGUtb2sgaW4gdGhl
IGVuZCwgd2FzIGJlY2F1c2UgdGhlIGZ1bGwNCnZlcmlmaWNhdGlvbiBkZXBlbmRzIG9uIHVwZGF0
ZXMgdG8gdGhlIGxpYnJhcnkgZm9yIGVhY2ggbmV3IHBsYXRmb3JtIGR1ZSB0bw0KbmVlZGluZyB0
byBiZSBhd2FyZSBvZiBuZXcga2V5cy4gU28gdG8gYWN0dWFsbHkgYXR0ZXN0IGV2ZW4gU0dYIHF1
b3RlcyBvbiBhIG5ldw0KcGxhdGZvcm0sIGxpYnJhcnkgdXBkYXRlcyBhcmUgbmVlZGVkIHRvIHdo
YXRldmVyIHRvb2wgb3Igc2VydmljZSBpcyBiZWluZyB1c2VkLg0KU2luY2UgdGhlIGxpYnJhcnkg
bmVlZHMgdG8gYmUgdXBkYXRlZCBpbiBhbnkgY2FzZSwgaXQgY2FuIGFsc28gdW5kZXJzdGFuZCB0
aGUNCm5ldyBmb3JtYXRzIHdpdGhvdXQgYW55IGltcGFjdCB0byB0aGUgdXNlci4NCg0KQnV0IHRo
aXMgZGlkbid0IHRha2UgaW50byBhY2NvdW50IHRoaXMgZ2VuZXJpYyBBUEksIGxvY2FsIHF1b3Rl
IHByb2Nlc3NpbmcgdXNlDQpjYXNlLiBXaGljaCBpcyBraW5kIG9mIGEgc3VycHJpc2UgYW5kIEkn
bSBhY3R1YWxseSBzdGlsbCBub3QgMTAwJSBjbGVhciBvbiBob3cNCml0IHdpbGwgYmUgdXNlZC4N
Cg0KPiANCj4gPiBBbm90aGVyIG9wdGlvbiB3b3VsZCBiZSB0byB0ZWFjaCB0aGUgd2hvbGUgc3Rh
Y2sgdG8gcmVxdWVzdCBzcGVjaWZpYw0KPiA+IHF1b3RlcyB0eXBlcyBmcm9tIHRoZSBndWVzdC4g
VGhlbiB0aGlzIG5ldyBjb21wb25lbnQgY291bGQgb25seQ0KPiA+IHJlcXVlc3QgRElDRSBhbmQg
bmV2ZXIgYmUgc3VycHJpc2VkIGJ5IFNHWCBxdW90ZXMuDQo+IA0KPiBJcyB0aGF0IGFuIGV4aXN0
aW5nIG9wdGlvbj8gSXQgc2VlbXMgT0s/DQoNCkkgdGhpbmsgd2Ugd291bGQgaGF2ZSB0byBjaXJj
bGUgYmFjayB3aXRoIGV2ZXJ5b25lIHRoYXQgcHVzaGVkIGZvciB0aGUgaG9zdA0KY29udHJvbGxl
ZCBxdW90ZSB0eXBlLiBMZXQncyBzZWUgaWYgdGhlIGxpYnJhcnkgY2FuIGRpc3Rpbmd1aXNoIHRo
ZW0gYWxyZWFkeQ0KdG9vLiBUaGlzIGF0dGVzdGN0bCB0b29sLi4uIGlzIHRoYXQgc29tZXRoaW5n
IHRoYXQgY291bGQgY29uc3VtZSBhIGxpYnJhcnkgbGlrZQ0KdGhpcz8gT3Igc29tZXRoaW5nIHRo
YXQgd291bGQgaGF2ZSBhIG5vIGRlcGVuZGVuY3kgaW1wbGVtZW50YXRpb24/DQo=
