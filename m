Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795566169;
	b=lSLt27vniyXEVoW1W6JBFISj2EPmN/Mcc07ytxzutjepVPlPHzOtOdJPh2Dr7oMu2ebU
	 HnBBhYmXQ9y2ZL0q71PwX1O9m5+eeFL3Z00Y27+GawWJ/TasWzGq0NwIbDXbXZxXQrMkq
	 eaigW3oJre/aUYu6WOww6WMxUXi9K5/NEr0+EJGS4R+UI/ZM2DZVdDo3Qu57Y0Cc4agEk
	 x0RsUSBzstvJ3GNocmvAyFoUkl5C6I5iX3O/PsYnFvW61lKCNyNBue06ttZsybBEby5Ny
	 pmTTIa9V7gBzgZ8x5nG2c3Qvtwldz4AqUpFExc2zkpnzqh0WUVTn5HF5gr3taRXr/Yg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795566169;
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
	bh=Il9z1IYOTaB7XqIZXcKWH+DTpX9ZYjbz4rnOrdaFR6I=;
	b=x66MbS7Lkmab3mAqWFJp1tucUxtgNi5A62P/WEk5OiCw7pPXXRUp6DgKMQblbZ1cGIFA
	 jOxg0pcindQ8nFWwBagbmjr3zkmSu2tKmJZ9Myn0xow6nCWYjY7Ju/cg2DB5aBlsHojQ+
	 nC8KaBsMRC6jcm4hy6dSO6v+Ystf6jsswQdBN4PjwTdT9ufkWx5MHo1YoNlvHxpihxAmc
	 aBbVVMSTz4PWcmaPjTSsleH2oah4Qjx1tgW7UHolYp+3aZEemVBZG5/dtJHPgMz9wHo7w
	 dkiIV7CbemTCn5AGPgprtvfNsGAzmLnAJWMxlYeylY45o2UiHStKBkFAv/T84wU+GOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2026-11-19 header.b=Fe+L0KLG;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b="CteAnEW/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F416F606A321;
	Wed, 25 Nov 2026 00:22:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F416F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2026-11-19 header.b=Fe+L0KLG;
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=CteAnEW/
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMbHDe2593538;
	Wed, 25 Nov 2026 00:21:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2026-11-19; bh=Il9z1IYOTaB7XqIZXcKWH+DTpX9ZYjbz4rnOrdaFR6I=; b=
	Fe+L0KLG1THkb2EC2Lq9OPuBVu8X1Qvwd/siL5wCP2FrdZeTIMY4/z9AUhHQo5a4
	ssl+vaAXqSmSbxLJre7saAsDGYnYZt0mWDcyORMkNXjXXCAGimn0LDWOefzclPDB
	2P0TKXYADcMTqdtVd/UZJcGQ9ZGJ8B6mN+7Q8H/Cthdpb957eGTxgglgSpnItZbE
	7gnVUMy2FcaxN1ssYIIZ/3+ooLDhPtysxqan/xBey167zIGIWfXL8mKWWrHwyrRs
	TlwOMcnGpLr4y+4dHypC14sSFRpk6GyxdXYN35cbYlpUC2uHLO4QBf3KloVLfGyI
	V03FG+6zvdFugakPu0cRzg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t7n1ye-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Wed, 25 Nov 2026 00:21:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMYZ2s716946;
	Wed, 25 Nov 2026 00:21:56 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012046.outbound.protection.outlook.com [40.107.200.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j5j945mqh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Wed, 25 Nov 2026 00:21:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XMmUgLtr9kIJLAMAt9ZV2EjlXtx3+NakKiPOBxZw0PxZXX3wbXQOG4BFjoPLsJftjDdNt5VjGuWMTMAHL3kaovNw59c0KyIN65bMLf2DUzKv4jJJPd0uLwccsOL6hi4ltPh5OVQ9tqSofYzieUCQltmt2xlL8rYdsgXnRiT/CsbIz60tMl2KM1ni7IF+l/NOnYa1fQj1wkGVDaE6OHv4IEaH3ODXF2FsXTRRe5u0GvyPs51HNL5zfu1aZfYWPaq3B8KJknFgCJfcUPGuc+m/hF31hI3GCAOA84tozyy4ue8ZefgM01NfTkVFbN3T9SisLWDzlWuSD1MssqL9f4rsww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Il9z1IYOTaB7XqIZXcKWH+DTpX9ZYjbz4rnOrdaFR6I=;
 b=n+M+KhmJ+lFqUBxdExOPxfQEP5qvBnAaMslDcltWDjluzNSMbgvoD7uA2TWxGHBPzxEY52N8Dp6BT/mJ4Q9haQHhrWuPxwp7lOPHdwu6e6Z2q1rED8w/bgFHG0Cb1wDXVvUEtKc1eJndZ8GekypRppvuKYr9LB8sh1KZgsXHTO/sGHKv5QZ6xWBxOcjCF6+VhfLiTpTuGcx4v29+HraQSJ6D9KNx9mkJ8YBkaAIqWp8H9/1siCKbEHpFAX1epGBU/uwXx49iKdbPOxQFzc4iihORmX678/CcXv58pkbki0lcd5QdP/45hrgOWJT+HWFuYbaUr+YJ7CHMAo7lGZ106A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Il9z1IYOTaB7XqIZXcKWH+DTpX9ZYjbz4rnOrdaFR6I=;
 b=CteAnEW/tX4UBlCrMB8Q9UC8TycdI0IyrVnP5nX+Cr1saYycJCUbWtmuJa98iafdxwsmmp3Xsp1XArDHkWEYZetgQFw0eW5O5rJi9JPGMHqYHZHHwMEYqCGpoOhP7/0FSz4ZYMpv2mzfaMN2P9cAVKz8jrkQlzz1ck75YWtPrlE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from IA0PR10MB7349.namprd10.prod.outlook.com (2603:10b6:208:40d::10)
 by SJ0PR10MB6327.namprd10.prod.outlook.com (2603:10b6:a03:44d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 00:17:48 +0000
Received: from IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::1e7a:452e:f372:b522]) by IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::1e7a:452e:f372:b522%5]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 00:17:48 +0000
Message-ID: <87a9555f-8f54-4468-936c-3212994b1771@oracle.com>
Date: Wed, 25 Nov 2026 01:17:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm: memfd/hugetlb: memfd-based userspace HugeTLB
 MFR policy
