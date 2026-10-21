Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792609534;
	b=mPZ1/8Dmr7iITxmyljg+F78C2BI8wYx4DR5b+UO8BbfSjAjaD4I540lFZlSCm8mcQElT
	 0GXRvmGzBILqTzyRQBgAgg7mA2VyE+IuSyhGmThbohjySoQ3XGuuiCQhKPwBZXCSN2soe
	 MjsF+tYVdNrwicNVR8+tKtEdHVuctJDcXAeN+rK1px9P9cQ/4NbHiZacgcS/ZPikr4LmD
	 iKbkKawVb6m8yPJ2WlG7CUr7Rl8lJ0HxDJqsQ/i8Q4vOLqIFpo7PcABr//q3PfkNccY3M
	 G15k3CnxhART/CQ+otn2DVkoFcfB8tZXXDspvbPwsOS/MFSQ6giSx6Id8IzQnp9U8rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792609534;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=xQ2SqnwVDG5xMzvzDIXO6M7gDqTy1UNMqzDsHAfACMk=;
	b=jo/PwyEj4v7cvdYjgLzxFYLs8VuVfGBoGKdHcYKo4jIP6LwJQdvoI23/lXL0QeqpPdDP
	 4dxKAJeTrZx5AuQvVaPtqFZsPDzY2jNJ8YXwRJTZHUXCGbB4CtZjS4/ndKSvFqVpnG5Q6
	 j2gtn1P4+xDJTFWM3RLGy5F5MK7btI5nBAnoXyCZQCWyEsMq8bMyIst+smm9iZKyp2q32
	 vs6PtDVpARkv/0+biJdY89WUHjTbpwIztMvz78rFHFUcjXJrAcivoOHFzw05MSyqe/Bi+
	 zuFueATjrx8AkZrAE8llBuOP0alUhQjMXnoJsO++KtMICX2OUSlSsKYERBJk2g3IOig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=coL7n6oI;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011F8606A31A;
	Wed, 21 Oct 2026 19:05:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 011F8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=coL7n6oI
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LIE1B6208261;
	Wed, 21 Oct 2026 19:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xQ2Sqn
	wVDG5xMzvzDIXO6M7gDqTy1UNMqzDsHAfACMk=; b=coL7n6oIAQolMtk9jv3xCD
	IdOjROBbuS8cjUl20s1RZTJh4mekwegdSgpa4i2L1qYmOasx8S0/v0cu3MUxqjuQ
	3VCnBeeJzA3TxPZX64Yhiy6b3At4DYvKAZ4+ZwN5vy0w1M0OJKdZ0JYsIYe7AZSK
	FcmvztvzKFbdc7QtK++cBEEUbsdfAXXd3f0rxO9MsW7n05QxY581f8hdEonceQOA
	CACZZBE/sHGxQqrT8NCDVgcpdYYdqRPbAo+1CipenFAZt+OEUzJYDXmysvjdywCs
	x8QNQv2W64rPX/In2OSqbV+9nWruPsQOwizQozakHKOyzJCgY+3lRzlEsKYSyJQw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5bk3jk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 19:05:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69LHopV93498329;
	Wed, 21 Oct 2026 19:05:13 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hcmuh8gr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 19:05:13 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69LJ5CNV61080034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 19:05:12 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 909FD58056;
	Wed, 21 Oct 2026 19:05:12 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 370605805A;
	Wed, 21 Oct 2026 19:05:10 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.77.162.217])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 Oct 2026 19:05:10 +0000 (GMT)
