Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792592290;
	b=hvd8r73OtiWAzG8kKiSj+vIuPdpL5cuD5InU34qxzv8H55zq/S2CgizlE2Naycopjb3V
	 c0dBlwNdrPvB/VlatNVDi+vWbsofJRzsk79+36taXDXOXwjHld3Rk7tlh/6P3Lg9XmzsV
	 0SEDuyZ2Xbeszl69nJUhvBuASvAEIYW9VeQQo+POAfJ0NUypDDgzW0lBGnC8rgE/VUpjA
	 dswpBRwinWrX+zhzcsr6x1+yUOfv3isxHCRvLjuwqC2GmUOyrSx1ahYo048oTG4cwO/Rl
	 bjSEGc/0hZ30vM4Mjr1bHZn02UWdE2WLsaAbYqMKLk5ff0HqlFC7XCE/88QYrNw2H/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792592290;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=cnH4/UglkdApjtk0d5fzERvfXq1GFWAaonQ1KuOAbdo=;
	b=Z2ljRmdHtKijgpsznYB9aRtlaQNxs354bw0rpEK3cHNGiqtmVuWSLWRkJ4w0HATTL50S
	 qoSxwo+0MMbhAMf3ZXIT43Iil/PkbVi2zeJto990N2/+hHKu68vj0M0v9LE1rNGrUIHS7
	 3w5tyLZJN2zUCamW+uUpZrykH8rarjvp/LUbQHY2Hl+1vdXZNmJYqg+eegLYQU/CprMOn
	 C1YKruhFRygX2mfI9HDEApbJ/grk6UpNg9SRig3ExLKeHsYMeAWBw8R/5WYf0nnUbAWNV
	 eWtehlSsn55RpHj/xCEFXRV854g1cJTw+5FFibr/G3r3dLbIhJG1k5VB4DpSMLUnngw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=qhW5x91i;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBEB606A31B;
	Wed, 21 Oct 2026 14:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CBEB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=qhW5x91i
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LBihF51092707;
	Wed, 21 Oct 2026 14:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cnH4/U
	glkdApjtk0d5fzERvfXq1GFWAaonQ1KuOAbdo=; b=qhW5x91iY0WcrC4VhMH7wY
	UiUJeTBnhY7wQuXzCwK3l/Nb0EUt+eo2c6uDEViJEoGJ8rPEXUZCGHIQHOYR836J
	HPwKAkPYHsicNmDvQtGIWu2j7lrHBPJVJjpDUN8easUY+UJqZ4k5TwRC9vnJ6emA
	LxA1CNB3DYbImERT54Mgbp3S/N9tXhwDEpTRQX9S+LAiXMO0yzfNP6yfjmlswbMl
	202j9tcdwffOt13m8EhpqPji19G0tS5+RoRuU7oi9bwgZDPHPIZIp5OM7LobsDOo
	kGSdDpJUBI+qKZMkt8wLyIpirLhE6dIKtuLu9kVstJoqAV94CCuyGykbU/nZMIYA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5a17ge-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 14:12:41 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69LBntBV3044442;
	Wed, 21 Oct 2026 14:12:38 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4he6gqdqyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 14:12:38 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69LECbLm13238930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 14:12:38 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB3CE58043;
	Wed, 21 Oct 2026 14:12:37 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F23B25805F;
	Wed, 21 Oct 2026 14:12:34 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.75.7])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 Oct 2026 14:12:34 +0000 (GMT)
Message-ID: <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: Mimi Zohar <zohar@linux.ibm.com>
To: Jiri Pirko <jiri@resnulli.us>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Dionna Glaze <drdeeglaze@gmail.com>, Jarkko Sakkinen
 <jarkko@kernel.org>,
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
In-Reply-To: <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	 <20261016234354.GA664420@nvidia.com>
	 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
	 <20261017203407.GM13920@nvidia.com> <atPgqROZZxnihYfC@kernel.org>
	 <20261017231007.GP13920@nvidia.com>
	 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
	 <atX9fugGUsI0hGcA@FV6GYCPJ69>
	 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <20261019225658.GS13920@nvidia.com> <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 10:12:34 -0400
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA1NCBTYWx0ZWRfXyoLKXsE16f7S
 WYqfJ5PPmkKwK9Vp0gZYpl8AEBTvuMatXtkRV9GrEFuYrsGP2dbsrqQLfZoyUOCYnAvXTO6g8tZ
 XiXjPY0ULc8v2b12cfx15jLrjpPPBzw1OBlFPb5i8uWnFSEjYQqwd8UypGmj3bDg8vPrl3VMXE8
 FbLm14si0ey/ey0lf86nNmWZ9SeKtN2PvwSiGjBTM1g0KoO6UAnIhqWnqhpikmnKpf87yGisb3F
 WkywgdoX3nqwBDkqY5j+7gnGGV9Ccnsvo/ryAGSebnKzRsTd3MHCqOBE15bxUPmWrQk5+NuhAd4
 peORg1G4FsDwI/90QBCeoPYdeFIBCeKuWCDot/hZ0r85Lmyn9fbSUWn+vZQuINyBLFyYE3A/Xfc
 k3j1TE2zGo0bsTdXSBWzxbxuroigkQWNfV/TKZu3BqooROEvm8ixUVX9Qy9+pT54PFA93c/LDfA
 MG68XircKXjLCjGxIzA==
X-Proofpoint-ORIG-GUID: r5LW5he_5nLfSlQ9QHxHuRJZxO92cH8M
X-Proofpoint-GUID: 431ewJp-P3UlLZkP6gfIqHy4gP_dwtnw
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA1NCBTYWx0ZWRfX+03hT/IpVZaZ
 KtoVklMkmjj8YwN4PnHYPkhsdgkKzy8mo1yW8tMK5tAQAeCa0cq+ogQcrWui4trYkoGRNqHCICE
 RtyRBtSxb+UOHPbZpykQuv/OmHA5mD8=
X-Authority-Analysis: v=2.4 cv=ZfSIpcVA c=1 sm=1 tr=0 ts=6ad8c859 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=vnREMb7VAAAA:8
 a=Ikd4Dj_1AAAA:8 a=wp3Z-KoLcTzOWeoiLfgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210054

On Wed, 2026-10-21 at 10:33 +0200, Jiri Pirko wrote:
> Tue, Oct 20, 2026 at 12:56:58AM +0200, jgg@nvidia.com wrote:
> > On Mon, Oct 19, 2026 at 09:10:31AM -0700, Dionna Glaze wrote:
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
> > > IMA logs and systemd logs are both system level concerns that are
> > > relevant to the OS construction, not individual users,
> > > so I would just say to reroute IMA to use ctlv using a kernel config
> > > setting, then make systemd the new system manager of the holistic log=
.
> > > The securityfs log contents can simply say, "log managed by ctlv" in
> > > this setting, in the form of the template identifier.
> > > For policy violations, only the 0... extend needs to go to ctlv.
> > > IMA can still keep its violation log as a ring buffer when it's not a
> > > 1-to-1 violation to extension
> > > https://www.youtube.com/watch?v=3DgyYUYbdiN_4
> >=20
> > I think for now we should not include a new dynamic log here, the uAPI
> > around this Jiri drafted can remain a future step. I don't want to
> > open complicated discussions about new functionality at this
> > stage. The whole CTLV idea in general is a big enough thing to bite
> > off for this series.
>=20
> Okay, dropping the log from this set.

Thank you.  Please keep in mind going forward, that the scarce hardware reg=
ister
limitation (like the 4 TDX RTMRs) should be resolved (e.g. by multiplexing =
the
extension path), not by combining distinct measurement lists.

Mimi
