Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792701901;
	b=qJ7VuHKtzcj7qIz1FL8xeXwYLeKVm3Zg8i/S85NUVl+9+JOvQxpFb/4LcWN5+bbmzjzT
	 VF1FmBowkvWy7tqFCYToeEi2o/T8CCxLQ7g4sES7+XQLgdJruToSQ4V4hJ51mvRyM3nhj
	 2sT9F9oSv49EWZM3DZVJXQGjIUkozwM378E4iqdj1irJNKL7kVNOajVEnCLc7ZIvTtAUh
	 d6Ly991gYTaOsGrCoieOdWlmpKPbnfydYRwp1cm394HOhzr6xn8+YgIFNMd+t4OQqPvuP
	 n0YggPdMnkCGDOGiTpLNGfyZ5OhlnyMehsJv/dUrjNeXJoKKs2h5yMVuyYDGqMIp2KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792701901;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=KUa73tAP6sqc80IwZh4prgSCGi9ezU4jrTu+zr0i9qA=;
	b=cZrtGFsy2maGy51prefipPe4r7xOm4leXD8/Q3qV3Ga3tyIaN3wm6dyUaeFBjSQX6Ghr
	 5oe6S8zuG0DGtUlb4Nst1SLa/bWGB7twyaTmvvaMdNoXxUiJWubTv4Hga5TTdNc+/6t2B
	 Jq1emG4cO8UKqd5NoL+0G6Tdb6RUFkmn/uQxHrImmEfK5kwLJzpbUf4A8g/eXHmSzfMIp
	 xvYWmog7spOKGN3ghPE4feOKzO0/VsL7I4s6rJkKkOCTJ4phtJet2YTQFgyY7SzII+bjG
	 0JVarCqyFCU/yrrwBMAHeugB6x1wINKa7Wja7hDtueT0fHulbGNEClxMBel6nKK2jRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=INHuFtQX;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CCE606A31A;
	Thu, 22 Oct 2026 20:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3CCE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=INHuFtQX
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MIE9Vd747378;
	Thu, 22 Oct 2026 20:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=KUa73t
	AP6sqc80IwZh4prgSCGi9ezU4jrTu+zr0i9qA=; b=INHuFtQXCrvxUd/nxpENCk
	LBin4ksk+tIqygfEHxJCgc8fuK+zI6uY3pyMhhVtAfdvbKX33PDtmswcEUMs0utO
	nsy8ak9edxpnhH7JQZHv8wLi9v4wj9bLL1wK+XxhecMAEYxtobeSEKCbc0NT4FdU
	+/3yBMPz5FucCW1CdDwqtct9iHTa3Fd4Rq6XkGW+4uTGOJstJSPwhMzoGdBbvh6G
	ReHypm9HNVp5RDBpz51+tHDWEIuKBYzkZOjm8qqlWtFi5STgcWHfD2tAjyo4AW9K
	mmoT0XrUnaITkCcglXXbwnW/LSwhUZBZOfrJbmWs5qeyArT1eumqsDgKJWr3wllw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw591fgy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 20:43:36 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69MIK4dT862992;
	Thu, 22 Oct 2026 20:43:35 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hekdggtr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 20:43:35 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69MKhZSd31130202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Oct 2026 20:43:35 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F16DF58056;
	Thu, 22 Oct 2026 20:43:34 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56C0258052;
	Thu, 22 Oct 2026 20:43:33 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.77.162.217])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 Oct 2026 20:43:33 +0000 (GMT)
Message-ID: <dcc62b1f9a64fae22cacdcde55a2110dc59e7c2d.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: Mimi Zohar <zohar@linux.ibm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jason
 Gunthorpe	 <jgg@nvidia.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Dionna Glaze <drdeeglaze@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-coco@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
        rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
        aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com,
        pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com,
        ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
        rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
        dave.hansen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
        roberto.sassu@huawei.com
