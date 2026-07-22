Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010006.outbound.protection.outlook.com [52.101.46.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7758F14B950;
	Wed, 22 Jul 2026 04:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784693739; cv=fail; b=GhbKioJksE1inrjUNoCKxiffDhvE1vsmF38nFR0Lu2JNQdTVeROEOJdNcydl0X0CflwobQVwMtXJembWhJj7qzO+Oe33lqJpfna/Rp81wQHLMgRMQv/sPg/tnksoqMsRwcnXPhLLtnK4GxHod3KyPBAriXVtWcm2N5u2kBOaFnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784693739; c=relaxed/simple;
	bh=IQOx2pmxXWBWXSFpyzJ7igopZdlMKd6FVlB3qsAU1Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tB8Ucjg+uAr1vAMogO21noZo9+yY+5YdSGI5QlzSTrquQV0cTMwtgku7LA7tuGUstL5RqnxMo+IjSL13iFRnxz+h27XP1+lPP7Da+FN069VTGFvKJ5UVmFN2HLm5oGCAuDHhNxjOuvca9JHQ9CxMlPUk2xSefi6N/6iEBugTWFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hrYkOkCV; arc=fail smtp.client-ip=52.101.46.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hrYkOkCV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hrG4ycUsD8B7stl8DlmXq+d9G4NE/PP3t1e51rWngvLeBqGG2y93ZEwFEVwS8nhTDKIIh9m81bF+Kqsg+iIHQKBWAYPrCN/MJZnbXQApVH4qrAIPNnJ+jKcwUGwMWWDXivKmRopDaesQW1MALLP6p5/lAc5pHa0CIA8LAE82fC2mYZ/UZraMXn35W2AgU3BPhPrQziCBVd7s30u+ujlfEXzNwvwqWGTlGQ0XX0N0ELvL/PH6SQVwGkMoawO8OjqZsSQSEMINLhvxglLQpHyzn2VUUwvfsy2yDLQt8fjw+8x51EqoRwyQH+cU8xH4Kpd7S+KLGH/G8h204QEVTK3dvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQOx2pmxXWBWXSFpyzJ7igopZdlMKd6FVlB3qsAU1Pk=;
 b=VuU6MterpseUtA/ldExf9fGZmYDBK6kKhyqbZR+cpgVARJRCJ6HSsqwQQkU/96p5fuKIznO9FhxHnyT5NXAhT8kRBNLBICjf03L+MfXB6zR+dUEzq3q5Ld5z6pnraqAnnMXp9EO9jdSQaVpPIdyfWZIstzhXQPZws2b8oz7EJVOqXYUTQ3R19Hbw/oVIilyOUZywhvzNRGMsx4dHx5CHRf61CCvXXm9lLeThLNM6KLeDlR89I3cCRkqO4NK1XNYI15iUjoVnvuBubYz+nl6S2iIfUioimziWU0qUSmjydHinBYrDbeim2GUbHXEpca7mTprdgAUxCT/bi5fF9WryQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQOx2pmxXWBWXSFpyzJ7igopZdlMKd6FVlB3qsAU1Pk=;
 b=hrYkOkCVhwBUIS824R/3GaB7pJdBZEM3yyT9b5zKhdO3v44prPX/VluE8Z+xv8U421In1KdKw5YYp/C0YXO9tWP+288LnfcIb5Ny49KfWf+OM/d7+1WMI9CpTXgZea+iuU8ix4/gdbkCWBIAi8h284KsUtUErSqbOYF8MCcTovcyzvImvo+ZW/eWeynCO4gH2dWZSy7IWDw+pp1I6s6AY3oJWvAy1f6Tmo6DDGbbbogIKORMGom2SMkVDV59WHQBqCO1Ux3AHN4I8lROuQUJapD9T+vZRrGCHoTEctN86p01RBVlR96mcoQ40t9h+FdmL99wRzrb5J6crmQm2Z8OVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4168.namprd12.prod.outlook.com (2603:10b6:610:a8::7)
 by IA1PR12MB8538.namprd12.prod.outlook.com (2603:10b6:208:455::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 04:15:35 +0000
Received: from CH2PR12MB4168.namprd12.prod.outlook.com
 ([fe80::762:c8d0:c9ed:ebcd]) by CH2PR12MB4168.namprd12.prod.outlook.com
 ([fe80::762:c8d0:c9ed:ebcd%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 04:15:35 +0000
From: Jonah Walker <jonahw@nvidia.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH] drm/fourcc: Add P212, P410 and P412 formats
Date: Wed, 22 Jul 2026 04:15:33 +0000
Message-ID: <20260722041533.941126-1-jonahw@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702212355.1072804-1-jonahw@nvidia.com>
References: <20260702212355.1072804-1-jonahw@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0159.namprd05.prod.outlook.com
 (2603:10b6:a03:339::14) To CH2PR12MB4168.namprd12.prod.outlook.com
 (2603:10b6:610:a8::7)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4168:EE_|IA1PR12MB8538:EE_
X-MS-Office365-Filtering-Correlation-Id: 2afba17e-cf11-4424-4d48-08dee7a7e0cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZKlKax7i/0ODJ6QVJ/uUKMxuJrsjngKA/Vu3AawdpVCmjlVFcBHejJdYqApE+qAJexp1hPHRJaPaPDUkuKdjUuLV9ETEDXh+t9S5ll9KpOqRRcIJ3G/4mneLPvy6QPEWEyAODSnj04RpifVvePdbAVOrCZ6UlsblBvuIHvi8FTBUWtDgIVZIg+7mIpwssAAzXpoNmv3eO8FrgoLZEF6WoNsoaNiGA9hrqBgr7d+jJO3z99xQQQTchMb53wFn6VanLrXFwdp3oWyln65K0PNlZ7BRGZNxwBkyIsp1/TJA3+BwTnRgY6YcfbuiC4ZxlHV55HCBSJgNLFEjartYUOXoRIc0iuRzNdI9RnL7efTfVrrsGMrAWca4StbT1ltuQTONe1d7JQSQWuHzBBrr9fiZ0Tbyi21B8vcJE8xJkPH4DrdZWzACB1dohd1+tBkpfeII8xzD3CuEhoXVqTRJ89B6PjYwGJxPw8pEurtLyuPxz72KQTqWxuPzcXi4Bn8PT7DjzuOptYJKAScLnjWOngFjCH2K5RCDu1bFRUIzt2HMRZDiCUxRy6uiPrN0Qj4JS/SEmDO33ynbfQ9EB2JKD0GBvZhZogAfW4soZ7qOI5Jxg8fiH4aKtcRdxEl7yEpVVfAautSTgz5MCEUSjix9o0Cc+0S1aJfD6i0iLdSSvI3xCwk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4168.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wyA2gf8TSEziUu6tyulGNatg/DnhKoUC1SErKTJ+NeXGbEwga1XSzUjXX+JE?=
 =?us-ascii?Q?HXqJ8oc/r29J/LpKd2RDbvSogM7tpTeI4lfavs30w9+PyLQjk+LZilk8suAK?=
 =?us-ascii?Q?YqL1tLWgAxLkbTHqwD/7Kls6wAjMhlw1ZZ/OSoYPtetvHRkpF7ScksIrHSPc?=
 =?us-ascii?Q?7Jh6FVaYU/pM6JoLjzfVUmFC2QWV3rKBOPORordofSAB+lQ/Aqrft4mSrwd3?=
 =?us-ascii?Q?64v1/DNHnk8XnlTapsuUQitjVxBRq1pYSFYS8fMJGeoSfJsnC1wRyznkHIp7?=
 =?us-ascii?Q?PBqc9rNcKaLReALvGMvcmu6QOx2dxgHlkbm9VRSXjaEqm2SqFTgmQSFwJun7?=
 =?us-ascii?Q?4+gJ35GXZY2eEkhRyp8hkH7IUtxJkJt8xNbamuqRdy48UzzJI1qu7pgzAwy+?=
 =?us-ascii?Q?QaFMIkILhbTWwVhvK14kX7n2U82OMJo9Os+HRy8lJd8GiJ07vgc4DL7j2WMZ?=
 =?us-ascii?Q?lI5oJ/mOrh0pnJUn6JVGAL0/NuPvjnsNFYkf0MDyJfv7R9moJDei5lGzvrGR?=
 =?us-ascii?Q?2lGFswxRdH/kZC24BzIqrWL7KAJvUwsfvDAnuggCS4Iypxvh3EBIyHrSXa2s?=
 =?us-ascii?Q?lqtSAmrziGHHDvn/T7ZjsmRvVaXbovW7mP0o6WpfPz9W9e6GiQxpQWoNLV5f?=
 =?us-ascii?Q?DE8KWaKOH4Au9JhOWeZVCuYZkx5pnZeH8FSybfvaaUPyFvLjJyVUoYUR3Cxo?=
 =?us-ascii?Q?kl+qGVWlgElxiFObe6lmPhgQezmFizzOwG2KX7VE63qIKorEtoQ4RJKor18z?=
 =?us-ascii?Q?Pw8ccN2ursUfgNqPfEeCngBGDktGgXe6aC1w6K2DEkQEx2OSpAjh7bzfOy12?=
 =?us-ascii?Q?zrYzh637pbuh551OcDG09PEcKuhbEpYxC8jxrVgD8+S7Ybb60PggvHMw6Y1A?=
 =?us-ascii?Q?hXcwZA74yp+9ge0lO7S1m6FJmyElq1AwATdJGiq8oafIBx8SCpRUQ1ZIRY/H?=
 =?us-ascii?Q?J2FkQMUyJTFgtOGOuPPBBJGLfMc0wOJDMZ0OKOsk/Aj99fJ5Ei+koGbYtBBY?=
 =?us-ascii?Q?I8/Uv5MHs4g0vIu0iX6J1JJgzeQ1x1LFBweBfNatO2lHFEObLXgIlUkWutXM?=
 =?us-ascii?Q?QztIfUrRjy+RXyjIO+vODhDtFDQOLbzvtIzGupFfbX7wUBJhpr9VznSQ5Uf8?=
 =?us-ascii?Q?rA0GbNoZhYFsjGRBrNUbesaVZG8FcvpvFknETYxu6PCckFekLgTm5fbeYcr5?=
 =?us-ascii?Q?kJG6Y2uIgi18lx/sv9IkIsR7L6EoGg6PElb48FInPt5VN4hUsebH6j+LC78q?=
 =?us-ascii?Q?ZF+Yw1/PAcrEGdtTrw0J5C7PSmiPhRIO1Gnqo92WgLDLA+Vt3co/WOZyN37v?=
 =?us-ascii?Q?7N6LFrqIP0+iQDTnYY+tryCtEU59F2OXDSxJQtJa2+ZSgx9Xr7v9qdaa0MST?=
 =?us-ascii?Q?5Gv+7ewsGeo1F/rlDGVDTshDgNY44IzZBQYCi2SKJKSaBEBGUvUY4p8eJ75Z?=
 =?us-ascii?Q?34i2K13a1Umt2IDZOVyxwnAhLZIh8XRtejCUayFqHBXZMvwdJoyk1yWTic7O?=
 =?us-ascii?Q?+32bVFUl6o/k/WG79hes0YjmSvDK1hx94VinPidxU17xH3grVipsgqOw1EEH?=
 =?us-ascii?Q?KBU5D3uBCXg7PsTFnYZ4nFLHgLjHSku44CY9GvPrfVGYSjpwgEIowAcF5jP2?=
 =?us-ascii?Q?iuRYRtebLzpKBbR3HJvxfX0eL4g9sGQr9o1ZErwtiaiVTeCB+5VniMZb+oKP?=
 =?us-ascii?Q?iNB3Xb7BJq2V8jwkZFPMMhqJwdgh6/h3O4fAtt9qWvUn++pJ6eb1qk+jp+la?=
 =?us-ascii?Q?7TNa8f5KrQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2afba17e-cf11-4424-4d48-08dee7a7e0cc
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4168.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 04:15:35.1026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DfswPuH8GC//GoWX318z7eOZtl6wmBAnVKIhOw0kCTYOJ9gq1PDSzSRCFC1oo3YLTyrypxr7BRi+0gMFFl5xVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8538

Hello,

Friendly ping -- any comments for this patch?
https://lore.kernel.org/all/20260702212355.1072804-1-jonahw@nvidia.com/

Thanks,
Jonah
