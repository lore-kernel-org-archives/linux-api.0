Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022103.outbound.protection.outlook.com [52.101.96.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCED4AA025;
	Fri, 11 Sep 2026 17:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789147889; cv=fail; b=LK0pFGTIfoBCOclO3qWfvhrOUFim1YOVJizeoql7xtMPtslWT/xa3uxFgc2JevWPLbCWIufh82Zhh4RDViPDGkWZIEnQPjQNAQ/WuoqTCC2LMpGmDzqpkQ823j/jYHMR7aMibB9VK9SD/C0nP9y328wAJbzIPJfykVR3kACu6Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789147889; c=relaxed/simple;
	bh=p7s9bWDAiiyaj8FNf3LSA5f5b0ZAQdlk2kEHWlWuq/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=i2jGqQcx01Mtbwft7o9RTKZ3TwN1ibOB5kENuhrQ4BILvMqsuBD5CMthrh1xjt6p0EP5mmaNnZK0Jj5LXBhJaUcoy47vWNhcaVg1syWJOy8rrUeel8LaCxBg851B+6IPtUS8gUgXrS+S+VFbs/cNmqC01GhRARLvG6d3317XBIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pEd3/wDeX+onZny9fJFHPQS0zLTGFK4ZHSWK3Raqsys3/6mRlBnzikV4Wxmsj3FSkqa10XdGfkuxlELu48QsivNidi3UPAlKiG2LWXDU3biSXl45Wj3kIazSPjZGr+gxMTGPbAKi0s2SmFdRbFoyfK7Vt37ikl6NYYTVab6vyZdhfs/brxSmqisTDmoJ8S1YJ7jtQaFrgvb+S/z2KuPIOgsm8D4dQ7DH8/UqRF8ByhZFxo/ij5hxDhoXYU/zdDhUpis8fBmSM1WKLPfrkA/Ce1W4lmBbIboOG03MHBqa7JvSBYS3u4vwLaWwOHAHJWaZRJKF/j0KLNF21IXHUcIyvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=DQ/I4VbEJOQ+IYMhWKIjY1NsA15HkVvhvcoHrSza/2A=;
 b=lMlCxnFLBeAbPkMzX1aHKdfn/l694bDdiwHCzAVJZW/kls/fUX7adM6xmIiIY0JOS8pIiN5Wilz7lSuqE1EYsG4VGOWkkiPP/msB2ETkcINqeD9lscaiDceIRnpwjy/KBTFiRO8Nolwgw4Nkp+vh/P63a8gFAwRS72mBq67U1u4kJLMuISYi9Hrcf/MaBQ6EbmWkTkg6/XdCahyxV5Q+i7ge+cVx3EwEvd6ka5iWgswqC4JyZH4QrlFocxr+xEgCKwUQ0w1XGadg9VA3cS10u3gluFxLtKvOc7vF5qQ/Ub1FJPqvSA3FINXyzpFYldqjX4sp4a4XTGC88nYwSv9pOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CWXP123MB3464.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:83::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 17:31:21 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 17:31:20 +0000
Date: Fri, 11 Sep 2026 13:31:13 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	Matthew Brost <matthew.brost@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Simon Horman <horms@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Francois Dugast <francois.dugast@intel.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	linux-block@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] module: Remove the error-injection.h include from
 linux/module.h
Message-ID: <46xi4ovj3vulfr4pb7znr2koaltngrgywgbo2fwirbfducs6ay@tr5rhev6snb3>
References: <20260911-module-include-error_injection-v1-0-5da895d8c84d@suse.com>
 <20260911-module-include-error_injection-v1-6-5da895d8c84d@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260911-module-include-error_injection-v1-6-5da895d8c84d@suse.com>
