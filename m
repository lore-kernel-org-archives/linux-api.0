Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792593146;
	b=Bp1TJbBRUNtqdrrPNL36YghA/+UaD1lu8Mcym7P2LRYG3hi5/vVd+O5hYAsWgarSm0gQ
	 BPqKyC8+8UsVIE1xlF3+IBvTlVdveWXu0x3D1Nz855tmCMPrzMmF3T1qTPuk9DMsRmUcl
	 +VT2+ERB7FoZVOQtJ7SUBjA2sipCGzUY8B/5SnHuq533zken7+PBiMALZRtLjB/3zS6Dw
	 BpNiBR/Vigq4J1eTyv+gS8wpCrxFHS36tUeoXnxyW3mYd0hpsbehVkQRTcyNIrn0eSkHZ
	 3sJ1UF8lxZs463+kSF4MjdZUOsgggCH7El2sN8ebi56HhhDiyONu7KHsPrnLcMLYGAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593146;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=WEikGICSMJKiPVXQX4CApolfCDnN5Ert0St5ZdogXiU=;
	b=fWrxwP74+OAYW8Fj3NP3YjImUhQQuA5aMSYIP59nFgoN5YWQeERTKWlZepjWqXWy4ZQe
	 j1OfOLjEINruaQpOvJLPvak4ck8kN+3NQvMTgLV3ZBucaPhSSSdjaPjJxtWy1uHPE3s2K
	 Pi2Mxg7glEHB7249jrrKsfRcXHyEO9pc3I6of8aLa0mxGoZvfpfHNb8hGVvRyzg9r6Wp1
	 045TbW9G5jojU5+/rzzkVlIkVKQDxIbJaTUdTed9DhzHHL73L+QsVCZrH7KkHTqLFS8wa
	 lsnE0EoTgX4OobZONx0e0Qf43m+gr60NVkQoXJBiCHpIDePV22AbojpCwEMVv7FD3yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=i404dnfL;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161DC606A31B;
	Wed, 21 Oct 2026 14:32:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 161DC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=i404dnfL
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LEEI1n1512527;
	Wed, 21 Oct 2026 14:32:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WEikGI
	CSMJKiPVXQX4CApolfCDnN5Ert0St5ZdogXiU=; b=i404dnfLKlkuEBYmLXRhFC
	WetwFK4PrnBk+MruFMMPOeJe4CT3HF1GLta/qJ5cJLcmWtwrw5fwgcR2zYGC1VK6
	yJ0vR2jnL8XdNhRbiQMn4frLHev7ZjADZO/bgXaLGIqxlD/mh5mNya0C+tilTedH
	sI1LEE9+pX/BRbEKsaww40ZEpSHRy3rVrKX7opMUJo7gylt880i5Ch7WbCMtJtbD
	t5z9pzpS/UoXMUF4mcFhOgBHROXjwTz2m6PDYWJWXXy88TbRIzicZPo8yyzKtR4J
	I5Ps7UCL1WTropB+SOwHiAANzZn1O46WNiFiDlY3mhFeFXy1Rd0AWOsYBj0UEPWQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw58smr5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 14:31:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69LC4mXO3038534;
	Wed, 21 Oct 2026 14:31:58 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hekdgap5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 14:31:58 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69LEVwhG15925912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 14:31:58 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D86758052;
	Wed, 21 Oct 2026 14:31:58 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 408E558050;
	Wed, 21 Oct 2026 14:31:55 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.75.7])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 Oct 2026 14:31:55 +0000 (GMT)
Message-ID: <5e4032b970ae2ea34b0b616977406e3183294c82.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: Mimi Zohar <zohar@linux.ibm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Dionna Glaze <drdeeglaze@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Jarkko Sakkinen <jarkko@kernel.org>,
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
        roberto.sassu@huawei.com
