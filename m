Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795782569;
	b=PYpMVgwJ/CfHdq+u6+wKkLbVY2dQjrnW8njo1GLVHQw3qjE+VOmxdUVYhJISX/22BBcq
	 H+G+scG7KyKkD/Gxx18KJzMA+FZVhbxffJvHXJFeI/sYnpu/9sijUEBWXT0JiwigfrSwU
	 A055zVAls8Nba1UDPs/WE5H0pU2jybXeJmXtz1u1gFA7YsxqohN0uHdhx7GqOO1c8mBYB
	 UV9JHjM4RG2yguyxrF2o8G9oAH3bfi6RMatnEE9chlvaJBgQmKFFmjXquGwOyg76ewZVr
	 NgWnJ/VR3tHz94/zszueDheFjTRg0Oj7UL9AluKgBOM79gj00d/cE/RpzsmCnW412cA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782569;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=gXf5stEDIYuDZVQjUcNyW733hx6qDRKNZoyJXoBIROc=;
	b=cPq/hquqIm8uujguXNr9dobWFktqDVxK5b7ddgGtCV21/m1ltWD38qc37Cc8luUzkNoF
	 Li6RsDSti5ePsIwQzyV1Gr9yaPDpP7LinzOWwOk+fzgdfGhc/VeUvOPTpZqrA3P37L5xW
	 oi0SmOpG0dmz/34tDhCrIk1pUgAHoCKept2mfEbY2DoQRSjsVQHhZdK7EKaj3ql2ifhdJ
	 wjRK8KGGffwaNn0mxfJJNSsybyGfRwcGpo99bJurxhkwh5lO64xPyIHZeSza+d7O3QCkE
	 LexIZDsIQuaJov0Hxi4NpcckyCqAEYxGuGxeUfWFPK0RzfqiD5RZd7cV2oW3X1h51Bg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IDtGKepm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.176
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C9B606A32A
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 12:29:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63C9B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IDtGKepm
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-55be673e029so1832241cf.1
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 04:29:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795782568; cv=none;
        d=google.com; s=arc-20260327;
        b=I8A6Gh83zvxS9FUZLP6SFxjrnfSN6Zy+tNqTL11Z5FhsZjQJnchPJOaT9KZwbozaBO
         S0qEXO9suHjLWCk3MYtBEOBqe8gpEdUNjBu9pD2sQlVMsg4rGWs8Ztbb6NhDvm1XsYWl
         4hCBojI/y4XsH3r40w4yqjNT8Wlah/yd6BN7SjTTJPxGa0wExhmvEAgumj14VHkzG7wV
         SxR2sTkVxot4ErMjVO/3pr5HCZPGeSIE0Oxlkafm3V3hM5EuTr+4MUn5TGOwaG01/096
         6PyjOyxl1/BMuwuW6SVymbsc7rms6ByvAS01pTQo+HyIsRe2bw9OxSAeSnc95q8ksyGl
         LNKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gXf5stEDIYuDZVQjUcNyW733hx6qDRKNZoyJXoBIROc=;
        fh=qwKrP9mPQ7Z3IiPZMyD0JBvDN+pdHge60VVJV4E+GUI=;
        b=AFDlIUX6i+8bOA3Rk389TDdoVoCWLH9/BQWKzCeT2xBXSsc6hjdtcBnTaTgetI3Lfq
         9TcPsu8Erk5cuS2SOukj9swUtwq22aRqvngO1l6lh7CTLF8f/9bReiQsKIIKzcIIPDVk
         RKjtYn2UzlDNuwMCdP1uUv0ds5EZRKOxMx+jB22o+PeleY319HwanxCq2N41Rl8o2FMY
         w+Eb3h2AkS80kyGyK2RRohR3uDeyvQ/eIccnxZY7E1/y5KdHQZZyLkXDZPaqr2MB2l0A
         ajpf3i0LTcTIywfwfkvoGIlkx0GORrgDcqNKfsLJl7Zq9E2EdnsrEhb8xLdsHGSFQcsr
         BnGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795782568; x=1796387368; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gXf5stEDIYuDZVQjUcNyW733hx6qDRKNZoyJXoBIROc=;
        b=IDtGKepmhQShYR7D/olwV/obTk+1pmvySEjMhbDi/ma/1i93QiS/JtjUrgxBSMhQ0k
         JL+ilsf6MgB7rL0RhzqkxVfHwpWehnk7Fk4Q747FAHE3PcGDe+yn84ff6jYRMPlMbx0e
         QokdEvRzq0preycHEpMBQ2Lohvx+Zw/uSsx2DMrkiT1qcSSKYLtRImSCVnyuzNksYALX
         NtWTa/1okzanV5FHK0NJqjKm441asfoZ8MYagjrt+QkZuqm+fqNCuiCSxrGhrELhPKIE
         fk/8Dwyrnu3Us/ZvtQsa36mEXHtFs/36/ZYUVzpvU3JIUzDhbiIDtqOBlvidXDxzNxSY
         eJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795782568; x=1796387368;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gXf5stEDIYuDZVQjUcNyW733hx6qDRKNZoyJXoBIROc=;
        b=ouHUXDGKA2wNX3Lx8wFh+c3ZhlRVIsHOBEXwlzr+6nlpB8A1OnLigovzYEKeJHYzTB
         ylVssQGnbebrWOPK9d32R3EDmRCM1Sv/Ms9v4uWUM3hYXBFA/lOO3b2ks4hL+yRpBA/a
         TNHrttZdxVeZs0vJGzcKPlMxAf+06z7mMYw/nOQI1ThgBm6KxMjjjF/fwjjdhDA+UClL
         L3UlP8cy5oUmY/ghhobEw7aAjd0ivUNvfRA+02Ol6x2/l3jh6FwJC4U601UuJcDeb2Yo
         7nmj0U+FrT0yLGO5/DdhIHXsPH/57Sw4x/oQPf9KFMBWa18iFl8o77gyqEzENDlHcdjS
         GWOQ==
