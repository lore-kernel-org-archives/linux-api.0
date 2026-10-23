Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792760173;
	b=DDIzHwKYTp0acHaCnzCMptNNgzGmRuYgj7fCjKX5ohx1FedQgLOSglqMqJhTB+3ea7Dn
	 +dtQF+RdhbAYNKbz6p39mu/qaNa4r/ahw5EUJqoGkXwmAGPLTRm6Kx/tAnij61KWp7uBm
	 JnqDn64niimvMXYOmoMOCKA5ELApYHHkzyhlCsf+3hLJN8AafqJEulJJSFfipLFm6ElIj
	 6xhp1x8KbrIb99M9dHTL1mbQej+HTo/FIMtNxzzrh3ndQWZd5xPeyWoCzIelG3TCbU9rW
	 16QKJ+wKzyv0wn5M1NPPwp0N/VVTmbOvFaib3BGI5sQbLBCm6DSbMaMnVXFVGD2VvCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792760173;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=4u5HTj0vYNkfyVy/ejdHIe5/AhW56e/aHgAn7wANgbM=;
	b=qNwLvk9/RiIZCQobcghoAmAD4AkQvZvDCJqFnmcH7MQ30T6QtCJ8AyOOttX3uUh/uXHe
	 FA4eLIfP7gz+PGSb3gV3mXB7/wzuiZT80TkSRnGRj8+ryatdECGRjc6FYPzyn93aKCwix
	 ZSV9WcSwO6q+rrRyPhEJx7OzZKTQldyiQWIOlnsFsQd03iHpOvlKreiLULgD5ULyV2cS8
	 wkdOFn9AsNob+PySIkWMq/68d4awE3qZBM3xNi1gL2hfkRi6oKZ6YgjjC4IL2WflkS7Yg
	 a1emxRVq5obAzeTFYjPoV/j3xN646v7pFWiUg0vjmsmjzzLS1lL+zncQ0y4oMrf/7kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0921606A31D
	for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 12:56:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0921606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a218ffa23dso1951655e9.0
        for <linux-api@vger.kernel.org>; Fri, 23 Oct 2026 05:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792760161; x=1793364961; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4u5HTj0vYNkfyVy/ejdHIe5/AhW56e/aHgAn7wANgbM=;
        b=m68+nKSR5BhjusJh/Qoc0nFyichGbcMpyaSKaNJGTP3rKdZ4Rjh5t6O40bNzgjsQJ7
         3ehrVsQhBMk8TpcHGvYxIVuxL6Ze31YASaTg7nasj/RW94kOhYVH3HMatmav1PWnD6ro
         hrnxuD+1NWOJaivSj8CsP4FSc6Yqtc3QVKWRjK8boPOVkf0vQXAjVum2TMSwmA0EI2YK
         Bn0wEYZ+diJ8DmIbUBKI+rmeQ5CMY/a+JhcwneYZfX1B0op3gTVSsQCCMm2tBMykQ56d
         x/TFWrZUzyXQegTGLG/MoakhVwcu3bSwlv/on6PDudlwXA/4Au3qwbz6mtfx38vXN42l
         OLeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792760161; x=1793364961;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4u5HTj0vYNkfyVy/ejdHIe5/AhW56e/aHgAn7wANgbM=;
        b=eE5MG7fAjzW3/kemS5oJyF97P/H5OKGhvDH8bPdKPIP89ucUAW3TI09zk6yKOOhvkS
         Vtb0hy3/XzHPj1ARESWLYCfccg6d46zAC3dQA3Lqp/jcFRHG8EB8MmH0LcuwU4IsPwSy
         HLU3aFxXtVCk5mwEtVvVirtG+FbStqGq6CrTTE94/M41ShILGIk8/ld9pC2u4ByzwYg9
         3b5erelTrY4o6GBadtEzRcLMX4BRtOeUoTxyuJmV7+lI8wTr5SRQ3xrdkYMcgfbPbQZc
         HBlVW2PA0t+QGIaUesZFIh3E/Bax42CihYf64EOiBsdJwpTpH8cSrKk/Hj6iSeRF5+Td
         DpCA==
