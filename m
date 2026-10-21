Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588706;
	b=J3W0FV9TuqmAwQOpkURTjaslc5hEQfYJG1AE3OdXicbKC006HUx7IA8qN8dQeCc/rNKO
	 ehHnixyIsY0+bgXV9tMtsMFCSJXxgmVMGRBVmisIvu3gEc3Fd7m0elke08mK71sN9SLhR
	 nd4qImFLh2+ixF8EW6eX2PgWnATrFhErXlGBCF92Fwyi7fYiTmM5gmcy/OTVs12PpO6VL
	 a8npLiAUuAT2k+bEWXIaZkWTjczxfzPmRoRCsYVAmqbK1GrLC1mQPqcy8vBtyDqyo7Gta
	 PbdnQrY9A8Sm6lB6UFyZsM+8767vf6oagjobVx3A8NYfWa1IV8c5rvsSmOrEmQNXx/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588706;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ekCibKv0PWllJqYiwbL8NTR+L8MQ741UG7Kn2SVkZkQ=;
	b=SrNdeeMzbHMysx2Y0Wcf2zAqWA+/7GJ+i8TK0pndoP+70ZUQ8wWj9zwv3OYjZOKJrMrc
	 37fojtg2poZFLCa+1lwIjiXYDFp6aRonIlCikeSpMRYdnV+psgtjv5BLRymE6kNVU3fT6
	 fBat6Ih4JoIz6yJcLk66IjtPpZa/oEE6GwbdWfcm7FRP68Q3FC4rZrae8vN5YYuLKF1gk
	 1y4LdJn+erda8o29ImrbFBQYRfwdBPt+INc4ytxXT7To9Kuzj1MHhpjZCkfotD/CINXOd
	 Kv4OkYsw2+sSpLokzYuFV5+lQQ0xRK/qOW5PudZ9s7XgJjeWt9DyuuhK1Xt6hZqv7Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jsr8bwoM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E6863606A319;
	Wed, 21 Oct 2026 13:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jsr8bwoM
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0A3D91F000C4;
	Wed, 21 Oct 2026 13:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792588705;
	bh=ekCibKv0PWllJqYiwbL8NTR+L8MQ741UG7Kn2SVkZkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jsr8bwoM0yi7oKg8wHJk3tffC/dTPOTVs02uNlnkZ4oZWn0IRD9DnECnE5Clx9r6/
	 ae6V09MG/X3D3cV1QxAnRe59hVNjgMeTeC2l3rixB9FwGLnAcoRuWiBmxiMQRy215D
	 KlFub3OGGxGN1Lj/YXKj9T6VFQl/OwSTT1uEPvEpAYwuf42DB0Qgyo2P3dFeemH39k
	 hSSRslObIuFVGzjPkPQ4TUg8OJ9ci1WSwwH2CMBPyn+Uo5RY4Hp0Nyg09UBj2hEAjf
	 6SzyPKcXDuv4ynFZgHteRinGWJl/umxFeJ1xORjnZuD73uYifWxgtWFv9KC4EkTUad
	 GjWn5gnUhlygw==
Date: Wed, 21 Oct 2026 16:18:21 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
	Dionna Glaze <drdeeglaze@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
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
Message-ID: <ati7na9OJjN9FA1u@kernel.org>
References: <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
 <20261020140655.GV13920@nvidia.com>
 <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>
 <ateSly15N5mLrM1m@e129823.arm.com>
 <20261020165251.GG3008132@nvidia.com>
 <ae372ed03da3cd2d57c922850b3b017bcb83ca07.camel@linux.ibm.com>
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
In-Reply-To: <ae372ed03da3cd2d57c922850b3b017bcb83ca07.camel@linux.ibm.com>

On Wed, Oct 21, 2026 at 08:23:05AM -0400, Mimi Zohar wrote:
> On Tue, 2026-10-20 at 13:52 -0300, Jason Gunthorpe wrote:
> > On Tue, Oct 20, 2026 at 05:11:03PM +0100, Yeoreum Yun wrote:
> > > But, I have a related concern about deferred probing of RoT devices.
> > > 
> > > For example, if TPM probing is deferred until after the attestation
> > > subsystem has been initialized, how would the subsystem handle the
> > > TPM becoming available later (This is reason for
> > > IMA_INIT_LATE_SYNC).
> 
> FYI, this patch set initializes at module_initcall(), not even late_initcall().
> 
> > I don't think it would be any different, the mechanism for TPM would
> > become generalized and apply to any attestation driver.
> > 
> > This series doesn't attempt to do that flow yet, moving ima over and
> > dealing with this is another series :)
> 
> When TPM device initialization is deferred, it is retried during
> late_initcall().

I don't remember when but I recall that this has been debated a few
times and the idea of deferred TPM initialization has never been
successful.

Just stating the odds :-)

Br, Jarkkko
