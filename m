Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793023694;
	b=OoG5XRcWU+IwulqBW4qhBItP8ilq+ncOpKO3BD1kD0QJmgvH6GbYpogvFMOrU8CnSKoP
	 5SScESINbv7H9NVvp54fcCIzcw54QClS31ygkUZIBe0bZoROFJ8n9gYQ4Xj/VAyF0T7Ty
	 qCXTaRiRR9bK/Iv5BR+DLC/ppDUnfcHVp9g4cV0pR28JEE0pIfYiiOr8lPTHOK1i9OSEf
	 eptrfUXMfyC4nLHvHE21S5703yOIy+pmBVQRIZTF2NWWH+Ag1jgrhSF/FbOhTdqJ//WhX
	 fq7rYmV6Pgn8TbjoqxfdCJM8/pOlrkOpQqTTigMjC2cdOulbVTRiLb96f45DbEeD8ZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793023694;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:References:
	 Date:Message-Id:X-Mailer:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=HUKosdFuWGGM/GGE1aqHFsnqoSet1pY9R+lr6zd6vdg=;
	b=zzKWsrnU223GTpbYuPcd7V5EipEP5kbm4HCnmDMv840u6JpCMq2uFdBUoYxfMGlDFeUe
	 iFPFetfJ2hK99xwq0VwpYgJbWAWa/dYBWR6d9Aeosb5vjvqYPH7UFx89wKUfSeGmNZIuB
	 qWnoK15XBOrASoJ0Vza3dFR6UKv1+XRx7jSVuVqMuYGQG3L3D42k6MgwASeG44C+9tAEn
	 nYTmU7MBk4NjxosKz8XR4zzg+Jfzl7HyN/+IM+6p67Re9kqKhfpq535VCFIrxDia1O1lo
	 fME86+poV2u5mFx/qY9K1RAAmpjqmC4YoCrSk6PHjncBZFzqwSFmrNadQ4CjaW12DnA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WdbeVwSH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.33
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54C6606A328;
	Mon, 26 Oct 2026 14:08:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B54C6606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WdbeVwSH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YqprhL18CBEo6fAuiSMgXZPrVQl94FwHEtH5hDLQQ04Kz39VXake5rhzs4NYAuodkN2P0xL6hZ/DspZQAxmGoj9lmRYa2Csrn8Lf8MXN/53Emc9EwBFaLwH/5V/i/47NWNMlaDXAL0AN/7aQfmzfVGgN4buGMXyCRgn2TvJ6asfdeTICOMPh36FvHRjzXWfyuVbNatoLluYUygZHasxNGgpUrUdyaKF3l74oBhoIrvK94t1eR2gt5bYE9sI5tFSzZA/Yi+1Q6PwV1tHZsncLjBrGiWOVBs7LziPm0FRS5c+NAKyg3VUGmzuORlv8phRfcpDzb4/Fqmy3nogizwaMzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUKosdFuWGGM/GGE1aqHFsnqoSet1pY9R+lr6zd6vdg=;
 b=KPYnoVkLdwKKZ+lG8W1GwURmk18aRO1poOvjJkhwmgUkS3Ze6OUN4+KNNTAvnWusDH95AMI42alWR85zaSf0MA8r2EBT6f4p9oR2Qsvwxg1/NpMR5SulICW0ZPB3OgU/DLNtbO7eaZmL/jR5OO4hVdzAAHgJz1ppfFqG8jhx+wNi6Ud4BbD0ByQurngryFHVft0dcJAn9L8uKZxAzvUF7eFxtObO5Bviu3uE+B5FsmzcTDstrFtP/mXHiodxPEay51GLMZ7a2qLU+lt1qTRfoe4LCJ4vjasPJ87N6BNxt+jSc8MF/u8SWkjLhwOQHhvo5/YkMJPMV6p0Q+s/eb+hyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUKosdFuWGGM/GGE1aqHFsnqoSet1pY9R+lr6zd6vdg=;
 b=WdbeVwSHvulQBAdrmBfP+MpAgo2giWxW0AHKUQvbjRVqMgsgyLxwFurNwJIsr5B6a3HwbxBZekhW/bX6645yVHFworXw+Z+sieL81plKOdrDO+4O4V/p3/eWyXeq3eJTK/zZhTsjF1EP+KlLluGz5vCeqYLaCieK3xOQC9TI8xXgGmeZL+vMWmb5raPNr23a+cKumkxdvGQzXZbqePFPwM/QtERoyqF1BBCFr6Vc4AsjQwAIudBII5A8tlA9h2dcGjBz11BaJdwMFpO7JoiihmbsquCA33GJ8TrirUqGquYRJIx0unlSya6qukzXuSN8UrDveRTJAJw4cJLCeTF6sA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB5961.namprd12.prod.outlook.com
 (2603:10b6:8:68::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 14:08:02 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 14:08:02 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC 05/20] ctlv: Prepare message input handling
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com, 
 lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
 cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
 James.Bottomley@HansenPartnership.com, aik@amd.com, jpiotrowski@nvidia.com, 
 qinkun@google.com, pgonda@google.com, jic23@kernel.org, 
 alistair.francis@wdc.com, ankita@nvidia.com, suzuki.poulose@arm.com, 
 kas@kernel.org, rick.p.edgecombe@intel.com, elena.reshetova@intel.com, 
 dave.hansen@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com, 
 peter.fang@intel.com
