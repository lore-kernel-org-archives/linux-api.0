Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021078.outbound.protection.outlook.com [40.107.130.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1E53BBFAA;
	Tue, 21 Jul 2026 09:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784624909; cv=fail; b=nweGrbfpSphLOqnW7JiPFOhM/qMOCQmvQIfIVZDOFYgI5ojCa0zdXrvafe2MVNP3Lv7MSawSrVGSSffV1jNA1HxGLuKjotaLz/GIphkwnsWj+oMTT2qIe4AkhLylYkvymUCFqZcjkXuuhh/iOF3BiZp0Ji+V75uP6yH1vvmmnOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784624909; c=relaxed/simple;
	bh=0i3/elJsNCh/WAwySChqtlyrIyj+z6xjdNH4QC+76QE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=clrICb5ZsZSNtGwespVniro6OWzqwBPlmA25B1tVkFjaIp49ZES6Nhn5pazh0DPMpoT5NTy8HQ7wVD6U90pN4XJsWL4BIiG3smRyivfF0LMt+Ti08ccGGG3QmXmCt+3MTIQo4dK7rzYxGouaVickz7u5coX5Hv5E0MqeJ+IXrU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=docforce.de; spf=pass smtp.mailfrom=docforce.de; dkim=pass (1024-bit key) header.d=docforce.onmicrosoft.com header.i=@docforce.onmicrosoft.com header.b=UIqj2ho4; arc=fail smtp.client-ip=40.107.130.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=docforce.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=docforce.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=docforce.onmicrosoft.com header.i=@docforce.onmicrosoft.com header.b="UIqj2ho4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BI4JsbnLPwz3CxftZO1s4KTgcpUQ/J5OVOqM2iVp2qe/JP5I7USyIDzn1apw10UK9SE5kN6O2kdRqvuZ070Bz35XjGR/ZW786y8XbXGP40asPwj6jVdY9AddO+K7ljOUZfhbS7uIltg/6NlGbdgjIPcC1RnzIrwT6bLIFTMEsKJuBGgvl+qxAxJpYbPDM0wydPwZ8jRUypELUmWyEfLA0/Dz9i063drrb6CW769st8z4Lj20+Ni3c+HpmmjpdMeWyb4jse03d6Zm9HG3+ejwwygmFlX/mEfu4uyymH6P7cbzBhEVdibQinQ0kMO/RxZEYr3kZXAb6AsWn0cnrg20ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0i3/elJsNCh/WAwySChqtlyrIyj+z6xjdNH4QC+76QE=;
 b=K7LFjn5pzgYfOizYJrWQ6ha5FaV0aLAxcwOfNT/VsJmp3dNadervr+nfuis49yRxuTqT2KE6ct1XIxJ73Fv3eh+ktdSFe5BWgRI4GmSwqCLr703FEDEkM1tekxLbtKnW+ND2d0lhEdpY4fgW9IvkgYW5xBbMEdn0RXVjb59uAEOvf9b4umTF/I40YDcEylp1+RFz4uiHm4WnuVZwoiAdxEd1hmv9OOfAJE21l8VEwyZ/8T3WaAiTPc+VzdjEp4ApwAE5umhIdLWU7WHa8skcDIMjWAqO7LIRNivsyAAO7a04ZVJePrjkmu+FjSTRs/n6WJ/+RKCp4RoDbVoMaupa5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=docforce.de; dmarc=pass action=none header.from=docforce.de;
 dkim=pass header.d=docforce.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=docforce.onmicrosoft.com; s=selector2-docforce-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0i3/elJsNCh/WAwySChqtlyrIyj+z6xjdNH4QC+76QE=;
 b=UIqj2ho4Nr5AAdijhY8r35+hNLDL/4JeicVQcdZlkn0crMLfWP1V8okYCLrDseInpdA3LDN6UiOqFjX5rVeEUp+bBqAVkI4wv/vb06jtlezUSiJRHa2AVBYpSj0KhN86x3Ul9qb8vb1a4+SK1mDpjHp9GfCk9DXuh7M9lyuySyw=
Received: from AM6PR05MB4903.eurprd05.prod.outlook.com (2603:10a6:20b:12::11)
 by DB9PR05MB9128.eurprd05.prod.outlook.com (2603:10a6:10:367::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Tue, 21 Jul
 2026 09:08:22 +0000
Received: from AM6PR05MB4903.eurprd05.prod.outlook.com
 ([fe80::6b8f:8919:9555:ce34]) by AM6PR05MB4903.eurprd05.prod.outlook.com
 ([fe80::6b8f:8919:9555:ce34%3]) with mapi id 15.21.0223.017; Tue, 21 Jul 2026
 09:08:22 +0000
From: Tim Parth <tim.parth@docforce.de>
To: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "oleg@redhat.com"
	<oleg@redhat.com>
Subject: Re: [RFC] signal: per-thread control over alternate signal stack
 delivery for selected signals
Thread-Topic: [RFC] signal: per-thread control over alternate signal stack
 delivery for selected signals
Thread-Index: Ad0C2a5mCii6+plqRmWqi0ohehBXMgWFszig
Date: Tue, 21 Jul 2026 09:08:22 +0000
Message-ID:
 <AM6PR05MB490384CB834573A0AA94CCD1E1C22@AM6PR05MB4903.eurprd05.prod.outlook.com>
References:
 <AM6PR05MB49032404F2001561036ADA1BE1EE2@AM6PR05MB4903.eurprd05.prod.outlook.com>
In-Reply-To:
 <AM6PR05MB49032404F2001561036ADA1BE1EE2@AM6PR05MB4903.eurprd05.prod.outlook.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=docforce.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR05MB4903:EE_|DB9PR05MB9128:EE_
x-ms-office365-filtering-correlation-id: e9c99a38-0c04-4a60-bfd1-08dee7079d83
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|23010399003|366016|6133799003|18002099003|22082099003|38070700021|56012099006|5023799004|10067099003;
x-microsoft-antispam-message-info:
 T4+iOVK/cJJu84Y9sSQ/v7Q7DMK6Odfc43ESP06Rm9p0FvRmogy3UpnSoXHSj9h3HraktcAfwsd0XQBY8md5YXeGiDW73EoTso/dpj2xK0elY6hOxF4oPU9qqhjB7JIThpeoqa8i4zoD8jDpbDmbt8t9msV7P+6QPnES34JEsvchmbuHeLGghsvpWFGrY+Tggx/doxJOihweWLrsIC7RplyGRQQN8kXATJWmtzp2eknOhF/cv2zN7D4j3izbo8Z57Pj4NcU3MiIG2eIqpNg7s6g1svV0scDstW3qM7ldhiLfdR/9yJjShVhgs1Y+68BChXE1PST5IEDDshM+zrtytrmiD90NwYAzTcFSKcmcqNHEFNrArYyiPMiRBhXCRbR8cRlZx4k3NVZhWWf5ScLsd31485qMshIxUCHRX+3pI3Q2U+6cZbOqwuhKdhx37SMb/TFupSf6Mf8N3Cf0WM3ddKWrV4Yb3+3j+gZCK+KDDbd632iCz7XGMezy8UQRmiLLarRHIbUz3+mozUOjLSeXZ3W56QVzoXg76rbItywAcr/i786u8kV0bkPok0/e23KMWj7gMWewzNrk2eJHP0/QPrZ/Wr2FlgwdIvVlPGeZw3ce8sbXBm7UE6CGnvfD9LJTs8odqHSRoaxkKzTUk5yz4qKdc1gOHNK0QmPP9sgOhhJgY6JMwyhw8feZKA1texYhUBQ4obXw1tYlNKLwpX/B9KR7y6nQ4xnu4uNpmOpn6U8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB4903.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(38070700021)(56012099006)(5023799004)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?S9Te9DRRDw6ULWSt7qLY3M7AnstCK1jD5YZML+3+ri4smyBI+vGw+ji5DP?=
 =?iso-8859-1?Q?rTSobHaFfn1XBOD7bYYuETpo0rIUu3TyZ9kXRMyA0Cdd49KpsAUu7TjLUQ?=
 =?iso-8859-1?Q?jqxEEX88GHB8fAfnTFWLN4fOGtR6BKORLgzxZl3hImHk/nXJ+7RkW45V8X?=
 =?iso-8859-1?Q?KokI/Z+EiA2DWsOqdf6r1A2Hzh/HotNcKiqtjU9CpKi5OC+RxrecJbl+gS?=
 =?iso-8859-1?Q?YWajn0pytFuTK4qvmx5UJemSJqxwmijXkn2uR7NFgb4oTFKW9w/qZ7J8kH?=
 =?iso-8859-1?Q?sp/hdIc5WMoGuEyed1PyZELNXZ957SlSxhcxXAbCxJlAZ5s8WMKrXOrd67?=
 =?iso-8859-1?Q?Qu8EjBCl25t6yW+htgO0RyRoHaXRZMBa0A+gR87b8lyCUV6EUJz5vkMC20?=
 =?iso-8859-1?Q?C4bltn9N0atoLpShJ584GkZxZv4agaoPFp8uDcZI8+XimILA1TmTnjYPQk?=
 =?iso-8859-1?Q?WlzyRsn+/56abv7krcPR3Oue1PP1stUsWCaeN7to7Mch3/+SHAJgf3BE+0?=
 =?iso-8859-1?Q?RuaN4T3M6+qmwtIE5AGynl6c1gX8BQKC/lcw6vfhKLaZpmMQRZ67pjDLlD?=
 =?iso-8859-1?Q?inGHpD3iUD9Rd1SQeV9L0VEOA1fGnzLV/sICeH6q2oEtACe+JzNsmtpwZl?=
 =?iso-8859-1?Q?c9RnLHTqUKK6+fp+jrNRFDIYUQOCpd4TaBidGNgSHFdN1gZvV820axVCG1?=
 =?iso-8859-1?Q?uV9Og0TK1CD5QVXglLr/am+HIBDd6WC2qumtpXo2jNvVqdByh/OqY0KY5o?=
 =?iso-8859-1?Q?kuXVX2hCa6SXNfaBN3lPdwfkLH8nYtvJpnn796w31TJsMGlkgPtxW0Xbqd?=
 =?iso-8859-1?Q?Cwy9Yy0Vh5IHGQNeJPzXrHAgAF7T2j2ON5KfEqaXrqUHlJy1okKAdLf1Co?=
 =?iso-8859-1?Q?K8wRclpYc0neg3TKX6pl4bv9VEapWqPWovNn2vf3V7W1D19+GniI+/yxhV?=
 =?iso-8859-1?Q?9wTduPA/+NOHUhd0ehkXrR+2ySkyWZdlYdhuMJhAm+pBk7Z1VFiNL7DaH5?=
 =?iso-8859-1?Q?M9dw1PEu+IfHVFblLAr8hTIsMXMoO5NmSOgbKlBX+fPooRt+Y32/68jA/c?=
 =?iso-8859-1?Q?xeKbe0o8URiKid52rtqT09x92IJKUriHFRMy/xbDd5Xr+mPkazLor3GhxQ?=
 =?iso-8859-1?Q?R50yq/4X2UFHraAcRzm8AueUcqjfmOmHF8scze4esFF2t9GQ3MMDSCcjAQ?=
 =?iso-8859-1?Q?V3KnFSvM1nBADlWy+saYpN52D5Vc0No+d4QYgc6uRfslSDSx9ir6WXIc7t?=
 =?iso-8859-1?Q?zwYvCiQc5ZeSx59jZ8owE8h2oYJG2ErzrSJCvcSOBOLlHdBFH62UD6EKFa?=
 =?iso-8859-1?Q?R4L4AdWiSUxRFB0vFtQJ7O2tOk0ZjlGl1CBqA6sl+ReHXg/JdE3zvddNFZ?=
 =?iso-8859-1?Q?YGX3+EUVpJxoNoxYOY7kvuOxTXqOKRgOnSgnlqPkTTUW8C4xFoTt65zri/?=
 =?iso-8859-1?Q?FzDvx27GJ6YvplSe18sTfgkQcKQJBQ3WAzvHBhJuX4NK8CiL8dKNr2djQL?=
 =?iso-8859-1?Q?brAb8uNxyc7cDbVkXE07C0Lo6MYt3a4jslS2BFR8fECDluf198amAGRlCO?=
 =?iso-8859-1?Q?aqvfi3l5Vo9Ejt+aQWPMcfIXLbWaw+7Hu0Vdau87o1VXNtW54WhHYlUOeQ?=
 =?iso-8859-1?Q?i1nqy/XgKxuOEjXUClgXOfkXvMGVTDRkeE66A1bmq2kb8Yf/hMdwGfnQL5?=
 =?iso-8859-1?Q?ec2EKcaUW0cwtEgx3ALUWEgEPbc2xQIpCY9vgtvUJMkqIbi/fHEsYb4HK/?=
 =?iso-8859-1?Q?HHzvpLvVCuhwo62lsJE0HZgEjQ79xkkzMrv8wLyMUI/nwrChBZxnJlCnTV?=
 =?iso-8859-1?Q?m4iJDpagEFoO35Zvhyo5p1zgXGNUBPGGGwM+0jZJDRzGMRgRkP6Y?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: docforce.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB4903.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c99a38-0c04-4a60-bfd1-08dee7079d83
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2026 09:08:22.6576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b5f6141d-a00a-4f0a-86d2-fddfde43e6e2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UjxnfMcZmVkdraldjYSCLy36hDm374cKGP/9YPvXDDWmsS3fTGRm11Cs7JTd1jeHa6gkAkOvzyJTTzfmNHTscQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB9128

Hi,

gentle ping on this RFC after four weeks. Adding Oleg Nesterov to Cc becaus=
e this concerns signal and sigaltstack semantics.

The concrete question I am trying to resolve is whether the interaction bet=
ween process-wide SA_ONSTACK and per-thread sigaltstack in processes hostin=
g multiple language runtimes is expected to be handled entirely in userspac=
e.

In the reproducer, Go enables SA_ONSTACK on an existing CoreCLR signal hand=
ler, causing CoreCLR's SIGRTMIN handler to run on a 16 KiB alternate stack =
and overflow it. Increasing the stack is a practical mitigation for this pa=
rticular case, but does not provide a way for independent runtimes to compo=
se their stack requirements.

Before attempting a proof-of-concept patch, I would appreciate guidance on =
one point:

Would an opt-in per-thread mechanism for excluding selected signals from SA=
_ONSTACK delivery be considered a potentially acceptable UAPI direction, or=
 is such a mechanism fundamentally undesirable?

If this discussion belongs on another list or should include particular mai=
ntainers, please let me know.

Thanks,
Tim

> -----Urspr=FCngliche Nachricht-----
> Von: Tim Parth
> Gesendet: Dienstag, 23. Juni 2026 08:30
> An: 'linux-api@vger.kernel.org' <linux-api@vger.kernel.org>
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org
> Betreff: [RFC] signal: per-thread control over alternate signal stack del=
ivery for
> selected signals
>=20
> Hi,
>=20
> I am looking for guidance on a Linux signal ABI limitation that shows up =
in
> multi-runtime processes, specifically a .NET host loading a Go c-shared l=
ibrary.
>=20
> Disclaimer: I am reporting this from the application/runtime integration =
side,
> not as a kernel developer. I arrived here after tracing crashes in a .NET
> application hosting a Go shared library through several runtime-specific =
issues,
> reproductions, and analyses. My understanding of the Linux signal subsyst=
em
> and ABI details is therefore limited, and I may be missing important deta=
ils.
>=20
> The technical summary below reflects my best understanding of the issue
> based on the referenced investigations. I used AI-assisted editing to hel=
p
> structure and clarify this report, but the observations, reproducer, and
> referenced analyses come from the linked investigations.
>=20
> This is not a claim that the current kernel behavior violates the existin=
g ABI.
> Rather, I believe the current ABI lacks a way for multiple language runti=
mes in
> the same process to compose their signal and sigaltstack requirements saf=
ely.
>=20
> Observed failure
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> A .NET process loads a Go shared library built with -buildmode=3Dc-shared=
 and
> calls it via P/Invoke. Under stress, the process crashes with SIGSEGV whi=
le
> CoreCLR is handling SIGRTMIN for runtime activation / GC suspension.
>=20
> The reproducer is here:
>=20
> https://github.com/egonelbre/csharp-go-interop-issue/tree/main/dotnet-
> go-reproducer
>=20
> Related runtime issues:
>=20
> https://github.com/golang/go/issues/78883
> https://github.com/dotnet/runtime/issues/127320
>=20
> The .NET-side analysis shows that the crash happens inside CoreCLR's
> inject_activation_handler path. The kernel delivered SIGRTMIN on the thre=
ad's
> alternate signal stack, and CoreCLR then ran a call chain deep enough to
> overflow that stack. In the reported case the per-thread alternate stack
> installed by CoreCLR was 16 KiB. Increasing it to around 49 KiB avoids th=
e
> crash in the provided stress test, but that is a runtime-specific mitigat=
ion and
> does not address the general ABI composition problem.
>=20
> Current ABI interaction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The problematic interaction is:
>=20
> 1. Signal disposition, including SA_ONSTACK, is per-process.
> 2. sigaltstack is per-thread.
> 3. On signal delivery, Linux uses the alternate signal stack if the handl=
er has
> SA_ONSTACK and the current thread has an alternate stack.
> 4. The Go runtime documents that non-Go signal handlers must use
> SA_ONSTACK, because Go may be running on limited stacks. For -
> buildmode=3Dc-shared, when Go sees an existing signal handler it may turn=
 on
> SA_ONSTACK and otherwise keep the existing handler.
> 5. CoreCLR has internal signals such as SIGRTMIN whose handlers may need =
a
> different stack policy or a larger stack budget than the alternate stack =
currently
> registered on that thread.
>=20
> The result is that one runtime can make a process-wide SA_ONSTACK decisio=
n
> that affects handlers and threads owned by another runtime. The other
> runtime can install a larger per-thread sigaltstack, but that becomes an =
arms
> race and does not give a runtime any way to express which signals should =
use
> which stack policy on a particular thread.
>=20
> Why existing mechanisms do not fully solve this
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> - Raising SIGSTKSZ or MINSIGSTKSZ does not solve the general issue. The
> kernel can only know the signal frame requirements, not the maximum user-
> space stack consumption of an arbitrary signal handler and everything it =
calls.
>=20
> - The kernel cannot automatically extend an alternate signal stack.
>=20
> - Clearing SA_ONSTACK with sigaction is process-wide and can violate the
> requirements of another runtime, for example Go's requirement that signal
> handlers run on an alternate stack when Go code may be interrupted.
>=20
> - SS_AUTODISARM helps with a different class of problems, such as avoidin=
g
> corruption when switching away from a signal handler, but it does not let=
 a
> thread express "use an alternate stack for SIGSEGV but not for this runti=
me-
> internal suspension signal", nor does it provide separate stack policies =
for
> different signals.
>=20
> Possible ABI direction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> One possible direction would be an opt-in, per-thread signal-altstack pol=
icy,
> for example a prctl() or similar interface that lets a thread provide a s=
ignal mask
> for which SA_ONSTACK should be ignored on that thread:
> PR_SET_SIGALTSTACK_EXCLUDE_MASK(sigset_t *mask, size_t sigsetsize)
>=20
> The default mask would be empty, preserving current behavior. Signal deli=
very
> would then become, conceptually:
>=20
> if (handler_has_SA_ONSTACK &&
> thread_has_altstack &&
> !signal_is_in_current_thread_altstack_exclude_mask)
> deliver_on_altstack;
> else
> deliver_on_normal_stack;
>=20
> This is only a sketch. I am not attached to this exact interface. Another=
 shape
> might be preferable, such as a more general per-thread/per-signal alterna=
te
> stack policy or a way to associate alternate stack requirements with part=
icular
> signals.
>=20
> Questions
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1. Is the signal maintainers' view that multi-runtime processes should so=
lve
> this entirely in userspace by agreeing on one sufficiently large per-thre=
ad
> sigaltstack?
>=20
> 2. Would a per-thread/per-signal opt-in policy for alternate signal stack
> delivery be considered acceptable as a Linux UAPI extension?
>=20
> 3. If such a UAPI is plausible, is prctl() the right place, or would main=
tainers
> prefer a different interface?
>=20
> 4. Which subsystem/list should own this discussion? I am sending this fir=
st to
> linux-api and LKML because this appears to be a userspace ABI issue aroun=
d
> signal delivery.
>=20
> Environment from the reproducer report
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> - Architecture: x86_64
> - OS: Linux
> - Example distro: Ubuntu 24.04
> - Go: go1.26.2 linux/amd64
> - .NET: 10.0.6 and runtime main were tested in the linked report
> - Signal involved in the reproducer: SIGRTMIN
> - Failure mode: SIGSEGV while running CoreCLR activation handling on the
> alternate signal stack
>=20
> Thanks,
>=20
> Tim Parth
