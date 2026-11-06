Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794001685;
	b=WqFgTls5kwFluCNKAtawhbclMLyE/iUSNTVUJovnkRxpVXvf8PfbHliX/MrM60wqtBRF
	 2itGRKe5xLu7dsmbLdeTgXqCLlwUBAnQBGmyN2t0WdWROw1wDjdqr0wSYOFtfGAE6gAfq
	 nwvvaF3j4OsB78/B2RmopQ/Q6Dzp9zSfyaE9K6Ajao8US0z/8B9ZvDu6r/HqaqGE0RRK+
	 8LmciKvs19T/Yuu/ZTr1lvsT+/SL3EMReFBh9cxEH4H/RHlsufGOU1ffGALESIamZCmFY
	 ztshJbCoW6i2v2s0yUIKdPGKnvwmL1ik6SbL7oviCYUfD3jUChHu5clYlM85BJWdYSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794001685;
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
	bh=8nXpEQymNXRku8n5+Yz7GHlxinAghyP0/7U2SYwQD2o=;
	b=chSGR3hJX1ESrrgaZFohw9OYbcLzk6rs/ZAAIIApirKwkJxrWfYnsVMIKu7mws2urBVh
	 rVAE5JHzduXdKWUZuSxfbB+4UDEK8cu/h+v7PmbPtbbjZmsXdK7gWFh7fH3Hzz8CweMJv
	 itn+MN6wVZLF740yHbF3tMIjlR7fusIHxcj2LcPssu9aSJfCF05oP13vR3bCHRLOqtz7R
	 7zfMRJ3iEqHuhIpys5JdD1hSZTzUqL2ibN9jfE0DOK4r0Xhqsa6sAXBA/zc4Y/t6Auq+S
	 xeInKU6LTubR+Xmkk0DVJXzPoPyY9K6fBXCpkj60t94Wl+eC08UIsoAnSKfVTrNI0bw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FlFseuil;
	arc=fail smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7923606A32C;
	Fri,  6 Nov 2026 21:48:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7923606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FlFseuil
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794001683; x=1825537683;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1f0nFmkUucJgN/zisFf0DFMdW3P5sF9Y8UCVX4FETzk=;
  b=FlFseuilGv/++KYT8z/syCN+ZPIBspMc3r19IuBiK5PSegqNNp6JJ+LB
   7PG0ACS/UMhoKJKWGyOeYvfVWADqLG4zgWQTn50pE7j9ZfinVOYJEXt6f
   IWenSsnQpBs8wTIsP7xIRJS75RNMwlTJTTbjJPQVP+Ep6a70dSpuXGpel
   Kmh7LbbdSRvuR+iXKgwf8GKrVFvyCY2kthUTMK/qB6urOuPzkcIF6pZr0
   PNtGgW21MyXNW2/5histXqFs7zYU4MxM875f7qpdE1tIOZKo76AujiLEq
   Fe4md+Dq2uSey6gWhGS6Mc6LH6ajRiwBQH5+gbjgooY/XRW/AAMfgwTF5
   g==;
