Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793887384;
	b=qmqD7n8B7YEXWaCJkl1/ixSGRhacl/WfEQwS5Bu3Wung50eJIBI2mTq76v7s+JI10POV
	 Pc+xIZi57XJ7L7Vsulo0TsXYxRGtq0MwNhTKql14Ru3UhkGZM5KISo+Z4e2IMVL91ie/f
	 s+WL+0k65CrHQH34AixcoDXGvhYms+Bcvp1QqfB0IrSM0BTYRqTY59uSYkq8p8oRlaF6J
	 wClAEYxgg2V8o9YUDoVYGlGE/KQSFDNZ5G+6osUXRjB8T8/LDeS5EffGPjbtGLr62Kz28
	 /+Hoi4bD3VbJh9VeOsqSUQjb4JvSju2thzR+hiZkInsQkAFD4m3QN+gVYyYCOO45Wiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793887384;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=7rw+Vw2Z3L2B8lNDfsIFSmx/pfSm9WeDfRFG4S2Q0cI=;
	b=xPfLt9NPet3RwnY4W1bZkdwT8geW05wc7y0TR9fi4USMKKkpCIBdAWP9zsC/SxWNbO56
	 IgIGwmg3ieoAKt/vxvRRjALRW9tmqgh/0oMehBaeqIF/64wruI/+mPVLzWMyzA3cnzvre
	 g8I4IXJzKSOfIkzKBFjP8JTdZzb3hGZpoSkrdq1/XODpqfV2nF0jpgZsHC1uEMnwpB9ed
	 EUGNfow9NJuSixzx6Bjw14t6WtxcoTDw8LN1n8rXgZdEsHWYiPO+kThEAHh1FfNg32xxS
	 1J6ksnTcALDV6IniUJVwNcKaVj+z4NTK1Aw6emJXTy9qs2OPzCFEIaNO8fZty64CcOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974CF606A336
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 14:02:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 974CF606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-491f34b4e0fso244212f8f.2
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 06:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793887377; x=1794492177; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7rw+Vw2Z3L2B8lNDfsIFSmx/pfSm9WeDfRFG4S2Q0cI=;
        b=wcPW2VeSRvODbdYagFsU2XIg0aTXdnhx/kXOwWNbpngwDM/gCfcZrWORghX1FKTjDc
         Mv5N2+vmUnjqQm9dS9NB6DBVam/f0NDbeQqt4+86O0cpG537XPDtso4cmVRWMyArr8PI
         jXiPqpbCMNpRwt04pZ64rNnRkpc1jgKy9F7LZJn034x7mHjW9lWeHDZ8wuGAGcsp9tA6
         fdYaq4RLqyMu+odlklcLb3/vkf+rq5ENmZYu7oz4AZdq4mhjZAN+ODbuapfT9A5hM+9n
         IBsHWEC4PC7xOlWAsj92te775B+ABgmDcVqt7oltV+jbn2ZKpApmiWB2SPL7l15TkecI
         7lpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793887377; x=1794492177;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7rw+Vw2Z3L2B8lNDfsIFSmx/pfSm9WeDfRFG4S2Q0cI=;
        b=ZckG8wAHQKPzps8u/SGWbhWeR4KNG3/zGTYlFGlet2EC8I15Y9Z9rQXJID6PbGlGYl
         FvuKvxuDqeWRcejnYVMh6QFoSYKHWqyHIZuHNmxa4o/KH2Bsw+OlVup7uM8jaouF2ee4
         1du3K2/oMMft4egEtEqZqlpeXEyZic9+s8fjIxYV0Oa2PJkKfskPVWabWJBWLNMXWoJy
         qCDq9tmiO6czyayLp9ZVugNbb96KnHJUZpBWA0FVUvXsjFUg09CrM1R4F75pY1S67fka
         JvZI8ZM1/XbIehD0A4R3fnw9iWQPpkA1FqUJi6gg1OXYtH9Dt7azo/mh4XDtiZhRiu7Z
         CMEw==
X-Forwarded-Encrypted: i=1; AKwUvBzX+X8KKq9Tk5ZaMUQainAggnrukSj3fWihNFjiN5dqKVOn+FQhHb0HmULNY4dliUpJ7W42yvNruas=@vger.kernel.org
X-Gm-Message-State: APuU4Z+I8QJCU9c/Po0+VY7Rx+yqF03GtJe/8Cv0td5a6Y9pd5qojHBB
	OnFPXwj3Lvpu0pkE5L0EhfBxusnzbcgeYcaKqFRuqIPn+np74f99FH1Ro6r1s3BYuOk=
