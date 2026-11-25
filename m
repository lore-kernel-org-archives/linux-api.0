Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795565966;
	b=wKathdWgKjW0DcG3tHqdKdaFngqW4uANLSArypEvKNhfF6uxMrYVVFt+ef/KWz35G/ne
	 BN/n32wWJWRjJH+yJ2XmDeoBf7y9++rI6LsLfQp/EV923rPy94jfj5TGOCCJI5dYx7Hzl
	 RGJaFvP28l0rL7dAXCX2AJBVm6v81ZAYOWZ9HzqErh+8jXRP71m1AvjfADH5bbfpvz/+f
	 7nVgkVHqbcx/EmXdQaGWHXPvNX9ohFqE8r7Ibu5jDkEkBykNHt470zBKRclkJxfZrFjla
	 Te3sqO2MWIE1lwSaEnViMmwGonDmAmPtO+Qv3NLAnyWkao6yYTteDUbsCqKPvB3R2uQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795565966;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID;
	bh=gok2exRVQ0WVJp7KbYwSC2DYsKLZjtX6QKGp73k7jsk=;
	b=nmMkCUWRDJlkEmku6Bz+DYhFam+NakesHyBCerTl+ctuj4tTDvWHmSARc1KLROn/18Vn
	 YS8PAoSx92Ic3SC++euJKC0AJkOING2suePBS+gTfKLYblhTEernoqPfHwD8Wc98+tdFc
	 dn12zvFlRqqKgbEVklWKbNHHguJSI15ShrZ2JUaVH1thVD/1pbNrMqjKDiMkk8D1/YWt8
	 J29j9RmnKactGXi8U9Yc3Wfm8VAdVHL0hauIn92OjP99KekynZLaeLD5oIZ/DWVMo1G2u
	 O/hsoqd9ygQhr5z5xwB8Zooi8TMcfkh3rhERFyhzXQJZQprl2T26YoSB0L+vio2gTsw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2026-11-19 header.b=zLreatk4;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=tNIDw7ei;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69146606A333;
	Wed, 25 Nov 2026 00:19:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69146606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2026-11-19 header.b=zLreatk4;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=tNIDw7ei
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMbUl22593781;
	Wed, 25 Nov 2026 00:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2026-11-19; bh=gok2exRVQ0WVJp7KbYwSC2DYsKLZjtX6QKGp73k7jsk=; b=
	zLreatk4FRe8VJHDxuXeTrURL1e6Dvw4OtMlxGZkxdDZJ2RGZlYdR4Nu+QJLybBx
	gYcgaS7jKb3fhsCbBS8lnL1nrhZzyVbgnnzhpgm7oa0OzG//7Z6k+p9FwP19cGNd
	1bVRP8jQIXVuRe5OEbQ9fY8RRzTsX4Jk6+cYj8AumkPsForl8OCNlh+hYSS7o1cb
	Wj5tBkcKXzDsZVFZy5PsKXGHffj83pP5WGJa1rNbU13IKkAY5ldAIOOjrz5QqbVd
	6jxBeRt++BV0d38ikCcF+dqdp+kpey240xhSdMi8D0Xzgi4UkU7aqDLlE/CuBjTh
	YMMAOjHVsaX9HH6K7q6Elw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t7n1vt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Wed, 25 Nov 2026 00:18:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMYPYJ1319158;
	Wed, 25 Nov 2026 00:18:32 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010017.outbound.protection.outlook.com [52.101.201.17])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j5jut4bex-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Wed, 25 Nov 2026 00:18:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epma1/TLlXbVHpMC0Ee4mWxKBlOLxeZJ9eYwO1akAU6hSyfNAB8ZJ6RUqekYM8vC5zvOAkLppNtUqfgSO5MxJ7irFs5MYTkVEFgLN43MSoOj0r9LZHchR+y9e/IARKAAMXqfte2f2xjr5yQM/fdRHNEKnOB9tRb0rXyRR+SQr3v1VHeQoakTYBrXLbGGy5O2jwWalULf1qm5HuBOs1XlwGdk4mfNgxLwQo6R2MjEME9Msh9Da4MdXm+hiVtbbZborRYgzQoR/oXrhDAKZEMfRrv/NGLAZHSTDga95NwYaKgUuZBMuGTDUZ4o61BWCdwYdoN2PSf0Wfu0Lz++ZR0ovg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gok2exRVQ0WVJp7KbYwSC2DYsKLZjtX6QKGp73k7jsk=;
 b=DJpQPMyYjsdHQhKQFzaGR9YyO6kTUXiIJ3zQ8svYC479dFo8h1f3D5shEkxufkOsqVf3m9M1FLTL/Jc6WYKfbPuSaHljRcNDlAt32QwSmKL1zzB+PD3ityMUcFWt03HMqL1pALVrbJoEbiBmw8mqszOhHqjHIxr3RPXWoDlQ4YS70U+c5vk4dPtNI6b3vXvJSzBrmQX0a9CkhzRMxl8of4ijb7lFZApc/HrBA4BOf5GaUUPzC04RouzqIv+4rCzbqE3z9k6Wcnw95MAg+g+/q6PQpKt6SragO8vGSgr6DwPIqhXPj95DRi7Nuuc9aVcS9nJs2Z1BF//SukTgRiYRVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gok2exRVQ0WVJp7KbYwSC2DYsKLZjtX6QKGp73k7jsk=;
 b=tNIDw7eiFCch2QOZDSXpJKtxNnxz5mVK7Dnibr+mKJ0TOJ8r1Hgm/BAAWgdn6mNXXMF96OyyI5y1rOwU3OyMvNt3EJ515CombE6Dx3gR1cx0OzWWL/BDAyW7+Otyra/erdDSBhK43L6lpdgZzlE1jBr1Kq8tuEizy7uB+Y9k3/s=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from IA0PR10MB7349.namprd10.prod.outlook.com (2603:10b6:208:40d::10)
 by SJ0PR10MB6327.namprd10.prod.outlook.com (2603:10b6:a03:44d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 00:17:57 +0000
Received: from IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::1e7a:452e:f372:b522]) by IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::1e7a:452e:f372:b522%5]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 00:17:57 +0000
Message-ID: <4a04e29e-a0d9-43e9-ac90-34a36d6a7904@oracle.com>
Date: Wed, 25 Nov 2026 01:17:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] selftests/mm: test userspace MFR for HugeTLB
 hugepage