In-Reply-To: <20261021135102.GM3008132@nvidia.com>
References: <20261017231007.GP13920@nvidia.com>
	 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
	 <atX9fugGUsI0hGcA@FV6GYCPJ69>
	 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
	 <20261020140655.GV13920@nvidia.com>
	 <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>
	 <ateSly15N5mLrM1m@e129823.arm.com> <20261020165251.GG3008132@nvidia.com>
	 <ae372ed03da3cd2d57c922850b3b017bcb83ca07.camel@linux.ibm.com>
	 <20261021135102.GM3008132@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 10:31:54 -0400
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
X-Proofpoint-GUID: F6kky4VAncYXumWvdjaHVpU1V0Kc0aY-
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA1NiBTYWx0ZWRfX9RDjJFiBi0DX
 R/zLdRca0vcJjRWz4iVTNcQeZjaeH/UGmfPxasCRMIdjfa/mIl9ia+ed71+lVp/DFp7deL6VD7/
 3llrql3xF7d6QV8pueyDOXqbLYBwbAY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA1NiBTYWx0ZWRfX7eBV3DLTSQoQ
 YgC2k18GXHRvLSk4ov1Pz4UfE/K+8YF1xayrqNPvR9L7yQG1geRzdmP/Fkj91mbgcv549b9Cgnz
 JJC/mzPidrm8DrrJRz4tWos5XNn2sZyUQBl+Zaxg9HWZQQctR/UjChZXc9vwIHkNghKB79vp5pD
 70oWyAdcvzM2VyQo5uUcGeXS01lDfF4grKf1p+wzgwvEvFBuHvIdvlRQz4rK0NilEQUdCx3qY6S
 1oebzKCJwIMVIosXGrscLu4+qu2jMlkPvccfQAQuluC3fiTNGztSwwHC9f5w1gu7Xoxi6XC7iS4
 pgJMMWCP9CAcb/QdigJJduxHIaJM+kpnN05Dx3VZVEIg8o5aQuN/QHn7ucYbJluFZYT/jJfzyfx
 +uBuifplXxr6+Y+tnkne9ruRlxKSghJcdeow3XPZxXtC4FwHe2F+ghcYx/+iJ1EPfLKwp9WzJB/
 ilgsg/k0dgnO806LAeQ==
X-Proofpoint-ORIG-GUID: X9xH4nBqsbqysPHhLTM5UPrGPrNmInOc
X-Authority-Analysis: v=2.4 cv=Ob4NnRTY c=1 sm=1 tr=0 ts=6ad8cce0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=c7Uk0Hrh90vnBjMxToAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 phishscore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210056

On Wed, 2026-10-21 at 10:51 -0300, Jason Gunthorpe wrote:
> On Wed, Oct 21, 2026 at 08:23:05AM -0400, Mimi Zohar wrote:
> > On Tue, 2026-10-20 at 13:52 -0300, Jason Gunthorpe wrote:
> > > On Tue, Oct 20, 2026 at 05:11:03PM +0100, Yeoreum Yun wrote:
> > > > But, I have a related concern about deferred probing of RoT devices=
.
> > > >=20
> > > > For example, if TPM probing is deferred until after the attestation
> > > > subsystem has been initialized, how would the subsystem handle the
> > > > TPM becoming available later (This is reason for
> > > > IMA_INIT_LATE_SYNC).
> >=20
> > FYI, this patch set initializes at module_initcall(), not even late_ini=
tcall().
>=20
> Yeah, it's fine for where this patch series is.
>=20
> > > I don't think it would be any different, the mechanism for TPM would
> > > become generalized and apply to any attestation driver.
> > >=20
> > > This series doesn't attempt to do that flow yet, moving ima over and
> > > dealing with this is another series :)
> >=20
> > When TPM device initialization is deferred, it is retried during
> > late_initcall().
> >=20
> > As there is no way of ordering within an initcall level, there is a rac=
e between
> > the device driver probing and the call to late_initcall(). The solution=
 was to
> > allow IMA to register at late_initcall_sync() based on a Kconfig.
> >=20
> > Both device_initcall() and module_initcall() are at level 6. Are you su=
re:
> > =E2=80=A2 the PCIe SPDM Devices will be ready at module_initcall()?
> > =E2=80=A2 the PCIe SPDM Devices are not deferred to late_initcall()?
>=20
> Why does SPDM need to get involved here? The device acceptance flow
> and SPDM stuff will be managed in the initrd. The subsystem can accept
> drivers and load a TPM/etc earlier while doing SPDM later. That's fine.

If there are no PCIe SPDM ROTs, then it is irrelevant.  Otherwise, the ques=
tion
is whether the PCIe SPDM device will be ready at module_initcall().

>=20
> AFAICT IMA needs its ROT to be loaded before we reach the initrd.

Being able to measure the early initrd measurements would be nice.

Mimi

>=20
> DRTM also needs a ROT loaded much earlier as we need to measure ACPI
> (and the initrd?).
>=20
> I imagine attestation subsystem will eventually have to be ready to
> accept drivers prior to ACPI.
>=20
> ARM's DRTM architecture splits the ACPI into parts that are already
> secured/measured somehow, and then other parts that the OS is
> responsible to measure itself. This split is arranged so the OS can
> discover the TPM through ACPI using only secured ACPI tables.
>=20
> Thus we need to parse enough of the ACPI to get the TPM driver loaded,
> an attestation driver for it, and then continue to parse the rest of
> the ACPI that wasn't already secured.
>=20
> Yikes! I dread making all of those things.. But that's an option for
> the required shape of things.
>=20
> Jason
