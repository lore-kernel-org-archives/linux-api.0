Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792784481;
	b=AQJR0UCKyMlUNOlQOJ1zoMecqgtuVEw5vMH8xzXY27g8NpCtgK/1YhW+c5rfdVWuS+HA
	 iIvaw88LoG+mQp5/zTkgmMEzrN5S/MtVR6lYJGhX/l8Z3CPycBS8IKHuOEfONgTfzBZ8J
	 5/PdheFjJAmfpxfvMWMIqwsHJj2ri4Y4Vj2RAB9fnBoBAw2UeqXGrdBJcxNhLmQ65JGu5
	 P2PzE8JIVkscpbnYzx31aoXnJrhjRjGWhUKWClap5FDnv4kqwF9046D1qDEg1DFIV5sSe
	 9Axg8S/Oz4TK0zHZ3rSZyG/qOHfPxsBf+RWbo51Kwa3QOhjJEpH+AzcKeZsm5hpTocw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792784481;
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
	bh=ZIlKnP7p9FEK7BGWaskWBfuZ70fo2dUFPebYmXlC23k=;
	b=ayUEIi5kU4fh6Ku0tvkZgrZLiYY0ccDbJtHfHOy557JRYqnlJU/KRL2kEqxAI/NS8Gfn
	 d+/cYV9/vgTwox/3Dn2q5DM+/zuUQaW0rxoKUqdNFDWPHArpcWxWD8SZCDiK4WuwdwHrO
	 PVVQUklX4v09tA1JMsBZOs0krbvDumYObSI3VyaLQYp3NZK4Tfhdyr81sJCqeFecEefgE
	 WZdbxmXC3/gwjop8xsDS/tMXFAtJsM8fUHqf3GvWs0+Qkl8oV6u3OhCmO2J6PeqTv5J7a
	 A8RoaNtjhbmo+QDBi8vvEU2F/7l6BKFWIXutXiAQ1PF0LFMtPE2BtVM62bN9bKmg0sA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Gxq7OmMV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9520F606A31B;
	Fri, 23 Oct 2026 19:41:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9520F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Gxq7OmMV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792784479; x=1824320479;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZIlKnP7p9FEK7BGWaskWBfuZ70fo2dUFPebYmXlC23k=;
  b=Gxq7OmMVERfKB5jkjXkC29v25WrF1AckyoSQefDRqlY5NXYrYBKEhC7w
   2nTANf51n4Wv1RwFZMUc5onIvi46A3CcUguIBmURrP8NjCC/zGWFBWMpw
   n3XxT6dOr6T8KEim65W3xawJNyhaXrqLAtETSIbhMiEsZFDaC0U7qWEO4
   7aNkpLE8681Q21VIg3nHNt4IfvocCRaOgOEAO3a0hhtq7f/lK0DZtxFiK
   Sav7q9impFFooLuYQxnuZlP2gsxH1vOhFvlZow+NJcDl1NKrj3/8g7QbN
   20RqaryhqRJl+xxUhkPQ2oNEg3w3NRSd99tsuoCscrZJvkHH5RrqWELkc
   g==;
