Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362384;
	b=GTLc3zfrzUodwJXUDevay/8igzIJ7gTjlq8u5uYgkbyvGWFzpex8YYhCLLMPt+6kyqya
	 NEaeZR+QJHSCIlyBmIeRCSOMbFbyOBUcgTQBBu4DRa3syBMmsScPlpb7kXMPiGjqOiIQ4
	 C3z+MrTbb5weATlT7w3WUe4KYNgfBNCmLCIzaDKFtygTOGklVHPQU6t2naQb7Os8UcW+z
	 OLlCNdJMPUp3ca2cp6kBHTm2Tz0VmtElmxYHxhLmaY4BqdQNvqZpYVcYt/hXO8zNVzDaN
	 yAYb1vYUiSvEAVT6z16Kj5vsDsy/DWNVD+ij/RlRSdNFFPM7WI9BiQE+W+k1e40Hvkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362384;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=bZKAADSfZoWv8xOE7quCSCjhwlCNy+kog5o59siXEHg=;
	b=jzjVTpwGfLnFN+MRXjoeemP9KYZGx0nztP3l3c1DIQ5V9XEZmj+hr0Dh643H2vKc6TSt
	 awzWZEIzVQ9KNWOWIgVBU5GxsWgmeO73e+Wy7oF4uFLc92Tt6KZU6H1eWLUUaC6xbToN/
	 ZNtJZXIhQWk3r2qiQl9IKgj/hWkqwB3750NUmBTOVPguBt3nv6uc8S7yMz3F4SxcghNM+
	 orjkxTb/US2BAOwASlv3hdCnv9vK3LH0CH+2WKH38mDfpPqEVToQ73XOWUi8+XvF4lW4G
	 DBDQE2yztMpgxxmJ+aoxU58UlWlHmN8aBrWBT27pLywEskk/7LzI8LCXL2oIPdkchIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=D9IrWoMl;
	arc=none smtp.remote-ip=209.85.219.52
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DF5606A31D
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 12:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72DF5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=D9IrWoMl
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91c6ce60697so10227406d6.3
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 05:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793362383; x=1793967183; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bZKAADSfZoWv8xOE7quCSCjhwlCNy+kog5o59siXEHg=;
        b=D9IrWoMliC4j7FfiOXtcVKJm+6NPKZ6oksqPyUCd5D5T1WgTVWDBvDlmo2f1Z3q3MO
         j1Vc4thT9XcOp6QH+0T2vP9E6ph+l5bTz5lHCAeq7+R1INkmfUuZXpPRY2FpJQ3AhD2S
         QTL1r2v3tqmelcOR9L3xvqtEXpZAdtFGtgQpfER/CI9AknxmZuBRpWcMc/ukm75y5+ZC
         r5GskGgMpUVtHzeigCwLg23KbIb2nAU3pAJ1eKUEPQii/uM+pbTyNkkCWvBSaDAAxlH9
         izMaevRfvvVccHb1YxdklPrs/GIL2ua+YzeTEr1O+BYLatProI3m7/ReKdzkz8XjT78o
         OwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793362383; x=1793967183;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bZKAADSfZoWv8xOE7quCSCjhwlCNy+kog5o59siXEHg=;
        b=EhiYLc/PmxPUwapv1s2LF6cF3GY11wK+NhCjk2kSsxHAyzlffrBc8CQR302wMwiiQS
         QIQLbDVulEJKjehEnHxOXqmYiS3eqi4mqykb6TjnmD8x7YbZzCd10Uy6vCHco2FlmbuE
         bblT2JQsIwXsTAEgFRfb8Eg7NqMpKL7nuDf8GuSluOc0R1VtjQ+2ivi0yr6JHcfngLG0
         QSczIM3MKDTIqDklUhAQt0VpTHxmYb5cVLtyY488U1JwZ6xVf3gEzcRDITtEb2eN8iSg
         F3FN4/qyXej5fNwlRJlMdVdDxXN0ohE8ebnEJUkHJNiztFDy0pO9LpgVROEa4+UhraJW
         d4Ag==