In-Reply-To: <827296091dbd27becdf85ad8301f94cb16025afb.camel@HansenPartnership.com>
References: 
	<CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
		 <20261019225658.GS13920@nvidia.com> <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
		 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
		 <20261021143529.GP3008132@nvidia.com>
		 <95b895522bb314187ac1cdc5d0c143c01f0705a9.camel@HansenPartnership.com>
		 <20261022131141.GD3008132@nvidia.com>
		 <db0f90dde6421c3f2ca0164ea042e73d13b4d02b.camel@HansenPartnership.com>
		 <20261022191911.GB3746973@nvidia.com>
		 <d3274fc7bea368e7e117fdffcff2193210d9d8b7.camel@linux.ibm.com>
		 <20261022194527.GE3746973@nvidia.com>
	 <827296091dbd27becdf85ad8301f94cb16025afb.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 16:43:32 -0400
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Evolution 3.58.3 (3.58.3-2.fc43) 
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: yaJZ0r2Xr5BFR8E-vk2nMF_ISSMIxKQz
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA4MCBTYWx0ZWRfX5WqoN2j0T76f
 ydyr88s51yqER3SZAr+E8/CO9dNbdc21NG9wWUzlJyA4gS+3iOq29Kt8l16rSqQxfTO3BzRvPG5
 SUO5phcqtnxuuWyo6y8bwgS/aCt/YAM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA4MCBTYWx0ZWRfX5C8WVHR/Oo15
 WrnjbK6XZt7h8nTNGfMhn5nAFujl2P41K+IjoAi3syIZyf/g2U4eeu0O6+QPyc3I50KqO7a0dem
 imQTLUttWEU3qPs4xrUKyq3uA5tJ0M7TkBrxu6Lq5iTVtvUc6yfYN818UtwAtfBfO7Jub81XNnl
 vRYEYh6A6Uw797V1rN7XJLaHjJkMO3A/kdQ1hR9MaEgHuBMY0YjROgt2eN7B022jPyy1LKr551/
 4wIJYhLd+g9o8Wf25Ask4hkprTmHOiEpM3kblmofJ+iUBa1/zHFXLz2+6Ht44U3R4UvMnulU4rB
 VhrlnGAdu5EOdSQLVXWZ2zfAYpJMXXLaoR7YqocGz9VqqDFA/w7aLHqbaG+7I7JEtidOBjXkQdq
 8MD9MHomuWL8V6IB2wOTaKEkf39va8qAFfxZB9tlgewdfIRVhNZLs80ZLcxWmkaDsjdgEKAI7BV
 5KJXr2uCihwLRGYA5pQ==
X-Proofpoint-ORIG-GUID: TKhfdmFmEYh4lueQyisSIkbNtOqRwnNZ
X-Authority-Analysis: v=2.4 cv=Ob4NnRTY c=1 sm=1 tr=0 ts=6ada7579 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=xvKMnzRlZjCcE3-R3fcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 phishscore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610220080

On Thu, 2026-10-22 at 15:52 -0400, James Bottomley wrote:
> On Thu, 2026-10-22 at 16:45 -0300, Jason Gunthorpe wrote:
> > On Thu, Oct 22, 2026 at 03:37:46PM -0400, Mimi Zohar wrote:
> >=20
> > > > Advisory entries shouldn't matter with a scheme like this.
> > >=20
> > > IMA has something called violations (e.g. open-writers, ToMToU),
> > > which are more
> > > than just advisory.=C2=A0 They intentionally invalidate the IMA
> > > measurement list
> > > since the measurement cannot be trusted.
> >=20
> > Maybe I got lost, but when James said "advisory" I understood this as
> > the TCG type that does not get included in a PCR extend.
>=20
> No, I meant the TCG type where the event description isn't part of the
> measurement (and thus can contain pretty much anything).
>=20
Thanks for the clarification.

> In IMA
> measurements, the path is part of the log but isn't part of the
> measurement (primarily because it's not reliable: a mount namespace
> could make it anything it wants).

You have a good memory!  Prior to IMA being upstreamed, only the file data =
hash
was extended into the TPM PCR.

The upstreamed 'ima' template extended the template data hash, containing t=
he
file data hash and filename limited to 255 bytes.  Depending on the templat=
e
format (e.g. ima-ng, ima-ngv2, ima_sig, ima_sigv2), the file template hash
contains the full file pathname.

Mimi
