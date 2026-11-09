Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794266428;
	b=PlX7X9K/hBZBHZRajyLiQHcJJ58sVfX/HcVTd/nD4I3QEP9qdPp2Hh92vHNBKkVsvKWN
	 Eec2rFh9flH2PugGIxLJ3+BoChaqVECGpDDlozReuRzCKx+tAe0pGKxsd43hO9k6MEsg5
	 VtlptnK1As+sa+MX4I5X9qzK6JOmMlV4d04bASa/oshZL/AXmBa68Lr2WbH5JBgcEGx+5
	 BTe0DAsx4pKDbz62TCwPvAPVCnc1xH0K1f9ut57eVLALHRI/ECfkFngd3siGyzrbxIchC
	 4vpqlva3zfOq2hk7JHIwonwvknq20l2Vdc483mwvOG/t/RWJ5RJkPcf8Ev9g+uN6f9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794266428;
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
	bh=A1Qs7xMjF7EtpWE3ZyaYEkIUCBCFoZV190Fww8T5aHY=;
	b=Qal8ZQK5/jCQ7Rk1aRYV8zUP86W2PCbphpC7ffi5w52nTGeKpfYBe9YdsXIIbaXsECg8
	 0aT96OQx2S2N8cVTYhc/6WWEqQEDkoYxpowZs1Ss/g49GxcWGDw4bIlXFh8Jt0QJpwx23
	 TXU2KvVm8c5tkPLoKG9IxFain5c4Th684WarDck4m3UD1cDdaKFFL83ShyU4TxvSlWIE/
	 yIw7M8K3/5JWRvjooD+n1ACkYakazZoqHxGUSgIwEbQFHl4vMe6AaHVQHbfzGqS/d4U6k
	 tOBEkAi6UaXOtTo4GsltYxUjlb00nr0kEa4GGfQACyFUreKO3USlBt+8j551U1roH8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cWa9uW7l;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA14606A31C;
	Mon,  9 Nov 2026 23:20:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AA14606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cWa9uW7l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794266428; x=1825802428;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=A1Qs7xMjF7EtpWE3ZyaYEkIUCBCFoZV190Fww8T5aHY=;
  b=cWa9uW7lB/k3fiVYmOatOQLcNYkJCLYpPcEF+V0aKA4jy4WCqL/ZBxj0
   sInLe5vKOBGPtAa0pGpnFii2WiDHoHqB3ID9gsm07egTRUDV0L03L2vNT
   IfiYgum7G9guyp3dRf/gmTYCN0gekspujSqLMbsw+B32zaSJxxGqMPEzg
   tAe7fpzdyeU8R/QA0Tgu53MbjX6b2pmfntsn+XyFbxlNbt65tk3KgPubH
   9ObmU3G3HMWot6SELEVVlJrKgM7MPpD+S5bL3Fkc97fsnUEDzkfROyGN4
   a1JSUBLftc0POV56kGRhf9xXrLL7/4KJIoPxgaEEwBB6ZVk1E8zYxtTgx
   A==;
