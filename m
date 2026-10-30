Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793353215;
	b=gMGvIUwF1lKBWWDqC2qwTXo626IFjxO+X8XVPPgG+/IkMuprR41sy6vFLCDEws1lV3AE
	 rltLyNqk8cDCVmJ4o9jAVrJip0waBlB5MiSNLGUAogTAoidjEnSKicfJeX+JzuDa4yiIx
	 xybO1kN4NHtJljy7ozVF5si3RGDJvZrHq+lIycLSaNqZ+EeIXZKNsaw4RG+objSBuw3sj
	 zgY/uLI6Zuwk9cU3gMsRPrHHlbQCTayGzGdpQfx+dw7uFUhlH9dKe98V2etXf/r7o6rIK
	 852VuGeXgmd0Vb7F6bDM32WTxKKII8YbEaGwb0lSny+z9JvXZPxjByMp7+/6hhBevCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793353215;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=La278T1NrCS4XO98Q/cTkbnnx/6adToIXrUcsW5BqDY=;
	b=itT8irNgm5xQ+QIQmCppMRl2f9ZBcXQrXBvXUh/64qFvpMUCiu6dBCen0wkGZZ05S8DO
	 kl/+xxDC4WjAP7ZZc77HAN+PMrj3VnKBCCOOb2lWhKVbJgT3xEtHzbIZxSXrBhtT4X3Zt
	 6WHhrOKCm80KePX1/JjELokzZLIXqz3KvoZhwKc0yCDQ2gDd8ktcWogRkB+WvromNESmm
	 GtZvSCttbwPQhN6yid6FzTbKCPcoDiQWyytDX+TYtCqDA0n6zdcfwgTfTheB8j4aHEONU
	 hHwGMH1yuBg7+GIDrHPsNyocahxWU99fLstOlwbtmn1UEpfE9nqlrFcmGSGZwR0njbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.167.51
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B02606A32D
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 09:40:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3B02606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5ba3ec92031so691769e87.2
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 02:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793353213; x=1793958013; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=La278T1NrCS4XO98Q/cTkbnnx/6adToIXrUcsW5BqDY=;
        b=Kv4m9vJR6R9/MCQPr8oImYroO5YLgSVS0DYGIvONwSH5eZkPBnkxNVp6UbPLFqhzJa
         mHwnam4KotFiiw2rxYegY1kWtGQiTINkwVf+f0Y+u2QzIsLuF3DneFaKE20yzTnkJvUL
         70+rwPeuEdD8KBv3DlclPXB2VFwYGOM9bVM++la8LT/SMXM8wnof4b6Sr9VGEuhyM5qi
         DH8zSsN+nlr7X7dPGz8SzGu1UlqoriuFXy1G9JxtzUCbp+ogvr7v5xumXPOz5NJ/Vd0Y
         /RvkMRt3ErRcgH7pb13vlNxMeCRHTiaIzHOaKj6JlTsxLzPyaWS/IEGF7NiBV8mjUXk9
         vdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793353213; x=1793958013;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=La278T1NrCS4XO98Q/cTkbnnx/6adToIXrUcsW5BqDY=;
        b=HNY2ynho2r1L7tK1Gw1R+S51qtNAGSJQ6WMQqvwwnt4eZwFqqVhzizItXxhoxzGnll
         0pWdjIVqnvVYvfN/AqW/AxR6YxZohYxBY0Ffo682O1M8W1QcPIcCJr0zfaTC1xGU/9mq
         NWsEk/6sMGUIKTuTvs6m9DFlbLpnqM/j71Umyoq5Nn/Gzzc9nE/dYWc1HII2UC7m8xCg
         LB+lMgAVAGBFgc0QfpNWabBE0tFgpx9Cb6L7lLfG7fdMo4pumxEbaurGFi7wVvRhQC5L
         Ef/O6k/u7iCxy/OOpbS0EsVn1XH1N0jxgde0MlF/uFXUXEpztxToMIl3XPv85Q5huva+
         m+KQ==
X-Forwarded-Encrypted: i=1; AKwUvBzthZ8gUG4CWl0ZinJCIYXgcHGD+TIgJCFMTKQEn2TBTvljAwk9N0t9JDFd2QnP5q7iZ/MY6cYztz8=@vger.kernel.org
X-Gm-Message-State: AFq9FYK4AzQfALimygC1xhhj4HpIFd7O5MsdvjkZM5wGu0MoYs+Wt7ek
	wCjStgWwDpNXS001T+EKA4iXzAIrpn40n+11i9VbEBwBCqmueZ6tLanyaTsEi4HIgus=
