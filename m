Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792697895;
	b=CV2+XWq1pWHtFcBro5Fcvij4CWyrHc21VwNmzDuZ20sJPnjCQTgbTsNnuz8gv8tmigpe
	 1BtOYUidqv2CDQLzxAE6xUokmG0+OjhzRIZ+VtdqqcyH0NAlgujlw/l5gn4Kz102aqAk/
	 7bL4uGDPXogOPIloP21t+3OtXn5dfoF4+RzWuv11JpHmJCUjnekykSbvEI3v04h/xXbRe
	 ZrVI/yz0dy9E6ZdRb0N5XMhxFL51daCndIeCSb5+mMrs24VRF7XmxlW2DLKobIhShpIg3
	 k3buix6Bq48De3EtwvdHg4IHC8XGBRwjBqkD3c9IVaD8i0nFJFKYxPVIaI4FykSeyCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697895;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=QtwtA+cN6AR7dndEV+fufW5y5cti1ZI2yNysmL/3n3Y=;
	b=tBKGZ4fYvyYJf3ltDDKR80bB1ZSOcMQ/2rjAMpSgDiIf0eiBkl8NF8GPaYEf7LcIaPP4
	 YP5VCDMVIeQWWVuoXk7VgSOW2y5dB4MNDDf/FywN1CSooqbX6AwCXidE8wOeHrl0TXGPs
	 Ab4qgTQoLPSo4Pd8BsxO2dyQaZE57Oha75f0vDpyre5eIcEZxiY31q/EoA1ncaqHLaoi2
	 4oRlNSpbReZilfmaTkyriSShuQvxrdZPn38FxutMpnGy97A5/I6wtbibbGXiXaA11GnLZ
	 HrbpqlKx69JFSWUcRbvU1CHRy8w+rJSr9h+8tnP0MOuX3rMN2ZstI2eW+yFM566ETag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=H20AB8pw;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11AA60A2625;
	Thu, 22 Oct 2026 19:38:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E11AA60A2625
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=H20AB8pw
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MIENWR562104;
	Thu, 22 Oct 2026 19:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QtwtA+
	cN6AR7dndEV+fufW5y5cti1ZI2yNysmL/3n3Y=; b=H20AB8pw71wOh4h88Ht12L
	rmBL71iPA9TiBzcbE3sQBvdkhuN9LyH+TuJThguiWmYguS7M5viP8e/Z7VhiXieX
	6MrSh8p2zVay+UO/CJqSMdnEy3DqO6b4mZ39uQ/nj4M+9YE0aj96xQibMjFdtd/z
	+yNvpHdpV591XcTyP4CvReOHCyg6W8zWwDrjGlIBnH5uqmGGsA/m1P8Xcfp/Y9VX
	j8rO5yyt3SLf9V0bQ8MFao9DzRxpoXQvAvoFsTFcaFf5x1N9lMv73IbQd3EKsU+w
	X/DPd87xKhFXrAih6lu4DG+U+sZyhtr84tFbedGa8T30H56shMXT+ofFCDCQrM2g
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5b0r11-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 19:37:50 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69MI55ct823797;
	Thu, 22 Oct 2026 19:37:49 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hfkg21cfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 19:37:49 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69MJbmE627722380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Oct 2026 19:37:48 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A56755803F;
	Thu, 22 Oct 2026 19:37:48 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A790758056;
	Thu, 22 Oct 2026 19:37:46 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.77.162.217])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 Oct 2026 19:37:46 +0000 (GMT)
