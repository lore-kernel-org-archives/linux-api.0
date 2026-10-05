Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25FB488222;
	Mon,  5 Oct 2026 17:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791222836; cv=fail; b=fJeN/1J8fHyfpe7aQrjS3qGGQN2UhLMARuR3Jo6w3JfkcS2jJ3KvVhKD3DSMEc32eHdbn4ggTNvmvoGaRqeaFukPUlaR2MT7GfcN05w9384OtrjFGS3k+/ctJw+rG+KSPe4yrXVwu8D3xUFS247sLHW4MzQtNVnNGrYoSZBqQDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791222836; c=relaxed/simple;
	bh=CHyzMMtYM4J5FT4cuSBt7riAjfFuLFoIpMCl1ydoFKQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=avG7Hl64Zoka8lPaStJBp6+UxGPlJniDgA3SG/S38cGcdCKbCUl5tRjbYFgpAivL8LSKuJkEqnVvOY1D/GvsHP8ImPwq66Wwcuzzdp1eAxzuZF7CM4Avf8NUnmzMt9YbphcHM91ZWv/qhOAF/NnLdu3nGG350YYrsEAxCfJdnr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b/zrZpwy; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b/zrZpwy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791222830; x=1822758830;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CHyzMMtYM4J5FT4cuSBt7riAjfFuLFoIpMCl1ydoFKQ=;
  b=b/zrZpwyIw04uI9Oc1KFjwq0GmosUrb8/F35NdCWrFvMlUbsofpoMpQ8
   NQOyiv7Labw8rBNkWLAF0ZxBJYhkNZEij+E7UpO99wp8GrZvU0hv9/exU
   p7QFaE1rQ6uaL+5g9t5SZXvNMZyX9bu6Nh2lotqsKA951ymivU4af2yN/
   KxYpIymlGGmyt+pPYXQ3wgh5tAq14iyn0J0LFJt2EzALM2wv3XCsrKePc
   1I6RwOQKxcUAMK7DyyhERpWC+yplnTpk/KgtMmSnFjxCE694SAGuO7iR0
   UZIpE3E/EG0jBmVsMY1jEkWgzkF34Z/l61mnVKve4d4tT8or08Dup+sQz
   Q==;
X-CSE-ConnectionGUID: wXpUaWY3Sc615R6u/8n+YA==
X-CSE-MsgGUID: eCARlzAoSriWURqHler9xQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11926"; a="91925553"
X-IronPort-AV: E=Sophos;i="6.27,142,1787036400"; 
   d="scan'208";a="91925553"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 10:53:49 -0700
