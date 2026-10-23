Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792784465;
	b=pcjcWqykY/l7oFf/5xZU2gweGrDPjiCH57kmukqun4Io22luaJOF2zRq64yLj3LAk0fM
	 O0jaLqJB/cXi0zV8BJ9E+ZnM4PrnIKTDo7p4r5kjn2rVPzVS5CwCAnWq8oivcOTosncYi
	 P2QtqDSx5L/qqz7JPCffi6sQ+WQBwsOxScbj1JWbWT2A1i2hNaEkmXRf5IwHboG4+xVpQ
	 lc9nK6Yzo71DOxWmKH3/DqjHg62xxIBjfgCHX6DT4CIsEIkwlUq2F5QqI5CVxLkQ/az9g
	 cxbiDGKepp1pcjBkIKwSXoh4OyEBMjHQSzw/ejXKp4YCy12+HyBhW6B9CKmyNdaJvdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792784465;
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
	bh=rdA1VZAWQAm3N4UujsluN+BFtCpNkCTm1W5gBbjw6sA=;
	b=MXkwVfY0gbJwCFranC6cR4CwWyqYvwjVf3JPgy45fe6KF5QN5Ish/4UNA7hufBHeTqE0
	 4XsNI2jI9TRgwVF2IAkBTUpZl35bZK81saBF0rrZaRCCqXF4ce0a85blSc3VWRum94MS1
	 6skeXodMYxo9MN5gGqV5yw7bTQp+YvIGxE+IFXTqsxaCHgcIdtJf149vZcNx0eUxqo+0m
	 kixYjmfa8CEhHpYBZmD4Pujqcjgt3vlG+CZ63SwbxdYCrFmB8dXaqsYLSe7N7uGlPjDxh
	 FjQZQ3nNQemBpo9Z3lf/s2eCEznhs85u+Lwu6/pb6dFwd4Hswof+veFR9PRKO/TDoMg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jHp5aMw9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328F4606A31A;
	Fri, 23 Oct 2026 19:41:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 328F4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jHp5aMw9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792784464; x=1824320464;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rdA1VZAWQAm3N4UujsluN+BFtCpNkCTm1W5gBbjw6sA=;
  b=jHp5aMw92/syyejrug/oUxP8mXiY/QnatL3iMbeA09ZWT7ntez76U9Rr
   mL0kExd3W9pnUwEcqIQ7zMfBFV3U5iKLiIslS4dUlVcuaCAfdB8j5bWLo
   JCmCR6rirs3HIO+LjVDaxGs8WTMkRncjJ1RpTglYg/1a+NCZPYrDErZVQ
   CPJkvlnxniu6wp0/NiBh2dT35ke75514/WuouzP35jjwy+7xXcH+EdiUA
   aUn4RE9Nind0ntCgfSqLv/qjxNdkU5HYqMW/Nl7As69OFvnRmNX8g+3E9
   wUANNmcYXlqa/tK7iCVo1R8Bb3uOCOp96feHT7DZYqdcF7XnUpQOxVcRn
   g==;
