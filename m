Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794422727;
	b=kVFduuHJ1E38eMEhVZS71DVZ2WnQXJoutndOooUwCcV9Nvjh9KvKaIvBJrT2AITeBWJn
	 l1Q+LfwOAbft22yzakyrRJqLIBwMsDGIwafXyAA876lL3NDHJLsXaw9J+e9Bu8MLhIX32
	 oLi+LgAnjuYoNg3offJ2W8+GnCaoedkjU+NEtUjKXjVJAyt+AlF2gJ42//pSM0eOC5MC1
	 YxU5e/w+fP2SVMuDgUPvf3ltDoFNc0dbRVdgQqUgKjjx4Yjn2vD7PWG0cBXk8tRs+AmoK
	 sHbYXP4ADgNtKXm4X5RQ2o+6d5wtW8ElCfi1A7m1F1k1Hvr144VKFF7eV0jrdc0hiQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422727;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=49MaCQym9slg1wd6k0otIRMRT27LbiHCT0+a1bCeTqo=;
	b=pV6p6S5jHf2qMnuB/PO7pUbCwC04jpLRIz2GXeZI5hIfQPNUbbMBQ+GRHuc0uwif+piX
	 i+uxv7O3cTHMQH1KAldyfpumUB2tOmVVZISUpB9jT/TjCFIXA6x+yg92miXm43M2yGe03
	 PrtHnETMxa+pED2awOKy2tXGYxjYd0cky9yNH9Kg+gA9qBjgS3Uyr3bNcn1+VemyefByY
	 U0YpXJon1oFnpXydrllDxbzPBmJth7qTaGAzUbSSkp6MN6K3iK4mocS0Zuh6uvzbPx6aX
	 BAlrN6reb9fB+RE2vH8Cb8EFR2558kf3bZCQEK/jvlMdOOM2Rax7pF2lrLp1wy+bT4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=A4ELrNMy;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1FD606A32D;
	Wed, 11 Nov 2026 18:45:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D1FD606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=A4ELrNMy
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABIiSvi672058;
	Wed, 11 Nov 2026 18:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=49MaCQ
	ym9slg1wd6k0otIRMRT27LbiHCT0+a1bCeTqo=; b=A4ELrNMySsqqi06Tj8LY/0
	DvvFAT6UPgCLbtdtzfJXgwwy6V0S+NEyHXU76mKcOPVtRO7KDwnhYUjjT3+7A3xm
	Yebgqh9q7BLWJOimyJFiS3d9bOw4py/3t4laHmE4e82pajRGlUCh7xfPo6LOGaig
	NHY2zs4QYPehcixAIt+ipmf0uVk3RLXmAdGMH7wR+0Ch/FfbFwmwYSdxJzW2lz+q
	Y4QIgTlIhRc2l47lgEHkv2mapSnoAH4G/ZZTgKY+8K4bpVTlvm1HBQUpHc91m+0d
	jkw3hWhWPF0EDjFvhhiP67XmssSn7gj7uq0RctRm3RFqlO1KbaRuibSzvrngYWkA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hstdgb4yu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 18:44:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABIJuDi3740537;
	Wed, 11 Nov 2026 18:44:46 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hvkq0t7mk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 18:44:46 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ABIijIs25625264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Nov 2026 18:44:45 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37C8858060;
	Wed, 11 Nov 2026 18:44:45 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9C4B5804E;
	Wed, 11 Nov 2026 18:44:42 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.123.17])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Nov 2026 18:44:42 +0000 (GMT)
Message-ID: <eb536f08b27ed28cf490205c57176b7fc8eccfda.camel@linux.ibm.com>
Subject: Re: [PATCH v6 0/4] initramfs: add support for xattrs in the
 initial ram disk