To: Jiaqi Yan <jiaqiyan@google.com>, linmiaohe@huawei.com,
        muchun.song@linux.dev
Cc: nao.horiguchi@gmail.com, ljs@kernel.org, vbabka@kernel.org,
        tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org,
        akpm@linux-foundation.org, osalvador@suse.de, rientjes@google.com,
        duenwen@google.com, jthoughton@google.com, jgg@nvidia.com,
        ankita@nvidia.com, peterx@redhat.com, sidhartha.kumar@oracle.com,
        ziy@nvidia.com, skhan@linuxfoundation.org, corbet@lwn.net,
        david@kernel.org, dave.hansen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20261115160105.2507650-1-jiaqiyan@google.com>
 <20261115160105.2507650-3-jiaqiyan@google.com>
From: William Roche <william.roche@oracle.com>
Content-Language: en-US, fr
In-Reply-To: <20261115160105.2507650-3-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::15) To IA0PR10MB7349.namprd10.prod.outlook.com
 (2603:10b6:208:40d::10)
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
X-MS-TrafficTypeDiagnostic: IA0PR10MB7349:EE_|SJ0PR10MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: bce93c29-7104-4b45-6b61-08df4a898e2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|18002099003|22082099003|261022105027099003|261022113327099003|261022075727099003|261026140227099003|261026121527099003|261028144727099003|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	cX7AX+Z5a4J9tGl3RpNuQDKkxURegkGzIxTXgBqM327xEVGrs3GNW/0wgChDjh1pWpfD8TG2kGvIUxxwgdVfarxDEFXbTjX3sP8PGl9Juhy000h7KohE2psCJSviU3RUpwxdirKscPt1dVuyfSWobRrPBmx6vB2iP/G0DwJevYw8xAyyKEJ5ODY7ir8na91g+Qz3PO8ZpTiEx3VgZSryvtd97rO//Ipcey53xBkCtD25AV+7lXKBaZE4veYRiAtdyJd76XZbWq8qyrqZHZpVGifMnbwR2FBuGCQg792e9LQI+y/dXU8klyyIz4jcue4kPL9+QUVKlXuFfdNQI8wFug9c50GXTzqorg7PQ7mzsElFpuVSySx+6TYgCrUI+JcOB9ucI61Hle34z53QBAzj1AvfyZQSws7RW+kG648gGtfmfi3QjZwZAx8g+PJTYv8cIxfFGDDb9dCLKI3TxOKByzzAmuV6NsZnzCKkgyx9i7pmZIDKi8gbqWY0B9dwIZ565M+e7YaeTFtptxu70IIweFoCrMcdKbFn5iGiaObYCqfJxlRvbLauf1llBpjyxEJ7cp0fHhX85G843reINo0qilrwaVso17Tys3HF8OhIIhj754/JL+5s9BY3fI8Jw6PB0vG37hMtkl0fXkrQOWuITMF1hZcyb4Pg4f35DC/xJQY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7349.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(18002099003)(22082099003)(261022105027099003)(261022113327099003)(261022075727099003)(261026140227099003)(261026121527099003)(261028144727099003)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWV3VDV0Umh0Q1RLdDFYbzJMN0tQVmZtMFkzeldCSlFIZkhQZ0p6MkY4MnpI?=
 =?utf-8?B?RFYxR3FZVjQxN3RKNjlveFBIYWxUc1FudTR3TGFNcC9MRituekhOS21WWWxP?=
 =?utf-8?B?YllNckZOT0VIakFPRmpCUmdGZWNiOUt5cWRqREtKWFpjRGd3dW0wNWJZSlF6?=
 =?utf-8?B?TEh3VEtITjZQN3F2L3VtWlRqSERQY0g2cUNKa1NJWUlVbHovakpjTmdEQ0Jh?=
 =?utf-8?B?dnhpZGhzZzNWY2dOR1FTR1BHV2tVUFNsWlIrV2tqZXBBYWFGWG1hYUZmSGNw?=
 =?utf-8?B?enhGYVhPdWlEbk1ESnZaaWhWT3ZVSWNmK3VjRzVqZHpUdnJKSmUxRERGZG16?=
 =?utf-8?B?a0dmNjJQSml0REFQcnNVK3lpK3FyVU5CcmgvVW1SVS90Y3VjUjNXb3p6KytN?=
 =?utf-8?B?d3hHRzh6MEdhZWF1SGQwb3h1VUN3ZGVJUG5MdjA2c1hTYnBlOXBnd0dtb2NY?=
 =?utf-8?B?MUN3dWM5Zmk5TXExZTVjeENZYWdGOEIrRmQ4VTc3ZFY3V1MrbERvaUJzcUJY?=
 =?utf-8?B?cG5ueG1iZ3RxNy9xTCt3aHlaNnBTdlRqbGVjN2EvNTVuYVhrU21vdk5ZT010?=
 =?utf-8?B?R3U1c1hnc09JQzZkeHlaTk51azdtUktyYVF1SzFpOUxINHVnMm9JTzBrQkdn?=
 =?utf-8?B?YzRXTE8zcjR2ZUh3MTJnb0JyVE1zY0J4WjkzZ2htNlAya05xYlNVQm9RQk1W?=
 =?utf-8?B?OFNpQkg4RFFHY3JidnlFcTd0TkVYbzlmZHpsWUhFQW1xc3F2NnRtWEEvRHQ5?=
 =?utf-8?B?SzYyNGgwOWNnWER4T1lRRGtVTVU1Y1h0UlJpYThwbHg5RDdLM1l1RitFNjBQ?=
 =?utf-8?B?K2NSTmVRTklRZlUxR2tNUFBQYVlLTXN6L2UrUVdZTlVFMnNoaWh4d2ZadDZG?=
 =?utf-8?B?OFJaMzFQYUI0YjlvclRWY1ZPS1lOM2Y3TkFpaW1XR0NvVW05cFJ5WENzRlZK?=
 =?utf-8?B?SHkyU2VSSU5VSU9DTXlHZUIwUFJhRHhKTXpsS3l3dDJBUFlRRlRXdWExd3Ba?=
 =?utf-8?B?TlpDNDh5VWovSmx1YkFGTk1qWTZGTjRMTE9iZmJhOTJrM2U0cytLd3U1a1Zm?=
 =?utf-8?B?VVR2U0pLalhaK2NuTlNPM1laVWdaRmt3SFkwbXZ2VzZmckIveWxMaVlSVEVC?=
 =?utf-8?B?Z0QwWldDVGJEbzFVRWFaR2lMK200eUFibXVOMVpPNWp0VnFZaC9vSVFOOFJz?=
 =?utf-8?B?TDBKTGoyYnNkQXYyTFBSaXBlQ3l6aGNFL2dvMEhzN0drQXRVMUxkWko4Mkdh?=
 =?utf-8?B?alE4ajkwTVNMWTZEMkhvZ0FQMldnbEc0ekQxcFVTcWxxWk5HTFMyZE9wREMx?=
 =?utf-8?B?eVZmMXIyY1JWNythMjVDU1pFd0JrcDdjSGVSVis5UFl5azdkOUxBV2lpV0NQ?=
 =?utf-8?B?SUM0dmtVUkRJNVhVQ1I5ZjZKMXZUaEJBSnZlMytEL0FZdGxuNyt0ZWNZSUdy?=
 =?utf-8?B?cm9lK29FOGJqM0tYY3Q0NE1HWkQzem9zaC9pSnZ3eXVLZ1pvOVdtVG5EV280?=
 =?utf-8?B?MGF0YUJqL3BRMTlGV0pPaTUzYkFlWDFTQ3hMcGJSWHlyQ2R0Um8wVzEyTW1S?=
 =?utf-8?B?QnVTcDRIWFlKamhPOHpUMitCZUNDVFVXb0NDMnBZRjV2SjEzMVA1YjJKalZ4?=
 =?utf-8?B?NFIvbXFnRHZValQxK3VZMXFSaDM5WVh4S2ZGNkxyMjdSQ1BwVERQUjU0TFo0?=
 =?utf-8?B?Z0gwa1oyVXRzUEZ5WmwyVEJCZVZnaEczZmlSYW1mOUlHTjhXL3FUZ245RElq?=
 =?utf-8?B?elZuRWJoeENnQ3c2Y2hVenBUUUUvMytxYzZHZnpoSEJ5NDk1cDVBRjFmdGc2?=
 =?utf-8?B?ZER5UXdBZWpJTVFJVDl5V096Q1lMWDZKTnVXUkUrYnJZMWZwRTdodDZ6TTNM?=
 =?utf-8?B?YnVEaXpta2NOcjlvM28vbGhnZS90dFR1MkwxTERZYzFWWGtXWUErZlh1OWRB?=
 =?utf-8?B?clN5QUlEOU44b1ByRTJiREQ1MyswWUsraGlIVGV2N0hVcEtIQVJ2ZzkrU1h0?=
 =?utf-8?B?UW5VK3RhYWszWUJKVFd6TG03bExFWWt5eWM5cGwyR0QraE1NejlsYTl6Qk9t?=
 =?utf-8?B?MHBEMVVYQlRIeGx5OFJjNmczNXArbG1IMXNHS2dhQmRsczFqT29rVlpUUVk3?=
 =?utf-8?B?L0ZYenhEVGVKV3JzUFlIQ3A0Qm02WVV0dS8zUUxzVHZlT3VhYk90MS8reUZn?=
 =?utf-8?B?Wndkb2grUC9RRjl1N2JaUHdqSjdvM2lQRnNyTTNkVmJmTGxhK1d4bFJTUFdu?=
 =?utf-8?B?YmJ1Rmt6Y3Nzbld2SU5RcnJTUUx3SEZ2Z0dwQXFqQkdGbWhQbmpENWtiUkgr?=
 =?utf-8?B?akluaU1PaEQ5bmJ5YVZxVk1UN2tZNG12U3V6Y3NSQ1k1WVlKU01RTmpqWFR2?=
 =?utf-8?Q?hP+DdIRP5r5nCsMo=3D?=
