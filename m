Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792503943;
	b=5GU9KmBIWfmttGXUa0J+50jSIxF1x927xVVnSybQAiwAJliFMVLCmXcxS7uIlCLbAQbB
	 FbXovJG3szEJ1Cm/sXojjqwMUUMauH2GT9SvIAyncKTtOXwXjRAfKpfyutkeqmumrfm1M
	 qKmvVlLD1N6ZrPTLVZR+5IF7DUnxPayQmyhsXpHZs8ipkc7Tjv7xnwvELEuSjSUcxEEwx
	 HYAOtk9GMYih4IP9hwJFrq5FuZpTEDY1VijLtbAujvFoi5zFYyI2WGrWmEzSrE48R0avU
	 rjleKgHvooMOPiBeBxGJCEn/pfnLGTeC0SDHn6VBtKEim1n2m+WxIKwnDhEjJahENHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792503943;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=TBlQ8XEvNLoQoc5u8Ixhu1A95c9gfj4lGqG4ps0UPhA=;
	b=rt3AZFTOdTv7ydsrLVtN9YmQFCMkzehhZOSf6IzuK0H5xbeN476kCDsJgHNqzGfdM4tq
	 +xgiiaLNeg4jVULTFOe4xoMGPk760T6aWwmWigVVi9yAINH2nwXnHYTv7Nx/pPmHE0c3E
	 P2IRJ3xZ/eDTTfa9wGQ8G73PIPfmbGRfevmeopIrKzVBf9foAP5NCH1vcawmU2ChcZYKV
	 iwPxXiwEo06adwjACjswpmSOJZgKrJNcR877+gFqmapK8hnurQHVBolZ3ZL08W1+amTV0
	 l6vHZfNBlkciFNGKRxfOLc16hk7QKURGY7CzfiSZ2ZFARRhfRd2N1OM+JosrJ5bcwVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=lobz1BKJ;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39951606A319;
	Tue, 20 Oct 2026 13:45:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39951606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=lobz1BKJ
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69KDE6jQ2677907;
	Tue, 20 Oct 2026 13:45:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TBlQ8X
	EvNLoQoc5u8Ixhu1A95c9gfj4lGqG4ps0UPhA=; b=lobz1BKJ7orrjhojPMHzS+
	nezKnO4H0YowUzeui0QgHi+B+RNDC4ieaTfD/wKGBYt0DyWQME/wzliQdWap0mzK
	Bx6HRiHVJBn/eTOtFM5qmu0KQAN+WDsxKbVwec2oKSHOHevRlfUXH44UtxQpf54A
	b1ZkFysMN9ekffIC+Q9HS1rRo4EXQOecWXjAhfqAAh4hVG6+WtFxefAWHvleNyQV
	8DiRVHgGME9P3827chCUzF2QPEV7KJdfodeu8PpqBsjq7kxOMAvieOGjmKkbUmWz
	tueLfbaJw6y3Pv3o21oSTVX4SB8J7MPY+YnBwlmC+THptJekbaYa4J0TdtC9WdeA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw58k5r7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Oct 2026 13:45:18 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69KDZ2Ss1539114;
	Tue, 20 Oct 2026 13:45:17 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hckqvjcrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Oct 2026 13:45:17 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69KDjG3N8192700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Oct 2026 13:45:17 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 811925805B;
	Tue, 20 Oct 2026 13:45:16 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3B3A5805E;
	Tue, 20 Oct 2026 13:45:13 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.185.52])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 Oct 2026 13:45:13 +0000 (GMT)
