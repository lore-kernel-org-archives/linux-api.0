Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795428720;
	b=NhhIct0Rn5m9lqwkFbXC0D/wN0VE5cRB8SG88TMeeKnhCokTlAQlgwCeTZV0JlcP8+f1
	 hAJjm10XsWAMNjzOoG3CiXEyINlxC+iFnt5JXP552KBDdvK+YCGeYDUgKzbYoX/7qeEvX
	 a1ai9OiaMnJpLqe+hzigWsHUiiBDFTkjKYlSRifLHu3BByeg64fYFIzPfBZBEnCUNUEfN
	 OACO71E1Lv3zHUpOu7n+vpC/oIc8coIdJDLJZ/7tNh1uN8+oMW78v7+kzRvs4NGz1VR72
	 2dZpPGYwO6XOk2t2mhyCOZWCCylXLD6kyE3NsAdtcMsPmTNTs90wjzADZofL54U9HXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795428720;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:Date:MIME-Version:User-Agent:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=2snuaHCf1ced3ZKcOLzPklCct0WrnW+pIXLZNFNgR0g=;
	b=Jb4XRoGZIMPm9QvScb1LjuVPcXbrhYqJYcC6POJJ8aLME8zbBFCetEciN6Da7vriLmMY
	 q/C79eH8Jg/LC88sFBFB0Hl3I431pISHp9uXEPQj1eHdp/+uT6n3l5KSQGC0y2To/Z3Fx
	 uIkcuzY106szpbRt0l6KfRIl4/kKiknZsqliYcCwfwhUTnfT3jxvw16KevkT2dze3OP0m
	 Xv343/ahh2SuEcdXrnR+fdzAApffAH/q7+EIfjg7euzXosKfEZBIXjs/9yzpCdkBXawiF
	 vvhGL5RTTx1mhuCwswtlWqi1bfvc3sntvguZJDyRbF9YzyEKA5AumY+e95SAAXOVTbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=qZeMY5N8;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077C1606A31F;
	Mon, 23 Nov 2026 10:11:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 077C1606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=qZeMY5N8
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AN9ZR6F1603637;
	Mon, 23 Nov 2026 10:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2snuaH
	Cf1ced3ZKcOLzPklCct0WrnW+pIXLZNFNgR0g=; b=qZeMY5N8IsLbhZxLNNTnPn
	zrukWbf9ynh54WOK9bRXhxGoG0zFvnrjzj35tqdh1TjJY0r8LGKZU2z8AH+d3c+b
	hmEFCp5VNW4FBBpwPErrLNxj0aktXwD11NF4zCyxAX0XxNRLugr1+H3BWoR/S0/u
	75Lhh66vaTxYE6oHew2u/4MztrSP9qPDucHFeqZkrRB27f+cLHGb1LEw4aKtVmlP
	H0dURSVf8URxndmV8GBY1qYKaBLJjDhFVyrkbCBIj5uaKpv0UOEf3AFpGcuVIX97
	7dJ2SrFLP5w15rfj+ud/pdG2xcmaPRQ8QV3YW7moe1JCiR1CjpHsZewNo/JTmo6Q
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g32jru-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 23 Nov 2026 10:10:52 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AN9JeFg2759046;
	Mon, 23 Nov 2026 10:10:51 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j3q4h675h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Nov 2026 10:10:51 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ANAA0Su29229686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Nov 2026 10:10:00 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13BA55805E;
	Mon, 23 Nov 2026 10:10:51 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2901F5805A;
	Mon, 23 Nov 2026 10:10:42 +0000 (GMT)