X-Exchange-RoutingPolicyChecked:
	muEbx4r8uovPPpUYPEM9wl9BJoHuBitDmxuSzXWrItV++wwlttoEWx6cuyszrmFGknlMzJ44O1vKHduYnTIIFBk6Bt313jbcmZvWnTRDMSZAeEubgdNiPbJX5t/Brh3GJB4wPW5wtamnKlOdvv00Hs7/5NaSqLom66QolJbvHihN9paSH4QPdKlqlGsCIxZjRKqXvIsK8acHCqhaN/Kk/EiVLWupU2kBWD/WT98g1rtNYsDAs9Vz0K0DweXRlU/yRcR7zSnC5h+y2f/BiFJtmP8fx+HiojLADRoQvl8q5Eki1RbX+E6sJ1PPT8eAspTE/OF0Sia5KWW8brKiliD12A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	84JvE9/ybMxwVImjwKmD/ZgHp4ou0XEAvKxhaKEaNXL1jxFYM8LTBzR1jr6VAzC1csQlpp4m2BZt0gm1EW5zabdC7MyvZAXe1j6e4XH48hJ4F+srqqCBtdXKLeTq+MC3OlbJrzhcA3LwB6eWyIzpoeW/HRsi26+gvCt4t5MIjChYXGX0WBboI0ApHQCH0DpZsgtyVz0+AfZ2aaCFf0LEIw69GE/NHbIwcb+Ukez6HWni7N16H5t33NZ57V+gjQswaRgxYfKLnFkssuKLdB3bccFdSz2XO9Hoe/12M5+xEn10ghHV/gnRFksWdcVuA76UDuAwUPqZdp1aZxxZnXy6zBCyKZoV9hNeB5zm02qDLScUjFa/4zJn/vAWgiQzSfGIkfLJgEyVgtTJJKq+djPZMH1lKyk/9TE/JjB4XezdorystZuZ65G2jz+XIbKRgNFyWF3b1jx92Q44TXSK3xrDnyCmO2+ZzU8u80T1aqc9mpj+WcfZ0sxCLf/f31OCQtmVXd+p66TZAIEmK9T39z/yEpCwGMvO8vu1iZFxoFzRC+ucc1R57pcHZh57i8ERfJes9sNbauMeDvKFe0T9MzcE873GKToT1rAUd4/YZfj8iT0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce93c29-7104-4b45-6b61-08df4a898e2d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7349.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 00:17:56.9932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsj/eNmuam4pLnVgcqWhBG4OQVC4sIYWcXug555g1M31wUlgPKV1n8r8966ijKJcL9ZX25+WpEpUeuUhG12Hz7Rj2SMeF4oD41542kMYAgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=983 suspectscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611250000
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI1MDAwMCBTYWx0ZWRfX6KfosVWArxVk
 9+a96YMoxmCyDNo6W/at+moopJkt1T7x6KjU3wsscK7uvP6Dqre3g6G2IY3g44N47VU6vkTPwpd
 ZvSfsP0d0RdM/LDoTm/0uy2iz9DWE1VoHfBH9ynjFikunqLPnkON