Message-ID: <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: Mimi Zohar <zohar@linux.ibm.com>
To: Dionna Glaze <drdeeglaze@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Jarkko Sakkinen <jarkko@kernel.org>,
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
In-Reply-To: <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	 <20261016234354.GA664420@nvidia.com>
	 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
	 <20261017203407.GM13920@nvidia.com> <atPgqROZZxnihYfC@kernel.org>
	 <20261017231007.GP13920@nvidia.com>
	 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
	 <atX9fugGUsI0hGcA@FV6GYCPJ69>
	 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 09:45:13 -0400
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
X-Proofpoint-GUID: JtM8A38RBL3pm-4XpExNGRnUJbYOx1IJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDA1NCBTYWx0ZWRfX5a0BTeNDogy7
 HQ0ku9noWvy//AajEmcZvoM8yDC4VlINY6GJLGXIshPQ9qYymdbZncUJRcGN6eoGPSMZCX07m+G
 acJPmPM4yBTYsF4o+YWZvyI9CBeL5Ko=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDA1NCBTYWx0ZWRfXyxPutWlpO7ER
 sAuCdwbWN4XoLLpGWf1AgJqgPZKv/nRELbbFHPd9VAOItOlJf4x6EKK41MIww9qGCwHZRdNtgc9
 mvUVQjKNRDJlEZ0D+vKN6tGkGFgCDxPEnlB1t5C0qVYHzlffxB5njJnn+SfbdO2/d54MQuG4hKl
 A5JVTCcjVl/eQPH7BkJRsnk0xRnd5yytBexE8cWHNphq93NHqqMMLAbvtzIAiaU9F8TQTV3axG7
 3aN+/u2ZdLVQsUxAyey0SYMrzOkVJyZc2zHRX52+5KeAJbrwCaOOwzKl0F+zAwKlWyrdP9V/cye
 fEOGOJv/EHagwzxRpOu+b+8dRYFTDM2dcP530+30a9ETbjWHdbVk/ovWGEO+1BKP3Em/WZUZJ3u
 9j7Ckg9ejD+12OXwLFxkH6KwR2Z4/xEaw9KUJQFPiczsNq79WF7GUBkJhxSeWttr992xweGJJdw
 2qp8yPFtoi8ZTmus/BA==
X-Proofpoint-ORIG-GUID: O8O2cJueqZADDX7RlQ3tl2sxveS2Ra_I
X-Authority-Analysis: v=2.4 cv=Ob4NnRTY c=1 sm=1 tr=0 ts=6ad7706f cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=FK4dugxTnjcHPJTaTJcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 phishscore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1011 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610200054

On Mon, 2026-10-19 at 09:10 -0700, Dionna Glaze wrote:
> On Mon, Oct 19, 2026 at 5:08=E2=80=AFAM Jiri Pirko <jiri@resnulli.us> wro=
te:
> >=20
> > Yeah, I was thinking about this and went back and forth. In the end, th=
e
> > only reason for leaving it unbounded is to allow multiple independent
> > users of the same register. For example, IMA and systemd could share a
> > TDX RTMR. The systemd side would read the journal through the
> > attestation device and the IMA side through securityfs, but both are
> > views of the same journal. If one side truncated it, the other could no
> > longer replay the RTMR. Isn't this the valid usecase? Do you see how to
> > resolve this?
> >=20
>=20
> Bright minds have spent a significant amount of time working on this.
>=20
> +Roberto Sassu, +Mimi Zohar

Dionna, thank you for including us in this discussion.

Based on my questioning AI, it sounds like the purpose of this patch set is=
 to
introduce a vendor-agnostic common attestation subsystem framework that can=
 act
as an internal kernel multiplexor for any measurement consumer, like IMA or
DRTM. By providing a direct kernel-to-kernel call path, it allows measureme=
nts
to be routed to different Roots of Trust (ROT)=E2=80=94such as physical mot=
herboard
TPMs, Intel TDX RTMRs, AMD SEV-SNP registers, and PCIe SPDM devices=E2=80=
=94without
hardcoding IMA to specific device drivers.

To support this framework, IMA requires a strict, atomic execution sequence=
 to
maintain the Measure =E2=86=92 Extend =E2=86=92 Execute (Measure Before Use=
) guarantee. This
initializes early during the late_initcall phase within the initramfs (via
dracut).

If the new subsystem introduces a direct kernel-to-kernel multiplexing call
path, how will it ensure the mandatory synchronous wait behavior when exten=
ding
multiple hardware backends?

I strongly agree with Jason=E2=80=99s point that we should table any discus=
sions
regarding a new dynamic log or uAPI additions at this stage, and focus stri=
ctly
on exposing the static firmware-level TDX log. I also echo Jiri=E2=80=99s c=
oncern that
replacing the securityfs template log with a placeholder string would break
backwards compatibility for the existing IMA ecosystem.

Thanks,

Mimi


> IMA logs and systemd logs are both system level concerns that are
> relevant to the OS construction, not individual users,
> so I would just say to reroute IMA to use ctlv using a kernel config
> setting, then make systemd the new system manager of the holistic log.


> The securityfs log contents can simply say, "log managed by ctlv" in
> this setting, in the form of the template identifier.
> For policy violations, only the 0... extend needs to go to ctlv.
> IMA can still keep its violation log as a ring buffer when it's not a
> 1-to-1 violation to extension


