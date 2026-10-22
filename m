Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792706857;
	b=JXji/+d8iPJjtd1NRRnAxnStdrkkdixkU/boOneGEVwLDTlnooddJCeITexR7KuREu4m
	 O3QzuVZhxP9viTsm53Q3wEpobIfeKfy349wzVy/B4zJxwWs6nAJk8C5PrU1b59GaZitWR
	 0NMXyEXEosCROjhvQdfEqoskW1brEvDzHOrFQ2KzWLSiiOyYvEluIdXFdxRneVSJZHTDp
	 GoJUEdWfen6PI9Nbjle4wD08LXFlIAZYTGTxDDs6sJdqkPicD/XKnPhnkWRi9KRwG+cBX
	 NmmiVNqfuhzuxNMzEHT2dB4zeUbeG0BUJyAHX13MyI0aeZAfkSrperdbJPmHOAE6UMQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792706857;
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
	bh=4aq+KGpX6u4xc5JoXZ3L2EW5gqu+1xLZEqfEIC4mzfY=;
	b=j673Mr0S52FFMpxjqiGsc5j3oVzWguNjHei0PzUaQkpijGOb1e/6BKl8M5UWQpMXCIyg
	 75ePUQyBtcmYlqaluDbDo5ouiHBih60fuPZsAfWfadxTa1KcvM5iimsqKACF1/1JE+Uw2
	 odMUilhexuwdt27pXegfODzEw6R16em0vvOMu1C0vGAQSV63rZ0UffEh25fS4Kl/0WDbT
	 gPLH5LxZCNRVJTtWJpQG9uKHSDRa8Eh77vO+Xrw1WyHcOJqJ/oKV3PpnmR6s2BikFR2Ma
	 jbujb3ms6zrvjId/tNjFMBD7BrtfHd3TRVUIlpUMTF9dt5uym9lxRIFC/OlgolyupAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=KfEXABUP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.19
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65D0606A31E;
	Thu, 22 Oct 2026 22:07:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A65D0606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=KfEXABUP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792706856; x=1824242856;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4aq+KGpX6u4xc5JoXZ3L2EW5gqu+1xLZEqfEIC4mzfY=;
  b=KfEXABUP/ILvR11sYrIeXZrakyeKW1dAzL2PHxg2mp74DTxYrrejFu8Y
   +FrtcZ7Se7FYSsu+3ZdD0gSSgZRga2iZpsQIHjYvxZc2hrftvsEM1Kbws
   Oa5nJK+vhMvzTh7qIOWzGrebHe4w44stno8VKFX3w2+zQ60omVoH1kkZ/
   /pkdJ5UIQZM6qeLJTwmHtMc2FK/EOjMyAstU1J9FMzwsfDyhZ8YN0qRek
   U/nbStZx7LqLXYVlAN1yPAb2A/l32MXZq6Gzb3D74N7WVcPhjy3Nh+XnV
   ptX6GuokC6LHfECfOALwGjd9ImQrc/72JQ69MbdDcaVnr8cVMEmHlEZoZ
   Q==;
X-CSE-ConnectionGUID: lE5fsFkFQ02re7WhS6JJAw==
X-CSE-MsgGUID: s79YEZ6XQyeiwUpUuQ8cNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11943"; a="1573808"
X-IronPort-AV: E=Sophos;i="6.27,173,1787036400"; 
   d="scan'208";a="1573808"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 15:07:35 -0700
