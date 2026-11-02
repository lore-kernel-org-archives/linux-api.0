Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793646168;
	b=2ozXawY7recRk1EiH8hDLt/0TEXwv4UFEm3JjfaZsl4+tK0z1EFewTJX1/1oVHnbxqj0
	 C7C7FXa/vkIu3TRf7ll7FCFwHOo56n8ytBBnDopStB/LC5sm6gbqqZqxz6xnwryzLcKCd
	 5BmvN9I0bl6NA/3rzIvDfWxy5xsbo2pZKKTzyoQM7lzF/7qL4jW+Szhn/geCb7Bpl9PPw
	 G8zUTTe5B0PywTV6y/DzeRfeCkBk2wnTr/jTrFrhwcijamk5xcecGOrCvgZOsw4bgM1HE
	 aeX1ioY8B9raCCbEEtagesn2AkDmOEOtnoPrgvVgCd28edB0D1vA+6v5qUuAWw8E9rg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793646168;
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
	bh=BIc2lzvSLE389QaZhp2RLFGkKUz/zoIeYiB/ijacAog=;
	b=aM8gRZ20Y4/L7H06kGSUSqFGgPj2JjYXuWjoQuydSwuU8pmDyTzUUdQEdhcX8DPTjuWb
	 9Ebzenr2vlwrUAU5RKsfBdvvn9F9D57DncMS7qfdfZCwEU1J7Mhquf3CQLq6LfVA1vov+
	 2Ozbs6Fu10NO+AEasxKnWSL5JHc3cndQGvGqaeGcg4llJu5GvF9f5UrvTMm2f3dNdO7TS
	 Yk1U1ch95XLfSLXoYrCx9Ii610wRzQnIAhS5oPwhzkuF9WzRdk+ok/0mpcGKcJHgmmJF7
	 rrb5sLHJyaNRZFKQ6IcCrXfY47T29yjYtN1/leli01NMtwVGhRmfUObX2/8R1hx3rzg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mtmuSPSw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38B5606A326;
	Mon,  2 Nov 2026 19:02:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B38B5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mtmuSPSw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793646167; x=1825182167;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BIc2lzvSLE389QaZhp2RLFGkKUz/zoIeYiB/ijacAog=;
  b=mtmuSPSwxbMw/Tlwn0DdCeoj6AYv8GS2NIW7++ISkfQiqnKeSCVOo0th
   Vl5racQ1LD/NrQns9TeabqO3l5JwsUbw+STOyjFy2H8V6k8k6VtGMPEJu
   6bhxdfEzVaWLLSCZoqfNfQL5qLWNwQ1QFKezDhPNkYjnn9RcnGDuHZtyC
   evczd/kgR5kApJnV+1IsjemYJ3ge4qjul6Q2n+vnqTLsEZTMiUJ+UVhEj
   8AY3TYpdPQdjX83hjKZ/FH9m1iyIsmtailvCP0o+UXcUCDjfZmeggwTZl
   YlyRu3zJRAlXqqPESuQDuxy0KaQgKcy192PsFg5vRYUZa5h5NYh1UkLOv
   g==;
X-CSE-ConnectionGUID: lFKIE5R4Q1u9lgbuM3hN7Q==
X-CSE-MsgGUID: GoDdEpeoQgWyWAECDVLPwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2261066"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2261066"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 11:02:46 -0800
X-CSE-ConnectionGUID: uIZTxabMTSuguDpnt/9Zow==
X-CSE-MsgGUID: zIpB6t6bTuu5HIH2vCI4Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="6325444"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 11:02:45 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 11:02:45 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 2 Nov 2026 11:02:45 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.33) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 11:02:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DcrBn1a4AggQk6rxOeoq64DZhgcgwrGY8iFCV3G2Rnwc97ybUtW0OIGHdz7BuCdAJPZYyLnFvGarieGqYbVbSgn4KKxjuk9TBokWv0NMGP4pMDoQvQboHHCbCbIisl+6UqwK+wQXdXjrObkfZiHkAce0vtYTtQ/mhNtRb3Grd1lbuBM+B0Ia19Q750PGA9crgL6e1WP6FrSIwb77AVcmpD3nxpCcPppToP2URfV0Cke8un0fOiYjZH2dwIVnCP39W5EtWG5V72tKPaAzOZbrstRdjpWkKKAlQPWuko8JEPZYUGgNn0NEXI9u1CuxVJkzS0OanHbx+U9gTyyeGV2/yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIc2lzvSLE389QaZhp2RLFGkKUz/zoIeYiB/ijacAog=;
 b=uEV4bYDSeWJHQICPH9YsGh4g/Oltx/DIwvv4h17aBin431reAGXzFelgW1iG7yYjRkvdYwSqCqAnhmty/3MdJMrVZZGCdXFqq+zKVwk6b4tozMZpVudJDrCVThfK84L2Rj4ch9T0+0dfJmRtdaAK61QDScRfR2GymaKu9acDyZ+GdCTSLPM47fTMg/z+SgqLzjzPyMcrjiMyUg5PLBkCfb9EQb7wH76JOBEr3YPEU/iDxsAswRCgFHrJvmS8YfKpxea3sYmzd333A7fsRqzUL/ah73TWC0F2iygIEwzsWM5vQpH4jZ6vkGpZe7BeMU+AksYm7c0AXL59FB3VdDEW6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 (2603:10b6:208:549::23) by LV2PR11MB719417.namprd11.prod.outlook.com
 (2603:10b6:408:413::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 19:02:37 +0000
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57]) by IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57%5]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 19:02:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jgg@ziepe.ca" <jgg@ziepe.ca>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Xing, Cedric" <cedric.xing@intel.com>,
	"alistair.francis@wdc.com" <alistair.francis@wdc.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"ankita@nvidia.com" <ankita@nvidia.com>, "jiri@resnulli.us"
	<jiri@resnulli.us>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>,
	"Quigley, David" <david.quigley@intel.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "pgonda@google.com" <pgonda@google.com>,
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>, "Vivi, Rodrigo"
	<rodrigo.vivi@intel.com>, "lukas@wunner.de" <lukas@wunner.de>, "Fang, Peter"
	<peter.fang@intel.com>, "jic23@kernel.org" <jic23@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "sameo@meta.com" <sameo@meta.com>,
	"aik@amd.com" <aik@amd.com>, "sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "ksinyuk@kernel.org"
	<ksinyuk@kernel.org>, "qinkun@google.com" <qinkun@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Topic: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Index: AQHdXLTTjrGSfVTT6UCa8v4N/LvKxbcKKgoAgAENkgCAAFvTgIAAJv0AgA+FnAA=
