Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815035;
	b=c5HZ6r2BLwuaUAuZD1cmHubvuZnng9SBxEetvgjdTcJX55+bR5qjIqz4tBNwHr9dh2Rl
	 uo3GiSuKiwe73Jlghn3is3pUa3ZVp7F8qOyWtz9zCnuWDm1MAs9Vs3omRN0lD77A3OKKo
	 pAjklqis03kYn55Zu/ioiOfI3p6esUfHr+VgJY1MCuQtdPSNjrWB8vK6LX8WTC31IhH+v
	 2H4RGJFaMSInoR1NGL6CNepXJ/jYvxnuhGrPsqAPhn9yMmFt9RCTSr0AtU6QrS1EbQ6Cw
	 q/kfLO/ZktyV4on1TLL6ehw77pn62gwIS8BatYNxVu5i8g1cETnpEAjQGH5LEipQv9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815035;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=u6+Lf/8gHZf1IKHjq4H+ss02XIxxzMA/c7y+z6oAgJc=;
	b=b1dfs1leXO/MMQy45d+ALEgxs2zIbopQkp9cWjOuUrOiqn0Lp5iIn8b8FZSxAWa9WeZJ
	 /WVk87HEjJb8psvZKF166qCGwe44ky1x3yRUpKiEQC3QaFBfEjGo6I2F5cJ43QcylM2jJ
	 NXm8QH14rLyqFf5Z0Oru9Je2XlopjJGxBdphq11SrEO0/ba7Pvr2gIxFq510q8XzVSc0P
	 kbc07QfcYVaj6l70lG4yNntauh7KINvlO0vx3H0gaTUxnNXUPI0+fs5FMqrkgPnrxEq0B
	 UtiM5jiSB8dGvLabKsyOR8iYgI8LMKpr4TrH0tQ8wyR2/2Qonlxh2qlZV/PqVfh+Mag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	arc=none smtp.remote-ip=209.85.160.175
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19018607168E
	for <linux-api@vger.kernel.org>; Wed,  4 Nov 2026 17:57:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19018607168E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-533797e72e8so5969831cf.2
        for <linux-api@vger.kernel.org>; Wed, 04 Nov 2026 09:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793815029; x=1794419829; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u6+Lf/8gHZf1IKHjq4H+ss02XIxxzMA/c7y+z6oAgJc=;
        b=jSpTFwGrGxYp4V4QZz2ba5dYIoDJJuxWjxKzx8KifYjFiBa0ODGbZD1ZEEW7S/WD0T
         Uh/eSnAdhC0igsZSTinaNwZ4d/bVNxNVLR0SLBhFpcfR//v8TwO6mWhjarmiAGHvyd/R
         eexkK+c4Gy+NJuptHuPNZ54oZFyCFRniuibxorEQrulnSaF5/g4Ne6nK4G/A+pa2SYyO
         6VfYSM9ZMa476+obumWFBoY+RomdwnrNryQ/m7ngxfEuyZ57ZyO3Quffa1K8yWwxMq9m
         PI1/0vFyzZ7alsgF2rxdyGUkXrbSK26XBu/pXg8rzUuwGjiFyUH5CdTcpJmTHMDmmIvS
         oFLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793815029; x=1794419829;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u6+Lf/8gHZf1IKHjq4H+ss02XIxxzMA/c7y+z6oAgJc=;
        b=Y4dzCOUfgWh7IsA9hF7r8gHoIl+hJZEmVachMaGUdw+61Xr+4i2BJhwCLFGlNq1ktp
         njGB/Fdb2pykAfU7VwCC1VIb5A6lWVG/whlG4257DW0fTtv117sxHKgTsd+aLVD0tX1W
         MnH+PNyJWpj/AMTqN2g877bmQE3vTw2/JBDg2199ini5nPo05MexU662UxAxGzfP5V+N
         Da01difM3js+rldPXAGqEVbaWE+Vw3Vg0UKWVin3An1iVOO19c6+sXIQoBrZFSYcKW6Q
         WxIjDn+lX1wo/D8FwABRoGqHUMC2b+4bz3OUEbKnmozD14LymPsLI0oKF0EoyuKIYeB9
         yB4Q==
X-Forwarded-Encrypted: i=1; AKwUvByszOOHVL2gWjDxB4ue/3urzdafVD4d9Xa8b6N4fvJyC3nHnenaMq4otpamKCeIYdA78Gz7KGcUyGQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z83rDhcOGVRK3onnzPjPDAAD7NFprRXoZmB3lg45GCTHwDYj9KZ
	k/YQfBxP/+RWPtO5kEcmvGPytCm1iZH6sC2rvNMBJn2uJTcAfFl8RyrDImvsqQvM5hs=
