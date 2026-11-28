Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795889563;
	b=lrFaCdM1sEFg7xfiGsVkBg0vh4X80ZcFzbTT1VemuTxHXUmAZqoVyPD+Ydr4kFvL69ZC
	 AxLA7nyZusMJGGjvqES93KQoWcGuGtKnsg0uTPLiFzGNcWnYiVXIWqOlKGf/1sPcsHacW
	 eNc1ZTMytGdz6An+IRb7fPTfvwYyIOmVln71w9fzloIGPJhr3bfEsS/UjlUuO1TUatJ9Z
	 qJC7XKyPJc4NSp5OoUJxJ9TxG7wlItxe6bR2xzALGQwM20rKd4zNQLRvSN2urEPPp2oIf
	 Gb7iyVTCJ7EIMFPA30GcxyMnAQloo2BHTBeCjcRYPNRQbWW+qwqaOJ7Np6sBP/YPAGg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795889563;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-atpmessageproperties:x-etr-sdm:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=7hl0X33WLyzozxO+ExEaPnqKJLquqUzAVeb+70A7D/8=;
	b=lkOVq4xRqxzalJtbmtUjIkDibIK2k8se5YE952L70J2utSngzMPNZ4HBW5N7s7iOMZfz
	 gkBgTb30neGI79zzjKTCba+T4L6rowPSBFVMRDp/kgypJm8lxFdwPwRMIprnWEgJ6uumk
	 75heccaT6e3Lm5GaxA+sq6TgUJZv+uS6sIV4YaU/yjQPOYShyL2QUo93wffoT+l7RyKX4
	 6jLcpi5D6np3L7a42StjaSFgdLVtvxGs12czrgSB1z1lBLzMZ0oiqStIyiOuxXYh0kjTC
	 JqIiJBbwvMsRx7AInRJCMueXkcvGb3cP7oLvVOkayoSj7IDXrmTG14RHx16+03pTcPg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=solidigm.com;
	spf=fail smtp.mailfrom=solidigm.com;
	dkim=pass header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=IqPnPyK5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.14
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011014.outbound.protection.outlook.com [52.101.52.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C97F606A31C;
	Sat, 28 Nov 2026 18:12:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C97F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=solidigm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=solidigm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=solidigm.com header.i=@solidigm.com header.a=rsa-sha256 header.s=selector2 header.b=IqPnPyK5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qkiM9xsBsR/BKKBV/1jDvq8w7JgrezGvjEMrHpmUZ6Lv2d9dUZiZTb9iAr8fevds8vav8/ihnobZWUDJbVR6BY9vb0X83zfmVVB/C7dKW+creRuRdA2qD5sI6t/bs3XtJJ/dqwHtCycWILKi7VVtR06YXvm4zUi5E8EGaYdEk2v0PC6wqflhRtCZFfypUZ9egbKvaq8oTGES8Nk8TC7Soo9XB2qRVKP5jlKn2+qTvWapsbNy49QeGFNB8/7deG6ruJU2j9DTJ1+vg/J36N2iLW8TLan1C5PiL5R6oc/3jSo5ljrEpadNJDz6i9iOJLzLnfI+uSOwdJ2GbIBITVBGsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hl0X33WLyzozxO+ExEaPnqKJLquqUzAVeb+70A7D/8=;
 b=UVbm6Lf8xRUWhtdnfDh7905GSp1fIgADSfJaSbM+joXgr60xrHBK4OmRcOsSWPDjFLB/Hew/WkepNoX/c/vPCDRy9a8I3hJlM1GUGfcR7W+PVn9cRvTSLnio2qVElEpf5jYjMTZZfk97xa/PMlQmYkV7pG62JhnrX/NgZRBrPRSyXgK+dSHh1SPAgdr56+y8I67GtacPlQ6qdQ6cwCjdSJb4CUS6KZuOr+J8gDkZtzIMxTD7eGzSuXjRE8+KrKoH32nk1vv1D+0zFvqWdmp0tg1Df3z0Ye3vGcPZ4Mswdy+olVBZHO+iPBX9EkQ8panSjyseCGa7hrDgEDx+EZ2Bkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solidigm.com; dmarc=pass action=none header.from=solidigm.com;
 dkim=pass header.d=solidigm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=solidigm.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hl0X33WLyzozxO+ExEaPnqKJLquqUzAVeb+70A7D/8=;
 b=IqPnPyK5PhETIpJtbM85i5ZlWiqqRgfXiKTVaD2mp4ceiz0qaWBeR0AO76pC37AGST+1HtZCg9+m7sUIw18aph43LS8Ir4Mezbcgkyti55KkUNWZ++87y9grZYuWhAPhCZ/BzxxzUJXOAInG7DgM6MROBxcyEJf4fKt6wWDOrGvTcv+GGa5onxfwFNlsJDSVnx+kKPvAmA648A2dAnwHzrcaEgQNRIf1PsiF0spoAbrkAZrwJ8yBGLSnJ6Tgw9wUqpUq+c+/KWi3WPc/uEt8tKlStHW05llFSlxq/q0JZGudyNc3IorIs4O/F/pks76sOpgA9hYt0sH+RhT2TA4kEw==
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 (2603:10b6:408:33f::17) by CY5PR10MB6144.namprd10.prod.outlook.com
 (2603:10b6:930:34::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Sat, 28 Nov
 2026 18:12:34 +0000
Received: from LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368]) by LV0PR10MB997684.namprd10.prod.outlook.com
 ([fe80::2b69:d102:4935:e368%5]) with mapi id 15.21.0662.007; Sat, 28 Nov 2026
 18:12:34 +0000
