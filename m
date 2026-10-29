Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268474;
	b=v0EiWDoNtXiOXp6qzP1a7Kjw2NmFC+WJSW4dC9cuiwK5u9HvOiw0C2Pb6W/0o2iaXv2G
	 v5c/ijSERND3011PGzyfYeFyRKF6C2ImqK/quMPp4utCvWy/lQfTUMuUrwKKWFfSXHqYj
	 eWpV0fQyoufKih5z/U/1NAhcQSCZzvESGjmxXGIfaGx9jnsMWBeQMVfbnKygQJB1Gu3Uv
	 2qFtQMxW3whYl29A857ORXYL+8gS2479xAQfY9UgiiulKdXl1WfT0mRwHUpkRYyceOqHe
	 D2/4pi9g4H/nw4md3ilqefpkd8+6aw2SfV6c96uT5THyZBhtyTU751Zm/rBOWbIc92g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268474;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=wgroa5qxrEZgRV1TzlPeAteJauIXp9n4MbPCfUIQ4C8=;
	b=txBB8h+I7rK/LGjLYJys/Rp/eSxV9yVzB2JPRYJqyrEawezMLVDxC3w9uTLp1AfU4dcS
	 1lc2hJsdv72IFKbKr/7f1vZ17SBt4Vx+e0y1HBc6kDpdBgxQwHmg6CNY3wD+PU7Gk5zWK
	 Zx0QR4XxVE7cfclzwuolBMxD+j92bd6XCJHgxiXkxkSX86yRcF5RlxOVDzMOjZ25ZOJI/
	 IfLFc3+ebzm6QodjhhrmGcAmA1dflG3n2Pz3c9kE9oOQCv8fRbTSHcg5OKtCYlujBqG1U
	 UIl0IqCFamyVA5XowOkImpDJshS5kigFrN6WHoM6arS4IgU815eRWueBmYmmiBqlOBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b="MCGV9df/";
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F09606A320
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 10:07:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8F09606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=MCGV9df/
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c40e02b2ebaso303783366b.1
        for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 03:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793268472; x=1793873272; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wgroa5qxrEZgRV1TzlPeAteJauIXp9n4MbPCfUIQ4C8=;
        b=MCGV9df/7k4ajBlFLNzpnpiyVP554R79li/56qz4JFgvKSV4eMPHTSDzDtiO+v0OXG
         amQcqEYKMIKb06gnn3dwytNvTkYChDHgYHuD1GcIs6YsflunLHI2CEtw25RALpdQtNDn
         5Se6m2V7pofQQZhstlbmMVyRNnXfrt8FDQidCK2DCySntXp3eXIjMIwGd3GBhkoA+M+R
         o/hwUoFTvZnV2wRrJeYXyGpoR6GETTnHQqYkHF1me+YT7LsyP8KIuGgUQ5bQ0SaQ8CmY
         I+L4iyO5i6YI0hE+HABSCmQHgKTuOcQH2FfxU2YTP2MUN3qxImSYhWmC5V41uQuPOFab
         nvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793268472; x=1793873272;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wgroa5qxrEZgRV1TzlPeAteJauIXp9n4MbPCfUIQ4C8=;
        b=TKmQrKXx8mTlYUVJP7+dAE7LjOqBqvauXgGmLcGdAuQQ3gN1LVsVIa0oISY3FqUt/h
         gtW1x1W2Dg0Oz0mv9yxj949l+S2BHoi7hOM8AITM1UG1O8fdmecBUYNXx5VqwIZqQ8xL
         ne6NqWzMnyZaiiP35a/ajdUT6fRShswfBDdvzcvh4F2kbzrTZzIOFuqj8PbAcqFJm0Q3
         q4DZLuHYo/x7RcAj/CcG3m3ldq1ST5c8nDs4PC05suy3C2jZxV1LKzu6yw4cSP/yRywQ
         Kv6qyeAuYsc4wjiENsbwZDrUCLun7+fEodK5npu/Qba3eFmh/+K0puT0Y6t8VtQ+HI67
         uWQg==
