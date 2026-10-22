Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792666479;
	b=ewiXHQTMd0xjK9effY3i80RYlKKSpxRqxsE2nYZ5sM5T59Cg305wkVHu3B2pnbgJCq5r
	 1KiUO+1VEnC+YggBWBNsdxTqv4EXi/6Mu8k1TY7iYYGRgAb2Z/0DEU0Ht+tLobjaIDyaC
	 UzI5thPGsdOvk5+YVXnJJg+dQuMWYfFV/tRIHie5b68yp/kcfCvsr1KNMj9skSpO5ZdCI
	 FHTsD6JG5R7qRYG8KtMGV+hU3C+GPEngFk4EiRFhL3krNh3gNvH/xRwNB6uwpVCwEPkom
	 4HlWiz0TiKv5ByLyXxxYa0SaEBU94kTnTuF45HC2Z4qwpNzAYkCmUpNU4cYNoT1FvUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792666479;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=wsdeMYd/7eLXCr9Ufg4dZ6+EW6LYxWJjZpkMLdZ1OLI=;
	b=Scux/U5pzi+JmCKgxX3whUjpL7qOXV1Vz7ElIfjlWNXFAjF615FP5u6cbOy4NTEOOCHh
	 FmzSjTL+sF875Bb9kn1vqKYZCO5rSD8oZ3XpWDPJPRsB7+v8E4Jhvqy8Frtr+DSRashAf
	 lc86bBZRctmXVUsoZ36kCyPQ+nMCOWP+wgot0NwmZZy/yzaE+JdBIzjTIf8Vrkr+9xVh1
	 /FxxMk9Nmr05J1b0e4QXhLODf8dxpXtvIKxXWIQTVVfBPW3sWiVSsFIvbdcqOscGzEwHb
	 K0+ZJ7QgW8eh8gFYncu4GjMzrZ1Uta5+ulYCV26cBf9qakjfBBBekPqiVEXrbwqvG2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=iVzM+4Wh;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCE8606A319
	for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 10:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FCE8606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=iVzM+4Wh
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so1532933f8f.1
        for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 03:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792666476; x=1793271276; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wsdeMYd/7eLXCr9Ufg4dZ6+EW6LYxWJjZpkMLdZ1OLI=;
        b=iVzM+4Wh7gDZgzymw32x+37naO3wz4NgCsioUd0xXmmYJLxHde730j8vwEBFHOigDt
         spQz+0mFByaQFwaDUr0c2ae1SeHnkPpIIUiMHP/cu/tOLU497pMtVgSh3Oe97yRxau59
         1+aFiEk/doEVxAUQ4uQi5J3n037VefaeLSYfEBVYI0ezdQtHblQfteC+MpB14t0Yb02b
         crjq4VN8tYFrfN5YMd66+KGrNKNSCqW3QnCUx8AtGlqCodiHQpo5792+KihYy5FXZLYH
         ZumXm9uvYooJDFh1wBcflp8vYOWr5d2vJQZRxljy7S6k5IwMbVTRod9BghghqnSJwFlZ
         satA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792666476; x=1793271276;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wsdeMYd/7eLXCr9Ufg4dZ6+EW6LYxWJjZpkMLdZ1OLI=;
        b=1i4ytE8a2Wek265LQJmSLfMzutqTCEBhE6MHKsIvBNG5VTDJKkhP9+PaGzJGrhjGqL
         +8FW8bGqqDebohZKa3rzJSx1faxZI6FrV/uIEMBNZ7mcO3tneFtdf83xJN3HKTe1oNpL
         6y0Dwg5ukeJu0WV+AtGaHQwV5KZNTlHwZaE1PIf8EAs+pwmlDUB5BqYLgaFQGJlw/24n
         lW6L9/VW11sHJu9JImUj5ZQELDoNG4s1l48WZP05WQY2bDauFs1SKNKp/WZlnnSO+u76
         fG33RZJyVLelzLvZx4s7EQdELa+Lw2RIuofIrN5x/f5NIGpzWC07xGgtr2s/hsNlCsbB
         M9lg==
X-Forwarded-Encrypted: i=1; AKwUvBwu5r5AB9+VpsI8s0cPOji9CWTlL4somxptQrYwNVCO6cwYH4Rwj0wIWn8QxBBauy/fOgjKzxESO2c=@vger.kernel.org
X-Gm-Message-State: AFq9FYKEQgULhMl6zutRLHWl3TVbn0kx8zn6hm2k+vrPbqDWpyMUP7Rl
	rZvOjMtP8L3cjiq9unU7f2+SYPO3xp6FtSm4qC5jfwliBXx1QU9tDHfyY8T+jLA/bfI=
