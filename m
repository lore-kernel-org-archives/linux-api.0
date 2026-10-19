Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792450629;
	b=Kl3MYSwD6iacxEFKI4KRLareGW791l/2/+5ohHJWwfpTs8nXbdPKGZaKeGqBFXx3SnHo
	 CcGgR+PXmp/fpMhXUdpysdmxa+fxbSPUAxoQVDlhBFtW/ZlocC2OS9E7rQKEI2Hz3KZOa
	 NopokfaInHQARPswpVLwDCD9ykcZbWXdygoZGZKYxscRJBp3jsiApkhPKGthu1BTezNZU
	 PywkTTh1aDgFfcVieufm/cJ0/JxYHgFg4eOub5CIisFQkur65aQL7ow36V9UGOqxxHWEV
	 00kF2T6GjNTlZ8hKr8WulbfpUnfP8Umwb1vuA5+YThBDfJ9UosBN6A5nUVSRT/O10HA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792450629;
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
	bh=HB9YdqYDzF2JFgvrnqNwMAmbEjVBHUn0Bou8pSLV8ak=;
	b=h13K0alwGNQQ8Weh3JJ9PQwF4BkYMlh60CQsahmx6hR7u/tX0XPdoM9GoY+sPgBzYG5P
	 QvDRnp4T6So1M416vVcHUEcsTkbvxDAwzF9rTTsPMHOUKecUnOoY0WFTr8VxPYCExfkfT
	 pqzzOfALLl7UbM7ucfid553q+wlR0SC2nbqwaPYOfzRdZttgpStpz42xwA0J75uotekX7
	 EZIgg4mdOk4hVarrQ03E5jJ1BExaVZcBTI5y3sX6+sCxk78TlQutsh7nP+ZCc9ZXxDh9C
	 u22t0XWYPtKuj9fROvHaKLJofnFlgSthr5sWyz8Cw6lBftNNDmWuv72n+rPrPgyr8Tw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iPJKdc5j;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.44
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012044.outbound.protection.outlook.com [40.107.209.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B35606A31B;
	Mon, 19 Oct 2026 22:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9B35606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iPJKdc5j
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PgcZFCdSFogb+AxVUVMd5Q9fchwnpmweIJ3cX2Zn12n4lVOY3k1vzXqwE16hRjNf3KjfLEe7LEXu7748qKaRX+vTq4FCvASHyU8kQiA8nsyrGKVk5+4tmVXoTs6sccgGOYGK+ZzZ0vV7iuyCdpMycRYJBhoQQyrKlZT82vxC6asNFjkXthnAGFTmkJ+IdhQJnY3iJ7VXKkjc8giVDNquhJ6SZ9wlICEckwyTr366FCeYs/k42hKPrdx3N5Hi0O50J+TdN2+hFqrPjNsfIEtjVj1Ob26OxASbiWjYsY5PELoby7M4bjCBabnwZF5nD4GImLHjTV5wp0GW95F+s+OwRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HB9YdqYDzF2JFgvrnqNwMAmbEjVBHUn0Bou8pSLV8ak=;
 b=pHzzB+YlbzkftvJz/+FpCL93HANPXB3sp9tO98Y7+oqVKX1EAD5sr4OQCg0cfNSilX0s0hxk8WS8t0NK2kweMu1HGZ43sEbi4Jm3Wd6DVSEymHwe+4lMtHT18WDOQitjj2Le0wfrfj9NkXSjipNTPxC8VuKCW/WLTGLYtKoNXcO2hbsQf8yGz7P+1wt/qrhF54fdt1V5vrm6XmPcvPXstowJtEaSEFVrpJQ84aVgBviH3/khiu0Qf6M68nCFUqsoLED3tnFL7tKikxz9EyeKP0oejTmoI/GEdM3ppINcNWLCiDWJ37KpHuiEdol2NTUzWTb2H59jZgt/AQrCPvz6UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HB9YdqYDzF2JFgvrnqNwMAmbEjVBHUn0Bou8pSLV8ak=;
 b=iPJKdc5j0fJB8TAj9nem13tCkBXmnDfNv+P7LBMog8FKADiR5oa+03Fab79cd2DuclF74tkPn2U0kGvlCZjA/ZfhKtpRYUIA3t9O5/LxgDP7ExAtJwAtRMB/Kk2PhozFYWtMFRzVBal9kKz7yCIBGnUdwmkASUlFYWpQ9MouW6vWqawXXhA404wMVqaBwFXPsofPay+5q9KOysdSwtG36wOICEpGF13A7GZhJl/RnpLS7MPZfyDHPcpt6iGa/x2oc2lAwzBOizzw8wZSY9fQ7pyKgNalZZMQ0zK+zvKw8AxntK+FgXg8CtkzPSrJkKfdfPHoONmNiwJ9XwVuKHOmUA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS5PPFFF21E27DC.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::66b) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 22:57:00 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 22:57:00 +0000