X-Forwarded-Encrypted: i=1; AKwUvByAKbnjT2w2OqAzEw6X+8o0aYLIwaW8KmbRe5lBo1U5qtPiTbRd/zUpVMlFQR3YE96odtgb++zVJcQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYIw8YtZGJnQ6YXEwHM26KaWNqeYPvFncsEma0AAqpDUUV2PUL3k
	WVBZElEDMz8wh1v61ggzevRnuhQc8xYvWJHGbM3oRdRD7D7Pjrgj8Vn/lVHNvg15enc=
X-Gm-Gg: AYBFou2ztC3Q3RBE1sljXnhVXYYhJozSI7nrn+HI9fkglo8OqmUE3iSd3icJ9MysBMV
	LOkVUj1cxHXo/RoOjwxxXhSxPKtbaGOKQWTieOEL5dZlKkvtT2GhBRsglsNED6tcbN3juSjRwOU
	MbZqo5aS1TyQXu2uPbMuYOsaqdMOvI4vFsYXGFsmezFhl0avDDLlQAXJpUPPrmGUzBddXSBcr0l
	cPVbYdYoRZNvjJeJ11bBlb1bv65hHlEJMJ6vglWx/VPhEcoaxyBWXCeZs8C5VLxWFl/0tQkKhKM
	SSxyNSrH9pBo1FSFNFNIrSzFG95vePkuWIshnVg5SUpErq+ITZNH66u6sMfoGoEP81M+Xk6AEYD
	1qimLrg9HBWtue3AHVYbUExlIWvWBPImhLECiAJ7EwgmGiY/ts3HaGsD70DV6oZqC9dUayksOXB
	8O/KmZLfoLHoTvzMVOlUlD38kCGxNpujZYHuhoPc3ptpos1jWRYcoIlcd1W2+nqbdOw/Vno5sA7
	M6uQN9ME1/tc4ZO1FZlC1qSeiwCqMTc6vbjrf0bv8vwEbL/3NBmUGAezCUpJCPnwA==
X-Received: by 2002:a05:600c:354b:b0:4a1:97c6:d2e8 with SMTP id 5b1f17b1804b1-4a211ef95e3mr38623785e9.32.1792760160732;
        Fri, 23 Oct 2026 05:56:00 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a29cd9d232sm3594475e9.4.2026.10.23.05.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 05:56:00 -0700 (PDT)
Date: Fri, 23 Oct 2026 14:55:56 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 05/20] ctlv: Prepare message input handling
Message-ID: <attZPPNPIgF-DH4r@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-6-jiri@resnulli.us>
 <20261021014324.58376589@jic23-hlaptop>
 <20261022183942.GC3381610@ziepe.ca>
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
In-Reply-To: <20261022183942.GC3381610@ziepe.ca>

Thu, Oct 22, 2026 at 08:39:42PM +0200, jgg@ziepe.ca wrote:
>On Wed, Oct 21, 2026 at 01:43:24AM +0100, Jonathan Cameron wrote:
>
>> > +bool ctlv_message_input_rebind(struct ctlv_cursor *nest, const struct ctlv_schema_tree *tree,
>> > +			       u32 node)
>> > +{
>> > +	const struct ctlv_message_input_scope *bound_scope;
>> > +	const struct ctlv_message_input_nest *indexed;
>> > +	u32 i;
>> > +
>> > +	if (WARN_ON_ONCE(!nest->attr || !nest->msg || !nest->msg->index))
>> > +		return false;
>> > +	if (!ctlv_message_nest_index_ok(nest))
>> > +		return false;
>> > +	bound_scope = &nest->msg->index->scopes[nest->index_nest_scope];
>> > +	indexed = &nest->msg->index->nests[bound_scope->nest];
>> > +	for (i = 0; i < indexed->scopes_count; i++) {
>> 
>> 	for (u32 i = 0; ...
>
>Is that allowed now?

Yeah it is! You live in the past, same as I do obviously :)