X-CSE-ConnectionGUID: FdGdTim6Sbe+w7fuGJDgBg==
X-CSE-MsgGUID: rwI40LqkTDC1ELLc/WBZNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,173,1787036400"; 
   d="scan'208";a="3830247"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2026 15:07:35 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 15:07:34 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 22 Oct 2026 15:07:34 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.3) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 15:07:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SMLzeBw+zcr59Q/VjWSI+vjtZDGg0FMOJtD6L3Ys05JOCZmkX789jBUn9e1QKcm+BN90e4Xb4GhBAaXC2UOEuKY5LpUfoVSOTvntleXDuc4P0MixZCoOzehJijzJB532QoaP+VSzM77x1boq7SjxxE+BjITSMhLaxAlkwnmNwdO4amyQIcq5I+HcKjIvU1/1KUCskzue6XvjZv5opHI9rjPtRBYokvzUKjD2HrbvVbX/PHRQHwRct8/JpoA3/EJJbZxB7pLvK/1OURYsHB/7n5MjrhCFt3wU1+HE08oOW/O7/Rfq/PU4PBps39NocB3+w0SYrN/ZY22sv1b/J5zYWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4aq+KGpX6u4xc5JoXZ3L2EW5gqu+1xLZEqfEIC4mzfY=;
 b=DhrFdWSDHq7Mln5kFxpHvhydWmWTvirZCBuQxOhUpnT/KzAYzPOqCmcsy43kI2o/UzTybQxGxjqCOqQtZ3i4ikRQynxVQ4ved7cex3mvaLDMZlUNmwuR1hTxKY+J2+Mcsi8BtaKk75MQdZFt3IMs2DJMX9dBoj/Slrn1P11sjlfPB4FQlcsPDmSuWtQwHvWul7UqhgL0B5RPVe3IONxPvzsQh/s5zmokyi0XkVwRbTPX1Wqh900ofPpImoqcn2jvOfyY/gurVNs19I0nb//r/q25rB2f07y2FXt+XvrArhviR4iEW/RyCZsuHdddPtkHtx3ytvzcEgiVtAnbR2QVSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 (2603:10b6:208:549::23) by PH7PR11MB6907.namprd11.prod.outlook.com
 (2603:10b6:510:203::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 22:07:29 +0000
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57]) by IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 22:07:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "jiri@resnulli.us" <jiri@resnulli.us>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pgonda@google.com"
	<pgonda@google.com>, "jic23@kernel.org" <jic23@kernel.org>,
	"drdeeglaze@gmail.com" <drdeeglaze@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "Xing, Cedric" <cedric.xing@intel.com>,
	"alistair.francis@wdc.com" <alistair.francis@wdc.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Reshetova,
 Elena" <elena.reshetova@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "ankita@nvidia.com" <ankita@nvidia.com>,
	"jpiotrowski@nvidia.com" <jpiotrowski@nvidia.com>, "kas@kernel.org"
	<kas@kernel.org>, "Quigley, David" <david.quigley@intel.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Vivi, Rodrigo"
	<rodrigo.vivi@intel.com>, "lukas@wunner.de" <lukas@wunner.de>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "ksinyuk@kernel.org"
	<ksinyuk@kernel.org>, "Fang, Peter" <peter.fang@intel.com>, "sameo@meta.com"
	<sameo@meta.com>, "aik@amd.com" <aik@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"x86@kernel.org" <x86@kernel.org>, "qinkun@google.com" <qinkun@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Topic: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Thread-Index: AQHdXLTTjrGSfVTT6UCa8v4N/LvKxbcKKgoA
