Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793144827;
	b=dwu/qBqVWLO0Ra/th7+kljR5+dIMxilfA0uGQP54DZ5zWtoKivK5wkJ5iOnm3Iy3qA4g
	 wuB3rSPPXhsIGX63q2VJU08dGzUll6BL6EpEw01SA5AY7JGCrUPFST5tL8r2x3hI1/fR1
	 4hpF4FgngOBjP5Y4JaZUIP6+xKh2XpF0gsYju9OlPfgenahXP1kLDYbizNqVjZ/x7zQYC
	 r8ddWBbZz424D6o365esh956JIJoW5aimqpMfKQ2TU+7YGV88j2xCO0KGzZapM4AOiNk3
	 G8kJOO7+IzwJKYptlbddOQNnzFcQxjt4jGGMQlyy/8cXy5Js05qRs3/fp9ThlnyiBrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793144827;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=0jobZ6lKMJLYxxTCc8I8rfjGuzkz6VIrJqfxqZy7dVw=;
	b=AUuUOUbgNnLIENOLz+TeRM/nKrayxQE6ijjrpq1ihDdoWFN8KfZIXm7G3sK4ZuUoYnvI
	 af0Gh+gqunTRrSdwRoEdy0t2J0aKt8CUU0Wf5vj5cVqavIyoEJF/o0wqXHDSDukPy1hPy
	 oik9Z7f+/xZMOeGRgxyPm/XBZF+EerjYhHllDF9s6YA+IeQaZ4v8gIZrynIwhgykZ64v/
	 b+TPj8kHqlH6fMbJfWq87E6cMKi0mphc4lytBEHeeF1paainlQ0I+MGnJSqg7QVpHKfPW
	 mP1s+RLcW6zcK0R+TkAHH/3jTGDNwuimXcUYaqHeXXkf4JiPH1oGVjlkZGEJy6k8mLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=MAMauGjc;
	arc=none smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30398606A31A
	for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 23:47:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30398606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=MAMauGjc
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-53c4b82919fso7136021cf.0
        for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 16:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793144821; x=1793749621; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0jobZ6lKMJLYxxTCc8I8rfjGuzkz6VIrJqfxqZy7dVw=;
        b=MAMauGjcQC5I4fdPuZtoQnkUL42Ja4RAOKAONT1AHTrTUlXxWwqX6qYADXfsEAR3/j
         hUis6BLTdqxH9lpDGbebIZ+F0qhK+3Gw5A5H3+z2NBgRxi4MH2CtjOQEt/4ZNf155hzB
         oTs4TdzanpcZpR/2BlKJXYZ5ayq9dCJ9KnWTYXDxPIGzp3UbV1x+jJ+RSlif0GRL/dJH
         j0OePIYXBil1ld6ZPKFMsFzi6F38i35BXCm6Zqet5zyQslJePMeaHITZMn+3CDTRQJk4
         QD6tYVzQJvCV1jaXUHg5KQO0GvIXtoG0gYWydzGqJE616loH3WeEVB2M4YGyBB7u1Jus
         n4fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793144821; x=1793749621;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0jobZ6lKMJLYxxTCc8I8rfjGuzkz6VIrJqfxqZy7dVw=;
        b=ChskEBJJonw/WtP80lrr7LJ0mHaSESATwCxEpeIH2qlTnPsAbts30AXNwhu4BvuwNt
         HO/aW2Ojy1U5W/IHd70xdLFZVlCG8GOwN/wGXOpmfZITrdZ68RLApV6k/ioT9Og4Usqd
         FOhmi1dZSMRl4hJrflJ1RnZevCA/AqBLu3aNy+8BxNZnAO/UW0WZQYKZ5Hgnq0N7aanx
         RkLzDqEMs7Yr6G2TBakarFSb53RuhDo8O9C/lVcI6kFKSYzY2PLoxZ9WDCzwaceNJXy4
         qXHzmd4dECLjXFxZPITdfLM7jOqCvL9jU8Dc/IvOmbfqIdnlD1eQLwSSsEdDnObUpGCJ
         Q33w==
X-Forwarded-Encrypted: i=1; AKwUvBwzg+fZlYOnbnFV4A1F4yg61p2HYe1Yl72wRbAnT/Se4lG7CFoy0Vmq15RfKVIGdNtuJrA3kp6X9BQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYJCzUwzgMzyv5Ez2J7iG4igriC/WCPWatOdPQGbGjKgrWPt8Nxg
	GUiJrM+kfaddfocJTXmFLzDkoOei8AjQBHyGUxFwFB22+rkQ9g4k7hfBZwzooRfdR+M=