X-Forwarded-Encrypted: i=1; AKwUvBw8khLI7WUbC+wG4WRtIDzAr5dKVPszZpcguDHMuYy1DONkthLHmb4TLAx3Ra2f9zR+9fu3DEm4NDw=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ31ymPRzRSvMTmqT0baX7c92QmYpfhWz7WnldsDT4U1GF4SAd2
	RKmquOXXDf7S4pEbGqbIweMAmxapop9L6XqXBbLKWAVt6qsQQNQTec1g2EwQXClr/3w=
X-Gm-Gg: AYBFou0lRdYxpGPCDEj7bhYve2ouKr+M9InPDNF6YkHoqZFEXvbKXjdDADyNMlkiqTf
	PdD69hp7honF7v59TOcZwHqf1qKgl4ZqArwztF3tAZa5aYT3TG9w9DB2S7Hod3K7m5n1BL4tZ+5
	ayl3aWna+YltA6aZGIZ8fKbuMD7L5QmuEwaV7JtCIxev1NnPIAWIC359hz+5msNJIZwWBsmhBjT
	t9RSz/0GJPctAwYKFsZKDYhRuLR0+BZb+EYUEJa7HZNiUG3ohwJkdHjFYIJeBVR+Uk1FDJZVKLn
	z7zwVq/fuJN1+5GD9y9vDtipoBMlGsVrLR/jzB5DuEAUy5dzGaFk2HVpjb2j9Rc7Nxmj5mDb2C4
	iLNRyuQMQ4zCEjwz37WAB50Fy91X8JAdNX/0QLEwVhM29x0OCwv2JDibBvJ7XelN79LMo3cQVCM
	2dVqrB9s1WY2MQI0DsQbiMvJOxvKvL09CaCrL7VtjXh3fOSLU0fut0llFKB6dJQirM3jPktRg90
	G0V/GJmIPRm0ctvzPpDjXFQUbPMrZzZNvhr5i7r3xNLDaUUAmJIjSCXfeYO/iLlOb6RQRbzpL1p
	O/rky+CiQVUq4GNwfH+kO8YGFX8qdCnbbVNtQt/Y1WHiV+n1P0BYWpt9MFqlp18BIW7w5WBAkKl
	nbLGNwlp/lRE/Xu3pya/UyNOcYdQPszYk
X-Received: by 2002:a05:6214:1252:b0:917:7d92:6486 with SMTP id 6a1803df08f44-91ca4a0c511mr31768696d6.6.1793362383132;
        Fri, 30 Oct 2026 05:13:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7e24001sm13957666d6.3.2026.10.30.05.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 05:13:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMlTf-00000000Zek-2qdZ;
	Fri, 30 Oct 2026 09:12:59 -0300
Date: Fri, 30 Oct 2026 09:12:59 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Samiullah Khawaja <skhawaja@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
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
Message-ID: <20261030121259.GC3889730@ziepe.ca>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
 <auEksxfAi9lHFXmT@google.com>
 <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
 <auPKfqh_YjRU9Ui3@google.com>
 <CALCETrUEyfvaEGxMHo=c0ia3CDgSxg-YW0_=Z7T31Ou+pvicuQ@mail.gmail.com>
 <CALCETrVpEP=HxVqdSP_AgA=U7ignwAgjz5Vi9+Z9dZsX5DXeLw@mail.gmail.com>
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
In-Reply-To: <CALCETrVpEP=HxVqdSP_AgA=U7ignwAgjz5Vi9+Z9dZsX5DXeLw@mail.gmail.com>

On Thu, Oct 29, 2026 at 07:11:25PM -0700, Andy Lutomirski wrote:

> I can't shake the feeling that the problem here isn't so much that KHO
> + iommofd doesn't like this but that the behavior in question is
> nonsensical.

It has been this way for ages, like David says if userspace shoot
itself in the foot it should not be surprised by this illogical
behavior..

You can get the same nonsenscial thing with just mmap too, you don't
even need a memfd.

Jason
