Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793104710;
	b=o5TWNo3NlgU2pr/z8e8gh48zuDQM18zifKRjGfmSBi9S2NOpXo1YoicbHgEIrsqoUBji
	 4kqgeiySztu+rU7F8p+NZUV09uuqNzIehleRsSY9/JrvyqFlnVIPFx4n+j8nT9sb9w4GS
	 YpDZRBlf9+S88SBZiIECCfBBHCYGXFVB76Mr+yonWiUiYekNDTUhqnu+Q/xDzcOHfue6j
	 RaLRxmls+W3aOauACTyqczb3sk0FKRuejA/PyERsU/hc9Ur8+/Eex69CJpMplC/Sr+7yq
	 CJdR8ZAZW/AeF9WM9L199e1m3Z74r7Dvi+iNkKNCwUvHoZSugAJa9a4X78fJdN4U0oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104710;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=qN+oFteBBnu0qCEf7Z79N2pFESAzJvFrXcLvl6PgY1Y=;
	b=054RjRV77eJQgJr9WLI2WGdBU4HnuvMauySTBJh9nAGCjDZWh5ar1EKeEmBT2Qs7V0G7
	 gogQ8QyXaYUGmnpMMY9gQECE6cfhaEd9FkdG+ZbayB69Jz02TrU9dE0u6WlxHMw64eedZ
	 56SLeo0IprfkjPVJMPtl9ERg+xnXjYkbY6+SwxmXf7eTO/kSBMuVANcBf+hZCxK4VERHt
	 /YpyLmLHjQvxgZCONgX55CpaESs2qhZJRZv7RXO7mhjXlykNqvQR/1WhPnxJIUOLNnId5
	 t/CabxtWLytC+m6jXnIYTdnBYcRVcTVuNT69grgoeMWCLgNAHgXRcU7g2G/43y3y1Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=K9Nmp3Ym;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E481606A31D;
	Tue, 27 Oct 2026 12:38:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E481606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=K9Nmp3Ym
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D5C115A1;
	Tue, 27 Oct 2026 05:38:25 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24FD13F871;
	Tue, 27 Oct 2026 05:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793104708; bh=AsQV8EPRWv/nZtGsAUNcNbWRUUJk7ZparFQR6Yrsrl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K9Nmp3Ymll4ZjvGr4zTYwZFV+35ZQwesqboMyB7EIqAfv5qOu9RyO9XG9N+fpdzCo
	 ULo58NND3GpJE273n6AvoGflscj1dRlINrrfQ6JxS0i+U388wwr+SauPBi98yZpGEr
	 RxFv1WHb6q4sjcTeU2HZmV9Br7fuJRF2zXZbhbN8=
Date: Tue, 27 Oct 2026 12:38:21 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
	lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 10/20] ctlv: Prepare event queue support
Message-ID: <auCbPdoaMq9oWoQ_@e129823.arm.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-11-jiri@resnulli.us>
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
In-Reply-To: <20261015145053.3664509-11-jiri@resnulli.us>

Hi Jiri,


[...]

> +int ctlv_event_emit(struct ctlv_op_ctx *ctx)
> +{
> +	struct ctlv_device *ctlvdev = ctx->ctlvdev;
> +	struct ctlv_event_record *rec, *next;
> +	struct ctlv_file *cfile;
> +	u32 len, wanted = 0;
> +	LIST_HEAD(spare);
> +	int ret;
> +
> +	if (WARN_ON_ONCE(ctx->file))
> +		return -EINVAL;
> +	ret = ctlv_event_finish(ctx);
> +	if (ret)
> +		goto out_free;
> +
> +	len = sizeof(struct ctlv_event_hdr) + CTLV_ALIGN(ctx->output.root->len);
> +	scoped_guard(spinlock, &ctlvdev->events_lock) {
> +		if (ctlvdev->dead_announced)
> +			goto out_free;
> +		list_for_each_entry(cfile, &ctlvdev->files, node)
> +			if (test_bit(ctx->op->event_index, cfile->subscribed))
> +				wanted++;
> +	}

Suppose at the time of here, the number of subscriber is 1.
However, before calling the ctlv_event_deliver(), another task hold the
event_lock() to register new subscriber. for example:


Task 1 (emit)					Task 2 (new subscriber B)

wanted = 1
unlock events_lock.
						Register subscription.
allocate one record
ctlv_event_delver()

  grab events_lock.
    Deliver former subscribe event to old one.
    new subscriber B will call ctlv_event_queue_event() with NULL.

When this happens, new subscriber B would receive overflow event
via ctlv_event_queue_dropped() though it was registered right before.

Is this intended? It doesn't make sense that subscribe B receives
the overflow event in this situation...


> +	if (wanted) {
> +		ctlv_event_copies(ctx, len, &spare, wanted);
> +		ctlv_event_deliver(ctx, &spare);
> +		list_for_each_entry_safe(rec, next, &spare, node)
> +			kfree(rec);
> +	}
> +
> +out_free:
> +	ctlv_event_free(ctx);
> +	return ret;
> +}
> +EXPORT_SYMBOL_NS_GPL(ctlv_event_emit, "CTLV");
> +

[...]

Thanks!

-- 
Sincerely,
Yeoreum Yun
