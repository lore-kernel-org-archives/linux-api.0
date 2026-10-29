Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793283001;
	b=Bxwz/6kNdtgkvHl8osQz5Jj8mJzqMaJuVHu2gh+6nOrZ0PQe6P6wkupcsyMlkOCnWfHZ
	 iROp6L/VAvjwjOe84eYi9cLyC4NJ94uy/9XWD3wJKUp8Dco8Im+gPSunNE9Oxb5K1hdCS
	 P3qp5eKz03lLsv3a2G2ftclrk1kFYMcUD0bGzB4gerDcEVw8ycghsfCmepyV9wy8BRQFe
	 YSJeGApQC4/Plufhj4nKB19gBkQR/HDim4JKXs/t90i17cymlzmrsTNL7iQEjwlrZrBj6
	 n7NG1jP8pHdjVfQRVBBoaeAEYBIDLKV7RmuuC3uZQDEminnuw55f+lVwMIfQNHzt9AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283001;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=u/mTL+S+jT7oJspNq9ZedMuDxLFktRxLqgiEWs4bjJc=;
	b=0h696YC6agcrAEoBKRUyBo53lfvVM2RAyxr6+BMl03UdUBS3aypqzcKZmMjn0EUVlh6x
	 zZv5+xzfpG0VHHLqad8744c7sQ35Cebs1IyVE7dUuYFJ+g8Uf2ULmNLM5JIm8DKT6q23a
	 bZ5artwGPM7C74Q6kfc60Vz4v1crCo3cG5FQ0MKzYy6UpRg8pQaChTMrgCe26q6rIuEUg
	 g+h24W44WHFzRhwtybbGOlhKUndYVgoiXTHE4XgX2m0CvF3a4fzGPBgjsJ8vPGEmKfomI
	 pWxA7z8w6FjsoWx/t0SsiVhX5sTfgPFALNtWcJMXDoKjS8deCaCIwAh+0drI4HVgWMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	arc=none smtp.remote-ip=209.85.222.181
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158F8606A320
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 14:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 158F8606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93e7ad9f78dso247291685a.1
        for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 07:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793282997; x=1793887797; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u/mTL+S+jT7oJspNq9ZedMuDxLFktRxLqgiEWs4bjJc=;
        b=oqoCkjVszR8u8wCAtEPVJAxDRDmSU97Ltyl0epD2Lt3u2UIIXdVHNDGujjYdwY6WRE
         SKBt6uYgdBnT6o5KdL7GbgHiWWlXLYlzp8oWVtx/63snb1x0A/98UMN9nSo5V6B5ls/h
         9u535mipY84FplFJ5MHPeqQly0KmoyExjUBmnPmbZgYUFhtaNmzu1pOR7TqeL6ghQvnJ
         wb2AWZsJdkzFI9sCrqTqK7UV5M+ZSaa+yHEEkToHs9S+zZdwlj+JO6pofP8F4CYTjz8w
         BisOYjY7MDZGSlzjpRbTYDWgiYT+BJxMePPhJG1Ck8ZG82Y4PAMfi9RC0ZL1zm8pkkMN
         jT8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793282997; x=1793887797;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u/mTL+S+jT7oJspNq9ZedMuDxLFktRxLqgiEWs4bjJc=;
        b=tYZvPRC/RIHuwRMHii0uTJQTneZxHVBySJlt+r+t7N16SyJqbysw9IGpwQDBTGJJQh
         DA/x8lazD7BcAJkba3X8OjtmutfwYOqjNBPJMO0LC+Yj9qY0l/mWUh94IftMUuRg6lzF
         LDfB8ZoQaQLdKAYCEtxVQZC8RrbJWOTx+tzKOFODi6oCGjavAPgn13EB5qU0vhKVy+19
         8ePaqbzGkqU0OlDZKVSUD2iHUPpkejYe3oRs75BBMc34uvGftvaSSy0qq3p9w8olPYCR
         Le+IvpTAivC0bd2PZBfcaoJJl/veB+0hLGIMvwcwbbJyxZtKMghZ8PotWtN3KVZ7sTbh
         SLTg==
X-Forwarded-Encrypted: i=1; AKwUvBxQJmf/vl/Yn90XnAJ7AVd3PIN82VARWr/6wDX2YwIJyq0wj8i4OYD2Csl4FqovTdQMlyqp5X/dL8U=@vger.kernel.org
X-Gm-Message-State: AFq9FYLrsrNhSVgNH/wIJqsrxWhXOPFKYD6kH6MDoEpdN1Dc5omZsQ8K
	XdtIAJ/fBTXcajtd7BNCKy6TPKePpbKOSbZCUdL8SlH6dna8QyKXKlhRuTXFKJNE0/Y=