X-CSE-ConnectionGUID: xdXH6yJCRVSDWbbFG/CFdA==
X-CSE-MsgGUID: peu8O4/nQXiCCoNmsm+LLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1440092"
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="1440092"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 12:41:03 -0700
X-CSE-ConnectionGUID: 41TK+o2fT0m0N+FJWkOFDg==
X-CSE-MsgGUID: nVjRS1mJQzSBc1ZIai4YEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="3828685"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 12:41:04 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 12:41:02 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 12:41:02 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.16) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 12:41:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xbRNeNt8y010qT110aKYD2oXHnC3h7NLlY2fkztNGCkAsnIMfxJNOCSKadSTDYl4VgHU4FHZHz8GxGRSoiUhqcLi3vyF86td6qNS3ZbtJWkDGvfIKWXsGK6bp34MgKzuFLaGgnOTGArqId1G3OcMSdWRDt8mLNZsBfUtSb/yhO8JYeWTitI+3EVvWlOEfTN7JjVxtb38f+jDrmr9zaxC0RymVgniMq3mBUeKpi0lVuqItcQzG4d9q9bAvNhT3hWg7f96NqhRv2wiqLxpxiInzgGo5Zh+ULOaVJd11n/knbb/mupzQoRDOKeDBz5P0AizBbxYiefqyacPEtyo7g66Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdA1VZAWQAm3N4UujsluN+BFtCpNkCTm1W5gBbjw6sA=;
 b=ED2kuL71doFJJ0WmrMjh7e5/rjEmaYfLOww/1zLQQb/elmITbn7pYDtGlCViym4ElsoaykBd3moG4zXmUMSSD/w9+WCwQObtvaCqFTGSZxitEX0K9yn399yvR0O3F552cjUuTBDs+X6rRHlnT4zANrP92mfq4otVnle24pynYil7iTjvJPSE8nlcBK6gU7iT6ATF4Gebx7wZ0b346VTiH6lGdzNFRHHCOaHhejAZlDFmNTr6f0Y0yai0Q/Benzgh7powZMe2Kyr9wNdsn1yyD9DwaNN3y0/AQE9VwFw1+66IpwI6kLPY1QP9eNz3CVtTHXD+zJy7LayaWijQi7LFeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 (2603:10b6:208:549::23) by SN7PR11MB8112.namprd11.prod.outlook.com
 (2603:10b6:806:2ea::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 19:40:58 +0000
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57]) by IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57%5]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 19:40:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jgg@ziepe.ca" <jgg@ziepe.ca>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Fang, Peter" <peter.fang@intel.com>,
	"drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "sameo@meta.com" <sameo@meta.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"alistair.francis@wdc.com" <alistair.francis@wdc.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "ankita@nvidia.com" <ankita@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jiri@resnulli.us" <jiri@resnulli.us>, "kas@kernel.org" <kas@kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>, "Xing, Cedric" <cedric.xing@intel.com>,
	"Quigley, David" <david.quigley@intel.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "jpiotrowski@nvidia.com"
	<jpiotrowski@nvidia.com>, "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	"lukas@wunner.de" <lukas@wunner.de>, "aik@amd.com" <aik@amd.com>,
	"jic23@kernel.org" <jic23@kernel.org>, "ksinyuk@kernel.org"
	<ksinyuk@kernel.org>, "qinkun@google.com" <qinkun@google.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Topic: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Index: AQHdXLTTjrGSfVTT6UCa8v4N/LvKxbcKKgoAgAENkgCAAFvTgA==
Date: Fri, 23 Oct 2026 19:40:58 +0000
Message-ID: <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	 <20261015145053.3664509-21-jiri@resnulli.us>
	 <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>
	 <20261023141218.GD3977851@ziepe.ca>
