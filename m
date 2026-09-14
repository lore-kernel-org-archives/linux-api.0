Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3467E3EB81E;
	Mon, 14 Sep 2026 07:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789372289; cv=fail; b=DSGR274FvWsRgf6mhy+HfARFFPEPByU/Hk6SykbfxrWyv8mPNSnByG4k4iHSd8EMxbuU0W6RRx6tPq2IMgGFL7CH2prJHvGReJrOnpwiSdGlbHXx6SNGjdIbp5vhqizcxgv9DlWzmtzKHRcVnRRV1uwgHmSPMQR+yVHO3x2qjfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789372289; c=relaxed/simple;
	bh=umjxXrVgP8ZDeKZA6SrBVRGggOLggyt3BGgNyGpKsaI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VTeZvo0O/vPkthlycZ7OWRO4jPCsdCE5Ayn/bStdfkTz8dbHrVry4hStZNergiY0bczthsU7zz0OGxmi/sGN4Z6bnNNPmzOBE4SL+ZYBkk74TfUQm6l/mWmfM3/tgxBp7xiU5rdHDdHjcKhPs+g3cFtIzlauZySV6U/wlFesxzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=efC7WoN0; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="efC7WoN0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789372286; x=1820908286;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=umjxXrVgP8ZDeKZA6SrBVRGggOLggyt3BGgNyGpKsaI=;
  b=efC7WoN0VTcVR6BDrIM7hNWDhaAE/21yfG/VfQhBKq537lEu+XcYbgHT
   PCYwZ6zDZCWt4qEwCW5dTZLs/sRqkAGUWe7prszuIlh3Ndv8KOElbNWlp
   M9BXGznqE38svf+EkiZoFhC2lOgKPio/qZGicnmilmt7rwmU241M4I6MG
   wCmAwVEeCvPRNHKjbAAvGkyU539WBJ0aI28xwi2Z5qQxODwNznt1EeoCF
   BIkPMTXHwcUtAZIM9DExkWlg0LQ/CREW+QgyeIvHp0Z+HWEKFWP9dyn3y
   +xKfHJ6A+qIR0CI2xRXPIlyVGoeCthTKWWIu90S6OpV11TXT91R64XD6g
   A==;
