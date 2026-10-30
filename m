Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793373081;
	b=qSHb1DSaQXtoIALpSVFYGLPUWW2mgZtkOXOcBWv+nKPmNTO9S5m6eAbV2PLQg93GeDvW
	 vJs65PwvrVd5yGJdKtD82XY/JsWTd8mtar8GbokRKMlmm0IZKFT43k54VXU7lZQDWH5NW
	 sKuK10UjWAtbfq9g+VqkAOJlPm4OVZQ25wx4EYsT6P3z0RT7VqEbEuc5K9GAlsfod/wn9
	 S2IA87Rzp6v4El2Lm4t+Sl4r/Wq/yf9KOgF7RNjCpmdiirVUNcJoYvLj8LTbDi9xSYva2
	 iIfjI+Y+kE0FvRqNIzeTkYgIx0LJaDzGMaPNj5szAGiJ0m/iuve0SFyKTF8oifGlSaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793373081;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=SknYW3+pVsCwOENllYU3jowrrCPEotGjBjq9wVk1tW0=;
	b=FUewqWowp9YSmne3K4bxMwHrtRMpq0pOnlTmLvWHZcxHemKULCAFKuhqg1i1t9IqIIVV
	 GHyrcLTREZOhmy1+055rrgBWaX8n4PeYp+uNrZ36vOMO9Y/eLV1+oHkFfiLP5fLV6GmMR
	 CyMoolFXlpz8FUJmxQ3l3yhrdZKLCG0O5qrvOgfaG+pKHgv9W6sFJUPYQwz8LkXcitybN
	 hV8L0Ij2vVK1xntWGBetj9yuiAVbhUG/zGj6e3qtnQKHa9Q4PHOoBQXhV/zLp0Mc1Ip4m
	 X1U+F8BhbddVMjLxtr+ytQEaQ20mhKfz52Atleyy41laE6idD1Sbqt03TqBlE3QkVOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=VAnxgq+X;
	arc=none smtp.remote-ip=209.85.219.48
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B59606A324
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 15:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74B59606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=VAnxgq+X
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91c8fef5ce2so10281046d6.2
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 08:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793373079; x=1793977879; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SknYW3+pVsCwOENllYU3jowrrCPEotGjBjq9wVk1tW0=;
        b=VAnxgq+X4QCFTDu9AfTIw48AdlrmXvNeSuIaONQhqFkWoVPXZBz84mze+bQQdrgAhR
         Yb1qIjdcTWGrZL1vyxFrdGovjWe0C1rwpn88C7tgXg3BW1x/vT+4lppONNZ8N5T4dIZF
         A86w3AiVzzJlHYHoWjb+ZBekF/EkxgqB5kFZzSlRgpVyxvegFwpmbFlwECZi5LehdbEw
         fPlvuM+bv9BCs3E+qbixvAbLVr2hTUtX7fpfDGGuE5hdiG5M5JPOPvHVD91ix6/f0At2
         dnlRKLnPnupUvjaDpJdUG/mHdwTGSxDI+PfrEZRHaKDbgB1fY52C8lRrarj8WAIdi77C
         HTkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793373079; x=1793977879;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SknYW3+pVsCwOENllYU3jowrrCPEotGjBjq9wVk1tW0=;
        b=BYJA5qXCUWzsc6XDZaVwA+rBWV0rfygkedSZFesrLtCq9ZUB5nWy6jvNDtmMgntP2J
         N11QmmhW1U5OOaxjUoWdKLk2WC7G2y75Mu52//lk2eBbFENJnz7uzPA19JboYnlXLkVP
         J5Rm7dU9nvRfGLRHSWSH9RNs/7dJYJMgmgWKoI1i/hCiG7wHtpDyKanQ9XIltb0Qt5Sx
         hEnV71SGQgDIF7Nb1R7GLsNCjLS+RY+mPGiEhBix8kwuDeOVbNTAZZ/Es6q8h7kVfLAd
         L7uFEsct/j/ZZgrYTYrApMgmgYukRBuuM1k938ysqbDZgzxfN5eQJaDWVEDVh88/RIki
         qT/Q==