X-CSE-ConnectionGUID: kynbzZiDSBOSVsYmvzIGOA==
X-CSE-MsgGUID: hDN8tNhnSQaSJDrWSZgIZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11958"; a="2914403"
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="2914403"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 13:48:02 -0800
X-CSE-ConnectionGUID: LXM3PaFWSh6DWBHE7402RQ==
X-CSE-MsgGUID: zI0oeOrITxWAB9lXA4lIUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="7705262"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 13:48:02 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 6 Nov 2026 13:48:01 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Fri, 6 Nov 2026 13:48:01 -0800
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.49) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 6 Nov 2026 13:48:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w2L9F/nNHKukUH8JxOE+YGm885+WORtORhdhar+vWI4/Mt6ixchRbvbluFtCw8iBRNXTPmPOzIG+eUnroDBV43qKK44LuEh9JaXFfGv0IlTfqQ7R/upEXzy8851nvAMeGqxwl9NkwF7vCvXLywat4oBTO6XOOiFp186UJytuz2hqiAxccDWYyhyAXWplRoun4RouxH4daOIqc0alJUOCSK4EXyEf2fGJAC8EHlBDxS9mRccQuFbKkV7C55RwNWYQMl4c98tEjstsv/LwKnNBIwunpECcu2adJkGWGRLeIlHkeNzJLvgpL+vbOZrTcYVIF5BOiQHr6rJ4E8qEJYUXfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nXpEQymNXRku8n5+Yz7GHlxinAghyP0/7U2SYwQD2o=;
 b=ImYcyIHkBsnQI7VcD9wSWgAwAV4CBQORCVs8RU0F7XHowvBNUqtu5j9gNnj2wFyM6UZr0qi9OYMtvOOXUVlPw4m5pS78MRCnE7UO1GwEXTw/IGpncPCx7zkEfjY+BoS5/zlVJUHy10zJS0ksmPHJj91hyVo5R1YsPB/9h3hGZqcKKeQZSbMuVh1N9D939U+obEkO7T86IfI88qo2RYY5ExnNbsqKpSfXZrV6SMYvyl26Ymqv/VmLsGpd6Oq6SeDk8WRxSotjt7t5YNnbtLjMzR9WwOYXwDo4Qca0vbHvFS1k5K1usp7FjlW3Y0bjTdm+QSnpxMv1fMXvzoX2fPriPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB435924.namprd11.prod.outlook.com
 (2603:10b6:610:34a::8) by MN7PR11MB628000.namprd11.prod.outlook.com
 (2603:10b6:208:5f2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 21:47:59 +0000
Received: from CH3PR11MB435924.namprd11.prod.outlook.com
 ([fe80::1696:c90e:60af:a0cd]) by CH3PR11MB435924.namprd11.prod.outlook.com
 ([fe80::1696:c90e:60af:a0cd%6]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 21:47:58 +0000
Date: Fri, 6 Nov 2026 13:47:52 -0800
From: Peter Fang <peter.fang@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
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
	<rodrigo.vivi@intel.com>, "lukas@wunner.de" <lukas@wunner.de>,
	"jic23@kernel.org" <jic23@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"sameo@meta.com" <sameo@meta.com>, "aik@amd.com" <aik@amd.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "ksinyuk@kernel.org"
	<ksinyuk@kernel.org>, "qinkun@google.com" <qinkun@google.com>
Subject: Re: [PATCH RFC 20/20] attestation: Add the TDX family implementation
Message-ID: <au5LCE1jau0yDo5S@intel.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-21-jiri@resnulli.us>
 <ed52bb6d48c87ab8023bf2165cadffa259e21725.camel@intel.com>
 <20261023141218.GD3977851@ziepe.ca>
 <343e4a12f2fdbb4e9a19c4afe49cf2b8908d6739.camel@intel.com>
 <20261023220030.GM3977851@ziepe.ca>
 <7843a833723e3aad40f8fc4de3a83f5a5059280f.camel@intel.com>
 <20261103005851.GH3889730@ziepe.ca>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261103005851.GH3889730@ziepe.ca>
X-ClientProxiedBy: SJ0PR03CA0339.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::14) To CH3PR11MB435924.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CH3PR11MB435924:EE_|MN7PR11MB628000:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c703691-ceaf-4df0-ccc4-08df3c4f9f69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|1800799024|366016|376014|261102123227099003|261021121427099003|261022075727099003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|4143699003|11063799006|56012099006|3023799007|6133799003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: jAVkQQ5tguamb0Kin3fzfqp71X8oPgpLhugt92KNMcxq6cNe4Nczj46RTkd5yJ5N1GkbTLfl0p6Pv6P/rX1NFFb9Ki0yXF0AZEgWjCCWLBuI4kdACAELUd+Suy/aohUhMG/cyI2QDNEuHRso8IxhGxXkJKUH8YISzd20TBJjaVWoYBHYfD6NUXN+IO/t811IGAmD5AL7v5ug/L1drJx5QpIp42+9wU/wb6d7JVNfpi9tr3OUNtFG4rYIuRwJZ4cj/JxvlASKNEMbl5aZykT4oBvt6zGvK4W1aNLPBKs3g6oLsxm6/P0rG1DwZRyRVAMGL2WF1/SgLD8kJNoiC2fUX5ahPZQL2fzxajwj349xQJxhy+T/TGreEfJCwMHiK+31XErE5OAv6M0ZyM6bDo8PiJQKEZIJzRiKUC/jFzEy1Uc0fedpNfZid+hMAqEtguUlIs5NutwPeLrmCfpvQh1xWZ2H2Umh/zw/UUOGSnlF8/oKzzop84ebt1MPR4+Vx4M5++NzZkVHcEWcptETECwi+LWljh0ZJFlCPM9gIYAPWNOvk7pgvpj2lAhHYUvp76T4XA/AftLaM57gHa623Wph6hPolwoOFTB9E5sant3F311ZQsdYWUsPJ1ZxgnNXn8lnl0v39+upP60T/xi9LAdF1giFLsI+4y7br9MHz7xkGbk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB435924.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(366016)(376014)(261102123227099003)(261021121427099003)(261022075727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(4143699003)(11063799006)(56012099006)(3023799007)(6133799003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H1y01PYy/uMXhQgIH0+0G+/Q6+8xUmflL/wpnNLHtHcCKaEFFOoIOcIXeavk?=
 =?us-ascii?Q?JO9QmY1qha3pMRnLpXu3zApgIoUlQb+sqsKMUOwaFFlhf3h6SzapEa15efqX?=
 =?us-ascii?Q?1Ubv7q93b7+Aq8M4kdIUL8zShP7RiQGx0YDlNCGQ6/fPvLk+5A/yIXzMKLZl?=
 =?us-ascii?Q?0IYqkgjnEy7iNJtXl+aKcE0GeBYRrinRLIzrPp8+vWt38ew7rP75h3mLpDW4?=
 =?us-ascii?Q?AXwEOi5jIfRvxgrt5m3vCjRZ5e9PuQS1cewR12Qdc7ALNk9U8S7BGQMGVoZo?=
 =?us-ascii?Q?B9M/UALj35zOunYXbVPdoWXZ/iaLy6v8GKK6O3U/bUQmiV3/UsFQeriRf5zV?=
 =?us-ascii?Q?pwuTrifzeG8RJZQDguKnsROMINYfLfgvmsdG4VQgruIgExhI2VSV4H7/SnQA?=
 =?us-ascii?Q?jfnitPVm2o/CbXSixuU1QL5TekfkOMOR+hsN2MxrCxy52ckmIdFL3nxfPdUh?=
 =?us-ascii?Q?+uL1RIvvSmrZqH0Xwa6aWM6WLKinXWG1HjDOX6MYtb5UQlzdhNooeV+u0Sfv?=
 =?us-ascii?Q?T1hoeyyVN6CzyieTkC5FZObpHuMzvBOykXK4SvSWgp2FYMRVojQnjVCYnLE0?=
 =?us-ascii?Q?3M0z+F3z5GaJsmjP2g5o2h+DfVdmiaMTBhbBd9LhSTZCxHNluTTWRlWk8JGX?=
 =?us-ascii?Q?sVBW0Tji6OCLQfTN6j/Zkg00WroTDZItl5eyXeB4+haZzxK5aHxDx16qMFrN?=
 =?us-ascii?Q?bXR3/FencTXlut93DryZYfvSRw4HdFUOTGZLI0x8G0AFNWQU0Opq7S9iv29U?=
 =?us-ascii?Q?3z5QvgphforPXUEQP+8uMsZauRaSx4TV51f+6BmLoxlmngqN+ew3MzsP/qqz?=
 =?us-ascii?Q?LNQdBMpYWHSFigjD9SFR6ikGgtCOHau/ZQsZwuCVLPO8W/eemlm6cI6oJXao?=
 =?us-ascii?Q?yke2JKN8VXbGu2RRnojJXE0d/yklUIOClVBcgCwvqzMFIh8I+CkcZATRtHpe?=
 =?us-ascii?Q?Hw2IFvH8BDIPCBZoFhOlxkMplHPYhubelDQyp7mV64y9Z3m7vnm3xG/X6Zwn?=
 =?us-ascii?Q?Zva8Be47prSKa1jKSIdlP3h1q074cnyeFmVn96ebQHA3ohlnyRyqGa3YR0gm?=
 =?us-ascii?Q?pVm2uupGBc9QGiBcL4WLGkWHkCep+L/7KODhzOkUf56yBOLeIwftgwf1qdot?=
 =?us-ascii?Q?/dFWq4vGnzbc9vPgFW/BLZJPaB7bLUFBdUJYKlEYMQ4wePVW9P6RRCjGB85f?=
 =?us-ascii?Q?ZN0+zI7TTeHHeG+3ZvZ7JVQHsIJC/1Fyl1H469yBCIMhtmQyrHIV/ydrsmZs?=
 =?us-ascii?Q?F1g/XtA3G03LLlv9ze91VyvnA7Fx2S0pWyI0fxh8fOkSWTkeA29pKaWN2/ka?=
 =?us-ascii?Q?wvhffpZoTCNIVbQemhDTvT8TW/AdTZbJQaeJ03lixQPzEFKuTq3sHqjftJxA?=
 =?us-ascii?Q?BwvXhWPfMP/GlKvCWuALw4uFGfU+AqLINcnvcW5SQReUf3J9RwvMg2lXywcl?=
 =?us-ascii?Q?Sy4x7NAf4+9kQjpO1n5a66nJ/CxoA94uPaZ2dG6vLDklleaftJ4BFiNQZWV3?=
 =?us-ascii?Q?/ss6DKS6h8+lIIWrB8Ok+rYjDw2DF/dHgdizg+bnrA6Zf1plcaSzUuhoWZuV?=
 =?us-ascii?Q?mqEF3zcqRBjfzMu8KEzEkq8GocN6mBC3XBuVdKTJk/IRxfVphNL4Oa1PQhut?=
 =?us-ascii?Q?k3Wwa7h9LtlN6vexMJ5yv5s2apZ/RS/6SCNt0BWyUAYjWp8VOYhoCLo7zT9F?=
 =?us-ascii?Q?3wqtRFPJ10RKtujj9aMqSxvld5cTShha/xyQbeq7ykutn1Tk+3bcWio7xyG/?=
 =?us-ascii?Q?qvCvX91p0g=3D=3D?=
X-Exchange-RoutingPolicyChecked: Dyw4XFzfqkzLUi3SHh5HnR6xqKJB+gVGNE4XLvcYMblW319gt7R/GHWeK6542Ks4Zj9ZJBiTjzYSwaVgxSRo4E179Us/pO8I7KuImDt/luYu/gDFBmZ/rQKIxco5mTMiQ1ajdBL/V9vmhDpwEejaCCQjFOnGaR32kxDKIwo6tJr1PIo5Ffo0KZXl+GbcXrpb3/xlONuFgIIP1PC9RpmiaWVrCPPamYFnnIJKbfErGbbEjygaP0STBTDemTf016r60vf7Z7zRgeB8HrxfDsc4jx6ybOQmn0DgXhxOzzhY8LGEI4KLzSbRH+ItiJUUc0llHoenKK9ZaebVxaNJJ8ra5g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c703691-ceaf-4df0-ccc4-08df3c4f9f69
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB435924.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 21:47:58.5687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymFGlZ/I4IsHLinATPbjsi6HL5u+gH9O0a+7jDYJIcj7uLtQNDSa9IP78Ip9bORe6CZMo/GA+w/xF7lU8nVCBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR11MB628000
X-OriginatorOrg: intel.com

On Mon, Nov 02, 2026 at 08:58:51PM -0400, Jason Gunthorpe wrote:
> 
> > > If you also want to have a way to query specific types, like AMD's
> > > guid thing, then that's fine too. But I think integrating into systemd
> > > report might be a bit tricky so I'm not sure it is a great idea.
> > > 
> > > In all cases the format of the report is labled, passed to userspace
> > > and given to the verifier. I see Intel already defined DICE format as
> > > 'larger than 8k'.
> > 
> > I'll have to check (or maybe Peter can chime in) if there is some easy label to
> > look at.

There are many ways we can label the quotes. For example:

- tdx-quote-sgx-1.0 (legacy SGX quote)
- tdx-quote-eat-cwt-1.0 (ECDSA signed DICE quote)
- tdx-quote-eat-cwt-2.0 (ECDSA/MLDSA signed DICE quote)
- ...

Or, at a finer grain level:

- tdx-quote-eat-cwt-1.0-ecdsa
- tdx-quote-eat-cwt-1.0-mldsa
- ...

But regarding this labeling, I have some questions below...

> > 
> > > We'd probably want to give that a dedicated label in
> > > CTLV land.
> > 
> > Not following what you mean exactly. A CTLV format that contains the report? Or
> > a user ABI way to request a certain format?
> 
> The CTVL output will always be something like {label, data blob}, for
> everything so it is self described.
> 
> Since the DICE and non-DICE TDX quotes sound non-interoperable they
> should have different labels.. I guess? I really don't know the
> details of TDX enough to say.

Yep, they're non-interoperable and won't share the same label.

> 
> > > One of the things I'm quite adament about on the data labeling is that
> > > if something sees Blob type A then it should at least be able to
> > > verify the signature. Further format variation should be self
> > > describing data within the signed payload. If it is so different that
> > > you can't verify the signature then you have to give it a different
> > > label too.
> > 
> > I'll make sure this made it back to our attestation people. (probably someone
> > already picked it up)

With TDX DICE quotes, this is already the case (the signature is
verifiable). This may not be possible with legacy quotes, but they're a
thing of the past.

> 
> Yeah, I'm quite adament about this. I don't want this to turn into a
> funnel for undefined binary blobs that nobody can understand. At a
> minimum the signature has to parse, and at the maximum I'd love to
> insist on a userspace implementation to dump the contents. We will
> see.

Hi Jason,

I think this in general is in line with the TDX attestation design. In
an earlier thread you had said:

  "I think in the way this stuff ended up being used the userspace isn't
  actually aware. [...] The verifier needs to be aware of the format,
  but the collection agent should not need special knowledge."

... which totally makes sense to me.

What pops out at me is later when you talked about data labeling:

  "Userspace would collect all the blobs and the labels then ship them
  to the verifier which has to understand how the data described by the
  label is organized."

For TDX, the direction so far has been to keep the guest as simple as
possible in the attestation process. So the "quote type" knowledge is
pushed into the TDX module and the remote verifier. The host kernel is
mostly tasked with transporting the quote blob from the TDX module back
to the guest. In other words, TDX doesn't have any quote type knowledge
outside of the module itself. And as far as I know, parsing these blobs
is sort of a pain.

The TDX DICE blobs are actually self-describing, meaning the verifier
can follow a schema, parse the blob straight away, and know what's
inside, including how to verify the signature. They're also
distinguishable from the legacy quotes. A launched guest is guaranteed
to have a stable format for its quotes. So this makes me wonder how the
labeling should be done. Do you think it makes sense to just have a
"primary raw TDX quote" label and let the TDX quote blob describe
itself? Also, I think currently there are no plans to add
secondary/supplementary blobs alongside the quote itself.

Thanks,
Peter

> 
> This will naturally force people to use the right labels since they
> won't be able to make a dumper if they don't.
> 
> Jason
> 
