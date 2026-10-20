Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792488387;
	b=08YMBEngV8idc7BomdJ7+I1voew2mPvSVmCVx1n9cLz++4p4DdiEBB+kku1s2h014+3w
	 Qg1bqhMm+PgTQKIyPZAf7U+yDBoQ/lz8QByuB+fQdNkGBlJxxThI4HAgcw4X9toJbTD1C
	 0zYyrzgG8f5AhaDmGlA87T3ly8GO9tS+mjzLnp8v1+SbyzuyvVVVsG0eZiiJMWIa1Pw6R
	 WoZvVVSmIEe9jUi8r88L0SEnDNCn+xo1+vIdjIaqA3m6lGQokZ3B954QX9r2Nzw0S6OK4
	 ftD+uUsQyLNqQTlVbfY4tbsoqwgI40iiUV4pjRk5CiRzm33nMQ+u2f3eY/HPig09ZUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792488387;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=V62r2oyMwKweJj3yBSLKefUPJg8WZq8H2U6uQoCWZWk=;
	b=E9QTKipV+9kodonFjF0BzBh6fMFPLBBZD6FuJ95GrEOfc3hiuydjqbKD0rP75dUBDaxK
	 3YcHgRyOn33kVsrPe82Q3tjtzHCcAKhbNBW0lyi6NUTAYhufba7yHMDVR8yFoyneKYKM5
	 wkWuYCjuWmT4uZ47m5GsQwVz0s7BIDud1Xt0CqdnFcbiP7HmhtLrxvF+N5e7SlmGg3KGg
	 oQDbuyrl30jJlIflX8OmB+dTwQUJBgfJhrAIMDuA/TXz9dVDj6d0Shko5bXPzi3ZD/CKm
	 yazG+4UYWdKw4wmHMcH6nYy+zV25Z0NH+XJdrx3IShQ2y9AaTJJZPHDtaF3XfT0gZyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=resnulli.us;
	spf=none smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b="fhvCsC+/";
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0B7606A31B
	for <linux-api@vger.kernel.org>; Tue, 20 Oct 2026 09:26:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B0B7606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=fhvCsC+/
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48e011d370dso2451185f8f.0
        for <linux-api@vger.kernel.org>; Tue, 20 Oct 2026 02:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1792488382; x=1793093182; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V62r2oyMwKweJj3yBSLKefUPJg8WZq8H2U6uQoCWZWk=;
        b=fhvCsC+/L+1bMr0FsexCnKyo47rJycuSZvhM1BKIBfyQEvBc4uR/sxPFeFk4JgA7t6
         ZUkpMEKwzeepefXulk1T2CMQpi0g/pzzFgGmJrpUjsF3g+7REVFmvCtPKN9uVKJlpyhg
         SIXhOvTi1U/sZBl523YJrKCAFpZVjG1d+k0DGvO1WNKY4v0xlGsLDYiPW+FaRySiti+e
         KKRSVX3h0x1tMIjBGVVVSsR9Jr+yzC3/MIAs2y7Lhpmgy1IcNGiOig7oKzPugb3huFZA
         nuY+FFTctXbaTtHfBpdiocNGG6/21HoY8Mh07eXk3PPFlShlnFFBPcK3hwSIrKnqIgG5
         SsQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792488382; x=1793093182;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=V62r2oyMwKweJj3yBSLKefUPJg8WZq8H2U6uQoCWZWk=;
        b=Ow34hpO+URkHjlyQpJiGoPLey483JCFPViIxwJqL8fQcJHA0Seuca1RR+y76JBjfeq
         Fmgg4p9KML8V1e8+6r1hyVVEdyGKgqAYPH0RMSbhxyjdd6CWio6mfGjqvvp012y8OIyF
         bvQl/UDp6nbyVgOCG63SjVsVv5hkXhi6Jjz72nEb+cV7Z+Qse8AyEaCNSyFL1jI688rH
         yJZ7Ul47ZOEAm/PNiK7I/owOd+twQLu8rpKLrcEGDlWvmWEJagnV0Zy5oYRIPaN09eCt
         T+kUEeMe917m1MH6GEGemUPlVDm2NLLQPRwMg02O3o6Nz8FL6KzTx+Smgfeebsh4ST1g
         brTw==