X-Forwarded-Encrypted: i=1; AKwUvByso53i2EwSc7OXZIQ9dBbBoQFS2+/CBERZWZdk3IRvuC6WmNWWPOtfL08JwdcJFSTapEfqqbjBzdo=@vger.kernel.org
X-Gm-Message-State: AFq9FYIwJpWGrLuBmfrNnZmbCKPRmbBk7PhbAlSvWq+RUz68OC+Rktq4
	86ZGAr0lvH+gExl4E32JABzYbPSPuiOpjVw6oN1qgbGkmG4tYbVPL/z1OrsjubF+QJI=
X-Gm-Gg: AYBFou3oPT8a0VSs/GyxhhWc/k9jlU2i30o6h2uK804l9XBzWTl5geJl1o8fG3mgpZZ
	9XbywT6ggsudA4+GSvaw3E8Lmu/3AFRCfk205veCHN7gvSZ2JIHQuHR/g9ckSsNf75kWjrPTxvX
	8XYbmyGpUHGncmGO9GnvNhIbemGf33JmfaKsVV2LwL1a2CPsJVB2E8B9jGAqq6NWUz6VSQg3MEv
	MmOAPvLlFpld8PCT8BL/g35ST5NwkSCKW1FtB8EgknXXkd20BOvLGkQogY8GatrkfloiFnuzhb6
	1BWsiSIy1fzOB6PQSZix/CK3PZzeDUtoclz/xR+Fsm6WIvWrR3V+C6s4Q6GaXn2wPJzfbyWLh7D
	Omev4uUlYQ59wP3rCbTjCGEPO2h6KvHl7RC/eUXhFKucHs6UHKj0CdHj7kslETUR5g9ZnU6P7aS
	1Scrr+MJb70DBfbcnyDiWvKmX6svv7tjS8aSNU0M73c79WGnnBBTwjaNcGtk/JmJ35H6s36M1Mz
	g8ZpV0GmU0yQEn2lMTWQc5GYWlCHPuA+51Fun7PvBwHnLlBKOlUCpetN/uiouUF565K8vVxJKkp
	aFp/kuSRXXbJ0IqzBky0a9iqNWjthFZ/Q7kRQTLHiR3BjNf9SlBIZuGxUl4vWpK7ZPyL1ewkNuJ
	I+3D3bVfiWc0=
X-Received: by 2002:a05:6214:29ec:b0:91c:5fc4:ec2f with SMTP id 6a1803df08f44-91ca4b0dc32mr40691666d6.26.1793373079235;
        Fri, 30 Oct 2026 08:11:19 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca807047bsm17117606d6.39.2026.10.30.08.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 08:11:17 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMoGB-00000000v1Y-0kVg;
	Fri, 30 Oct 2026 12:11:15 -0300
Date: Fri, 30 Oct 2026 12:11:15 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>,
	Alexander Aring <alex.aring@gmail.com>,
	Shuah Khan <shuah@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>,
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <20261030151115.GD3889730@ziepe.ca>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca>
 <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>

On Fri, Oct 30, 2026 at 03:39:40PM +0100, David Hildenbrand (Arm) wrote:

> >> I don't see a reason to make userspace (that should not shoot itself into the
> >> foot) a kernel feature it must activate itself to not shoot itself into the foot.
> > 
> > The issue is live update doesn't preserve those background punched
> > folios and now we have created an UAF attack on the kernel across
> > kexec if you don't do something about it.
> > 
> > There was some notion here that with the right sealing flags we could
> > tell if everything was 'live update compatible' and then know that
> > these attacks are impossible.
> Just remember that there was any hole punch and refuse to live update this instance.
> 
> We could likely implement "we saw hole punch on a pinned folio" as well, but I
> don't think that's required initially.
> 
> No need for more shaky seals.

Ah, yeah that might work out. It has to be checked really late though,
after userspace cannot change the memfd any further.

Jason
