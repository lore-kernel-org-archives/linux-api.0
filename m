Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1F32D3A75;
	Fri,  2 Oct 2026 07:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790924748; cv=none; b=V9xTMEkTEk2ZKJwUo9f/uBrutuqC4wu7lvmsydGg+rjTkf37gI5jU6wZ9Fh5IXDml+vsO2ZbZ7VWx36/gX5zH2/gJz1/ZJzphqYs5w5WwoBDTWSZ3PfrKZkWWuaF4/03NtAEGXONG7MlXm0r+EW8qV1dqoTOl49n54ArE6AopCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790924748; c=relaxed/simple;
	bh=SsQhvlJAJv0pdksiuuoZnY55Sy8Rj6sCNdaY5dfHUsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPF+0+pOk23j9cgPrX7uMAP15J/IGmeN7SYQBCDac9k4GeOfa5ARz6S++mSA8iviymChR/GZtO+TWJqHuVR7ixXqwjF2Kcjf4ElwIeXGqF2Aod+Lq1ZGbtFJV5OF5iMGfontH6uhF+xetwYdWnCGG/6+bMiqRPjDSHZqFwcO+9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=enxlC8cK; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="enxlC8cK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790924747; x=1822460747;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SsQhvlJAJv0pdksiuuoZnY55Sy8Rj6sCNdaY5dfHUsA=;
  b=enxlC8cKCpr2wPZAVX9dBNxSoHkeIYm2eu+nBaPAncPjllrwwgr/SS+c
   EIHIkSxz4MaRQU8qhJzst/vLm/5VWIUBFh9ubSWDGwQuXWbq4hJDFAgej
   qoVWQVzb/gytGhWEzfFcPkkUHlOhNKjunzx1XZ4odIfP6HLL6nVLGOmZ+
   Or09kSyQnkBAt/x/qfH24/m7o0jdQaGeNK6Q1suJ/xfot8Wxwkhyv8MAe
   adxhxgvW+A4xqSAUlbRTnKkai+XSdISxHuLHNv9qdojlVVrX+clpB/UaH
   mq+AM8SBjrj9Amneh1ffekw+luh0oZJ7FlS8r5EnYepQkS9o+b7JRK6JR
   Q==;
X-CSE-ConnectionGUID: g9S2PE4XTgCLztaz5lQNhw==
X-CSE-MsgGUID: 4QjFaBHwQx6UAZ2Nn6j+yA==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="102213210"
X-IronPort-AV: E=Sophos;i="6.27,136,1787036400"; 
   d="scan'208";a="102213210"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2026 00:05:46 -0700
X-CSE-ConnectionGUID: JsatRacVQuSSLTGAEbKyUQ==
X-CSE-MsgGUID: Ybx2T56SQAyPNw2AQnktTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,136,1787036400"; 
   d="scan'208";a="314170258"
Received: from conormcd-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.244.188])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2026 00:05:43 -0700
Date: Fri, 2 Oct 2026 10:05:40 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Vadillo, Miguel" <miguel.vadillo@intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	sakari.ailus@linux.intel.com, hansg@kernel.org,
	laurent.pinchart@ideasonboard.com, mehdi.djait@bootlin.com,
	mika.westerberg@linux.intel.com, srini@kernel.org, arun.t@intel.com
Subject: Re: [PATCH] media: i2c: cvs: Add NVMem-based firmware update support
Message-ID: <ar9XxEb6Kjvd6HXb@ashevche-desk.local>
References: <20260930182142.108744-1-miguel.vadillo@intel.com>
 <ar6nSbS-FpaI6jYp@ashevche-desk.local>
 <abb0daee-c5f2-47c2-9b0f-6018edb0ba6b@intel.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abb0daee-c5f2-47c2-9b0f-6018edb0ba6b@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Oct 01, 2026 at 04:03:50PM -0700, Vadillo, Miguel wrote:
> On 10/1/26 11:32 AM, Andy Shevchenko wrote:
> > On Wed, Sep 30, 2026 at 11:21:42AM -0700, Miguel Vadillo wrote:

...

> > > +	mutex_lock(&ctx->lock);
> > 
> > Why not guard()()? Also how ACQUIRE() macros are co-habit with goto:s?
> 
> You are right scoped_guard() should be the case here and to get rid of the
> gotos, this could be done like:
> ...
> 	scoped_guard(mutex, &ctx->lock) {

Why scoped_guard()? If you need something to be outside of the regular
guard()(), but double check that it's indeed the case, refactor to have to
functions, one with guard()() in it and one that wraps it.

> 		switch (val) {
> 		...
> 		}
> 
> 		nvm->auth_status = -ret;
> 	}

> 	if (ret)
> 		return ret;
> 
> 	if (do_uevent)
> 		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
> 
> 	return count;

...

> > >   struct icvs {
> > >   	struct i2c_client *i2c_client;
> > 
> > >   	int irq;
> > >   	wait_queue_head_t hostwake_event;
> > >   	bool hostwake_event_arg;
> > > +	struct icvs_nvm nvm;
> > >   };
> > 
> > Is `pahole` happy with the layout?
> 
> Yes. struct icvs_nvm is itself hole-free and fits in one cacheline.
> That being said, there seems to be other holes in the full struct from the
> existing implementation, this order could make it better
> ...

Better by `pahole` doesn't always mean better in all aspects. You have to also
check it in conjunction with the output of `bloat-o-meter`. And in some
(performance-critical) cases with the runtime performance tests.

> 	struct media_pad pads[ICVS_CSI_NUM_PADS];
> 	struct device_link *ipu_link;
> 	unsigned long quirks;
> 	struct gpio_desc *rst;
> 	struct gpio_desc *req;
> 	struct gpio_desc *resp;
> 	wait_queue_head_t hostwake_event;
> 	struct icvs_nvm nvm;
> 	struct icvs_dev_capabilities caps;
> 	u32 nr_of_lanes;
> 	enum icvs_resources res;
> 	int irq;
> 	bool prefix;
> 	bool hostwake_event_arg;
> 
> but maybe send as a separate patch since it is not related to the patch
> intent (?)

-- 
With Best Regards,
Andy Shevchenko


