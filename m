Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792571629;
	b=zPapHt7+DK2PQfuTT2XBVekAWyq7ylGMLIyyH7ymPSTbOuY0s/b/vwWde6PMfpBunb5A
	 oMXay3Z7Tcyxb/df0/61KhfcPoBTQ9JwafzTU87oNqIJSyFYGanudL/ERhxab0KYiWpvs
	 uwzDdfDzV951l6Apag18rsHF6Kzhq7tMaSSJK95wztqXrFP7+QvM/p6zo9e/kuDWB6wRk
	 FXX79JqofoJznmmJhtLipgGvpc1piN7z4xKTyJl5izt20/U0iTD5wsZYHpCQGP/EU+IJv
	 SMVashRPfySr7hM/u8I6YWdNMsX2KD6qdY12Ih144ocbB+Lan2wbWK5Eo/3E7Rw33vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571629;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=xztp8CA2EuYwLkJWXTD7L/r6UpbaCRk0H8KiI8WbX/0=;
	b=Sfy8rwVmXEuNkLbWoILgVPzEfVvMtymy3IEN6gvX4p07aF277P/ib55HqBJKQ0i8eDu7
	 lJJ1ZmbnCwLcSFs6CO1JfQNdaKPyuPKMi43ue6xOpGxThVVjy1X8StB7xq0ctnknkXdOG
	 uISL+szCKtmjNrQ+VdckWyL6pM+CV/jGiceMxSfuYKHW6h5I5vNzBmculvm9Bn0Bw24DM
	 ziuoh1lDq0Y1eKPeYRroppZHUxq9xkkf7HQmXHW3fFYb5mUAA4ZHvU98N4tKiLq+hgywt
	 wq0K2sWrSrvcQfxEgqcdcGX1Dl/QrWHPYo526fj5MmvqdsvdxU/xcxvpKFA+bfHzscg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=resnulli.us;
	spf=none smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=r1hMRlHN;
	arc=none smtp.remote-ip=209.85.208.177
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DBF606A320
	for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 08:33:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3DBF606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=r1hMRlHN
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3a808f09021so3569431fa.0
        for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 01:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1792571626; x=1793176426; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xztp8CA2EuYwLkJWXTD7L/r6UpbaCRk0H8KiI8WbX/0=;
        b=r1hMRlHNKxIdoWis5K35C0U6pBm/7vNAgzUYPNgxOyTuaDmbox0SdKa3Ggu77kAXo9
         rx0sLojY9MY9eLFQIVMHli3lNQZF2pRQk1oj9UIPHdLe+glHwLaXZMBcNRKoKzrAGHCm
         RLbhUnQIZKY/yfqBWeMKXDCbkqoQKxbCGe9L2+zfRkPFrs/VO6vJRcJF9R6Lh6G4gaTz
         TGLocTMhr3rye1aGRVzJwZyy8sUY+ZPXNgASDnkSNH6lSPL7LJ5xacv81opcvCqAzqkh
         PYvYMLTGXfSCpamswAeCascR7b80RgejQnTkoh6SIcsrWyzSurXxqIr7FEhSXISWAsPj
         bDMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571626; x=1793176426;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xztp8CA2EuYwLkJWXTD7L/r6UpbaCRk0H8KiI8WbX/0=;
        b=vfeveOeSH4KcAt1dl6M9jwLbsmxbP2iVQD/pxcC0dsYsh9akrlGwFEDT5ICahF5kON
         S39wBoYIaS/IC2ixwH9gD2RkQz+/StlCGeDA/jMJn3WhTY/whaoHgDkGBmUXfQFCI9Xy
         CAp0QgxqFt2KjakFir8vY4Iq+I/+BvmBd4dlm0GhKfTyN7uLD1Izllz5cC16eZxpSer2
         coGU95Axofhou6xENs3dPlJE9TY0VCtE4Ve+TM+y2xIZOznFAIw2/gZprIFhuJQZb883
         BTl+gemRvQrrd8m3Ob30jw2eiUxmy38i8rgLSUUsdF2xe9FkUi5NjW0zRVZ7Xw7n40I7
         HSsQ==