Received: from [9.111.1.66] (unknown [9.111.1.66])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Nov 2026 10:10:41 +0000 (GMT)
Message-ID: <1f10002ea9ee16a17087bd06e4a1685a973fdf6e.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Luigi Rizzo <lrizzo@google.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand	
 <david@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka	
 <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon
 <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski
 <m.szyprowski@samsung.com>,
        Jens Axboe <axboe@kernel.dk>,
        "David S .
 Miller"	 <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub
 Kicinski	 <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo	
 <rizzo.unipi@gmail.com>,
        Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R .
 Howlett"	 <liam@infradead.org>,
        Mike Rapoport <rppt@kernel.org>,
        Suren
 Baghdasaryan	 <surenb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Brendan
 Jackman	 <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
        Harry Yoo
 <harry@kernel.org>, Christoph Lameter	 <cl@gentwo.org>,
        David Rientjes
 <rientjes@google.com>,
        Roman Gushchin	 <roman.gushchin@linux.dev>, Hao Li
 <hao.li@linux.dev>,
        Matthew Wilcox	 <willy@infradead.org>, Jan Kara
 <jack@suse.cz>,
        Jann Horn <jannh@google.com>,
        Catalin Marinas
 <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki"	 <rafael@kernel.org>,
        Danilo Krummrich
 <dakr@kernel.org>, Jonathan Corbet	 <corbet@lwn.net>,
        Simon Horman
 <horms@kernel.org>,
        Jesper Dangaard Brouer	 <hawk@kernel.org>,
        Ilias
 Apalodimas <ilias.apalodimas@linaro.org>,
        Willem de Bruijn
 <willemb@google.com>,
        Kuniyuki Iwashima <kuniyu@google.com>,
        Joshua
 Washington	 <joshwash@google.com>,
        Harshitha Ramamurthy
 <hramamurthy@google.com>,
        Alexander Lobakin
 <aleksander.lobakin@intel.com>,
        Christoph Hellwig <hch@lst.de>, Dragos
 Tatulea <dtatulea@nvidia.com>,
        Naman Gulati <namangulati@google.com>,
        Pranjal Shrivastava <praan@google.com>,
        Mostafa Saleh	
 <smostafa@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
        iommu@lists.linux.dev, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
	 <20261120010655.467825-1-lrizzo@google.com>
	 <20261120135013.GO3115493@ziepe.ca>
	 <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 11:09:40 +0100
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=SoQFe/O0 c=1 sm=1 tr=0 ts=6b04112d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=9jRdOu3wAAAA:8
 a=HXTMhFcmDb5UjnNm18QA:9 a=QEXdDO2ut3YA:10 a=ZE6KLimJVUuLrTuGpvhn:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDA0MCBTYWx0ZWRfX+SnUpKBhpNxt
 6ltTAuPh+dSZqgYKHq2EXRW6JLOXkC9bKqTXzOMLsW4XQjFY6ICqrLo1eTubFi7+T30qb9yK/Sq
 g1x/8GS5VQC+luYkfurSA9hBn0vrob8=
X-Proofpoint-ORIG-GUID: g4YrXK8XHnOLs6hMgSbVa0siPTgmA4y1
X-Proofpoint-GUID: COYrNUVwdZNscqeoFw9r-VC7XEpM8jcb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDA0MCBTYWx0ZWRfX221TJUFwr82H
 r3mUgrbkS3uy4QqsIJGhCohR3l6xECTkhKk2B/N+op9eDonLFxwOFN0BdaUaIXtTpXOUZet8yjN
 aQlwwBmgQtA65yL9mninHDLTSLbJu4ItKtAXWNMNxzzqty4zhE/M4TSxo96726kPTyeUU6ftpwy
 nMPPh4y+F0eTHqjEmxDqB/W+qR7NxyImWAm9TD2IUIquUft3bkDpuLb0y6KBbY2D/Z3udRSkp5M
 b9WJVFEzVvGYZohAzenyKN2CvdIWAVHV/ZiWNJcAMXZvh6xJ0rBHnZWP3x4W3UuDHE6P8UNcZwa
 hy+ETYikMLYo1Q6uFj+WQpJ+nZYJywIs9NZmsfo/gl5fTKDa/fZeQJ0BItRWk4w3+zIRFz+E1VC
 e/nL6Pxj4e61wP1HQ9jbJ0vXal7SsOq9rUnB0y6Dst6TB8/6U0fvmd7OFSp9F5EGScS3L+ocPeG
 uHgw66vM79lVBe3iOHw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_02,2026-11-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611230040