X-ClientProxiedBy: SJ0PR03CA0350.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::25) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CWXP123MB3464:EE_
X-MS-Office365-Filtering-Correlation-Id: e7558224-2d6b-4df8-1e3c-08df102a7e0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|3023799007|4143699003|56012099006|5023799004|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kysciGr7k1voJxrtIN2WGkc9N8o03fy7ApmYFY3+6apHSTYx7+L4Qz6hVvJBX/M+hChvfLOZg6wGCd1M3sVVR7x15/ddtVF5LN3SBAsjCxkREVVLZCy4mIR7YmXkxtxijZqlPpAQSRrk2ymaIri7csr8N5EPBRZpLCJMAczvj0OjsOq+dr7XQL29OT+Qr8xEhch5+C5hW4dJofx37DpAA4Znv/UnMkWwbDuWHn7SQqLF/qmwVyBgmLzl/8BeLmw79wF14rx4E6c2y1U7rzbbVa0X5EgkBKPcs2B2KEQY9PyPvPyqD3mkBnscAVdi7j5ECBZkyi+aDrJL/szmjY3sEzqQ5F4a8hwE+v0IZ64xhb8sKXQ4vKf7FqlpgUbjkzeK3ZOj0J00pSVlQDWgH2QaRh6mH2NAVj22CXqIxTh6QWmSu9gsVQGoU4PuV03aWdmE+TuP67EomDRsu4KyI7ux8ehpfpKyYaiUtCQZnchSm4bI/u4nW07+GZ7xwPrAOR2baDKojsKTTxEkvyDEp84LO959ZJ7WzMhecVDuT+ugfiOSa7ojSKgoztrj41JqBaqnuBQzrXo7HxyWbasy+hNHO/JSn+bP5ZOu6M+n0BGqfv1swPNxKW2QCedk7ned8ADsuU+HXPVTsY5smIQwC5I8Nx1Qxl4oDkbr49BfOj1yhqI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(3023799007)(4143699003)(56012099006)(5023799004)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qm5FbzNOa3IwVVNkcjl1RmNjaWRFekRXMDhNMTJiTDU2aHkvMnhyaXpUUXhi?=
 =?utf-8?B?Zzc4Tk1UWW1FSnd4bEhyc0lnN0VNdm1iMXZ2cksycjNWb1BGRXlic0FmNTZ2?=
 =?utf-8?B?UXR6U1FUaVFGbnpwRGtqYXUyN0NhWmh5a0VhUUU4YkROT2x4WldRdHJHcDdI?=
 =?utf-8?B?eW9qTjVEdkhaU09YMldvRXB4Z2Q0Q2lURzduanVoV3UyWFhlTGhNZEtKYmtK?=
 =?utf-8?B?SlFJRzRUZXNwVVIzVWNPWmRDZU1LbzdFdVVBSW10dUFhZlV4MG5LdjR3cFVl?=
 =?utf-8?B?QWVhN1lERnUvbFErMDhGWkhRRlJuaVpnMHNVVWxkK3hYQlZPMFRhOVhIU05O?=
 =?utf-8?B?M3Nrd0lsRnFIQlkwekVqblNUSFZ4SWdmK3hSTVlNUWFqb2lEYXBkRW9STHVz?=
 =?utf-8?B?VWV1SG52SW9qd2hqOWZiS1JXRWdsWXZvM0FtZ1R5KzJ1UXpTYnQyaFRSeXZ3?=
 =?utf-8?B?eU5xZm8vN0hJZTFqTitDdU1ZdVZDQVE4aEdoMFpyTWIveVFtWThGakJuS3Qy?=
 =?utf-8?B?c0UrWUd5dDdTSG1EY29jK253MWlONndWYjBUOVRLTmVBVXp6MmcrSlJxUmto?=
 =?utf-8?B?aDA1MWt2elBWeDFESDhhNW9rWkZTREJsMDJvZm5aaDBKdVZ6U2dLUEtnVEhz?=
 =?utf-8?B?ZWZQSDlBcnlxckFXWmoxdnI0VmFNWVpDZTVBWjdyQnVJSWJMN3NVMDUzRlJk?=
 =?utf-8?B?YmxDb2xHRHl1K0NTWGlMU0Jsc2JuUlZnQU9YRE5jUTFIZ290WG1TNzgrc0dX?=
 =?utf-8?B?MldKTzBHZlpmVjBvNUdub243d0JMT3NmT05ReWl4ek9zcnBLeFQ0VVk5Vjlp?=
 =?utf-8?B?WEc2a1NTQmRoRng4UWpURS9GdTl1dTRUOG42c2VjTkFSelF5WlQ5bjZDaFFW?=
 =?utf-8?B?dktaUTFqWWNvYkY3RHRxL1NmS3ltT1YzTEhlQzg3amowdWNRcVduUUIwNVhw?=
 =?utf-8?B?UVdHOVY5NEJTYXgzOHJzclJoYXdHU2dHclRmN20vbi9YdlZqR3VpK3kxNVJV?=
 =?utf-8?B?TEpQWXRIMW85eXVCUHdRT1hvWElUUm13UGJRU05mMlBzblFnWFFQczVIR0RD?=
 =?utf-8?B?QUdhSWJYU0NWZ2x3NXF5MzNwNWxWdFNLNVF5VThSc05CV3VSMzA2MlIwN2ty?=
 =?utf-8?B?UlFhWVl2K0t4SHZpYkMzMm1LUmhkc0hmVXk0RkpyTExKQkJvZmdUN1FNaFNn?=
 =?utf-8?B?b3VPQVY3eXpHanJkSnFYSWhJWEptOVg3dzV4czd6MVU2Y2tkSGRwUndzWE5O?=
 =?utf-8?B?VmthZHFrTVFySnJFRFhJZDgwT1ZGb3hMNnlHT3l1V3hmajAxbCtzZHAyemtP?=
 =?utf-8?B?bi9nNmJxNnJQS2VEL24yZldtVHNHN1QzRjBxa0ViQ2RYN2ZFc054TVNNZktI?=
 =?utf-8?B?UnBxWjcyS2V1SGs0UTkrRGw5QmFwZXZsdjlJc3R4cnZoQmFTSVdSK1BySW1t?=
 =?utf-8?B?ekNqejRjNE01OVFzL2c3MitaaVZWcXR1amZWSHdNVDNIUTUxRmZ2RXpraUlx?=
 =?utf-8?B?T1JjNm0yeXNhR0ZmWmMvSks5ditiV09GMUFHNDhIaG9hemdVTjNLU1F0Ukgy?=
 =?utf-8?B?cnhGOUphTE12QjZYNFVEbVI4aFJZTk9ZTVlXVGJGWHdaQm5uYlZvUUR5YVFL?=
 =?utf-8?B?aHFqWHBBUG5ySENvTW1nVFJNOHRuZWt6ZDNCTHFFMW9UNVNjZWFvMnI0a1My?=
 =?utf-8?B?ZWRjQkxjeEFrNitJMEQxWkhOalZTYUpKTGFzZDhkYkJLQmJFSlhtUDBKZVdZ?=
 =?utf-8?B?WnRpRXNBWHBhVEhlNVBUa1RGTmVWNWQ1dWZkSGFmMVkrV0F1MnRPRjJ5N3Ns?=
 =?utf-8?B?bFdtRGJ3bVhISmZZOXRobnd3VDJyYVBydnA3QlIwdjE1RG14YjJTYnVEbFNJ?=
 =?utf-8?B?TEVsRHlhdG1KeVh1QThJeXF5eC82NXpKbzYxRHFIQ1BHUFJydE5oaG84SVgw?=
 =?utf-8?B?bDlYN1hXRWxmWWlwYU4rMU1yL1BwWmJOa3crWG5wYmF6NWk3LytXZklJaXJs?=
 =?utf-8?B?dHd4V09xQ000QVphWHg3SFlYUGo5TjdGejcrS1RQSW5aUVJmVTAzb1Q1S2tz?=
 =?utf-8?B?dlRjU3VyMzZJVnlIZTJTOG1ZaTFpakVvRmhXNUYrc3JnVTBsRFpJSXhPa0lz?=
 =?utf-8?B?c3R2ckw0SkZVYm8xVTZmaHcybk5hZk41ekJVVDF6dXo1SlJZR1V3Kzg3WTV0?=
 =?utf-8?B?K2FtTGJOa01PTjNKRjFoT3ZER0Vzb01aTjc0NkVsMmNuencrOUN4YkI1N1J5?=
 =?utf-8?B?Y3AzV3RZclBpVkJ4Q2lRcEJlaVZGZVZmZXIxM3pLbkhnM3Z4cEoyQWJYSHFw?=
 =?utf-8?B?Q0FuL2ZPR2J2cmdUZlJySWdSeXVWQzdnWG8wUjhCamRGeDRiN1JIZz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7558224-2d6b-4df8-1e3c-08df102a7e0a
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 17:31:20.4038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dghqHAyv1aNmSTQNXjCYdNYSylZyxPSnIkgS66DeRj+JWf8Heio4Nfx5hkPyRgisMgu8Ps60Dda4Gn4Ca998g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB3464

