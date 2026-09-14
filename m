Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D013E51CB;
	Mon, 14 Sep 2026 07:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371728; cv=fail; b=C78JDMG4Yn4Z8AR1cCG+sdNm6BKiF84VqZeBsf4GV6HFC4i+tIq09WYZKDUUupwWDS/cfl6s8BtxkbfbTX69PseZEE3a0NqpwZkA50SS/jxadUFry5HBZzvuvX0jL///jEq9pB+a8303N440keq7Ot1HB7D6Ja3RG1UvZgX0Dnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371728; c=relaxed/simple;
	bh=DLw9cRRh9kzSXQT19FBHPYfhtB9zxteXctEixjWtuwY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=t6oWnLZ+AlIJjGvu8AIT7H/8sXlPsMTDHet+wN/8NFF7InnX880mM1pr43YDywh3QKDAo+6xkToTYLXqutCHlaXsk6GT4gyHrkoXoVCOBRR7BvXEMDKIvFS0qxHKzPaOeZpa6NsYQJ9oAouN6xd6+BYlQmtLdXpBYs4FhVNCDf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dmE0CeXw; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dmE0CeXw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789371727; x=1820907727;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=DLw9cRRh9kzSXQT19FBHPYfhtB9zxteXctEixjWtuwY=;
  b=dmE0CeXwvrJnP5TACCCEnnyPswDtr/Ft/dqZ6oGs1EolDxq+v1vxCQi7
   QGaZx3hd2fFYyUei4YPnwjGfw2WDi4zJtHxfQDZJLKdfKEJ/ovDeILVvt
   iP6BbhpXTZf6Z8ONGU5InZuSEtq5Zt34T5QNYG0lPaEo5jFB91JgPmP9g
   KnB4StmXWc/CHDdBbwA1ZRNZRpKioJPQWTlQSqkEYpzgMUI88nDJUKAbC
   kFYpCOVH5r+cnE4S7X9B/dZq+jDiUols0Rb/2bRKFUf6edE8UbSjY3CO9
   FIjJH0n52LK6jQDpqXdlKwaZNWvE2El6qVaCWq4K+UD2nPu14EFUul1xO
   w==;