On Fri, 2026-11-20 at 15:19 +0100, Luigi Rizzo wrote:
> On Fri, Nov 20, 2026 at 2:50=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wr=
ote:
> >=20
> > On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> > > This is v3 of the RFC previously posted as DMA_PMD [0], now renamed P=
ISA
> > > ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> > > Documentation/core-api/pisa.rst (patch 25/25), which has the details.
> >=20
> > I thought the conclusion was to just do this stuff in netdev pagepool,
> > now you come with an enormous AI series spread across the entire
> > kernel?
>=20
> There were surely comments claiming nothing outside net/ cares or needs t=
his.
>=20
> I respectfully disagree, witness is the fact that e.g. there was already =
an
> io_uring proposal which is smaller, but does not address applications
> that want to use the standard disk I/O paths (libaio, buffer cache etc)
>=20
> Nothing has changed from the initial series in terms of size, use cases o=
r
> subsystems involved. Large files are placed where they should,
> the series covers the same three use cases (disk, network, CoCo), and
> touches three parts which it has to touch: mm (most of it; it is a
> memory allocator
> extension after all), dma (it hooks into map and unmap, not a large chang=
e)
> and net (the pagepool change is a couple of lines; the tx path needs to
> touch more places because the current stack assumes all paths have
> the same I/O requirements).
>=20
> For CoCo, there are very fine grained controls so the bounce buffers
> can be enabled only when they don't pose a risk, which in turn
> depends on the threat model.
>=20
> Specifically, for network tx buffers or disk writes, the user-to-kernel c=
opy
> is basically a bounce buffer provided it is used correctly and not leaked
> elsewhere (which is the design; of course the implementation
> needs to be verified and possibly fixed so that it matches the design).
>=20
> cheers
> luigi

Hi Luigi, Hi Jason,

I've been lurking but following this series since the start. I am torn.
On s390 where the IOMMU is always enabled on our closest equivalent to
bare metal (non paging LPAR hypervisor), and where we also default to
an emulated IOMMU in KVM guests, the underlying problem is a real pain.
We're also in the process of enabling large IOMMU mappings via the
generic_pt API which are 1M and 2G on s390. So, the idea of making
better use of larger mappings is very attractive to us and I applaud
you for trying to tackle this very real issue.

That said I do have to agree with the critique. This series is too
invasive, too unclear in its layering, and most importantly it feels
like you're trying to do everything in a big swoop ignoring advice from
the maintainers just because it would limit the scope of a first step.

I also don't think Jason's point is that nothing outside net/ cares, I
think, it's rather that the IOMMU and DMA layers already offer the
tools and each subsystem needs to use the right combination for its
specific requirements. And if a tool is missing this needs to be stated
very precisely including how the addition keeps layering intact.

I don't claim to have a simple solution to offer, if I did I would have
sent patches already, but let me state my thoughts. First I think this
really needs an iterative approach with much smaller self contained
steps and focus on specific issues. With that, I think this should
focus on the network stack, while the io_uring specific proposal can go
after the block layer. Also in my experience networking is where this
hurts most.

Now, I wonder if we can't start with something simple. What if the page
pool could start by allocating in batches of PMD sized and aligned
folios of contiguous pages that can share a single large IOMMU
translation. The page pool can then still hand out pages from that
batch without having to do sub-page allocation but would already use
much fewer IOTLB entries and the locality might even help non IOMMU
workloads.=C2=A0So, I'd even hope this could be enabled by default and this
is actually something I don't like about this series, I really don't
like having a tunable when we know that larger IOMMU mappings are
strictly better when you have an IOMMU that supports them.

I think that approach would also align with Jason's idea to keep things
within the network stack and to work with the tools we have until their
limits become very clear.

Thanks,
Niklas
> >=20
