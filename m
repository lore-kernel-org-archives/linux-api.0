Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A9F31E832;
	Thu, 27 Aug 2026 21:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787866032; cv=fail; b=r9xvJCePX7K9R1yj0tfTOfZfgFwwRKZ/I0h1ZcfIvefT6QjDMTN2bhpTkckrb0rh46IFB8kFWz/4oEDK/qI1Gyczgc3hTlAQ8HBNQmz0iCAwHizH8+Gb0qadz4a5ywd9LtjajSBFa3zXcV4Gf+vx1Y5cRf2SlIf1vmvcnyTQTZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787866032; c=relaxed/simple;
	bh=5p0UUdLiWAzacBPNJ0/K2cExFuZUFIUGvkv/0SRtqfk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FndD4CZaLWHPkaFpyEstqMD1z4lMakTs/eaL7ucjEDvrqmLs1qDNYEQIoacFzTzyURqX6HuRfZcrw6aliTJmPSSvsqRyARvK7Ful/BOvl1ZIVAhMJFsIiJ4ogLf9JvZs+mtXJsTTpQUsxHWw76r3XfSTs9llZVtfkG1cYpFXKns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AdRechP1; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AdRechP1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787866030; x=1819402030;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5p0UUdLiWAzacBPNJ0/K2cExFuZUFIUGvkv/0SRtqfk=;
  b=AdRechP10eyey0oeheTfmFOLJp20OgLcaIL1j1qLW3pMmp0tuDqVplkP
   6FzOMvngWUK/o7dH8dmSOpsMzTQG56foTv5so120EnGLAARLlRuw73AnU
   FW6Mxj0m/yRQlExGvapRjHamVcKPIi9n6Kaz3NGQve6J+tjdAwFwSZEYI
   Hzzj74Xc5L15YWhJ5FTZLBHxmMou1Bf/N9pqtQSdWYXBOgTuMgXxeGTHI
   7S5dYKetk2DMSp56goLwvH3BqitYBonFylCGHrnM8Nayx5oBj6yACLrC/
   JNItc3IK71s2/S+EIwTSFHuVQX6QMjhDlvDkuQm9rpvD/UIKvzPcbfWaM
   w==;
X-CSE-ConnectionGUID: WdtdS2NKQ8itNxGk7dvPuA==
X-CSE-MsgGUID: g1N3eNcqQbG/u7poLlaY2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="88400942"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="88400942"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 14:27:10 -0700
X-CSE-ConnectionGUID: LWnnqY2KQlmJ1nw3At/hWQ==
X-CSE-MsgGUID: PkiJ2zlMSgCwyYno5FrZJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="267387529"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 14:27:09 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 14:27:09 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 27 Aug 2026 14:27:09 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.24) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 14:27:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lAlF++RwL004K2U1wPCNl9lew4HeFBKVOQ2nZZ1RkIVdMWvln7j8IcLoLPKnVOc2STtAiyns2h4/T0Wk6dXyXWXkRk1d0NQNCCYLbeI3B7gdNcNLZAIw1i2kXnaef5zZBqHJM0CDapw899myi+6AZCnFwoMfY4EbFLysApI9bTvryMpY9gP7YjgePrkXFCZAC9zR8NBydzKXnKr04XmKZmS6QGndM8tJynmHudf5FnaWCozAddN2VIwWalFXVecDls8b64EcWRnA80vCRwHoNmr7Vl54U4yoOY9SRuMQWoGwnvvZDr78NjbSQcfzxWu6kQHnl4aZhOZ2xpr5eghoyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5p0UUdLiWAzacBPNJ0/K2cExFuZUFIUGvkv/0SRtqfk=;
 b=ZNEnJ981VRRgGG78jq0uMCs2sLvDTYHbILGTBdHzSVW8qw5i0dtSfB5aIVcB1q0rvEHk3B688IuG8mDORtHRIxrrurTJoCJTeDWS4fpnu/UJ2tIec+YeaRipOkjcQDKED8Pa3b2wBZ/DIT0FtLQulyKbxaTCnRHtTs3huiVGZS6KvPO3yKzXn5EGJEgr7qvMIA/sCrprGXqmHyXkEMpZ8olyWwHQfKegloV+yhNfTY1QwruszOE/gBkFkI1Tpetm4wtpoRLbc2bBIwzlJcMOAjcgaIfx7zJxkP9q4/1kbchNyEVZxaYucL7fd1VaI3C9WBVJXR/M/0vG0OQ/VsdgGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20)
 by CO1PR11MB4867.namprd11.prod.outlook.com (2603:10b6:303:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 21:27:07 +0000
Received: from PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4]) by PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4%4]) with mapi id 15.21.0339.012; Thu, 27 Aug 2026
 21:27:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "broonie@kernel.org" <broonie@kernel.org>, "bill.roberts@foss.arm.com"
	<bill.roberts@foss.arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "debug@rivosinc.com" <debug@rivosinc.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: Shadow Stack Locking Semantics between arch's