X-Forwarded-Encrypted: i=1; AL+hErE2R6PrWAR15ZDxMdC3iGF+TmmEd2WvETWLqpRv/fSYe7aBhewOQK/7OL6i6atrD2thAq+kJ4/WJa4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+FJwi7bQMWepUQa3HYv/Dk5r72h0qQCx1Q18Mhv6eA2mHB6Q/F
	L8rWlTro6qkvn/eMfngx7mLFYnG4COBshSER2nR4TkKs0dsE44MWgdw078fBmzqOI1DhaOAnIj8
	DDaSt2FSI6pMAOGYFYxoy7wPIZwvqytIk19SLQ5UF
X-Gm-Gg: AZFdTZfnAOk4EBoI3D1Z2Hx1wf5zCruKvPeyW6I/NICJ5pM36d3Rcb0uEpAa9GXucfU
	O5wSxUlL5ee63d8ou46oYn3tvrdBao+EEpMkQoijy+EWuqp6C8vEAQPrazkS3cZ1+p7QTYuvnzd
	1pPwe9byrM4zKW1/4TYt8TLnb5UI6FEEw4eRKTCdVEaMnaaTPYv1FTmEJEnXghWgrqZ3HEU6Z4U
	y856dqf4KfpnQdze/5bHWYHcj0pwtMBGT4Eg/44ay8/4xNE5eYYtsUXKHh2Xmf5RVxBSEDvKYb8
	aY+023T2spScrUM8a5UDqLrF3tYqaFqv6pcIUR3Pc5zwXSqKj63ZX0fkC9n4mh/eWNpMDdmPBWe
	/rDemiOzSIff3XqtAYZeua0NsGQrcgWKWwFodJg==
X-Received: by 2002:a05:622a:a14:b0:536:6ae9:f55f with SMTP id
 d75a77b69052e-55d8900bdcfmr34062041cf.7.1795782567558; Fri, 27 Nov 2026
 04:29:27 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
 <20261120135013.GO3115493@ziepe.ca> <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
 <1f10002ea9ee16a17087bd06e4a1685a973fdf6e.camel@linux.ibm.com>
 <CAMP57yVZx=s-JXHfQfd_ouv2jV6MMsJXpxVLkQQHG=7qfFVJfA@mail.gmail.com> <d42bd9452d00a0b2a5b7d6652d556c9fc8d2c830.camel@linux.ibm.com>