X-Forwarded-Encrypted: i=1; AKwUvBzazp4tEmTzlaszjLvYwusP/4EbbkpTZuoNTq5mL3zYR1D5x73GcsycKEhTFalsUSnso3/6X2aXwWA=@vger.kernel.org
X-Gm-Message-State: AFq9FYJsTI/lmmj3qcbAFYZhlAh0tdhBz+fWhgjOXSAgoRZdX/Bc398Z
	rbSTUQIKTbyljXJalDaHL4Hy5JK+wwiQHCcevrThzOvhHKCaXcyOmaM8j32wniba0qA=
X-Gm-Gg: AYBFou3NQUwnDs3eNNOYvyDJZmk8NEghdG44oPySlAra9WnzCn+BPUiPffthLEgLxE2
	noUFzMbbTsCKq2/yCBhTFB8ySEr58C6wNWZZpsNgbk6Enr1+Uw/gqJv0j5e1e5bsjOJhkJhyw8X
	bHoOj+02r/F4hcB0bzmyFNHHvlnBqwprQpVr+wX+cFz7P3ntu3ccBCfSzza6IoqMJecqtEJsGwa
	rykEgMvn2ERGWfvPmwsyWqnjX2d1FpNCTnHCYPyD5bBlw+bOq13bsUSohe+ecTeZf/+Nil+0i6v
	wB8KAzPjqdNzcMzZx8coXAjzdyiiFynKBFctM0DYfO9K4C2ifwzZHGGYey0MzPqCDtkmEkFoKg5
	AF2lb7V5NX5f/FAP6fQn5PzBLvEuppjUvlF6EK6q2o/KdNrv/cuXYOEUlY2PicIBcD1y6P9CLvW
	fIKrkg7swctnAq3nrDmluWazgNQ6AEiqHSNMjzgrkq57IrK7kPRokIbO+f0m4b1v2vy49e9ZJLF
	hRFoyMCQd6EBCOhXJ4td9BRogW/6/j+S69OrM9hnJuYfw2bv4VsfVmsiB8crlMnXLM=
X-Received: by 2002:a2e:be10:0:b0:3a6:692d:b7ed with SMTP id 38308e7fff4ca-3ac441af820mr4315381fa.20.1792571625331;
        Wed, 21 Oct 2026 01:33:45 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ac43772cb3sm4553341fa.16.2026.10.21.01.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 01:33:44 -0700 (PDT)
Date: Wed, 21 Oct 2026 10:33:42 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dionna Glaze <drdeeglaze@gmail.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
	cedric.xing@intel.com, sameo@meta.com, James.Bottomley@hansenpartnership.com, 
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com, 
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com, roberto.sassu@huawei.com, 
	zohar@linux.ibm.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com>
 <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <20261019225658.GS13920@nvidia.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261019225658.GS13920@nvidia.com>

Tue, Oct 20, 2026 at 12:56:58AM +0200, jgg@nvidia.com wrote:
>On Mon, Oct 19, 2026 at 09:10:31AM -0700, Dionna Glaze wrote:
>> On Mon, Oct 19, 2026 at 5:08 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> >
>> > Yeah, I was thinking about this and went back and forth. In the end, the
>> > only reason for leaving it unbounded is to allow multiple independent
>> > users of the same register. For example, IMA and systemd could share a
>> > TDX RTMR. The systemd side would read the journal through the
>> > attestation device and the IMA side through securityfs, but both are
>> > views of the same journal. If one side truncated it, the other could no
>> > longer replay the RTMR. Isn't this the valid usecase? Do you see how to
>> > resolve this?
>> >
>> 
>> Bright minds have spent a significant amount of time working on this.
>> 
>> +Roberto Sassu, +Mimi Zohar
>> IMA logs and systemd logs are both system level concerns that are
>> relevant to the OS construction, not individual users,
>> so I would just say to reroute IMA to use ctlv using a kernel config
>> setting, then make systemd the new system manager of the holistic log.
>> The securityfs log contents can simply say, "log managed by ctlv" in
>> this setting, in the form of the template identifier.
>> For policy violations, only the 0... extend needs to go to ctlv.
>> IMA can still keep its violation log as a ring buffer when it's not a
>> 1-to-1 violation to extension
>> https://www.youtube.com/watch?v=gyYUYbdiN_4
>
>I think for now we should not include a new dynamic log here, the uAPI
>around this Jiri drafted can remain a future step. I don't want to
>open complicated discussions about new functionality at this
>stage. The whole CTLV idea in general is a big enough thing to bite
>off for this series.

Okay, dropping the log from this set.

[..]