X-CSE-ConnectionGUID: /ndzdztLTheup0WDjrJgRw==
X-CSE-MsgGUID: HB7dA8nHRvWS6HEqskr5DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,142,1787036400"; 
   d="scan'208";a="276406595"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 10:53:49 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 10:53:48 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 5 Oct 2026 10:53:48 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.19) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 10:53:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PDCijWAFZFrmFDbllRy6EzUPS/dnu2/MrX7sE/fXV8RwMi8bCqd3PScYP6qGl5u/NTUB57XeYJQiKn5RLIkxO3xibDrNS7kG0QL5TY06MrJq3MQlRmBEXtjVze/40pfcp9N4jf5IZ3jm89KqsB+WGRngRtk++oYGC5psk4Hh0ZKvOz3bqdqQITKkO8SsIhzFWKcotrQ8hiv26eLHvCOqsX51mtuXP7ZD5lKxwe7m+XEj+LX9NXHHVwSUivX61XL3AgYsMbe1tSrtMj3R7COdZdB+AmdEGTnQmr9d7/8V3bzjvV7C7+ruz+gFVlTQQeyD3yLVj6an8fcSilDH1f94tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIEOgEcKhibpVul80s70Z8sVny+dMm+ZkSgK9EK7W+Q=;
 b=UAHWE0GrEqwb5UTxzOCYuTX5TS/83Lg+SQcES6MDMePsVXNfKJ+fs7xrCvdsF/RlcTy/WyvgoLJHbtSeB1gsLp7MG7aSGyQhshTD6Kf8qYDVuICuWvsI3CNHui9Wg1jq1FmJY1bgMvj2pFyfFoaFiIt+bthA51mgWor3g+m/mA9uxJFOZnCTZmFvZWe7lEsPwzbjRDKo14FqZGMTsmfErfdWH2s13gM5beASSULxPLOZFYNxk1jYhCb20GCBchPYpyzMCg+Gi436HheuEofD3h8wplmyM+e4eRGsSNXn+LyhlQ8Zr35dUVTWh4jDjqV2xKO7m5kuEzFxDoxf+Bc1WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8568.namprd11.prod.outlook.com (2603:10b6:a03:56c::19)
 by DM4PR11MB5245.namprd11.prod.outlook.com (2603:10b6:5:388::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 17:53:46 +0000
Received: from SJ2PR11MB8568.namprd11.prod.outlook.com
 ([fe80::a548:ac78:60a8:8a43]) by SJ2PR11MB8568.namprd11.prod.outlook.com
 ([fe80::a548:ac78:60a8:8a43%6]) with mapi id 15.21.0451.026; Mon, 5 Oct 2026
 17:53:45 +0000
Message-ID: <9147f6b3-1afc-4939-b34c-424fb7dd11eb@intel.com>
Date: Mon, 5 Oct 2026 10:53:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] media: i2c: cvs: Add NVMem-based firmware update support
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <linux-media@vger.kernel.org>, <mchehab@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
	<sakari.ailus@linux.intel.com>, <hansg@kernel.org>,
	<laurent.pinchart@ideasonboard.com>, <mehdi.djait@bootlin.com>,
	<mika.westerberg@linux.intel.com>, <srini@kernel.org>, <arun.t@intel.com>
References: <20260930182142.108744-1-miguel.vadillo@intel.com>
 <ar6nSbS-FpaI6jYp@ashevche-desk.local>
 <abb0daee-c5f2-47c2-9b0f-6018edb0ba6b@intel.com>
 <ar9XxEb6Kjvd6HXb@ashevche-desk.local>
Content-Language: en-US
From: "Vadillo, Miguel" <miguel.vadillo@intel.com>
In-Reply-To: <ar9XxEb6Kjvd6HXb@ashevche-desk.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0046.namprd04.prod.outlook.com
 (2603:10b6:303:6a::21) To SJ2PR11MB8568.namprd11.prod.outlook.com
 (2603:10b6:a03:56c::19)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8568:EE_|DM4PR11MB5245:EE_