In-Reply-To: <20261015145053.3664509-6-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-6-jiri@resnulli.us>
Date: Mon, 26 Oct 2026 11:07:54 -0300
Message-Id: <179302367449.58760.13616210130636541456.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0037.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::10) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b55be30-8398-417e-8303-08df336a8bdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|4143699003|56012099006|11063799006|261009223027099003|261022105027099003|261021130227099003|261022113327099003|261022075727099003|261021135927099003|261022115727099003|261021121427099003|261021123027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	6fU9u60Gw/FmzZsGMELJEmGEEOZOJKer7lELut3hzKcxPJKWu4gw0gmRC4v1RaNpWlnRNl81Xf6T3yELxgBVGErbmtuQgEq27Dkr+fRWyUiVDt4JIYxbxifNpeKeRjjOc07uSo3vne2kSEz2NutJukJ228UQUz0W5Xq06VPT3ZzbLHJgJBzpApI3ajv1AaVxbPhCWdwpGi5N4NFdygZrU9m8kUatjgcX4N8e53IwPA3yaD9/yk8OWZg5cNbDwpAfW3OgiAegMn5ZAH/IZOHUIkfLld6fRHcuPmRzLghpmeNgVNyTaV37KzUfkeGFAK4Id7oztXj4jzUWwUtIvRKr1khApZaayj/mplwQwVGtpCPObRyRUNVeOrALukYipDaq2EDS0dSMBSX96LXt7bZeVIao3W0esTnD2Eh9eRx21zCPlj8f7Fc1TJagAhEsf6m+PZBCO6VAheSmKhkwk8ZCAvv1AL2KmJX0VSENLG6oyvZ1bA9jlDiSFNdSCr8JW0Ww7Esr1APnIfylFk7sIVjlqt5AUxRyO1wZryDbBysQLk4svWdN5P9p/9FTfLOqyW4JAk+Nwa6490nrHxJ/qMxO39SvDjQcnoQDtqU8gopWP86XpLh/5XtzFAO6rsz/iVC8wuyQZXwkFD7U5Le5BN/rY/1OZTQaTDB/I1eJesC1VjA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(4143699003)(56012099006)(11063799006)(261009223027099003)(261022105027099003)(261021130227099003)(261022113327099003)(261022075727099003)(261021135927099003)(261022115727099003)(261021121427099003)(261021123027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2FWRHREL0pyNmgvUExGY2h1UDlxQithUkpMM2RRbk5jdW5lQmFTK0RWbWZa?=
 =?utf-8?B?ZVZacUZGdjJZMGNwWEtEbzhpWGh4emU3NWtOa3NBWGJ2ZTJnZkViMU1HOEFs?=
 =?utf-8?B?Mm91NkN3SXhPVUNHd042bU12aGFsb1JEbWdrWkFsWkxIMU4xNStEMGlRUFlG?=
 =?utf-8?B?ZGYwTnhkVWZ2bkgvR1NHYW4yUzlFQ0ttRFZIM3p0bFJXTzlRL09VMEsvTkV3?=
 =?utf-8?B?NkJXc3dSdmF1ZzF6RDZodGZSRkxDSW4yT2xZYVFZd1NIbE96RmhST0M0b3RU?=
 =?utf-8?B?NTRKaW9YMDMvNHNNQkt4bjNjWU50QnQ4aTQrRUhmeGorTWUwRHRGOVNmNDB4?=
 =?utf-8?B?b0REbnQ0YVZ4T2xLbEZKRWhjOG90ZVZMS1gxRjRLRC9BZ3lhNFIzaDhEOGNx?=
 =?utf-8?B?dUVCSGNZSWh2WEk0ekdhOVVUTUZKa1JEUWh0b3VyRHNSd0tMeHVEcHhDaTR3?=
 =?utf-8?B?eVllZHNyOEJlOEc4Q1FWZUhrMmsybTJTZzgxSnZiTjBUdFpxajVRNHI3N21J?=
 =?utf-8?B?ekFpaTlBcHgzVFlxMDBSUWR3T2dLb2t6SHZ3ZkdROUlXcTAzWEFuN0ZWWW9a?=
 =?utf-8?B?aGpjTDMxVG1EeGVvRzZFR1RTV08vMy9SNGpKRU5MS3ZHa3hadW45QnZCaEJr?=
 =?utf-8?B?emZOOTBQdkkvV2lpaTdCOE1UbkhQVUNSb3NmQzdUNXlhMjRWcjZOMTJCQUk4?=
 =?utf-8?B?RG5OQ2VKQ1kraUhIbm5oREdqbEFOTHJPZ0xUYmh6UWRZZE9JbnJpeWl3WWJX?=
 =?utf-8?B?VnZuU2w2MEp5SzZPN0Q3S1E0NXNRY0JSeXBoQ1crUVZ6VlhIWkpLK3lnN2xt?=
 =?utf-8?B?WkdwVnBsZmRkc2hScGQ1eUV4UGN5eTZGZ0pyd05YM0FlRGY1ZE1sRGNOcTVH?=
 =?utf-8?B?NDcxU2FJQmlHZlhzQW50VnJDdXpDbXNYYWFEZTRnTEcxeERvVnZEMlQvbm1P?=
 =?utf-8?B?aHNrKzZYNVEvY0xLa3NTeFNUYjJmYWo4c2FBaUJFQUxYLzZsOGd6Vk1FMFM5?=
 =?utf-8?B?Z2RhZTE1UTAxeE9KZnhXN2wwcVdpZmlCRXpaelIyMmpGVVBqQ2VISEFnSlc4?=
 =?utf-8?B?TFlibEthaEo4cU81YjR1S0cwaGxieFl5Ti80dndQRC9Fdzh6cngxVEI0RVFu?=
 =?utf-8?B?VEZVeERHeHYrdklTU2Y1Y29MVkJFSGVyV2ZtMmU3V29id0lnaEF3T0FYL0Z4?=
 =?utf-8?B?SFh6YnYxOGtFbU9ncU9OTUpGUy9QQTdYRVNWdFl0YmhRVFM5cWdRdWFTNEo2?=
 =?utf-8?B?QS8wUDY4c01xa2crVjVGY2tGaXBJcHVXRFZXL1lvY0lwMmR4cmoxaUJKQkhG?=
 =?utf-8?B?elZvc1ZOMENidkFiNVZIc3pBSy9FNk1OcHR1RGhEVDVaejVmbzlsNjhmYmo3?=
 =?utf-8?B?L0MwZ0diNnFReGlaNjllNGt0K3pHekV1cno5RHJTdUhQcTJ4alo1RmxqendH?=
 =?utf-8?B?SWt6bktsTUpnMWtoNGt6VjRUVGdVMTVkSWR2UjNpYUE5c1h6ZDFPVERkankx?=
 =?utf-8?B?enVTMDB1cy82OFVGMGN2a1ZabVUxWXVRcjA3ekdXMDJpUGhxL3hJdzVDNE9X?=
 =?utf-8?B?U0xabkw4RW92WXp6RHYxa3Iyc0EwUFMvb3pVc1NBcWhWV0MyTHpOTWpJblBT?=
 =?utf-8?B?anBwREorT0J3TWI2dHFUOWxLY0twNVgydy82enhwVUFpY05YSU43b3hCZ0ZP?=
 =?utf-8?B?SE93RzY5RUVZUW9TTXZteWJYNnJla3dwYmtBQ3ZtVzhyZGljMEtIMmVyY2t6?=
 =?utf-8?B?dGhVQWc4ZGhld0Q4dmdPc0x4N0ozOG55WDBmNUZJZFh3UWQvNUp4WWc1Nlln?=
 =?utf-8?B?dExRS1ZudkkzLzhMT1p4MWRNZDZLQVJ5MXpZRjM0M2ZzZ2VtdUhUZTdONS9u?=
 =?utf-8?B?aW96Mm5DR0IwMGhrRkQ2MnlRWVVnWk9oT041UmdZMFlSbUZESm9yWTVudGJJ?=
 =?utf-8?B?MURhSy9iUnBQd2Vrem1KYTFpSGRFSHM3YWxTSXBXeVVvR1pHSmZ2VVpBOUsx?=
 =?utf-8?B?UnVNL25UK1JYRXBna1ZiMHZ5RjZDSnkyYWFqMW1LVlNZUWYvWmFrTW12VU5m?=
 =?utf-8?B?bGs0eXFPSWZDU0ZCa2xsZzBoSTlsZjA0bG1VWmUwdE4wYTZoeldBcFpHZ09v?=
 =?utf-8?B?eWlHeHRaUkdqT3NSak4xRy8xWlU3cWNqV0FROWNJU0t3NURHZTliRWkrRTlP?=
 =?utf-8?B?WXJHYVpjL3VKMHo4Wlk4ZmtwWTZNTnd3QTNZVTdXU3lOTmhqcDNPd0xVekJC?=
 =?utf-8?B?RHpYbG9QbGM1aUZxZzRlc1FONHI3RmdGb1dPZytxL055VUVEekd1dktycFBF?=
 =?utf-8?Q?iBH+EJxN0A80aW0SFG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b55be30-8398-417e-8303-08df336a8bdc
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 14:08:01.7272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDiD7RBGjSzHdLIFVULS2AHnfWnLDA52HH4SzhocTYiTmHdi3hIvP3oSZqdeSzNe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5961

> [ ... 38 lines skipped ... ]
> --- /dev/null
> +++ b/drivers/ctlv/Kconfig
> @@ -0,0 +1,12 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +menuconfig CTLV
> +	tristate "CTLV character device TLV UAPI"
> +	help
> +	  CTLV provides character device UAPIs described by a checked-in YAML
> +	  specification. It owns the character device lifetime, the strict TLV
> +	  message format, request validation, reply serialization, the large
> +	  payloads a request describes rather than carries, per-open event
> +	  queues and runtime schema introspection, so families only implement
> +	  semantics.
> +
> +	  If you don't know what to do here, say N.

This should probably just be a simple selectable config instead of a
full blown menuconfig. ie one with no description. Since this is
really just a tool for subsystems to use every subsystem that uses it
should just select it.

So:

config CTLV
   bool


> [ ... 159 lines skipped ... ]
> +static bool ctlv_message_nest_index_ok(const struct ctlv_cursor *nest)
> +{
> +	const struct ctlv_message_input_index *index = nest->msg->index;
> +	const struct ctlv_message_input_nest *indexed;
> +	const struct ctlv_message_input_scope *scope;
> +	const struct ctlv_attr *attr;
> +
> +	if (WARN_ON_ONCE(!nest->msg->request || !index ||
> +			 nest->index_nest_scope >= index->scopes_count))
> +		return false;
> +	scope = &index->scopes[nest->index_nest_scope];
> +	if (WARN_ON_ONCE(scope->nest >= index->nests_count))
> +		return false;
> +	indexed = &index->nests[scope->nest];
> +	attr = (const void *)((const u8 *)nest->msg->root + indexed->offset);
> +	if (WARN_ON_ONCE(attr != nest->attr))
> +		return false;
> +	return !WARN_ON_ONCE(scope->tree != nest->tree || scope->node != nest->node);

Maybe wrap these invariant assertions in a helper and we can compile
them out?

  #ifdef CONFIG_CTLV_DEBUG
  #define CTLV_ASSERT(xxx) WARN_ON_ONCE(xxx)
  #endif

It helps manage expectations around WARN_ON. I assume these have all
been checked to guarentee they cannot be triggered by users space?

-- 
Jason