X-Gm-Gg: AYBFou14cZIaiLeLBEooxfsQ1lRhbnQGAnzXTsqZ00F3Vav4legZU+9h/7KJm/o0aUQ
	naZFCGSHWYwxz+CK/qBamfFzKEzeDE+L7usLbWD53cJng0uBD2tmbHvv+SGHb1AHDnFc9iiSfnc
	0y2dyZ14RZ8Srd77oz2SHCBWbvu2W+wFyKk1WHgjkUJ155SSB0VVHRCjKFfjRwkNr4wC/qs0HLq
	WSk5zlNNYCTzFWCNeURXi2qqxneGC8NOyZrtMhIENiPjU2xnjlRXPnZ9uS3lFnG4ZYpofTwcr5d
	X93gNtSLIbegp1b6lv6Z+E4BeH2X/2FDF8kxSJsIpcywajZWXT/lw1is7R9WeACJW3yor5ae2MY
	isqtBWzQ30nmnRFJYqaRULfHMR5ddgpqEdwkh5Ky0r4MDzU59vXmotlj2AL64QsLzlIUVZlfxsi
	kqwLpKC17niaF0/Ccn2GAuZYJWBWA4RU6aQISQv01EyA6oPkW2vaxdHdsglpj6HNulsjHis0emf
	Zm58QUUz7GyyD09/3Q+C/Iv82f0vaYsD2WM4o3jIk8xVqyvU+PnXEAvdRVbRCTnQBZ3KeW7FW5u
	xw5DC7D+NQoERt2Xjf0s/hRIZhyyExzeTK785A==
X-Received: by 2002:a05:6512:668b:20b0:5bf:da1f:c390 with SMTP id 2adb3069b0e04-5bfda1fc9c2mr262942e87.36.1793353212517;
        Fri, 30 Oct 2026 02:40:12 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfdc08ea60sm221364e87.33.2026.10.30.02.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 02:40:10 -0700 (PDT)
Date: Fri, 30 Oct 2026 10:40:05 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 11/20] ctlv: Prepare runtime introspection
Message-ID: <auRl4VzVljAQ1Suy@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-12-jiri@resnulli.us>
 <179302367452.58760.11808905856343064399.b4-review@b4>
 <at9nsxtGOl3N5PJR@FV6GYCPJ69>
 <20261026161220.GA1671235@nvidia.com>
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
In-Reply-To: <20261026161220.GA1671235@nvidia.com>

Mon, Oct 26, 2026 at 05:12:20PM +0100, jgg@nvidia.com wrote:
>On Mon, Oct 26, 2026 at 03:52:30PM +0100, Jiri Pirko wrote:
>> >device-get:
>> >  request: {}
>> >  reply:
>> >    caps:
>> >      evidence?:
>> >        min-challenge-length: uint
>> >        max-challenge-length: uint
>> >        max-total-output-length: uint
>> >        objects[]:
>> >          blob-class: evidence-blob-class
>> >          format: string
>> >          representation: evidence-representation
>> >          max-length: uint
>> >      mr?:
>> >        mr-flags: mr-device-caps
>> >    info:
>> >      $extend: device-info
>> >
>> >So.. how about could we drop the sets, use a direct description of the
>> >layout and do something else for the ID numbering? Maybe the numbering
>> >can be solved directly by only listing the names in:
>> 
>> I didn't want to have a lot of duplications. Netlink show us that the
>> same attr, or attr group (or nest) is often used in multiple ops. It is
>> not good to repeat them each time (multiple obvious reasons), so I came
>> with the sets and groups. But I will think about how to make this
>> possible to be formatted in more readable way.
>
>If a "record" is re-used in multiple places, then sure, put it in one
>spot, not disagreeing with that.
>
>That can still work out with a clearer top down flow, more like C:
>
>records:
>   evidence-object:
>          blob-class: evidence-blob-class
>          format: string
>          representation: evidence-representation
>          max-length: uint
>
>ops:
>  device-get:
>    reply:
>      caps:
>       evidence?:
>	 objects[]: record evidence-object
>
>Jason

Okay, I like it.