Date: Thu, 22 Oct 2026 22:07:28 +0000
Message-ID: <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	 <20261015145053.3664509-21-jiri@resnulli.us>
In-Reply-To: <20261015145053.3664509-21-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB634048:EE_|PH7PR11MB6907:EE_
x-ms-office365-filtering-correlation-id: 3e2c2515-29f3-4e33-50f8-08df3088dccf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|6133799003|22082099003|18002099003|3023799007|4143699003|11063799006|261021121427099003|10067099003|261022105027099003|56012099006|38070700021|261022075727099003;
x-microsoft-antispam-message-info: kz5Cki3CLPgcjM76ZNFCRhPWx/P5WR3J9PlTec/dxQQwLwXQAivRhqYNWGahHz8h+uYpZBPp6AW4GEZKuQxezlDk+mmbGJWXRcG3iVuVULpoUbsXwqcArH9MlRWMr0fS/mYhwPEaxel0kMop+EVYdiIWwKpdaLh4prURKwLhnMOzCE0xu2tCOYtXrTNCNR5lvttk/EGpnhVPBpArAXnpId38Gx/s1V8OJwY1y/1cqapxRa6Oz7FklFTk37XgHlAXzoybpaaHN0rxcuPqtZo6IHa3Qr6b1ppGtzG9fIsFXoH65jNDJhAIePva9hTl99ZLdf+CdLt8DL0PH+bjq8gP1WbAlgA5rZDsLyRSNfYDalUqCsrwg5nYgoIebRau80QSW7WLgWUa8WEKAAJvcWr//T7w3yQDaJ2Tc+YAV7LsR6s7ULu5/GyuO3V5ZNTibGAWC0epI5OM1QiixVDrO50xRqxQmN8pvIxY5AgS+zQIVF0Yrd5Vm41Y2d0WPcdMUPfoEDDB3fz9/Hvs9IKzO0FB/wglj+j5lU3NH+08ZhJH4Oc3RlaOPPhTHOgKKM7jFt7Rod5IiADASnhqXEagEa0qWCNQw7dzHo9GR02ZzQxgr9jIywFJ3vgq6rSLPtcx2rAKzQzok++E6MVD6k8qmd/52uXgqW5U3wRC8OL9ynsGqg6DgGPHVUTY/XW2rBSd9wG33KP+r53a48F+NgeD2DhxgSNXiVk18YKtImHOWecE28Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB634048.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(3023799007)(4143699003)(11063799006)(261021121427099003)(10067099003)(261022105027099003)(56012099006)(38070700021)(261022075727099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjdMUElGaktGSnN6S21HZVpKOGhLN0ZvL2wvS2diSERSK0NqTE9wUGZGSXc4?=
 =?utf-8?B?M081TnhhNnU1T3hQZ3dQUXRjOFZpV1k0VmFsb2hiRFBkYUtvQVBOb3ZJNGh1?=
 =?utf-8?B?QTd4YkdXVHRCY2k0VVlhb1M2NkxkVWRMRlBKQ3Q3bVY3ZEZCWDNhRTlVODhl?=
 =?utf-8?B?LzZycWFWd20wSC96aUQxb09MM3FTdmxQMGdLVkkwQVNTU0JnaFBsUEtuQVUr?=
 =?utf-8?B?NzJmV3pmN011dytVd3VLTVdNVU9YSHF5bkx2Y2E1UEhKYk5zVTBUNWF5ZlMx?=
 =?utf-8?B?b2FIUnQ4RGFCQWMwRXEyQlIxRHV1ZmZJcWZrS0prNG85bzMza080cEJVL2FG?=
 =?utf-8?B?VU9IUy9uNndqRmVtOVRWMzlPbi8zSmJDOUw0dVlEZi9VZE9Pb3NZcld6bXRh?=
 =?utf-8?B?Y0kxUW5kSXhCcUhLWG5lTzRpNDU4cmQ0bDVIbkJoSFJ1RlkrZ1dVVXpnOVdv?=
 =?utf-8?B?UU9EQWE4QjBNbjNOWWVpbFFrL0xWelNWbU41SUNtQUljNEN5ZVkrQnVraGlk?=
 =?utf-8?B?Z2NFZWwxK0NHZHJ5VExkOFduNEFpR2tIOFZ5R0ZDc3RDNzh1TW9HWG4xY0hZ?=
 =?utf-8?B?bktCZmQxWStaczBTRmdzVnFpSUlWSEwxenB1V1djWmhTUlVKcFhpUk5XSHdW?=
 =?utf-8?B?c25wSFA2dE9nM3F3aUxNbVZISUJQQnpzaHJhMjY1cEZxVU1JK3NhRFdvNzZI?=
 =?utf-8?B?bFZmdVh6MmhxbHZLY25XUnlLeGRON0VYekhkSjRuVmczNElpNi92NGk4MGxU?=
 =?utf-8?B?N0VDTUh5akJTWm04TlhSLzZ0NlhYb0dCUk9XOGNzSVRpUlE1Q05OelR3Z2ZG?=
 =?utf-8?B?M3FsVnFlSXhHUHNXd00xamtlQkR6Q2twd0x3QlVrVWF5SndPa21ZNlVrSHRi?=
 =?utf-8?B?ZVF1SXJjSWtLeGNSVXp3ZHo4SWtsUGZKWVR4b3J1Qm5LZDhNNHp4Vm51YkhV?=
 =?utf-8?B?cDdwcUJHSTJyQ1RUNTRCSUhLek54V2VnN01IS1BvQ25lUjRMc1p3Y2xscXNO?=
 =?utf-8?B?cVJSa0J4cng4UU5FbjM1NFZZRytBSy9zK3NiMDBZaVA0NFdPYUZGYml2OXlH?=
 =?utf-8?B?U2tnclhsT3crLzRuT0xHTGx0cDNKbWdUbEVKdHd6cmxzNnp4RGVDOS83eSto?=
 =?utf-8?B?VEI3cW5uUlFSaHR6dEYrSUxvWGJmd2JWMXRFUDhHay9JY3A4R2RFUjk4QXdI?=
 =?utf-8?B?ekwvdVVYL0lhUlNKUGd2YjZPeVdDbXVxdzVkR2lRemRmQ1pnNFIrWS9XZDBx?=
 =?utf-8?B?V2JLbmtjRnRVREtBeDkzaFlDK1ZpRzA2MXFxKzNyNEFreXZCRFhnVnVEclJl?=
 =?utf-8?B?SmlvOWJhaENsR2lrUFAyOWNlRGE4M2hsdWllZ2hxb0pKY0liYzVvc3pNajhZ?=
 =?utf-8?B?NmN2WlVWYjVpSzVuTldrL3BqeTRFbFNmLzBYZFdRRS9OZHVQWVRhYmxqLyti?=
 =?utf-8?B?cHJrVkpYSFFjU2UxZHJEVjFaakZ2d1E5MWlFZUNGQjV2QWJpdWduZXFKeUg4?=
 =?utf-8?B?TkJTQko4RlpIbzBINXVqMEFEdHc5VDlxeUhVTEp3SVUxN09tSUtySGY3VXFh?=
 =?utf-8?B?RFYrdGVkMWE4ZVFhdnlpZzhDSUJEYjEvWHl1VGdDY2RSRTFVMkJodjZjc0xt?=
 =?utf-8?B?NS96Ykp6YWkwdFlYZ3Zybnp0M21pZjg1YnRaQlhLREdrTzZHNDNmZTE4M0Zk?=
 =?utf-8?B?NlJUbHJHcHl1bERyR3Z3MUoyTk1haDFTMlNmTWZuYjk3czYwazBzYlgwVEww?=
 =?utf-8?B?R3N0Q0Z5RUREekhlZlN5eVVEcUh5WFhsV0xnaVdUWGhIWnhYNko3Q253N2c3?=
 =?utf-8?B?b2RnUElTWjNLNitlQU5NallhOGw5OW5RVC9XSjZueDdhTXc3ekhUSUw5VFFm?=
 =?utf-8?B?dmMweGpQcDkvY2dqK0FaVFNaS0UwbDhMY3VmZllQYUtHMnBFYTV0T0tWV0w1?=
 =?utf-8?B?WFB2TkZZb2o2d2JZbDVLUEJyaFk4RUl5M1MzWTZiQlVjeVU3clZHa3oxZ1dB?=
 =?utf-8?B?U3FsSm45STNlbFFaRVdxeWpHTmIxMkRRbjZERGEzTU9xUEN3QU5ieGtVS2tL?=
 =?utf-8?B?Yit1bk5iMjhPS0FsbEZLdFhOR3d6ZEpyMTd1cWlYMUNmMTNYMExpTFNIQVpY?=
 =?utf-8?B?Yks1NVFKdU1rdUpQQ3FqcEdWVDM4R0twc0ZjdzVNSjlSaHpLNGc0bnNqK2kr?=
 =?utf-8?B?em5VbTE0VXFEazdSMTh1MnhLZWdheE9VeVhzeitzemthakNFam43dCt3eGRE?=
 =?utf-8?B?MnlRUTNkdlhOY1pJYlZvNG1VOFh4SFUwVTJ0bjNIZVFCaS9IZTJJUytqQWkx?=
 =?utf-8?B?RFZBQlNRSVN4Z3F0dnNuTm9od0lsMlFTR2Y3NHMzaXE0UEVLQnpYd0trdzJQ?=
 =?utf-8?Q?BxsfEfLwj6NJvUwk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51DBDCB66E77154EA456A966DF8E20A8@namprd11.prod.outlook.com>
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
X-Exchange-RoutingPolicyChecked: X8M+MS4/skfxh41r4P8uwNps3zapBgA5vzigHZ78TurKKoXp1C/Ef3utxRhFAq26COiRBOE7swIYRIpyFJaL2FUR+SBidHo1Isg3W+DmiR34DgHFtvP8ICuQY3yA41AZX9HCvHqPfFQgONPxo8KfDsPS5Q1JeWMcAnnR13EGKF98VltgMfwwxQ81zKhZyT0R1c4luJiI2+NJDruqhV8dXkDcUwBps13vVqYOqbsw6Ye9DKOFdOzhtPSM7rYQDGCZzlWI3GBZGEhgGK7P1lej16+pUpzEk3xbw5J5n64YfX+Fp8oo0sn+LwAfUe0yV4dayHPesQav8Y+PJoqzLmwKYw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB634048.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e2c2515-29f3-4e33-50f8-08df3088dccf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 22:07:28.8141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1c2FDQ/xtY0oFwi2nQmjVDah/G90rPnrbR8n4xnCpSERhWb5wY3CKcIu4F/LgMrvjkphvjfmj0VLCHUTnDLH0cvbkcpM9Y14MkrD3upZlO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6907
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTEwLTE1IGF0IDE2OjUwICswMjAwLCBKaXJpIFBpcmtvIHdyb3RlOg0KPiBD
b25uZWN0IHRoZSBhdHRlc3RhdGlvbiBmYW1pbHkgdG8gdGhlIG5hdGl2ZSBURFggc2VydmljZS4g
RXhwb3NlDQo+IFREUkVQT1JULCBRdW90ZSwgTVJURCBhbmQgUlRNUiBvcGVyYXRpb25zIHdoaWxl
IHByZXNlcnZpbmcgdGhlIGV4aXN0aW5nDQo+IG5hdGl2ZSBpbnRlcmZhY2VzLg0KDQpBbG9uZyB0
aGUgbGluZXMgb2Ygc29tZSBvZiB0aGUgb3RoZXIgY29tbWVudGVycyBJJ20gbm90IGNsZWFyIG9u
IHRoZSBiZW5lZml0cyBvZg0KdGhlIHVuaWZpZWQgVEQvVk0gYXR0ZXN0YXRpb24gcGFydCBvZiB0
aGlzLg0KDQpFc3BlY2lhbGx5IHdoZW4geW91IHRhbGsgYWJvdXQgYSBURCByZXBvcnQsIGl0IGlz
IHByZXR0eSBzcGVjaWZpYyB0byBURFguIFNvDQpjYWxsaW5nIHVzZXIgY29kZSBpcyBnb2luZyB0
byBuZWVkIHRvIGtub3cgYWJvdXQgVERYIGFueXdheS4gSW4gZmFjdCB0aGUgcmVwb3J0DQp3b24n
dCBoYXZlIGFsbCB0aGUgZGV0YWlscyBvZiB0aGUgVEQgZWl0aGVyLiBHb2luZyBmb3J3YXJkIGl0
J3MgbWFpbiBmdW5jdGlvbiBpcw0KdG8gc2VydmUgYXMgYSBub25jZSB0cmFuc3BvcnQgYmxvYiBh
bmQgaXQgb25seSBoYXMgVEQgZGV0YWlscyBiZWNhdXNlIG9mIGxlZ2FjeQ0KY29uc3RyYWludHMg
YWJvdXQgU0dYIGJhc2VkIGF0dGVzdGF0aW9uLiBTbyBqdXN0IGEgcXVpcmt5IFREWCBzcGVjaWZp
YyBwYXJ0IG9mDQp0aGUgZmxvdyBvbiB0aGUgd2F5IHRvIGdldCBhIHF1b3RlLg0KDQpDYW4geW91
IGhlbHAgbWUgY29ubmVjdCB0aGUgZG90cyBvZiB3aHkgdGhlIHVuaWZpY2F0aW9uIGZvciB0aGUg
VEQvVk0NCmF0dGVzdGF0aW9uIGhlbHBzIHVzIGdldCB0byBhIHdpZGVyIGF0dGVzdGF0aW9uIHZp
c2lvbj8NCg0KDQpPbmUgaWRlYS4uLiBOb3Qgc3VyZSBvbiBpdC4gV2UgYXJlIGN1cnJlbnRseSB3
b3JraW5nIG9uIHN1cHBvcnQgZm9yIERJQ0UgYmFzZWQNCmF0dGVzdGF0aW9uIGZvciBURFguIFRo
aXMgaXMgYW4gaW5kdXN0cnkgc3RhbmRhcmQgYW5kIEFGQUlVIG90aGVyIHZlbmRvcnMgd2lsbA0K
KHdhbnQgdG8/KSBzdXBwb3J0IGl0IHRvby4gUGVyaGFwcyBpZiB3ZSBjb3VsZCBoYXZlIGEgc2lu
Z2xlIHdheSB0byBhc2sgZm9yIGZvcg0KRElDRSBiYXNlZCBxdW90ZSwgaXQgY291bGQgbWFrZSBh
IGNyb3NzIHZlbmRvciBpbnRlcmZhY2UgbW9yZSB1c2VmdWw/IENhbGxlcnMNCmNvdWxkIGp1c3Qg
Y2FsbCBhbmQgZ2V0IHNvbWUgc3RhbmRhcmQgZm9ybWF0IHRoZXkgY2FuIHVuZGVyc3RhbmQuIEl0
IG1pZ2h0IHRha2UNCnNvbWUgd29yayBvbiB0aGUgVERYIHNpZGUgdG8gZW5zdXJlIHRoZSBESUNF
IGZvcm1hdCBxdW90ZS4NCg0KUmVnYXJkaW5nIHRoZSBkZXZpY2UgYXR0ZXN0YXRpb24gcGFydCBv
ZiB0aGlzLCBEYXZlSiAoQ0NlZCkgaXMgZXhwbG9yaW5nIHRoaXMNCmN1cnJlbnRseSBhbmQgY2Fu
IHNoYXJlIHNvbWUgZmluZGluZ3MgaW4gYSBiaXQuDQo=