X-MS-Office365-Filtering-Correlation-Id: 94f58234-c133-4a5a-9ab0-08df23099a19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|6133799003|22082099003|18002099003|10067099003|3023799007|4143699003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info: nyKeJiiZtABnAuDckbdUUOv2zzH5Rnyt8jPJhTIP9kg5XqU8v2Cutc6vVRQS6h25ysOKRscKSJcZYqT5VaaMfXsY9lYS4JjA4ije2yUvjX9KYVc+aESrFWoX5rL1gkEuy+jl77DD3S6b72TpNm1G+64QDGmdRg03LRgNGhby68v+od1vXBE9uavpA6+Mb+w7jJoUxJwW2xTG6GLgxJQL7nYG5xUeCsAJDuWbdRWIDpJh74+9Xxb4Gl0yV3qvImjKa/jA7eD7hAKqyU40UvFz7JEv16CSyUtuMsTh9w3iPYNMf/c/mqzIHdMwnjeYEPr+tTZ6U72//DjbToAhoBNlMCAwn4umdZfZSMhkRRJPYQOp5lF94ct1LvSpleI90cWEzov+c73JaQ/fFO5GFrjBa388/P5g4VPySWEPMuBow19MLI3/mrePCiJSTD9f3NE1wdJPO/nl4+aAT0J7x8gKGnl4KLufaMCQ2sblhPt7PacgwiWaAU6AFtWkk+mws0/SCEqn+RRV8epq85zmiiE9FT5BMUFHOYw/Scei72kFS/B81bpMe/FntY2jOGoAqTQOh3ic4CMhA28p6IPiIN3+P+9wuWVgQCq4wWRhUjUxbzSYUVhMUhZzRceL0sj+kSuNMQA4QEJokcuIBpG69VikThVgTgxsC8SAAqOkDn7luy0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8568.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(6133799003)(22082099003)(18002099003)(10067099003)(3023799007)(4143699003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3I2VnpHQjlNVWU1L2pLOGJ5WldVOWxqSDhCZVJsZ2ZnVk50ckhPMkdscnFa?=
 =?utf-8?B?UlBHU3NZdHNwNG55RzN4OTJvd3NYelRySU9NVkZ2RlQ1S290aWdxSHFnY2xB?=
 =?utf-8?B?em95U1hEYndadEcwOWwrWlZmVDlQSk96QWxaS3kzbW9mckl4ZnNKdG5FbmlV?=
 =?utf-8?B?blQvM3FITFFXbjU1eTJRQjhYTHVwaGdqbmRYVFFqTkFTSmxPa1drSld2N0pN?=
 =?utf-8?B?MjJBNHROQlJzV2JLWlpSekhaVDluZ3pSNDBONjJKMTBaV2FkYlJQR1FIaHNX?=
 =?utf-8?B?cy9WSTNlUWhldE1qZHpyeThBTUE5amJ1VWxFZVhjbzRNSG9oNjQzcXp3aTFp?=
 =?utf-8?B?UHVqdHB2VlNRSGlQd2ptM0N5by9SaVo1UU5yVmNVWmx1WXNpekllKzc4SlQz?=
 =?utf-8?B?S0ZVQ2h2TjQ2SFNWVUUySVdQR1hUQlF3SnFKWW9GT2lwN1oyQzFlekRtbHJS?=
 =?utf-8?B?VXR6TnRYNFJFR1JuaktqQUk4Yy9UQy8rU3ZqejRyQ0VaY0wrS0ZnS1FTMitp?=
 =?utf-8?B?RkExR3VzcG8rSkRPcUQ2cWVCTFVVUTZPdmhxUWtxTVM4ZDFDOEJIdTFPbCtQ?=
 =?utf-8?B?S0JWUnlaNkdsWGVmSGQrdEtvQnZDYk5HekdNc1FqSTN6eCtReXZSWUxneXl0?=
 =?utf-8?B?YnlFaS9kSythb0ZCdW9kbUY2dFYyT1c2QmsrMlhsRGlQTVo0RmFwRXphQ3Ix?=
 =?utf-8?B?dDhIWGJsY3RwUDk0Rzdab05FUGk5VE9nVjVBYTN1R3YxSUU1ZGZqTUZ6b2I5?=
 =?utf-8?B?TmNwYnJKNlBqVXIxRXl0cWREaGs4UHdOYTEvdUloaVBlZ2p1ODlCSFNXY1hX?=
 =?utf-8?B?bjlCSi8va3Q0MFlEaVpuL0dhUHYxVEhKVkNKakhBMWxLRUJmcUFDdjJJbmxX?=
 =?utf-8?B?all6UnlJc1ZpeTgxT0hzSDM3VFNXVHV4RWRWSlorN3lCS2RjZUh1aHdUOGpL?=
 =?utf-8?B?dk05QVBDNnN0TFF5NkRKZlVZaXBYcjVWWks5dWhsa3h5Y2lCcE0vaUZXeHFk?=
 =?utf-8?B?TkdvbzZOOVdmUzJwRmRSa0xTalhTZHhaaDNPK0VwOFFBSThDbGVoMTg2Nkdl?=
 =?utf-8?B?RVBoV25NRndNZ25NRVJkVUFReDExVkg0OWVPeFBENDhNWDBLSkxsckNnNFBo?=
 =?utf-8?B?akZydWxYRVZnNUpwQjZEZkQzRy9GTDFpb012TGUwOFdWRHVRcUo0WWk4cW41?=
 =?utf-8?B?ZVlpd3kzTDRlc3pxYllQWDRDS3lWeW1ZUEdka1lBdW1QM0FLZmpsQy9jcFNB?=
 =?utf-8?B?NXgvOXJOUXRjcWl6ZlBUTGEyQnhndEc5bWEwVVk2THBTWlRlSGtMT25nVlZt?=
 =?utf-8?B?d1Rwelp3U2JzKzhaZm9QSGxiWTNOVTM2blhxVHd2RThjZkk5UGVqblBZTmFY?=
 =?utf-8?B?Vm04clRXbldMT2NMUFhqdE5HN1VjRkVHVm9yWGpQdW9WZFJNTkQvYWxpWll4?=
 =?utf-8?B?ekRRZGJGck5MVXZXWjVLa3Y1b01ZQktWUjdGd3Uwc0doMUpic25teS9IbWJj?=
 =?utf-8?B?cmhuWU1uN0dCejVRbVpXVzBOaHpranlWUVVWRWNaZFJpWmtlOFBJbHdhVUhp?=
 =?utf-8?B?c2NLakFNM0xSUFZYMFpNYkxPVStucC8zZDd3K1NYYlJVemZXQkRENEpaUSts?=
 =?utf-8?B?ekpTbzA1S3JQd2p3MlU5RjF1WnpFaHIxWHNvajdEdTNtWFQ0amUvenhwNHZF?=
 =?utf-8?B?VlhYZ1k4Vk9pUzZFck5ZdVlpRmVuODVJVlBaMFpIWlQyN1RETW5vL1pSZlRJ?=
 =?utf-8?B?ZmplOXpuM1RvZVNBTFN0eElnbFNMNW14YTB4VW82VVR0ayt3bXVPVHpLTUlo?=
 =?utf-8?B?SytnbTFneTdTNUtUeWFueXJaWWVVeHp5RkMxUVlnODFlR29nUURiOHE2UGpv?=
 =?utf-8?B?UndDb0FBd1ovUW4vZDRTdmc2Y0o5V1JCUmtmbEVsRytmbHMxY1oyOFNtRzRD?=
 =?utf-8?B?K2NrcW04SjU0YVhTQ0MwVlF1WmI3NGt0K1V4aUYxRkh1NVVuSk4xWFBDTTV0?=
 =?utf-8?B?WGhXRWdZd1c1ZjRZSmY1MUpzbzd0SlRVaEhTNEdwNlNLZmF4SVEra0s0QUxK?=
 =?utf-8?B?T3A3Qmw4OVFnVHlsVkVmYTNwamhCNWh0Nk1jV3pvclFSa1psbHJUQXRyczRB?=
 =?utf-8?B?d2VXeUREVnZnMWxxT0E0alplKzBFM05SYXgvdU8xekI5dWpmQnpwL2s2bklj?=
 =?utf-8?B?N0hROGJGU21TSnA0UmJCNmZZcHk2STZQeGppTVNYQVN3VjBKazNWZVN2dkVl?=
 =?utf-8?B?Z3ZxSUtoZTdzOHZ5bFJyS0lTQkwyRXQyajdXUmhQM1lpTEdqQitaSUNyWEN6?=
 =?utf-8?B?SzJ4b2FLK2J6MHdBL3hxV2Nvc1h5SDFjNDBsT05aUTY0RW9yZzFhSVlVSmFU?=
 =?utf-8?Q?pw2M0li3zghLmb6o=3D?=