Thread-Topic: Shadow Stack Locking Semantics between arch's
Thread-Index: AQHdNkfbtZ5ZknJJAkKNElU5hV4EXbayLRYAgAAGJgCAADXRgA==
Date: Thu, 27 Aug 2026 21:27:06 +0000
Message-ID: <01b0fe86d5700847f78b0e6f839119f54ac88b04.camel@intel.com>
References: <a1946d93-370e-4ca9-85d6-60b4a20ffd47@arm.com>
	 <3bb672e0-7bc3-434f-904e-aa00394dd01f@foss.arm.com>
	 <d20ccb74-69ed-45d7-a810-846904873588@sirena.org.uk>
In-Reply-To: <d20ccb74-69ed-45d7-a810-846904873588@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6771:EE_|CO1PR11MB4867:EE_
x-ms-office365-filtering-correlation-id: 057aca82-6e70-4cd8-3ccb-08df0481f218
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|38070700021|22082099003|10067099003|56012099006|11063799006|4143699003|18002099003;
x-microsoft-antispam-message-info: TtRu3u3DQqFWbbzaczr5yfPtKTlIp7M8OcqhOpgYtHSpW+5MjD7RCCaavoXGM81+1FdzVhkoFAzvEaDreWaqYyKH+6KdbqG7PsuOZNYeRCIlG0IEp6hNZ8a9uS2084REJna/kHKGh27qNUwjZJxi4dZBsbHtoJjulwKNIs4SujGYE4JQ/+ukujf4OSHymVGJtQkc3DIYud1JuWnjY50X5j8kdSg89ZANXpIDlDzWB/ipbGbgqwwALrx71VQQ2ikcG8Zr3ngYQ1sgREgYvwhHzvEz9MimQVPFFFc6pXmRbalyZQqsdL5YudjSwtO9RDyQcDTIBpWQZIkFLAZhnAqwX3UAYyOwUdFK5yhftMFjMZ18QNLNlczjXUIfCijfqHIRWrkVxrvBMqKbqKWYNmjoox6QyaaGf+wrc66iZpzeS88R2r9cFawf2iU3wf42sTmuknWIGWSSS3s3ZTxOPcZLN2ZynBPHsqMy7sXfmznSv6Qk85ljyH/7BT9XdcGF1xZxCihbPE/zxMr1oCsVdS8gVWTUdKTRw7XNHsxGxx/BzVx9KOkGFgJOYXn1tWyKlG/C1MhQvgiO6x7d6OQdfa1dVWYj1pZkfD31q24QqYH8hErZS1zwTJTl6yngQojM4cECanha2AIySSIc3flPLq9TmTNgL0h3iKdiOeEj1bRI1clMvMCOyQF+6X9B8GYvESOzY1i4YCpMLsud/xY2p3Kd38i0ZjJXpwMY7HWETOcCA8I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(38070700021)(22082099003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmZiSnhUMVlycGdrdC9na2RUU3JNd2VPdlVhY3BsTURDZitSMitua1ltN2RN?=
 =?utf-8?B?cXVVVE8rZmlWRkFxSnYwY1d4QjVaR01oWFpBNStOVExxUnBiTjZ2QW9wc2kw?=
 =?utf-8?B?VkNsWmoxS2RJbEV0T3lQT0E1WmpBbTB2TjdLOHkwUm1JL0FZYjdmcWxVUisr?=
 =?utf-8?B?Q0NKY2wzTmFISlc4L1E0UVMya3U4ak80Vjh5WjRqTDhDL2ZCRDV1QkJzbTRP?=
 =?utf-8?B?Tms3Yk4rMjAyRFMzN09IRWE5OWJsKzYvSmFrMFFEVU5Xdkl2NUMxV01RaS9N?=
 =?utf-8?B?UmRTTEJkcTB0OFRrVlJtL1dZUFEvSU4vSVRBZjBzUEpSanpHR3EwM3hldWlx?=
 =?utf-8?B?T2VJcFMwczdnazdiS3NkRDBGazdmMlNCSHRmenRvd0J0SnNzN1crYjVCZ01I?=
 =?utf-8?B?NXlqL1RYbUZXaGNHcVluL2VQOFdkSlE5ZWJHeWdTaXl6QlptUDlKYjBXR2FR?=
 =?utf-8?B?L3VjdkRldmtQRWRQb29hTHRlR2JLK0o2ZCtQWFNkRFZPNGFPWERzMWl5M1Jl?=
 =?utf-8?B?NnJieVozcmorM0dpWnJrSStXOEFOcnhsWFFrOWt5c3hFNmlkcEk4QTkzMmRU?=
 =?utf-8?B?aDVrai9RQ0VDTGJ4ejFiNkpmSVNldE9ZUHRRT0tYcCtPWXFJK0xDMU53cTM3?=
 =?utf-8?B?eGZOdFM5R0tCSCthTlkxVlVZZlNpeTBuSnJXSTJIYVlyRkdRRjFWOEk1d1Zl?=
 =?utf-8?B?VmdCK1lTK3J3a0IyV01FaENpUFk2Y2JsSWZrd2FLUmJxcUUyeTVORnU1L2Mw?=
 =?utf-8?B?RzRDZzV4cXVDb2hRZEh4N0pyM1RvSkJJME81YjZtczhFUzdTQnlqdG9lakow?=
 =?utf-8?B?MFR1Q1AvYWV1US94d3VqR0JaZmFlcjR3d1N1NVFzTDhDTzZFSGYrMmxMSDlU?=
 =?utf-8?B?WWtIRWgxWXUreEkvZ1lkbE5zQlJpMFVCdm9ncllsVDd2Y2dyNXVJaGdxYUVa?=
 =?utf-8?B?ZWdSS3VXZG51TEs4ekREQ2w5ZFdZZkxacUVJQlpLSEVaS1lSWU1vQkljZ3Nv?=
 =?utf-8?B?MFdIVEs3MDVGejZpeU05eHI0dzJ5aFY2Y3ltUVVpbDJWNDJVVFZGV3cvNDhX?=
 =?utf-8?B?NVVaK3FnaklGMGZjSnZ2d0hBRDZDZGpaNEUwL1NiWEc0Nlp1ZVZ2UHdQb2Nr?=
 =?utf-8?B?RFVZL0tybXQ3OUFHLy9BMDFqcUdKVTNUSzdaelNkQTBoRzN6ZkkzYklZU2pH?=
 =?utf-8?B?MjkrSjBkMTJyNnAzZG5mc2dSVWlMdDREUFcrOVc1eEQwbkx0RE5pcUQyWlFa?=
 =?utf-8?B?bFFxK3ZGUXk4a2JtM2xQbnhnZXhGQWZPdmN1NnZxUG5mTEVQR3dMZFZDdC9U?=
 =?utf-8?B?YjZvWHlLcGdXUVpkcnZQNlJvT0E0MTZsbXM1SVFjM1dKNGduVmJtL3hUVXlG?=
 =?utf-8?B?bHduQndkMFBITEZSd1J4bE9Kd3NVMUVxZG52U2dlSUxqYkI0ZUpKZEoxSk0v?=
 =?utf-8?B?eXJueWlqVmRSMEVxT3M1a2hSaFVVbnJUNTFJbUx2YS9UQ0MydmVDK1d4QVNl?=
 =?utf-8?B?aHlPR2xiNlFkQ3lUSDY3RFhTZ1FCY3VCaU4xOWFFa2E0SnR2azYwcmkzZVRZ?=
 =?utf-8?B?Tlo3NzI4ZVJjeSs0RFgyRmE4RU9meFI2Z2ZvMTN1VXJBY1V4YXNIc1Z6a29C?=
 =?utf-8?B?ZDcxcFZaenB2aEM4bHpxQkNoTnJIaGVVTmxvcUI3Vmx3MTZZZDJ2eUtnVkdj?=
 =?utf-8?B?NDNmQ0l4MDhkYXBnSDUwMDFaWGdXSHZQQUp2cmZlTjlxajhxK1dwYnlDN1pa?=
 =?utf-8?B?WmdVdDhJdU9tZTlBNE9vN0dKWkpjcWltUDUyajJKWVhHRlY1L01qZ0ZmMTJB?=
 =?utf-8?B?elNwL2hBeUlSN1RGaThTTEtjcnVvYVozOTMrc05Pdlh0TEZZdGc0VStudjNq?=
 =?utf-8?B?NU9VSTlaQU8wMUlmVUQ4UWVYZnpmSmU5UDBIdWJZRTRRWVF6c0llWU9hK3Vt?=
 =?utf-8?B?Rmw1RW5vMVdxQmRnWk16T3dlSTYxZEdzVENHVTc4d0VlM3RZaENCS2dobytl?=
 =?utf-8?B?cWIyeGo3TlI4S0lYTCtFdCtsSmFaMW03WjVSZVhOYi9ISjI2Tm5iemJCeUt2?=
 =?utf-8?B?UVJMQisrYnhROGxEc2ZxaUNUTnhqVC9wc0N1MGRZZDJSMzlVUUVnUU5wTGpN?=
 =?utf-8?B?NmFudXNiM0JrZHB3dTAwWWM5NzNHWUFGTE5OaXllZE5RbVU2ZTc5dGVZclRJ?=
 =?utf-8?B?QTErbUVGeFlhV0VZMEU0MTdZak9FVVZtNjhGdDViYXNYVHQxZWM3LzhjdWRN?=
 =?utf-8?B?eXFoV3hMM3RWRzNWNmk0eDFzWC80VXlIcWhrdlRlL0UxUVlqRW5VVHp2aXZS?=
 =?utf-8?B?ZEdTdk8vZ2lNOFhvd0pqN1l2VDdSZVRVWWRFMWtRUFhBdXhlejFSbVRIZTM1?=
 =?utf-8?Q?bcTNCdEdnxDeb6AA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <109B54FEBD59654997769CFB1048A60C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: l3CZT9ZrpbqqcjZd6x8zPD3SdTbEJXV4VEaxEHaR3O///v4YPkbDD13E3rhTlT+nnANyeagZdliK9OpdekY/b+uRY/UlUFLiG/El3zwJZUkv0i60umRPb0LybGZKPm9RrhJmZOQUDdakyeZ7rXwxMFEs2C4hwXrkd6TrUzRI2blXV+l+C9/N74t6BCIfg2bT9ej5o59eAoICs+hsNMG2oIZJCE0lnomx/bONjzMgL4FfXM4HZK1XlDx+CEyyJS+GnhpnaFY8opdBFMTnAmUTcuhDCtGnHho5kv9WjCN57fAPYbK/sGq2WPVMS5De30gYw0nsp5PDVLl7yT7djRKPcA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 057aca82-6e70-4cd8-3ccb-08df0481f218
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2026 21:27:06.8473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BmYv3Ql+f7+GNdhElAGqX/2Axj/KSvKG5WYOM6iqp2d2Lu+RWEHD3GWR/DtizbS9YqFdWSC+Y4N0njU1kKEZ7w5HYOjJpCCPhfVDyPFgALM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4867
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI2LTA4LTI3IGF0IDE5OjE0ICswMTAwLCBNYXJrIEJyb3duIHdyb3RlOg0KPiBP
biBUaHUsIEF1ZyAyNywgMjAyNiBhdCAxMjo1MjoyOFBNIC0wNTAwLCBCaWxsIFJvYmVydHMgd3Jv
dGU6DQo+IA0KPiA+IEkgaGF2ZSBub3RpY2VkIHNvbWUgc2VtYW50aWMgZGlmZmVyZW5jZXMgYmV0
d2VlbiB0aGUgYXJjaGVzLiBHaXZlbiB0aGlzDQo+ID4gZXhhbXBsZSBvZiBjdXJyZW50IHRocmVh
ZCBzdGF0ZSwgY3VycmVudCB0aHJlYWQgbG9ja2luZyBzdGF0ZSBhbmQgdGhlDQo+ID4gbmV3IGZl
YXR1cmVzIHJlcXVlc3RlZCwgYXMgc2hvd24gYmVsb3c6DQo+IA0KPiA+IHVuc2lnbmVkIGxvbmcg
bG9ja2VkID0gMHgyOyAvLyBLZXJuZWwgVGFzayBTdGF0ZSAtPiBMT0NLIFdSSVRFDQo+ID4gdW5z
aWduZWQgbG9uZyBjdXJfdmFsID0gMHgzOyAvLyBLZXJuZWwgVGFzayBTdGF0ZSAtPiBXUklURSBh
bmQgU0hBRE9XU1RBQ0sNCj4gPiBFTkFCTEVEDQo+ID4gdW5zaWduZWQgbG9uZyBuZXdfdmFsID0g
MHgwOyAvLyBVc2Vyc3BhY2UgRmVhdHVyZSBDaGFuZ2UgdmlhIHN5c2NhbGwgLT4NCj4gPiBESVNB
QkxFDQo+IA0KPiA+ID4geDg2LTY0IHwgcmlzYy12IHwgYXJtNjQgfA0KPiA+ID4gLS0tLS0tLS0t
LSB8IC0tLS0tLS0tIHwgLS0tLS0tLS0tIHwNCj4gPiA+IFdvcmtzwqAgfCBGYWlsc8KgIHwgRmFp
bHPCoCDCoCDCoHwNCj4gDQo+IEkgd291bGQgbm90IGhhdmUgZXhwZWN0ZWQgdGhhdCBjb21iaW5h
dGlvbiB0byB3b3JrIGF0IGFsbCB3aXRoIHRoZQ0KPiBwcmN0bCgpIChhcyBvcHBvc2VkIHRvIGFy
Y2hfcHJjdGwoKSkgaW50ZXJmYWNlIFRCSCwgaWYgeW91J3ZlIGxvY2tlZA0KPiB3cml0ZSBvbiB5
b3Ugc2hvdWxkbid0IGJlIGFibGUgdG8gZGlzYWJsZSBpdC4gIFRoZSByZWFzb24gdGhhdCB3b3Jr
cyBvbg0KPiB4ODYgYXQgdGhlIG1pbnV0ZSBpcyB0aGF0IGZvciB4ODYgeW91IGNhbiBvbmx5IGNo
YW5nZSBvbmUgYml0IGF0IGEgdGltZQ0KPiBzbyB0aGUgbmV3IHZhbHVlIHdoZW4gZGlzYWJsaW5n
IGlzIGVmZmVjdGl2ZWx5IDB4Miwgbm90IDB4MC4NCg0KbWFrZXMgc2Vuc2UuDQoNCj4gDQo+ID4g
SSBhbSBwcm9wb3NpbmcgYW5kIGhhdmUgcXVlc3Rpb25zIG92ZXIgdGhlIGZvbGxvd2luZzoNCj4g
PiAxLiBXaGF0IHNob3VsZCB0aGUgYmVoYXZpb3IgYmUgaWYgeW91IGhhZCB3cml0ZSBsb2NrZWQg
YW5kIGRpc2FibGUgdGhlDQo+ID4gc2hhZG93IHN0YWNrPw0KPiA+IMKgIC0gSSBjYW4gYXJndWUg
Ym90aCB3YXlzIGhlcmUsIC1FUEVSTSBvciBzdWNjZXNzLiBJIHRoaW5rIEkgYW5kIG1vc3QgYXJj
aGVzDQo+ID4gbGVhZCB0byBmYWlsdXJlLg0KPiANCj4gR2l2ZW4gdGhhdCBSSVNDLVYgZG9lc24n
dCBzdXBwb3J0IGNvbnRyb2wgb2Ygd3JpdGVzIGl0J3MgbW9vdCB0aGVyZQ0KPiBhdCB0aGUgbWlu
dXRlLCBhbmQgeDg2IGN1cnJlbnRseSB1c2VzIGFyY2hfcHJjdGwoKSBzbyB3aWxsIG5lZWQgYW4N
Cj4gYWRkaXRpb25hbCBBUEksIGl0IHNlZW1zIHRoZSBwYXRoIG9mIGxlYXN0IHJlc2lzdGFuY2Ug
aXMgdG8gYWxsb3cgaXQuDQo+IFRoaXMgYWxzbyBhdm9pZHMgbG9ja2luZyB3cml0ZXMgKG9yIHB1
c2hlcywgZm9yIGFybTY0KSBvbiBlZmZlY3RpdmVseQ0KPiBhbHNvIGxvY2tpbmcgZW5hYmxlIHdo
aWNoIHNlZW1zIG5lYXRlci4NCg0KSG1tLiBJIGNhbid0IHRoaW5rIG9mIGEgcmVhc29uIHRvIGxv
Y2sgd3JpdGVzIGFuZCBub3QgbG9jayBzaGFkb3cgc3RhY2sgdG9vLg0KR2l2ZW4gbGlrZWx5IG5v
IG9uZSBpcyBkb2luZyB0aGlzLCBJIHdvbmRlciBpZiB3ZSBjb3VsZCBjaGFuZ2UgeDg2J3MgYmVo
YXZpb3IgdG8NCm1hdGNoIHRoZSBvdGhlcnM/DQoNClRoZSBBUEkgd291bGQgbWFrZXMgbW9yZSBz
ZW5zZSB0byBwcmV2ZW50IGRpc2FibGluZyBzaGFkb3cgc3RhY2sgaWYgd3JpdGVzIHdlcmUNCmVu
YWJsZWQuIEl0IGNvdWxkIHJldHVybiBhbiBFSU5WQUwgcmVnYXJkbGVzcyBpZiBpdCBpcyBsb2Nr
ZWQgb3Igbm90PyBJcyB0aGF0DQp0aGUgYXJtIGJlaGF2aW9yIChmb3JnZXR0aW5nIGFib3V0IGxv
Y2tlZCk/DQoNCg0KPiANCj4gPiAyLiByaXNjdiBzaG91bGQgY2hlY2sgdGhhdCB0aGUgbG93IGJp
dCBpcyBzZXQgaW4gbG9ja2luZyBub3QganVzdCB0aGF0IGl0cw0KPiA+IDAsIGl0IHNob3VsZCBi
ZSAxDQo+IA0KPiBJIHRoaW5rIGZvciBBQkkgY29tcGF0aWJpbGl0eSBSSVNDLVYgd2lsbCBoYXZl
IHRvIGNvbnRpbnVlIGFjY2VwdGluZyAwDQo+IGFzIGJlaW5nIGVxdWl2YWxlbnQgdG8gbG9ja2lu
ZyBQUl9TSEFET1dfU1RBQ0tfRU5BQkxFIChvciBldmVyeXRoaW5nLA0KPiBidXQgaXQgb25seSBz
dXBwb3J0cyB0aGF0IG9uZSBiaXQgcmlnaHQgbm93KS4NCj4gDQo+ID4gMy4gcmlzY3Ygc2hvdWxk
IHJldHVybiAtRVBFUk0gdnMgLUVJTlZBTA0KPiANCj4gSWYgeW91IG1lYW4gZm9yIGFyY2hfbG9j
a19zaGFkb3dfc3RhY2tfc3RhdHVzKCkgSSB0aGluayAtRUlOVkFMIGlzIGENCj4gc2Vuc2libGUg
ZXJyb3IgY29kZSB3aGVuIHRoZSBzeXN0ZW0gb3IgdGFzayBkb2VzIG5vdCBzdXBwb3J0IHNoYWRv
dw0KPiBzdGFja3MsIEknbSBub3Qgc3VyZSB3ZSBzaG91bGQgcmV0dXJuIC1FUEVSTSBhdCBhbGwu
ICBPbiBhcm02NCB3ZQ0KPiBzdXBwb3J0IGxvY2tpbmcgYW55IGJpdCwgbm90IGp1c3QgdGhlIG9u
ZXMgdGhhdCB3ZSBjdXJyZW50bHkga25vdyBhYm91dC4NCj4gVGhpcyBpcyBmb3IgZnV0dXJlIHBy
b29maW5nLCB1c2Vyc3BhY2UgY2FuIGxvY2sgdW5rbm93biBmbGFncy4NCj4gDQo+ID4gSWYgd2Ug
Y2FuIGFsbCBhZ3JlZSBvbiBpdGVtIDEsIHRoYXQgbG9ja2VkIGJpdHMgY2hlY2sgY2FuIGJlIHJl
ZmFjdG9yZWQgYW5kDQo+ID4gc2hhcmVkIGluIG9uZSBvZg0KPiA+IHR3byB3YXlzOg0KPiA+IDEu
IHdpdGhpbiBwcmN0bCBpdHNlbGYsIGJlZm9yZSB0aGUgYXJjaCBob29rIGlzIGNhbGxlZCwgd2Ug
d291bGQgbmVlZA0KPiA+IGhlbHBlcnMgcGVyLWFyY2ggdG8gZXh0cmFjdCB0aGUgdGhyZWFkIGZl
YXR1cmVzIGFuZCBsb2NrIGJpdHMNCj4gPiAyLiBhcyBhIGhlbHBlciB3aGVyZSBmb2xrcyBqdXN0
IHBhc3MgdGhlIHVuc2lnbmVkIGxvbmcgb2YgdGhlIGJpdHMgdG8gZ2V0DQo+ID4gdGhlIHJlc3Vs
dA0KPiANCj4gRm9yIG1lIG9wdGlvbiAxIHNlZW1zIGEgYml0IG5pY2VyLCBhbmQgbW92ZXMgbW9y
ZSBvZiB0aGUgaW1wbGVtZW50YXRpb24NCj4gaW50byBnZW5lcmljIGNvZGUgd2hpY2ggaXMgc29t
ZXRoaW5nIHdlIHNob3VsZCByZWFsbHkgYmUgZG9pbmcgaW4NCj4gZ2VuZXJhbCB3aXRoIHRoZSBz
aGFkb3cgc3RhY2sgc3VwcG9ydCAtIHRoZXJlJ3MgYSBsb3Qgb2YgY3Jvc3MgYXJjaA0KPiBkdXBs
aWNhdGlvbiBhdCB0aGUgbWludXRlLiDCoA0KPiANCg0KKzENCg0KPiBJdCBoYXMgYmVlbiBvbiBt
eSBsaXN0IHRvIGxvb2sgYXQgdGhpcw0KPiByZXBpdGl0aW9uIGF0IHNvbWUgcG9pbnQsIGl0IGhh
ZCBiZWVuIGhlbGQgdXAgYnkgdGhlIGNsb25lMygpIHN0dWZmIGJ1dA0KPiB0aGF0IHNlZW1zIHRv
IGhhdmUgZGllZCBhIGRlYXRoIGZvciBub3cuDQoNCk9oPyBXaGF0IHdhcyB0aGUgYmxvY2tlcj8N
Cg==