X-CSE-ConnectionGUID: 1EO8r9UXRs+drhak7Jq/gA==
X-CSE-MsgGUID: EwvCCel9SeqytqKsl6tmQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11904"; a="93416311"
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="93416311"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 00:51:26 -0700
X-CSE-ConnectionGUID: k9QaNNqbQdmRCtS9vsEMDg==
X-CSE-MsgGUID: /eELFkq6QYKvULJn+VaKeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="269941834"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 00:51:25 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 00:51:25 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 00:51:25 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.54) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 00:51:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f89gNkIDXV7SaDkKoWfV6Ideyg/mgVbm3A7M1T+qeZ99APW/wgV+unJiLvUEpWODePjh6D0oHABgwUqM45cbRYIjbVgIcLGTc2G1aNiYQHTLhKAqrgrgpo9xGQcN8BbLdTVFigv37yk7Qse+2uhBayW55EpllB28JIF9ZXjexfXrXSQRUIyyMjbsQsCi1koh3tdXNU5CVbNhfA6ntWFGBOyrDjkSz1O2AiZG6Qy7KNp9/HNOmSd10iNs1LLr5JqOAamo9yyjoiPaPS3LsVeSdmCztnzS7QykBeRD1E0XUXAY4rL31ws8VoVROrzieyP6fFpUvVjMwlm+jGaiCKvoEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ad2Xp6R4omUZs6ZM59Dnrd+AJGKd3NKYfEoRubel7xQ=;
 b=RsHtvL9xUkldJbNlkJ/nGOAclwcDPjW2yptAHYLoGZQMZKK0MT5HRHaOQAgHZWPrD3wt+l+WIp6wtzRQHvYupqFfgDYZyxx6puEG2AxnKwPJ5OsWopRwmQTEfA3o5WmEhrmufONCKsZ5xMNca8PhJbbfd5cVr/6+bACqwPqnVOZS5sgGEleU0AEHzcuchLthbmmUybHu9f4AQ78iqhD4XJhQTLd769RbDWQkRdvKf9y6RlyqpdGchjZN8ThSPtQ3BS/CKX0nSrg+tzTqDmU9bMCCc+M/Rf9j5BSwhYP8VlhyfzFiiT33SG42CaRW+NMcNsgTXjZBkXgUuHeeh9qqag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB9534.namprd11.prod.outlook.com (2603:10b6:510:39f::22)
 by DM6PR11MB4737.namprd11.prod.outlook.com (2603:10b6:5:2a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 07:51:20 +0000
Received: from PH8PR11MB9534.namprd11.prod.outlook.com
 ([fe80::16ca:6958:c9e9:a266]) by PH8PR11MB9534.namprd11.prod.outlook.com
 ([fe80::16ca:6958:c9e9:a266%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 07:51:20 +0000
Date: Mon, 14 Sep 2026 09:51:12 +0200
From: Francois Dugast <francois.dugast@intel.com>
To: Petr Pavlu <petr.pavlu@suse.com>
CC: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, "Andrew
 Lunn" <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jani Nikula
	<jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, "Joonas
 Lahtinen" <joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin
	<tursulin@ursulin.net>, Matthew Brost <matthew.brost@intel.com>, Thomas
 =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>, Simon Horman
	<horms@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez
	<da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin
	<atomlin@atomlin.com>, <linux-block@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-api@vger.kernel.org>,
	<intel-gfx@lists.freedesktop.org>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-modules@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drm/i915: Include error-injection.h for
 ALLOW_ERROR_INJECTION()
Message-ID: <aqencKrPMiB-GWY5@fdugast-desk>
References: <20260911-module-include-error_injection-v1-0-5da895d8c84d@suse.com>
 <20260911-module-include-error_injection-v1-4-5da895d8c84d@suse.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260911-module-include-error_injection-v1-4-5da895d8c84d@suse.com>
Organization: Intel Corporation
X-ClientProxiedBy: DU7PR01CA0011.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::14) To PH8PR11MB9534.namprd11.prod.outlook.com
 (2603:10b6:510:39f::22)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB9534:EE_|DM6PR11MB4737:EE_
X-MS-Office365-Filtering-Correlation-Id: 91491f05-ba36-490f-0359-08df1234f748
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: H6jJcgF0/r2ntKmle8LBQsb0KO+TxyCu6d8c3bPLFPGuK4E59l7QPxL/L/1COzpQLiScEVc9xNG9+3qEK2Bi/23faJ3nGgYMSEiA0/rvFGx8C5j68Ed1e+zdCFTvsY4oyCOnQWk7vVB9eMrcPSg8URfhfAtcZwX5V8k7FV+HewDXnCN9PuIGgNjMQA1ZJAESxm8uip0nK0IXive0VZX7FnN5nSDga8znVfXGjoUCnRbfyDgaTr6/Ap831j8fAMcl7qCkzRYzxswGPVaYdCcbABOYeygKxKt83pbKSVKy57Uje2jmKkPq+f150yEkB5S8OeXw/aB83+p03VrUYY+RxHLgyPyo3nE4rihczdJUXKB65OJ+d83gbuO5k59+uVLS6sS5Vm5j9snrHitKjO1rBJVOq/BKhbBFdLBlMh5IXejpS4cPanNJhRI3O3R7fR+encXkXk7b7aJViZ2hWDXB1iUDg3EnwDcUqizKqoNqiRRfq/Oup4behSCCmmd7jXM/UCn0/o2jWXe7swXvhrccuPXvy1Lo3Hbw2HxdMYAQJ9ZMAUGldb+xeD56ZqUzgUizPv3S8Ly/koxgdmFsU5Bb3M2CvhWPiXeQESYbxqvoA7AHbdMw47CQYFbz5n6lrqLGy7PYGEpmOuvY8Y1RxGvm194rr+rb2GHbCkoA4UGvcx4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB9534.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?6VxlagFGdMBeLMtuAHKHfSlHM7DaZ9aIrTzrc3sQI6fZKqtT1f29HJ9ADI?=
 =?iso-8859-1?Q?gAPT0IbRw87iibIw35yiW1RaB3TjZQsKBffY4oSC48nCr1GRWiZqsEp1xQ?=
 =?iso-8859-1?Q?QABFJGcrXXMalHINux/UboUxaJw6euXvv1gDAqLh8uHSV4IelJz24BlpTZ?=
 =?iso-8859-1?Q?lyb2yYM0l+nu3ZI/vrwLdsGManDUkN2Az5SgdLh/CtcXMKPJ35JCmU3hPj?=
 =?iso-8859-1?Q?GfAUzX/VbLO3x7aw3sOl4fm/2pEnJ8QtzT+DTS8OYAccZhuROE3G431flX?=
 =?iso-8859-1?Q?nR8MhR+o8VKAMjNTuy+Fub3l7Wws00NJ+LBuILQK5MTymEUbmzAsFECMRl?=
 =?iso-8859-1?Q?VNyonTxD9MvUTyGvEYveFjkVsXgP1UaGBPuXJ1C7DMr7MRuyHLBbuTSKoq?=
 =?iso-8859-1?Q?7kqjwx38TV+mPEKY0HNXu0OH8jD5CnOkLtKhymFw/upZHJEW2wJcWoMWVD?=
 =?iso-8859-1?Q?OdiEbwuNNKolsxJdCB403sdhx7b9fKiAqcViwNxHbtd9yivYFcQgE13O0W?=
 =?iso-8859-1?Q?2mBBCCA4MWaOJTzcx8PorCEKkGs7dxyBmy6FnvOGw1bInkFlfveAVkn4gZ?=
 =?iso-8859-1?Q?H0MytB/pJbtBqO5iwy9RDk5ACIxj1BhMaqUn7e5vB3IDWKdkSpUj3zn+MS?=
 =?iso-8859-1?Q?AoEuilAFILrq0jOHXPSG99BUtx8zRiYsgt6UWszLAi2zLMiph2aFcpBc78?=
 =?iso-8859-1?Q?4OtMZkqxnVaqMiK6ZIcCfjkTZV7lmZOXUIn4FnToop35rFZGDERbevAFJ1?=
 =?iso-8859-1?Q?xaDPZfjH4QaVxVHApvGeMCDiGJZ30VipoqOGvSFNNADAKr3NejpCbpNH5w?=
 =?iso-8859-1?Q?sNet86qUkuehv0wIUMMFp3BpeBhy0h0raj27mellBY3Jgpru3IW66UAOli?=
 =?iso-8859-1?Q?qqzSnJFlqab3WZR7CFodPtuY0L7C8hKHhEoz1v09N+xBu3L3q5MhwotsPE?=
 =?iso-8859-1?Q?caHEEhVTBW4jYlX3p/FdhLhnVg9j+8fD6u9Zz1Mss5c2usRtAAG9As7ep3?=
 =?iso-8859-1?Q?HV/c8sm5uDCVm8Ny3imqWyz+N58skfP3xpfJGlPZhVU6/524S6YxNzo5G0?=
 =?iso-8859-1?Q?DCKBQJQPHRQmf0Y1tg8qtkxXFdV2ypWkO6D9gC/FnjhPA9GuKmIgaDKOlH?=
 =?iso-8859-1?Q?3oap0Yv6eVLodBcOQfIvEvKDuiy2bQPP8jvvTW6PsAsGiUOTLAHB4RKz61?=
 =?iso-8859-1?Q?4MWBFfMloFu6f7fZXEY0SLU02b6VVucAsW4rXQd3LLjfxnIT/LZ03XGnDY?=
 =?iso-8859-1?Q?pZuvFiFOT5S5hzmSDsYp5MEGquWXn/VuQX/stxMPNl/aiOw1Tq5F2HGb9b?=
 =?iso-8859-1?Q?/smJW9FUS7kRMMFf1qcIhQ/k03FpSOTp5OR6B0vmS726C8BfyLFg5hm9oB?=
 =?iso-8859-1?Q?83YhgPc+o9Pdt55Q/TwHUPm/N3vyDP9LQHY7uEL5UthVEeN67ny5rQBYOw?=
 =?iso-8859-1?Q?IIye4JDqWsJfs07h5aN8FuSsMH4iQR6RpnBg2Kz5tNTXBZQfh77CKxjWAJ?=
 =?iso-8859-1?Q?StwL41S07dL8K9Ht5rWGNxzpHEY2DmhOi4RvwGQuVGoB/fJEVWwzr1FNkm?=
 =?iso-8859-1?Q?qYq8s2yuFMFk6AiYnfsSWz5MM4kuVSiVAIUxgLyWPDAIXOEGjuVpHmexJR?=
 =?iso-8859-1?Q?RG0dqQeeaD1UKWHsEDJzZyhHuaIUoW3UWh0yNyI58ZgIieV7FemtChd01b?=
 =?iso-8859-1?Q?UXpnzcxgSUYmsY5LPlO1iEdUrom13M45opoyRtHR+gKrCw4KXWLr18lqbi?=
 =?iso-8859-1?Q?NFjwKGsHXzGsbIh4eKxV1rVsNqykhThIaWPHL9IjhWNqh7gY6bd/Cj5ZSM?=
 =?iso-8859-1?Q?WsJQvylEuQF42S2Hue9iSZfEtM59AII=3D?=
X-Exchange-RoutingPolicyChecked: kdX9bGrVdunRYIf25UBLo0w+ZzYBt/+7uZ0RYrL8x6UiEKT8+JxAHcyIms4j1eLG6Kyn7hL4aHuPQQXc8Hes2O1hBTl/+84j4W99SPXhhTp6Kh0vun0REFXpR1BCqdpOQRdfPsGYQNQ+248w+KfvXeSD0nca7qcTSpg3n/GADFxk55CvNB+cOc1Fq1fV5cGbrTj68CWNwFGpOFX2EqU/CVEEExAettRhYgQEdv5LcrzIio9xyQo1FU9vqCivRA+wLEvqhLE0qKaAa2sfR9FYlOnTHFJiBNakmT98Q/FBIyBMU8+8OTuimLbfkrOwyvilk0zlYN4Q1Fcz9ali+GEVpQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 91491f05-ba36-490f-0359-08df1234f748
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB9534.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 07:51:20.7215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QbZvFSPQAv9JwHCz4soVLr2ImZPV1p+2qWGJKRO3Q2M/7qcRmf35v9Cwurw6x/ctkQO37480LDVXYSkSltLgAfIMQw+7buUk3dkGRAER9zE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4737
X-OriginatorOrg: intel.com

On Fri, Sep 11, 2026 at 05:04:04PM +0200, Petr Pavlu wrote:
> Several drivers/gpu/drm/i915/*.c files use ALLOW_ERROR_INJECTION(), which
> is defined in asm-generic/error-injection.h. They currently rely on this
> header being included indirectly through linux/module.h ->
> linux/error-injection.h.
> 
> Add the missing includes in preparation for removing the
> linux/error-injection.h include from linux/module.h.
> 
> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>

Reviewed-by: Francois Dugast <francois.dugast@intel.com>

> ---
>  drivers/gpu/drm/i915/display/intel_connector.c      | 1 +
>  drivers/gpu/drm/i915/display/intel_display_driver.c | 1 +
>  drivers/gpu/drm/i915/gt/intel_engine_cs.c           | 1 +
>  drivers/gpu/drm/i915/gt/intel_gt.c                  | 2 ++
>  drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c           | 1 +
>  drivers/gpu/drm/i915/gt/uc/intel_uc.c               | 1 +
>  drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c            | 1 +
>  drivers/gpu/drm/i915/i915_driver.c                  | 1 +
>  drivers/gpu/drm/i915/i915_pci.c                     | 2 ++
>  drivers/gpu/drm/i915/intel_uncore.c                 | 1 +
>  10 files changed, 12 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_connector.c b/drivers/gpu/drm/i915/display/intel_connector.c
> index 7ef9338d67ab..a287884c0045 100644
> --- a/drivers/gpu/drm/i915/display/intel_connector.c
> +++ b/drivers/gpu/drm/i915/display/intel_connector.c
> @@ -23,6 +23,7 @@
>   * DEALINGS IN THE SOFTWARE.
>   */
>  
> +#include <linux/error-injection.h>
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  
> diff --git a/drivers/gpu/drm/i915/display/intel_display_driver.c b/drivers/gpu/drm/i915/display/intel_display_driver.c
> index 70d112fd4287..204810a11e46 100644
> --- a/drivers/gpu/drm/i915/display/intel_display_driver.c
> +++ b/drivers/gpu/drm/i915/display/intel_display_driver.c
> @@ -7,6 +7,7 @@
>   * details here.
>   */
>  
> +#include <linux/error-injection.h>
>  #include <linux/vga_switcheroo.h>
>  #include <acpi/video.h>
>  #include <drm/display/drm_dp_mst_helper.h>
> diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> index c0fd349a4600..2c3bc7b67c0d 100644
> --- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> +++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> @@ -3,6 +3,7 @@
>   * Copyright © 2016 Intel Corporation
>   */
>  
> +#include <linux/error-injection.h>
>  #include <linux/string_helpers.h>
>  
>  #include <drm/drm_print.h>
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
> index 5c7f862f7100..2f0e1cb5578c 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt.c
> +++ b/drivers/gpu/drm/i915/gt/intel_gt.c
> @@ -3,6 +3,8 @@
>   * Copyright © 2019 Intel Corporation
>   */
>  
> +#include <linux/error-injection.h>
> +
>  #include <drm/drm_managed.h>
>  #include <drm/intel/intel-gtt.h>
>  #include <drm/intel/intel_gmd_interrupt_regs.h>
> diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c
> index 1c455d84bf9d..091aa33f624a 100644
> --- a/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c
> +++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/circ_buf.h>
> +#include <linux/error-injection.h>
>  #include <linux/ktime.h>
>  #include <linux/string_helpers.h>
>  #include <linux/time64.h>
> diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc.c b/drivers/gpu/drm/i915/gt/uc/intel_uc.c
> index bd07c72a66fc..d367a897c86b 100644
> --- a/drivers/gpu/drm/i915/gt/uc/intel_uc.c
> +++ b/drivers/gpu/drm/i915/gt/uc/intel_uc.c
> @@ -3,6 +3,7 @@
>   * Copyright © 2016-2019 Intel Corporation
>   */
>  
> +#include <linux/error-injection.h>
>  #include <linux/string_helpers.h>
>  
>  #include "gt/intel_gt.h"
> diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> index 7fac97fe30a6..d7c731fe972b 100644
> --- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> +++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/bitfield.h>
> +#include <linux/error-injection.h>
>  #include <linux/firmware.h>
>  #include <linux/highmem.h>
>  
> diff --git a/drivers/gpu/drm/i915/i915_driver.c b/drivers/gpu/drm/i915/i915_driver.c
> index ce6d20958320..aeb7b24c81c8 100644
> --- a/drivers/gpu/drm/i915/i915_driver.c
> +++ b/drivers/gpu/drm/i915/i915_driver.c
> @@ -30,6 +30,7 @@
>  #include <linux/aperture.h>
>  #include <linux/acpi.h>
>  #include <linux/device.h>
> +#include <linux/error-injection.h>
>  #include <linux/module.h>
>  #include <linux/oom.h>
>  #include <linux/pci.h>
> diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
> index 2f03f95945f1..84a7dc6ab5db 100644
> --- a/drivers/gpu/drm/i915/i915_pci.c
> +++ b/drivers/gpu/drm/i915/i915_pci.c
> @@ -22,6 +22,8 @@
>   *
>   */
>  
> +#include <linux/error-injection.h>
> +
>  #include <drm/drm_color_mgmt.h>
>  #include <drm/drm_drv.h>
>  #include <drm/intel/pci_config.h>
> diff --git a/drivers/gpu/drm/i915/intel_uncore.c b/drivers/gpu/drm/i915/intel_uncore.c
> index 170e83a8c9fc..e360e4f9d9a2 100644
> --- a/drivers/gpu/drm/i915/intel_uncore.c
> +++ b/drivers/gpu/drm/i915/intel_uncore.c
> @@ -21,6 +21,7 @@
>   * IN THE SOFTWARE.
>   */
>  
> +#include <linux/error-injection.h>
>  #include <linux/pm_runtime.h>
>  
>  #include <drm/drm_managed.h>
> 
> -- 
> 2.55.0