X-Exchange-RoutingPolicyChecked: Ox1v8CWapKoeYgWmsE7BjmrL7LLNg67C17JQ+zyTREe1Gn3alQO51O5L6bYH1r6sn3jLs2za98ac5i3uMeHm7KSgRyuxuwU00bh1GSv8HJs7UrtoTH8wPbiIuTM72Go0oIt5nzxYahwS+aLaZL8Si4CnBmwtiEcak8KgoPYazw3mPDK458AFxdfbx7iLVHRrZJas69fTJpARoLUsvXfFFOvDCwWtnP/3ak17mV/dLUN38BSi3PqHHtyHXRXET/Rs0HDEepeH99xQ3aDpLx4yusi5UtqCvmdVqdGdBkIaCUlVmUoMzoDVdZgdqYwp2BW2Mj07K4Z+c+lFoNvSiVlpAA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f58234-c133-4a5a-9ab0-08df23099a19
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8568.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 17:53:45.9110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSsTIdcVkjTZSPXTBSjW37cryJ9oweALSlaMt2JlZ6TthpZzrElE7/P1vPCbvv/wH1jFuMMqQkWP6Q8+iSSRcRxSKCoGADQAYJ58C0H+dH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5245
X-OriginatorOrg: intel.com

On 10/2/26 12:05 AM, Andy Shevchenko wrote:
> On Thu, Oct 01, 2026 at 04:03:50PM -0700, Vadillo, Miguel wrote:
>> On 10/1/26 11:32 AM, Andy Shevchenko wrote:
>>> On Wed, Sep 30, 2026 at 11:21:42AM -0700, Miguel Vadillo wrote:
> 
> ...
> 
>>>> +	mutex_lock(&ctx->lock);
>>>
>>> Why not guard()()? Also how ACQUIRE() macros are co-habit with goto:s?
>>
>> You are right scoped_guard() should be the case here and to get rid of the
>> gotos, this could be done like:
>> ...
>> 	scoped_guard(mutex, &ctx->lock) {
> 
> Why scoped_guard()? If you need something to be outside of the regular
> guard()(), but double check that it's indeed the case, refactor to have to
> functions, one with guard()() in it and one that wraps it.

Fair question.
AFAICS, only the KOBJ_CHANGE uevent has to stay outside the lock: fwupd 
reacts to it by reading nvm_version / nvm_authenticate, and those take 
ctx->lock.

V2 can remove them and keep only the guard()(). cvs_nvm_authenticate() 
holds the lock with guard(), nvm_authenticate_store() wraps it and emits 
the uevent after it returns.
This also simplifies the error handling.

The other three scoped_guard() users (cvs_nvm_active_read(), 
nvm_version_show(), device_id_show()) only did a memcpy() or 
sysfs_emit() afterwards, so they had no reason either. All can be plain 
guard()() in V2.

> 
>> 		switch (val) {
>> 		...
>> 		}
>>
>> 		nvm->auth_status = -ret;
>> 	}
> 
>> 	if (ret)
>> 		return ret;
>>
>> 	if (do_uevent)
>> 		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
>>
>> 	return count;
> 
> ...
> 
>>>>    struct icvs {
>>>>    	struct i2c_client *i2c_client;
>>>
>>>>    	int irq;
>>>>    	wait_queue_head_t hostwake_event;
>>>>    	bool hostwake_event_arg;
>>>> +	struct icvs_nvm nvm;
>>>>    };
>>>
>>> Is `pahole` happy with the layout?
>>
>> Yes. struct icvs_nvm is itself hole-free and fits in one cacheline.
>> That being said, there seems to be other holes in the full struct from the
>> existing implementation, this order could make it better
>> ...
> 
> Better by `pahole` doesn't always mean better in all aspects. You have to also
> check it in conjunction with the output of `bloat-o-meter`. And in some
> (performance-critical) cases with the runtime performance tests.

Fair enough. Measured, the reorder is code-size neutral:

	add/remove: 0/0 grow/shrink: 0/0 up/down: 0/0 (0)
	Total: Before=14547, After=14547, chg +0.00%

text/data/bss are identical too. So it saves 16 bytes per device 
instance (1304 -> 1288) at no text cost, but struct icvs is 
devm_kzalloc()'d once per device and never touched on a hot path, so 
AFAICS there is nothing to measure at runtime. This could be a separate 
patch as cleanup (?)

--
regards,
Miguel
> 
>> 	struct media_pad pads[ICVS_CSI_NUM_PADS];
>> 	struct device_link *ipu_link;
>> 	unsigned long quirks;
>> 	struct gpio_desc *rst;
>> 	struct gpio_desc *req;
>> 	struct gpio_desc *resp;
>> 	wait_queue_head_t hostwake_event;
>> 	struct icvs_nvm nvm;
>> 	struct icvs_dev_capabilities caps;
>> 	u32 nr_of_lanes;
>> 	enum icvs_resources res;
>> 	int irq;
>> 	bool prefix;
>> 	bool hostwake_event_arg;
>>
>> but maybe send as a separate patch since it is not related to the patch
>> intent (?)
> 