From: Mimi Zohar <zohar@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Christian Brauner
	 <brauner@kernel.org>,
        Danny Hu <dannyhu@arista.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Roberto Sassu	
 <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eric Snowberg <eric.snowberg@oracle.com>, Jan Kara <jack@suse.cz>,
        Victor
 Kamensky <kamensky@cisco.com>,
        Taras Kondratiuk <takondra@cisco.com>,
        Zheng Zengkai <zhengzengkai@huawei.com>,
        zhangguangzhi	
 <zhangguangzhi3@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, silviu.vlasceanu@huawei.com,
        hpa@zytor.com, arnd@arndb.de, james.w.mcmechan@gmail.com,
        niveditas98@gmail.com, pierre@arista.com, julien@arista.com,
        kbharathi@arista.com, alexandr.lobakin@intel.com,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org,
        initramfs@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, bug-cpio@gnu.org
In-Reply-To: <a9edb8a433e8efcba3d11b2a06fa1063df41a24d.camel@huaweicloud.com>
References: <20261105193743.2654656-1-dannyhu@arista.com>
		 <20261110-hengst-tontechnik-ausfuhr-265b06d68611@brauner>
	 <a9edb8a433e8efcba3d11b2a06fa1063df41a24d.camel@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:44:42 -0500
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
X-Authority-Analysis: v=2.4 cv=J+M/fwnS c=1 sm=1 tr=0 ts=6af4b79f cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=07d9gI8wAAAA:8
 a=VwQbUJbxAAAA:8 a=oGMlB6cnAAAA:8 a=vpqfxihKAAAA:8 a=pGLkceISAAAA:8
 a=meKO6n-CRK1YFxY-CrEA:9 a=QEXdDO2ut3YA:10 a=e2CUPOnPG4QKp8I52DXD:22
 a=NdAtdrkLVvyUPsUoGJp4:22 a=AULIiLoY-XQsE5F6gcqX:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3NCBTYWx0ZWRfX3gn636Rji0NZ
 iSazCfHd8HXcmr4d5jGXXmBYPn05xP83IXxhjJWgXtsiJj2XWUExmGRX/xv9PlqCaHRhCSn2SOe
 j5LtDKi4Rc8DcKEhpP7RcYKWeHaLZ0ecPaQ8gfSJzAT7t9Z4c6W09cS8Jett6BR4fKtlaHvEsgb
 b1kL1SWdkRTVnUBfBRk4HAhckbmQPg21AEdFu5zSOO0Tolp1QTigj02PbtGt/BZEgWn5EDMwyaP
 I6O70FNB873BNEHt0GcnX/O/5ve5Add6ywtZ83eG3LNqs5BwMhpDJCberDh+L/OEKvVGBrJ3m7x
 XIE7gZcvU2G8HXb/HD2OrKyoNo8kTVnYzNpH+nYk9yPJ9l+D5n1vU848ZwY+uhkUOuG1brxZss0
 zUaafrXUOy942LMCUgckXVQfA0yP4oRWn2lDFjYhj1fKI3hmcEdVr2Jaf1nyGSzMURDs2FwyCTv
 s9MeY++t5Ie4lIDFrZg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3NCBTYWx0ZWRfX/y+xAAh94onv
 cLdD7EEkkfO+pTmM/OFNa7h9sGBipx+EUhnDh76AIMXj6ABAP0oRIFN9yeuLUdU7tQbUudaImwI
 2JwPY1t126ZMmdL6vm9Xbbyj/BLK6vo=
X-Proofpoint-GUID: CTJhBYIyODsTvXA5TgxC6EstFdV3S_SH
X-Proofpoint-ORIG-GUID: VeWHy195uGzXlBEJaEaDPnLzgJqp5EgW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_05,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 clxscore=1011 priorityscore=1501 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110074

On Wed, 2026-11-11 at 14:45 +0100, Roberto Sassu wrote:
> On Tue, 2026-11-10 at 17:21 +0100, Christian Brauner wrote:
> > On Thu, Nov 05, 2026 at 11:37:39AM -0800, Danny Hu wrote:
> > > This proposal consists in including file metadata as additional files=
 named