X-Gm-Gg: AYBFou3QL9m0GagAEgmCFTyD1JBCsOEWcJ0CrreJPJaI/lkXC6t/WjEgcQR/O6NI0Fb
	OULgZo53BG1yU28T+YCtqD9y9w6a4EwjhNKIP0gkmGNaA0CKP4g6gKUbO4sMcSQ7Ot8JqBjlSZ9
	725JgZOPtNKyMrifZ2AOtE2boz4xLRzBNCbFb/opANsatcIL1jDF7ulWC8pOsl+zUfGjO/pReJI
	7mfKYiB7+LqdNIxW5kRlEWXKPm1fw/ilz5YkbxAjL37F8eeUCar2HzGE0LNtUWt4Gol/WgbCN2k
	x0mfBX9tNDbl2KtO69Z1fDMIFXyZcXd4Ep8/K7KguUBsq8QuXrwKrlyyNd9CBrjm313k8+Ef0G9
	XwRpIzeXTEHA7Gj8ZZFLLIYmO2QeJLtExXnpgwQLGQn/Glqof3/DkQJxlaAgDac0kSt89uETdL3
	4/2IHN/dwbv6s0N/QgBps0//bi4jaJqFXFAOHlWimSaNyaie3cjIspxRUW3ToWN23jYy4a9K/bD
	ODFC4bKnrcAPlWNwu2HMDNDKZFRs+VWV/0TfJnjIg+p//COWqgsMcx1+aua4FTMAiFgRGIDEEIC
	rweDzrIioAyMtqmCnDxE2ExZgmmxNqqtmUi4uj8=
X-Received: by 2002:a05:6000:310f:b0:48d:f95e:6e8 with SMTP id ffacd0b85a97d-48e6e2c3586mr39104058f8f.1.1793887376849;
        Thu, 05 Nov 2026 06:02:56 -0800 (PST)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fec8d8e29sm10937240f8f.19.2026.11.05.06.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:02:56 -0800 (PST)
Date: Thu, 5 Nov 2026 15:02:52 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 14/20] attestation: Add the base family specification
 and generated files
Message-ID: <auyKhc02JmfXNiMe@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-15-jiri@resnulli.us>
 <179302367452.58760.3782556786585774917.b4-review@b4>
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
In-Reply-To: <179302367452.58760.3782556786585774917.b4-review@b4>

Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:

[..]

>
>evidence-get:
>  request:
>    challenge: binary
>
>Binary, blob, raw? Lots of words for the same idea here..

binary is inline field, blob is va/memfd/dmabuf using field. I want to
keep these to "types" of TLV separate.


>
>    objects[]:
>      blob-class: evidence-blob-class
>      format: string
>      representation: evidence-representation
>      data: output-blob
>  reply:
>    object-lengths[]: uint
>    mr-generation?: uint
>
>=======
>
>mr-get:
>  request:
>    id: uint
>  reply:
>    name: string
>    supported-hash-algorithms[]: uint
>
>No definition what these numbers are. They should be TCG2 defined hash
>algorithm constants I guess. Why not have an enum here for them?

it's enum hash_algo - I will make it more explicit including existing
c enums into yaml.


>
>    caps: mr-caps
>    register-index?: uint
>
>So we get a string and a small integer for every MR? Like PCR10 and 10
>for TPM?

Yes. The name is the platform's and the index is the hardware's number,
where it has one. TDX has mrtd without an index and rtmr0-rtmr3 with
0-3. A TPM would have pcr10 and 10.


[..]


>
>=======
>
>mr-extend:
>  request:
>    id: uint
>    values[]:
>      hash-algo: uint
>      data: binary
>  reply:
>    generation: uint
>
>Is this extend 'you give me an exactly sized data that is a hash' or
>'you give me data and I hash it' ?
>
>TPM/etc do both, there are good reasons to have both, and the latter
>is more flexible in supporting crypto agility..

The former. I have a patch in a queue that adds the latter: mr-extend
takes either a digest per bank or the data, as an input blob, which the
kernel hashes with the algorithm of each bank, and the reply returns
the digests the banks were extended by.

