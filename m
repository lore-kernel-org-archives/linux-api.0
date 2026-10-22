Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792668390;
	b=fFE+JDvXK/Ui+ZDXPwHNEm14Gjuce+PMr9BqjBMNkxZadNWPFz68z0hThOzPuB26wSzu
	 fOKXO67pAUB46123dkmxubPiSiiTr4R4jWjUEJtVh3NUl5w8bZS+AMRTpuN+C2OwEMGQP
	 zS3HpzvH+mWtTvDX4OPgSAH5VrjRyLlc94bB2FuACaJoxwTA7m3wHvDMzCutK8uaIyGjr
	 ZQOzhM+ykzSC330O7pMU/IezZHO9G7le7iIcB3Mw9vSnAE1yM53EhSr+D+HofAV3kFL01
	 1Gl5YiVJLjyY9qZiAzZIZzzL4W9uUql5gDMi8ZYP0aXMzYjsgvKmiFDr/INL5hcbOYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792668390;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=H75v3I9hrZtnPC5oLMkBzDelhJGj3dWwVG0uNk3+Ha0=;
	b=idH2wP9EQOwbvW57i6vWqaEV2vnQgzSgh+/FyPqyAgC7IG+oKSTMoano0m2sb4xy3bYo
	 078UP7SAfhEfUOqXJVlTWfygFDxo712uw++RuifoU2rwlefkLK3yHzL3Bl31uLngazhuH
	 aob9PiLkAkh9HTllZtW/pJowkJEDGZihNt4a1kAl2vbGQy60du8TL7jA547CSRsSRaCqC
	 pn4mtoRb733mUyIyhlFjFXTMbU8vC11PheIbmheJXRngSirbxf/e9Lt0h01TnYURAPyv0
	 ryQpake3NlEUab6uC88oZ/CnG1ie9stRi8lhtQhZ3lOaJ5kKIB9NpXjSIuLkLEgwaPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=lsLGDmdW;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E78606A31A;
	Thu, 22 Oct 2026 11:26:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83E78606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=lsLGDmdW
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MAEYJv3824238;
	Thu, 22 Oct 2026 11:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=H75v3I
	9hrZtnPC5oLMkBzDelhJGj3dWwVG0uNk3+Ha0=; b=lsLGDmdWPtn2CX10h+XxDw
	x5wBg6WHB3+bSoaQUEvwIuQrjoGmajSen9pTPgRxWhV/s/tOjot1Aa03KEpecoCE
	fmyJCkze8aLBnQ+cLxt2I/ZddydBbBS19+S4GhpPbHf4OJXOmb6Tl87CDuEubcD1
	b+ERZaLyHwaTVI8IGjasRzMcCUsgwmv8hZen3Gbd8W1TCXe1NTmbIwk9x/M0JJr8
	z6JDKRgKi5Xf955VJVvnjvr/u5UFmdhqpBD1PQLIJiw1PD0jzdSl1zhYbXGx5NTM
	zvKpL+aeojQiNR1qaptzAO0/uMZCz5K9FsUdKPMq9bb3LE454xIFGQ4Oq8onCwIw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5a69br-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 11:25:02 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69MA4sQ3337793;
	Thu, 22 Oct 2026 11:25:01 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4he6gqhwnr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 11:25:01 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69MBP0ja1442606
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Oct 2026 11:25:00 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B46D58056;
	Thu, 22 Oct 2026 11:25:00 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D83D58052;
	Thu, 22 Oct 2026 11:24:58 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.112.79])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 Oct 2026 11:24:58 +0000 (GMT)
Message-ID: <2342b42699292d4e5fc85e5dd4d351a3f29ae336.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: Mimi Zohar <zohar@linux.ibm.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Dionna Glaze <drdeeglaze@gmail.com>,
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
In-Reply-To: <atnqmDhgaJycTf_Q@FV6GYCPJ69>
References: <atPgqROZZxnihYfC@kernel.org>
	 <20261017231007.GP13920@nvidia.com>
	 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
	 <atX9fugGUsI0hGcA@FV6GYCPJ69>
	 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <20261019225658.GS13920@nvidia.com> <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
	 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
	 <20261021143529.GP3008132@nvidia.com>
	 <8d8833fac61558a94af415143530884349584a2f.camel@linux.ibm.com>
	 <atnqmDhgaJycTf_Q@FV6GYCPJ69>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 07:24:57 -0400
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA0NCBTYWx0ZWRfXxwiqvDMronE4
 FQK3t3Ka+UBmU9zzP6ecQ8euUkLzhX4FWUA5V6YeEa4nH5caVDHgElYPouOKaWY3eO8sxSm1dQq
 H9/MmeIBwxmSOkAbNRJNbqEIv2r1PEY9b1MnCLPNEX55kJslBV5xEVWyyOyg9O0b9gQeRA+uSgu
 CHr64hZ9+eFCMu4Eg31bmjUZAedOL5lT0MHSsG3X9uxk9kuBE0aN07NN90hsjqZGukFlvNi+kbN
 qv0hKlFArX4L+q+8xOiOrZfCGEnyMBxfUuw+usWF8t2Xgp5pDm5omURfcg6/QKbMdBXe7lF7m35
 0m9fwfHY2VP0GfW6qd8iWkBOJ3LOOtvHhZ5+qfxq7bKjK7mEf3MJAAs87PHyTjNgR1mM/wIovh7
 9hTns2c/rsKR85/hvetAL40zf8fx8w==
