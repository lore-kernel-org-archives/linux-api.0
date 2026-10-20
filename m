Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792505235;
	b=clrY1C0FKaCEZmkSoxgxS5Qh+Zcq54JaNsfLndzQZLxJoehBD/MTQzMILc01QXgX6F+2
	 mtuAreRpxKA6Lr/S360NTJJkUSJLi57sdLgltZqljeOE38UoUZxPUlBez9204BPkbxEHo
	 8ioru8evUX/3MbHoiPdenfkMtFVAqLqK/Qd89DNqetucqAQN67+2u6PBr3//r+8prQR/j
	 JcJdB6AYFxj0KuqOtZc/3S6FM0CcAOGz4b3Y85DFsR6gJMpJECi7gSISRMURq51f6P8aM
	 fj1sh8jM0aPVPZubDnv7bCsKKQ0yu3IP9oIQTCdTbFi5ZSJTk88jyjEHYMAG0mVgyfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792505235;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
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
	bh=vQYJWqcAONnzK3eNNgqMHY/bCnCXZdHHBqUo5ZldEtk=;
	b=dp75RNKb7SLDx1grdT14pP1IQW6nbyHNPk7SD+goF5AvwdOiYWpJ0/6Q2EoNGeEt0QGC
	 yMyFnQH7yit3dhP6BOu1nUl8espNPyK8yBF2sa+Z3DohMYZaPHu3SZBZpV9Csvk8B5gVY
	 637cYe3FhWrJUPJS4klUAcl5yS0mo4vludI4UAp/Lw+TLBpVJcFQ4yP+WyXi90ao2Nwnd
	 Q9uQB2+AMPb/JRcSrTeVJeSCbvQ3RR3McVQhOhVuUifkobUhjEjl5+LnRQWO4J+bABLwp
	 7oWFJaEXKJWXQjGG/E71ZZIp/ptizQIkphPAjvqyZgXuPWKXBOnKQcqRyA/c5Mi5HwQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=P2PXNJHU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.53
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012053.outbound.protection.outlook.com [52.101.43.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E5E606A32E;
	Tue, 20 Oct 2026 14:07:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26E5E606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=P2PXNJHU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mqm6HNS4LhPuOuSJR7HKXh5ExSSdd0tzYunBwSQVdXZcHXGwJNdz3RmDJg2y/W2gty6D4WCRhPVybLIuN7c7fdro6Fh4Qld/Cn59NbwAuR8lpuE6pgs3G5QqGXyxyGjLDj/wEcK54L6CCKsT9Nr7wlR+uuyzhQtCk5COkxReIpvcaxZ2a6ZXSsK1PysHkLIXIBpvzQSX1cmQlxEE08ZEYpkLqdHryE2OG0pk1W3fEXqsVN3Pwhwb/vELJhnZhX8HdThpvq2POjSHvx3uNnkkbe0HaM43+/FhQ0jdXSXZ7xmbUuC2br+j/V7rMN/esnmYFQ21PkRPByZDNbbQKsjVlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQYJWqcAONnzK3eNNgqMHY/bCnCXZdHHBqUo5ZldEtk=;
 b=Erli6om0LyaSsayyBZHBOueVzw9QhfGKhWzMDyIUCaI1TYhSTzWLpDk0qPsbH2yPZKMxK143z2VKo6ckZ+fzkYmCfP2l/rdfHSDRkKc2Yt03GsuRgZCBwh/FOFZraysVaWAogGsJwZfQNjJ++cagTaXefpnVhF5aHj9TMHIe+x0KiMGM4BOqozCz5UTEx7yW1+gGNHzTzkP9eCH/h7R9B1vP4n+tEHagjYPJRljjaxGVlO/gEK89Hd0NbQYDOlLIrbGVZ8gKeNWbRYuIBC18T6It8CvOk5BNBKjl9YLG0CWN67CUeCrXA9cGDW/d790L8aIs8FItntF+CCzu4OybJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQYJWqcAONnzK3eNNgqMHY/bCnCXZdHHBqUo5ZldEtk=;
 b=P2PXNJHUrTD+fkl7pifsthG8oz2Nynt0qdm9RJIkpGNg2XKmYiK1kXl73KSTRW7mi8hD8i/kTZaG4h1AoEc2TtyEyjDu7Bw8vIr7C0VnzZLFR8nD22cii3N02/mTtSfgOmxrFJxUcMCKK7uCHfdahrVGKIBhGLapUgw8z0EwBXLyQ1kzrgwlGAYa9nz0pRCnaPUMbOqcpeapcKYYkSTClGrHRxSqilgIcQGxt1NlYKxEvRlkMLOvZi9UYoEFQZFDod2oVt+kBvwnULVwWSXHfFElpVuLnjSsP1l1CPLInnMeDHLW2jX24VSZNuzShNols2KX9PezzxhoqxPxyxU9Cw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6158.namprd12.prod.outlook.com
 (2603:10b6:8:a9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 14:06:56 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0546.012; Tue, 20 Oct 2026
 14:06:56 +0000
Date: Tue, 20 Oct 2026 11:06:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Dionna Glaze <drdeeglaze@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Jarkko Sakkinen <jarkko@kernel.org>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	roberto.sassu@huawei.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261020140655.GV13920@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com>
 <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
X-ClientProxiedBy: CH0P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::19) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6158:EE_
X-MS-Office365-Filtering-Correlation-Id: 998990e9-b665-4b9a-d952-08df2eb36643
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|6133799003|10067099003|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	K/rszYfC5ilAYUoYYuikSKhO9DWsZJoH7DDSzifnOBWwc6TFeWR/JVoOzjeOGK+f2JE1uvP9TixdYyXwJdqod35wmK75YEdt67LCpaj8PW13ICXq7zBP0ZI/Yh78uN5EUTp500nXsoDHFpLHFY+TZ/zwaJAROFuU/bRevra7/6DXcYvCNOHpxRYqplHKdVDDYKI5bTbhwNjXWOdf/TlA25rg2i7swcqfSLjpRrATSHtsKKz8lcsg3Ygg0y8+xQhbrWFdzjzD+b0OIUpr2wlimZYChIX8zj44od3gBD7hKyimuje26Nuc+/cTQ3Vypd3EU1Z8GCx8A/gn0vbcnFZ6560fCpMjnnpdXf16Exy/xubnrG8cXeptJpF0nJx1pbGIhG8fdkXAfJqqz92uYWt9OapF0WHaXwsFnR22TtoRm6u2GBTpzvPYHFVXlrvRY58AAjod6VYe9IXmS3EB7ueIVvgk8CT5I3XxoQ5Bd77PJT4c+wJr+gXlSwDFq9p3rO3u3vhaHJCsfBiMdp7UnrYEYoOK3qnzc36bmXk9DSH6jAsrKaaFxEmKAbLeAteM+b0J3iJZBzDGcXVNa9k2EZbLsukOD+VtMc7QY7Z5npkYruKovUDyBAiZ8PsQNE0eCKQeCvOqySvAFcAgrntsno0ZO3JISeRKq2+Ggb2G1u/PXI0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(6133799003)(10067099003)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dm1qbldXM2ViZThnZTZpcVJtMmdya3phdmpabkJXeEh6dTFiaFpDMUdSYVFW?=
 =?utf-8?B?KzlGcGFNdkR6QmdLaitrZWJqSDZhSHNndjE2QmMveFZGZzVIbWdKOWJUK0xI?=
 =?utf-8?B?VDlSM1ZpQm1oYUdTQjZRdXV5WlRYamxNSTR1TlFTc2ZSYVVFbFZHVUk5WFIz?=
 =?utf-8?B?SUtZRCs3ZlJSNFdiajBGdmRQcytucEtDOVR5S2kxc0I4bE94Y0NDYWtPUUVj?=
 =?utf-8?B?SmkwdzdOKzZWVnRhNGZvNVU5U2JkM2VLVkJwMWxMZGpnTnpIanJCTi9kQlZU?=
 =?utf-8?B?TUtJTmQ2c1FPUkVVbFFabFdKYStUUm5LWW9KNk5pVkpWOTJLU3k2bm0rd3RJ?=
 =?utf-8?B?Y0p6bGZFR1Y5VFh1NGpxcFo1Y0cxYWxsOUFVT0hONUZsWnB0NXlDbEN3Mllv?=
 =?utf-8?B?NFRROUVFS1JZN2pkWnA3MlhJL29XZWNyK0dseHRPUytKdnZqY1hDQVVyaEh4?=
 =?utf-8?B?MWt5by8rM2lEZjd1bmJCSll4SzRBNmFDT3hnRi92NlpiM3poSllxM2VhTWd2?=
 =?utf-8?B?VUl6dU1VQytLVlpxUFFCRGFDOUhlN3FyUFF5ck52R0ZJV21lWDdzMlUweE1y?=
 =?utf-8?B?QTA0eUJuK0FXS3hLZklxc2Iwclp2V3B0RXNMYlgvakV6OG5TWXdSRFVXSkJj?=
 =?utf-8?B?RXpJV0IvcURId3hLMnBsdHhBMmlBMnNiM3BVZDZLa042eDkzQ3liL3NGOVpp?=
 =?utf-8?B?eXJlTkRVN2ppeHVVTFlaeHE2KzJEeTZCWHE3clgrV1JwLzR3RmFjQThwSThw?=
 =?utf-8?B?VWxpVERPaFJMQjNOOWIxQytuWjdFd3gxeS9waks5UzhCWlFQbVdhdldCTjhK?=
 =?utf-8?B?aW5sZzgwNCtTVi9WMHhWMnQ3ODdwbmxGeUtXQzllZGpaYUh0RS9jK1VFT3oy?=
 =?utf-8?B?MFI4aWxzNnZPazRpZFZ0aXZhY0puM0cvamZuV21RRE53enNTUktyZURoOHE3?=
 =?utf-8?B?cGhPQ3NSUDhFMThmY0w4M3BGNzVJMkhQRTlaL25oWUpCYllENDNsR0JRNmxo?=
 =?utf-8?B?UEJwdE1RMW5FUWp6ZEFicWsyMDRrNjBhUjRGdnRMcXJHUUYzL2pPajhPUjlQ?=
 =?utf-8?B?TWRxLzVRK0lQNDhFL1NReFAvQUZHQ0FFcm80TUxpWXFFNDVtUzE3WmJoS3VX?=
 =?utf-8?B?TlE4UVd1YVgzMDdTellEbHFFZmQvNWc0N2xEYlRQODNiTUVnNVJiaEFSSXpw?=
 =?utf-8?B?djBDUkxyK25hTk01T21xN2tMTHNNWlNuQktFTXJGM1RjSElQd05GVVk4b29h?=
 =?utf-8?B?U05kZXppemEwS3h4dk8xN3NTK0l6NXcvY0tXLzVFenh3ZTJuSy94cGlhZDd3?=
 =?utf-8?B?SG1WTFd5QmJ1Q3d2dWV3aGhKRWhOWmZNZUtuWUlwU0hKaGpPUnZnU3d4UVRV?=
 =?utf-8?B?c0pLSXlpRVBMVkU3bk5lNkl0R3VNYjhBR1c1R0Fvd3NwTHlLNTNoUmthdmNq?=
 =?utf-8?B?RDlZbXBhTVVLaE9PSU9JanNMS29jV1dqTGJjdy9IcWthYW1lTTJqSURId3Mz?=
 =?utf-8?B?ZXZqajIvV2p4bWtST1dOaVRaZnRoZnAzTTNBV3l2cWhmUVhNNUh0cjdlV2hX?=
 =?utf-8?B?b1Bta1RsNkh5eVlnNGw3Wlh2UGt4OWhzV0hwR0RaSE5DT1FhQmhWUnpuREJZ?=
 =?utf-8?B?WG5GMTlNcWtNM2ticUtzUHBMMHkxZzh5YUpocjNvN1ArNEI1bGdORjJSN0Yv?=
 =?utf-8?B?eUNQQXJITTZwVm9KNDVCeittbEtaUHhHeUFjM2M1TUhSL0piR0UrYngrdHZJ?=
 =?utf-8?B?dUhvc2dqeHl1a1BsdzlQMmNLK1FTMHdzV043eUhsWXpINXhyeUpoN2x5L2xx?=
 =?utf-8?B?emJPSXdXaFdXaFhmVVY1TXRSUnRIK3pHeE9BWGFWK2hNQzNBZW5SeExFbmp6?=
 =?utf-8?B?UjBjak0wdmhscmhUVHdGaWN3aGJWR0NidEpJcy9SVy9Gb3dMNG51dXF5eEpF?=
 =?utf-8?B?WUhMbjM4UFBQTGtkZHJEOTJ6allPL2I5L1NOZDBzNmN4emVuWjRwVjdOYzZJ?=
 =?utf-8?B?WGdrUHRLL2hOMlk4dXRrZ2ZKdUpLSlBvYVNTQTVqKzVobit0SzFNMFFYR29D?=
 =?utf-8?B?Umc0cUdqWjR0Z1VrTk5xNkhaeGZjbkRCVVVQa21iK3hZTTZLcnhrV2ZZZjQw?=
 =?utf-8?B?QmpTekRDRHZzY0kyQWtSSHJBbGR3QjNWRy9pRnBSeENIUkIvOWtzTjVpaUt5?=
 =?utf-8?B?WW1TSm9pbUYvaHhvdjF2Rzk0V1h6ZWQ4Y2hQa01KdFQzMHl4ZE5TeVRwU1I1?=
 =?utf-8?B?WmpUeHd5RzN6d20zT1dCTUs5NXd6M3hhcVd1ZERSdnZoYUN1QUEvY2dxOFVH?=
 =?utf-8?Q?zISqWq9mCG/L4VxNPe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 998990e9-b665-4b9a-d952-08df2eb36643
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 14:06:56.0672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zn5OmPhVL/KmLdlyHOr13PlU9ajIH9elpTEjr9VeTYV0mF/FpYavGFPvByq7HuPS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6158

On Tue, Oct 20, 2026 at 09:45:13AM -0400, Mimi Zohar wrote:
> On Mon, 2026-10-19 at 09:10 -0700, Dionna Glaze wrote:
> > On Mon, Oct 19, 2026 at 5:08 AM Jiri Pirko <jiri@resnulli.us> wrote:
> > > 
> > > Yeah, I was thinking about this and went back and forth. In the end, the
> > > only reason for leaving it unbounded is to allow multiple independent
> > > users of the same register. For example, IMA and systemd could share a
> > > TDX RTMR. The systemd side would read the journal through the
> > > attestation device and the IMA side through securityfs, but both are
> > > views of the same journal. If one side truncated it, the other could no
> > > longer replay the RTMR. Isn't this the valid usecase? Do you see how to
> > > resolve this?
> > > 
> > 
> > Bright minds have spent a significant amount of time working on this.
> > 
> > +Roberto Sassu, +Mimi Zohar
> 
> Dionna, thank you for including us in this discussion.
> 
> Based on my questioning AI, it sounds like the purpose of this patch set is to
> introduce a vendor-agnostic common attestation subsystem framework that can act
> as an internal kernel multiplexor for any measurement consumer, like IMA or
> DRTM. By providing a direct kernel-to-kernel call path, it allows measurements
> to be routed to different Roots of Trust (ROT)—such as physical motherboard
> TPMs, Intel TDX RTMRs, AMD SEV-SNP registers, and PCIe SPDM devices—without
> hardcoding IMA to specific device drivers.

Yeah, I would say that is the eventual goal, this patch series would
be the first small step along those lines

> To support this framework, IMA requires a strict, atomic execution sequence to
> maintain the Measure → Extend → Execute (Measure Before Use) guarantee. This
> initializes early during the late_initcall phase within the initramfs (via
> dracut).
> 
> If the new subsystem introduces a direct kernel-to-kernel multiplexing call
> path, how will it ensure the mandatory synchronous wait behavior when extending
> multiple hardware backends?

Everything has this 'measure before use' requirement. Why would this
be hard? Just loop over all the configured measurement targets if
thats the plan? Maybe I'm missing something?

Jason