X-Gm-Gg: AYBFou2GZErp6j4XC/C7ASPAMiHgyy1otpEzUBWzJCNOKVLRy88X1X+E1JlYUl1bypb
	djy6KXOCA618Evr5R0i5CoXWOE8cF2CJHOoVp05HkU7DW1t2/e7WnqCoDaZBGzZRsTHXa7mdrhY
	KDLo9ZLozw8+9Imv5MzJ/k7xMvB4kDttOSWleThk/PZkgwmwgdYRwh6QNN8ivsUOtKIPq55UHSf
	bwJJ1ZSXpdULpGzd+FHSeF0KS+TdQD4Rty1ZbyK9TpMxqSBtE1CxZkc0simG1RhM/eyK3RQ6ISt
	kREwh+Apk/cdPNPX9e4qpO+/HmS9MDO64aWyQ2jmyI5wvvv7zPE0uswKe293XTQa6/t+q5wdMxl
	Jipv+f/HQbX6GuGbrgo1xVaUpJ+pEgIAizYyVaRSk47ZnXhoKoH6Ps7V9rzTDmvXU9+9/q2nrMY
	MLzS6gMlLMV/fbDxQuvR13atEknuSBdFE2AtT+haQjfVWkyHhU3GAsyhMmOqoa1+LfZWpiQRvoN
	0MRb72b+qo7k28J/5+K85jm3t0wkSVCnXOLXuidMYObRsFK/neu10c9iU+Qom/BjIrB0axetHwY
	FwskqLit31EM8OEbY9LWvs+Jp9XquVQeslvrIh8kncEwMLBPI2sZNW64hhd2jEBJxTVCIuz1dZM
	+ffN/T6FdZg==
X-Received: by 2002:ac8:5f08:0:b0:535:baa:a78d with SMTP id d75a77b69052e-542b3a728c4mr272645741cf.10.1793815029017;
        Wed, 04 Nov 2026 09:57:09 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54b10a6ca24sm30262291cf.14.2026.11.04.09.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 09:57:08 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xOfER-0000000H210-48gw;
	Wed, 04 Nov 2026 13:57:07 -0400
Date: Wed, 4 Nov 2026 13:57:07 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 11/20] ctlv: Prepare runtime introspection
Message-ID: <20261104175707.GA3889730@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-12-jiri@resnulli.us>
 <179302367452.58760.11808905856343064399.b4-review@b4>
 <auRmMPfaFINUIchi@FV6GYCPJ69>
 <20261103010537.GI3889730@ziepe.ca>
 <aumogVKtYnY0QJ2r@FV6GYCPJ69>
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
In-Reply-To: <aumogVKtYnY0QJ2r@FV6GYCPJ69>

On Tue, Nov 03, 2026 at 10:29:45AM +0100, Jiri Pirko wrote:
> Tue, Nov 03, 2026 at 02:05:37AM +0100, jgg@ziepe.ca wrote:
> >On Fri, Oct 30, 2026 at 10:53:11AM +0100, Jiri Pirko wrote:
> >> >So.. how about could we drop the sets, use a direct description of the
> >> >layout and do something else for the ID numbering? Maybe the numbering
> >> >can be solved directly by only listing the names in:
> >> >
> >> >numbering:
> >> >  - device-get.reply
> >> >  - device-get.reply.caps
> >> >  - device-get.caps.evidence
> >> >  -[..]
> >> >
> >> >?
> >> 
> >> I'm still committed to implicit numbering. For "inline records" I
> >> resolved it by having it encoded as a tree with 4 levels:
> >> 
> >>  63         48 47 46 45        32 31  28 27  24 23  20 19  16 15               0
> >> +-------------+-----+------------+------+------+------+------+------------------+
> >> |   family    |kind |   index    |  L1  |  L2  |  L3  |  L4  |      field       |
> >> +-------------+-----+------------+------+------+------+------+------------------+
> >>               |<------------------ record ------------------>|
> >
> >Fascinating idea. Sort of like an oid
> >
> >I guarentee we will run out of bits someday :) I saw recently we ran
> >out of bits in RDMA :\ 3 bits seems like quite a small number..
> 
> Well, this is just for inlines. I think if user comes to the point this
> will not be enough, he can use named record, as he probably should with
> more than 8 inline records anyway :) Also, we can introduce "mapping"
> mechanism to allow inline conversion to named record without breaking
> userspace. I just didn't bother to implement now as it is a theoretical
> problem now as I see it.

Oh OK, thats interesting.

Jason