Date: Mon, 19 Oct 2026 19:56:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dionna Glaze <drdeeglaze@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Jarkko Sakkinen <jarkko@kernel.org>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	roberto.sassu@huawei.com, zohar@linux.ibm.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261019225658.GS13920@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com>
 <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
X-ClientProxiedBy: BN9PR03CA0934.namprd03.prod.outlook.com
 (2603:10b6:408:108::9) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS5PPFFF21E27DC:EE_
X-MS-Office365-Filtering-Correlation-Id: a80fe9c5-036b-4427-de91-08df2e344883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|18002099003|22082099003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	dmxTYJy1uYrJn4nd0I4CAeHSYUch49DkhCFYnE5+syIJXm+qgIn3H4pQVtu43tEDNKQ8shbTtPN/G1jHJ6cy/BCiORmRtkxAKOa38zY5ih4Sz3EaMqcfnP34D1yxYKEuoOyxn+H9uwcUovBbprdGTr18YUQ9XrH9bw6vZH0fRrBN6pXIRFfblDQCRmpyQrsa3th4e4M7HFRIFBD7X16+LQoeONC1Z3fo2mC1wbWCL6OXaBvRrqsnJFnelUUtQDEat6e8UqTSn5HvmhAXp0+IolE/4RdH4Wp7O5NJFge6Y9FrghDKDpBpox/RJox8uXkwPo22Oj+mKLWOJ6jssK9dG2a3JBOM2TGmd7kyad/sfZLfTj1B1Q8upRr86e22K6RncqLgK3P6dW2/3jdnbOuOfkxzqJUsGqbb0pCjPaPxNF6WXZcnGr4l8j8gldPWWw31N5/DOvdBYqviOszH6IRDZSFJ5ictnZ75tWb8vEsLNn/HrXtZ/OZnShI0ETBkTTBOSWEAPUzfQOOuXVVM0eYiyhI7vj/wFWnNOm8u5EN6m4pnym0iZLwj0lienIlniZImAqqCM2xiktlJVytx/RP0LQPYgS6H82/IdpBrueUw/WF7/YjTN69reSKowmZ45F8Tz9GyPMsO3MisV45GC6R0RCxETKcwhkU6gv85VnG93lY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGpjNWJKeGhEeVlpT1Q2WXN6aXExRE9EUmVpeUVheDlCUzdxNlNmWldZOW5z?=
 =?utf-8?B?R3lpQjRJbDBUclRuOVR0Qk92dkhPYXN3a0tQdnJUM0RobzBrSDJEZXc3alhY?=
 =?utf-8?B?elFJT2xSMGYrVFQ4bnBXKzU0eldSN1NNZGhZQkExWktYWHc4TVZWMEcxMDNZ?=
 =?utf-8?B?d0IyUU9TamI4ZUc2c2dzNW9WWUpPeVRIZngzcU5qeFdKSjFubmx1cW1PVS9x?=
 =?utf-8?B?R1c1anA0SGhYWjJERldFUURZTWZ1RVhDVjQvVmxUVHRDZ0VVYW1EU3BNcWZM?=
 =?utf-8?B?VWEwWDR3T3Ara0NkbHVTcnpMRkpmTE1tajNhQ3dwOE5VZjg1a3FNSm5tOE1L?=
 =?utf-8?B?UWdwQWdRSTduelJsSHZadVhTYXZhL0tMOHBFeld3YWdsZTdZZzkyVlFrbVhp?=
 =?utf-8?B?UEQxWXR3N0JtdHN0RllPRlFjRkJobFZIZU15bnpHMmlONldtOFVvZ1ZBOFdK?=
 =?utf-8?B?eERjWnNkL01qWkE0WUFscUFBUC9rbUlJQnZZQnYwYUY3ZFcwRU5wSWxOT1B3?=
 =?utf-8?B?MUNkVGZod2loUjU5UFBrRHBCM3ZOeWs3V0RSLzIzQ3Nrbm1Cc2E2NWg3UjRy?=
 =?utf-8?B?OGFnU0x4MnVPY2I4VmZUc3NZQjkvNXJQY21IY1EyWk9xK0M5S095Z1RTK2Na?=
 =?utf-8?B?RkVtNWRrSnN1T09Pc09HbDU5UG8rd25YTXZVSzBWREVsbEFpL2N0dzd2eFA3?=
 =?utf-8?B?M2ZnMWpDUk54Q0RTZUdGSjJvZ1E5bXNwNnFtZ2FnSHkyUVR1ZWZyTnhtTHhi?=
 =?utf-8?B?NDZSckwrekdrV3YraDU0TW95MUtTSmcxSGtWTk81QUVGRjR0RFBBQmpYSTJH?=
 =?utf-8?B?dHZyL0lFTWk0eXdYYXNkeGVxM0dBUHo1VG9kTWdXRmdhOTdiYUlKQk9ldHRK?=
 =?utf-8?B?RU9ndGo4emZEQnJsMDRtR0tLalhTVWk2VEcrcEorQUVneXF3TlRrUFVyVkxX?=
 =?utf-8?B?cmtxQzNiZ2kyTGxEbWtWdHUxeTJwQllMdnl3U0E2YVBxVTJSeWJuZUtsUnJN?=
 =?utf-8?B?ZTNlU1RQbWJ2ejhxcytsbVlrLzkrV04wSXpjWmIzcElNRHBxSDIzcXhHT3ha?=
 =?utf-8?B?R1lScjgvaUEvNUlpTlloVFZIWU1jZmtLRk84OUk3VXlISDB3czRTc1pZblA2?=
 =?utf-8?B?UHpmQUhrYnlnbmV2OEdVaXUzUmFUTjc1Mk5kUHRmUDcvRDg3MTkwd1c1SmJM?=
 =?utf-8?B?Uit0UjZCRkdWOHExMkVFWXhaeGp1ZGZUN0EvdTkxUlNWYTVtMXR6VkpJaTl3?=
 =?utf-8?B?clNFemVVZXM0TThVY2NMMXpCK3pITjhoenB5cGNSR0FLaWFFNnhTdzNmeVh5?=
 =?utf-8?B?dnE1d1lRMEV5TndUL21QTWgxaW5CY3FIZ0UwUWlSVmYxdFRDT2YzbkZCNmcr?=
 =?utf-8?B?Uzdxb3pucGZXaE1yWTJUaEJKMVlWS1FSM09yYzJuSjhDVmY4ZkhYei85YjRr?=
 =?utf-8?B?d1dRQkhRWXJlRDgraXJIbTRma1pyK3BSN3EwajRBNVF6Qk9UMUVLOE9nMm5h?=
 =?utf-8?B?MExCOUVwKzlDVlBTM3d4TWdUNk5sYzVHai9WZVBjbmRhRE9wL29vZGpsR1Zl?=
 =?utf-8?B?UExKVlNSbmsvcnZzZ3dzNHBsQkxkUkdMeW5SYm9XMmpXRFhYV2l3TTdHeE9V?=
 =?utf-8?B?VzNFUWZYdTd1eFV4MXN6dUo3cTdOQUZTb1N0eU84M2NKQmNVL1JPVTJmeUsz?=
 =?utf-8?B?VUI5ditqb0Zrd0E2cEFjeUFNb2R0M0U4OUd4K2svUjVBSHp4a3ZZMEFVL2R5?=
 =?utf-8?B?Tll3UEIrU1Zwd1NuVEVrbUJsZ0tybFY0dWZyeTRsVU9ZRllhK0RhcVJ0NXhi?=
 =?utf-8?B?SFFYcDJLbHJTc004cW5nVE5OZTdBcXJQbjN4enpMSWdrdUFjb0pWYzU4bUQ5?=
 =?utf-8?B?UGRaNEZSM2ptdHhmTEhiY05DYzJ5U1Z1TWRESXprT3BNVTgrT2pDdjEvQVE0?=
 =?utf-8?B?VURCVGd6aFRmRkFMVWJBNWlacm0rVzdhaitPT1JBL2cxZjY2a3NRaHJ0OEwv?=
 =?utf-8?B?U1hoZUJXMkp4SGozeVVRK3d4R1JWdWRhVHlTTUg0WHJtMXRaZEF1WkorbGJq?=
 =?utf-8?B?LytOV3JiNTJxZkQ5WkhoMXlxRzRmcXBXc1JHd0taUlZ6Smw2SUI0aHB3T0NU?=
 =?utf-8?B?SHBpUjNjSy83TnhVSVlCWTZ3Zmc2WjJBbHltaDkwVm1IWjRZYk9ycTRaZ09G?=
 =?utf-8?B?MWt2SkpPNE8zVWcxQ01qYzlwcmFaN0xQemR3WC9GRXNMWkVVT1A5TUtQKzk4?=
 =?utf-8?B?OHgvMmF5YU1IMW9McmRnY1RKMEwwU3dpQWVqMjNMUitvc0tzZFBISnR0c1NO?=
 =?utf-8?Q?tV6mo+VU2UAyNKsu9o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a80fe9c5-036b-4427-de91-08df2e344883
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 22:57:00.0793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5btIAh3KnB/4kgtatPI5DmJx8v2Al8g9N0KD4S1txnxhK9oqELzXgbXONPr2uPWX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFFF21E27DC

