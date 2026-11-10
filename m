Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794337089;
	b=zDA9oSn4JXeO6QatyZcmLLy0/NtWz14VYLrpIOO9w3AOFTf7Qqjawk/U3Z9Mx/pAEEYn
	 MCww8x4eL6pkrcE8nEnVKQG9ic0Z/RGuXTxnj5eV0OSxRJvVh0iOsAPcIRNorx65H6YFO
	 E+9czM8HJSNHCLFHZfrgqhXmZKWDa5AquJQi2gNXkSLKFOb6JOlJRxnRJODhEtF7d3aGc
	 W7QB51gUVKrF1laCuybN6iUHhncwHdO5didPYIxHyOG3J9XJlvvInTtri/5zQZkHZlzjq
	 Yb1IG0pGbqJEdGY4LL0z2Oc6OU87bCs+Pa8f4fZcvW9o52BXfXXO5bDDzKzEs4MkNzw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337089;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=3+N0HC2etuxeWKcguIHDqiFmlHt/SPdRQtJquMB/2U0=;
	b=L8wkNX7lzwGpKCIVCCkQFE9vOwApgwKbYu/v14JbPrC8cMXMWyEEG+VHbDh+jQUUfNOH
	 XzHzCoN0h0e/vyZl6IzQb3pohpj+CzPRhAQL0OKupx5UH512Sp1yJKgfMsmp1C3ZRq92v
	 23GjgU9mESumwKFheUCDikCnUk+VVGxrlP8IQINzvRMzWeP9GT2ZOG4/ADuzMw2HuL9PS
	 xxi/jyXkAD7SFy/Rn2e1SvYK8nAlv3ANutx/5TucFof/xhwZgda4ntCVCYc3p2bC1O+Pf
	 7pxkHQQBf9NKqvMCWjViOFxZXqeuXL+UtpqOwLNRbznJe6osYK0zfb8sQ6K41StgQBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cb+ZtpJw;
	arc=fail smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30D7606A321;
	Tue, 10 Nov 2026 18:58:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D30D7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cb+ZtpJw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794337089; x=1825873089;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GNwmD/SB1C0asLDpduwwnKMchLZk6IFyZQd0IGu+Uhk=;
  b=cb+ZtpJwEPVtIXSD13GG+vaaRis9skXdY2h6V/Kwy24s/BP6rdhyHmRF
   IrMezn+vxv4whB/UwYPnwadjAHFh+WlCDYdMaq8kKUY3uhpSD+sqWAEmH
   au7O8g2MVCw1AVdcx1s6o9d1ETTZ1UWsk1e1kcN/B20JGk6SbrcWVfxz3
   oYD1D7VAOvzBvMdH6wtXNu7B25I4Lrc2YFmOghgY0lNQg6Oq+Kn+bEsAe
   wqbnoJ8GqlrDiV0RI8BUx+qrVkx1m6wznoOF+Mts1zduvevM9u95wX34H
   P2/Z9Fqgka8LhlXGdEEbnvJiOb2epJywBTtYadG5E24lWFotv+fGxPT/P
   Q==;
X-CSE-ConnectionGUID: XviuhEObTD+vAnMyO2lrjw==
X-CSE-MsgGUID: qrPHY9RiQiaPZoz+45JNsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11962"; a="3123101"
X-IronPort-AV: E=Sophos;i="6.27,206,1787036400"; 
   d="scan'208";a="3123101"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 10:58:08 -0800