> > > METADATA!!!, for each file added to the ram disk. The CPIO parser in =
the
> > > kernel recognizes these special files from the file name, and calls t=
he
> > > appropriate parser to add metadata to the previously extracted file.
> >=20
> > No, sorry. We're not going to do this:
> >=20
> > * This is in-band signalling by filename. A METADATA!!! entry changes
> >   the meaning of whatever came before it in the stream.
>=20
> Yes, it is a hack, but such an image is backward compatible with
> previous versions. There is no new format, version bump, etc.
>=20
> >   Which is just the TRAILER!!! nonsense all over again (cf. [1]).
> >   No cpio tool knows about it and a kernel without this parser silently
> >   extracts the metadata as junk files.
>=20
> METADATA!!! is stored in ramfs/tmpfs if not processed, so it is just a
> temporary file, like the rest of the initramfs content.
>=20
> > * It sets whatever xattrs the archive comes with through vfs_setxattr()
> >   during early boot. Which is insane.
>=20
> Similarly, the archive can already ship arbitrary binaries that get
> executed as root. If you want, we could restrict it to security.ima and
> security.evm only.
>=20
> >   Not just security.ima but security.capability, security.selinux,
> >   trusted.* and anything else.
> >=20
> >   And we've NAKed this before in 2018 (cf. [2]).
> >   The magic file name scheme was called a kludge back then too (cf. [3]=
).
> >   Nothing about that has changed.
> >=20
> > * The initrd is already covered as a whole. Appraising
> >   individual files inside an image whose integrity is plain weird.
>=20
> I agree when the image is prebuilt and has a known reference value. As
> far as I know, there is no reference value when the initial ram disk is
> dynamically generated on the host. In the latter case, using finer-
> granularity measurement/appraisal is the only option.
>=20
>=20
> > * If kernel and initrd are owned by different parties this can be
> >   done in userspace. A trusted /init can apply xattrs from a manifest
> >   before it runs anything else. That was pointed out in 2019 already
> >   (cf. [4], [5], [6]).
>=20
> Unless the trusted /init is in the kernel image and launched as User-
> Mode-Driver (UMD), you need to measure/appraise it, which again
> requires its signature to be carried in the initial ram disk.
>=20
>=20
> > This has been proposed in some form since 2018 and never found a
> > maintainer willing to take it. I'm not taking a private cpio extension
> > into init/initramfs.c either.
>=20
> I understand. v3 was close to being upstreamed but then got stuck
> because nobody was willing to take it, despite all review comments
> being addressed. In its favor, this extension is harmless. If
> METADATA!!! is not there, nothing happens. If it is there and not
> supported, it is a junk file removed together with the rest of the
> initramfs content.

At the time, there was no initramfs maintainer.  At LSF/MM 2018, I brought =
it up
[1]. AL said he wasn't the maintainer (and if I touched it, I would become =
the
de facto maintainer).                                        =20
                                                                           =
    =20
[1] https://lwn.net/Articles/753276/

Mimi

> > [1]: https://lore.kernel.org/r/d69f329c-8365-bb0e-69ee-774cbea141b2@zyt=
or.com
> > [2]: https://lore.kernel.org/r/3d1bfbd7-7d45-4cf1-32d6-7f6985b42393@sch=
aufler-ca.com
> > [3]: https://lore.kernel.org/r/f2886ac7-aff9-94bc-5f65-b3b2e946a6ff@sch=
aufler-ca.com
> > [4]: https://lore.kernel.org/r/20190512091748.s6fvy2f5p2a2o6ja@isilmar-=
4.linta.de
> > [5]: https://lore.kernel.org/r/20190512194322.GA71658@rani.riverdale.la=
n
> > [6]: https://lore.kernel.org/r/CALCETrV3b205L38xqPr6QqwGn6-vxQdPoJGUygJ=
JpgM-JqqXfQ@mail.gmail.com
> >=20
>=20
