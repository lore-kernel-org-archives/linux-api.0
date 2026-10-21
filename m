Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792585411;
	b=I7LV0mz+YvxhEe/06jv84rKOKVnllxkCYujY9Ydz2Pn/WYKbzpSXrRE/x+TVcd4vWJg4
	 D5iXw7Vz8oUGsUV2yC5v9+oZaWGGeSQS898cQ9XyrXao2eX0LUdH+DL9QjjvnPB3xQKNI
	 7X5SrcUzlJ3jGPIQnrvelPWw71v0np1hivLCJ0iBZmtgbm9wb2ia7mu1FQijXIvBENhvW
	 q7P29n3o+lW+lSwoaF7puVKZQYSKIZ1hRALN1age7NmO79V07Iq7QQVR4b8skwg/5TcS+
	 +uxFu2U6UuS5DHnw7MW3u/EZoemn+W0JilSqLZRoK8LE6+s7YdiEYh4cpSkEqTzc0nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792585411;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Y13Y29MlvPb+Sz8PtQpD10VqqMQo4I4AAm9Usigt760=;
	b=KkIVAXAPA/I1DxfEUGcVx8+qyfmxmSbxqulSL4irWDT9gNdQu0kSSgCZOsTlbtoFpBkr
	 yhdmYTl8Z6T9aIUrudYsLLwTAyN5tTJHVoFlkrBWdGSmz9kj3kPi1Vv1Kk1fwZ/tD0i80
	 +WLezS3W0mUbzKjFk53CghDISPxikxbojvqN6YtIjXB/opUQS76tJyltooS8u79zwd/cy
	 9wtz/Ze2mBg4wkvAnhK+qRWer+kTQWUDdU4LOj5yQQHx3C5/gs4AFvzp65ECh1e8+1hui
	 WGtUT//uSLq1bhqZyGT+oWvN1tVigkDhPc66txsXBhE2m/ogwN4MU2gpQdW2Sr+DBPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gz6qW5ni;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8DC606A319;
	Wed, 21 Oct 2026 12:23:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E8DC606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gz6qW5ni
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LBiUUu3586175;
	Wed, 21 Oct 2026 12:23:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Y13Y29
	MlvPb+Sz8PtQpD10VqqMQo4I4AAm9Usigt760=; b=gz6qW5niygx0BGa9HyQCMg
	pXAIZ5o7xaEk4fCGCPn3N3CHwuGoJgvYnq7E0/qYhkcR4S7HoHF8QRmHa8v34hu9
	9w80wPp3J4RXuneQO1i/+8tfaPm+gGLWctDK0RjSXk24EvZIAA40N+OMihRYP/XP
	8T2rHnwXkj1l/See8nWM7lBcnQoyvY7OCwqm5aVLhL6U85pHOW2ePOrHVjE+9gzl
	mGHsVhAw5/nlcsOiD+KKVRR8KcjT1vCkJyBlwRD1n9PD+d7KppiZHh8TrbbwoIGL
	K09eWWtRYXYzF5Mar6g+L4Gttn7/V3x7wWxRzkJLXlmbuBbrCFH4d5QmI/H1R3MQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5bgwnt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 12:23:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69LBo3X83085758;
	Wed, 21 Oct 2026 12:23:09 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4he8vhvrqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 12:23:09 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69LCN9wh31392054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 12:23:09 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B7B858052;
	Wed, 21 Oct 2026 12:23:09 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C4E85805E;
	Wed, 21 Oct 2026 12:23:06 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.75.7])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 Oct 2026 12:23:06 +0000 (GMT)
Message-ID: <ae372ed03da3cd2d57c922850b3b017bcb83ca07.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
From: Mimi Zohar <zohar@linux.ibm.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Yeoreum Yun <yeoreum.yun@arm.com>
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
In-Reply-To: <20261020165251.GG3008132@nvidia.com>
References: <20261017203407.GM13920@nvidia.com>
	 <atPgqROZZxnihYfC@kernel.org> <20261017231007.GP13920@nvidia.com>
	 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
	 <atX9fugGUsI0hGcA@FV6GYCPJ69>
	 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
	 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
	 <20261020140655.GV13920@nvidia.com>
	 <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>
	 <ateSly15N5mLrM1m@e129823.arm.com> <20261020165251.GG3008132@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 08:23:05 -0400
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
X-Proofpoint-GUID: mhtBMVDnWVjSRXEgOMejCaHGMznMmbKb
X-Proofpoint-ORIG-GUID: OUxN-Ps5evmI7ZsRjJ6xHIT22ql-EQ4i
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0OCBTYWx0ZWRfX+CWHnOcamU9V
 6wooUZV+3CIKlZ4J+mDp4FpdF8mv26EXt3BOHZl4D9t0tXnWhOTHI6goE6CozgGJ/jqXkTSI4LV
 1rzuD11nfRdVSr1iBuCgJhHa5t+Y1lo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0OCBTYWx0ZWRfXxIYt7aeXQXMm
 0t3e5tygzLhvMtq3+HdivM94KbY7kfR/sMUk0QZ5w75cMQ3/mH+JFUfu3sypGoHs1E56y5CgSrd
 xvINpBkCJ9nEGxHi+/rZ5j5BI7vVDNYbcUr3Q5GCPS8LxlK4mEpNwXVgOl7CPFP2YW1mVFdAaha
 NZeF3Vc7AsUiDjA+DdWil4teRMpTJ7Z6PDEcgCUkYsiI/0nYhb64nbfr7rNNYep19I233f9u6gk
 FUicF62doDzjy9MN+TIpHFY6+Z/4Y4rGsUYwTBdiWAg6ic9Hn0ovuRQGvUgaBXndg9Zqnfk/ZHU
 HeKUnIcrC78dX53qOiAAe7+LmW1/Zwjabi8VNhDpr0HDwW3W5QSksWNV5EAThuiX9qee2yfsi41
 WRfSr9tSfRa+unODmydO3rXvzTM5wCK1QqwSlR+qzehQby2zOX7Eh1hwGNgYpz7qHBy9nNpMeeh
 jXlHyesR74dNx5W4enA==
X-Authority-Analysis: v=2.4 cv=Gb2CDgXL c=1 sm=1 tr=0 ts=6ad8aeaf cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=YAVQozInYYzzJe9E9cgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210048

On Tue, 2026-10-20 at 13:52 -0300, Jason Gunthorpe wrote:
> On Tue, Oct 20, 2026 at 05:11:03PM +0100, Yeoreum Yun wrote:
> > But, I have a related concern about deferred probing of RoT devices.
> >=20
> > For example, if TPM probing is deferred until after the attestation
> > subsystem has been initialized, how would the subsystem handle the
> > TPM becoming available later (This is reason for
> > IMA_INIT_LATE_SYNC).

FYI, this patch set initializes at module_initcall(), not even late_initcal=
l().

> I don't think it would be any different, the mechanism for TPM would
> become generalized and apply to any attestation driver.
>=20
> This series doesn't attempt to do that flow yet, moving ima over and
> dealing with this is another series :)

When TPM device initialization is deferred, it is retried during
late_initcall().

As there is no way of ordering within an initcall level, there is a race be=
tween
the device driver probing and the call to late_initcall(). The solution was=
 to
allow IMA to register at late_initcall_sync() based on a Kconfig.

Both device_initcall() and module_initcall() are at level 6. Are you sure:
=E2=80=A2 the PCIe SPDM Devices will be ready at module_initcall()?
=E2=80=A2 the PCIe SPDM Devices are not deferred to late_initcall()?

Mimi
