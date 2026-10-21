Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792590646;
	b=r1FYW5DU0bxxP2D/n+IQzYX3yO0/lbrfa3vUgeJkvftkTDjhDBQXPslw3klg2ukU26rk
	 Ut2BYwIRwii0ITkQ9N8u7XSt106lyDwNW022b47KptF+AynOttmq7ZaIejr3FAQlDg2dI
	 ZLQYV3xDQChfUmaQX1xeILs1jTZTCn1LSWkYQNmWnd9lsODqQ2GhkzOpR9jq7iuKJkIZ4
	 4tp986168EMqtYTqnNc7MJv4E0mm2nFyOKHCrII6zMoz705A+ShrsNJ+2k+fTmI/YJO3k
	 w/i2rHF3fjoUiuYJYeHqW1Sx7+OgBBAcRinEHp5IvTaN7LbJ2p59j/Lnd6d0js5tPiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590646;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=q/QkqYTtgy2bufWV4QHDyITEHcwRUY/+ZRaQQhogM7Q=;
	b=Y4JJN4CR/XPMQ3fMGgYChK84SQhd3x/G6e6yfh0q/u6tZ4vSNpj93AMRK3YO7xhStRWO
	 7rElpHxk5JjP3BOuMhQfiXQLmiN3lsNZBibVxB32SviSOQdvuKbq3wvNTfLajCU/pYYNp
	 TJ6tQWN8VzOFNYdfVpkM/gRnAsCa095lbyxDGy8U649ZtZCwSSeuR9WIaAjp20wAKxok+
	 ln5fXK/oi8IZhiS8fuIG7YuaBnlJF4LJWYo9fB6xwAnO+mjlrc3NcaZ76ka+cTyAmLfWn
	 Cik49JcuoJC6aYJh5xqqduOAmkwSNCfFnUmc79XkIFZfByzk459Xfp1+gijPWHuWmsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LabB0NAn;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03CD4606A321;
	Wed, 21 Oct 2026 13:50:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03CD4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LabB0NAn
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5A2B16F8;
	Wed, 21 Oct 2026 06:50:40 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A08C3F7B4;
	Wed, 21 Oct 2026 06:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792590644; bh=H9BbNKD9GkEe6o0jC5JSixuXsP4WuXXgnjCc42nbGrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LabB0NAnebFRInTcBUa9BOCZ/lgn/jjoDQSRA2s/axBNi6xZLE+nRkYJaxSJVdXT5
	 +HIcagw6CFCMIU0JVEmsn7LwC0FiKLgN9v68cikBBU1nB/zBKt8zztUuhdjYPxABV1
	 rFHuoIbwz6brT0EOV+VRC0mLMGw15Y0xr/OiLM8w=
Date: Wed, 21 Oct 2026 14:50:36 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
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
Message-ID: <atjDLOTJE7-L711K@e129823.arm.com>
References: <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
 <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <a69c7e7ac4fd07a9c375faadc599e96bb8c8534e.camel@linux.ibm.com>
 <20261020140655.GV13920@nvidia.com>
 <aa00515a0f364fea0150cf1550a09d9400e4632f.camel@linux.ibm.com>
 <ateSly15N5mLrM1m@e129823.arm.com>
 <20261020165251.GG3008132@nvidia.com>
 <ae372ed03da3cd2d57c922850b3b017bcb83ca07.camel@linux.ibm.com>
 <ati7na9OJjN9FA1u@kernel.org>
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
In-Reply-To: <ati7na9OJjN9FA1u@kernel.org>

> On Wed, Oct 21, 2026 at 08:23:05AM -0400, Mimi Zohar wrote:
> > On Tue, 2026-10-20 at 13:52 -0300, Jason Gunthorpe wrote:
> > > On Tue, Oct 20, 2026 at 05:11:03PM +0100, Yeoreum Yun wrote:
> > > > But, I have a related concern about deferred probing of RoT devices.
> > > > 
> > > > For example, if TPM probing is deferred until after the attestation
> > > > subsystem has been initialized, how would the subsystem handle the
> > > > TPM becoming available later (This is reason for
> > > > IMA_INIT_LATE_SYNC).
> > 
> > FYI, this patch set initializes at module_initcall(), not even late_initcall().
> > 
> > > I don't think it would be any different, the mechanism for TPM would
> > > become generalized and apply to any attestation driver.
> > > 
> > > This series doesn't attempt to do that flow yet, moving ima over and
> > > dealing with this is another series :)
> > 
> > When TPM device initialization is deferred, it is retried during
> > late_initcall().
> 
> I don't remember when but I recall that this has been debated a few
> times and the idea of deferred TPM initialization has never been
> successful.

Yes. That's why handle the IMA at INIT_LATE_SYNC according to platform.
and when TPM RoTs is added, unless the the attestation module with is
initialised at late_initcall with IMA_INIT_LATE_SYNC option, platform
where TPM initailisation is deffered, this seems get failure to
recognise the TPM  RoT attestation according to current code example.

Might the TPM RoT attestation module would require some handling.
but I'm not sure with what fancy way.

-- 
Sincerely,
Yeoreum Yun