X-Forwarded-Encrypted: i=1; AKwUvBx/VjJNGCiLA69YNm76gdhLiXjNvl8PHsZ3TKAiH0lJpMf+GZmycuVhdsZyTdDvHbMSVkADa+c3ykA=@vger.kernel.org
X-Gm-Message-State: AFq9FYLkwQOFZxQkHBRokTulLrPqCm0Z/4JT/g2bk2dzVujJfJGpPA5f
	pcOrqvuRMi5r3lgRpEPZBR+u+GWBoCXIu5nXXG3Ew7xVjKWNGgpBINVY23Zyb8IhatI=
X-Gm-Gg: AYBFou3Ilts+787cBYaLqF/cfqo06eCf/QhetLK5EauzLS7qnYwPWOvd91SyMAfJGOU
	+yAf+wB1zxc8TTMt+0HhVFcUr0nTdpS3/jqT8L04fWR7knf6DZrGUB3ZLTUn5fP9TllRBlQsSXe
	d3KnSvsMrZvy0ZEQSSSd+JuWJQkoOBt5ETszKeELe22z7TWjjXciwYCGxDSF+KDv6qM7wCoe9m2
	b7vmO+vb2yfzDVlS7IsgxqNiP/A9/TUBLdRZ4M++2brSLbqTUWJM47Juydz+qZ1ocdv8YWAPtAB
	9k5ta4rMrTrB5quYFZQ+/2HLR+np1CCfMELNuuf9D5nWnAPGMNjU3kFquAdlmL1xmMbt3EWpaXY
	qwtzDTG3ReEx+DfmY7waHxXpBcv/YqscS2nqpEw415mIqLGJiqeCfPtesYc3o1MFj5s74jy3BOv
	goxUOBQSJpf8kwQ4y8qZJKSRzG6qUsdNl1ja6gbbGsaPqYnQ14UXu7SdHRJ1bOBTb/yU4w2Kk1n
	udMDau0z+16yidCW0Sglk5ltcPqnMgsqE3HDxJsz6ibZYj+ESqgiI8eKfuUxErgKypIyPm/rUK8
	qXE7EQ4fu1TjJiAgQPL9VXrDut27gwL76SZMnA==
X-Received: by 2002:a17:907:9405:b0:c49:8d28:73ad with SMTP id a640c23a62f3a-c49be020e3dmr404569566b.49.1793268472113;
        Thu, 29 Oct 2026 03:07:52 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd520838sm715397566b.31.2026.10.29.03.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 03:07:51 -0700 (PDT)
Date: Thu, 29 Oct 2026 11:07:47 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <auMahpRIeL-Dkytk@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <592d643f-e97d-4de8-9a87-e47d57dc8457@intel.com>
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
In-Reply-To: <592d643f-e97d-4de8-9a87-e47d57dc8457@intel.com>

Tue, Oct 27, 2026 at 07:43:04PM +0100, dave.jiang@intel.com wrote:
>
>
>On 10/15/26 7:50 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 

[..]


>3. Jason asked on 14/20 whether anyone needs a variable-length challenge. I
>   don't think devices need a range. A plain read sends an empty challenge, and
>   an SPDM GET_MEASUREMENTS nonce is "NL = 32 or 0". Your TDX provider always
>   takes 64 (attestation_tdx_evidence_caps).

https://lore.kernel.org/all/auMX4kbsflE9kK3Q@FV6GYCPJ69/

>
>   A device needs exactly two lengths: 0 for a plain read and 32 for a refresh.
>   struct attestation_evidence_caps only holds a single min/max range. It's
>   checked on every request in attestation_evidence_request_decode(), and any
>   range that allows both 0 and 32 also allows everything in between.
>
>   To work around that, my provider declares 0-64 and PCI/TSM rejects any length

Perhaps just omit the challenge attr in that case would be the best way?


>   other than the backend's nonce size, 32 for both backends I ran. Could the
>   caps give one exact challenge length instead of a range, plus a flag that
>   also allows an empty challenge? A device provider would set 32 with the flag,
>   and your TDX provider 64 without it.
>

[..]