Message-ID: <d3274fc7bea368e7e117fdffcff2193210d9d8b7.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: Mimi Zohar <zohar@linux.ibm.com>
To: Jason Gunthorpe <jgg@nvidia.com>,
        James Bottomley
	 <James.Bottomley@hansenpartnership.com>
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
In-Reply-To: <20261022191911.GB3746973@nvidia.com>
References: 
	<CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
	 <atX9fugGUsI0hGcA@FV6GYCPJ69>
	 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <20261019225658.GS13920@nvidia.com> <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
	 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
	 <20261021143529.GP3008132@nvidia.com>
	 <95b895522bb314187ac1cdc5d0c143c01f0705a9.camel@HansenPartnership.com>
	 <20261022131141.GD3008132@nvidia.com>
	 <db0f90dde6421c3f2ca0164ea042e73d13b4d02b.camel@HansenPartnership.com>
	 <20261022191911.GB3746973@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:37:46 -0400
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
X-Authority-Analysis: v=2.4 cv=X63Hu2Te c=1 sm=1 tr=0 ts=6ada660e cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=7DVriy0AQeK61SD6co0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 4dOH7DFKI6sPzQZqWHpHSTZa9cjkIkS0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA3NiBTYWx0ZWRfX5g2U0Hsnv8Gk
 qcRPZR1O2zwY+LkVQcBok2CEIut9GwwmDsrA7JUrRVXPY6Vv/PajUbBi/TqjUY1xDjTmG9wpswJ
 A5EOr9jQtZlotkjgXZDmynez6dQ1d2YDG9py72Z7M6P/o9mwyAwQPrEIgeoOu/WxkffWdNIavcY
 9C3lBEJyxjf0RSkGvpVu86Rc5IXEb/tOPKdvMLyBLEw8ztXeLybyZpB2JRJsN5PyVrQ9eVJYJV8
 OBwr+cczAqH6MDQX6MLebrawz7zrZLcQqBbIRwm1Z2JlmRZJqLkbz/wJBpFgjpiNoHpqfjwnJ1J
 0A0XNTUf3Zk4df3rMA+9DpSso/f73dBb4RO/JJKtZTCANN1N6nAnlqRiRzhWzTXvJwoXabBwsUJ
 LJ7XJ/V682hS9cMxcp/ZbR/xlvka3thiRMS9FjUfpHjTcpoa1DPD1uMFc6TUTTpCrIl+qH+zqAU
 CnW+GzrVITAka1eWRdQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA3NiBTYWx0ZWRfXwUfRVnzb483+
 iZ+gzokD3CEZISLZ/8C60AS1ZPvPUSvmRe0OXgc9xeY6eijVzfaWuTtcWk2TZSGZxjqbt+b4YDg
 XbqZC1ormf+mHMvKb2n/l6Pc+MqqZLQ=
X-Proofpoint-GUID: x2_2POeeQj1Gszt9zEOTxfu-9XeMhXaM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0
 clxscore=1015 spamscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220076

On Thu, 2026-10-22 at 16:19 -0300, Jason Gunthorpe wrote:
> On Thu, Oct 22, 2026 at 10:07:33AM -0400, James Bottomley wrote:
> > On Thu, 2026-10-22 at 10:11 -0300, Jason Gunthorpe wrote:
> > > On Thu, Oct 22, 2026 at 08:26:29AM -0400, James Bottomley wrote:
> > > > On Wed, 2026-10-21 at 11:35 -0300, Jason Gunthorpe wrote:
> > > > > Maybe we can build a multiplexed scheme on the spare? I don't
> > > > > know.
> > > >=20
> > > > Direct sharing of PCRs is certainly possible, but not in all
> > > > circumstances. To share a log, each logging entity must record
> > > > entries in such a way that the relying party can disentangle them
> > > > with absolute certainty.=C2=A0 The problem with the latter is that =
both
> > > > the TCG and the IMA log format have unmeasured (or advisory) log
> > > > entries.=C2=A0 You can fool a relying party trying to disentangle a
> > > > combined log simply by converting the advisory entry of one logging
> > > > entity to being the advisory entry of another and bingo, it
> > > > disappears from the other log.
> > >=20
> > > My understanding was the unmeasured entries exist only to help the
> > > verifier understand the log structure, and what data is in the
> > > log. Like you might record a firmware version so that the verifier
> > > can locate the reference measurement.
> > >=20
> > > If they are corrupted somehow then the verifier should fail to
> > > understand or reconstruct the log and fail the verification.=20
> >=20
> > That's true, but only if you know the entire log consists of your
> > measurements.  Because you know, ipso facto, that you should be able to
> > understand them all.
>=20
> Yes, you cannot start processing any log entries whatsoever until they
> have been verified by the Merkle tree calculations.
>=20
> With a shared PCR the Merkle validation would have to be done in one
> pass, with knowledge of how to put together all the shared logs.
>=20
> For example, if we imagine a scheme where we create vPCRs then every
> vPCR extend could have a common log bound to a RTMR of
> something like:
>  {extend vPCR #10 to hash XYZ}
>=20
> The first verifier pass evaluates this log, confirms its merkle is OK
> and ends up with current values for all the vPCRs. Then the individual
> logs associated with the vPCR are merkled up just like a real TPM
> would have done.
>=20
> Advisory entries shouldn't matter with a scheme like this.

IMA has something called violations (e.g. open-writers, ToMToU), which are =
more
than just advisory.  They intentionally invalidate the IMA measurement list
since the measurement cannot be trusted.

Walking the list containing violations will fail.

Mimi

>=20
> There are other ways to do this, but the general notion requires that
> the log entries are, in some way, self describing so anyone can do the
> Merkle calculation for them.
>=20
> It doesn't work for sealing, but for remote verification systems it
> seems like it might be something interesting for userspace to do?
>=20
> Jason
