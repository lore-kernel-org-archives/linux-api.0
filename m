Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD13381C4;
	Thu,  1 Oct 2026 23:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790895839; cv=fail; b=WJuGAefmIjX5T5wlmrSjJLXXOa+4qU3rc+PB+XDyG7dKW9cI69FxaEVtINKhW0QDLe6f0fnOPr3nn9QJvBMeIeOMT3btHCRDN7Ne1+NLZZFQpEmZYVVjJykg49xY6HK0LLTUdvcYkLaKM+jDDTN5Mc0bW2oBFqaiIN1+EnsgOw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790895839; c=relaxed/simple;
	bh=YUD8ZE3J5LL500BjEWw1/nd6cnPU4lKMsUSVrkSosPQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pA4vUJ2e6EPiKu5ktiyrcIy80JJTagLf6sseWO8/wFdk7c14FSxjyXpzLImNpRepRKdVscXi2E3CjskvQ3ZbzVxx3TxAQRc1g2dEeoGofgtfMsyhsADom9ehnAuA93dPRfOU0pHnj1KG/624ngMUQJYEoq2/LuCQ+hnDWCrOE3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j7SwokRh; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j7SwokRh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790895837; x=1822431837;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YUD8ZE3J5LL500BjEWw1/nd6cnPU4lKMsUSVrkSosPQ=;
  b=j7SwokRhbxaBraPZpEoDQTex0QPLFQJH7/zIqx5Lq+0aopC/gazo9wt5
   082rQ3eUwkyge/frafzlTCY2vaHqf8Heho1t4AqXX/bV15X0ZYfef/XOa
   Be6767V7hYD7QDvDRfN1T24LZZDftn/OvQ7m3MrHl0gFhiMgywhCZ2sSE
   dbTAABW7EXMJaa5nutxIjI7qtr8awTgjMNNs+8qnp4MPncGkTTGtzyiME
   OyOXH00YzmDMeoVADwz1WALLDrIW75M6u1JCAppMNX3BOLx47YfKTXWAD
   XL4F4u6lHw+5cROBLcKs+Gguhr70hcfqesL3+c7f2T7Fnl2JtREx6Ddnj
   w==;