X-CSE-ConnectionGUID: PAEkqEFFSM2i7sFnvJJ+eQ==
X-CSE-MsgGUID: arBMQ9QMQpqn1QZf829cNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3014758"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="3014758"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 15:20:27 -0800
X-CSE-ConnectionGUID: k2NPYKGkRCOmUNyya/6F9w==
X-CSE-MsgGUID: M3/mGEgPS+aNRpop1Xm0TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="9741851"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 15:20:26 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 9 Nov 2026 15:20:25 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 9 Nov 2026 15:20:25 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.9) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 9 Nov 2026 15:20:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vuwXJ9W4dxLJ7RGjIRlpA69cnt/ti/NfeXKLDn0wSxaVbmDIjRyTdcgQky6wsySkC0evOWU4IpRNjriwTpweqB+8yu6A97h6SQ0WWX/oaYK6XKQt+g1WRtf/8RCIxEOBox6/Ah90bYwxqG7ZFct/XG2jXaMx0ekbzKykYWzGdyRtl8ye6UNPc+96ybsZXfUjxjdHpwstc8I6wudMZ1R2VUfnjFwGO6Klqlp+rsvhry41bh1tkXT3Qqhf3PwhTctBgtKUL9bS6jR+MtEp2UWNwzyr4SES4kydzzpQ5vyL179ROfRMKjBEDdKh0mm+GZQFvJYAh3VOgZO8pB+ugUZmVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A1Qs7xMjF7EtpWE3ZyaYEkIUCBCFoZV190Fww8T5aHY=;
 b=FMte/nX9X/SySci/78StY4zyd+SuXFWTSq7ObS4Gsw42uJsXacTCGh3k0WB9YfeaoGCze4HlMJNjalBw/QRviI7DJNTMXQ9g1QGq16bfZlK1bDGw3nQvKK//uBh4CAs3UKmR4JI1OUu7CkgeiuLvEXJwGOj+wx1qEI3/LNNRgbrVQJDDvZwagixxz8L2wzA2j+zh6sarGiPCm6MAkWGDYaVcTV9I3G6FjPexuFkfnuzHJuoFmoNGjhygYKYhYRHu6wgxNR9B5nwujR0XST5RK2YS3RBD19eyh7v4rjvEhDGUJg42l+KHSWyt82Sx6l7x7oZiFvJAnIuAQhBficILcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 (2603:10b6:208:549::23) by DSWPR11MB9559.namprd11.prod.outlook.com
 (2603:10b6:8:36d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 23:20:22 +0000
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57]) by IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57%5]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 23:20:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jgg@ziepe.ca" <jgg@ziepe.ca>, "Fang, Peter" <peter.fang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
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
	<linux-doc@vger.kernel.org>, "qinkun@google.com" <qinkun@google.com>,
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "lukas@wunner.de" <lukas@wunner.de>, "Vivi,
 Rodrigo" <rodrigo.vivi@intel.com>, "jic23@kernel.org" <jic23@kernel.org>,
	"ksinyuk@kernel.org" <ksinyuk@kernel.org>, "sameo@meta.com" <sameo@meta.com>,
	"aik@amd.com" <aik@amd.com>, "sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Topic: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Index: AQHdXLTTjrGSfVTT6UCa8v4N/LvKxbcKKgoAgAENkgCAAFvTgIAAJv0AgA+FnACAAGOJgIAGE/cAgARqFgCAAGa/gA==
Date: Mon, 9 Nov 2026 23:20:22 +0000
Message-ID: <cbef9bda9241ffe98652172edb67fab3eb1c35ee.camel@intel.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	 <20261015145053.3664509-21-jiri@resnulli.us>
	 <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>
	 <20261023141218.GD3977851@ziepe.ca>
	 <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>
	 <20261023220030.GM3977851@ziepe.ca>
	 <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>
	 <20261103005851.GH3889730@ziepe.ca> <au5LCE1jau0yDo5S@intel.com>
	 <20261109171236.GP663069@ziepe.ca>