X-CSE-ConnectionGUID: V5YxIzvuRhSEZVOAAMVq4Q==
X-CSE-MsgGUID: Mc2skfGaTUyhs6n0AOrtdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1436356"
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="1436356"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 12:41:19 -0700
X-CSE-ConnectionGUID: b6LgskWdQ1W6YkqVgVFkVw==
X-CSE-MsgGUID: GTw4qVyURuisrZbROUtwFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="3814767"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 12:41:18 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 12:41:18 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 12:41:18 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.66) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 12:41:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sb6DnvQpZi9wmX6UsWSVmAAYsxDdlirqM8Gz7Xu74tmzIy6erPUKC/gQqmSpG+wf1RIILEKzpPraroy6+QyqsbLZwLm6mNATAj1jbqkGghzuJdQzGUua3O55nD56rrFMJQqCK0AGZSJAKDI+KlrHdMwIJlkoKxdUySbNzVPw9cJ01TaHqvqwEJqK+9bxDa9MCYhUmUHgqDjNPx6LdzmC1uwzj7nUeVVVHFIynUDsnCWVmvkG9s7k+oDuRcYCw5Fa2TINF3TrvFHpUr5MR42NAp2xv5Rd7TR958ykAx8OawyqkxgdLbTG6MBOBwYJ1ByjtJWOHLPZ2TcA8hf000NroA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIlKnP7p9FEK7BGWaskWBfuZ70fo2dUFPebYmXlC23k=;
 b=eGPqUY5QftmFEO8j0tuYnxk5M1dpjkAyPBoh52IlDUOJ0Hs04I0/Nz/AhGx0VGn6jzQ/vcrbc8LPO7CX0zIZHvnwrFB0PGRX2YBn/tGwHnnpNaGk1zZNcFenkqvn14XYmeHbXuNx7RaiC7ZRkR1IsN1lILp9o06IzfgYMcalNGuEjWRHqRUpDZn7mIQ/LnHC+UMoVIKKheOz/+PaXDxI+cBzN/edu/UOf02vYVI2PROb9OivA94FcvhhVnPwWBhM522VbXVwBKD5m8OSUvxLK7Xhfp81/PPs2Hekslx86lnFJkEe/1d6qZZxJRgT++sAz4o1XxtxK1dPltnmjbF/RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 (2603:10b6:208:549::23) by SN7PR11MB8112.namprd11.prod.outlook.com
 (2603:10b6:806:2ea::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 19:41:08 +0000
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57]) by IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57%5]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 19:41:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jiri@resnulli.us" <jiri@resnulli.us>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "sameo@meta.com" <sameo@meta.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"alistair.francis@wdc.com" <alistair.francis@wdc.com>,
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "ankita@nvidia.com" <ankita@nvidia.com>, "Xing,
 Cedric" <cedric.xing@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "Quigley, David"
	<david.quigley@intel.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
	"lukas@wunner.de" <lukas@wunner.de>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "aik@amd.com" <aik@amd.com>, "jic23@kernel.org"
	<jic23@kernel.org>, "ksinyuk@kernel.org" <ksinyuk@kernel.org>,
	"qinkun@google.com" <qinkun@google.com>, "Fang, Peter"
	<peter.fang@intel.com>, "sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Topic: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Index: AQHdXLTTjrGSfVTT6UCa8v4N/LvKxbcKKgoAgAFReICAABf5gA==
Date: Fri, 23 Oct 2026 19:41:08 +0000
Message-ID: <ac3b2426d4a25219f608eb0506f2631c8198c397.camel@intel.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	 <20261015145053.3664509-21-jiri@resnulli.us>
	 <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>
	 <atui5si5xs5px_Or@FV6GYCPJ69>
