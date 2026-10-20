Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792509809;
	b=Kx2Z4yfj6MvAMP7bu+CdS9/f9a61sEBo7GNmFOo03IYwq0PdlMDpMZLPVH1mewOEFMTZ
	 s615PsEWAczTCW/QndMAUwYEmNsoBKe007JydRKV4jkigPQlmEOIz4AxP0NCEFhydWVXI
	 jVUJSNPXBZAYXqX6nDXXJnd0GmGkQijcfakDqnlyi/uMkpRS5qAu4DvuHjtGKN4Dbim8r
	 ZX13vD0S31GXFbS1sOJqvSuOIQ7ozQdvxNHqF3Kutp3zhxsG2JQl4jM1B8Cq1+aS1NEtK
	 4NmHVk+AHO62ajVBVJeVguXUKcmGPxmZ8gyRk7sJQ2f+fofuhm7Ic8KVDviHqIlfgnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792509809;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=LyHQMbJikx7xBSFYKoXIMj/0bcUbQtzrUPaXCrP3rzk=;
	b=IW7kKvl6ybD0ZQCH8UNqcSQinaqyHrpET+WAbk6f3w/PyS2bfaMUjKtSZGCq5eI6GcRV
	 K/Fy9ksZOiLO4WX1pL3oJhBDqvXekbzDURcCgy8Txopnu+PlQJvRsOgvZFMOCUMnWn2O7
	 d+DLsNT8iJyKjJSczk2C6JTDyi/+dvrzX0hHMFj2KmgOMKMJ6Wz2DhCA/YKDZgFC+bssJ
	 Lsw+VnOGQWlM7Psbb0AeBlOqvd77XXInvQCwaAjw8k4YhNkjRo6TMSqOLN+xUKAOIYq3A
	 xsgBBRmx5W4PdTJzAc/86PFsZDYq5M7llak0tY9i9UhQ+yK42eq78PlzwtoC1V0d05w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=FfTQ7Vy5;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6BB606A32D;
	Tue, 20 Oct 2026 15:23:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B6BB606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=FfTQ7Vy5
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69KDEKqA1400981;
	Tue, 20 Oct 2026 15:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LyHQMb
	Jikx7xBSFYKoXIMj/0bcUbQtzrUPaXCrP3rzk=; b=FfTQ7Vy5O1tW33td2mLFln
	OU4X/oa3JqFpxv2V5ONpQHtGO5H6tTa8DtnvpEwRn4XAaLpdr+EE4C83nMg4yFWb
	TlbKN0k0h0mUQ8jYsz2MjVoUjmtXyYoPWBqq1EqnDmnB8lPx+z1ruCKYWH4rdBIU
	QWzKJYHQS0xD7ZBALLB8a2IQE7Nba8jE5WDK/td81Vn88yTro1hIxVGSWQ8VxWXA
	5k6I5uWaQEJeei+FAckNQc8KBfSHjo2m4pSb36B0y1MdDUblEWwePsq56XNtY0yy
	mA9j91ek9xim3WZ/65S857PM/B/7zvFXwF1Ix/z7ykywXlwXOHZrUCLbu9dyRDfg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw583fr0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Oct 2026 15:22:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69KDK1iG350728;
	Tue, 20 Oct 2026 15:22:33 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hcnjh2ejb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Oct 2026 15:22:33 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69KFLkDu2949858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Oct 2026 15:21:46 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0F9C58054;
	Tue, 20 Oct 2026 15:22:32 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1AFBD5805C;
	Tue, 20 Oct 2026 15:22:30 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.185.52])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 Oct 2026 15:22:29 +0000 (GMT)
Message-ID: <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: Mimi Zohar <zohar@linux.ibm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
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
In-Reply-To: <20261020140655.GV13920@nvidia.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	 <20261016234354.GA664420@nvidia.com>
	 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
	 <20261017203407.GM13920@nvidia.com> <atPgqROZZxnihYfC@kernel.org>
	 <20261017231007.GP13920@nvidia.com>
	 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
	 <atX9fugGUsI0hGcA@FV6GYCPJ69>
	 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
	 <20261020140655.GV13920@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 11:22:29 -0400
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDA2MCBTYWx0ZWRfXy+5R0tKb354o
 J8BGXeAuPxh5pjl5jo5BRmfiDIpfcKZpe0k2MOPBtXBUzXGWS05C5UL3hvFB/25WuZSputgV4dT
 xJUpEGNuzrQrc9R/B3GHKTKPuZqlgFg=