X-CSE-ConnectionGUID: 732o3L4DQ+CeV/wAcqpTWQ==
X-CSE-MsgGUID: +rE/5HoFRbulfTCsI3++8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90527445"
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="90527445"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 16:03:56 -0700
X-CSE-ConnectionGUID: D4rSRs+kRdm+T9ZtXmbsAA==
X-CSE-MsgGUID: atUkd8FLSI2yo/ZTxzpBeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="275306083"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 16:03:56 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 1 Oct 2026 16:03:55 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 1 Oct 2026 16:03:55 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.30) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 1 Oct 2026 16:03:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VBrewBTLDA7sNytkaQ2VIKnuPpI/lVhq5xaKwzwXhDuqQEspqvfgUao9Ct8SigwNmIAY4MDLcdGxYprz0R2hqRA2AKxDs3PyYWlRbai9UJkWOYyFyO3eoYqw9/CHJZ1EQkI8bcROyulOKhNtLN+rdzBMChVpHHwLHWuGkPD2+5kEUFKXsd2tzYLZNVXnt66vhPulWOYAoaRmyHXCMwieiPxstPrIR6yQ0Af124+nrRmqmZXGYI5e0ppMZImEWi2qPWf+wltZc5mCGwuJBX7vW/OWZNa0DOT7nfSK4GtJxaccB8HNwVwAAo3+RUcroTR8jB2CRjr+aYdUPD5NyPotnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5hPUxmM/LAaQd+CTw3PvTavF7TvpwzeP6iLQUIAsvI=;
 b=owSVKIkvoPMCJ5CqnxYKMrLDBa9peQzx/bmhD1M5wNM6UFVd1QggRaUOn6kCJPD1kNc08WEKb9T9wVe7c+8+e8BX5ba6E7e79jCELn6jz1ccKxjhChxvH+04YrRtWQvVgxYLarNmev+YzSEJGjmW0TWE8EwaNevPFfHOrtXYnYW3xtrzDxWQBLGbYktZ29OmY6UcVqwxvnLI80LOWWSiASEmGSKxbrlTQ+9Gp5ehZgyuurHxwLwxIvFoLoWV8ZpZWkmp9KHta2+ORu39egLwdTR72Z7/WSAwhTGSCNvVjdMgGLy7nfK6czuLnEdBYJ4o8pu4N05Kbr+aeUuul8gdTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8568.namprd11.prod.outlook.com (2603:10b6:a03:56c::19)
 by PH0PR11MB5047.namprd11.prod.outlook.com (2603:10b6:510:3c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 1 Oct
 2026 23:03:53 +0000
Received: from SJ2PR11MB8568.namprd11.prod.outlook.com
 ([fe80::a548:ac78:60a8:8a43]) by SJ2PR11MB8568.namprd11.prod.outlook.com
 ([fe80::a548:ac78:60a8:8a43%6]) with mapi id 15.21.0451.026; Thu, 1 Oct 2026
 23:03:52 +0000
Message-ID: <abb0daee-c5f2-47c2-9b0f-6018edb0ba6b@intel.com>
Date: Thu, 1 Oct 2026 16:03:50 -0700
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
Content-Language: en-US
From: "Vadillo, Miguel" <miguel.vadillo@intel.com>
In-Reply-To: <ar6nSbS-FpaI6jYp@ashevche-desk.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0216.namprd03.prod.outlook.com
 (2603:10b6:303:b9::11) To SJ2PR11MB8568.namprd11.prod.outlook.com
 (2603:10b6:a03:56c::19)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8568:EE_|PH0PR11MB5047:EE_
X-MS-Office365-Filtering-Correlation-Id: 074745d4-388a-4fd1-bd51-08df201042c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|4143699003|6133799003|10067099003|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: 0KXJP3tAfpQ3TciIqlXxAgQugczHzEuLyy7vhvufx6uQpIzYvEU3N1dsSqZUdIH4toFs6oQFXB0h3zJ58hqyiO4TyfNmcjokFcos2n/oGniDb+73hQbFUh+QrEUR04Fjv5kMSSW6vWJdxPHcgTvpSOxnv8PSQE5vKOtrgjrUZL7gLRPlCV8BVtNoCLolsmra862GYhwUvakm7P/D+e+cvoqJb6DlZBdxSQZgiTSMWJ68IGAcOGmuom/Dy/iskmFpaU1i0eHHi09MpTVtSdLiHVqr2JMnrrRnuQtkEwRVjq9u8Fx3PY/8qGl6hpWOJ4G0o6NR3IQsCcR2E3Nt2m/UNGendy54VEzd5TNH/Hh0EhhwmnVBq8varqPXUegcvyuVdKIMzzrXn+zbJBLr3ExXodfrtorCylEet0ijCqvQUywb8mj1KCu0ydxLBbkUwgbl1EFNWc+qovCux+Z6DCZBuKvCaQ+FuT3XmLs689sl5Eqz4nVYzoW4QS53LgjKOGQ27zcSP3Hu2c/G7nvZoRSHHj8NCq/Sico38LhWSgmUpvjD24+IKFRqXggwk/57VvzU9hfdwBv8BPmFXOPzlUVhuzsW/6n2iUUS7ThaFx0D3lEkQx07bnbedA7MQYKE3OZTKdtXy54PPbZbPef9cZRQFm722AQclfpQwgSqePYXtO8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8568.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(4143699003)(6133799003)(10067099003)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3QwRTJaSUhBZjdyajZkZDlzd3M1c3Y1WitjYU5oNkVLOFRxY3dndS9idC9v?=
 =?utf-8?B?Qm1DbmZjTGlpa3RwOGJDWGZVSHM1Y0Z3VkhtQ01DUHNZbHM2WXk0bFVub2Jm?=
 =?utf-8?B?MjV5YStMMHJ3bmNWeXE2Syt3SUxtaStxdGpJVzdZWnM1dUV2ai9HWEVFRzhR?=
 =?utf-8?B?WHNBNzREV1lyZXFiZDF2a0tjMkZBOS9NTFFWNzkrQ0tON2paVXRpaEkwZ0lD?=
 =?utf-8?B?RzF1bno2VEQxVk5yR1VVVFlwRWo3dUhodTY4bk14b2VLc2Z4bjFiOGRyWWlW?=
 =?utf-8?B?TGYzUFE3cnVzVUZCb0ZXbFNGWUVXMmN2Slo5SHRNV3VOZytReVpwNFpWR1hZ?=
 =?utf-8?B?T254NHc2cU5Bc01FaGRpbWJrWk1aTEkrM0VVamt3c1k0MDVmeW53d3NHayti?=
 =?utf-8?B?LzJOd21HZmMxQzFSZHlERHlxMS9qVjZoL25TZ2Q4WGx2Y21FVGs2bWRyRDVn?=
 =?utf-8?B?cisxSVdFRm12dldRYkVja0lnaGZJMVRTajQzbjBpUzZ0eGxMaksxYS9GVE5z?=
 =?utf-8?B?bFhEMllxTnozTG5odWZZeTRHSWtyeWtJRXJQRlNkR09Oa2IyTExqUmRONXdu?=
 =?utf-8?B?UTZJVWllSFRvTDF0ZVZUZVRNektPSXJWcWlSK0g4aldEdDM3VCszZkkxR2pl?=
 =?utf-8?B?MU9iUlZnWFpDWHo0YXUyVmRUNG9uOXZJNTRHRWJya3dxb2ZhZDdMaEVWNFlx?=
 =?utf-8?B?eEtuM3R1UlBJZnlva2VZL0sxTU9oVmZKNW5ucGEvbGVRaXJHdlA5WFhWTVM5?=
 =?utf-8?B?TlJ4eE0wOFE1eENtWHNtUTZLWlUwVERVTjB2WGRTd3BiUVJ2dzAvbE9EcEky?=
 =?utf-8?B?ajRUOElxRXZWUzZCSUZadFV2bGlsMkhYKzROS3cxUGhlb1gvc0FrU0FpRlA4?=
 =?utf-8?B?VlZZOVUzL3ExVkpaMTVEbnp4VURuMFhzV2hpaGNEbUVxRG9lSWN0eVlNRy8r?=
 =?utf-8?B?bVJJZ290U2NwdnV2VUp1MEloSmtqelVzWm9SRXRhWjVSV1QyWDQrMjF0OXhF?=
 =?utf-8?B?MlduOEE1NHVSVHVqTWk5aG9yc1RzbFFkOFNKN2xSU09LZ3kvWUs0ZVNmdzhO?=
 =?utf-8?B?U0IwWHNjRk9hYnZKTmFNcDFqZkNHZDRiSkVXdUdXd2xsMUtyN0EwamJhbTFn?=
 =?utf-8?B?ZzRMeUlHWUpZMXByUjFUTGRvTU82SHJXdjNSM0NBUkloVEJlSlFjeitXd3M3?=
 =?utf-8?B?RkZtL20yZGNlUzQrbE5YWklKOGFJNzdEVjQxU1R3eHBoSlNmNjZzaXplUHZE?=
 =?utf-8?B?NStmcWN3WW9Ob1JhV1N3M1BKZ2U5bnZjdjI4dVVKUHhJZHdOZVFaRC83Nk9N?=
 =?utf-8?B?MkVGbTc4M0JseHFGb1R6ak5WTkdzSS9Cc2FPbG5BYldxbjFrRFAzcTVLS3lk?=
 =?utf-8?B?RS93YzBaQ25DZ1JYQktMbHRkVkRsK3RYUlRwSEE3Z0dzMVJmdFlCV0srUFRu?=
 =?utf-8?B?WVRweGFBaTRienpUWUNkK0Fua2VYNHkrbUZ3b1F1ZUUrVTNhK0VvaDIxRmlh?=
 =?utf-8?B?aXF6czdEMGxLMGMvRm0yL1luL2FhcnpCTjQzTWNQaXRjakYycm0wa091elVZ?=
 =?utf-8?B?TmtVRXNaY0F3Kyt3R2cwanpKKy83L1UwZHRqck5FMldjVWgvKzhFMysxS093?=
 =?utf-8?B?RWFNZ1NOc2ZrSVBSZk4xMDVmN0F3cTZMUVZEVWgzZkNYdk1CekZ3bnNKcDJJ?=
 =?utf-8?B?eGZ2WHNZUVM0T1JXR1JrTkhGYTZqZHhxRFplakVQUUwxSFpnV2FqY1FhWmpv?=
 =?utf-8?B?SjI3OEdsaVVuT3BSTUE0dmdUZ1dtTG5lV2tRa1N5Q1VWMUs4RnVYODZQeHNJ?=
 =?utf-8?B?WkVoREQrTS9iS0l6TEJZMzFEUVlRSzNIQktqb0grN2pMOWIwTERNMmFhUytJ?=
 =?utf-8?B?YnA3UkRRaXpzUFVHU0ZjYmV4YndldmdHdjEybE5pWUpPWjB6N09zSnA4aGVS?=
 =?utf-8?B?b2lVWVJXY1NtRUNvOFVkQy82bUwwUVF2bE0wSFhTUXlYYnFkZWQ2aWh1ZXJL?=
 =?utf-8?B?RWk0N2xmR1Z0NzhhcGJvYmxzV2FBVklNazhJS1VuQzJ0OENHQzlxMTNGYW44?=
 =?utf-8?B?eVhwL2duUEdqdzBvSzFob01TQ3Z5ZlZ6TSthMmc4MWZwM2djdUFCak5ZaytE?=
 =?utf-8?B?VUtFc0ZQY1l0SzljUVBrYUdRN1lEVk1ZMjZNa3BubTRxYWhUS0U2QmRTZWNj?=
 =?utf-8?B?Q21lYmNySFB2REh1L0FJSllibWg1TzZhNngzQzk3T1M3S3VlcStkMlpBUm9M?=
 =?utf-8?B?M3lBc0txQWwwR3UxSkplV2x6Q1B5cjhRL3B2R21ieDdqQXJ1aklITUF5aFFp?=
 =?utf-8?B?N1pqRzV2OGxkaW1kY0RScEhxMzFvM2hVaUE1YjVBL1JlWmxZSG9Fb2htSXhC?=
 =?utf-8?Q?c6jI8FmqofU6N52I=3D?=
X-Exchange-RoutingPolicyChecked: t4nL+r9kLTmUQB+1Sd3QyR+9hDaSuSbWTyGQyNQihNvmd2Ri7w9GiEAXR+wZgEFjys3blBa7M/Mobl5Bzbmj/3Ssedrtvv7JxELtG8Q+SkXI1vOxLqMtCAWHLufcEgS9U8q+hclrphgt3uTJQ/X7letPSZAg5lCNJvnhUHaBtjv6+Qiu2hx2CmYWWv9byMXNyL3ertuL336QsA5G7otHGbiSiMj2Met7qBw1OO4OaiJze/gEKNHizpvpIdrJNpzQWGEGcXSgCg0kOsEAmlnwrQCICtdaZz15erNJ4bFyeZzEMfM+HZhmuv4Qn77yUw/ptoHMXoMemC+s+ZnrJz9KFg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 074745d4-388a-4fd1-bd51-08df201042c2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8568.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 23:03:52.2826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p+GsNKobe7eYTsDR5Qa8nHvYAqaNHDyVa0nvJcbOYF4KbfCNeAJ/ocO4vTB2PlL7/LNXAupL7XvAbl5n68FsYlmMsVIS18kU7isfzTx1M5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5047
X-OriginatorOrg: intel.com

On 10/1/26 11:32 AM, Andy Shevchenko wrote:
> On Wed, Sep 30, 2026 at 11:21:42AM -0700, Miguel Vadillo wrote:
>> Add firmware update support for the Intel CVS device using the kernel
>> NVMem provider framework.
>>
>> Two NVMem devices are registered per CVS device:
>>   - nvm_active: read-only, exposes the active firmware version by
>>     querying the device over I2C.
>>   - nvm_non_active: write-only, root-only, accepts an incoming firmware
>>     image staged by userspace (e.g. fwupd).
>>
>> Firmware update is triggered via the nvm_authenticate sysfs attribute,
>> which supports the following write values:
>>   1 - Validate staged image, stream to device, and request reset
>>   2 - Validate and stream image only (no reset request)
>>   3 - Request reset for a previously streamed image
>>   0 - Clear update state and reset_pending flag
>>
>> On a successful write of 1 or 3, a KOBJ_CHANGE uevent is emitted and
>> nvm_reset_pending is set to signal that a device reset is required to
>> activate the new firmware.
>>
>> The nvm_version attribute exposes the running firmware version in
>> major.minor decimal format. The device_id attribute exposes the device
>> VID:PID for identification by userspace tools.
>>
>> Firmware images are streamed to the device in 256-byte or 1KB chunks
>> over I2C depending on device quirks. The staging buffer is vmalloc'd
>> on first write and released once the image has been streamed to the
>> device, or on driver remove if no update was performed.
>>
>> ABI documentation for all new sysfs attributes is added under
>> Documentation/ABI/testing/sysfs-bus-i2c-devices-cvs.
>>
>> The kernel does not inspect the firmware image contents. Signature
>> verification and anti-rollback enforcement are performed by the CVS
>> device firmware, which rejects images that fail either check.
> 
> ...
> 
>> +Date:		January 2027
>> +KernelVersion:	7.4
> 
> Tough deadline, but if there are nothing to address, you have a chance to land
> it as expected.
Thanks for your review Andy,

Yeah lets see how it goes with the feedback, if needed I'll bump...>
> ...
> 
>> +static int cvs_do_fw_download(struct icvs *ctx, const u8 *buf, size_t size)
>> +{
>> +	struct icvs_cmd cmd = { };
>> +	size_t chunk_max, chunk, pos;
>> +	int ret, end_ret;
>> +
>> +	if (ctx->quirks & ICVS_FW_BUF_SIZE_256)
>> +		chunk_max = SZ_256;
>> +	else
>> +		chunk_max = SZ_1K;
>> +
>> +	void *fw_buf __free(kfree) = kmalloc(chunk_max + sizeof(__be16),
>> +					     GFP_KERNEL);
> 
> Slightly better to read in a form of
> 
> 	void *fw_buf __free(kfree) =
> 		kmalloc(chunk_max + sizeof(__be16), GFP_KERNEL);

acked

> 
>> +	if (!fw_buf)
>> +		return -ENOMEM;
>> +
>> +	cmd.cmd_id = cpu_to_be16(ICVS_FW_LOADER_START);
>> +	ret = cvs_send(ctx, &cmd, sizeof(cmd.cmd_id), ICVS_CMD_TIMEOUT);
>> +	if (ret < 0)
>> +		return ret;
> 
> What is the meaning of the positive returned value?

There is none this was a mistake on my side. There is only 0 or 
negative. I'll fix for next version, to if (ret) and return ret ? : 
end_ret>
>> +	for (pos = 0; pos < size; pos += chunk) {
>> +		chunk = min(chunk_max, size - pos);
>> +		put_unaligned_be16(ICVS_FW_LOADER_DATA, fw_buf);
>> +		memcpy(fw_buf + sizeof(__be16), buf + pos, chunk);
>> +
>> +		ret = cvs_send(ctx, fw_buf, sizeof(__be16) + chunk,
>> +			       ICVS_CMD_TIMEOUT);
>> +		if (ret < 0) {
>> +			dev_err(cvs_dev(ctx),
>> +				"FW data chunk send failed: %d\n", ret);
>> +			break;
>> +		}
>> +	}
>> +
>> +	/* Always send FW_LOADER_END, but keep any earlier DATA error. */
>> +	cmd.cmd_id = cpu_to_be16(ICVS_FW_LOADER_END);
>> +	end_ret = cvs_send(ctx, &cmd, sizeof(cmd.cmd_id), FW_END_TIMEOUT);
>> +
>> +	return ret < 0 ? ret : end_ret;
>> +}
> 
> ...
> 
>> +	mutex_lock(&ctx->lock);
> 
> Why not guard()()? Also how ACQUIRE() macros are co-habit with goto:s?

You are right scoped_guard() should be the case here and to get rid of 
the gotos, this could be done like:
...
	scoped_guard(mutex, &ctx->lock) {
		switch (val) {
		...
		}

		nvm->auth_status = -ret;
	}

	if (ret)
		return ret;

	if (do_uevent)
		kobject_uevent(&dev->kobj, KOBJ_CHANGE);

	return count;
...

done for v2

> 
>> +	ctx->nvm.auth_status = 0;
>> +
>> +	switch (val) {
>> +	case ICVS_NVM_AUTH_CLEAR:
>> +		ctx->nvm.flushed = false;
>> +		break;
>> +
>> +	case ICVS_NVM_AUTH_WRITE_ONLY:
>> +	case ICVS_NVM_AUTH_WRITE_AND_AUTH:
>> +		ret = cvs_nvm_validate(ctx);
>> +		if (ret)
>> +			goto err_status;
>> +
>> +		ret = cvs_do_fw_download(ctx, ctx->nvm.buf_data_start,
>> +					 ctx->nvm.buf_data_size);
>> +		if (ret)
>> +			goto err_status;
>> +
>> +		ctx->nvm.flushed = true;
>> +		cvs_nvm_release_buf(&ctx->nvm);
>> +
>> +		if (val == ICVS_NVM_AUTH_WRITE_ONLY)
>> +			break;
>> +
>> +		fallthrough;
>> +
>> +	case ICVS_NVM_AUTH_AUTH_ONLY:
>> +		if (!ctx->nvm.flushed) {
>> +			ret = -ENODATA;
>> +			goto err_status;
>> +		}
>> +
>> +		do_uevent = true;
>> +		break;
>> +	}
>> +
>> +	mutex_unlock(&ctx->lock);
>> +
>> +	if (do_uevent)
>> +		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
>> +
>> +	return count;
>> +
>> +err_status:
>> +	ctx->nvm.auth_status = -ret;
>> +	mutex_unlock(&ctx->lock);
>> +
>> +	return ret;
> 
> ...
> 
>> +static const struct attribute_group *cvs_fw_groups[] = {
>> +	&cvs_fw_group,
>> +	NULL
>> +};
> 
> __ATTRIBUTE_GROUPS() ?

acked

> 
> ...
> 
>>   struct icvs {
>>   	struct i2c_client *i2c_client;
> 
>>   	int irq;
>>   	wait_queue_head_t hostwake_event;
>>   	bool hostwake_event_arg;
>> +	struct icvs_nvm nvm;
>>   };
> 
> Is `pahole` happy with the layout?

Yes. struct icvs_nvm is itself hole-free and fits in one cacheline.
That being said, there seems to be other holes in the full struct from 
the existing implementation, this order could make it better
...
	struct media_pad pads[ICVS_CSI_NUM_PADS];
	struct device_link *ipu_link;
	unsigned long quirks;
	struct gpio_desc *rst;
	struct gpio_desc *req;
	struct gpio_desc *resp;
	wait_queue_head_t hostwake_event;
	struct icvs_nvm nvm;
	struct icvs_dev_capabilities caps;
	u32 nr_of_lanes;
	enum icvs_resources res;
	int irq;
	bool prefix;
	bool hostwake_event_arg;

but maybe send as a separate patch since it is not related to the patch 
intent (?)

--
regards,
Miguel
> 

