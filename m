Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795171872;
	b=d+R+lumS9HXkkRrilMHTLrgjTwHSc91xoevpFaSwoN7fLZ1ErmIWs2+2RKEspc/sWG26
	 +CBFgkwng/60JSPon8fSd45IKGHr9QwAfG6RMlGT4N6dSboBey/h06ufmOzh2id7r4J3L
	 hUxZGSQiUjODPAUW8T5GRTzaeYGFpeCDVo5hRYx+PCALMSabyou/hOG2/22kfHFriwLJB
	 xx1C8zFGUsVdQt1tTVYzAPM4nzMSDah844LBGmD0eRjsgegVwRlFnw/Lrgv0p0WjtZo8v
	 rp2U2XZfefmK/v8wd1RTLrrGuyjCYdEU2vxazeStYOKw2TLdBo3b7XKg5yI0VjcpjBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795171872;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date:
	 MIME-Version:User-Agent:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=ub6uVwbshCbu/GNhE2f5A/6m7aPhZB0osZVqaeuTvHA=;
	b=EkOs9DcsBMc/uAsTyMp0Xnpuaq77cLYnmUiImhIlHUfbKuGqCmnyX/GyGUJsXG2emo3g
	 uJtHQx4TVp5VI4LbyZuPztwa60LNcZlOR9GwbAmdPteHQtq+i1MQvBlxM8cmzvdIgdA5D
	 BltB2VSusXLoHDyFrr66pQYazhXb+Xdgv4WJgiHB1qHwGBMop0WVra9Lpn7Jw7qMRjAcM
	 6owasXlTiqmw87Rk0kOBwVAqy08sUsWIR2HmqCLg3jsYCdhfRHqhuYGawraLhHC1imHhO
	 qytwtcxTV+j5nJ8C0hJ1Bv5h7XegBxxa7UjHYgOVvYu8V8sfrmCkRDS7jV1TOmwzeQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=AkpBTIWH;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7DA60A2600;
	Fri, 20 Nov 2026 10:51:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB7DA60A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=AkpBTIWH
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK7uZLn1291381;
	Fri, 20 Nov 2026 10:50:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ub6uVw
	bshCbu/GNhE2f5A/6m7aPhZB0osZVqaeuTvHA=; b=AkpBTIWHXdaJDlfwXZ0Q65
	SGgBmHzgPL7BPqJk7e1PE9FxYyrNktKftH2jhXZUTKnL+woWuSucYrnvHGbRXUeP
	VNXsNJCJ59aUUKEk0Y7XlVm1TF1YBfXd+vm0rSXuo/ZZ1oWonLl5pMfMV6d3mSqH
	8xV8VhC4pJeo3Uuog/rwMrjK1OfLhnEkZJk6itxZndNVftAWUqFxIIYhllOi92RO
	8cQWu6OfsB3OtysHKd03MvUTdX5LZ7fumH9aI2wDTcWnBtCh/2Yckb+KHmZuA7wl
	DLEQlYmeJyaxx++rZ0uQYwTOKl+671IQS3+F1j8QpXHAvt+rMA+jrS1VFSgKruEw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105w7eey-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 10:50:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAo2G11031967;
	Fri, 20 Nov 2026 10:50:12 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j17c54cny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 10:50:12 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AKAoBop25428646
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 10:50:12 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B832358043;
	Fri, 20 Nov 2026 10:50:11 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 033135805D;
	Fri, 20 Nov 2026 10:50:10 +0000 (GMT)
Received: from li-43857255-d5e6-4659-90f1-fc5cee4750ad.ibm.com (unknown [9.61.105.144])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Nov 2026 10:50:09 +0000 (GMT)
Message-ID: <bff9077bad99a5b2c9137a44d98be8fd16be7b48.camel@linux.ibm.com>
Subject: Re: [PATCH v6 0/4] initramfs: add support for xattrs in the
 initial ram disk
From: Mimi Zohar <zohar@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>,
        Roberto Sassu
	 <roberto.sassu@huaweicloud.com>,
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
In-Reply-To: <20261117-makaber-paranoia-gefilde-7d976e97e12a@brauner>
References: <20261105193743.2654656-1-dannyhu@arista.com>
		 <20261110-hengst-tontechnik-ausfuhr-265b06d68611@brauner>
		 <a9edb8a433e8efcba3d11b2a06fa1063df41a24d.camel@huaweicloud.com>
		 <20261117-makaber-paranoia-gefilde-7d976e97e12a@brauner>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:49:03 -0500
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
X-Proofpoint-GUID: ZqdJIFsgCUKjEC8YYQnPbz-cnCueBzAq
X-Authority-Analysis: v=2.4 cv=Z8x5j3RA c=1 sm=1 tr=0 ts=6b0025e6 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=i0EeH86SAAAA:8 a=n2GhSfulAAAA:8 a=P9hg6L4mTtILJBKynr4A:9
 a=QEXdDO2ut3YA:10 a=9NqWk_7B-uqI6kdQTXIl:22
