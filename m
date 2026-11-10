Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794334580;
	b=IngtE1dffc50/ijRVo8O/5AWUdVxoZmDY6oiifqY0oQQYBEWtq2ASQ/Edx6kr5nakOxt
	 3llecW1n2G3C7HfEQ/uCfN0yPulHG8le+57m8O0y9UrLbogg41DRV4yI5iYzHb3lGgxBp
	 Yu3JaBrqb7eZhDbR/X0s+FjeTDPoKJoYW7peQ23IUU3xu9CbjgDAMNQF0nHwb89ZHkfUL
	 tBglC215sEybpyfRr2xw3AON7LJyggFLePnu3f73L596aJqtZI9HkN4rDCyVhQR8P5RI+
	 XwIPoI2ArRMIXbPFFysZ+UH+TP4bCZag41mxd8tSv6EUix07K/A/zoJeiomFzhJF6Hw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794334580;
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
	bh=EN1yBndk1f/Ef6cYRk9OLoKUm69REozQt6OoajBczus=;
	b=K1z/nLlL0QNr+GM0zbnxmDNyJn58Rbdr7m6Y7n0xAHvZPKi94H7qh1dsKRjWON+R1uVA
	 lwngc/VTfdGi4kb/Nid/D9NM/nMxu6bdfRdSk9Ce46My5vzlO4GniFxm+3eHfUrNSLD6V
	 NkEsRiUgwjnZmvPktC1/6STYH5OfEiJgCcoCJSXGfqBbwbj/HzGS6q/khaP2k601QdRhd
	 k6N9WBONSQiGMu03plk4Tsul1/FGqFxRVNQtZO3WgS+HnaBTrfrOEcBncKCUdxzW/Qoz7
	 OOAs+EbKOnzXIHEz0c+EKw1v2Qn2FmX2X1D8fUhdNqQflxwjfS1u6E/5/lwOTT3TD4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PI3H30J+;
	arc=fail smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D93B606A320;
	Tue, 10 Nov 2026 18:16:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D93B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PI3H30J+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794334580; x=1825870580;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eApH6Si2QnbgzwxyoN09WeawJ+hlrgsKI30tTHL5zEE=;
  b=PI3H30J+VMIhpUiLzfjC06xTaOdwQ85SEocWWZiHLon4ZFq/v6gETZp1
   Odn8MRSZWPYpfOit0HtrYHc3WBTaWsrAqzPGkfCRvn5iN4Xu0k5u7iEtQ
   5zs/i/WlG5eELoac0BrAH3KVkpTM1EZK5nAlETk26lzPXGI5Ktyfs7jUs
   pdqoZGmnhEDHgtxLB8of0WHbeQunJFycUm68AHldF0CBpwfknz/uQdwu8
   VNjhd6iVNOpWDgUvYdJuZdTVJBdj9pP/Z6Kne58nznq6l1CvIe1q2oIDe
   Qj26LzrFbdGBcDY+lEWbIeQKv1usNMPqmkS/v5cNnTwU7t9HxOMrrp27q
   g==;
X-CSE-ConnectionGUID: 51zp53XwRsK3MQk1m4WlKg==
X-CSE-MsgGUID: TQeWzoRKQmmpPXAGo3B7Hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11962"; a="3132961"
X-IronPort-AV: E=Sophos;i="6.27,206,1787036400"; 
   d="scan'208";a="3132961"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 10:16:19 -0800