X-Proofpoint-GUID: xv6GHz6zNLONi6YmOmB4pcqCAEDlm5mZ
X-Proofpoint-ORIG-GUID: thjdnNims9VKADJbfk5fg0P1T2nPqtkL
X-Authority-Analysis: v=2.4 cv=UOBIjyfy c=1 sm=1 tr=0 ts=6ad7873b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Cc2t5CyIl5whlRMK8MMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDA2MCBTYWx0ZWRfX8JlxZhTEPV2s
 vT0JtiPCTq1/pMMvpW3NfmWghQTaE4RggoTVC+Z+EBpSpq60kk+zpnMIxVafbJoDPv5Q9fEajxV
 34FsnIoJ0Q05xe3bcjVlrAwwrosgHNR7yROBqfOD27g5BmMYWg7kcKOuYa4egReyLkY8ZI2yvi6
 Cg4HxX6zy7F0GEhoOagcTF6hMKAYV06Y4atMeBw31an8GzpKM0hfC/cOBkveC9BHQMSwSHd9LIX
 deZIbCoUHHbm8uNT0GuGat19zrjsh47VBoQ9fASnyvyYPFzbaYLEbbsQiApSjp2AzuJC+gsYS7M
 TIwwItigRI4fqsu/6NO2QbbWi31iS3E85NsGX0NY1rw4u1S529CqvyH6x8jCX0VI6cn0dz+PIux
 DqYz6lW1wyLJ/OFQc3thit/n0mtmPtXmsY7Go2XRPWNc0EJgpVNrYkr6/pLlh9mnsbe2r0wo2km
 xEEDHNXrk/qZiBseLZw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610200060

On Tue, 2026-10-20 at 11:06 -0300, Jason Gunthorpe wrote:
> On Tue, Oct 20, 2026 at 09:45:13AM -0400, Mimi Zohar wrote:
> > On Mon, 2026-10-19 at 09:10 -0700, Dionna Glaze wrote:
> > > On Mon, Oct 19, 2026 at 5:08=E2=80=AFAM Jiri Pirko <jiri@resnulli.us>=
 wrote:
> > > >=20
> > > > Yeah, I was thinking about this and went back and forth. In the end=
, the
> > > > only reason for leaving it unbounded is to allow multiple independe=
nt
> > > > users of the same register. For example, IMA and systemd could shar=
e a
> > > > TDX RTMR. The systemd side would read the journal through the
> > > > attestation device and the IMA side through securityfs, but both ar=
e
> > > > views of the same journal. If one side truncated it, the other coul=
d no
> > > > longer replay the RTMR. Isn't this the valid usecase? Do you see ho=
w to
> > > > resolve this?
> > > >=20
> > >=20
> > > Bright minds have spent a significant amount of time working on this.
> > >=20
> > > +Roberto Sassu, +Mimi Zohar
> >=20
> > Dionna, thank you for including us in this discussion.
> >=20
> > Based on my questioning AI, it sounds like the purpose of this patch se=
t is to
> > introduce a vendor-agnostic common attestation subsystem framework that=
 can act
> > as an internal kernel multiplexor for any measurement consumer, like IM=
A or
> > DRTM. By providing a direct kernel-to-kernel call path, it allows measu=
rements
> > to be routed to different Roots of Trust (ROT)=E2=80=94such as physical=
 motherboard
> > TPMs, Intel TDX RTMRs, AMD SEV-SNP registers, and PCIe SPDM devices=E2=
=80=94without
> > hardcoding IMA to specific device drivers.
>=20
> Yeah, I would say that is the eventual goal, this patch series would
> be the first small step along those lines
>=20
> > To support this framework, IMA requires a strict, atomic execution sequ=
ence to
> > maintain the Measure =E2=86=92 Extend =E2=86=92 Execute (Measure Before=
 Use) guarantee. This
> > initializes early during the late_initcall phase within the initramfs (=
via
> > dracut).
> >=20
> > If the new subsystem introduces a direct kernel-to-kernel multiplexing =
call
> > path, how will it ensure the mandatory synchronous wait behavior when e=
xtending
> > multiple hardware backends?
>=20
> Everything has this 'measure before use' requirement. Why would this
> be hard? Just loop over all the configured measurement targets if
> thats the plan? Maybe I'm missing something?

As long as the measurements aren't queued, but actually wait for the multip=
le
ROTs to complete, it isn't a problem.

Mimi