In-Reply-To: <20261023141218.GD3977851@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB634048:EE_|SN7PR11MB8112:EE_
x-ms-office365-filtering-correlation-id: abd25750-fcf3-4af3-79e4-08df313d8fa3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|261022105027099003|261022075727099003|3023799007|38070700021|11063799006|4143699003|261021123027099003|261021121427099003|10067099003|56012099006|261022115727099003;
x-microsoft-antispam-message-info: m2ymH0W+0G/yVxvtzj0G3mR5aJxPhrsCPmmw6I7l238n7YrnI7XK+zKo2Hxmka0NfyOq7JtZ7PYtxi7MAB4WHUsWIrOf7HbnoJBUDQ74Ul9HdfNMYfCn6q+7G0c/oWoFrXr77Usca+BOvNPttAnfgvKsH/i9MU8QJ9MshHLCDUxasDrMyd9XBfvynBESRKW3N0WgJMKuR8oGmldgF+8qtITSSUebs9hQImb0sd+v/tCDlFkUXiOOhPKZ1sah8Pds3k+1ytnP0VGTvWcsnlzkOWFXtCp/9qd/CIcDoA25YaJfcNmx5i7d6mhgUFzTwk8Wv0PP3eeU3V6rQ4PaXyX/rFMAxhR4/Fkco3cN4PWwNcvGF4BmimPf4sad+tA/Sx9SKYd2SjISBCJdbiqmOJJWn164rBu7vb3GkCph/GgctvC03k2EWVZ7vcePcZKfcOgznlbvmLfzfiDOOG7gBOqLXEwMjFkTilDUscZPLErKAAtjRYIGC7TQQ6aY3bxZEHjxTUBqWP1Kj/MGtuAe9bctZB99/9gQ0UH6FoAWDN3Hcg7UB4/YMPxERZDZoptDOW6B9v4ehHDnzqyzMD90txyXzp7/VaeLgovUnIUlrc3NziwJ3SqjmLjIZE+WWE9vbPJSBdRrHmuUD9wcCi4iTnLDubsEHFaCaA9HABRIFwbKgm7p0jkBlvSffYnW8pzfwTDu+pPkmS22F/7s2GWhN2L2h8T3GH5Cs7gcyOXGncbZWEY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB634048.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(261022105027099003)(261022075727099003)(3023799007)(38070700021)(11063799006)(4143699003)(261021123027099003)(261021121427099003)(10067099003)(56012099006)(261022115727099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qk1ONU92OThwZks3K3l2OTlON2tZK1FXZjFVUWpYdmhRS2VjSlBoVGtudm5s?=
 =?utf-8?B?YmlIbEloZ1g2elJGQ01QaGtIcnhsU0xXUTgvYjIvVlpiMGRxaDdBOXRvdWd4?=
 =?utf-8?B?M0VBSWlJVyt6S01hQUVLZVVPVHdzQWZvTENBOUFTZTE2K2xEV1pQQUxDd0lN?=
 =?utf-8?B?bVkwdy9ic2VvQVNJSEhNR2twTzZ3S1dOK1dWdmhoZDgvNExubXp2R2NuS0pB?=
 =?utf-8?B?R0t2bjRKWmFqWjdydWJuaTYxUC9sdjMvVUJ3WlRjanc2S2tEc3g4Vkh2Z20v?=
 =?utf-8?B?d3hCWElOZlh4Y1htdmNGNk5zVkNzWlV4Mm9QaVJ2eUNTck5NWHF6UFI3Uk03?=
 =?utf-8?B?L29wY24yRHlRbksyZVQ2YWhLOEhMRWRuSFJmZFduUmdFczE2Qk1FaHBPbjFM?=
 =?utf-8?B?ZGFNWVEzKzlNMlFuWTFwVjFGVFBEZDViQjJZOU5vWmNhQmtVT2NjTys2b1JH?=
 =?utf-8?B?eGlOMFZybnZJU0twUTRwQUdZTHEyeW9qQ0UyRVgyVmpvcTVIYkliVmRiUktG?=
 =?utf-8?B?RG1TYmtaOFU4ekN2Q0p5VUI3SDJFZGloOFVQMDlwZDFEUWkzek9wTmc3Rjk5?=
 =?utf-8?B?ZTZnaUNnQWpMcFpSMlFEWnFYN3dETE5jM1VUdVJpN1NLZ1dQZFpMZTJnWC8w?=
 =?utf-8?B?OTRYS09aemduaDZUcXB0QzZYaHV1aDl1Q0lvazA3UE10NHN4ZklaOExkZ0R6?=
 =?utf-8?B?cXg1ZU56TDNHRCtsUTlhc3V0TGduQUhIZGZpcWMvaitla3ZoV0o5akVMTzFZ?=
 =?utf-8?B?SlZUdXA0VUtSRkQvbE1kQkQ5cEhRV0xOamZTa1R5YUt6U3B5ZmVFVjRPZ21P?=
 =?utf-8?B?SnpiVFJtZVkvU1JWTzFyQVhTdnM2dk9YakdYYndGNWV1V2pmekU1U0o0Rkg3?=
 =?utf-8?B?SE52SnZRUU44WG1oeVdtUDE0aWtYcS9xRU9KMkI1c24wZHFMZ0RNSjlxY1F0?=
 =?utf-8?B?a1J3SDE0RzA0Q3pJVktCSU5DZ1ErYlNCSXIwMkNySHVSZ2N5TXZYMG5LUEVr?=
 =?utf-8?B?cXlyUEFTSEdVeDZ0bVpOZmZBdEdXeHE3SDY4SUlabWdpV3MvREhWSGlYSEJT?=
 =?utf-8?B?THBwektGZVhxN3lqbUxpQ0F1U0tRWFNMTGltVG9CSExxYmh3RWVWamRNblA5?=
 =?utf-8?B?aWZqWTBsTVZjTDZvay9yMCt3TzBqbUFGdzcyL0VoUHhJZGxYM1doeXhYWU9q?=
 =?utf-8?B?Qm1HMUs3UUxqTU80c1VRa0pDb0lWMjRkRnN3SU5CVDJuTUZZYWhSQllRR1k1?=
 =?utf-8?B?WFl2Zk9kNEFTcG5GZmhRRDJ5VU1WbkJ6QVZ0anZ6RUxTWXFnckx2OXFqRUJE?=
 =?utf-8?B?TkhNM0NQdzZaa3dzdVlIRmQwRXZuVDU4cUpOSnBpR0tMT2dMS1dvckswSGFa?=
 =?utf-8?B?NEpPbWhxSDdDZzlUbGFBLzdXYU52NWt3OVpqQWRMbkRCekVuYkQ0WFlKQXVN?=
 =?utf-8?B?TXUvYktMUnRFeXlqTHZ3ZmE4TWFvTk53TE1wa09rNURyS2pMTGd6c3RYUVZx?=
 =?utf-8?B?QXZWTHJWcWs3RjJUenVicC9qNVppOTNGQUFMR2F5NkRWdUt2MHZ4VGRoRUZ3?=
 =?utf-8?B?b2lKbHhnd0o1eDJvYXFDczlheFc5NnU4a3NPcVNnekx6WWNiY0NuL2M4TmZL?=
 =?utf-8?B?Q0tOc3BmN08zK1B3dUd3RnZFR1NkQjlUT0NEbHJYQysydFJoQmFkbFplQTdY?=
 =?utf-8?B?RnptOEJKVGxVWnJaNElSdVZ0enhhdjZDUjVKNmFJT3RnSkJ1SHBoUHZPbEJP?=
 =?utf-8?B?MFkzNlJSUUN1Q2Rvek5ML1pFcytVcFA3VExIZS80ZTd0b0tsTmpuQUVHd01z?=
 =?utf-8?B?TWtJbXEzY29sRS9GbEkxYklIaGQ1eW83cS93Q1JHbkpsTE1jNjY0UDhGUGcx?=
 =?utf-8?B?VzQ2ejQ3aG1rYTBLWGNaYlNQcHNjbVNIWERHQmsyb0RjYTNwSDAyQTZJMTQx?=
 =?utf-8?B?SWs0MXNHUFluR1d5eCtoN0FPSFZVcE1WeitxZE1vczBLclNBdGZCTjk3SHZn?=
 =?utf-8?B?emdsdCtKS0RJZ0FsWnFOZldFTEQzRk5UVGFZNVNwaTYwYlFUNzVvdTBxOWkr?=
 =?utf-8?B?RXM1R1I5cVphcS83U0RTWVFnSnNPMzN5MkZPbmNKdlZsUU9PUHZsbE9sYmph?=
 =?utf-8?B?azJqeHFzR29aVGdIT1cxaFJidFViSS9qWWpxRDJwd3VMMWordGNJa08rcHZ5?=
 =?utf-8?B?QktPbEZPWnhrck5zUThoSkcvUGI0UUltaW1tRFhxemRxQzNoOWozUzlGLzh2?=
 =?utf-8?B?TjVsRnB2bm4yUkJ3bjBqOE14dU5HZnZST09vcFJHZXNOanVSTWMxenlsSTFS?=
 =?utf-8?B?M1doT0xmcWNiQXBtelF2QjBiZDNoT1ZkdGdKYU9OYXpmZ1BWMFNZV3RUSjZx?=
 =?utf-8?Q?kixyoGQy3HqFm5rk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1B2923D3F40C64393AE064EFD6BEDB0@namprd11.prod.outlook.com>
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
X-Exchange-RoutingPolicyChecked: TeqLcacmN0amG6Q2vMc+vog7gt4yuhIq1X3UMqIZjhWOPCmalAE1waOF1AmBZmQHbSR80QdCWM2/l9CPXD9nMfMaCy3CnpT3UoUF1wKuu2X/XpYhWnnzojmw/Rg8cDdck7t6g8VVc5IirzHKjH3WbS700Q+N+W0iK9sq9zdbPmW7q+SWxFkQeoxi3Fh7H9qVhEyvWYSMTDWbsfqGG/QZ8pxFPrMJo02sBbO+CTFo+Ah2Tmk+2Op9h3xbl7ka/3Jj+LE/fWQdaMwPDz3eFY+V1+KxAx96ggYEwi6RzvEYTF4gk7/Hzl81rSUcI9R4kD04QUs/yr0cIPUsH8NgW0e1jg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB634048.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd25750-fcf3-4af3-79e4-08df313d8fa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 19:40:58.2473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dfjn38tWQC0hMWK8k3ryrxeX/cWnp5GJvBS4sJ2GWDAAgmH53ZbVel08GhAyeQbzEvvYyB7UL+u18pMKThacuVBpjA++hhI/jZRrSjTKPp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8112
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTEwLTIzIGF0IDExOjEyIC0wMzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IEkgdGhpbmsgaW4gdGhlIHdheSB0aGlzIHN0dWZmIGVuZGVkIHVwIGJlaW5nIHVzZWQgdGhl
IHVzZXJzcGFjZSBpc24ndA0KPiBhY3R1YWxseSBhd2FyZS4gSXQganVzdCB3YW50cyB0aGUgVk0n
cyBST1QgdG8gc2lnbiBhIGNoYWxsZW5nZSBhbmQNCj4gZm9yd2FyZCB0aGUgcmVzdWx0aW5nIGJs
b2JzIHRvIGEgcmVtb3RlIHZlcmlmaWVyLiBUaGUgdmVyaWZpZXIgbmVlZHMNCj4gdG8gYmUgYXdh
cmUgb2YgdGhlIGZvcm1hdCwgYnV0IHRoZSBjb2xsZWN0aW9uIGFnZW50IHNob3VsZCBub3QgbmVl
ZA0KPiBzcGVjaWFsIGtub3dsZWRnZS4NCg0KU28gdGhlIHZlcmlmaWVyIGlzIGEgc3RhbmRhcmRp
emVkIGVuZHBvaW50IG9mIHNvbWUga2luZC4uLj8gVGhhdCBtYWtlcyBzZW5zZQ0KdGhlbi4gQnV0
IEkgdGhpbmsgd2UgZG9uJ3QgbmVlZCB0aGUgcmVwb3J0IGluIGhlcmUgdGhlbi4gSnVzdCB0aGUg
cXVvdGUuIE1vcmUNCmJlbG93Li4uDQoNCj4gDQo+IGllIGZyb20gdGhlIHBlcnNwZWN0aXZlIG9m
IHN5c3RlbWQtcmVwb3J0IGl0IGRvZXNuJ3QgbWFrZSBhbG90IG9mDQo+IHNlbnNlIHRvIGhhdmUg
aXQga25vdyBldmVyeSBzaW5nbGUgc3BlY2lhbCBjb25maWdmcyBwYXRoIGFuZCBwcm90b2NvbA0K
PiBmb3IgZWFjaCBDQyB2ZW5kb3IganVzdCB0byBnZXQgYSAnc2lnbiBteSBjaGFsbGVuZ2UnIG9w
ZXJhdGlvbi4NCj4gDQo+IFRoYXQncyB0aGUgZ2VuZXJhbCBub3J0aCBzdGFyIGhlcmUuIFdlJ2Qg
bGlrZSBhbGwgdGhlIHZlbmRvcnMgdG8gYmUNCj4gYWJsZSB0byBkbyBjb2xsZWN0aW9uIHdpdGhv
dXQgaGF2aW5nIHRvIGNoYW5nZSBzeXN0ZW1kIGZvciBldmVyeSBuZXcNCj4gaW5ub3ZhdGlvbi4g
QWdhaW4gSSdtIGxvb2tpbmcgYXQgNS0xMCBST1RzIGluIG91ciBwbGF0Zm9ybXMsIGl0IGlzIG5v
dA0KPiBkZXNpcmFibGUgdG8gZ28gYW5kIHRlYWNoIHN5c3RlbWQgYWJvdXQgZWFjaCBvZiB0aGVt
Lg0KPiANCj4gU28gYnJvYWRseSwgdGhpcyByZXF1aXJlcyBhIGNoYWxsZW5nZSB0byBnbyBpbiwg
YSBzaWduZWQgYmxvYiB0byBjb21lDQo+IG91dCwgcG9zc2libHkgc29tZSBzdXBwZWxtZW50YXJ5
IGJsb2Jbc10gKGxpa2UgY2VydGlmaWNhdGVzKSwgYW5kIHRoZW4NCj4gbGFiZWxzIGZvciB3aGF0
IGlzIGluc2lkZSBlYWNoLg0KPiANCj4gVXNlcnNwYWNlIHdvdWxkIGNvbGxlY3QgYWxsIHRoZSBi
bG9icyBhbmQgdGhlIGxhYmVscyB0aGVuIHNoaXAgdGhlbSB0bw0KPiB0aGUgdmVyaWZpZXIgd2hp
Y2ggaGFzIHRvIHVuZGVyc3RhbmQgaG93IHRoZSBkYXRhIGRlc2NyaWJlZCBieSB0aGUNCj4gbGFi
ZWwgaXMgb3JnYW5pemVkLg0KPiANCj4gSSBkb24ndCBrbm93IHdoYXQgIm5vbmNlIHRyYW5zcG9y
dCBibG9iIiBtZWFucyBpbiB0aGUgZnV0dXJlLCBub25jZQ0KPiB3aXRob3V0IHNpZ25hdHVyZSBz
b3VuZHMgbGlrZSBhIHN0cmFuZ2UgdGhpbmcuDQoNClllYSwgaXQncyBzdHJhbmdlLg0KDQpUaGUg
aW5pdGlhbCBURFggYXR0ZXN0YXRpb24gbmF2aWdhdGVkIHNvbWUgcGxhdGZvcm0gbGltaXRhdGlv
bnMuIEl0IGludm9sdmVkIGFuDQpTR1ggZW5jbGF2ZSBvbiB0aGUgaG9zdC4gVGhlIGVuY2xhdmUg
d2FzIHRoZSB0aGluZyB0aGF0IGRpZCB0aGUgc2lnbmluZywgYnV0IGl0DQpkaWQgbm90IGhhdmUg
YW55IG9mIHRoZSBURCBkZXRhaWxzLiBPbmx5IHRoZSBURFggbW9kdWxlIGRpZC4NCg0KU28gdGhl
IHByb2Nlc3MgdG8gZ2V0IGEgcXVvdGUgc3RhcnRzIHdpdGggZ2V0dGluZyBhIG5vbmNlIGZyb20g
dGhlIHJlbW90ZQ0KYXR0ZXN0ZXIuIFRoZW4gdGhlIFREWCBtb2R1bGUgdG9vayB0aGUgbm9uY2Ug
YW5kIGZvcm1lZCBpdCBpbnRvIGEgTUFDZWQgInJlcG9ydCINCnRoYXQgaW5jbHVkZWQgYWxsIHRo
ZSBURCBkZXRhaWxzIGl0IGtub3dzIGFib3V0LiBUaGVuIHRoaXMgcmVwb3J0IGlzIHNodWZmbGVk
DQpvdXQgdG8gaG9zdCB1c2Vyc3BhY2UsIHdoaWNoIGdpdmVzIGl0IHRvIHRoZSBlbmNsYXZlLiBU
aGUgZW5jbGF2ZSBqdXN0IGNoZWNrcyBpdA0KYW5kIGRvZXMgdGhlIHNpZ25pbmcuIFRoZW4gdGhl
IHJlc3VsdGluZyBxdW90ZSBtYWtlcyBpdHMgd2F5IGJhY2sgdG8gdGhlIGd1ZXN0Lg0KDQpJbiB0
aGUgbmV3IGF0dGVzdGF0aW9uLCB0aGUgc2lnbmluZyBoYXBwZW5zIHRocm91Z2ggdGhlIFREWCBt
b2R1bGUgaW5zdGVhZCBvZiBpbg0KYW4gU0dYIGVuY2xhdmUuIFNpbmNlIHRoZSBtb2R1bGUgYWxy
ZWFkeSBoYXMgdGhlIFREIGRldGFpbHMsIGl0IGNhbiBqdXN0IGFkZA0KdGhlbSBpdHNlbGYgdG8g
dGhlIHF1b3RlLiBTbyBhbGwgaXQgbmVlZHMgaXMgdGhlIG5vbmNlLiBGb3IgbGVnYWN5IHJlYXNv
bnMgdGhlDQpvcmlnaW5hbCBURCByZXBvcnQgaXMgYmVpbmcgdXNlZCBmb3IgdGhlIG5vbmNlIGRl
bGl2ZXJ5IHRvIGhvc3QgdXNlcnNwYWNlLiBOZXcNClREIGRldGFpbHMgYXJlIG5vdCBnb2luZyB0
byBiZSBpbiB0aGUgcmVwb3J0Lg0KDQpTbyBpdCB3aWxsIGJlY29tZSBhIG5vbmNlIGRlbGl2ZXJ5
IHZlaGljbGUgd2l0aCBzb21lIGxlZ2FjeSBjcnVkIGluIGl0Lg0KDQpCVFcsIHRoZXJlIGlzIGEg
c3BlYyAoR0hDSSkgZm9yIGhvdyB0aGlzIHJlcG9ydCBtYWtlcyBpdCB3YXkgdG8gaG9zdCB1c2Vy
c3BhY2UuDQpCdXQgc2luY2UgdGhlIHJlcG9ydCBpcyBwcm92aWRlZCB0byBndWVzdCB1c2Vyc3Bh
Y2UsIHRoZXJlIGFyZSBhcHBhcmVudGx5IG90aGVyDQpub24tc3RhbmRhcmQgd2F5cyB0aGlzIHRy
YW5zcG9ydCBoYXBwZW5zLiBBRkFJVSB0aGF0IGlzIHRoZSBvbmx5IHJlYXNvbiB3aHkNCmd1ZXN0
IHVzZXJzcGFjZSBtaWdodCB3YW50IHRoZSByZXBvcnQuDQoNClNvIEknbSBzdGlsbCBub3QgZm9s
bG93aW5nIHdoeSB3ZSB3b3VsZCBwcm92aWRlIHRoZSBURCByZXBvcnQgdGhyb3VnaCB0aGUNCnN0
YW5kYXJkaXplZCBpbnRlcmZhY2UuIE1heWJlIHdlIGRvbid0IHdhbnQgaXQ/DQoNCj4gDQo+ID4g
T25lIGlkZWEuLi4gTm90IHN1cmUgb24gaXQuIFdlIGFyZSBjdXJyZW50bHkgd29ya2luZyBvbiBz
dXBwb3J0IGZvciBESUNFIGJhc2VkDQo+ID4gYXR0ZXN0YXRpb24gZm9yIFREWC4gVGhpcyBpcyBh
biBpbmR1c3RyeSBzdGFuZGFyZCBhbmQgQUZBSVUgb3RoZXIgdmVuZG9ycyB3aWxsDQo+ID4gKHdh
bnQgdG8/KSBzdXBwb3J0IGl0IHRvby4gUGVyaGFwcyBpZiB3ZSBjb3VsZCBoYXZlIGEgc2luZ2xl
IHdheSB0byBhc2sgZm9yIGZvcg0KPiA+IERJQ0UgYmFzZWQgcXVvdGUsIGl0IGNvdWxkIG1ha2Ug
YSBjcm9zcyB2ZW5kb3IgaW50ZXJmYWNlIG1vcmUgdXNlZnVsPyBDYWxsZXJzDQo+ID4gY291bGQg
anVzdCBjYWxsIGFuZCBnZXQgc29tZSBzdGFuZGFyZCBmb3JtYXQgdGhleSBjYW4gdW5kZXJzdGFu
ZC4gSXQgbWlnaHQgdGFrZQ0KPiA+IHNvbWUgd29yayBvbiB0aGUgVERYIHNpZGUgdG8gZW5zdXJl
IHRoZSBESUNFIGZvcm1hdCBxdW90ZS4NCj4gDQo+IFllcyBvdGhlciBwZW9wbGUgaGF2ZSBhc2tl
ZCBhYm91dCBESUNFIGludGVyZmFjZXMgZm9yIG90aGVyIFJPVA0KPiBkZXZpY2VzLiBBRkFJQ1Qg
RElDRSBpcyBtb3JlIGFib3V0IGhhdmluZyBhIHN0YW5kYXJkIGRhdGEgZm9ybWF0LCBhbmQNCj4g
eW91IGFyZSByaWdodCBhYm91dCBldmVyeXRoaW5nLi4NCj4gDQo+IExpa2UgU1BETSBJIGltYWdp
bmUgYSBzZXQgb2YgaW50ZXJmYWNlcyBkZWZpbmVkIGJ5IHRoZSBESUNFIHNwZWNzLCBidXQNCj4g
d2UnZCBwcm9iYWJseSBzdGlsbCB3YW50IHRvIGhhdmUgdGhlIGJhc2ljICdzaWduIGEgbm9uY2Un
IGludGVyZmFjZQ0KPiBmb3Igb3BhcXVlIHRyYW5zcG9ydC4NCj4gDQo+IFNvIGZyb20gYSBURFgg
cGVyc3BlY3RpdmUsIHdoYXQgd291bGQgeW91IHdhbnQgdG8gaGF2ZSBhcyBsYWJlbGVkDQo+IGJs
b2JzIGZvciB0aGlzIGtpbmQgb2Ygb3BlcmF0aW9uLCBub3cgYW5kIGxhdGVyIGFuZCBtYXliZSBz
b21lZGF5IHdpdGgNCj4gRElDRT8NCg0KT24gdGhlIFREWCBzaWRlIHdlIHdvdWxkIGhhdmUgdG8g
d29yayB0aHJvdWdoIGhvdyB0byBhc2sgZm9yIGEgc3BlY2lmaWMgdHlwZSBvZg0KcXVvdGUuIElu
IHRoZSBpbml0aWFsIHNldCB3ZSBoYXZlIHBsYW5uZWQsIHRoZSBob3N0IHdpbGwgZGVjaWRlLg0K
DQpEbyB3ZSB0aGluayB0aGVyZSBjb3VsZCBldmVyIGJlIGEgdXNhZ2UgZm9yIHRoZSBjb2NvIGd1
ZXN0IHRvIHByb2Nlc3MgdGhlIHF1b3RlDQppdHNlbGY/IElmIHRoZSBvbmx5IHVzZSBpcyBzaHVm
ZmxpbmcgYSBibG9iIHRvIHRoZSB2ZXJpZmllciB0aGVuIG1heWJlIHdlIGRvbid0DQpuZWVkIHRo
aXMgZWl0aGVyLg0KDQo=