X-Forwarded-Encrypted: i=1; AKwUvBzm5GUUu8McYE8TO8g1cEJ+009ZwsTeCkejxyUJ2HaCvdeIXBixg0G54vxaU7vRAny754EXcKTbQGY=@vger.kernel.org
X-Gm-Message-State: AFq9FYIPKf5EDZ2k4Yeua08bC3cD+VXaNJhzEN6n01/up/ankpH8RdlC
	DKDV12Nk2Vkha6xv/L5DgrM0MQ+CgOJ6IaCOsBV6O5hk4QhKSaMko1yYpG64D9ZBQdc=
X-Gm-Gg: AYBFou3OqphNfjM9SSm21VjF8ckS5y7Oa+k7aTTZW8+Z1gbYvz9RJqqWn9WyxJCUprn
	rZq3YWqfbd/YN1iebOdncz3qdGQA+Y351ZpV0pqiCG7DR+1tBKk5vyxJtRj5v2pWuTMFztANL3C
	Vy7QU/1SzEOl3TOoUgiU7eT89s/VgS3E+wWrv/gwpnKveIvZrE/Jc1FJH8Id182MTQalFzjT+6O
	sbUsPuHgR9PJlH1PHnVEy9ZuSdIGgmgW0T9h1zmiSFPmHnogALhTOV1HVkh2UN55NnRSTeaTwAp
	b3Afi3eLhynhngYz3fJrKci0nH2GvsIBgMU+MA0GDXqMnTk8boVUJx4YWsyubcxZw00X1eETIwk
	qLRkTuxkc7qdul25pvUK0X3w/KnEMuZUUuBJOWOGUBAcY+RIQHKdqUFoZD9cZlzxJeu6IpPv9lS
	QKsfOlYjsp/WMAiUn/Y1CzLgpcVT42jtFXHdOEUzcqNBvkvMJ7ZcWr02eizTe1c0OWHCtnHAHMR
	qd/3w==
X-Received: by 2002:a5d:5e87:0:b0:48e:1fb5:eac2 with SMTP id ffacd0b85a97d-48e1fb5eae1mr2877151f8f.12.1792488382209;
        Tue, 20 Oct 2026 02:26:22 -0700 (PDT)
Received: from localhost ([85.163.81.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d818d61sm4750276f8f.31.2026.10.20.02.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 02:26:21 -0700 (PDT)
Date: Tue, 20 Oct 2026 11:26:17 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Dionna Glaze <drdeeglaze@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
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
Message-ID: <atcypJ7oQ37oY8c2@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com>
 <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
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
In-Reply-To: <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>

Mon, Oct 19, 2026 at 06:10:31PM +0200, drdeeglaze@gmail.com wrote:
>On Mon, Oct 19, 2026 at 5:08 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Yeah, I was thinking about this and went back and forth. In the end, the
>> only reason for leaving it unbounded is to allow multiple independent
>> users of the same register. For example, IMA and systemd could share a
>> TDX RTMR. The systemd side would read the journal through the
>> attestation device and the IMA side through securityfs, but both are
>> views of the same journal. If one side truncated it, the other could no
>> longer replay the RTMR. Isn't this the valid usecase? Do you see how to
>> resolve this?
>>
>
>Bright minds have spent a significant amount of time working on this.
>
>+Roberto Sassu, +Mimi Zohar
>IMA logs and systemd logs are both system level concerns that are
>relevant to the OS construction, not individual users,
>so I would just say to reroute IMA to use ctlv using a kernel config
>setting, then make systemd the new system manager of the holistic log.

Yeah, isn't there a valid usecase for 2 separete userspace consumers
though? It could be a limitation, perhaps configurable :S


>The securityfs log contents can simply say, "log managed by ctlv" in
>this setting, in the form of the template identifier.

Yeah, I just wanted the existing userspace IMA ecosystem *just work*
without any distruption.


>For policy violations, only the 0... extend needs to go to ctlv.
>IMA can still keep its violation log as a ring buffer when it's not a
>1-to-1 violation to extension
>https://www.youtube.com/watch?v=gyYUYbdiN_4