From: Wayne Gao <Wayne.Gao1@solidigm.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dgc@kernel.org>, Wayne Gao
	<Wayne.Gao1@solidigm.com>
CC: Linux Kernel Developers List <linux-kernel@vger.kernel.org>, John Garry
	<john.garry@linux.dev>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "pankaj.raghav@linux.dev"
	<pankaj.raghav@linux.dev>
Subject: [RFC PATCH v2] xfs: add a mount option to force atomic CoW
Thread-Topic: [RFC PATCH v2] xfs: add a mount option to force atomic CoW
Thread-Index: Ad1/YmK/c+fGNNUUT/yLctYqIf99nw==
Date: Sat, 28 Nov 2026 18:12:34 +0000
Message-ID:
 <LV0PR10MB997684E8C7E6D597B1108BBAB6B9402@LV0PR10MB997684.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ActionId=069c03e1-b334-491f-bcab-b6a6d815777e;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_ContentBits=0;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Enabled=true;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Method=Standard;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Name=P2
 Confidential;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SetDate=2026-11-28T17:56:04Z;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_SiteId=4bb44aac-867a-4be0-aa34-30794e8470dd;MSIP_Label_1a4d86c9-6ef8-4c81-b7a9-15a3140c062e_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solidigm.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR10MB997684:EE_|CY5PR10MB6144:EE_