On Mon, Oct 19, 2026 at 09:10:31AM -0700, Dionna Glaze wrote:
> On Mon, Oct 19, 2026 at 5:08 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >
> > Yeah, I was thinking about this and went back and forth. In the end, the
> > only reason for leaving it unbounded is to allow multiple independent
> > users of the same register. For example, IMA and systemd could share a
> > TDX RTMR. The systemd side would read the journal through the
> > attestation device and the IMA side through securityfs, but both are
> > views of the same journal. If one side truncated it, the other could no
> > longer replay the RTMR. Isn't this the valid usecase? Do you see how to
> > resolve this?
> >
> 
> Bright minds have spent a significant amount of time working on this.
> 
> +Roberto Sassu, +Mimi Zohar
> IMA logs and systemd logs are both system level concerns that are
> relevant to the OS construction, not individual users,
> so I would just say to reroute IMA to use ctlv using a kernel config
> setting, then make systemd the new system manager of the holistic log.
> The securityfs log contents can simply say, "log managed by ctlv" in
> this setting, in the form of the template identifier.
> For policy violations, only the 0... extend needs to go to ctlv.
> IMA can still keep its violation log as a ring buffer when it's not a
> 1-to-1 violation to extension
> https://www.youtube.com/watch?v=gyYUYbdiN_4

I think for now we should not include a new dynamic log here, the uAPI
around this Jiri drafted can remain a future step. I don't want to
open complicated discussions about new functionality at this
stage. The whole CTLV idea in general is a big enough thing to bite
off for this series.

What is important at this point is for the static CCGL log for TDX to
come out through this interface and be affiliated with the TDX
driver.

With only 4 measurement registers in CCA and TDX we probably have to
do *something* but it should be well consulted and not buried in this
big thing..

Jason
