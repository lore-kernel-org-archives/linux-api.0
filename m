Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D332E4E9C22;
	Mon, 19 Oct 2026 12:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792413616; cv=none; b=rHNcA6vvE74BmwFdA39s3KKXEAD61y8Pyc8YJeK4mXewV/L058xvRT6lU6vEVH7KcagDHotZq7Lfkjtw6UWijKs7Sls6vYUJy5GsN65dcDdOUD9aRu57+MTmGpedEWvKu8/f/Or7BA8MHWCCtxnYOaPB8wjq+zm9SEqXh9i19DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792413616; c=relaxed/simple;
	bh=c2jJL8g1o78ZHcWn2hWaMeykmocZ1Jrl/60Jv1Ak2kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ftmi7vwt1s7+DKRbqKfTDR9lE/FawDNsdhxGBAiBOz4HPsV5g4N7PdzG+ygTi1eNgtqSvu4w/Ca7NDbj/4BEzIqrigr3t6cpss7NPTs2qVU14NKzDlWzGqktRvIpO63CCSEVpq03hz5D0X/Lq9G8yKK1kvi6JLC20qw8beioqag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FceDrw6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FceDrw6E"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5CCEA1F000C4;
	Mon, 19 Oct 2026 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792413605;
	bh=Lt3t+hZCkJKDCkgZ9RLSNhgjFT8G4p+7rBrqWmCeF2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FceDrw6EYmp9Eq/4QZT7kFwc7TNvkJf1WpONqCkjTJr4Dy30SP0p/h7SJDNiQWGu6
	 JLqqXK/UWY45KsWa70U6jZ6liJUYTWIL0dVD8ede5QlpUUHWLFPNQ9tWGpAQJoSvYM
	 sukVJUiK40DNYCh29b08aiqM3bZZz8a2KTMmNoJhr7I0YU+wgWl9K3zIYvCKdMS4Pf
	 n9Bodc4j+4WJtyPpGf/UDHxEdRX5L0JPNVx8TsQlG10Fiv66AZuqXPsG4PRvkNMZ89
	 AA09rqznCRJo+XLcuFgR8NX3+8mtApm68Wlwh6/dVrWeadbCqLPWMhrxgNQA4GD68b
	 dCgoCb+xaowDw==
Date: Mon, 19 Oct 2026 15:40:02 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dionna Glaze <drdeeglaze@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <atYPohN7ztVVGko-@kernel.org>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com>
 <atPgqROZZxnihYfC@kernel.org>
 <20261017231007.GP13920@nvidia.com>
 <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANwfdvVJRv6++MJ8OCUnHSR_5nVD8Yv6eTmYxxqfzxEk0sNfpA@mail.gmail.com>

On Sun, Oct 18, 2026 at 04:53:28PM -0700, Dionna Glaze wrote:
> > On Sat, Oct 17, 2026 at 11:55:05PM +0300, Jarkko Sakkinen wrote:
> > > I wish I had a better picture what is going on.
> 
> Me too. I've spent my Sunday with Claude trying to build some
> understanding of all this stuff, and put together a static site about
> this series.

So I got the information I needed from Jason. If there is something that
is scoped well that it does not take too much time to digest, feel free
to contact me again on this topic (or anyone involved).

I.e. I can help if the problem is defined but figuring out what the
problem is - that is out of my scope :-) Hope you understand this,
and I'm saying this from polite/constructive point of view.

Br, Jarkko