To: Jiaqi Yan <jiaqiyan@google.com>, Chris Down <chris@chrisdown.name>
Cc: linmiaohe@huawei.com, muchun.song@linux.dev, nao.horiguchi@gmail.com,
        ljs@kernel.org, vbabka@kernel.org, tony.luck@intel.com,
        wangkefeng.wang@huawei.com, willy@infradead.org,
        akpm@linux-foundation.org, osalvador@suse.de, rientjes@google.com,
        duenwen@google.com, jthoughton@google.com, jgg@nvidia.com,
        ankita@nvidia.com, peterx@redhat.com, sidhartha.kumar@oracle.com,
        ziy@nvidia.com, skhan@linuxfoundation.org, corbet@lwn.net,
        david@kernel.org, dave.hansen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20261115160105.2507650-1-jiaqiyan@google.com>
 <20261115160105.2507650-2-jiaqiyan@google.com>
 <avvdFHtnw2BlE5Vq@chrisdown.name>
From: William Roche <william.roche@oracle.com>
Content-Language: en-US, fr
In-Reply-To: <avvdFHtnw2BlE5Vq@chrisdown.name>
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
X-MS-Office365-Filtering-Correlation-Id: 4cb50128-a353-44fe-6185-08df4a898904
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|18002099003|261009223027099003|22082099003|261022115727099003|261022105027099003|261022075727099003|261021121427099003|261026140227099003|261026121527099003|261028144727099003|56012099006|4143699003|10067099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	aUMumv0416tKRNg0EiQZL34+PLDF+ou425wyHnwTNoGWwCs3oc84jnIAM0AXlM1nOAv8npWH1Rtf7P1+QNqSX1cSBtil+JijF/Y6WL3dzU5n88VNNrzaSjtF0sZlwW1/w/gmHYSt53pLG5ibw7mlGRYp11+AaH6jAe7PcfGt5KnA+dhjD/nuqGd1vmT7088YypKGgh7AII1oEFvJILKuiJApSHVOneNjM9BmGvKc/x4nicwUJsXOvNswvAvQMLtk8ddxVIFJz0sHgYoYelXWQiv4ksc6LGeX8LI6U+ocR0J7Gs73PDs8z3AiYB0nXa6OW7s5QdhGfmxidOIOSN7M1W9E7ocw6A/ASA5MQpfono9aLRSgCXWrXi+2z5B2O0QixaiV/bBM+zsFFimPkj8hBDKoC8ROJt5zAtqdQJRkiiyZI9mv70i7DUa7WREfkzO884jzsktdICd9uQ9Ze9ZEzxofxM8VYKr6u2LtDbSzRQG3fBc92QYh69URjuqxbQE3JOpB/8rspdLGTpyLzkzfKt7es9XtQS/DStp3Fj70LwVH4QbdGoEEiK5jsA8c8ke9Uo/oVLAxDdybip+7vUOjBohtnVIPWNtBRCpqtIt25nMypk7yIzZGrCpKZ5J1n07PYhuaQBZmtfRjx4p86KpeadvQiWwvjJmCCTl4J0kxnkw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7349.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(18002099003)(261009223027099003)(22082099003)(261022115727099003)(261022105027099003)(261022075727099003)(261021121427099003)(261026140227099003)(261026121527099003)(261028144727099003)(56012099006)(4143699003)(10067099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ODlHQndIanZXUjZIUzVjSGJERXlyM0xWbllHVUpVdk1oMVRRcEdzdmlGbW9r?=
 =?utf-8?B?QmZVM3dEZnB0bEF1VFd6SmhxR2FnSTNsNmdWVXVtaFdjcmRlKzUrZlRGZ3RB?=
 =?utf-8?B?blFSWm1nRkVqMzdLU29DMmRoZjBPcnFFdEpWajlJeXBXcGw2RDk0UGNKSGtI?=
 =?utf-8?B?bkJGMHI2RnNqL3NiaU52SnRUdHdtWE9KemgraXovd2JXcHB5a0RjWUZrWnln?=
 =?utf-8?B?eENQL2JrMXl2TFdrdm1sVSszTDJ6L1Y1WmNrdjM2cXZodXY5ZytYTUxDbXlW?=
 =?utf-8?B?ZnorZGZoUWEvL1ZXSUU4aWRRTC9pYWhNeENrc0tTUEFOWlRmeDNZaCtkcWFa?=
 =?utf-8?B?ZHU3RWVlbzJFNnNqL1dyR21aY1V3dG9BMXc0ZFh3NkMvcWlXbFJhRjYyblQ1?=
 =?utf-8?B?dWw5NjBUWGw0NWMrRGxzNTNwa3dxRHBJamNZRFZ0SWY3QUdwQXlxZVNSeHh6?=
 =?utf-8?B?OVZ6VTFBK0I4aXc4UjRuOXdXd281NWtheHpWMnFTL2lseGVhcW5XRkRnamQw?=
 =?utf-8?B?T3Fmdy8zV2V4elp1cWlScGJHMVZXSE1SdlRvWjBkQXJXNStLWUMyamlBbFlx?=
 =?utf-8?B?KzN1dmhzRWJJeGN2WmcySjBIaHFQMHpvM0VLQ0hJZ2l3ZXArcXNlSGVmWW9k?=
 =?utf-8?B?VkhBTWJFUHIwdmR5RkVyQnh2LzJJRGFPM1BFQXNaeHRGRlJsM1JQdnE2dXFK?=
 =?utf-8?B?b2lKRWx2SG9QL1Y3YmE4dFg1ZzFoM0YxaHhSTExzaTYvYThhK2dacDBCWEdy?=
 =?utf-8?B?ZEowMEMzKzF2VDlqNDRFUm5TUWNlQ2gybXJtNVl4RThianhtTW1XNkMxM2JP?=
 =?utf-8?B?K0MyWGlEM21RNzJtbmNORzlzTlZ0aEN2R3FOeU9xencwZUowTVQ3UnpvRi9p?=
 =?utf-8?B?NFJLckF0NDlNK3AvNk85TmZOaEx2Q2JodzJrbFNEc2JsQTdDeGcrL2pReWdN?=
 =?utf-8?B?cWNTcmxkaGRESFZ5Y1pxRWpaK1lZWGwxdmI2b3lBMVVHbTdxRTg1WUpJNjlw?=
 =?utf-8?B?RVZ5VWx1N0w0U1pjNXRHaVhudkhiQ0t6ZHU3cGQ5aXg4Q0lydCtEZWN4WFpt?=
 =?utf-8?B?NEtZS2ZZbEJ4Vk1HY1Zhams5SVdQcS90MG9mdU9wUjRrRTVtODVoeE8yaWZv?=
 =?utf-8?B?cCt4YUtLZmlJZFA0ZUNoem52T0JnTHpaL1NYaHFVUm41RWltN3NFL0xFYjdX?=
 =?utf-8?B?ZlBxQW8rYmJQZUw5eGhnMGVldWFDZ3h5dWh4QW5uS3g1ZmFFa0Q3RHlxMkp3?=
 =?utf-8?B?VisxaEVzY3RsRVBpL3pRdXR3eDlDQ3Y4OGE3OTFxdUgwM3ltMFZ0OCtNUUxU?=
 =?utf-8?B?SE5kMVlSZjRNQXd0NnBBREYrakF2U3h0TWhSbG8zKzdKQXM3UmV1N25qbFJj?=
 =?utf-8?B?Uy9ZR2VFYUg5anowM1FyM2RSMzVjcnhOOXREcTd4cGFPZzllb1NCQ3BHRlJw?=
 =?utf-8?B?b0ZDUWVnSENPZFFIbWJhM3JoVUVJSHVUbDA0OEpIZTJOM2FPMjdJL0xXZTlR?=
 =?utf-8?B?a2hvemdNd2U1blp6SHhlYzlOTnUvSTE2bHlIR2xxcktvaVFTTDJDWGs4NzZZ?=
 =?utf-8?B?cGdlUWtIVnBHRlg1cTd4aGErdU9PVHVpQ0RWdVdQaDg0aGUxM2FnODMvUExs?=
 =?utf-8?B?MzlzblZERHpvTEh3T2k3QUFzNzFHRUhQQklxdXBodHV5bXJ5VytYRnZDMmVY?=
 =?utf-8?B?WmdGbURoendoNHBnUFNBcXFMbTArSkZDYTB6bUl1QmFoTmJVVmthQlM1QWNy?=
 =?utf-8?B?ZDFBWlR5ZkQwbUZuOVVyb3pBVTAyOHZyTUNnZ0I3dDVqSzhESFZnSEZ0cVUx?=
 =?utf-8?B?bENIRVFmVWF4cWlmOTNBb1RRNmIxY1ZpYW5TcWZ6Sjd3K3BoQ0F0SkxUaWpE?=
 =?utf-8?B?bHAyZW1ldUxmOUxRMWI2SFptNHlYMTVWU1Q3bXZ6RzNKU1QzcW4ydDRPclUw?=
 =?utf-8?B?VkVDRmdQb1ZoajVwd3U0MzNPTzh6d2RlYUZHb1BwTktMUHpWeGVkcytCTHRt?=
 =?utf-8?B?SFVDTzRMMkY3TkVXSUpoV1BvTHFNOVVmTmFzb3BFOC90dmFyOElKM1dWNEpX?=
 =?utf-8?B?L1Jibk1JSEU0SDcvUUpOemNpNU1WWG1OQmhPRDJacFZEd0tZVmpWQUxSaVdT?=
 =?utf-8?B?NWM2eVB1d1p3MEZ6andkNk44OG9NS28vYUJtQU5rR2FoWFJJN0UweGl0SFRt?=
 =?utf-8?B?V2pNT3BOM0ZrNUFBbHZHMXhYaHlOczFrdEs4akR3UldWRU1uQkZQTllXZXg3?=
 =?utf-8?B?OWRlUGJVZGs3MW9VUG1Pa01JWVJYZm1mZ0ZnUHV1Y1RzUk5XcFM1WE8wakE5?=
 =?utf-8?B?Y1lkaWJXSk9EdXVjVTUwb2tWdzUyRi9mWTQyd2RhUWxDdGdncW5wR1gwcElv?=
 =?utf-8?Q?sel8nSIdeJ7NApWs=3D?=
X-Exchange-RoutingPolicyChecked:
	BPq8P5Mpho+x4ayRXaYt+zLkC/4FOdwElRP2W0ycBlraKgqvwwpAtNMCx/7oZSTDEAP+Tp7NMXpY/EfBVlTBhYOik05zNRrsYbFlEAFmCBYjw3oH8MiCuReURryP3BFZF2Ulgk9enIhPuHiOOe01X9Mn2VtxnHTUqUs2kOC9LJdLuvIFbZNQtu9ul8a+8PlqBcgLFs/EH3z7Mrqjz8mXmfXCAoZ+59isOHOStiRIy6xp80//SMvMh+UzYrKBZqP9soWA8Jb/+kvTxilH0GYKdeE/WI0OoBQ7G1v+KcY2ru7/XgByDZJ7nLAv8KZIgv38BQ3cwT+RMDiPnaoEVUswfg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	br7ZfR/a3t61jSgV9I5Q/Xe0JXuZzKOOCjr9b6QOaG2sjxUCGhB6rARkbm3iZOGubi4/TytshZ2NjeVuy5w8+ib1Nftdi6lmteU9HTYfwuraSxuF/P8To569/cil9BC1+NI0KOwravIOnk7BoWmjEyctASJ8xYRJ3uzCKYur8TUagQYiQZILusEYjEf/DcWGsHXeOCXInmgfyUS8PweYRNm+89ArE7DVpeJtE7prX6UN11UfdRhGeE5VD6baOVEDN+JQoau5DGjZu5jYh4Gq0KjOp4HSIfltIPGiBHa27PA8Uk5XDVbTBxEZz+dBm0OYEOkjWOO+Bgrgl3zFZGM/SSLTiR4keRbKlR4lMy5/wftdcRCpF1y0h2kPw2RW0YNeuFtG7GsSZw7OWp0I3QcX0fHjxWN2gC9KblhMvxEkfIGCukHAkqrPM/6ymGK4fN4gvsblLhlQBf3ZJYStoGFEK4OhX150l5zxXurJCQdY1ONvUq1L6DAwlptfZU3T20QIjBfJ2voevzurlckV++22driW/v7t7PYWIjPEEFf/3ZnpZ0ugb/Skd2DtOdTma6aAR1XjWMjjtph/tN7Y7AqzxCZd5IJ3Sdh6DbzSihpp+BA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb50128-a353-44fe-6185-08df4a898904
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7349.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 00:17:48.2391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3O7E9FtskcCXRppmSnKcikW3XgUU87FqpmKgdysHKIxNlMgpzMkEg47G6RUML2+2tDu4aG3w/B5iuZwiWW/6U/ku12VEUS3C0wTqb09G+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=986 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611250001
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI1MDAwMSBTYWx0ZWRfX4pE7Stum6Ajc
 7ghNpehOSc2dxPIX4EE3Gg9ZBHPPyF3uwgTW3HX6c2SUm2oz0x9WRP0c98la7bK3FgS8rqT1bST
 ksra7CnhP6KU50LFenNaKkZzZzoIG9zd/Qw64AoKSv3jAhnRqZ7e
X-Proofpoint-ORIG-GUID: pzK1PoiJjiwQmTSZdJ7QQzfMmllVfYKK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI1MDAwMSBTYWx0ZWRfX1iN+S7V8NKR8
 0djpErCNYcvDD8HJbCWGig97Ct6CK3kMUcNvnB6K/EvuL4kgmWPYpvT3TD+DKzNizFDDwl21srF
 Z8iWI9VK6pJ4pHGDvFiBeRKBz2usk+SaJ6OJCdVRnHWQxab37g3caqFd2yjod8RhHHmRq01aTM8
 RcA5K3er95GrM6qv1Mz9cXpkOzqyZHx604N8CAKm4HtTUXk2nOXb1cpfzh8TOvqQ5MOh7O4V1uv
 PNFCkCIvzK7AQrMQGx+EYX1qIRil/nz2jpzTNPKJowF2FVoBxV1Jvb888D9G2qrEQd3h6ymXzZH
 ceFW32EnNvqbsvT2ihzbbeCnGxldJ9WJ0F2BFDC9tjrWoP09EQcNgsLZX40ynwdlACDkSUQlN8L
 oJcKW86yAhRlsL3+tbRg3xe+hBzqxzi/QJ0dsDecFyott/+ieTQvbA/W4Mz54EaGUzk1vgV6FKJ
 H5zrTCdVsFI2dxoYT/2M8+k5ej+ekRSzE2duwRYk=
X-Authority-Analysis: v=2.4 cv=Cocq4X4D c=1 sm=1 tr=0 ts=6b062a25 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=xR57CXKHv53rqHUfRhQA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12101
X-Proofpoint-GUID: pzK1PoiJjiwQmTSZdJ7QQzfMmllVfYKK

Hello Jiaqi and Chris,

I think we may have another problem to consider:

@@ -1229,6 +1259,15 @@ static int me_huge_page(struct page_state *ps, 
struct page *p)
  		/* The page is kept in page cache. */
  		extra_pins = true;
  		folio_unlock(folio);
+
+		if (hugetlb_should_keep_hwpoison_mapped(folio, mapping)) {
+			/*
+			 * Page cache keeps the folio until
+			 * filemap_offline_hwpoison_folio() dissolves it.
+			 */
+			folio_put(folio);
+			return res;
+		}

Shouldn't we evaluate hugetlb_should_keep_hwpoison_mapped() before
releasing the folio lock? AFAIK, the folio reference alone does not
keep the mapping alive.

Maybe something like that could be more appropriate ?
         if (mapping) {
		bool keep;

                 res = truncate_error_folio(folio, page_to_pfn(p), mapping);
                 /* The page is kept in page cache. */
                 extra_pins = true;
                 keep = hugetlb_should_keep_hwpoison_mapped(folio, 
mapping);									
                 folio_unlock(folio);

                 if (keep) {
                         /*
                          * Page cache keeps the folio until
                          * filemap_offline_hwpoison_folio() dissolves it.
                          */
                         folio_put(folio);
                         return res;
                 }
         } else {
...


On 11/17/26 05:50, Chris Down wrote:
> ...
> This doesn't look right to me. For example, hugetlb_mfill_atomic_pte() also
> checks folio_test_hwpoison(), so UFFDIO_CONTINUE on such a folio still fails
> with -EIO.

We are dealing here with memory errors in a HugeTLB-backed region
registered with userfaultfd.
For an application using userfaultfd minor faults on HugeTLB-backed
memory, returning EIO from UFFDIO_CONTINUE would prevent it from
resolving a fault on an otherwise usable part of a kept-mapped poisoned
hugepage.  We can imagine a VM using this type of memory, and starting
a migration where userfaultfd is used to track access to an already
transferred memory area, an EIO could disrupt the migration workflow.

So we should fix this limitation in a way that the kept-mapped
poisoned hugepage is not rejected by hugetlb_mfill_atomic_pte().
Would this introduce any other problems?



> Also, do_migrate_range() calls unmap_poisoned_folio() on any
> mapped folio with HWPoison set, so offlining the memory block unmaps the
> hugepage after all.

Here too, we would need to avoid the unmapping for a kept-mapped
poisoned hugepage.
Memory migration should not be allowed for such a poisoned hugetlb page,
as it relies on the hardware to generate an event (an MCE for example)
when the failed location is accessed.
If the page was moved, this needed mechanism would stop working.
Preserving the mapping may therefore require memory offlining to fail
while the hugepage remains in use.


HTH,
William.