X-CSE-ConnectionGUID: s84ukwXwThmcuNlZ6sfZyA==
X-CSE-MsgGUID: ganPH9Z1Ree22SgFCRuT+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11904"; a="101239896"
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="101239896"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 00:42:02 -0700
X-CSE-ConnectionGUID: XHsuzrnQQWO6byIvw3nW9g==
X-CSE-MsgGUID: 6FCyopO6TByrime0vq1gaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="269939932"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 00:42:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 00:42:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 00:42:00 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.39) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 00:41:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AG+QGIelK3lRNhbSq6V0RxZxinGchbPkQa0HxWQ/rM0r1fFwZ50YVanKVNIEEhnsLft3gSpgES38uWdCu0agX46WmpEvq99CluOBDjwUcShgu8hTHhvAijRvO75mPq0JkbANKfSNv8YKYr7pJtOlPWhcTfcT6pSeM71eWJ4T2HvqwavaiQT7y9oKc+fA7lsBy9kV3Nf+7JY00TSJnG4PLh7NDMIwowx229ZLZrISnj/mTmGoCkQ+A2R7z37/NnZRXXtF1pzsamLL3r6myuEgbRV67N6iDPYYr4gtQBfmqU9UfuSO7BPalJ7Xw9U2VzX2arhWFQLihrCFy2y4LwjIkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=njGDq+9pnkdiw7yBtdbOMS89JuhOhEUWuV31CkYMm/o=;
 b=aShQT1frpnx76AWOb1qkFImx08vs1gkAAXKyfdwUWEsX20ghep1egdEa1MmJVjnwKQOgPdHb4xZcMJFaFnPHMI1eYol9gzacrqB8T9Zz3jVZdMKg87xWCYp2vaYeWXmeZP38+0Sf3VVE3TFG/HdBxDSIzh1c5qbWAMPnZyg39ltzZs8PUEsdVowGtYzukGS6GQBtRVV7yCPKGGGqI9Al11gM4IjiVCsYanEbiS/gmR96H6vIoYiTgSarwJIUX5qWMcyHFLoToJILE3ENAhJdxcrOfXupaUb0Gg/V0+4sfSPNJh97M12GTRvITjrAVkb/auFYPR4+gHpi+fAjsYE7uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB9534.namprd11.prod.outlook.com (2603:10b6:510:39f::22)
 by CH3PR11MB8341.namprd11.prod.outlook.com (2603:10b6:610:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 07:41:57 +0000
Received: from PH8PR11MB9534.namprd11.prod.outlook.com
 ([fe80::16ca:6958:c9e9:a266]) by PH8PR11MB9534.namprd11.prod.outlook.com
 ([fe80::16ca:6958:c9e9:a266%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 07:41:57 +0000
Date: Mon, 14 Sep 2026 09:41:46 +0200
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
Subject: Re: [PATCH 5/6] drm/xe: Include error-injection.h for
 ALLOW_ERROR_INJECTION()
Message-ID: <aqelOvgLfacnxcJt@fdugast-desk>
References: <20260911-module-include-error_injection-v1-0-5da895d8c84d@suse.com>
 <20260911-module-include-error_injection-v1-5-5da895d8c84d@suse.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260911-module-include-error_injection-v1-5-5da895d8c84d@suse.com>
Organization: Intel Corporation
X-ClientProxiedBy: DU2PR04CA0025.eurprd04.prod.outlook.com
 (2603:10a6:10:3b::30) To PH8PR11MB9534.namprd11.prod.outlook.com
 (2603:10b6:510:39f::22)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB9534:EE_|CH3PR11MB8341:EE_
X-MS-Office365-Filtering-Correlation-Id: b522ed08-f1f7-4790-3b51-08df1233a75a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|6133799003|22082099003|18002099003|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: 8eIbjHC8RbudcTd8ChyVP/dvUawde82NRzN800E4t24TVnPdhRzNx6oeiW8NSNBoNOEf/bsjYpC6tAtCC1Qf7fi1CiR2ea3a0Opz45Wrvp25MO2MN6jwbzG2orqFgESreeXHx0+IkIyey/muZTsUNR3h8/nypOXoRmzceV77hql7AHbe9esim7myhoEUtScKj2kajHT4wlym8vZCD0Z9DdcG8H8AuhAdsgRNVJSGZxp6S9LGS0ebd78pHGGb3mb89q+uKpWLw7SDlgjinLw8b9oux4VhL1pV5qYi5GUTe3+ISbUuIvaQep8FpHcR4L3kBBrP7DXt7vDaCC5MqGP2BVnr/YMfEvjqF7OT8zRpN4JxTnhVTpdwHNuDNe5GdbaWPoRxt3TgduEbvc2gtaBN+xbB2E2Viu5ODuaDqDq8nr307j/jdhV2/3JU+NU3ChWxOdEKt8CpSjSFNrZckRO5TfvkBEuegwCr0+kuvYntTP3rx58PxyQHh4MEdvNtYNMGQMBE+4g5YsAPPH9c4pS1g54BPecd5aiSTC/6SjMxjcuJm5lmoPDhbSL1Fvu2PJWv2SE4It1y38Uh7bVTwAr2LL405xPS7gWI9VffyMK+vbKRuqGArle/WzDePhU4MD+cdA0KTbm/mdKGnlJo10TstJhRKJjKwD6VQs58uJY2Po8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB9534.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(6133799003)(22082099003)(18002099003)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?vVNUhI/9PMjOqYvmiRO+djQ00RYgXi+iByU5mp+rr9MYgGRStAwSa7sP9T?=
 =?iso-8859-1?Q?KDCv+a8RofL99IjthyqB+rjiujg9jAW/ss65dJ6zLTrI5VjpshV4ekdACX?=
 =?iso-8859-1?Q?+uw76CqV+cL1jLtgXywGQsiLqrrWFqg0QvXm6QkGrSVGU4Y5orJTcZxo4Q?=
 =?iso-8859-1?Q?HvlwsObGbIhJQ5NRlksxsy2auZLqBb0D0eWgro3OXVPcfD1tHaZJ1i5NYB?=
 =?iso-8859-1?Q?GydvjMVzhp8vRRe/6zR6nBex/IYKwFIGl/elNkykYPRmBvs57dM7CiP3/j?=
 =?iso-8859-1?Q?bqYH9TnEQEYOYn/+W9wszTy8+ut5PcjI4vM0Ud/yh44YHHnaZJ//Ot0svd?=
 =?iso-8859-1?Q?Z6teDz7Qo6MYgc2bgCVyvYPVjvXhscPvaqnd1wTr7RkLuFYIy9k2KfejGc?=
 =?iso-8859-1?Q?tnpbo1UTy5JXK1e7MoMpQbKJQeXpUAc6GyJo5OmtSXbAw+Slnsi1gXiVa1?=
 =?iso-8859-1?Q?cBnDpxbRNZgcHanVUVsz1jg2fYYSkstae7RYtp++hj/0JitY4A9ZshCp78?=
 =?iso-8859-1?Q?b2LM/8Qlcs2dP2noZjtj+dE10kBfRHqcf0jSfL3p+RPLcvp2fADh+FBVNc?=
 =?iso-8859-1?Q?g/PbJaeqt68dhtVzukrkNrdfVqKGAV+oDKOnkH5msucNcogG6gZbtHk7aM?=
 =?iso-8859-1?Q?ksdbo8oprHV1hNYqA0Ui+8eA6pARBLMVXObmyfSfDHtjlEHKIeCn98XlMm?=
 =?iso-8859-1?Q?FOqvT5o1HzqteYGtgbMqJRRPBVRwdL5jz/5lhm0YoLi1hz/5LSyDlqKxYI?=
 =?iso-8859-1?Q?1jZkkgbuuWT+i4cVs5LQ/JuFmjs2jZAuytnmZbzzWtAYJLcSuNUdEP0C3n?=
 =?iso-8859-1?Q?3zaT5UPIzAqOavT7JvXVC8+jof4k+t5ecjhOlUVyRAWoHVpVwK4rF6lkya?=
 =?iso-8859-1?Q?Lu9HT/euU6k2ry1VKd4P9J5k8l+vw/+5OdPQ/sa5cGvXdoN6+xtpnhzkRj?=
 =?iso-8859-1?Q?/KVyuKIOvKjPHFS78zWFaXq6n1w9nGHwov2yKjnJVnOk5j42EvDfQWFK1e?=
 =?iso-8859-1?Q?L9E+2N9L9lAPafQfbsMim5Le27dWn9m8Qbn3XEkL2C77CJf6kQgyTZJ16I?=
 =?iso-8859-1?Q?OP0SmHVg/5xuR/pdTyQZBX3WP+3xlK9tVNEb735JemSfsfwqKxEIgwPFwq?=
 =?iso-8859-1?Q?/RXZt57Uzu7l/cG0V4ciIRrgAhNiB0hHsB0ziq/Uiasa/xsMShHsSsdtZp?=
 =?iso-8859-1?Q?17WwuK121tpKw7QXSlsIVd27WUmZTGkNeRFaiBVd36BBLk2w1ULWAOyy/1?=
 =?iso-8859-1?Q?Bx9Gmkgd8bixV1RTR1hrW3M2/ufY4RwAXaw2/rqKfFExFhNFd5qee8gztB?=
 =?iso-8859-1?Q?FtUERb0vgxT6IMrRYeQw7/L4bO7iqjkuMR4LZUumhmM0tu9gE0K1UmN9G3?=
 =?iso-8859-1?Q?nbW4L4Fc6anwo2N7Qh/8vrpL4fFtQpV9pPuEirYg0eJZ5BjzfNymKuxRRr?=
 =?iso-8859-1?Q?lyC3BZufDcjayWkDlMNE0XYYkOeChamMQhruJgdusp97dkWZNwn33OQWJ0?=
 =?iso-8859-1?Q?u050cwZueNIIW3C0irWVKBzeqA6pcVF3r6Xad90EicCOUsoeeK3yBy7Okt?=
 =?iso-8859-1?Q?xZi9gNIUdhq0YwkFY9CyJ5dLRPdoJB3J2LaLVOlGAX/MFWUZ9A7uGzoGNj?=
 =?iso-8859-1?Q?sYY7eu8fSbIkuuMY4Dwfp9ND9RLpjSkHehezWDtvXLlVS8Pv5/XByx5EtM?=
 =?iso-8859-1?Q?ZxigROMF9lrZ4z2PsaZAGcBtnHPGf33LeoTDK2/TeVsAsrfbsV1l4C2wtE?=
 =?iso-8859-1?Q?/zAbYrudTljVQdwqEvPZmy6pYuYD0Gy3MYV9TJynwWXzSSLbo62Y8Jk4Zc?=
 =?iso-8859-1?Q?rLh2IwlWo/WkX2OKaR1p7a32j3FMtCg=3D?=
X-Exchange-RoutingPolicyChecked: j7xRhe0QUGIPZcUGVrXHoTcDJaXXHZaUI7WvhQrh8axLo0KoSaCZtO68TTCegEe6F9PNLYaJoHCC8RHHSszWih+hD3eSPSZef3kFxXcf82+iEs9kbbOPg2bwjOpX4kmmUl1nnzXa3w5ZgOaZ2pKDnA9XbgK9IuKf4MT/aU33Flsrm0povSfei1m9h7v9iPw7b852BPAjwyqVFX0EyponhvBN+RQLITLU+I5MUzRhNUbweMqEQpA2GzPEvIqT3a2oh5XTUNQ5Lwcz5XUctmYbTYpMKrfiPoj8KwNzttvr7RFAOu7jM+KjkRoGBA2fkDHQ9g7Tgerj+STQscgI2nL67w==
X-MS-Exchange-CrossTenant-Network-Message-Id: b522ed08-f1f7-4790-3b51-08df1233a75a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB9534.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 07:41:57.1268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2bpPlXB9hGPWX0cGo9tJT1BRXb1sdlZPH3XAjp5sEtB5BVZNmmLfPhPoqG5RW4Mo/yz86VsifSNbn9H1NGCdU1sJbrixMswxLOJ2Q0Y2H14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8341
X-OriginatorOrg: intel.com

On Fri, Sep 11, 2026 at 05:04:05PM +0200, Petr Pavlu wrote:
> Several drivers/gpu/drm/xe/*.c files use ALLOW_ERROR_INJECTION(), which is
> defined in asm-generic/error-injection.h. They currently rely on this
> header being included indirectly through linux/module.h ->
> linux/error-injection.h.
> 
> Add the missing includes in preparation for removing the
> linux/error-injection.h include from linux/module.h.
> 
> Remove also the linux/fault-injection.h include, which commit 91b2c42c214f
> ("drm/xe: Use fault injection infrastructure to find issues at probe time")
> mistakenly used to provide the definition of ALLOW_ERROR_INJECTION().
> 
> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>

Reviewed-by: Francois Dugast <francois.dugast@intel.com>

> ---
>  drivers/gpu/drm/xe/xe_device.c                | 2 +-
>  drivers/gpu/drm/xe/xe_exec_queue.c            | 1 +
>  drivers/gpu/drm/xe/xe_ggtt.c                  | 2 +-
>  drivers/gpu/drm/xe/xe_guc.c                   | 1 +
>  drivers/gpu/drm/xe/xe_guc_ads.c               | 2 +-
>  drivers/gpu/drm/xe/xe_guc_ct.c                | 2 +-
>  drivers/gpu/drm/xe/xe_guc_log.c               | 2 +-
>  drivers/gpu/drm/xe/xe_guc_relay.c             | 2 +-
>  drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c | 1 +
>  drivers/gpu/drm/xe/xe_hw_engine_group.c       | 2 ++
>  drivers/gpu/drm/xe/xe_mmio.c                  | 1 +
>  drivers/gpu/drm/xe/xe_oa.c                    | 1 +
>  drivers/gpu/drm/xe/xe_pm.c                    | 2 +-
>  drivers/gpu/drm/xe/xe_pt.c                    | 2 ++
>  drivers/gpu/drm/xe/xe_pxp.c                   | 2 ++
>  drivers/gpu/drm/xe/xe_sriov.c                 | 2 +-
>  drivers/gpu/drm/xe/xe_sync.c                  | 1 +
>  drivers/gpu/drm/xe/xe_tile.c                  | 2 +-
>  drivers/gpu/drm/xe/xe_tuning.c                | 2 ++
>  drivers/gpu/drm/xe/xe_uc_fw.c                 | 2 +-
>  drivers/gpu/drm/xe/xe_vm.c                    | 1 +
>  drivers/gpu/drm/xe/xe_wa.c                    | 2 +-
>  drivers/gpu/drm/xe/xe_wopcm.c                 | 2 +-
>  23 files changed, 27 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
> index ee732e5495f7..fcef8d5fc7ca 100644
> --- a/drivers/gpu/drm/xe/xe_device.c
> +++ b/drivers/gpu/drm/xe/xe_device.c
> @@ -7,7 +7,7 @@
>  
>  #include <linux/aperture.h>
>  #include <linux/delay.h>
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  #include <linux/units.h>
>  
>  #include <drm/drm_client.h>
> diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
> index cd053de3c6b5..3e46c14584c4 100644
> --- a/drivers/gpu/drm/xe/xe_exec_queue.c
> +++ b/drivers/gpu/drm/xe/xe_exec_queue.c
> @@ -5,6 +5,7 @@
>  
>  #include "xe_exec_queue.h"
>  
> +#include <linux/error-injection.h>
>  #include <linux/nospec.h>
>  
>  #include <drm/drm_device.h>
> diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
> index 8ec23862477f..e05582ad098a 100644
> --- a/drivers/gpu/drm/xe/xe_ggtt.c
> +++ b/drivers/gpu/drm/xe/xe_ggtt.c
> @@ -6,7 +6,7 @@
>  #include "xe_ggtt.h"
>  
>  #include <kunit/visibility.h>
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  #include <linux/io-64-nonatomic-lo-hi.h>
>  #include <linux/sizes.h>
>  
> diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
> index 4286bd05c686..34e21a70d5ad 100644
> --- a/drivers/gpu/drm/xe/xe_guc.c
> +++ b/drivers/gpu/drm/xe/xe_guc.c
> @@ -5,6 +5,7 @@
>  
>  #include "xe_guc.h"
>  
> +#include <linux/error-injection.h>
>  #include <linux/iopoll.h>
>  #include <drm/drm_managed.h>
>  
> diff --git a/drivers/gpu/drm/xe/xe_guc_ads.c b/drivers/gpu/drm/xe/xe_guc_ads.c
> index ff8eee3831aa..41a2b8c807d6 100644
> --- a/drivers/gpu/drm/xe/xe_guc_ads.c
> +++ b/drivers/gpu/drm/xe/xe_guc_ads.c
> @@ -5,7 +5,7 @@
>  
>  #include "xe_guc_ads.h"
>  
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  
>  #include <drm/drm_managed.h>
>  
> diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
> index fe70c0fd85c5..ac6cbbaa6cc0 100644
> --- a/drivers/gpu/drm/xe/xe_guc_ct.c
> +++ b/drivers/gpu/drm/xe/xe_guc_ct.c
> @@ -8,7 +8,7 @@
>  #include <linux/bitfield.h>
>  #include <linux/circ_buf.h>
>  #include <linux/delay.h>
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  
>  #include <kunit/static_stub.h>
>  
> diff --git a/drivers/gpu/drm/xe/xe_guc_log.c b/drivers/gpu/drm/xe/xe_guc_log.c
> index 538d4df0f7aa..6f0739204d9e 100644
> --- a/drivers/gpu/drm/xe/xe_guc_log.c
> +++ b/drivers/gpu/drm/xe/xe_guc_log.c
> @@ -5,7 +5,7 @@
>  
>  #include "xe_guc_log.h"
>  
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  
>  #include <linux/utsname.h>
>  #include <drm/drm_managed.h>
> diff --git a/drivers/gpu/drm/xe/xe_guc_relay.c b/drivers/gpu/drm/xe/xe_guc_relay.c
> index eed0a750d2eb..e528d95ba7fe 100644
> --- a/drivers/gpu/drm/xe/xe_guc_relay.c
> +++ b/drivers/gpu/drm/xe/xe_guc_relay.c
> @@ -5,7 +5,7 @@
>  
>  #include <linux/bitfield.h>
>  #include <linux/delay.h>
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  
>  #include <drm/drm_managed.h>
>  
> diff --git a/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c b/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c
> index d42e263e0611..ac81f382e7dc 100644
> --- a/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c
> +++ b/drivers/gpu/drm/xe/xe_hw_engine_class_sysfs.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <drm/drm_managed.h>
> +#include <linux/error-injection.h>
>  #include <linux/kobject.h>
>  #include <linux/sysfs.h>
>  
> diff --git a/drivers/gpu/drm/xe/xe_hw_engine_group.c b/drivers/gpu/drm/xe/xe_hw_engine_group.c
> index 0804b426b6f9..418ff427ae30 100644
> --- a/drivers/gpu/drm/xe/xe_hw_engine_group.c
> +++ b/drivers/gpu/drm/xe/xe_hw_engine_group.c
> @@ -3,6 +3,8 @@
>   * Copyright © 2024 Intel Corporation
>   */
>  
> +#include <linux/error-injection.h>
> +
>  #include <drm/drm_managed.h>
>  
>  #include "xe_assert.h"
> diff --git a/drivers/gpu/drm/xe/xe_mmio.c b/drivers/gpu/drm/xe/xe_mmio.c
> index 7fa18dfcb5a2..d8f8a2453bb6 100644
> --- a/drivers/gpu/drm/xe/xe_mmio.c
> +++ b/drivers/gpu/drm/xe/xe_mmio.c
> @@ -6,6 +6,7 @@
>  #include "xe_mmio.h"
>  
>  #include <linux/delay.h>
> +#include <linux/error-injection.h>
>  #include <linux/io-64-nonatomic-lo-hi.h>
>  #include <linux/minmax.h>
>  #include <linux/pci.h>
> diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
> index ab09dcff5860..b15c96e35fab 100644
> --- a/drivers/gpu/drm/xe/xe_oa.c
> +++ b/drivers/gpu/drm/xe/xe_oa.c
> @@ -5,6 +5,7 @@
>  
>  #include <linux/anon_inodes.h>
>  #include <linux/delay.h>
> +#include <linux/error-injection.h>
>  #include <linux/nospec.h>
>  #include <linux/poll.h>
>  
> diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
> index a5289a9df8d2..c0489a8d8a62 100644
> --- a/drivers/gpu/drm/xe/xe_pm.c
> +++ b/drivers/gpu/drm/xe/xe_pm.c
> @@ -5,7 +5,7 @@
>  
>  #include "xe_pm.h"
>  
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/suspend.h>
>  #include <linux/dmi.h>
> diff --git a/drivers/gpu/drm/xe/xe_pt.c b/drivers/gpu/drm/xe/xe_pt.c
> index a07316a45d79..6c6d9be2717e 100644
> --- a/drivers/gpu/drm/xe/xe_pt.c
> +++ b/drivers/gpu/drm/xe/xe_pt.c
> @@ -5,6 +5,8 @@
>  
>  #include "xe_pt.h"
>  
> +#include <linux/error-injection.h>
> +
>  #include "regs/xe_gtt_defs.h"
>  #include "xe_bo.h"
>  #include "xe_device.h"
> diff --git a/drivers/gpu/drm/xe/xe_pxp.c b/drivers/gpu/drm/xe/xe_pxp.c
> index 2fef274a585e..2f3632ac201a 100644
> --- a/drivers/gpu/drm/xe/xe_pxp.c
> +++ b/drivers/gpu/drm/xe/xe_pxp.c
> @@ -5,6 +5,8 @@
>  
>  #include "xe_pxp.h"
>  
> +#include <linux/error-injection.h>
> +
>  #include <drm/drm_managed.h>
>  #include <uapi/drm/xe_drm.h>
>  
> diff --git a/drivers/gpu/drm/xe/xe_sriov.c b/drivers/gpu/drm/xe/xe_sriov.c
> index f3835867fce5..ec254b950daf 100644
> --- a/drivers/gpu/drm/xe/xe_sriov.c
> +++ b/drivers/gpu/drm/xe/xe_sriov.c
> @@ -3,7 +3,7 @@
>   * Copyright © 2023 Intel Corporation
>   */
>  
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  
>  #include <drm/drm_managed.h>
>  
> diff --git a/drivers/gpu/drm/xe/xe_sync.c b/drivers/gpu/drm/xe/xe_sync.c
> index 37866768d64c..711de22f4986 100644
> --- a/drivers/gpu/drm/xe/xe_sync.c
> +++ b/drivers/gpu/drm/xe/xe_sync.c
> @@ -6,6 +6,7 @@
>  #include "xe_sync.h"
>  
>  #include <linux/dma-fence-array.h>
> +#include <linux/error-injection.h>
>  #include <linux/kthread.h>
>  #include <linux/sched/mm.h>
>  #include <linux/uaccess.h>
> diff --git a/drivers/gpu/drm/xe/xe_tile.c b/drivers/gpu/drm/xe/xe_tile.c
> index 74d925a337b7..810dfd98d830 100644
> --- a/drivers/gpu/drm/xe/xe_tile.c
> +++ b/drivers/gpu/drm/xe/xe_tile.c
> @@ -3,7 +3,7 @@
>   * Copyright © 2023 Intel Corporation
>   */
>  
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  
>  #include <drm/drm_managed.h>
>  #include <drm/drm_pagemap_util.h>
> diff --git a/drivers/gpu/drm/xe/xe_tuning.c b/drivers/gpu/drm/xe/xe_tuning.c
> index bcec40ca2d35..d3d38b4380be 100644
> --- a/drivers/gpu/drm/xe/xe_tuning.c
> +++ b/drivers/gpu/drm/xe/xe_tuning.c
> @@ -5,6 +5,8 @@
>  
>  #include "xe_tuning.h"
>  
> +#include <linux/error-injection.h>
> +
>  #include <kunit/visibility.h>
>  
>  #include <drm/drm_managed.h>
> diff --git a/drivers/gpu/drm/xe/xe_uc_fw.c b/drivers/gpu/drm/xe/xe_uc_fw.c
> index a8e6f18cc9b4..f17925ad53f5 100644
> --- a/drivers/gpu/drm/xe/xe_uc_fw.c
> +++ b/drivers/gpu/drm/xe/xe_uc_fw.c
> @@ -4,7 +4,7 @@
>   */
>  
>  #include <linux/bitfield.h>
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  #include <linux/firmware.h>
>  
>  #include <drm/drm_managed.h>
> diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
> index 23952ad8951e..f000564f1e59 100644
> --- a/drivers/gpu/drm/xe/xe_vm.c
> +++ b/drivers/gpu/drm/xe/xe_vm.c
> @@ -6,6 +6,7 @@
>  #include "xe_vm.h"
>  
>  #include <linux/dma-fence-array.h>
> +#include <linux/error-injection.h>
>  #include <linux/nospec.h>
>  
>  #include <drm/drm_drv.h>
> diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
> index 139434946f8f..98d2fdd3ba6f 100644
> --- a/drivers/gpu/drm/xe/xe_wa.c
> +++ b/drivers/gpu/drm/xe/xe_wa.c
> @@ -8,7 +8,7 @@
>  #include <drm/drm_managed.h>
>  #include <kunit/visibility.h>
>  #include <linux/compiler_types.h>
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  
>  #include <generated/xe_device_wa_oob.h>
>  #include <generated/xe_wa_oob.h>
> diff --git a/drivers/gpu/drm/xe/xe_wopcm.c b/drivers/gpu/drm/xe/xe_wopcm.c
> index fe65ed246775..7da1e3ebc839 100644
> --- a/drivers/gpu/drm/xe/xe_wopcm.c
> +++ b/drivers/gpu/drm/xe/xe_wopcm.c
> @@ -5,7 +5,7 @@
>  
>  #include "xe_wopcm.h"
>  
> -#include <linux/fault-inject.h>
> +#include <linux/error-injection.h>
>  
>  #include "regs/xe_guc_regs.h"
>  #include "xe_device.h"
> 
> -- 
> 2.55.0