X-CSE-ConnectionGUID: txTpw4aFQJOFO+rgV7NTYQ==
X-CSE-MsgGUID: 9fdFVEaDQTWX862oV7P+PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,206,1787036400"; 
   d="scan'208";a="10002390"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 10:16:18 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 10:16:17 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 10 Nov 2026 10:16:17 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.30) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 10 Nov 2026 10:16:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vT/8X/TiP9QvZykDr3WnhYgLBlhWlR4JXem+gxCgejq9+GbSCtEhFRnA/ucc8eHcyRaPZeTNjcnZmqQMVxIOBd1i5Gi8GOSd7uk+WXLhIuXEDIe6g9r1+ei6JGhxRwG4/VQAJAmnscy4hRrPuQAmvelR9jioGImsT04qzvGe1c0npa2wR/v1xFkMLY77+lYSTXbQjDtFwTlYmJYuW5ALP7YHm85sX6TqpDt8coSvAUSHZWTmxW41QrRbcoQEiiY1TF3iqz+2Gnn2kn9e+3tSj3/LYcTbsTlIXO6tOk+1NK5D6NWioWZwP++gobGL/X2Ppr5WaKFN/EKzDoQm+mVHCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EN1yBndk1f/Ef6cYRk9OLoKUm69REozQt6OoajBczus=;
 b=DuzWDkZIZUrdczoTYOe6L2gW6QKVjC4hK3je3j/k3d9gAWqOF9VOhURO8V98u+LoJp6Dxa2scNzRiGuhKdNu9ejNzfX5m5VNJoyiuHVnwzQg2teIV8uyYPwv2zTeEB7z4bAKam34owa5H0ROALJTyn6jDdb24BdxUHUqxv/QTdKllHIz3mkOuLlp8aanXVwQ0V+e02Cw0Us0GNN+/G4Jb/i3yA5EmtJhYwiS9j6yFkt3jC2pYXGgjbEYP+CrUopco33QIQYAdHi554xcSXvIGfKVn19SiyAPLmq+CeECObJoC1lfL/p2uytoOEL1z2D61RJNRoueXm+ZozWcR8Y+wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB435924.namprd11.prod.outlook.com
 (2603:10b6:610:34a::8) by IA3PR11MB9227.namprd11.prod.outlook.com
 (2603:10b6:208:575::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Tue, 10 Nov
 2026 18:16:14 +0000
Received: from CH3PR11MB435924.namprd11.prod.outlook.com
 ([fe80::1696:c90e:60af:a0cd]) by CH3PR11MB435924.namprd11.prod.outlook.com
 ([fe80::1696:c90e:60af:a0cd%6]) with mapi id 15.21.0615.007; Tue, 10 Nov 2026
 18:16:14 +0000
Date: Tue, 10 Nov 2026 10:16:07 -0800
From: Peter Fang <peter.fang@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
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
 Rodrigo" <rodrigo.vivi@intel.com>, "jic23@kernel.org" <jic23@kernel.org>,
	"ksinyuk@kernel.org" <ksinyuk@kernel.org>, "sameo@meta.com" <sameo@meta.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "qinkun@google.com"
	<qinkun@google.com>, "pgonda@google.com" <pgonda@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Message-ID: <avNfZ0lLl-OrkCHs@intel.com>
References: <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>
 <20261023220030.GM3977851@ziepe.ca>
 <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>
 <20261103005851.GH3889730@ziepe.ca>
 <au5LCE1jau0yDo5S@intel.com>
 <20261109171236.GP663069@ziepe.ca>
 <cbef9bda9241ffe98652172edb67fab3eb1c35ee.camel@intel.com>
 <20261109234252.GR663069@ziepe.ca>
 <4c75b369b68c98c5c35e296895b6935342dc7dc1.camel@intel.com>
 <20261110131114.GV663069@ziepe.ca>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261110131114.GV663069@ziepe.ca>
X-ClientProxiedBy: SJ0PR05CA0137.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::22) To CH3PR11MB435924.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CH3PR11MB435924:EE_|IA3PR11MB9227:EE_
X-MS-Office365-Filtering-Correlation-Id: a16b99d5-759e-414a-248b-08df3f56b49e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|56012099006|5023799004|261021123027099003|261009223027099003|11063799006|4143699003|261021130227099003|261021121427099003|261022105027099003|261022113327099003|261026140227099003|261026121527099003|261022115727099003|261022075727099003|261102123227099003|261028144727099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: HuZdwyllx2dJHWg8SyuX1m8x6LUD6qBZulCzTGaZZcntSQ49rQF7J54/iZHosJ4tQ0P9N3Ofh30QSERVuQ4h+3KymQwZEEH8MgIWbAdGGfGcygwo0nUK3+mUJN/WP97wgXA4huFaVQ4I4pi3nGwHunVpMFpuDGa7Ym3zFCilG3DFUGzp4bG77N6K3e8iP0HxFXpLtymzYYuoAnOOQm0K7X0AI4aeywsIwPI0LYrp8bGhjshp/eSjcsCHgVMVwzJ+wF869VXYHeNVC2yv1iwAWn1hVLTbCMupxgNNHwlLgtvshMrIOwHcVrGDE5OFlKOUuN89imRcAtPBMj3XEBrXIKWvjjV2FdSePrX9mOQq1DXrlZwDc89+zRAzVbPcLp72ErMSzjZS2DrGZDU0lI7dTwtbEUtiqhCnMZOzg23RgEI8UfNKJVAerTAHA5YxnrZEq8OdCRjS6dovbVhscwG5wiXNuivab2r9gJLTbCrExJtYh7rCaSq2S86LOvjBBAnFfa+U0WLwdK1i6heISFvEzD7Fm+Cgn7pnqRkVW7qBuqA+Foz9yxas6Bu5NMJu4pEf1ygbCqzLlGNjCWSiLa4UxuV9K0DTku7RxIh7KXTMiMovqjiQtoEKa97O0iRgLXKu25ceEGqknIW/+gd8irBWy0r9ztlddLyvuxoXWL5CdAw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB435924.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(56012099006)(5023799004)(261021123027099003)(261009223027099003)(11063799006)(4143699003)(261021130227099003)(261021121427099003)(261022105027099003)(261022113327099003)(261026140227099003)(261026121527099003)(261022115727099003)(261022075727099003)(261102123227099003)(261028144727099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lI39cfD1nOB/S0PSmvG3gz0oFYiGJcC88RCTRwigb/pzQky+NIn4GsgbE/IT?=
 =?us-ascii?Q?LiK26tG4isTM7fOBznDOz3U4e+p89a8eahYZNeirVWOd017Gi9PFxSJD/JUJ?=
 =?us-ascii?Q?hHwW/hoIRnS9KG8GdvKmyVzbUVs6CdpxEk6clfKnrH6p0Vz0cKQHNtjhQ+ab?=
 =?us-ascii?Q?X1wzAxmd+/wr3tbJg/U+IRdFhMETWzFPKuHdY6hNXPTJyWcTe61vtY7v1ONK?=
 =?us-ascii?Q?hc2mZkVVcynAlWcGDrmbsKqyGTQVNi0jcACnNBep27nn1Aa62GpAJHQ56Er5?=
 =?us-ascii?Q?8JipD4qJCXbhb4uyeiBgwvEnHcPOaRPsuyNuFl7iSgLnoFj7ikYy/y0cX7s9?=
 =?us-ascii?Q?aXQjM37b85N24Ve37O2OSFDTMKUw/YzqKB1Mexy+anxvPxBjSWu9y4Yw0xu5?=
 =?us-ascii?Q?ygGApNRK256hz8u5DD5RqxVus5jWXijveEoAcG13pRgus76FqQZWLQH4H3Od?=
 =?us-ascii?Q?SR1bwknQ8qR65tTn+UR23clIPLL3cfnyZ+9Z1O9K3K1wqYbcJQowr5TM9wPT?=
 =?us-ascii?Q?X6ugYc01J1aBLDwZ51YrIHlnzdjbm5tPVr1NZSddSvuB2O7UDwLZkc/L7v48?=
 =?us-ascii?Q?YSKmsrnbxWrW55cYCED12Sr1n0f2awxgvmfr3A8ZYxaIcjKasT+EP1gRR5+r?=
 =?us-ascii?Q?lROhwd5fDGYR2sETJOxYJxa4H4IA8cEtXYVCh+dzdoYMs9e3/6NyKGHciJF4?=
 =?us-ascii?Q?JOYBeOt0iOjyc7iETdQ9j6M8nMwVEIn5FCN2jF99HSIXDajmTyClypkOhEcw?=
 =?us-ascii?Q?HdTmDJG/id64snr63WAU5ctWEQkwvunIL98KWwK9oXHVFCb2teLU+NtbTb5H?=
 =?us-ascii?Q?UpEjvUwVEG8dxaEVSFZPZo/AgIXTLuRCcHC70Gl7LSFM2sw1HgwOQ8+rV0x+?=
 =?us-ascii?Q?ca4B0BleZ0meRB/Ma6L1pSdeuD6QiweQcE6wLcHeasxDdTInlOpjyV7/onFf?=
 =?us-ascii?Q?U6H48qYH0+JLT6Jy7YDhk5/ApkjZPfdhFf8M691h+yN8ILmissZmIkiYYwiG?=
 =?us-ascii?Q?qfMG6tPPNhIUb2/w+kiT7lp14d2klaXGuy5B9/rCzY6DrQ3qOzoWpS1W07WO?=
 =?us-ascii?Q?PcfciLiiqyCDGDdObvzJuLW7bgQ5jVnEul9T3hHL+65YOXyQyMfNV0iw2SXD?=
 =?us-ascii?Q?KTOxQ8mDmMA7bDmOF5Y249286G08GBkq0VUWJtU6njwRj2IJB+vLnLy87WkK?=
 =?us-ascii?Q?MlCiXAXEvO6WRbww4tFkgZ3BVvAl7FhDPrV28LzTuohJssm8bhOt/UbFUi1g?=
 =?us-ascii?Q?XjouXFT/wYYFDdii06MU6cs4FUo6wACYZMqrRbiyt0PFJ3PzBdmgWZNfr9EN?=
 =?us-ascii?Q?ZJWKABb+YhWrKhh0swhreqXtojxIPu8mzLoNciwWWPM4y0eArKvhDtdJU3bT?=
 =?us-ascii?Q?pdQf9YSg/B7zgnxEM4uHvKc43sI6ypGMAyPWbxYZ880RMk0Br1ArxJ7PhiU7?=
 =?us-ascii?Q?afAMrj5bAjasAT7WM9OAguCHE1cubHsA+u//oioStIlIyiLL7lIq0LnB6R+M?=
 =?us-ascii?Q?L/qyNCYdv9jat7ZGivZqmo0FVfLw4ZzPnnw1RuEnIMQQiuCjPVnx8kQGOXpK?=
 =?us-ascii?Q?FFBZhjEYD5c+iBSOAR8WIvJBTnOq40FrZn6QiI2C4Eywq4pGQ0sYN+fpNghI?=
 =?us-ascii?Q?s6cGvoxxWusQp6yFLGaP/ZfC/FDG1x8PwAsNIjv7hok4ygX7dyRjmu3Y9zlj?=
 =?us-ascii?Q?DW0gjqqESftP5ofoZY25tpYTzsPtgO4acx3NtdH2SOqOoykm7xEnrJmvQSL5?=
 =?us-ascii?Q?+xzx398s+w=3D=3D?=
X-Exchange-RoutingPolicyChecked: lM6eJhLFM8lWhTFrVaAZWlaCdWf8Xjhj6vUgUCi8WsQdG4YMeHr0kQNSCAuLTRmq2GONsWmwP4VUmdVIvgkT/f2o7NY0WZN6GtCyRz90EhhsWQmOrGha/8ZXFa+dREXcyqQV+NbWEnpzK+GoVyF1MyquH++iVg3Kjs26YHvr5VMrmDA8Q7XPpNpaKflSzN3F0/Mn+qWSj4arqm3Mq4pCvocjsarFPyro2rd4xhehDgYkNZYgSLU79jQziJec6UMaSF1doxnr6ZgoyQcM80qm/dgW04thJU6JRjKOtDxAc8BgIFUmsfHwtohMam8llekvRDc10nNJW9yn7BinTFyGiQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: a16b99d5-759e-414a-248b-08df3f56b49e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB435924.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:16:14.0900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZkCmcdoib+GWICXnVI5BHaovpuwkLaC6ka39i+9v+2i6ldv4hmrHFHsn399chPV+FI6vgL9mLdBNeVZQiQW8+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9227
X-OriginatorOrg: intel.com

On Tue, Nov 10, 2026 at 09:11:14AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 10, 2026 at 01:30:16AM +0000, Edgecombe, Rick P wrote:
> > On Mon, 2026-11-09 at 19:42 -0400, Jason Gunthorpe wrote:
> > > > So we have this SGX based quote format that is fixed because it already
> > > > exists
> > > > in the wild. Going forward we are moving to DICE, but that is a standard
> > > > format.
> > > > So also somewhat fixed. I guess the question is: is there some combo of bits
> > > > in
> > > > each blob we could check that could deterministically distinguish between
> > > > the
> > > > two? To do this we would need to analyze the quote formats.

Yes the first few bytes of the quote are a tell. The SGX quotes start
with a fixed header (04 00 02 00 or 05 00 02 00). The DICE quotes are
CBOR Web Token based and start with the CBOR magic bytes (d9 d9 f7).

> > > 
> > > You guys really didn't make it discoverable when you added DICE? :( :(
> > 
> > Like influence the DICE spec to interop with legacy SGX based attestation? I'm
> > out of my depth to try to say how possible that is.
> 
> No, I mean just have the SGX firmware tell the OS if it produced a
> DICE or legacy blob :(

The way the TDX guest gets a quote is it calls out to the host, goes to
host userspace (through KVM), and then typically userspace VMM decides
how to generate the quote. Right now it only generates it through a
userspace SGX enclave, but with DICE it can also get a quote from the
TDX module. All of this is a roundabout way to say that the current
design keeps the quote an opaque blob until it reaches the remote
verifier. I think the host can give the guest this kind of knowledge.
The infrastructure just doesn't exist yet.

> 
> > I'm also under the impression that the quote was not designed for local
> > processing in the guest. But rather remote attestation which, usually involves a
> > helper service that processes the quote. I've never been clear on why that was
> > desired. But it probably is part of the reason attestation doesn't fit this use
> > case perfectly.
> 
> Even the remote helper needs to tell the two cases apart so it can
> parse them
> 
> Again if you expected the user to pre-tell the helper that this is a
> legacy vs DICE VM then that's exactly the bad user experiance I want
> to avoid.
> 
> > > > If there isn't, I'm not sure what we could do at this point. There is a
> > > > library
> > > > Intel publishes (right Peter?) that can verify the quotes. I'd guess it must
> > > > have some way to distinguish between the two. Can you check how it does it
> > > > Peter?

Intel publishes a library for quote verification [1]. It doesn't have
the bits needed for DICE quotes yet, but I think it will be added in the
near future. But basically the first few bytes should be enough to tell
them apart.

[1] https://github.com/intel/confidential-computing.tee.dcap.qvl

> > > 
> > > See this is exactly what I'm talking about, I don't want to repeatedly
> > > get into this situation down the road over the next decade.
> > 
> > I'm not sure if I'm missing something. New incompatible standards seem pretty
> > normal? Sometimes there is a container to specify which type of blob, and
> > sometimes it is just discoverable by clues in the bits.
> 
> Yes, completely normal. The thing that generates the data should have
> an unambiguous contract with the OS on what kind of data it will
> generate.
> 
> If you want to change it, thats fine, but the OS participates in the
> change and is aware of it.
> 
> > I think the thing that is a bit dicey (no pun) with this, is that there is kind
> > of a backwards compatibility adjacent change for systems giving the new DICE
> > quotes. This came up in in both discussions with Dave/x86 and Sean/KVM. The
> > reason why it was considered grumble-ok in the end, was because the full
> > verification depends on updates to the library for each new platform due to
> > needing to be aware of new keys. So to actually attest even SGX quotes on a new
> > platform, library updates are needed to whatever tool or service is being used.
> > Since the library needs to be updated in any case, it can also understand the
> > new formats without any impact to the user.
> 
> I don't know what you guys have done here. There are IETF standards
> for all of this and well defined container formats. Sure to parse
> every bit of the token you might need a new library, but you should at
> least be able to get a signature verified and parse the generic
> information reliably.

I think the issue is that these standards are actively evolving and at
the same time new crypto is being introduced in the coming years (like
post-quantum crypto). So things are more volatile than they would
usually be. AFAIK introducing the post-quantum stuff will again break
how these tokens are parsed, but that's a big attestation change no
matter what. But yes the intent is to eventually stabilize these formats
so that things like certificates can be reliably fetched from the
quotes. I think in the short term these quotes are going to evolve at a
faster than normal pace.

> 
> If your plan is TDX releases are ABI incompatible with the verifiers,
> then thats a horrible plan and *much* worse than what ARM is doing,
> for instance.
> 
> But it sounds like your library can somehow parse the blob and figure
> it out, so maybe it is just a matter of describing how that works.
> 
> > But this didn't take into account this generic API, local quote processing use
> > case. Which is kind of a surprise and I'm actually still not 100% clear on how
> > it will be used.
> 
> It is not local quote processing. This is labeling data properly so a
> verifier is possible without the user having to manually and directly
> inform the system what versions of Intel CPUs and TDX modules it
> should expect to have.

With labeling like tdx-quote-sgx-1.0 and tdx-quote-eat-cwt-1.0, and
enough knowledge of these labels, I think this can be achieved.

Thanks,
Peter

> 
> > I think we would have to circle back with everyone that pushed for the host
> > controlled quote type. Let's see if the library can distinguish them already
> > too. This attestctl tool... is that something that could consume a library like
> > this? Or something that would have a no dependency implementation?
> 
> I would hope for no dependency, the idea would be to provide
> references for anyone wanting to make verifier software, and a tool
> for the admin that wants to debug/understand their systems..
> 
> As well as a point to have a strict injection of sanity into what
> people are doing so we don't get repeated ABI breaking instances in
> future.
> 
> Jason