Message-ID: <8d8833fac61558a94af415143530884349584a2f.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: Mimi Zohar <zohar@linux.ibm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Dionna Glaze <drdeeglaze@gmail.com>,
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
In-Reply-To: <20261021143529.GP3008132@nvidia.com>
References: 
	<CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
	 <20261017203407.GM13920@nvidia.com> <atPgqROZZxnihYfC@kernel.org>
	 <20261017231007.GP13920@nvidia.com>
	 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
	 <atX9fugGUsI0hGcA@FV6GYCPJ69>
	 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <20261019225658.GS13920@nvidia.com> <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
	 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
	 <20261021143529.GP3008132@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 15:05:09 -0400
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
X-Proofpoint-GUID: ydaOzlwPIUk9SIhOIcCkK3SVXfS2DDcg
X-Proofpoint-ORIG-GUID: GzBYn879Oa5NzXnY4sgOMq8X1dbUx1fB
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA3NCBTYWx0ZWRfXwyVoKuAud310
 A3MMgRuO3P9BfDlryZr7ihLhpK+1PPfP0xO1xgsoY0qD3mT++OvGba+8UA0zkcoD+iWg/elNtcH
 Z8gPzXT/JWDMgUcPZBCKi26sOkrkUsY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA3NCBTYWx0ZWRfX1hmDKI4a0lIN
 oCbznsJRgcS0JN6foELRHP6ISHyPt+L/UW64K16gcO4VrYiohYmtKf0oW63pkMniBR5FA572QN5
 ieNRoOqQ5C+MUuzixWaCYc9xzLcGBWUGx03ndwS3NTq8ewrjFeaaF25ZgavBj0gzJcdgbUGxSh1
 z/ImEgbAtQpFnbxfpY5IGBnzAOUVBhPlq7kbzT4jo+YS8enEUnhx0XveFs7pUFwmfqtIhy7rfMr
 /eNM5pZnlbLbm0Swwddnnl31pEYsNFSv3Bp6+k2s2ORgrk1ke5QlzwIRPi80LBWPLiKzQs+u8rS
 SF8vdtLnNGB//AB0FOdXciN8gmxl2uGcWMN78g8nK/9aLNTmGVGxuGAPsMu90zKkHsZHcndSc2b
 gg2i2oceWWm/HafsY/e03vEgK0dQEZfnGympFncPnRryoEodcVL2DFBslRUkKJieyf7rN1+dJEg
 a9Wr0QwuxTURorMH4dw==
X-Authority-Analysis: v=2.4 cv=Gb2CDgXL c=1 sm=1 tr=0 ts=6ad90ceb cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=yVQDdmlqToHGFoNqkO4A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210074

On Wed, 2026-10-21 at 11:35 -0300, Jason Gunthorpe wrote:
> On Wed, Oct 21, 2026 at 10:12:34AM -0400, Mimi Zohar wrote:
> > > > I think for now we should not include a new dynamic log here, the u=
API
> > > > around this Jiri drafted can remain a future step. I don't want to
> > > > open complicated discussions about new functionality at this
> > > > stage. The whole CTLV idea in general is a big enough thing to bite
> > > > off for this series.
> > >=20
> > > Okay, dropping the log from this set.
> >=20
> > Thank you.  Please keep in mind going forward, that the scarce hardware=
 register
> > limitation (like the 4 TDX RTMRs) should be resolved (e.g. by multiplex=
ing the
> > extension path), not by combining distinct measurement lists.
>=20
> I'm not sure what you mean?
>=20
> Since the HW doesn't support sealing the only *technical* requirement
> is the verifier can reproduce the measurement register hash. So long
> as we can get there we can do whatever.
>=20
> Multiplexing extension alone isn't enough. We need some scheme to
> reconstruct interleaved logs too.
>=20
> For example we could add an atomic sequence number for each
> extend. Every log sharing a register can report the sequence
> number. The verifier would have to globally sort all logs to confirm
> the hash.
>=20
> Hopefully we don't have to tackle this problem. I hope that 4
> registers is enough for Linux. One for IMA, one for systemd, one for
> user? Plus a spare!

Agreed, I hope you don't have to tackle it either.

>=20
> Maybe we can build a multiplexed scheme on the spare? I don't know.

To avoid interleaving the logs, AI had suggested multiplexing or virtualiza=
tion
of the RTMRs.  Whether is has any merit, I'll leave to you.  Here's the ver=
y
short AI explanation:

"Instead of allowing external drivers or subsystems to execute a direct, ra=
w
extend command to a specific hardware register index, the new attestation
subsystem should act as a Hypervisor for Registers."

>=20
> But we almost certainly need to have logs sequentially created in time
> occupying the same register. Ie IMA may take over the register from
> UEFI logging. Here we'd want to report the start/end hash values of
> the logs back to userspace so the verifier can stitch the order back
> together.
>=20
> It would also be nice to think about a way to restrict the registers
> to help avoid multi-user conflicts from misconfiguration.

That would definitely be a plus.

Mimi