X-CSE-ConnectionGUID: P2YCmJhgSUi9SgZFQ0D9lw==
X-CSE-MsgGUID: pVGXRN3KRr2WTceFmYgM5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,206,1787036400"; 
   d="scan'208";a="8089874"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 10:58:07 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 10:58:06 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 10 Nov 2026 10:58:06 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.32) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 10:58:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=natCmjDMmWf7WooO782b33VyUN4uFHT2KgjDs7woTsYGb2h/xuHrco7XGwF7+Bs5PnBHma1yY5ehOfSJFZ4fV1+xL5GmNupuQ8eWwQnK45zrGLVOsZ3WXswaScjJWi/XvzMPBX4MV8Wx+Rm2QwP/gwrD3lzonBpOJGxRBhkXBwNQMtALnUkNzPMMtwtLQ6GWK1Sz1NL4MslVAlvoEkSLCetkWBXx8ewpaKumGk6Bl98qAqBTRgpslmiCrJP7hLcFHcBmzBc5e++Noy2JStUHI8raGMAUlZE8mqGrZQ4c9KJZJT7QpyALcDHXkwuMmtf82qx5IEHbxAmw3cwXuIlxxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+N0HC2etuxeWKcguIHDqiFmlHt/SPdRQtJquMB/2U0=;
 b=GTp0f3/KjRok4OZZ518FCpd5L5POhMmP1T8JNOnTqWiczITMzVcLt3Ci4vuPi7dyM/4U1qUAPcxnb1ogxMbQB/Agp6fusGpMfdr1dKceGEJ8lc2b9edS8+D9MgvhrfY47gZdJrWHxSSi7s+o9DNSVzKQG/q2MTC5nkBj0uwFp+5jw683VFwmWTpw6ysmrJSN6Hhj+aRYCEjKmFhGPFSCrlbrXnuZHd/wKlFXLV8bbv1+gJB4P/Zy2vovgbWuO/yDGSyMHK0X/1gHAYZreiZSLMHN02pq6kufq3feFQxu5csnjFsd4+waq9ybcuHJLYhnOvkF0LDoFGimHo0m419fow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB435924.namprd11.prod.outlook.com
 (2603:10b6:610:34a::8) by DSWPR11MB9872.namprd11.prod.outlook.com
 (2603:10b6:8:4e2::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 18:58:04 +0000
Received: from CH3PR11MB435924.namprd11.prod.outlook.com
 ([fe80::1696:c90e:60af:a0cd]) by CH3PR11MB435924.namprd11.prod.outlook.com
 ([fe80::1696:c90e:60af:a0cd%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 18:58:04 +0000
Date: Tue, 10 Nov 2026 10:58:00 -0800
From: Peter Fang <peter.fang@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "jgg@ziepe.ca" <jgg@ziepe.ca>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
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
 Rodrigo" <rodrigo.vivi@intel.com>, "jic23@kernel.org" <jic23@kernel.org>,
	"aik@amd.com" <aik@amd.com>, "sameo@meta.com" <sameo@meta.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "qinkun@google.com" <qinkun@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Message-ID: <avNpOJbGdgP0zl7q@intel.com>
References: <20261023220030.GM3977851@ziepe.ca>
 <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>
 <20261103005851.GH3889730@ziepe.ca>
 <au5LCE1jau0yDo5S@intel.com>
 <20261109171236.GP663069@ziepe.ca>
 <cbef9bda9241ffe98652172edb67fab3eb1c35ee.camel@intel.com>
 <20261109234252.GR663069@ziepe.ca>
 <4c75b369b68c98c5c35e296895b6935342dc7dc1.camel@intel.com>
 <20261110131114.GV663069@ziepe.ca>
 <3860f37059d4c8807fa588c9f03b3a18e9449cec.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3860f37059d4c8807fa588c9f03b3a18e9449cec.camel@intel.com>
X-ClientProxiedBy: SJ2P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5da::12) To CH3PR11MB435924.namprd11.prod.outlook.com
 (2603:10b6:610:34a::8)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB435924:EE_|DSWPR11MB9872:EE_
X-MS-Office365-Filtering-Correlation-Id: 8579cfd5-5488-4656-fcd9-08df3f5c8c9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|261009223027099003|10067099003|261028144727099003|261026121527099003|261026140227099003|261022075727099003|261022105027099003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: eQprS+O+XgwbQCOYL7fRvVLPfgls7ur8jbQ7HBJI1BizA4+ZBJTTZketNQWPj5b/oN0+airilHkJFcBZWwhi2+g2DEKUTN4+fV3kE86W2kDFazEXYvrcUhcnr+EwbiDU5+DAZbxnEl6uayin+sNFTn4jPJqbVX5jZwSZLbgDGTM2rRF+Ufv4p0MQb3EsX4KVloBK1e+8rmzzzMp+LM7vzHAZIDdIStBtBi9IZuvh4GBCTm2KGbOmowJMxDAqXCOsT8j10fbLR+ORmk/Q2CZy397JYZap73jTwTXt4NSaUiOKLJfNOxBmgBM7EZiH6bNbiiEPqWC4BAlKGPpUpvkyDlZjw67UevveZt6fASGUOof2AJ4uX+j5rK4B9R31gVMShHrEllIk3Ldr0qgNbVxymyNdrnhbYiEcY2TJFI0HTHXLB3NxkgnfMrJ2xD0DqoPwUaolBrp2h9+Tc7HscMb599jDPx86sau73YPFBIfRywE+GbVY+Ec+qJTK7L4ZegJeQy5SWkvKUftyoQXVnNts30txViENiXxbwQxb9Pb92UY6idyK0+4Yj+d7OL4nD4HeJG0+tRVUBq2rT4HNvSSOAwt3K7yQ+ZFY7lJHl7XqMbxtlptJjtTfRx9ywREx++wi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB435924.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(261009223027099003)(10067099003)(261028144727099003)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XKYZtSpeEVDJq1pG3ovaTpkQaOpGRzS2L5Bi43HmnE6EJnjlk3jMgeDa/hXK?=
 =?us-ascii?Q?94zET4OvBWUMEYErbAHWOasEc6ESacUgwBFiRkmVUuCiMr4Zoh65YtST8hdT?=
 =?us-ascii?Q?6E/DNO0j/1ImWRR01Hc01isdnHJxeqNK+r/R+HBYKLH6c+OPctFet5YOucEw?=
 =?us-ascii?Q?GqAquZKHwHjOpO76hQ3ILZdrEXvio1MzZix8M4IzVnLv/2u2ig1n5oPa0156?=
 =?us-ascii?Q?JZ/8ACYP0oTxDsHW04zIetChQsjADEhIeSZdwEy1S2K9bUlvO4iY/4LsQaQy?=
 =?us-ascii?Q?3WYvgV9kfWaoC/cF8fP+7EmmCLxkA1B5CBwr+XEgZt+hYphkGvhA1ItIG7j6?=
 =?us-ascii?Q?txYDOf2kWM9UpiO3afGqAdHtCpR60IU1mcEGHiMXgpJ1Rxfia8s7ybffcBR7?=
 =?us-ascii?Q?uTlBnFJOWFQdY0ti2+vi53On7TsvwmOTzy68BZCmJRKHl4raXV4c4HI3BVJl?=
 =?us-ascii?Q?Ad690RGqY3jJTIoNCsnWzK+klcoF4v70qiWBZ2UcaWPzxm94bTbdUbfCAjbm?=
 =?us-ascii?Q?L0cgk8Q106lOF31Wbcv6+wo45u2dJfnAZHODNYO7etQHuVRBUHexyNvRKGXS?=
 =?us-ascii?Q?Cnrlpzm4VtmIYRb5LuTDsCrmV+G1AXvA9prFiPWvc91QciGkjMudtdOehAsI?=
 =?us-ascii?Q?mUhUJ4hWmpZAPDqZWksBKUDFcCruQCipRB2Tx4M7MXBvX6kCIgRx9sZkNrlg?=
 =?us-ascii?Q?5iePQu93mPqUnBbydw3H1kAKf4vHp6tiO/s5irYgz0vPKq2oXGCOEZTcZnsa?=
 =?us-ascii?Q?ClZ7w2HE5vJigZIqZnpylcoyHaktq9gu8ZV3GVmicCdByD4aff7kry43URpY?=
 =?us-ascii?Q?s06YJfDvwlZ65oJI7IAro+uqfndkLKFBq0ivOXy1lJEuSHhTjPlOkBK4mOQG?=
 =?us-ascii?Q?7YzmUsJaLfni5cdJjeJNgbAANEffvTGrKa/zaM3SoEY8aVdQbmNs2NV7BpRS?=
 =?us-ascii?Q?m86BcurrAG9Eurtbnlt0Twnq67yqhQ6kdjlmf6dhBjH2jr0s/nMXBr2VWH/U?=
 =?us-ascii?Q?6YkGWx70xIBX2ivFcZ9dRCMEbKAqlqEAhhnPy+NjDArQ315mgqTYxBa6u6K8?=
 =?us-ascii?Q?bflkwtNiSraOzohCZDzoXFE8ibCMxwOxgJMX/4kGdA01mmgz45dknkUOdx8B?=
 =?us-ascii?Q?T8AYZiIUN+2/FqoQBhOPc0YBVWtHQ6Mocr2TXrfYALG+BWakTXd6+A6lOgGz?=
 =?us-ascii?Q?35KaPFjzsUbQ6AEB5ZotWAg3reBH2c0XO/59Unop8cwIQTB7tBh3FKvHBeO5?=
 =?us-ascii?Q?LaOqnORkyWt8TmWmPvbvu3GtMNjEaBPFSJ+siKW4c4i7QyyNOj4SIVw5scl4?=
 =?us-ascii?Q?c14RTN7PVoUNH+FBNnEpyC3LM8gbCu6gZS02VhH2imlrhTjVKB/y3QSy/Udk?=
 =?us-ascii?Q?lHjkQm8Ck97yt9dOQz1nGQ93Hy5U4XQexLWTeBM9JYGrE/Ar46pQpharz7cW?=
 =?us-ascii?Q?6qFTHP0DWvQxfeZg7vrTKxNdngBSZ9enWyH6SfF/pLoro7n8tpDHTAnrsI04?=
 =?us-ascii?Q?L/A434muQ0vsdiup+sJC8M1685k4Nzwn8MT1UYrDZkP3u/slfMs9Svm9KeKU?=
 =?us-ascii?Q?rpQqV0U0O2ye3Zthq2ryE1ssH0y5D4nqTv3BNmJqsRWkQNJcfy7D++gkVC9M?=
 =?us-ascii?Q?bWGTsvJPh7UCPRhe0vZ40wJGFWTE8E8fKic3tICwzeoM9DomuvljdgRig8tF?=
 =?us-ascii?Q?RvvMqa4qsG380ZMoG5WYtnkinwi/ElLmH5J1eHrETocHZPUrocsWhaLo1Tum?=
 =?us-ascii?Q?UNA+1IFP5A=3D=3D?=
X-Exchange-RoutingPolicyChecked: IuGVRQYGFY3qhdY0xQZp+qbMjTDIBzm+ccPHNXWcSVdk8If/pfj5164OfNjEj2YXy7XvecRfovagBpDdQiIkLSNOMRWHYSqxPObkdOUw5UhiUftbkFn1b/cTab5wFJ2VooLkXhBhUurg3P+7BleDRtXV5qtr58UsINKalAEp2ZcA9gLRShK0md/NFoc6uBSv3W2n54KmvuQBXNj4uZaquFvbBupC7wLaCdIu0R3MUAcL7pYLqpc/gXqKxcebGXZVTqCXQTPumPAHeEV7hpeMuG2NPyA90fJ97Fj0dp/B9V+I+ezGGfQZQFoIsxWZtHmNRwyflom1zxJHX3pU5Phdrg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8579cfd5-5488-4656-fcd9-08df3f5c8c9a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB435924.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:58:03.9535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z2HqEd09GEGCjANktA8iImMOOP7vCGuTA4dsGIZonO3ylZO13b3wBe3CGrN5ki6za8LYfoVZ/kxpZSU+EXV3AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR11MB9872
X-OriginatorOrg: intel.com

On Tue, Nov 10, 2026 at 10:01:53AM -0800, Edgecombe, Rick P wrote:
> > 
> > But it sounds like your library can somehow parse the blob and figure
> > it out, so maybe it is just a matter of describing how that works.
> 
> The SGX format is documented.
> https://download.01.org/intel-sgx/latest/dcap-latest/linux/docs/Intel_TDX_DCAP_Quoting_Library_API.pdf
> 
> How the TDX features are applied to the DICE format is documented too IIRC, but
> I'm not finding it immediately.

It has not been published yet. I heard it just underwent a pretty
significant overhaul due to some customer requirements. So it's still
evolving quickly. I'll circle back and give an update when something's
available.

> 
> 