In-Reply-To: <d42bd9452d00a0b2a5b7d6652d556c9fc8d2c830.camel@linux.ibm.com>
From: Luigi Rizzo <lrizzo@google.com>
Date: Fri, 27 Nov 2026 13:28:50 +0100
X-Gm-Features: Aa3M54o01jhZM9dCQYVFb8_-yMQWCkVYamRB04RwDLjyCo_Cf-5r3I24fRo_Jr4
Message-ID: <CAMOZA0JMZ8wUrV08YznFUH7AkmyqXcNdzfd26KsoTtzqt69SVA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Naman Gulati <namangulati@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Dragos Tatulea <dtatulea@nvidia.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Catching up on a few comments:

On Thu, Nov 26, 2026 at 9:46=E2=80=AFPM Niklas Schnelle <schnelle@linux.ibm=
.com> wrote:
>
> On Mon, 2026-11-23 at 09:50 -0800, Naman Gulati wrote:
> > On Mon, Nov 23, 2026 at 2:10=E2=80=AFAM Niklas Schnelle <schnelle@linux=
.ibm.com> wrote:
...
> > > I think that approach would also align with Jason's idea to keep thin=
gs
> > > within the network stack and to work with the tools we have until the=
ir
> > > limits become very clear.
> >
> > Hi Niklas,
> >
> > I have been working on this idea exactly - extending the network
> > page-pool with a memory provider that allocates large pages, splitting
> > them into N smaller pages that all share a single IOMMU entry. I
> > breifly shared my approach in the v1 PMD series [1]. I'm readying a
> > short RFC to share shortly, would appreciate your feedback.
> >
> >
> > [1] https://lore.kernel.org/netdev/CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69t=
rmw+BJRVYf3JB1g@mail.gmail.com/
> >
>
> Hi Naman,
>
> This does look more contained, but I'd say you should still go simpler
> and fewer steps per series. Some thoughts:
...
> - This is still a LOT of churn, my gut says much of the benefit should
> be possible with much less churn. It's really too much to follow but a
> cursory look makes me feel like there is duplication between rx and tx,
> which is weird since for the pre-mapping they should be quite similar.
> There also seems to be very little integration with the existing page
> pool, rather it seems to set up a parallel mechanism for the pre-mapped
> buffers. Really in a first step I think we "just" want to use a more
> efficient DMA mapping and contiguous memory chunks for the page pool
> and also keep the page pool API unchanged as much as possible.

The implementations seem large because they expose limitations
in the current kernel code (or our understanding of it;
but the proof is in the pudding). Networking for one, since you
mention it: the tx path allocates memory in many places without any
hint on how the memory will be used (loopback or device with IOMMU ?
cleartext or encrypted?).

If we limit to the easy parts (e.g. just network RX) we may avoid
some churn but we will not resolve the problems arising
from reasonably strict IOMMU deployments on large systems:
- IOTLB thrashing (network traffic uses separate PTEs for
  rx buffers, rx headers, tx_buffers, tx headers). Rx buffers
  are only 25..50% of the total. See [1] for some data.
- per-buffer VM exits on overcommitted VMs (same problem as above)
- IOMMU unmap serialization (with strict DMA, I measured over 10us under lo=
ad)
- swiotlb copy cost (on tx and a backlogged queue, most of the copies
  happen on the TX softirq handler).

Also we will not be able to see what is lacking in the current kernel
code to address all the above.

What I wanted to do with my series (Request-For-Comment, for a reason)
was to identify the components we presumably need (meaning: implement,
or figure out where they already exist and actually do what we need)
and get an idea of how intrusive the changes would be.

Then it is completely fair to say that the goal is not worth the effort
and should not be pursued, or to take the low-hanging fruits out of it.

cheers
luigi

[1] Here is an experiment with a system using bidirectional TCP
traffic on multiple NICs, where IOTLB thrashing becomes a bottleneck.
Below is how total throughput (TCP payload TX+RX across all NICs)
changes using 2MB mappings for different regions.
We really need to cover them all to recover the performance
of identity mode

Use of 2MB mappings         total TCP throughput Gbps
-----------------------------------------------------
none                                  440
rings                                 572
rx_buf rings                          577
rx_buf tx_hdr                         572
rx_buf tx_buf                         649
rx_buf rx_hdr                         674
rx_buf rx_hdr tx_buf                  716
rx_buf tx_buf tx_hdr                  734
rx_buf rx_hdr tx_buf tx_hdr rings     744
identity mode                         744
------------------------------------------------------
