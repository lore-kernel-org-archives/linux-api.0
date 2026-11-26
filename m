Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726056;
	b=36zDgpoAagVHtQQ/JgqTbijvDw5wQXzao/AC+RALnO/IKNIxV2s/2CG3Owpi1lR31VuB
	 jls7pwAgjUYfH/82XuZgh95gIgH0mOOLriYo+GUhjPUgqXr85n8RxXxAYKz2Us7KX5/wL
	 d4LJBoAzmSl15UKglybJNgvz5J0AA0yA7av5MKEMoTsFubFLDYILQzn1NisSbqhQIOLHV
	 EPHtQzYwmUriydHjK8EledNFKGDzhBtG99ogCSDQK9zrDjzbSvWiaETKhJ69JeSQeJMJg
	 fb1FVsVN72MLxPoqzlj6rIVK+xZuLpeVUqBnZHHDWd0NcbxRHO3YdWYi/0+wESz4bsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726056;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Subject:From:To:Cc:
	 In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:Date:MIME-Version:User-Agent:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=TRZ70z+Z1nlNflbGDjmI948Rj6w7bC+zQbrt4UTlP3Q=;
	b=hgegc5vbPaz+nSX5bKaJBc/nM0mfsjT7Oc/0OVnNYEZUNSjnHYSLykTfTNV13tAhijec
	 iQCB9Va7ePUUX6x1St/Aooo3IqzVO4G+SB/ffWeGosce+y+YLFPN4gtz9g1wmmOW9K+HX
	 XEDamdBYWRwX3zrr3UE2z3A8tP5QPdMlCV35naqkSoQyhxYDnyds2K4+vthRszDiGtrbK
	 PuC7k844xEMv69LNeDSa3BXGskmGSxG+QEGiiubS/txrIPqk52v/8+DsFtGhN57ledJYK
	 2JqFPZVpH5aTK7SJgKw001RenK6XYnyfA4z3V6k7mM7ConZDCiaqv7QQ8bb+4yrxw0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=GF7Pj1ZT;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754D5606A334;
	Thu, 26 Nov 2026 20:47:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 754D5606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=GF7Pj1ZT
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQK4nu23683099;
	Thu, 26 Nov 2026 20:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TRZ70z
	+Z1nlNflbGDjmI948Rj6w7bC+zQbrt4UTlP3Q=; b=GF7Pj1ZTnh8wViBir6xRWF
	UkqwEYfqQ8oS5W6b7f3uQvEa9rven3BKvwJm2ur2gxt9GN9fJEhQGBcGLXV3UlCw
	jfWs6PohdUOd+jzYziGb8gnSBai9gkVIyBQurE/hd4esI7vc7SPp3tOcP2P5JyG8
	Aoz9vferby4uGns/9gcH3RQBDbEUxcJHKPSJ/4UHzNKQYxBD1komWPKGeuvpOW/A
	MM+T+ENs78luBhl/Vw0tLNFoJyMgVDbtFE8u17UAILdwBq9Y52rwDO+0uVBRfd5t
	Y5Xevw+kWjSlD6tDQyLlpEbck/3XLMTwfmlDPr97DXOvYASK2ht6xAsOXWsR55eg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g3k34s-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 20:46:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQK4K4i1672992;
	Thu, 26 Nov 2026 20:46:36 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j5kfa7rxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 20:46:36 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AQKkZ9o12190272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Nov 2026 20:46:35 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 76C1A58059;
	Thu, 26 Nov 2026 20:46:35 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70BB058065;
	Thu, 26 Nov 2026 20:46:24 +0000 (GMT)
Received: from [9.111.15.131] (unknown [9.111.15.131])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Nov 2026 20:46:24 +0000 (GMT)
Message-ID: <d42bd9452d00a0b2a5b7d6652d556c9fc8d2c830.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Naman Gulati <namangulati@google.com>
Cc: Luigi Rizzo <lrizzo@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew
 Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Johannes Weiner	 <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel	 <joro@8bytes.org>,
        Will Deacon <will@kernel.org>, Robin
 Murphy	 <robin.murphy@arm.com>,
        Marek Szyprowski
 <m.szyprowski@samsung.com>,
        Jens Axboe	 <axboe@kernel.dk>,
        "David S .
 Miller" <davem@davemloft.net>,
        Eric Dumazet	 <edumazet@kernel.org>, Jakub
 Kicinski <kuba@kernel.org>,
        Paolo Abeni	 <pabeni@redhat.com>, Luigi Rizzo
 <rizzo.unipi@gmail.com>,
        Lorenzo Stoakes	 <ljs@kernel.org>,
        "Liam R .
 Howlett" <liam@infradead.org>,
        Mike Rapoport	 <rppt@kernel.org>,
        Suren
 Baghdasaryan <surenb@google.com>,
        Michal Hocko	 <mhocko@suse.com>,
        Brendan
 Jackman <brendan.jackman@linux.dev>, Zi Yan	 <ziy@nvidia.com>,
        Harry Yoo
 <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes
 <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li
 <hao.li@linux.dev>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara
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
        Pranjal Shrivastava	 <praan@google.com>,
        Mostafa Saleh <smostafa@google.com>,
        Randy Dunlap	 <rdunlap@infradead.org>, linux-mm@kvack.org,
        iommu@lists.linux.dev, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAMP57yVZx=s-JXHfQfd_ouv2jV6MMsJXpxVLkQQHG=7qfFVJfA@mail.gmail.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
	 <20261120010655.467825-1-lrizzo@google.com>
	 <20261120135013.GO3115493@ziepe.ca>
	 <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
	 <1f10002ea9ee16a17087bd06e4a1685a973fdf6e.camel@linux.ibm.com>
	 <CAMP57yVZx=s-JXHfQfd_ouv2jV6MMsJXpxVLkQQHG=7qfFVJfA@mail.gmail.com>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 21:45:23 +0100
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
X-Authority-Analysis: v=2.4 cv=SoQFe/O0 c=1 sm=1 tr=0 ts=6b089aae cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=9jRdOu3wAAAA:8 a=AYP4Pnggl5clyuVTJKkA:9
 a=QEXdDO2ut3YA:10 a=ZE6KLimJVUuLrTuGpvhn:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDA4MSBTYWx0ZWRfX7y2nZhl4+ubi
 FWX5zWRwcAmuzRkuebBq1cTCWDGv+lCPQjK4q3lrBxdZhW7ihblzuEWYgBBzvPLv65ipqxvEHU6
 h6xDrjn860cWaIx+PNHfAzubb/AxIt8=