x-ms-office365-filtering-correlation-id: 3040a733-8005-4352-e82e-08df4d7b2d34
x-ms-exchange-atpmessageproperties: SA
x-etr-sdm: Outbound Disclaimer
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|11063799006|5023799004|6133799003|261009223027099003|18002099003|3023799007|55112099003|260925021311599003|260925022911599003|260925021911599003|56012099006|10067099003|261021121427099003|261102123227099003|261102130727099003|261021123027099003|261028144727099003|261026121527099003|261026140227099003|261022075727099003|261022105027099003|261022115727099003|261022113327099003|38070700021;
x-microsoft-antispam-message-info:
 n/9MSf3uOFcQcvrSqwZOkX59I4HkZmunJzAH6hPODJCl6/s9Ks+oFLzpEf9pdgysgUjUIxV46jlYsY2CPcZsVCX5jFG5JICtJ+znfJnwvsRsCLDwenCesBJNcBzsMEnH2ogvx/ek7fvwGRHz6MnMtWi5V4h89dKpxEBsm+j8/ASeJ5vHWDqMd8c7uBShCbCw74sPTUxTQ34UuiawnuDRqe7PWSMK7imZhXi93tw5rA/UpEImQXfT1dHii+Bn3gX509nZ+r6uk00K0WQLfJYzH7HSWPI0JTdnnhoiTR5ft1v8Uj9Z3KXKEyqEf50vW3Ih4yntMP513JIEZjAK3xbiXb0rkUqmRrxelMbpauCouFMmkg+3Ta8nAssgJ/yVXQmFHHsk/11XIxXW7vUklFdS3mh8M+sySqjAy51CBsdy7cpmuMSYzNG4BjROyTJQSNoqhptv9KVNZG+IFViT2kfC3iCtgrVBaBtak3JW8ZhM4LkcIpzs/gGLJv718wU5i+ohughVyCkX7TRqdnNdYIbxf8FA2ozeP+u2hjasXycFK1olQ/GO5/pWCp7nEYvkqjyxv6tzf974hjWLYgYf8ZvJ/9/2CeF99ucFmgMktFoSh1Mge5Qw1Gz/O6mmZk4Pv05EL9m1g9AsAEeJ0LMdJ/6piUKAt1zoXPoURzLairZawuM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR10MB997684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(11063799006)(5023799004)(6133799003)(261009223027099003)(18002099003)(3023799007)(55112099003)(260925021311599003)(260925022911599003)(260925021911599003)(56012099006)(10067099003)(261021121427099003)(261102123227099003)(261102130727099003)(261021123027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(261022115727099003)(261022113327099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Psy74fOxHpwk/pAXwTdBOi55rsPX06xlI+n4sd4TogsBVdCx/89c0c3ifT?=
 =?iso-8859-1?Q?usAzdFs9E6VdNittujgKSbwb6dr+w6sgu8BY3amt5+j/cEl91Nzo7rIqf4?=
 =?iso-8859-1?Q?4dOfgkNCY6LSrgtA6piBUPHPulvPAbEgdDOiiH0bogWi/Qo03T2O7xmYsw?=
 =?iso-8859-1?Q?wbx0hZUk3qOSSZsWfGuxHFi1yhqt4Q2I8w5YUja9iotlx2ElGbE8ZCP9bL?=
 =?iso-8859-1?Q?yAzv7ATetZZWo5fY2kw1BT0vIxEJHhcvHdPp9pVXBfCAi0w+X6Yb9yPPd4?=
 =?iso-8859-1?Q?X3x+au3zqaglUIpFW6S7R3yyVI2kEK7yrmDNhc0QCwn9Uf+DR6Lpeb2LPa?=
 =?iso-8859-1?Q?mlM1yNtUmwccGunYB2qs3/30voPZ1j80wd5A+TF16dolq5GVvlUHLqUStu?=
 =?iso-8859-1?Q?S9KhSdYjbcLTC3hUjKtCHFmVavGb3mekYDsKJonpq4xup7zFihGkoOIDSQ?=
 =?iso-8859-1?Q?sdX9jW2zz2RjdIqGNtQYjCdX0KnchXgnZQjDNFuHe8R6UVJ43SNwkM1QbA?=
 =?iso-8859-1?Q?fWAT3k398Zi/H+dnlSbcOXMjRL7LCDPPIWrN4yUiawdB77TEgIsoM9jGyb?=
 =?iso-8859-1?Q?C+YX1M1s3GCSrko1wpO60w4Ondrij003FBGk7xPfhm69LAO5rel9TAcrtw?=
 =?iso-8859-1?Q?4zLXqThd6HHg6iXrFqfOmOi+iCnw6/Fh+baoHSkz+YJmZmduIlKeppUM32?=
 =?iso-8859-1?Q?XMed5jt6V2gYmSOBez/ufGpo8T45t/S1Uafs40AQ5KMGFZcR2wlLG2IjZ+?=
 =?iso-8859-1?Q?DNE99cybv6JoBNv705GI4jd6M7PocBJntnPKatxiTymYgDxkcNJ5LGIT+y?=
 =?iso-8859-1?Q?HatYqp6kkMXZAsWqJUsEHTHf8HReGheKLNHqLNcS2F8ULYmFdQIoKm2CsE?=
 =?iso-8859-1?Q?g7upiF/BRbHdHSPr+dQEuEAR9wsvQSQjO0kGuIOploeVQZTDXUCTQlye08?=
 =?iso-8859-1?Q?tGQHKpGE+/k/5qnHnTRYW+1Zdh6C+F/kEj25bvlcshgpDrjVkP7HOb93R3?=
 =?iso-8859-1?Q?3hqwQmOapB98/VaUxlOHb0ntV6QlXVXNv+Jl+e1G3koQIsAk/6pVAxMQQd?=
 =?iso-8859-1?Q?Og6O6VAEW5YHzhCgSR40apERuGQ7KB4CFFhzKPY5oSSl0jDhwwNrUCHDiT?=
 =?iso-8859-1?Q?xGODjQng4x8t8C8J+wmVQKdwE9HRYznb0VBiVbEbBI0QXbqiXbSjBdYVZj?=
 =?iso-8859-1?Q?MXob53R/EZbU2IemNAmgfveQvRR54+s6LOpPiSdrhKV7UT1KLJhfO98OTA?=
 =?iso-8859-1?Q?+jrXCrfe5aNGurd3PV27WikYJ3QCylnbNvdLnDpByOQ3NLdr5locTu/R6R?=
 =?iso-8859-1?Q?RMAG6V8li/GXyQhG/y/EbQzqMdvn+JsSy9FN2tTohregOyrHf2oVbco3cj?=
 =?iso-8859-1?Q?AxhhVmOS5qsqZtoM9iU0WmBSGy+eDsMN5d3LC5J572QXdv3okpNJfS4jkT?=
 =?iso-8859-1?Q?1RtOqXgecajNuQTYdocDfvxy0wL7umkRtkEAjseN+WqUHBBGdQITKUFi0T?=
 =?iso-8859-1?Q?OGnXaneaeOzc952w9RqW6dXL0b85qwQYaFMUF3L36Gt7/Zq4nsOwBQ3zlM?=
 =?iso-8859-1?Q?IGH+jVgIUJI3mjcPJcxocwd3MO+JBOhYBjSDTQd8DoJ4VTwpzAUZajeL92?=
 =?iso-8859-1?Q?e1UKAZycQsqkEwf5QiV+eePgktuaJJb8aMJA/mNU7GAe336B+277BSKyAK?=
 =?iso-8859-1?Q?D0BtuLBvijlTpdF/vpirITwFFRnrcKUrhO1YLinvPKK41p7hyS9LvjsDWN?=
 =?iso-8859-1?Q?nj6Lamn0lfWOjs0/Q6doqB/ksISj1JXbr48raRuU461YyR0ZW8XWP7ti0v?=
 =?iso-8859-1?Q?UUiur4uOzEXS2ZMOx3VD783/Vh5YO6s=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: solidigm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR10MB997684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3040a733-8005-4352-e82e-08df4d7b2d34
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2026 18:12:34.4227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4bb44aac-867a-4be0-aa34-30794e8470dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2hzBo/dvtN1BcOXOwJ1JEYtxazgSorEX6PrmoD/ftIAwymjts50yFJZ8SAqYJxS0ScX0lSjd0RfDcMgGv9Xz+Cs0TGNKUhOEKelEv/ufrq+WFM0H02XDYaoAxFDRmEij
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6144

Comparing hardware-backed and software-backed atomic page writes
requires a predictable way to select each implementation on the same
device and kernel build. Triggering fallback through fragmentation or
misalignment changes the file layout and does not reliably keep later
writes on the software path.

Add a force_atomic_cow mount option to select the existing software
CoW implementation for RWF_ATOMIC writes. Keep hardware-first selection
as the default and leave non-atomic write routing unchanged.

Require software atomic write support and reject attempts to enable
the option through remount or by mounting an existing filesystem
instance again. Changing the policy requires a full unmount and mount.

Report no separate optimized atomic write size while software CoW is
forced, and document the mount option and its restrictions.

Signed-off-by: Wayne Gao <wayne.gao1@solidigm.com>
---
Hi Carlos, Dave, John and Pankaj,

Thank you for the feedback on v1.

This v2 replaces the runtime sysfs interface with a mount-only option.
I realise that Dave's suggestion was to consider configuration at the
block-device layer, not to endorse an XFS mount option. This patch is
therefore an alternative for discussion, not a claim that the layering
question has been resolved.

My use case is test and performance characterisation of fixed-size
database page writes when evaluating RWF_ATOMIC-based torn-page
protection, including potential alternatives to doublewrite and
full-page images. I want to compare the hardware and software atomic
write implementations on the same hardware and kernel build, keeping
request sizes and synchronization policy constant.

The motivation for a non-debug interface is to avoid changing the
kernel build configuration between measurements. It is not a
production requirement to disable working hardware offload.

The current block queue atomic-limit attributes are read-only. I
understand John's concern about changing atomic limits while requests
are in flight. This proposal leaves the advertised device limits
unchanged and fixes XFS's implementation choice for the lifetime of
the filesystem instance.

Feedback on whether this belongs in XFS, at the block/driver layer,
or only in an out-of-tree testing mechanism is welcome.

Changes since v1:
- Replace the runtime sysfs control with a mount-only option.
- Use an XFS mount feature bit instead of a runtime boolean.
- Reject enabling the option on remount or an existing instance.
- Replace the sysfs ABI documentation with mount-option documentation.
- Rebase onto xfs for-next at the base commit listed below.

Validation:
- git diff --check passed.
- checkpatch passed with BIT_MACRO and CAMELCASE excluded to retain
  the existing XFS mount-bit and option-naming conventions.
- The exported patch was checked against the local worktree.
- Linux kernel build, mounted-XFS tests and fstests have not been run.

This RFC requests interface and semantic feedback. It does not make
runtime performance claims and is not ready for merging.

v1:
https://lore.kernel.org/linux-xfs/LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@=
LV0PR10MB997684.namprd10.prod.outlook.com/

Related discussion:
https://lore.kernel.org/linux-xfs/awXuAESDkLr1nd3n@dread/
https://lore.kernel.org/linux-xfs/a337f9fc-b6ef-48c4-ad98-52972b10b4c9@linu=
x.dev/

Thanks,
Wayne

 Documentation/admin-guide/xfs.rst | 28 +++++++++++++++++++++++
 fs/xfs/xfs_file.c                 |  7 +++---
 fs/xfs/xfs_iops.c                 |  4 ++++
 fs/xfs/xfs_mount.h                |  2 ++
 fs/xfs/xfs_super.c                | 38 ++++++++++++++++++++++++++++++-
 5 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/=
xfs.rst
index acdd4b659..d91c61785 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -59,6 +59,34 @@ When mounting an XFS filesystem, the following options a=
re accepted.
     across the entire filesystem rather than just on directories
     configured to use it.

+  force_atomic_cow
+       Force ``RWF_ATOMIC`` writes to use software copy-on-write (CoW),
+       even when hardware atomic writes are possible. This is intended
+       for testing and comparing the atomic write implementations without
+       changing the block device's advertised capabilities. Writes without
+       ``RWF_ATOMIC`` retain their existing behaviour.
+
+       This option requires software atomic write support (currently the
+       reflink feature) and is available without ``CONFIG_XFS_DEBUG``.
+       Existing atomic write size, alignment and direct I/O requirements
+       still apply. CoW can require space allocation even for overwrites,
+       and ``RWF_NOWAIT`` writes can return ``EAGAIN``. Software write
+       failures are not retried using hardware atomic writes.
+
+       The default is to prefer hardware atomic writes and fall back to
+       software CoW when needed. This option can only be enabled when
+       creating a new filesystem instance, not by remounting or adding a
+       mount of an existing instance. All mounts of that instance share
+       the setting. Omitting this option on remount does not disable it;
+       repeating it when already enabled is accepted. To change it, fully
+       unmount the filesystem and mount it again with or without
+       ``force_atomic_cow``. The setting is not stored on disk.
+
+       While enabled, ``statx`` reports ``stx_atomic_write_unit_max_opt``
+       as zero, indicating that there is no separate hardware-optimized
+       size range and ``stx_atomic_write_unit_max`` is the optimized limit=
.
+       The other atomic write limits are unchanged.
+
   inode32 or inode64 (default)
     When ``inode32`` is specified, it indicates that XFS limits
     inode creation to locations which will not result in inode
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f7e474161..4dfa91faa 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -798,10 +798,11 @@ xfs_file_dio_write_atomic(
     iomap_iter_next_fn next;

     /*
-        * HW offload should be faster, so try that first if it is already
-        * known that the write length is not too large.
+        * Prefer HW offload unless software CoW is forced or the write len=
gth
+        * exceeds the hardware limit.
      */
-       if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
+       if (xfs_has_force_atomic_cow(ip->i_mount) ||
+           ocount > xfs_inode_buftarg(ip)->bt_awu_max)
         next =3D xfs_atomic_write_cow_iomap_next;
     else
         next =3D xfs_direct_write_iomap_next;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e04b7d9d2..f785996a8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -664,6 +664,10 @@ xfs_get_atomic_write_max_opt(
     const unsigned int hw_awu_max =3D xfs_inode_buftarg(ip)->bt_awu_max;
     const xfs_fsize_t  hw_align_max =3D xfs_get_atomic_hw_write_align(ip);

+       /* Forced software writes have no separate hardware-optimized limit=
. */
+       if (xfs_has_force_atomic_cow(mp))
+               return 0;
+
     /* if the max is 1x block, then just keep behaviour that opt is 0 */
     if (sw_awu_max <=3D mp->m_sb.sb_blocksize)
         return 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index cbcfb89c6..2a07481b3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -406,6 +406,7 @@ typedef struct xfs_mount {

 /* Mount features */
 #define XFS_FEAT_NOLIFETIME    (1ULL << 47)    /* disable lifetime hints *=
/
+#define XFS_FEAT_FORCE_ATOMIC_COW (1ULL << 48) /* force software atomic wr=
ites */
 #define XFS_FEAT_NOALIGN       (1ULL << 49)    /* ignore alignment */
 #define XFS_FEAT_ALLOCSIZE     (1ULL << 50)    /* user specified allocatio=
n size */
 #define XFS_FEAT_LARGE_IOSIZE  (1ULL << 51)    /* report large preferred
@@ -550,6 +551,7 @@ __XFS_HAS_FEAT(grpid, GRPID)
 __XFS_HAS_FEAT(small_inums, SMALL_INUMS)
 __XFS_HAS_FEAT(swalloc, SWALLOC)
 __XFS_HAS_FEAT(filestreams, FILESTREAMS)
+__XFS_HAS_FEAT(force_atomic_cow, FORCE_ATOMIC_COW)
 __XFS_HAS_FEAT(dax_always, DAX_ALWAYS)
 __XFS_HAS_FEAT(dax_never, DAX_NEVER)
 __XFS_HAS_FEAT(norecovery, NORECOVERY)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2f6999b69..9c90787f2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -116,6 +116,7 @@ enum {
     Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
     Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_max_open_zones,
     Opt_lifetime, Opt_nolifetime, Opt_max_atomic_write, Opt_errortag,
+       Opt_force_atomic_cow,
 };

 #define fsparam_dead(NAME) \
@@ -175,6 +176,7 @@ static const struct fs_parameter_spec xfs_fs_parameters=
[] =3D {
     fsparam_flag("nolifetime", Opt_nolifetime),
     fsparam_string("max_atomic_write", Opt_max_atomic_write),
     fsparam_string("errortag", Opt_errortag),
+       fsparam_flag("force_atomic_cow",        Opt_force_atomic_cow),
     {}
 };

@@ -196,6 +198,7 @@ xfs_fs_show_options(
         { XFS_FEAT_NOUUID,             ",nouuid" },
         { XFS_FEAT_NORECOVERY,         ",norecovery" },
         { XFS_FEAT_FILESTREAMS,                ",filestreams" },
+               { XFS_FEAT_FORCE_ATOMIC_COW,    ",force_atomic_cow" },
         { XFS_FEAT_GRPID,              ",grpid" },
         { XFS_FEAT_DISCARD,            ",discard" },
         { XFS_FEAT_LARGE_IOSIZE,       ",largeio" },
@@ -1141,6 +1144,11 @@ xfs_finish_flags(
         return -EINVAL;
     }

+       if (xfs_has_force_atomic_cow(mp) && !xfs_can_sw_atomic_write(mp)) {
+               xfs_warn(mp, "force_atomic_cow requires reflink support");
+               return -EINVAL;
+       }
+
     if (!xfs_has_zoned(mp)) {
         if (mp->m_max_open_zones) {
             xfs_warn(mp,
@@ -1609,6 +1617,9 @@ xfs_fs_parse_param(
         return 0;
     case Opt_errortag:
         return xfs_errortag_add_name(parsing_mp, param->string);
+       case Opt_force_atomic_cow:
+               parsing_mp->m_features |=3D XFS_FEAT_FORCE_ATOMIC_COW;
+               return 0;
     default:
         xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
         return -EINVAL;
@@ -2031,7 +2042,27 @@ static int
 xfs_fs_get_tree(
     struct fs_context  *fc)
 {
-       return get_tree_bdev(fc, xfs_fs_fill_super);
+       struct xfs_mount                *mp =3D fc->s_fs_info;
+       struct super_block      *sb;
+       bool                    force_atomic_cow =3D xfs_has_force_atomic_c=
ow(mp);
+       int                     error;
+
+       error =3D get_tree_bdev(fc, xfs_fs_fill_super);
+       if (error)
+               return error;
+
+       sb =3D fc->root->d_sb;
+       mp =3D XFS_M(sb);
+       if (force_atomic_cow && !xfs_has_force_atomic_cow(mp)) {
+               xfs_warn(mp,
+                        "force_atomic_cow requires a new filesystem instan=
ce");
+               dput(fc->root);
+               fc->root =3D NULL;
+               deactivate_locked_super(sb);
+               return -EBUSY;
+       }
+
+       return 0;
 }

 static int
@@ -2189,6 +2220,11 @@ xfs_fs_reconfigure(
     int                        flags =3D fc->sb_flags;
     int                        error;

+       if (xfs_has_force_atomic_cow(new_mp) && !xfs_has_force_atomic_cow(m=
p)) {
+               xfs_warn(mp, "force_atomic_cow cannot be enabled by remount=
");
+               return -EINVAL;
+       }
+
     new_mp->m_qflags &=3D ~XFS_QFLAGS_MNTOPTS;

     /* version 5 superblocks always support version counters. */

base-commit: 1ebd141a13ae59c34f08e55922c9308e180409a8
--
2.54.0.windows.1


Wayne Gao
Principle Storage Solution Architect
wechat: 13636331364
solidigm.com



CONFIDENTIALITY NOTICE: This email and any files attached may contain confi=
dential information and may be restricted from disclosure by corporate conf=
identiality guidelines, or applicable state and federal law. It is intended=
 solely for the use of the person or entity to whom the email was addressed=
. If you are not the intended recipient of this message, be advised that an=
y dissemination, distribution, or use of the contents of this message is st=
rictly prohibited. Please delete this email from your system if you are not=
 the intended recipient.