X-Gm-Gg: AYBFou2tvgnpQBnMMLYIX+er3bQgBOdDhY21G8hDp8jG/ZJpCcjIoQ4kBunPdUfQaMZ
	36nDv7dWOzcfluZmA5thzRQkfyFUvMikj1J9nUfPcRQdB/cvBv300hJGEnfPCblQw5Du/kwiYSo
	ifoTE216aYMdLji9NEH9LwJ6e2jyyj49ePkI+dVTtxifSqrD83Y+UVwtrnfcvYssZxuBom4hZrR
	ltMcH62YjfD7CJ4OVtNcY6a4zcVSplmRF9MagaZr+yc+H3kD6uTuwPjtach20OhpmL02BwZN8w9
	BzLFNLaRuW5kHmmFZnZ/SBwU6NemxoNkYzU6syHWfOcW7+5oiuONM4bzFIRPG6EETWqfRiBwrXx
	tVnMS6OMFUtuFQ+yzpAgQqbOmkwUHJoUDY4jhHIXO4TwOxT5+tFUTYY8M5asRyNY6NflR7tRV9Q
	EUpJmxgCSAHDFAgv2sXOKyv+PK3SJ06zaVDbPMuDZZfiBYfkmMzpOeIYyv075EhC8Y718v0A+PN
	trsS2/C1v/vV5dCHmwXAilpnglfLAmCsR/CAl9bDUNT654YLQEkOJOxg5Qx+Aa2hOm0E7s+OSaO
	G1Q/tEp3mBGfT7LXFKlA7JADfKfSCS9u7smqr1Z4LfOXeefOTNuxvCx4r+3jllfj7RmUI4xFl+E
	UjqxjgitSg5E=
X-Received: by 2002:a05:620a:29c5:b0:93f:59b8:e28a with SMTP id af79cd13be357-94408cf4114mr838476185a.28.1793282996749;
        Thu, 29 Oct 2026 07:09:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47cb4f56sm162421066d6.35.2026.10.29.07.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 07:09:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMQpH-0000000FhyS-1U83;
	Thu, 29 Oct 2026 11:09:55 -0300
Date: Thu, 29 Oct 2026 11:09:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	drdeeglaze@gmail.com, James.Bottomley@hansenpartnership.com,
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com,
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com,
	ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
	rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
	dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <20261029140955.GO1685504@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <592d643f-e97d-4de8-9a87-e47d57dc8457@intel.com>
 <20261027193629.GK1685504@ziepe.ca>
 <5f33aeed-a20d-4881-9ccf-a69bc308d348@intel.com>
 <20261027234658.GL1685504@ziepe.ca>
 <c57c45bb-5047-4aa9-9f06-6ac5f36ff3ce@intel.com>
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
In-Reply-To: <c57c45bb-5047-4aa9-9f06-6ac5f36ff3ce@intel.com>

On Wed, Oct 28, 2026 at 12:16:01PM -0700, Dave Jiang wrote:
> 
> 
> On 10/27/26 4:46 PM, Jason Gunthorpe wrote:
> > On Tue, Oct 27, 2026 at 04:09:19PM -0700, Dave Jiang wrote:
> > 
> >> There are two issues for TDX Connect. One, the device info is collected at
> >> SPDM connect (TDH.SPDM.CONNECT), not at lock. TDH.TDI.BIND only returns the
> >> interface report. So the measurements a TD sees at lock can be from well
> >> before the lock. To get measurements taken after the bind, the TD has to
> >> ask the VMM for a recollection with its own nonce.
> > 
> > IMHO measurements taken before lock must never be made visible through
> > this interface, it defeats the security property of evidence within
> > the locked session. I would expect the guest kernel TDX driver to
> > prevent this.
> 
> Agreed. I'll change the guest driver so the lock asks the VMM for a
> recollection with a nonce the driver picks. Each lock then costs one
> recollection.

I do not understand why cached evidence exists in the host. What
reason is there to ever provide a stale signed evidence? None.

Other things may make more sense to capture once and are not permitted
to change, but evidence is not one of them.

> >> The empty challenge in my provider means something else though: don't
> >> recollect, return the evidence collected earlier. So it's less "omit the
> >> nonce" and more "no new collection". Maybe that's better as an explicit flag
> >> than an empty challenge?
> > 
> > I'm not sure 'no new collection' is an especially useful thing. Since
> > the kernel won't be validating the signature you still need to pass
> > the expected nonce from the prior collection back to userspace so it
> > can check it.
> > 
> > Is there some specific use case for this?
> 
> Getting the lock event's evidence. With the suggested lock change
> above, the guest driver collects it during the lock. But the lock is
> a sysfs write and returns nothing. Userspace still has to read the
> evidence to appraise it before run. The device was already locked
> when it was collected, so the read needs no new collection.

Why collect evidence during lock with a useless kernel made up nonce?
What is that even for?

Signed evidence must always be collected with a userspace provided
nonce. Any path that doesn't do that is pointless and I wonder why it
exists at all.

I imagine lock should only put the TDI into the locked
state. Attestation should later collect the evidence with a user
provide nonce.

Do not collect evidence during locked. Do not hold stale signed
evidence in the kernel for later retrieval.

Again, we need a flow where we get into locked and know we are
continuously in the same locked session until we reach run and dma
enable. That should not be done with evidence or evidence generations,
it must be some contract inside the TDX driver to provide a locked
session generation.

Under these rules it does not matter when we collect the evidence. Any
time during the session is sufficient, it does not have to be done
instantly during locked.

How TDX does this is up to its spec, if TDX has to capture evidence
and do evidence compares internally thats awful, but has to be hidden
in TDX and not leak to userspace in any way.

ARM should do it with the sequence numbers I mentioned earlier.

> The guest driver picks the nonce for the lock's collection and
> checks it before publishing. If userspace sends a challenge instead,
> that nonce is its own. The collection's nonce is in the evidence in
> the GET_MEASUREMENTS request that asked for the signature.

Unless the kernel is decoding the evidence to check the nonce this is
security broken. I'd rather not have the kernel decode the evidence
like this, so the nonce should always be known to userspace and
userspace/verifier should be checking the signature covers the
expected nonce.

Jason