X-Proofpoint-ORIG-GUID: -IIoPKCgjZ0iA8b4LLnSoxnm_Zenbl1V
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA0NCBTYWx0ZWRfX7uaAEEsIiURA
 ne+UmovPSY99pNXg6qSZquGDhuWRRe4QPG5ipgQoLtIN4s8DvmHYGAUjbPLNQTDpe8oGqQEQCGh
 DzJvSX212klGw9ZeBsDgcoe8AzXgIYU=
X-Proofpoint-GUID: Dmhzh_FOqH-X5ktGgnB0OO9LGedtpqZL
X-Authority-Analysis: v=2.4 cv=ZfSIpcVA c=1 sm=1 tr=0 ts=6ad9f28e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=cpN7-hlQ1AlEGHSOM8EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 classifier=typeunknown authscore=0 authtc=
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.22.0-2610190000 definitions=main-2610220044

On Thu, 2026-10-22 at 12:54 +0200, Jiri Pirko wrote:
> Wed, Oct 21, 2026 at 09:05:09PM +0200, zohar@linux.ibm.com wrote:
> > On Wed, 2026-10-21 at 11:35 -0300, Jason Gunthorpe wrote:
> > > On Wed, Oct 21, 2026 at 10:12:34AM -0400, Mimi Zohar wrote:
> > > > > > I think for now we should not include a new dynamic log here, t=
he uAPI
> > > > > > around this Jiri drafted can remain a future step. I don't want=
 to
> > > > > > open complicated discussions about new functionality at this
> > > > > > stage. The whole CTLV idea in general is a big enough thing to =
bite
> > > > > > off for this series.
> > > > >=20
> > > > > Okay, dropping the log from this set.
> > > >=20
> > > > Thank you.  Please keep in mind going forward, that the scarce hard=
ware register
> > > > limitation (like the 4 TDX RTMRs) should be resolved (e.g. by multi=
plexing the
> > > > extension path), not by combining distinct measurement lists.
> > >=20
> > > I'm not sure what you mean?
> > >=20
> > > Since the HW doesn't support sealing the only *technical* requirement
> > > is the verifier can reproduce the measurement register hash. So long
> > > as we can get there we can do whatever.
> > >=20
> > > Multiplexing extension alone isn't enough. We need some scheme to
> > > reconstruct interleaved logs too.
> > >=20
> > > For example we could add an atomic sequence number for each
> > > extend. Every log sharing a register can report the sequence
> > > number. The verifier would have to globally sort all logs to confirm
> > > the hash.
> > >=20
> > > Hopefully we don't have to tackle this problem. I hope that 4
> > > registers is enough for Linux. One for IMA, one for systemd, one for
> > > user? Plus a spare!
> >=20
> > Agreed, I hope you don't have to tackle it either.
> >=20
> > >=20
> > > Maybe we can build a multiplexed scheme on the spare? I don't know.
> >=20
> > To avoid interleaving the logs, AI had suggested multiplexing or virtua=
lization
> > of the RTMRs.  Whether is has any merit, I'll leave to you.  Here's the=
 very
> > short AI explanation:
> >=20
> > "Instead of allowing external drivers or subsystems to execute a direct=
, raw
> > extend command to a specific hardware register index, the new attestati=
on
> > subsystem should act as a Hypervisor for Registers."
>=20
> Isn't the hypervisor what we are doing now? I mean multiple extension
> originators share the same register and eventually the same log. Or do
> you suggest to go even further having a "generic_registerX" exposed for
> every hw implementation allowing the user to have full abstraction?
> The "generic_registerX" would be always alias to something hw specific,
> like RTMR2 for example of TDX.

I definitely prefer the latter, as everything continues to work as is with
minimal, if any, change.

AI's wording:
=E2=80=A2 The Virtual Mapping: The [attestation] subsystem exposes "Virtual=
 RTMRs"
(vRTMRs) internally to the kernel.

=E2=80=A2 IMA's Dedicated Lane: The kernel config routes IMA to vRTMR_IMA.

Mimi