In-Reply-To: <atui5si5xs5px_Or@FV6GYCPJ69>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB634048:EE_|SN7PR11MB8112:EE_
x-ms-office365-filtering-correlation-id: 303dbe58-174b-4b87-fa97-08df313d95db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|261022105027099003|261022075727099003|38070700021|11063799006|4143699003|10067099003|56012099006;
x-microsoft-antispam-message-info: DmQ5RQRfQV5/Hzd/9GZ/IlzXpCuzZwcPsmqaco4MI2Jr4kGrAnOqN+MP+OAmiD7yuL+HZwMPDIk81Trj0tewRShGdLS7ukLlgWgPhRBFe65aGWZ141PaR+sJERxAQnCjXqA9wUj49cPf4IUt+/iItstHhqWLp1xXqHsSDGLY+hx5iYrlCSAguEGYNwYjidqD/NQCI/qWlZGfKfV6/tH8IZFwcFcHcLyEydYDLfa4uDGhffPDzAOCEXBfZWMANqTFugYwVUrDemLj0zvO3A71raQXqPf68F49AGa17r+KoaO3ocQGbf2XEb8wtrJKOo0AfRCPeeipqq/3QGKelcN00tHQV9vH+DI9mqETkWwtyfz8GRoyLEf4tMbK0h3eufyChUwrYfWlgdKByb/OWqynGPydybFI1j/rrELflPD+JDVycyeEnPGEpGWMIPtARwYAp4foIPrSn06Ob/TfP17y9yjkOdV7dNxRLR/sofqZCP7XNelH+6jIS4M+a/H3Aq+M5KXzlj/IKacu/TBIXPHbefB68hOZOa3TMuxa5TRHPi96kwZgA8aXcYxFm7Lz66ft+9+TUru9A8BimbIpiujUUKrlnowBwZBkw9CYJkErS3FQVC1V1Yl8AghhlbjtByxtdXvLHT3tdTY+nJjnPl7lTVtI6VI9lNHgPkBaY+MqzOYX4Q1Y3LrPgEC61VG29ZpVfoUjJqvqzUQds4AryG474/7Le1/MHxDrLdiE26WEnHw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB634048.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(261022105027099003)(261022075727099003)(38070700021)(11063799006)(4143699003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmpSa3llaENIK3k4c0tsMGJLTnNPYWZDdE9ETTB4QjRaZW1QRzJENWwyWFNG?=
 =?utf-8?B?TGhJY04vOEhJTHBMVzUvK3hIcERlV0ZDVGNvSS9UYmtvWnIrWTRYYVg4RllU?=
 =?utf-8?B?RWhJVHFTc3M4QjluU1MxMTV2bkhxMzVzOWs5TEZud2M5RUJsUGhldWlQSE9k?=
 =?utf-8?B?dWI5Y01pUDhkM1lyWnI0Nk10WkYxN0I4ekt0RW9WQmwzRm5pMVpMNkRKT3pN?=
 =?utf-8?B?UUg5ak9Xd0ROZVdOQkdVUVQ4Y1FTWU1ZVlRBSXR5dWc1dy9uMGpkUlAyOVhG?=
 =?utf-8?B?Z1EzYkRuME83OVZoQ3dRY0lEeVczMGJwYkkyMGJEZFcxUzA2NGQyNDF2MHpF?=
 =?utf-8?B?a1BMWS93Qkh0bXovQ3JmUVJBZURWUmQzL0EwSzl3WjFSajlRMmtYUnZtUlY5?=
 =?utf-8?B?dHhGOW5PRWFUMHNiMHRVREdLVnhxY0hDeVNWMm5DWmo5QVNUSE9adTk0NUtT?=
 =?utf-8?B?WFhSRDJHTW9rc0kyZEZVclVCS2c3bW11RElGcTVTVXlqVWtqdTNrTFdBTEJi?=
 =?utf-8?B?OC9zdzI0T0NTUVVGU3dvVnRvTUNkWnRySmkxSUM2SjNWR2tjUHpJTkJBSndn?=
 =?utf-8?B?eldML2ZJaVYwYUh5anArZ0VCSUlTdnM0NlB3Wk1vMjkzcEpkVUxBSjY4UlMy?=
 =?utf-8?B?NXlRR3BpY1BpSWdHSmxwQTZnTCt2eWhLNEVpR1FTQ0NyL0ZXcHgvWTZGUmo4?=
 =?utf-8?B?V0ovdXpLWU0xSzhRY0FaR0xVcDZwY1c1QUM3QWROdnJOVklXdCt3dFpJdUZC?=
 =?utf-8?B?Vzh1RHREL1JoRzFuaFdtY2EvSktnb00rRHRSSkgxTmdCK1NNaXhqRmo3MWls?=
 =?utf-8?B?R01UL0Y4ODBFdDRHVDlNNWZ3R2gvanU5QzV1K3loaDdwNmlqOWpmTVFscm92?=
 =?utf-8?B?SWR6cHNsK2c1T1k4TkRvVUFBS0VIbmhkbHY0b0lZYUJRVFhuWURQdGJzRDFv?=
 =?utf-8?B?WmRVdFpDU1J2TTl4M0FTNXVJWUE0U0F2aUJiMzQyQTdUZ3MrVysvSnRML3hM?=
 =?utf-8?B?NW1CditqR0E5dkpaUm5UbWw0eVVBaEgwdGZ5RFczVGw2UjNHaklzWVFsNWFx?=
 =?utf-8?B?STVYNHFYTEcvOHpaRXpoN0dXWnZKd21SQUswTUN1Vmc0VXkvM1JBRjFwQ1FM?=
 =?utf-8?B?cjFmamRKU0ZQUDFhYkNHRzliclJMU3dNMnFzeFJCS082TnZUM01mNkpTYnBv?=
 =?utf-8?B?Y05WSjdtcW1TL3hqWDF2cUF4b2MyYzRZVWdOYnVtaUdIY0xaSU9aVC9PWXBY?=
 =?utf-8?B?SkhoOVJjU1dUb1N4TWEycUh2UVV2cWxjMkVqUSt2RExhWUhjN1NOTXEyaFlj?=
 =?utf-8?B?Q3IwMTlQRE1HdFlIU2lFSGhBcjFyUmlWN0Q4RzQ2ZTdneGgzYTFCYUs1SzVK?=
 =?utf-8?B?N01YTlp5S0hVay9uQjdpbHNLT0M1YzBHUm0yQzNqUkZMb3JIVDlaZlpsM3lh?=
 =?utf-8?B?TzlvbThBeldtS2l0MTdFRDF2dDZOSEkxOEtwRUIvZEl0OWhweTVSVnNkRyt6?=
 =?utf-8?B?WGhBazBXUmhickRodlRqa0pMVTMvazJWT0FodlRUUjdSNUR4REJienI3a2Ru?=
 =?utf-8?B?aWZQS1lQak83THRNckwzTEJqUDc0RDNOTTF4dGRJT3NFaFVGZ3cyRkJwa0lh?=
 =?utf-8?B?UWFXUmNjMmIxWml1M3hBYTA3M0xpUDc4cElyM2JjY3JEUWZLbzlSVzZZZlhp?=
 =?utf-8?B?QmFZQXc3REd5Y0dXVE8xUHpDSHVIK2UvRk9MRlF4RHdHb3NMU01EUG5MQVJP?=
 =?utf-8?B?NUdMbFRuZnRtbzZuSER3SXF3SFRUUHlyMDlvWTVsTnZFeVRvSUkycHNUVGRI?=
 =?utf-8?B?Mmp6U3haMmVnekhYNG9sUjV6akpGT3UrcGlNbGkraEZ6YkZqNjQ3K04xM01Z?=
 =?utf-8?B?SGhhWmdqZ2dEK2dPWlhod2ZmQTFsbFhMK2YydU9neXM5eWtqak5HdzJ2eXJi?=
 =?utf-8?B?aHQ2dSsvQkxYVW9PSFlEU1FuQjlra3g4bksrbEoxTloxOEFHdFBKcFBHTnU1?=
 =?utf-8?B?czBENnZEWTV2T0JTWGYyTjcxZnh4MzVnMlVESTRLajN6Z0ptaHFPdEdwWFVP?=
 =?utf-8?B?TGd1eTY5OU5CVVdGRUhnQkFaYjNvaW43bHhyNzNKTm9QMWNmYTN0a1R6YzdP?=
 =?utf-8?B?QkswdDdFQUxJcEx3YzFmdFFrZnlpcjVEN1BBYzU5NWd1QlhUZWFZM0ZMTjVM?=
 =?utf-8?B?czg1NnZVT2RmUTlvMy93SS9XemxDN3grMTVqQjVod056NGV4eThlM2I5dVdt?=
 =?utf-8?B?ZHhBREgya1JEVkVBclRiYXpwSVlZRHJaVWI2bVZZUEc2TlBOVyt5SEF0VXhU?=
 =?utf-8?B?TXllYmFlVStQYmRwREdLdjhaS2twNWI1ZXdMUXROM3VBVHM0c01vaU16RFRH?=
 =?utf-8?Q?wot+E6ios9lih+JA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA3FC173A7199045B438D6E659128EDC@namprd11.prod.outlook.com>
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
X-Exchange-RoutingPolicyChecked: 0RwxIWPVmp90ea6wMwRGEnZsEwNVWz+ts1Ptyysi5KiikmAroaQvvB8XZd0Q3c6yJLT/jT157qpuQU+/vnZ39ruejip1tBSfuYN+HMfGJA7D041g39H4vnOpiDzOjOM4w5eFsdVh7ZQvavRUXFJVd4KdYS0PZiNyjzMYEvO6+ooliaa8ri7ocAirCL+EvT8kfE+aayc6p10sfqa8hWuoTHYZrDhIIP2H9eKmF1dydIk0k7JvzDNkJMUPO0A+H92dnsRNCH3zk/ETq4LWth1PHImKZcGM0lRNllrt+Svkar0Co5AwRUs54wDxWeI1MhK96iBAZh+9SE4MM8jvCsfmkQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB634048.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 303dbe58-174b-4b87-fa97-08df313d95db
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 19:41:08.6148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ssz3cT4LutlKQ+SdG92M47/P7LjX/UyLCbjTbAkRYQ6QA4QhP3/UVjEOSBlC9JwWmahjwVRu2YQMty339YMuUGbyGwdQeNEUeoqT6KvuZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8112
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTEwLTIzIGF0IDIwOjE1ICswMjAwLCBKaXJpIFBpcmtvIHdyb3RlOg0KPiBG
cmksIE9jdCAyMywgMjAyNiBhdCAxMjowNzoyOEFNICswMjAwLCByaWNrLnAuZWRnZWNvbWJlQGlu
dGVsLmNvbcKgd3JvdGU6DQo+ID4gT24gVGh1LCAyMDI2LTEwLTE1IGF0IDE2OjUwICswMjAwLCBK
aXJpIFBpcmtvIHdyb3RlOg0KPiA+IE9uZSBpZGVhLi4uIE5vdCBzdXJlIG9uIGl0LiBXZSBhcmUg
Y3VycmVudGx5IHdvcmtpbmcgb24gc3VwcG9ydCBmb3IgRElDRSBiYXNlZA0KPiA+IGF0dGVzdGF0
aW9uIGZvciBURFguIFRoaXMgaXMgYW4gaW5kdXN0cnkgc3RhbmRhcmQgYW5kIEFGQUlVIG90aGVy
IHZlbmRvcnMgd2lsbA0KPiA+ICh3YW50IHRvPykgc3VwcG9ydCBpdCB0b28uIFBlcmhhcHMgaWYg
d2UgY291bGQgaGF2ZSBhIHNpbmdsZSB3YXkgdG8gYXNrIGZvciBmb3INCj4gPiBESUNFIGJhc2Vk
IHF1b3RlLCBpdCBjb3VsZCBtYWtlIGEgY3Jvc3MgdmVuZG9yIGludGVyZmFjZSBtb3JlIHVzZWZ1
bD8gQ2FsbGVycw0KPiA+IGNvdWxkIGp1c3QgY2FsbCBhbmQgZ2V0IHNvbWUgc3RhbmRhcmQgZm9y
bWF0IHRoZXkgY2FuIHVuZGVyc3RhbmQuIEl0IG1pZ2h0IHRha2UNCj4gPiBzb21lIHdvcmsgb24g
dGhlIFREWCBzaWRlIHRvIGVuc3VyZSB0aGUgRElDRSBmb3JtYXQgcXVvdGUuDQo+IA0KPiBZZXMs
IHRoYXQgc291bmRzIHVzZWZ1bCBhbmQgZml0cyB0aGUgcHJvcG9zZWQgaW50ZXJmYWNlLg0KPiAN
Cj4gREVWSUNFX0dFVCBhZHZlcnRpc2VzIHRoZSBzdXBwb3J0ZWQgZXZpZGVuY2UgZm9ybWF0cywg
YW5kIGNhbGxlcnMgc2VsZWN0DQo+IG9uZSB0aHJvdWdoIEVWSURFTkNFX0dFVC4gUHJvdmlkZXJz
IGltcGxlbWVudGluZyB0aGUgc2FtZSBzdGFuZGFyZGl6ZWQNCj4gRElDRSBldmlkZW5jZSBwcm9m
aWxlIGNvdWxkIGFkdmVydGlzZSB0aGUgc2FtZSBmb3JtYXQgaWRlbnRpZmllciwNCj4gcmVnYXJk
bGVzcyBvZiB3aGV0aGVyIHRoZSB1bmRlcmx5aW5nIHBsYXRmb3JtIGlzIFREWCBvciBzb21ldGhp
bmcgZWxzZToNCj4gDQo+IEVWSURFTkNFX0dFVChjaGFsbGVuZ2U9bm9uY2UsDQo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBvYmplY3RbXT17UFJJTUFSWSg8YWdyZWVkLURJQ0UtcHJvZmlsZT4p
fSkNCj4gDQo+IFdlIHdvdWxkIG5vdCBuZWVkIGEgc2VwYXJhdGUgRElDRSBvcGVyYXRpb24gb3Ig
cHJvdmlkZXIgZmFtaWx5LiBURFggY291bGQNCj4gYWR2ZXJ0aXNlIHRoaXMgYWxvbmdzaWRlIGl0
cyBleGlzdGluZyBldmlkZW5jZSBmb3JtYXRzLg0KPiANCj4gTWFrZXMgc2Vuc2U/DQoNClNvdW5k
cyByZWFzb25hYmxlLiBIb3cgYWJvdXQgaWYgeW91IGFzayBmb3IgYW4gdW5zcGVjaWZpYyBxdW90
ZSBhbmQgc29tZXRpbWVzDQpnZXQgRElDRSBhbmQgc29tZXRpbWVzIGdldCBhIGxlZ2FjeSBURFgg
cXVvdGUgZm9ybWF0PyBBbmQgcHJvYmxlbXM/IEJlY2F1c2UgdGhhdA0KaXMgd2hhdCBtaWdodCBo
YXBwZW4gYmFzZWQgb24gdGhlIGN1cnJlbnQgcGxhbnMuIFBsZWFzZSBzZWUgbXkgcmVzcG9uc2Ug
dG8gSmFzb24NCmZvciBtb3JlIGVsYWJvcmF0aW9uLg0KDQo=