X-Proofpoint-ORIG-GUID: 8GbvswXuL7Th9c0RnbnM9IoDuLRBNhM5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI1MDAwMCBTYWx0ZWRfX3ejbZxYndD4g
 P4lFlQYOKw/xRS2He/b5i/colfvAr83Tqd0i+QIOlOnUwUS1vCmrV19SqUY/KwJfXoFUvkAGSsL
 ajU5W8k/2mmU166Eu6huemZekG55TVTj+FRREJ8rqsCiKUHc5X2ELmpW5wgJCPTKcjahMb7iqeA
 6iuXNcZbir6atUKX3Xmwr9Gz1PQ72I+ligVh+Hh9U5qAE14IaxNcfgcc0vTMbd8N5FaEEOSLFHd
 ZM52hU60P38p951/TFit2yf48bG0j00E8bcR3TyDnkgf4TXaCDHWPiLpLfu3evMi3vAwxYKQikj
 Py/3wEA6Rd9kyxvv2yyIyRyeodNAn+m/JindprMrc3a2fBAU9Jc2axby5ika1W7/QyV79mbLWI7
 PmdjDwprjDvLXrYXieqC16K486VLca1wdB/fKxnnVSyFNrtHvYYNqEOft/ChwDn+QdNWXc9Xdrk
 EVbmIcK3qq/FhwZQBk6hIVPWWBVD4sN2ISSKBipM=