X-Proofpoint-ORIG-GUID: 5kOz6Gl1NjdF4oL33T-IpMiwaH8-ELgO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0MSBTYWx0ZWRfX+YHMuW6NnsUe
 86lQVCsuPp/NvRoxrnqRoc3bnDhG0hnemG/Y3xQRZx0puMuQb463PTCrFx4qgBvkTFzzXcVnUpU
 Xhqp+qerRq7eKUVdQ+GyReus0x+B+4I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0MSBTYWx0ZWRfX+0h3WbhtntiE
 XZdsdCmbDr9WEUPoksnezsPv31YninLxwWzklkMYjPZG0jLs8VSFPwSEOoUqxVahXgE3qk6DxFc
 mxjgcd0sniJf9dHzHI8V4l9MgpeYMD5qt6IB7AF57liGYDsPU7Fag8d59MKFbEsrebSlNuXJlDo
 tzsS2SvN5/+Ez0sVZsQKscPY7JgHn8nBzluswB4Olg/Ytel4wvA9udJuaL1K0eVVtH/blQ16kD4
 p68qnaj3yYFTGk8DhmwFtG8s3oXkABaKh8OC4NEdh8mrgr+3FnnUkThoz4c+qCaVQjMaXo8R6uF
 ZWuCKkKibbIdEhwE6yZ4llmWHFmmhZ1/CZpnsBnkOow2nkA9uiO5AGrrXjFUAGO2LRiXglBmcPs
 zjpodmzKyrEGQ3s6X8tKLqjMrm2Q6723CMdP/P6Bko0/SxdT8EtSbugWNbjSyRDHOC6Nonr0rrh
 w5BZ+8d2PaJl6+SxqhA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 adultscore=0 bulkscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200041

Hi Christian,

On Tue, 2026-11-17 at 15:04 +0100, Christian Brauner wrote:
> If you want xattrs in the initramfs then that needs to be a proper,
> versioned cpio format that userspace tooling understands. I'm not
> taking METADATA!!!. So still no, sorry.

Regarding your request for a versioned cpio format, that is the first appro=
ach
we tried. I posted an RFC extending newc with xattrs in January 2015 [1],
followed by a v1 later that month [2], after Al Viro advised extending cpio=
 at
the 2014 Kernel Summit. Taras Kondratiuk and Victor Kamensky carried the wo=
rk
forward in 2018 as "newcx" [3]. The discussion then turned to redesigning t=
he
format itself: ASCII fixed-width fields, no header length, the in-band
TRAILER!!! end marker, and whether to use pax/tar instead [4].

Roberto=E2=80=99s later series [5], carried forward by Danny Hu in v6 [6], =
aimed to
provide xattr support within the existing format, since the format discussi=
on
had stalled. It began with xattrs in separate files and later moved to a
metadata file placed after each file it describes, following review comment=
s
asking for self-contained per-file records that work when several initramfs
archives are loaded.

I wanted to share this background in case it=E2=80=99s useful to whoever ta=
kes on a new
versioned cpio format with xattr support.

Thanks,

Mimi

References:

[1] RFC, Jan 2015, extend initramfs archive format to support xattrs:
https://lore.kernel.org/all/1584934.WkKQGAFadF@sifl/T/
[2] v1, Jan 2015:
https://lore.kernel.org/lkml/1421781180-24425-1-git-send-email-zohar@linux.=
vnet.ibm.com/
[3] newcx v3, Feb 2018 (Taras Kondratiuk):
https://lore.kernel.org/all/1519153284.14218.18.camel@tycho.nsa.gov/t/
[4] Why cpio rather than tar:
https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs=
.rst
[5] v3, May 2019 (Roberto Sassu):
https://lore.kernel.org/lkml/20190517165519.11507-1-roberto.sassu@huawei.co=
m/
[6] v6, Nov 2026 (Danny Hu):
https://lore.kernel.org/linux-integrity/20261105193743.2654656-1-dannyhu@ar=
ista.com/