X-Gm-Gg: AYBFou1PDqtGyrxfJdOtXhX5Vb1dp3GEzt5sMrSD5d4OKFnNLHMc2zCzBI558Rdq261
	uDaP7A4qntRnPwGihqqbMIkSTOzd7XgrvMKpWRbA6kYwhQJnyXAupwjwTVRpBoXQZKISyJPUu2P
	0M5rPNr2mS6TzYfG/hl1VDPFuU7ieadu2XWwNah7yeqiR6zMYJ5jxt+w7qRcNDHahJeOKXZy2HO
	jd+DGTYa53eolN7a8SDnbbs6Hl3lkQg8prSN2Fneht/30bit6vNLEzRaRDuWA2+JaKM/jEarQ0G
	L+SDmg+CuLB0xU/6LCwmKCs14PJr/uHqp5e2Xt5SYUv3SF+5Dxjm0DyKmkaQo5ChMq6Exo1Qq9T
	vp7VNQCLe3x1f4W0pDkPDpe5sFwyD/dvELtXi3bgwT8CEwWzbinFYtZLbqDxeNBhPzTG+b25MJo
	LiY9yaqMQpI+E916levBt5mDGuHoCriNmQM8A9g3CjwMRym9jt57/XPk5lQMvrvaZrnTeNp34+p
	qVaQwrz5r/YqfIcYKs0KmgUt6tXHvt0niYdabMIh/JuintmfYUu3gS8IXE/JcbYU2667+kai750
	6tMNyST+AaYgCxgppi97PDTLO0Ru6iQUTz0eMRDWvCLzpFnh40Pr46eaV2sY+1/2Cks7OkHq/8T
	vEAE3JVk/EYs=
X-Received: by 2002:a05:622a:342:b0:532:8ed7:534 with SMTP id d75a77b69052e-53fcb7f9e76mr15856551cf.37.1793144820933;
        Tue, 27 Oct 2026 16:47:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a69129sm114200426d6.4.2026.10.27.16.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 16:47:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xLqsc-0000000BHke-3ly0;
	Tue, 27 Oct 2026 20:46:58 -0300
Date: Tue, 27 Oct 2026 20:46:58 -0300
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
Message-ID: <20261027234658.GL1685504@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <592d643f-e97d-4de8-9a87-e47d57dc8457@intel.com>
 <20261027193629.GK1685504@ziepe.ca>
 <5f33aeed-a20d-4881-9ccf-a69bc308d348@intel.com>
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
In-Reply-To: <5f33aeed-a20d-4881-9ccf-a69bc308d348@intel.com>

On Tue, Oct 27, 2026 at 04:09:19PM -0700, Dave Jiang wrote:

> There are two issues for TDX Connect. One, the device info is collected at
> SPDM connect (TDH.SPDM.CONNECT), not at lock. TDH.TDI.BIND only returns the
> interface report. So the measurements a TD sees at lock can be from well
> before the lock. To get measurements taken after the bind, the TD has to
> ask the VMM for a recollection with its own nonce.

IMHO measurements taken before lock must never be made visible through
this interface, it defeats the security property of evidence within
the locked session. I would expect the guest kernel TDX driver to
prevent this.
 
> Second, a device may take a runtime firmware update of equal or higher SVN
> while its TDIs stay locked, unless the lock sets NO_FW_UPDATE. The
> TD isn't

Sure, any of the live update things are not really relevant, the
evidence can change asynchronously and without notification, so we can
just ignore the issue. If the guest opts into live update then it can
only rely on things like min svn.

> > I'm a bit puzzled by this optional challenge concept, I haven't tried
> > to read SPDM spec yet, but it really has a way to omit the challenge
> > from the reply? It doesn't just replace it with 0 or something?
> 
> SPDM puts the requester's nonce in the GET_MEASUREMENTS request, and only when
> the request asks for a signature. The MEASUREMENTS response always carries the
> responder's own nonce, and the signature covers the request too. An unsigned
> request has no nonce and gets an unsigned response.

Returning an unsigned collection seems like an interesting use case,
but why would you want to do that in the first place?

> The empty challenge in my provider means something else though: don't
> recollect, return the evidence collected earlier. So it's less "omit the
> nonce" and more "no new collection". Maybe that's better as an explicit flag
> than an empty challenge?

I'm not sure 'no new collection' is an especially useful thing. Since
the kernel won't be validating the signature you still need to pass
the expected nonce from the prior collection back to userspace so it
can check it.

Is there some specific use case for this?

> >> 6. tdx_attestation_test's discovery_and_construction_fields expects an
> >>    inheritance chain of 4, but the TDX family inherits ctlv-attestation
> >>    directly, which gives 3. In a real TDX guest it fails with
> >>    "Expected 4 (4) == ctlv_chain_len(self->dev) (3)".
> > 
> > I would have naively guessed this should inherent from some SPDM family?
> 
> The TDX family is the TD's own attestation (TD report, Quote and RTMRs), with
> no device or SPDM in it. In wip_attestation_all_1 it inherits ctlv-attestation
> directly, so I think the test's 4 is what's stale. Jiri would know for sure.

I think TDX report/quote/rtmrs should be a different familiy from TDX device
assignment SPDM. They are completely different things.

Jason