In-Reply-To: <20261109171236.GP663069@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB634048:EE_|DSWPR11MB9559:EE_
x-ms-office365-filtering-correlation-id: c5d817b4-f06a-4a57-2ee2-08df3eb8071d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|22082099003|18002099003|6133799003|10067099003|3023799007|38070700021|4143699003|11063799006|56012099006|261021121427099003|261026121527099003|261102123227099003|261028144727099003|261022115727099003|261022075727099003|261022105027099003|261026140227099003;
x-microsoft-antispam-message-info: MN1fEV1ZiOtdeJWpgoC8PaOeVetCdljgrTyDedmgHL9Q4zzMbly0MGc1wlTNLL/dO0WT2f7vQ8MLIUZMnvfbP3x2ir6YN0fw9uyGAh5swcsmyhKQLx6m7KX8vriuGdrNCnfKBUE7FzzK+EBQjH2rKpmPIr6IKbZKmNdrlT34DGaOk7mGBRFZgniXy3exEsGYeI8mBLbwtModZfOv9BCmM+QSTILp7L09WdmAudvVT+QjWd+Tqeyfcf/ZJOUNsnZBTHBKx18UY16Vl1KauyWvS0WIx8x+eJqiojjvFeRnTvuk3CFtkqDsrekUimV2kKnxnmY724z3K0gKrpUDxvbiw2rbTsjamPpoZ/ivcctjG6mRLb1985io1/Lj863GZOvzddpMUPhrjH/5xwSARzkoSdviHiHsvo/y1uz0W/UpUaaCqikbfqrjlvXEi3I+UCN71eozhBOpvV3xBSThW+K94gUVKbGU80ufenxwrPO8eeQxAn5pC8bx88O6KHqM+fx/XPyTuUubRaejeP5E7VhYaR5/Z5BXF4jYhakA22RV+4Hb9iHLfVvfT6s7oTvcZRP1zkBL5LiONqrMcacl9lDM0wbD6EnnYbARcO2K0+XYIWQDitaxxYCuejAh8hz+HOg3oW6HtKJbkQ6t3htZX1Ot38nYk1qHmjSoFanPkYCM3tDdixoTrAxqny8wScbK21xz8Tun3FbWMFDTPQr4H75vl17/vmju82kQogq6+oJAOWE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB634048.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(22082099003)(18002099003)(6133799003)(10067099003)(3023799007)(38070700021)(4143699003)(11063799006)(56012099006)(261021121427099003)(261026121527099003)(261102123227099003)(261028144727099003)(261022115727099003)(261022075727099003)(261022105027099003)(261026140227099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elA2bjg5ZlBXR3ZqZU5iV3ppZDgxdUFaR1lZN09OQzZJY0d5VlVEK2JOTDU3?=
 =?utf-8?B?b2gvZW9IeERvNTBSZEl0cHdqU3hGL3ZMNEd4ZHZqM1J0WmRjK1ZpTzZWT21D?=
 =?utf-8?B?a25kRSthWTVOcUcrTUN6Ny91K2NvUXFTeURvQzJOTDExRWdDQnYxV3p5U2tw?=
 =?utf-8?B?TGIyMm9wRDN5OWlPS0IxMTkyQXBLSlZ4RWlCNWpVVDUxK3lTMHpGRitZMjgv?=
 =?utf-8?B?WWtLZEEyVDlCYU80alJIUU1qUVk2aWZnQ2RBWU9QeEJSRlFCVnVDU3dkWFRH?=
 =?utf-8?B?bGpjVTI4RjRDUHVUTjNwZUUyVjF6QXYvWE9XcXZNeFRqMFFldERGaG9JRisv?=
 =?utf-8?B?U1VkSWQrc0Nic0FQSVZWbzE0dlVhQjlXN1c2UmZ3S0RoTkl1L3pWb1JGUVFR?=
 =?utf-8?B?dnI4eWR1ODQxalZhY1FTVFluVm0zRTlNNVZUemx4aE8xTURCdlR0RC93ZXd6?=
 =?utf-8?B?VnEwNVhpMUdoT0NTSDc2cmJ4ZVExbEpYaWkwTmo4SThBM2p4am9QbkdOckNV?=
 =?utf-8?B?MnRzT2lBa3Z0SFhQS0pOSkVIaHVJeDVoKzZsSXZ6S0syQTZzVWpBRlFpcGVT?=
 =?utf-8?B?OGxkRDdONDIyV0dCTHdTTUFXbUt1S2IxYkNNeDlzVktLelRRVmhJcTlmWWpu?=
 =?utf-8?B?YXhSRjZKU3BnNm84UjJpK0ttTTZTRU5wV3EwT005endNQjZNS1NBU0lSNGNr?=
 =?utf-8?B?N2x5Z2NSbTRoWVJZaUh1RGVIL2hYQVRkWlhQdjM3YTFyOWNzSUdIdkl5V2FY?=
 =?utf-8?B?QmJoRXp0U0c0Z1crZ0o1WWUwdUtMSE9yd05qZGNkZTNIT2ZrNHltTnBKSDVV?=
 =?utf-8?B?cC84WUl4VUNvUEtsM2NxcG5SN2l5ZnJZZysrMEFKbmpzMzVTSjZCMFZrdmhN?=
 =?utf-8?B?eGdEblFwSzRwTXpVeCthOWVtM0lVK0RCSnp6V3J1Q1JzWHUwZk1kRndIbVU0?=
 =?utf-8?B?QXN2Mm4xUitHOHJXWlNxSXBGM2p0cjV1SC9LS3c0Vi9hdldSbStYUnZ0K0JQ?=
 =?utf-8?B?QjlBNjg5anprblZBcmUrQ3FwejNQWHA2LzlDbWtEUk1SQ282K2tLTU9GMmRh?=
 =?utf-8?B?NkJOKzU0YmZmb0M5K3NaVTB6cThoUUsydThZc2lzQVcxNEsrenFPTUt3K21j?=
 =?utf-8?B?RE4yZGFQUVlibHpVMzBwbEZsaGpFZS85WFB2dm8vdHhDRFZ4bW9QUEtwT1NX?=
 =?utf-8?B?WERUVldCZXc0Q0huYXpkeElRQ1ZvbmVUYTlFTDlEeXYrRjRZMDBqSklKMVZ2?=
 =?utf-8?B?aXd1aFR2aDFIT3YwN0kwV2doRVI4SDNFVVp5K3h3a1o4RnN1SSt0czgyK0Ri?=
 =?utf-8?B?MHNZMjRnTUlFcUk1YlJCYmNFc0p1ZGtmMFI5T2ZYazBQWnRvSDhzaUMrZDNV?=
 =?utf-8?B?NnBPTFllSzJNQ2RqSXhyMVNKU0ovWDhUTERjMkU3aFJpdldmdGR1dzJ2SFpk?=
 =?utf-8?B?WHRZVDB5cnVtZk91QjU2YXlSd2xDc096NG82djQ1OXR6SGpDRkhEcmpLRnd0?=
 =?utf-8?B?MUJHVmpVdEF1SHZqSXYyLzhaNWFUaHJiVXdHNXhqQXRNYWJabG5saWs1bjU4?=
 =?utf-8?B?ZFZaQzhRS3lRc2NXekE5VnBUQnJ6VE9hWEJURzQ0cVowMlhVeHR5blRIM1p3?=
 =?utf-8?B?OXM1bkRTSDRlcjRjTHVqVXpxNHFoOXNQRUFJZjFDdWFzRkFLRDlVRHpqek9C?=
 =?utf-8?B?d1YxVm9vL2hjSE9ybHV6bG1Kam5ZRXExSjNaenN4bHF2WGhpai9iVC9IMzJq?=
 =?utf-8?B?ZW5HS2pTQ3QxRTQ0d3RVMDFOZk9SSjRhV0RTWlNseWJtbWpjdFZqTlpWTkt6?=
 =?utf-8?B?S0lZY2dscFp0SC9qMUlSSm93Rnh6dDgvK2dXenNCOFdPRitLZjJNWEdCMUNo?=
 =?utf-8?B?N1BxQWZSRXl0Ym9saXdhWGVoUitUNDd5RjF5YytGTUZRQWNRdzJRMWdIbGY5?=
 =?utf-8?B?MDczZGxlKzNpMlZxR0h3SmV0d0JVcjNHck5RMVY4TkRYRHMvbjhDWkhxd2Z4?=
 =?utf-8?B?ZlBBWVRWOWd4RjVNalhOeGlYZ3VGekVLVU1YYm9pMVgyWWlDWVMyenJEYWJY?=
 =?utf-8?B?Wkx2VXJnUzV2UitWRnppNUhjNHBKRzRjQ3BROGF6UU1Gd3NHNXRUNU1Jc1FV?=
 =?utf-8?B?M1BpcnBLU0VzT1Y1ZStvL1RWTVEyTUFUdUZCTmkzektSTUwvMURxTnp0NWZi?=
 =?utf-8?B?T2UyajBEdUlXUnpicS9uaVBoY3BTY1c5eW94WWxvaDlNWXNxSWdVRjBZUTFJ?=
 =?utf-8?B?N1BiVm02SHBpaDh5ekZpR0VHUzZCaWc0OVFiZTFSWjFDN0UzTnpJWDB5UCs2?=
 =?utf-8?B?Q253S2tHZ2kzL2dTQmVoWENkRXNhdVNOMWpvUWVLeFJLNUdUbHE0RjI0S2du?=
 =?utf-8?Q?t2Gibb2UGiMT/3Zc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <54A9FE2CA124064CB434FA00820A6B5E@namprd11.prod.outlook.com>
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
X-Exchange-RoutingPolicyChecked: dVECw8SRlndTwl+EwVIY2Z23mmOLiZwo2mjMG39avJgCOG14T9XG69zCEUHyp4FfEf1hGgosUQZDYh31NUzLB35Tpj5w8MtAxAOS3k/vTN3A9zovRAoi7g1+hxTPNGjXwOEodByAdJnzFkttv6KyviAdWiyUlkoMDCp0EY8q+cd6XJLt1v3b2M0ggZtlLBllPpg1Lr6YP5ryfj48yZKVy6WNwm/1on7Z+Csr/wWk4tFQpKaP+kEun7mPyOkh7y5QegFvv+emyy6JyTkSG/jtuBzISuYZEi/fgNrJqlcI5rVw3xE4nycI1p6gXOh9t0hK6+eteL7KuPjYI4esZvYseg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB634048.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d817b4-f06a-4a57-2ee2-08df3eb8071d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2026 23:20:22.3905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bbTKuTM5NYn32K79barGhoNvRzQ9d5Ff4T9nzeoxU6k94kVDmTxF+E/f6Jd9Q0dFeiSCT+2/AMoPf6uyJg7JWEtJ21aNOtKPnOPUkI86SIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR11MB9559
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTExLTA5IGF0IDEzOjEyIC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IEkgd291bGQgYmUgdmVyeSBoYXBweSBpZiBJbnRlbCBjYW1lIHdpdGggc29tZSBwbGFuLCBk
b2N1bWVudGVkIGluIHRoZQ0KPiBBQkkgY29tbWVudHMgYXJvdW5kIHRoZWlyIGxhYmVscyBkb3du
IHRoZSByb2FkLg0KPiANCj4gV2hhdCBJIHdvdWxkIGxpa2UgaXMgdGhhdCBnaXZlbiBhIHNwZWNp
ZmljIGxhYmVsIGFueSB1c2Vyc3BhY2UgY2FuIGRvDQo+IGEgdmVyaWZpY2F0aW9uIGFuZCBmdWxs
IGR1bXAgb2YgdGhhdCBkYXRhLCBpbmNsdWRpbmcgc2lnbmF0dXJlDQo+IHZhbGlkYXRpb24sIHdp
dGhvdXQgbmVlZCBvZiBhbnkgZnVydGhlciBleHRlcm5hbCBpbmZvcm1hdGlvbi4NCj4gDQo+IEll
IGl0IGlzIGVudGlyZWx5IHNlbGYgZGVzY3JpYmluZyB1bmRlciB0aGF0IGxhYmVsLg0KPiANCj4g
U28gaWYgc29tZW9uZSBoYXMgdG8gc2F5IGV4dGVybmFsbHkgJ29oIHRoaXMgd2FzIGEgbGVnYWN5
IFZNJyB0byBtYWtlDQo+IHBhcnNpbmcgd29yayB0aGVuIHRoYXQgbmVlZHMgdG8gZ28gaW4gdGhl
IGxhYmVsLg0KPiANCj4gVGhpbmsgb2YgaXQgdGhpcyB3YXksIHlvdSBzaG91bGQgYmUgYWJsZSB0
byBydW4gYSBjb21tYW5kLCBsZXRzIGltYWdpbmU6DQo+IA0KPiAkIGF0dGVzdGN0bCBkdW1wIHJl
cG9ydDANCj4gwqDCoCBpbnRlbCBURFggQToNCj4gwqDCoMKgwqAgLSBGaWVsZCAxDQo+IMKgwqDC
oMKgIC0gRmllbGQgMg0KPiDCoMKgIFNpZ25hdHVyZSBWQUxJRA0KPiDCoMKgIENlcnRpZmljYXRl
IGNoYWluDQo+IMKgwqDCoMKgwqAgQQ0KPiDCoMKgwqDCoMKgIEINCj4gwqDCoMKgwqDCoCBDDQo+
IA0KPiBJdCBtdXN0IG5vdCBiZSBzb21ldGhpbmcgbGlrZToNCj4gDQo+ICQgYXR0ZXN0Y3RsIGR1
bXAgcmVwb3J0MCAtLWtpbmQgdGR4X2xlZ2FjeQ0KPiAkIGF0dGVzdGN0bCBkdW1wIHJlcG9ydDAg
LS1raW5kIHRkeF9kaWNlDQo+IA0KPiBEb2VzIGl0IG1ha2Ugc2Vuc2U/DQo+IA0KPiBXaGF0ZXZl
ciBsYWJlbGluZyB5b3UgY2hvb3NlIGhhcyB0byBmb2xsb3cgdGhlc2UgZ29hbHMsIGFuZCB0aGVy
ZSBpcw0KPiBzb21lIHRyYWRlIG9mZiBiZXR3ZWVuIG1ha2luZyB0aGluZyBzZWxmIGRlc2NyaWJp
bmcgZm9yZXZlciBpbnRvIHRoZQ0KPiBmdXR1cmUgYW5kIGV4cG9zaW5nIHByb3RvY29sIGRldGFp
bHMgaW50byB0aGUgZ3Vlc3Qga2VybmVsIGRyaXZlci4NCj4gDQo+IFRoZSBmdXR1cmUgc2NhcmVz
IG1lIHNvIEkgd291bGQgYWx3YXlzIGRlc2lnbiB0byBpbmNsdWRlIGEgZGVzY3JpcHRpb24NCj4g
b2YgdGhlIGJsb2IgZnJvbSBURFggbW9kdWxlIHRvIHRoZSBndWVzdCBkcml2ZXIgOikNCg0KU28g
d2UgaGF2ZSB0aGlzIFNHWCBiYXNlZCBxdW90ZSBmb3JtYXQgdGhhdCBpcyBmaXhlZCBiZWNhdXNl
IGl0IGFscmVhZHkgZXhpc3RzDQppbiB0aGUgd2lsZC4gR29pbmcgZm9yd2FyZCB3ZSBhcmUgbW92
aW5nIHRvIERJQ0UsIGJ1dCB0aGF0IGlzIGEgc3RhbmRhcmQgZm9ybWF0Lg0KU28gYWxzbyBzb21l
d2hhdCBmaXhlZC4gSSBndWVzcyB0aGUgcXVlc3Rpb24gaXM6IGlzIHRoZXJlIHNvbWUgY29tYm8g
b2YgYml0cyBpbg0KZWFjaCBibG9iIHdlIGNvdWxkIGNoZWNrIHRoYXQgY291bGQgZGV0ZXJtaW5p
c3RpY2FsbHkgZGlzdGluZ3Vpc2ggYmV0d2VlbiB0aGUNCnR3bz8gVG8gZG8gdGhpcyB3ZSB3b3Vs
ZCBuZWVkIHRvIGFuYWx5emUgdGhlIHF1b3RlIGZvcm1hdHMuDQoNCklmIHRoZXJlIGlzbid0LCBJ
J20gbm90IHN1cmUgd2hhdCB3ZSBjb3VsZCBkbyBhdCB0aGlzIHBvaW50LiBUaGVyZSBpcyBhIGxp
YnJhcnkNCkludGVsIHB1Ymxpc2hlcyAocmlnaHQgUGV0ZXI/KSB0aGF0IGNhbiB2ZXJpZnkgdGhl
IHF1b3Rlcy4gSSdkIGd1ZXNzIGl0IG11c3QNCmhhdmUgc29tZSB3YXkgdG8gZGlzdGluZ3Vpc2gg
YmV0d2VlbiB0aGUgdHdvLiBDYW4geW91IGNoZWNrIGhvdyBpdCBkb2VzIGl0DQpQZXRlcj8NCg0K
QW5kIHRoZW4sIEkgZ3Vlc3Mgc29tZXRoaW5nIGxpa2UgYW4gYXR0ZXN0Y3RsIHRvb2wgY291bGQg
YXR0ZW1wdCB0byBmdWxseSB2ZXJpZnkNCnRoZSBxdW90ZXMgdG8gZGlzdGluZ3Vpc2ggdGhlbS4N
Cg0KQW5vdGhlciBvcHRpb24gd291bGQgYmUgdG8gdGVhY2ggdGhlIHdob2xlIHN0YWNrIHRvIHJl
cXVlc3Qgc3BlY2lmaWMgcXVvdGVzDQp0eXBlcyBmcm9tIHRoZSBndWVzdC4gVGhlbiB0aGlzIG5l
dyBjb21wb25lbnQgY291bGQgb25seSByZXF1ZXN0IERJQ0UgYW5kIG5ldmVyDQpiZSBzdXJwcmlz
ZWQgYnkgU0dYIHF1b3Rlcy4NCg==