On Fri, Sep 11, 2026 at 05:04:06PM +0200, Petr Pavlu wrote:
> linux/module.h appears in roughly 15k #include directives across the
> kernel. This makes it a "hot" header, so it should avoid pulling in
> unnecessary definitions.
> 
> The header currently includes linux/error-injection.h to obtain the
> definition of `struct error_injection_entry`. However, this is unnecessary
> because the type is only referenced in the file as a pointer, for which an
> incomplete type is sufficient.
> 
> Remove the linux/error-injection.h include from linux/module.h and add it
> to kernel/module/main.c instead, where
> `sizeof(struct error_injection_entry)` is actually needed.
> 
> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
> ---
>  include/linux/module.h | 1 -
>  kernel/module/main.c   | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 96cc98568eea..b3a3d5827384 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -24,7 +24,6 @@
>  #include <linux/jump_label.h>
>  #include <linux/export.h>
>  #include <linux/rbtree_latch.h>
> -#include <linux/error-injection.h>
>  #include <linux/tracepoint-defs.h>
>  #include <linux/srcu.h>
>  #include <linux/static_call_types.h>
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index d0e1e0bd2ad0..f1392c10907a 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -60,6 +60,7 @@
>  #include <linux/codetag.h>
>  #include <linux/debugfs.h>
>  #include <linux/execmem.h>
> +#include <linux/error-injection.h>
>  #include <uapi/linux/module.h>
>  #include "internal.h"
>  
> 
> -- 
> 2.55.0

Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>

-- 
Aaron Tomlin
