Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792512672;
	b=KsYUX//0wq4oGsu4J2n/toq2AMRFSswHx/9F5ZaHk7QzLYCSVEzAW4z4/mxcvZP3OJ8x
	 Anpzx2MNgUUiLmmCrSohmO+ceBdXGv487ZF9q4RGrA9ejQ1NWI/2ANNrppmvXa3RCkLzB
	 eyqbf8bcBrv+ntj6kR13hs8weoLM2hxdmqOpm7UhxUXMd9gTTRWJ1FPO3IDSOnNnVQLPR
	 xQBtXxQxF06ld0d7sBBW+BwmK4EYn7eDdo0ZFID7q4seitKxKV6psfQlIurxd3X51UdE8
	 HURl+W38DoXocNykKtYx4PBK0CiYcbmR4cBP7OVqHXJyzV4xydXNcxzyrEP5bfxo7Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792512672;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=qGagtzPPLeE5JUUJiGkA5WeVK5upm/IW7i7tq6L22jA=;
	b=gCmdbdRasR/AstaeIolUPfzSSAnYa4KWg5YYM5fMGfkdV4U8nK2CAAZtI+1/3NfvTC3I
	 rSMKFGrTJ68gZUsKaeGPrQRycMQW/Cq0CuAT2fep+0K3xAnYf7VttA5zUTHU6o24RK76r
	 EHgk9rung9mOYJkbU55p8Fg3KYatJ1tMEQiZneagGpjw5xEXPPWfnwdxDbq/nkYZBLitS
	 HLBGE0LU7Y6XnbOfDQES/gQOFRIVVwsYx1SIstEm6Rtv+INmYgswlfIj/I/zo/9iungRu
	 yW3ipofok7r4pOTxpv08dw+3F7hXX3B8+lwFT/utVOqBdtUlnctfjHVDQEhuzjKF3Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DbShED55;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1A3606A31D;
	Tue, 20 Oct 2026 16:11:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB1A3606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DbShED55
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A766C152B;
	Tue, 20 Oct 2026 09:11:07 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 412653F7D8;
	Tue, 20 Oct 2026 09:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792512670; bh=Onq6jxRqEq1WaTY8fGmgczAqDI9uWyGv9j4N9Vll460=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DbShED55IdZ5GqRBbk415/IcFxQD5ednAiW31MbR9Rn1dtNulHbKnhX4wEJI3XFbs
	 So+6u7EYH07FhsbRc0NWVaadc13WVhntS6CtJqRJQy7gS9S0cW3VjfLRdokRqWdJnl
	 7dkTDfkWhwCDWfk/tw8ZbIKAh3fG4SMLUV5JGvtQ=
Date: Tue, 20 Oct 2026 17:11:03 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Dionna Glaze <drdeeglaze@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>, Jarkko Sakkinen <jarkko@kernel.org>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	roberto.sassu@huawei.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <ateSly15N5mLrM1m@e129823.arm.com>
References: <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com>
 <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
 <20261020140655.GV13920@nvidia.com>
 <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>
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
In-Reply-To: <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>

Hi,

> On Tue, 2026-10-20 at 11:06 -0300, Jason Gunthorpe wrote:
> > On Tue, Oct 20, 2026 at 09:45:13AM -0400, Mimi Zohar wrote:
> > > On Mon, 2026-10-19 at 09:10 -0700, Dionna Glaze wrote:
> > > > On Mon, Oct 19, 2026 at 5:08 AM Jiri Pirko <jiri@resnulli.us> wrote:
> > > > > 
> > > > > Yeah, I was thinking about this and went back and forth. In the end, the
> > > > > only reason for leaving it unbounded is to allow multiple independent
> > > > > users of the same register. For example, IMA and systemd could share a
> > > > > TDX RTMR. The systemd side would read the journal through the
> > > > > attestation device and the IMA side through securityfs, but both are
> > > > > views of the same journal. If one side truncated it, the other could no
> > > > > longer replay the RTMR. Isn't this the valid usecase? Do you see how to
> > > > > resolve this?
> > > > > 
> > > > 
> > > > Bright minds have spent a significant amount of time working on this.
> > > > 
> > > > +Roberto Sassu, +Mimi Zohar
> > > 
> > > Dionna, thank you for including us in this discussion.
> > > 
> > > Based on my questioning AI, it sounds like the purpose of this patch set is to
> > > introduce a vendor-agnostic common attestation subsystem framework that can act
> > > as an internal kernel multiplexor for any measurement consumer, like IMA or
> > > DRTM. By providing a direct kernel-to-kernel call path, it allows measurements
> > > to be routed to different Roots of Trust (ROT)—such as physical motherboard
> > > TPMs, Intel TDX RTMRs, AMD SEV-SNP registers, and PCIe SPDM devices—without
> > > hardcoding IMA to specific device drivers.
> > 
> > Yeah, I would say that is the eventual goal, this patch series would
> > be the first small step along those lines
> > 
> > > To support this framework, IMA requires a strict, atomic execution sequence to
> > > maintain the Measure → Extend → Execute (Measure Before Use) guarantee. This
> > > initializes early during the late_initcall phase within the initramfs (via
> > > dracut).
> > > 
> > > If the new subsystem introduces a direct kernel-to-kernel multiplexing call
> > > path, how will it ensure the mandatory synchronous wait behavior when extending
> > > multiple hardware backends?
> > 
> > Everything has this 'measure before use' requirement. Why would this
> > be hard? Just loop over all the configured measurement targets if
> > thats the plan? Maybe I'm missing something?
> 
> As long as the measurements aren't queued, but actually wait for the multiple
> ROTs to complete, it isn't a problem.

But, I have a related concern about deferred probing of RoT devices.

For example, if TPM probing is deferred until after the attestation
subsystem has been initialized, how would the subsystem handle the
TPM becoming available later (This is reason for IMA_INIT_LATE_SYNC).

In particular, when I see breifly proviers/tdx.c and imange for TPM,
once if it's failed to get tpm_default_chip() in module_init(),
There is no way to retry and TPM seems not to be exported as RoT device.

Am I missing something?

-- 
Sincerely,
Yeoreum Yun