X-Authority-Analysis: v=2.4 cv=Cocq4X4D c=1 sm=1 tr=0 ts=6b062959 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=jVm0pqy-w_Lvylt8gQkA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:13532
X-Proofpoint-GUID: 8GbvswXuL7Th9c0RnbnM9IoDuLRBNhM5

About the selftest:

The Linux documentation indicates that there is no fixed debugfs mount
point, so we should probably discover the debugfs mount point instead
of assuming it is always /sys/kernel/debug/
My March 20 version did that, but I haven't found a C test program
within selftests that dynamically does that.
So maybe keeping the "/sys/kernel/debug/" would be an acceptable
implementation, and could also be an explicit test prerequisite,
with a clear skip if the interface is unavailable.


I would also suggest to load the hwpoison_inject module before starting.
Something like that should be enough:

         r = system("modprobe hwpoison_inject");
         if (r != 0) {
                 ksft_test_result_fail("Can't probe hwpoison_inject 
kernel module");
                 return -1;
         }

Just in case it's not already there, and we would like to support a
standalone invocation.


I also agree with Chris: The default test should run on 2M pages to
have a better chance to run because of lower requirements.
By default, I would even suggest running 2M test first, followed by the
1G test when that size is supported and sufficient HugeTLB pages are
available.


HTH,
William.