X-Gm-Gg: AYBFou3eTfrJCvNkxwShH//5MMs3SZkfH5n+eNr4w+jMkAmocByL5ZYLJwc79VLgmZV
	CeJt47h5GtJsMOsCI2lNIctK6uDccfhhNFQisdm1bbuCvNOWZ538JlpmoFUS3mM3IhQkvwdgRKH
	5M3kQwBCXTVEqPZYJFrXbrAMSaMmJ18xO3nfWsdIaCGUc9y08C/ZJUXrhOdsIBYanA+/tICJms2
	1Sl69rAQFUfJYPUW6Q9Re5noJ73hHOuxLrW0kPSaoWvBDcGGe1TwmbDJ4vXWA9Z/Bq3nWHnBL5C
	Si5IGKC+BWWensAiP7UhQ5iw7HH4fzZdKagiZrifTIusiTTeFyNcLXblFObyYuuB412JT4NY/6v
	3MDwcZsgZTGFpBMP2Q9gFOCGmkZ+ZwzevLnsAmBRKaozOC0t6JW4RjcQh8l4JivZEa6fQZkjysM
	NahEhh5Ie34ofvq/7sohtexAknTZK7bnp+wxU8vd3eIO5Ewb6WX2S7RX7x7vduNERfaCB6OFAfA
	cd1UxQKNgZX8xZIq6zMsPC1tj5VbMAeBpViB5KdnH4V36titin000GQtcPjLka9oM0=
X-Received: by 2002:a05:6000:288e:b0:485:8cc8:1f5f with SMTP id ffacd0b85a97d-48e264a1f81mr10449260f8f.42.1792666476063;
        Thu, 22 Oct 2026 03:54:36 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2583522esm11890881f8f.35.2026.10.22.03.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 03:54:35 -0700 (PDT)
Date: Thu, 22 Oct 2026 12:54:30 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Dionna Glaze <drdeeglaze@gmail.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
	cedric.xing@intel.com, sameo@meta.com, James.Bottomley@hansenpartnership.com, 
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com, 
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com, roberto.sassu@huawei.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <atnqmDhgaJycTf_Q@FV6GYCPJ69>
References: <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <20261019225658.GS13920@nvidia.com>
 <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
 <20261021143529.GP3008132@nvidia.com>
 <8d8833fac61558a94af415143530884349584a2f.camel@linux.ibm.com>
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
In-Reply-To: <8d8833fac61558a94af415143530884349584a2f.camel@linux.ibm.com>

Wed, Oct 21, 2026 at 09:05:09PM +0200, zohar@linux.ibm.com wrote:
>On Wed, 2026-10-21 at 11:35 -0300, Jason Gunthorpe wrote:
>> On Wed, Oct 21, 2026 at 10:12:34AM -0400, Mimi Zohar wrote:
>> > > > I think for now we should not include a new dynamic log here, the uAPI
>> > > > around this Jiri drafted can remain a future step. I don't want to
>> > > > open complicated discussions about new functionality at this
>> > > > stage. The whole CTLV idea in general is a big enough thing to bite
>> > > > off for this series.
>> > > 
>> > > Okay, dropping the log from this set.
>> > 
>> > Thank you.  Please keep in mind going forward, that the scarce hardware register
>> > limitation (like the 4 TDX RTMRs) should be resolved (e.g. by multiplexing the
>> > extension path), not by combining distinct measurement lists.
>> 
>> I'm not sure what you mean?
>> 
>> Since the HW doesn't support sealing the only *technical* requirement
>> is the verifier can reproduce the measurement register hash. So long
>> as we can get there we can do whatever.
>> 
>> Multiplexing extension alone isn't enough. We need some scheme to
>> reconstruct interleaved logs too.
>> 
>> For example we could add an atomic sequence number for each
>> extend. Every log sharing a register can report the sequence
>> number. The verifier would have to globally sort all logs to confirm
>> the hash.
>> 
>> Hopefully we don't have to tackle this problem. I hope that 4
>> registers is enough for Linux. One for IMA, one for systemd, one for
>> user? Plus a spare!
>
>Agreed, I hope you don't have to tackle it either.
>
>> 
>> Maybe we can build a multiplexed scheme on the spare? I don't know.
>
>To avoid interleaving the logs, AI had suggested multiplexing or virtualization
>of the RTMRs.  Whether is has any merit, I'll leave to you.  Here's the very
>short AI explanation:
>
>"Instead of allowing external drivers or subsystems to execute a direct, raw
>extend command to a specific hardware register index, the new attestation
>subsystem should act as a Hypervisor for Registers."

Isn't the hypervisor what we are doing now? I mean multiple extension
originators share the same register and eventually the same log. Or do
you suggest to go even further having a "generic_registerX" exposed for
every hw implementation allowing the user to have full abstraction?
The "generic_registerX" would be always alias to something hw specific,
like RTMR2 for example of TDX.


>
>> 
>> But we almost certainly need to have logs sequentially created in time
>> occupying the same register. Ie IMA may take over the register from
>> UEFI logging. Here we'd want to report the start/end hash values of
>> the logs back to userspace so the verifier can stitch the order back
>> together.
>> 
>> It would also be nice to think about a way to restrict the registers
>> to help avoid multi-user conflicts from misconfiguration.
>
>That would definitely be a plus.
>
>Mimi