Date: Mon, 2 Nov 2026 19:02:37 +0000
Message-ID: <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	 <20261015145053.3664509-21-jiri@resnulli.us>
	 <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>
	 <20261023141218.GD3977851@ziepe.ca>
	 <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>
	 <20261023220030.GM3977851@ziepe.ca>
In-Reply-To: <20261023220030.GM3977851@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB634048:EE_|LV2PR11MB719417:EE_
x-ms-office365-filtering-correlation-id: a920968c-5409-4965-24ef-08df3913dc77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|38070700021|261021123027099003|5023799004|11063799006|4143699003|261021135927099003|56012099006|261028144727099003|261022075727099003|261026140227099003|261021121427099003|261026121527099003|261022105027099003|10067099003|22082099003|18002099003|261102123227099003|6133799003;
x-microsoft-antispam-message-info: mE25SFpyupBMW3N874ui1J3T8aH0yT9HBLO+mqXbrhV8N671stGS1mpT5EdrXMgpOeFklsCR0q/prE7akM9XYNWrzL6+N0yXDFHejhyuehygt+a1kwCvbRS2LaY0Q1wn2rgXDB4b6DY0Wo08nrsu94EDEdjda5qarbkhtneqpcpxdDLDTexxQZOxYZloxLE79ILPWlVoNd0wvpMGtRrAzwPIeXpiSZ9z/F5sXMqCJ24ZtcIbNUoZxFZuR3mnwsUhQRYeUrzeCqIW+hpcC1vTr8odW+WebDxc8Han0KLa2L0RVIINbrhH+Xa5c+mOpeT+l0REi3P29t4PrIjK6EKPmpyQLTHPPr904Nrq2eqPPgAgmMXharL6BR0BKBzD7NQ5QN1PgLrzCyBoHPrFXcZq3fVrOZtmlurMaaWi8PYpLdzqCvzVqvt7KbBa5YPtkfsgwJVEMbuLBxP27tMXFT9l08DC04VhInfkSuvVzU/MlR+RAiemRwMfC7ktAbcuTQfvbih6K/PXcRgXGLdEsEDnQayqLh3oD0Adcwf4Xy1pPUYyoUCIdir+NerXRqg/RLUd+MPUZq+14JB9TYXcqX15NUohmBVTweVeuWorjA+5E32UzeTrOjA3VDYAX6XndBqPHSL1VSekFxDcmOI3G+FBRPIX7LsInjfkPhjaLQzfSnwGGwdjp0xpX499CpZyvKhNK5fgEfkHx+ukXB7oSI35g50C6f44g/b557+0Hf86G9I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB634048.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(38070700021)(261021123027099003)(5023799004)(11063799006)(4143699003)(261021135927099003)(56012099006)(261028144727099003)(261022075727099003)(261026140227099003)(261021121427099003)(261026121527099003)(261022105027099003)(10067099003)(22082099003)(18002099003)(261102123227099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnhWdUlWNEZqcjZnQ2xaSVc3M2tMQ05US1hxWlgzLzZXdlc0MHJ2YzBRdWt3?=
 =?utf-8?B?SFVVeWFtU09Bc00xa2VJUncvZDRibFJXNXRESE03OVlVZGczYVZUY0d4eTY5?=
 =?utf-8?B?THltdWlOS1FhUldvSFRxMTJKM1UrSHowV3NNUG83Y2t1T0ZpMUhDM3c2ZG1Z?=
 =?utf-8?B?ckxoQzBtL0NIOFF4VXZReHRJY1dUKzZQMHhVelVzZ2lEbGRJK2kxUHRHclox?=
 =?utf-8?B?TjRXNWUwS245cGFIMzhSd3FSeW10Rkxna1pvU1Y5b3I2cnk5MXZhUDBiNnVS?=
 =?utf-8?B?SlNYci96ZktWblFTY09kUUpKcmczMzQweTZjUTJNZGNBd1JLTFhaRjhhcG42?=
 =?utf-8?B?aW5VeGJ5Z3JDekp6L0pSNnRtVS9RK3ljUWVUckNEZGxhcHNKaytXdWJHdmcx?=
 =?utf-8?B?dnFnbjZKdkxpcUU0M2JydWRRTVdVUThKN2hIaWZIRUNjMWNCdU5yNkdCaWE5?=
 =?utf-8?B?VUJuNzliVXF3Uk15OGxsaDl1cTl3MWhmaGlmQXV6ZmxGaUpwSHpWZU84QTRM?=
 =?utf-8?B?emxjeEhmMWhNYjIwZGxpT01pbmZVbmdTaC91ZUpnSm5YNmJERHhkbTJMWGpy?=
 =?utf-8?B?U2cvQWsyeUJOM2M2NFE2NFlDalJBc0k5WEVEMmpFY0VTTEtBZzBIM0xBK3hJ?=
 =?utf-8?B?NzlBVTdGQXdsdy8xa1d0d1BCR1VnQ05uc1M4dmZRalprVDUwdWduYm1DMFBB?=
 =?utf-8?B?NlNjTXRDbm9PQU8rOEhOR0xkMVY3YUh2dittcXBiZG9telRjV1ZtVUUzdm9P?=
 =?utf-8?B?c0VCeVk4QW01QWt1Q3c5NTkyMlRTVG9qNXJmcmNuZElMVGlFdS9TQ3RiZDNx?=
 =?utf-8?B?dHU5VzFUZ1lFaExDNmRLRVRSZ0psc0xHRVlRQzhRVmRrOTBnQWgwSGRianp0?=
 =?utf-8?B?UVRIc1BGQm5hSiswTWxsZHRJdmMwUjVpZWlySUwrcFBvd1VKNVNxRklkQ0tY?=
 =?utf-8?B?anB6a1ZaTnJPNEFMK1RiK1EvVGJSMENtQ2dtZkJCeWlnU3hXaGhheGdmcHo2?=
 =?utf-8?B?QnExQmFHcUdVbkVFaWZqazRxelR4OHlLT1hoN3FHY3RPL293ZnBUZ0Z6RlIy?=
 =?utf-8?B?eFdTWitKMmxtdmVJQ001S3FhdGozVzBGM3M4eStWNHVWVDJDTll3T21lenNs?=
 =?utf-8?B?Y1p3OVQzSDRLSEVBTTVSTFVYUkdacGVDZVFzKytlSk5uTEp3c0VUc3VhOEhJ?=
 =?utf-8?B?SkNXYTE4VnFwb05mTHNsa1M0OWJvbWF4Vk5kQysxUXZYOExWNGpmS0JoMG5o?=
 =?utf-8?B?QkMyL0ZyQXE2aE0yTk0rc3RBUXhTMUhFbUljQW1zUDgvbHRRdFZjdVFuK05O?=
 =?utf-8?B?WXFMVzNLd0kwcHZDaCt4OVNUSGpsMEd3MEtjTTd6dEhycEZLa0xQWDdpeGRR?=
 =?utf-8?B?aWxkQVYzMkV5UTM5R0ZPY3VodmIzWGp5U01ia2QxakZGS3BvMzNXTHQycFI1?=
 =?utf-8?B?Mi8rYWZEQWJiSFh1ZTlaN1RhajdZV3E3MXdYMCtidUtTZmhWQTlJNytKemFo?=
 =?utf-8?B?VEJhU0lrSEwxNGJyL2I0aTRFMkNCcENLU3BXajlqVzdKUDBMZ0lmb3lvVi9i?=
 =?utf-8?B?c2R3dVhHeXU2ZzVObk5sMXY4bm5LcEpQdlBkNnRjZ0xuODg1OTVrS2I1N2ZY?=
 =?utf-8?B?TzhUZDg1Z3hkVWw4eW14UCtSNmNrWkJyODJKcEVqR1k3MnpLMmdNeElmeDBp?=
 =?utf-8?B?cUNmZm5KTmZSeDZiU2pNeXgzelM1ZTIxQ3dSaTdnVzZIdTJDcUhFblA5K092?=
 =?utf-8?B?WTRHbW0ySHlmMkRIWW52bVBwdUVCMk5ra3E3RGxDR0hoKzRNTVF5a3hVSG5M?=
 =?utf-8?B?SG5YQ0RBK1ZJUmVybGF2RnRyZDdnc1d4Uk4zMTB5MmdjUWlkREJRL2d0OEJl?=
 =?utf-8?B?Z2NERmhWNldMYVZpZGpiZVUrVTRVa2RMYi9JTGxIM3dVSjFQU3FOVS91aFpj?=
 =?utf-8?B?c1FMTmk0RzFyUlg5THpRS1BCNTljRWxJcTJHZWhXeWdFTlg2MFAxMXZpZkVh?=
 =?utf-8?B?elFXRFhmNFIvMDlhb2dWaTE0emN1WVB6cUpBejl3U21TdWVzSFp4MzhZeERU?=
 =?utf-8?B?TjMvb0Nnb0pKRXhwK0JPek9RZVJTcGVLY1ZBWEFzNStjd1RHbHc5M3B2emZ6?=
 =?utf-8?B?dVhaZDJkQk9qVnE4TFRPSDdSMHdYbllYWk16eGV6cmFFVlhNRHkzejBmanR5?=
 =?utf-8?B?TDkwL2czUk02UXlBbFltT3VOUUZKZjBhNkROUGo2b1A4NC8zNHh0OEc4OEZv?=
 =?utf-8?B?S0VCYktWbU9GdW5JZk5qTU9vWDJWRGxBbkkyeTBhbzRUdDJNeUhVZVZuTkw0?=
 =?utf-8?B?U2YxLzI0dUk1dEZ6VHk4NlpyUHhKU2VleHZtUWFpMU50SEdXZHk5eVRhaDFJ?=
 =?utf-8?Q?j90dfvA7HfXSrYl8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7661AADDFE62284CABBFF42378ED47CC@namprd11.prod.outlook.com>
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
X-Exchange-RoutingPolicyChecked: Q/7AO+dgslcN/3qa7aRa5pTKl8CboC1lMs9ClIqIgs5F5PSM47ZmZzcqcbsu18E8MEPsrsO7HHfkDyJBBhRVDEMWs++qYQSEhFVeRnMFcG2iczDP4sxxgt4FxfhsPo4lVBgj6iSZKaZ2SeMP/e2bUcbE1Js0NjpRCk5tLwbU0kOTXLp43Y+/Ln+qrSUpF2jh6e0G2rBem5jeZxIs+gsG2rtaIotkfBbXHraTzWO10rjeeWpazYpf7hO6BHukzADBhS+fwf5BU3HdFpz12yY0xBeJNfNFuAPDPqiYcHOCy8tOXLfK+Ni00DteHNrVBBYZ2Oy+lcOrsE0UneWlBJAn0Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB634048.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a920968c-5409-4965-24ef-08df3913dc77
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2026 19:02:37.5767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zRO2PfZvVMzSE+tdToTHqxV26K10bMqHLZxeyDQ5Ef9aF/uT2jsDzkqB/8IBzBpbaWIVitAoFUvTy+aAl7sicVQHsEN/LEUqB/cUpX+sU8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB719417
X-OriginatorOrg: intel.com

U29ycnkgZm9yIHRoZSBkZWxheWVkIHJlc3BvbnNlLi4uDQoNCk9uIEZyaSwgMjAyNi0xMC0yMyBh
dCAxOTowMCAtMDMwMCwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+IFllYSwgaXQncyBzdHJh
bmdlLg0KPiA+IA0KPiA+IFRoZSBpbml0aWFsIFREWCBhdHRlc3RhdGlvbiBuYXZpZ2F0ZWQgc29t
ZSBwbGF0Zm9ybSBsaW1pdGF0aW9ucy4gSXQgaW52b2x2ZWQNCj4gPiBhbiBTR1ggZW5jbGF2ZSBv
biB0aGUgaG9zdC4gVGhlIGVuY2xhdmUgd2FzIHRoZSB0aGluZyB0aGF0IGRpZCB0aGUgc2lnbmlu
ZywNCj4gPiBidXQgaXQgZGlkIG5vdCBoYXZlIGFueSBvZiB0aGUgVEQgZGV0YWlscy4gT25seSB0
aGUgVERYIG1vZHVsZSBkaWQuDQo+ID4gDQo+ID4gU28gdGhlIHByb2Nlc3MgdG8gZ2V0IGEgcXVv
dGUgc3RhcnRzIHdpdGggZ2V0dGluZyBhIG5vbmNlIGZyb20gdGhlIHJlbW90ZQ0KPiA+IGF0dGVz
dGVyLiBUaGVuIHRoZSBURFggbW9kdWxlIHRvb2sgdGhlIG5vbmNlIGFuZCBmb3JtZWQgaXQgaW50
byBhIE1BQ2VkDQo+ID4gInJlcG9ydCIgdGhhdCBpbmNsdWRlZCBhbGwgdGhlIFREIGRldGFpbHMg
aXQga25vd3MgYWJvdXQuIFRoZW4gdGhpcyByZXBvcnQNCj4gPiBpcyBzaHVmZmxlZCBvdXQgdG8g
aG9zdCB1c2Vyc3BhY2UsIHdoaWNoIGdpdmVzIGl0IHRvIHRoZSBlbmNsYXZlLiBUaGUNCj4gPiBl
bmNsYXZlIGp1c3QgY2hlY2tzIGl0IGFuZCBkb2VzIHRoZSBzaWduaW5nLiBUaGVuIHRoZSByZXN1
bHRpbmcgcXVvdGUgbWFrZXMNCj4gPiBpdHMgd2F5IGJhY2sgdG8gdGhlIGd1ZXN0Lg0KPiA+IA0K
PiA+IEluIHRoZSBuZXcgYXR0ZXN0YXRpb24sIHRoZSBzaWduaW5nIGhhcHBlbnMgdGhyb3VnaCB0
aGUgVERYIG1vZHVsZSBpbnN0ZWFkDQo+ID4gb2YgaW4gYW4gU0dYIGVuY2xhdmUuIFNpbmNlIHRo
ZSBtb2R1bGUgYWxyZWFkeSBoYXMgdGhlIFREIGRldGFpbHMsIGl0IGNhbg0KPiA+IGp1c3QgYWRk
IHRoZW0gaXRzZWxmIHRvIHRoZSBxdW90ZS4gU28gYWxsIGl0IG5lZWRzIGlzIHRoZSBub25jZS4g
Rm9yIGxlZ2FjeQ0KPiA+IHJlYXNvbnMgdGhlIG9yaWdpbmFsIFREIHJlcG9ydCBpcyBiZWluZyB1
c2VkIGZvciB0aGUgbm9uY2UgZGVsaXZlcnkgdG8gaG9zdA0KPiA+IHVzZXJzcGFjZS4gTmV3IFRE
IGRldGFpbHMgYXJlIG5vdCBnb2luZyB0byBiZSBpbiB0aGUgcmVwb3J0Lg0KPiANCj4gU291bmRz
IGxpa2Ugc3R1ZmYgdGhlIGtlcm5lbCBzaG91bGQgYmUgaGlkaW5nIHJpZ2h0PyBVc2Vyc3BhY2Ug
Z2l2ZXMgYQ0KPiBub25jZSBhbmQgZ2V0cyBiYWNrIGEgcmVwb3J0LCBpdCBkb2Vzbid0IGNhcmUg
YWJvdXQgdGhlc2UgZGV0YWlscz8NCg0KSXQgaXMgaGlkZGVuIGluIHRoZSBub3JtYWwgYXR0ZXN0
YXRpb24gZmxvdy4gSSdtIGFjdHVhbGx5IG5vdCBzdXJlIHdoYXQgdGhlDQppbnRlbnRpb24gd2Fz
IGZvciBleHBvc2luZyBpdCB0byB1c2Vyc3BhY2Ugb3JpZ2luYWxseS4gQnV0IGluIHByYWN0aWNl
LCBpdA0KZW5hYmxlcyB1c2Vyc3BhY2UgdG8gdXNlIHNvbWUgb3RoZXIgZ3Vlc3QtaG9zdCBjb21t
dW5pY2F0aW9uIGNoYW5uZWwgdG8gcmVhY2gNCnRoZSBlbmNsYXZlIG9uIHRoZSBob3N0LiBTbyBs
aWtlIHlvdSBjYW4gcnVuIGEgc3RhbmRhcmQgZGlzdHJvIGtlcm5lbCBidXQgaGF2ZQ0Kc29tZSBD
U1Agc3BlY2lmaWMgY2hhbm5lbCBmb3Igc29tZSByZWFzb24uDQoNCj4gDQo+IElmIHRoZXJlIGlz
IGEgdjEgYW5kIHYyIHJlcG9ydCBiZWNhdXNlIG9mIHRoaXMgdGhlbiBmaW5lLCB0aGV5IGNhbiBi
ZQ0KPiBsYWJlbGVkIHRoYXQgd2F5Lg0KDQpUaGVyZSBpcyBvbmx5IG9uZSAiVERYIHJlcG9ydCIg
YmVjYXVzZSBpdCdzIGxlZ2FjeSB0aGluZyBub3cuDQoNCj4gDQo+ID4gU28gSSdtIHN0aWxsIG5v
dCBmb2xsb3dpbmcgd2h5IHdlIHdvdWxkIHByb3ZpZGUgdGhlIFREIHJlcG9ydCB0aHJvdWdoIHRo
ZQ0KPiA+IHN0YW5kYXJkaXplZCBpbnRlcmZhY2UuIE1heWJlIHdlIGRvbid0IHdhbnQgaXQ/DQo+
IA0KPiBNeSBiaWdnZXN0IG1vdGl2YXRvciBpcyB0byBnZXQgdGhlIG1lYXN1cmVtZW50IHJlZ2lz
dGVyIHN0dWZmIGJyb3VnaHQNCj4gdG9nZXRoZXIgc28gd2UgY2FuIG11bHRpcGxleCBpdCBpbnRz
aWRlIHRoZSBrZXJuZWwuIEluIHRoYXQgd29ybGQgSQ0KPiB0aGluayBpdCBpcyBwcmV0dHkgaW1w
b3J0YW50IHRoYXQgdGhlIHNpZ25hdHVyZSBjb3ZlcmluZyB0aGUNCj4gbWVhc3VyZW1lbnRzIGJl
IGNsZWFybHkgYWZmaWxpYXRlZCB3aXRoIHRoZSBtZWFzdXJlbWVudCByZWdpc3RlcnMNCj4gdGhl
bXNlbHZlcyBzbyB0aGVyZSBpcyBzb21lIGhvcGUgb2YgdXNlcnNwYWNlIGZpZ3VyaW5nIGl0IGFs
bCBvdXQuDQo+IA0KPiBhdHRlc3RhdGlvbiBzdWJzeXN0ZW0gd2lsbCBkZXNjcmliZSBpdCBhcyBv
bmUgY29oZXJlbnQgd2hvbGUsIHlvdSBnZXQNCj4gYSBzaW5nbGUgVERYIC9kZXYvWFggdGhhdCBj
YW4gZG8gZXh0ZW5kIGFuZCBnZW5lcmF0ZSBhIHNpZ25lZCBxdW90ZSBvZg0KPiB0aG9zZSByZWdp
c3RlcnMgdG9nZXRoZXIuIFdpdGggdGhlIHNhbWUgaW50ZXJmYWNlIGFzIGV2ZXJ5IG90aGVyIFJP
VC4NCj4gDQo+IElNSE8gaXQgbWFrZXMgbm8gc2Vuc2UgdG8gcHVsbCBpbiBtZWFzdXJlbWVudCBy
ZWdpc3RlciBhbmQgbGVhdmUNCj4gYmVoaW5kIHRoZSBxdW90ZSBpbiBjb25maWdmcy4NCj4gDQo+
IEkgZ3JhbnQgeW91IHRoZXJlIHdpbGwgbm90IGJlIGEgaHVnZSBhbW91bnQgb2YgdmFsdWUgaW4g
bW92aW5nIHRoZQ0KPiBxdW90ZSBvdmVyIGJlc2lkZXMgdGhpcyBjb25zaXN0ZW5jeSBhbmQgZWFz
ZSBvZiB1c2UgZm9yIHVzZXJzcGFjZS4NCj4gDQo+IFRob3VnaCBJIGFtIHBsYW5uaW5nL2hvcGlu
ZyB0byBoYXZlIGEgc2FuZSBhZG1pbiB0b29sIGhlcmUgYXMgd2UgYWdyZWUNCj4gdG8gdGhpbmdz
LCBzbyBhZG1pbiBjYW4gZG8gbGlrZToNCj4gDQo+ICQgYXR0ZXN0IHJlcG9ydA0KPiDCoMKgIFRE
WCBSZXBvcnQ6DQo+IMKgwqDCoMKgIFh5eiANCj4gwqDCoMKgwqAgQWJjDQo+IMKgwqAgVFBNIFJl
cG9ydDoNCj4gwqDCoMKgwqAgMTI0DQo+IMKgwqDCoMKgIDQzNQ0KDQpIbW0uIFRQTSByZXBvcnQg
aXMgYSBzaWduZWQgdGhpbmcgcmlnaHQ/IEJ1dCAiVERYIHJlcG9ydCIgaXMgbm90LiBPciAiVERY
DQpyZXBvcnQiIGlzIHJlYWxseSB0aGUgVERYIHF1b3RlPw0KDQpZb3UgY2FuIGFsbW9zdCB0aGlu
ayBhYm91dCBURFggcmVwb3J0IGxpa2U6ICJURFggc3BlY2lmaWMgdGhpbmcgdGhhdCBpcyBpbnRl
bmRlZA0KdG8gYmUgcHJvY2Vzc2VkIGJ5IHRoZSBxdW90aW5nIGVuY2xhdmUgb3IgdGhlIFREWCBt
b2R1bGUgaXRzZWxmIi4NCg0KSSd2ZSBzZWVuIG1hbnkgcGVvcGxlIHRyeSB0byB3cmFwIHRoZWly
IGhlYWQgYXJvdW5kIHRoZSBURFggYXR0ZXN0YXRpb24gZGVzaWduDQphdCB0aGlzIHBvaW50LiBF
dmVyeWJvZHkgdGhpbmtzICJ0aGlzIGNhbid0IGFsbCBiZSBuZWVkZWQiIGFuZCB3ZSBzbG93bHkg
bmVlZCB0bw0KZ28gdGhyb3VnaCB0aGUgd2hvbGUgdGhpbmcuDQoNCkkgc3RpbGwgZG9uJ3Qgc2Vl
IHRoZSBuZWVkIHRvIGV4cG9zZSB0aGUgVERYIHJlcG9ydCAoVERYIGRlZmluaXRpb24gb2YgcmVw
b3J0KQ0KdGhyb3VnaCBhIGdlbmVyaWMgaW50ZXJmYWNlLiBBcmUgeW91IHRoaW5raW5nIGFib3V0
IGhhdmluZyBhbnkga2luZCBvZiBjb21tdW5pdHkNCmNhbGwgZm9yIFRTTT8gTWF5YmUgd2UgY291
bGQgd2FsayBwZW9wbGUgdGhyb3VnaCBURFggYXR0ZXN0YXRpb24uDQoNCj4gDQo+ID4gPiBTbyBm
cm9tIGEgVERYIHBlcnNwZWN0aXZlLCB3aGF0IHdvdWxkIHlvdSB3YW50IHRvIGhhdmUgYXMgbGFi
ZWxlZA0KPiA+ID4gYmxvYnMgZm9yIHRoaXMga2luZCBvZiBvcGVyYXRpb24sIG5vdyBhbmQgbGF0
ZXIgYW5kIG1heWJlIHNvbWVkYXkgd2l0aA0KPiA+ID4gRElDRT8NCj4gPiANCj4gPiBPbiB0aGUg
VERYIHNpZGUgd2Ugd291bGQgaGF2ZSB0byB3b3JrIHRocm91Z2ggaG93IHRvIGFzayBmb3IgYQ0K
PiA+IHNwZWNpZmljIHR5cGUgb2YgcXVvdGUuIEluIHRoZSBpbml0aWFsIHNldCB3ZSBoYXZlIHBs
YW5uZWQsIHRoZSBob3N0DQo+ID4gd2lsbCBkZWNpZGUuDQo+IA0KPiBUaGF0J3MgZmluZS4gQnJv
YWRseSB0aGUgImRlZmF1bHQiIHJlcG9ydCBmb3JtYXQgc2hvdWxkIGJlIHNldCBieSB0aGUNCj4g
Vk0ncyBpbnN0YW5jZSB0eXBlLCBlZyBkZWZpbmVkIGJ5IHRoZSBDU1AuIEl0IHNob3VsZCBub3Qg
Y2hhbmdlDQo+IGxhdW5jaCB0byBsYXVuY2ggb2YgdGhlIHNhbWUgVk0uDQoNCkluIHRoZSBhdHRl
c3RhdGlvbiBzcGFjZSwgaXQgc2VlbXMgdGhlcmUgYXJlIHBlb3BsZSB3aG8gd2FudCBtYW55IHNs
aWdodGx5DQpkaWZmZXJlbnQgdGhpbmdzLiBBbmQgaXQgaGFzIGJlZW4gZ2VuZXJhdGluZyBvcHRp
b24gY29tcGxleGl0eSBvbiB0b3Agb2YgdGhlIFREWA0KbGVnYWN5IGJhZ2dhZ2UuDQoNCj4gDQo+
IElmIHlvdSBhbHNvIHdhbnQgdG8gaGF2ZSBhIHdheSB0byBxdWVyeSBzcGVjaWZpYyB0eXBlcywg
bGlrZSBBTUQncw0KPiBndWlkIHRoaW5nLCB0aGVuIHRoYXQncyBmaW5lIHRvby4gQnV0IEkgdGhp
bmsgaW50ZWdyYXRpbmcgaW50byBzeXN0ZW1kDQo+IHJlcG9ydCBtaWdodCBiZSBhIGJpdCB0cmlj
a3kgc28gSSdtIG5vdCBzdXJlIGl0IGlzIGEgZ3JlYXQgaWRlYS4NCj4gDQo+IEluIGFsbCBjYXNl
cyB0aGUgZm9ybWF0IG9mIHRoZSByZXBvcnQgaXMgbGFibGVkLCBwYXNzZWQgdG8gdXNlcnNwYWNl
DQo+IGFuZCBnaXZlbiB0byB0aGUgdmVyaWZpZXIuIEkgc2VlIEludGVsIGFscmVhZHkgZGVmaW5l
ZCBESUNFIGZvcm1hdCBhcw0KPiAnbGFyZ2VyIHRoYW4gOGsnLsKgDQoNCkknbGwgaGF2ZSB0byBj
aGVjayAob3IgbWF5YmUgUGV0ZXIgY2FuIGNoaW1lIGluKSBpZiB0aGVyZSBpcyBzb21lIGVhc3kg
bGFiZWwgdG8NCmxvb2sgYXQuDQoNCj4gV2UnZCBwcm9iYWJseSB3YW50IHRvIGdpdmUgdGhhdCBh
IGRlZGljYXRlZCBsYWJlbCBpbg0KPiBDVExWIGxhbmQuDQoNCk5vdCBmb2xsb3dpbmcgd2hhdCB5
b3UgbWVhbiBleGFjdGx5LiBBIENUTFYgZm9ybWF0IHRoYXQgY29udGFpbnMgdGhlIHJlcG9ydD8g
T3INCmEgdXNlciBBQkkgd2F5IHRvIHJlcXVlc3QgYSBjZXJ0YWluIGZvcm1hdD8NCg0KPiANCj4g
VGh1cywgaWYgeW91IGJvb3QgaW5zdGFuY2UgdHlwZSBWMSB5b3UgYWx3YXlzIGdldCB0aGUgc2Ft
ZQ0KPiBzeXN0ZW1kLXJlcG9ydCBmb3JtYXQgYW5kIGEgc3RhYmxlIEFCSSB0aGVyZSBmb3IgeW91
ciB2ZXJpZmllci4gV2hlbg0KPiB5b3UgdXBncmFkZSB0byBpbnN0YW5jZSB0eXBlIFYyLCB0aGUg
cmVwb3J0IGZvcm1hdCBBQkkgY2FuIGNoYW5nZSBhbmQNCj4geW91IGhhdmUgdG8gaGF2ZSBhIFYy
IGF3YXJlIHZlcmlmaWVyIHRvIHByb2Nlc3MgaXQuIFNpbmNlIGV2ZXJ5dGhpbmcNCj4gaXMgbmlj
ZWx5IGxhYmVsZWQgdGhlIGVycm9yIHJlcG9ydGluZyBzaG91bGQgYmUgYmV0dGVyICd2ZXJpZmll
cg0KPiBmYWlsZWQgYmVjYXVzZSBJbnRlbCBESUNFIG5vdCBzdXBwb3J0JyBpcyB3YXkgYmV0dGVy
IHRoYW4gJ3NpZ25hdHVyZQ0KPiBmYWlsdXJlJy4NCj4gDQo+IE9uZSBvZiB0aGUgdGhpbmdzIEkn
bSBxdWl0ZSBhZGFtZW50IGFib3V0IG9uIHRoZSBkYXRhIGxhYmVsaW5nIGlzIHRoYXQNCj4gaWYg
c29tZXRoaW5nIHNlZXMgQmxvYiB0eXBlIEEgdGhlbiBpdCBzaG91bGQgYXQgbGVhc3QgYmUgYWJs
ZSB0bw0KPiB2ZXJpZnkgdGhlIHNpZ25hdHVyZS4gRnVydGhlciBmb3JtYXQgdmFyaWF0aW9uIHNo
b3VsZCBiZSBzZWxmDQo+IGRlc2NyaWJpbmcgZGF0YSB3aXRoaW4gdGhlIHNpZ25lZCBwYXlsb2Fk
LiBJZiBpdCBpcyBzbyBkaWZmZXJlbnQgdGhhdA0KPiB5b3UgY2FuJ3QgdmVyaWZ5IHRoZSBzaWdu
YXR1cmUgdGhlbiB5b3UgaGF2ZSB0byBnaXZlIGl0IGEgZGlmZmVyZW50DQo+IGxhYmVsIHRvby4N
Cg0KSSdsbCBtYWtlIHN1cmUgdGhpcyBtYWRlIGl0IGJhY2sgdG8gb3VyIGF0dGVzdGF0aW9uIHBl
b3BsZS4gKHByb2JhYmx5IHNvbWVvbmUNCmFscmVhZHkgcGlja2VkIGl0IHVwKQ0KDQo+IA0KPiA+
IERvIHdlIHRoaW5rIHRoZXJlIGNvdWxkIGV2ZXIgYmUgYSB1c2FnZSBmb3IgdGhlIGNvY28gZ3Vl
c3QgdG8NCj4gPiBwcm9jZXNzIHRoZSBxdW90ZSBpdHNlbGY/IElmIHRoZSBvbmx5IHVzZSBpcyBz
aHVmZmxpbmcgYSBibG9iIHRvIHRoZQ0KPiA+IHZlcmlmaWVyIHRoZW4gbWF5YmUgd2UgZG9uJ3Qg
bmVlZCB0aGlzIGVpdGhlci4NCj4gDQo+IFByb2JhYmx5IG5vdCwgYnV0IGlmIHlvdSB3YW50ZWQg
dG8sIHRoZW4gc2FtZSBwcm9jZXNzIGFwcGxpZXMgdGhlDQo+IHZlcmlmaWVyLCB5b3UgZ2V0IHRo
ZSBsYWJlbCBhbmQgdGhlIGJsb2JzIGFuZCB5b3UgZG8gdGhlIG1hdGguDQo+IA0KPiBOb25lIG9m
IHRoZXMgY29uY2VwdHMgYXJlIHJlYWxseSBjaGFuZ2luZyBmcm9tIGNvbmZpZ2ZzLXRzbS1yZXBv
cnQsIGl0DQo+IGlzIGp1c3Qgd3JhcHBlZCBpbnRvIENUTFYgaW5zdGVhZCBvZiB0aGUgY3JlYXRp
dmUgdXNlIG9mIGNvbmZpZ2ZzIHdpdGgNCj4gaG9wZWZ1bGx5IGEgYml0IG1vcmUgcm9idXN0bmVz
cyBvbiB0aGUgZGF0YSBsYWJlbGluZy4NCg0K
