Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011060.outbound.protection.outlook.com [40.107.208.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5D229D288;
	Fri, 16 Oct 2026 23:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792194240; cv=fail; b=ec4EH/6CSfaXIpykhzGwxfeb/c/njAlxpMn0YLjMxSMjSSZM5YGtNyOtD2eBSmXZ092EJHrhqQVHRjF69mI3zPmaFIg3YDTCa1MFKkI7EPvWsjPHLJf79zjt57e/iBO0qz9q56UR+xf7IKX54F/dHVAekos3bnea+zQ6CVjRmLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792194240; c=relaxed/simple;
	bh=/nn8x0lzdQHmDX0oGmBnvidyd6qV6hWlksD7A7upm4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bMCds1/ThhKrd/lUZwa9jOYLErVRRoHbBlHeLO0qEE9aYlS9HbFBnhToxRwQVPodfI3ssaOLfZj1j5/+mVAqXu6lS/jIEi7grCxsG082Ds0qoC0jCGgbaeg0XgKXD3JysYKwoxywDbXxhZXG7STvCxysQiD9ve9mm3TUsIZAyjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d2z4fQLh; arc=fail smtp.client-ip=40.107.208.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d2z4fQLh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7NMGQyzylyVx57pDae5BbrOJxkwXadRUZIj/kmzge7rxI5+OqTQsMGrn0YMFG3sLzcUUIdUuyM+sS7Hvf6k5FR5H76bGkak8tEj4nZRq5tslh4cnp5m1Ynl5UAHs9xH9j0+rSR/VwLviw5DLEW18WavnRgAJ9OOrHuY7QvQ/7ivsy+IoRki3CHZIr7XU8OcG9p2LsrjsgsL/q5q2TE4ZMgoNfBU1QiwpOvnlSDSUcIeXchWPT3fj8s5cdssFJisI1L04jt+qA+YueuUdRRUQK03f9mwhsRJjNdJWE/CgI7rjj63JZiS2xd/bg8Q8MT3D+uRXcI3/zKzivTqmgkfmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAWjvz1ExE6t4FXF2EvzjI2aEQMCzbMfc93MLaenuqI=;
 b=JApploNOkIIb4VG2CYlvtRhOlJIvNlLZZvrxae/CScTzbmhs7ANI3yNiSTX2QWY97RyAI9wKMRaWEYfNkCYypkVqREQfViVSM0hJQE/aOpEweP5+Mv7Km5N/lItmww2fTXNoUZtgn4TvBAz4Ma2Z+stzEQhIfGZpoDtTguC72UWLfUGE7rJ25iGZTrATSEGUM6y1GV2HKP/MyjuyS7IiNgtd5kRs7YQ+BLdpF1N/x+WcdeUzsEFr0Dpev2sTE9A14Q+zDMGadV3ZBRx6v6zCJEqbgFh1fBM9zXb14Vo8aUK2G5gsHoeBLCyfVcAbwIdh3jMRM6/wekRLlL/knEcKTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NAWjvz1ExE6t4FXF2EvzjI2aEQMCzbMfc93MLaenuqI=;
 b=d2z4fQLhQ6suQ6trgkfHG+ZJPHvu00CrQi4o+d9aYclNaKuOniUmxxYvS0Oa+gshtbhcyEYTt7WYxUkCPUeCoMe+JYNWM4PLdkEhtKG6GX2ONR7EUMDwVz9m5Txk8j8jbSJxtF3wOgTmgUhQwRBGjEjHgBgLJQyybQ+PpP9p8zzgCko1uBds3xLCRYKit8sLi8o18RQ21m/Y7njU7LEP68G9RdxvhcXXxKYeiF9/Ip5TUbQREqMYZb6ezwhP9pRRrn69a1xYbCkt1eYd6z8a+f0Ba5VCcFYXJu4Ot5iGPVAwlbeUDYh5jQgRavcYUEGNDzLPejnSBL9rqCdhAaT5IA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by SJ2PR12MB9115.namprd12.prod.outlook.com
 (2603:10b6:a03:55c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 23:43:55 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0522.016; Fri, 16 Oct 2026
 23:43:55 +0000
Date: Fri, 16 Oct 2026 20:43:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261016234354.GA664420@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015145053.3664509-1-jiri@resnulli.us>
X-ClientProxiedBy: YT4PR01CA0252.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::24) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|SJ2PR12MB9115:EE_
X-MS-Office365-Filtering-Correlation-Id: cfd1f139-8584-4640-a026-08df2bdf5757
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|366016|6133799003|10067099003|18002099003|22082099003|3023799007|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	6cc57foRuhQvv6IP8X2C29HhhKODh21YUg2i3ykY/eWt0AN73lrQ+FmMCFOVRPZXIUektDix1/EBNo4lle48KBOO1RDvOZIZkp7nQDPK/801Qp/qNes0FCt0keTstB/KTNJyWvx8NuMfGryrMqveBgzshVdckcjBfmJxVCKKXtsW+Z/dqk8vifj0+WIE60pDTIpq3rQuadpVYCm82BFzg1QbceHQEsHARKjesiWkjbdlZvBs4AAoYJnCzNzwfLOQeDPuKoCf6K5ORun5c8CzSdTup486Ed2Ck9vgYmTn+TDfS1wv26orIJRmN9uNY3ToTRIqz/uMPs7088zxPxm1xleUYu1x2H++Wm9LmKrZPc4BII6bJmGuw/OPttdSMojctM78Pm5E2ncH3VawlKMCXkAg3vQnLou/PHZZG/AR8JbY2EBAnE70I8cjXmsakhM/O6k6hmOgaVDxB0DFZrOuupXtjkvMSMfnHVpmX+Ti+AzSVerkM+2LrR5y2xT/QwQSWXGsUfp+GXeZqC4RRiWwrLXZw+QH5j8RtYJtmAMRox+UgZxFK+CZhl5+NgDiFM0gRj3Cb8jXAtBCFTPlmJ45xR6lYukMDLhdZ654+jC3H3N9mEqeZYgyMgWF8bGZVeIyXT1iKbx9kxicior2qoiTz5f0dfiRyekXmnLuV9KcCQo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(366016)(6133799003)(10067099003)(18002099003)(22082099003)(3023799007)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?spU70kwkUZRR6anIlDvkCIFUsKMs0dUFSRGiovupMmxdITdkEuQhWFgoMiW2?=
 =?us-ascii?Q?QgoSlGz3wPJNcNH5bm5k6agD+BMd7/dtEuaf5YpaZqOYcgpAm1Isb7tlta3Z?=
 =?us-ascii?Q?DpFwl1ts3EFA3yEfGXRjJyAkkcAhq9KnufNpMqEgthjb6FxyroYDXlpVH6FO?=
 =?us-ascii?Q?JD3S62OBaId/iQYp+hlhTWXH+PWFbV2LADh3k3D07q4oeHj7DlQYvT+WRZ8/?=
 =?us-ascii?Q?hkKz2rCpPNCuAsKw/zq34niJQXvr6YO3ZOopkiVIY4QzB4pQx9wGUI60aCFP?=
 =?us-ascii?Q?0vi2puTOIsPdH40Woun/xPvn9MImTwB0P4+K3G6WlFMMCxOObWgKhTQ6NalO?=
 =?us-ascii?Q?ed4EQwFhQdEhcJKrVO8nrsT+8FOi7gcZbU0CX7JGuzQNxEbnE8xriwnC2UDn?=
 =?us-ascii?Q?whBZc7u5jXGbAOJchS8rPg9K0mIOsjrCObXHuvx2rkmaq2MNYxbHUQKSCiwL?=
 =?us-ascii?Q?/YAB+mtwfJwd7GiY5mgOt7yeXbMxVpA5Ur3mpo1ieEEfH2l/OWVatZecakIg?=
 =?us-ascii?Q?mvJY9/cDebBSy2lvArL97XQC2Vikch8YWSMFrdNpJZs1VlmbAFoV8nuNtf+G?=
 =?us-ascii?Q?epaGl+xsbjTnjppHnsfW2az3zwLOxlTVoQhhpuF/J9nhWmB+4lHqsvAPQDkm?=
 =?us-ascii?Q?g7ycOHis+Trd6ddQYUp+tIdHpk62k9M56M7gRg6kHh8ATtVv9O/K8AfTYHZM?=
 =?us-ascii?Q?t+5yoVxodR2l+D6Kg1YQ6AejtcuHLL2O4lc534WFPQT/UhvJ8RZsu8U1vJYw?=
 =?us-ascii?Q?Y1g7+noJwl3CeedNls4+YCx4Ehc2Vv/zwUQG7E89eIAcfp064dDzsh0y/9Vn?=
 =?us-ascii?Q?Dfiu3RU+2FDRr1U5iwfSDCUZaNtQrslcXD85qAdZqOCfjmmjFRZYedw9TGaJ?=
 =?us-ascii?Q?YRjB+fgwx8YI0risFXtTJgI5U0KxqvowtNoGscuK5Io2kChK0wnNwi79aHzH?=
 =?us-ascii?Q?AJHnqAOUsPl7r5Q5d0IGoCgO51uevyRkJMZuZ9tnR6TrhfC5pvxH2QK67+BJ?=
 =?us-ascii?Q?x+BMKOsMr6oFbMH/Cc3eVK3J7iRnzciSp/8H5KNEv1Z5GkR5A/mr8FHHmsZr?=
 =?us-ascii?Q?MR/l7YPoVm2w91VhXewjLTEDF9HPyHWcwkDgVkG/vePkABThdhzvi1npSANE?=
 =?us-ascii?Q?E3jl0LgTwvwH4+RPwpkyT4qHGjMlnrjRBxQp0t+Y9933O1aHy0w76UeeDk8B?=
 =?us-ascii?Q?OJGVRGBhbE79ZGm6sGh5oYRDPrD6HSm/v89WSmyR8nt3BbtGIJVMCJyIe/8g?=
 =?us-ascii?Q?7ZfrjQbFgxzIsJrV08X+3lSWfxXCbEnhuFB4TZq8bmqlPWiWsYMId2p2U1Id?=
 =?us-ascii?Q?V/f8YHMeVF+GWuAVl33Uh9rY0EpEFaeu0ezLCScKamfVAbjFiScmaDBcwocW?=
 =?us-ascii?Q?Fwrd0QijGEoSQVIwArBuvyAkZ9FIGLPSo2oRt48nPcvJBaoLYXPKdpZyWU83?=
 =?us-ascii?Q?BL5/MmbM+wFjdDFcyKJZSOK0AJQgd6Y8s8Wn0+0jqitYqfxLfleX4I9lUdo8?=
 =?us-ascii?Q?t8wD3GzUTCjJJlXu24v3XbyuPpf/MFFpfP1XNErvCmyQ/vxeg+3JBzFH+kLA?=
 =?us-ascii?Q?77E6hqwHN98GyizYcNeK4nEnHkquxPz1COS8TJMzs4ouR+sOPS7I+5kdWe7W?=
 =?us-ascii?Q?/nxLYIEnMWXaN4pUO4LGIo/zKOUuMFUJQQZffmeti2SMbaDkvaBpRqssScmh?=
 =?us-ascii?Q?BiwsLDMqWWyHXk4/ez5o5EPDSq387aLHueyuzbZRkKoYzAwH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd1f139-8584-4640-a026-08df2bdf5757
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 23:43:55.4878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GzpLRXto55xFTWs62fXN3ixu67f/6DgT89HKBlacElwt0OBK/KzxkrM/8kVrQsVf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9115

On Thu, Oct 15, 2026 at 04:50:33PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Linux has several attestation interfaces tied to individual technologies.
> That makes evidence retrieval, measurement registers, device state and
> kernel consumers provider-specific.
> 
> This series introduces a common attestation subsystem. Its goal is to
> support platform, TEE and device providers through one model, including
> TPM2, TDX, SEV-SNP, Arm CCA, FIRME, Caliptra and PCI/TSM-backed devices.
> This first series implements the common subsystem and a TDX provider.
> Existing native TDX tsm_mr and tsm_report interfaces remain independent.

To add some more colour on where this came from for others..

About 3 months ago we started looking simultaneously how to support
roots of trust (ROT) HW in place of TPM and how to respond to the
feedback on the netlink proposal for the TSM SPDM.

We began talking about generalizing tsm_mr to handle more than just
"tsm" into a broader set of roots of trust, including TPM. In this way
it could act as a multiplexor for any measurement user in the kernel,
like IMA for example. I see others have independently come to a
similar conclusion that IMA needs ROT agility, but I also know that
DRTM needs the same ROT agility too.

Bringing in the SPDM side, the netlink TLV uAPI fits nicely and can
expose all the structured binary data it has. SPDM is also effectively
a ROT without any measurement registers.

Combining the two needs together it seemed apparent that TSM is a bad
name for this expanded purpose so we start calling this attestation
subsystem. "root of trust" subsystem would be another way to look at
it.

The general notion is any root of trust can come with a single driver
and expose a bunch of different uAPIs. The modern most capable one
would be the CTLV based ioctl interface through a char dev, but in
cases like TDX the legacy uAPIs will also remain supported.

In this way I view it as a further evolution of the tsm report and tsm
mr components in a way that lets us harmonize the uAPI and avoid
hardcoding things in userspace. Though the name has changed so this
linage is not quite as apparent.

For example the end goal is for systemd report to be able to
dynamically enumerate all the ROTs in the system, include them in the
report, and generate signatures. Without necessarily requiring ROT
specific code.

This applies to SPDM as well, ultimately every SPDM user in the kernel
should be able to get an attestation subystem cdev and flow through
the same uAPI channels that PCIe TSM uses, also into systemd for
measuring and logging.

I'm looking at something like 7-10 ROT drivers just for the current
set of NVIDIA ARM servers. Probably another ~5 for NVDIA non-ARM
servers. Then a couple more down the road. It is alot of variety and
today all this HW is largely unavailable through Linux.

Jason