X-Proofpoint-ORIG-GUID: _NB78zlRf_P9-O9HiYlEA1VklFdHsUbA
X-Proofpoint-GUID: VPHT65VoCiUnCEkR2bZTEbEzQ7dyLUEe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDA4MSBTYWx0ZWRfX453nIMPIcDZV
 hP6Bh0Q4oBItuZwj85YnFNVsNUbGvPxCPfssInDe70gydwYTF9s/2BpwJTkgXzlp1EnS0qAyiyf
 6FgUgG+uIGxfsFPdi0Wkn7YQB4ejP77GGO1D72dLE4sk1EnNSQY97CttoBlRNsg2AwkupyTwbIR
 z7YJGzLN4NeRqjSr9MoAF+I/ACqLUeCNaF4NH2UXer3zmCL70wClyceD4y0r8gHIB1A/pVk6DmQ
 NkjO7MNxXP2BklO0Js6dGgWyMcqC9BhQXISKoOCnmNnInn160t4pgo9Fz8XSgqwrxqjtNBsOgto
 SLCctUSEOER8lX920eq4nq+Fpp2/ssG3PdhLAItMbefpL6yc5LFc0XrQWlTkC7lNV5+4Aedm9ne
 r4SZ+f3EghM5Y80TOBV7rXzqXZ5PjRTs6p3h6jpDBTiaDiovnw5qMQ4Os1VrW3CqDVEuYkyY4tq
 u5kWMw44R/R9oxBCOQQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_05,2026-11-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260081

On Mon, 2026-11-23 at 09:50 -0800, Naman Gulati wrote:
> On Mon, Nov 23, 2026 at 2:10=E2=80=AFAM Niklas Schnelle <schnelle@linux.i=
bm.com> wrote:
> >=20
> > On Fri, 2026-11-20 at 15:19 +0100, Luigi Rizzo wrote:
> > > On Fri, Nov 20, 2026 at 2:50=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca=
> wrote:
> > > >=20
> > > > On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> > > > > This is v3 of the RFC previously posted as DMA_PMD [0], now renam=
ed PISA
> > > > > ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> > > > > Documentation/core-api/pisa.rst (patch 25/25), which has the deta=
ils.
> > > >=20
> > > > I thought the conclusion was to just do this stuff in netdev pagepo=
ol,
> > > > now you come with an enormous AI series spread across the entire
> > > > kernel?
> >=20
--- snip ---
> > Now, I wonder if we can't start with something simple. What if the page
> > pool could start by allocating in batches of PMD sized and aligned
> > folios of contiguous pages that can share a single large IOMMU
> > translation. The page pool can then still hand out pages from that
> > batch without having to do sub-page allocation but would already use
> > much fewer IOTLB entries and the locality might even help non IOMMU
> > workloads. So, I'd even hope this could be enabled by default and this
> > is actually something I don't like about this series, I really don't
> > like having a tunable when we know that larger IOMMU mappings are
> > strictly better when you have an IOMMU that supports them.
> >=20
> > I think that approach would also align with Jason's idea to keep things
> > within the network stack and to work with the tools we have until their
> > limits become very clear.
>=20
> Hi Niklas,
>=20
> I have been working on this idea exactly - extending the network
> page-pool with a memory provider that allocates large pages, splitting
> them into N smaller pages that all share a single IOMMU entry. I
> breifly shared my approach in the v1 PMD series [1]. I'm readying a
> short RFC to share shortly, would appreciate your feedback.
>=20
>=20
> [1] https://lore.kernel.org/netdev/CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trm=
w+BJRVYf3JB1g@mail.gmail.com/
>=20

Hi Naman,

This does look more contained, but I'd say you should still go simpler
and fewer steps per series. Some thoughts:

- Drop the CoCo aspect for now. The shadowing / virtio-iommu and IOTLB
performance aspects stand on their own in my opinion and the focus
makes it easier to review too. As Jason said it's then really just
normal memory that was pre-mapped for DMA.
- I'm not a network stack expert but I think using the page pool for TX
warrants its own series. Maybe just start with RX, this is also where
we see the biggest performance issues and it would hopefully make the
patches at least a bit more manageable.
- This is still a LOT of churn, my gut says much of the benefit should
be possible with much less churn. It's really too much to follow but a
cursory look makes me feel like there is duplication between rx and tx,
which is weird since for the pre-mapping they should be quite similar.
There also seems to be very little integration with the existing page
pool, rather it seems to set up a parallel mechanism for the pre-mapped
buffers. Really in a first step I think we "just" want to use a more
efficient DMA mapping and contiguous memory chunks for the page pool
and also keep the page pool API unchanged as much as possible.

These are only guesses from looking at the GitHub branch a bit, I did
not dive super deep.

Thanks,
Niklas
>=20
