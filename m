Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792657679;
	b=X7/WGVNvgG30aRc//7TsMumkwd1q/i8F00+I3fkchZ4pbYpLbY3bU5+1Q/l1l1loz8mY
	 a173bw093veJW/ljTEyHiA9N52wsPwIYgDm3VYgSju2o8NevJrdBGOmkotMWEzlLGzRmL
	 Y4Z07qaxDH35ShJMmfUbYBKqgi2QjTJDj0UXanTwHIcVu1JVbL/5V6i9XzF3mm3A4BTfo
	 mjGYLR8oemYowNGWV6Fr9oCQ5DOse2bWw8qOoF+65b9/0DGhk1S6oAcsTslEZObWOQzsO
	 2sq7/Ww+F1IW+Tl+4ui8dHe9hU2toiNu8gEVYnsgu/MlRXXUBLS1rLymhjgUAajkGIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792657679;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=asTQwS3Q/pIZmKtVtb/ZZcYojtRdxCAchkNTDOljnRg=;
	b=m1tAFJM/aJ1Ky8jqw5ZbX8Y8vQCtS2aCwnnr7d50whXCCe8ObTX1OwZqBVz9a4C8hFti
	 8d/60iYYFpMppXyCE7bzhR3TJQru5iByqanJ4MpWLQ0zTvb9H8pywqDbtBhEbnbskrbB/
	 ToMUhONNx8/d6M1UCL0k+fo9gzhPHpeCswhx102eWdGHSLvZXgU1WgyLvVqMXPVp+cTVf
	 bp7jvImA+Pdqv/4kvMNgCyd4HFe39bIaf+cOkjyYqJw+iXRvnhbEwg/g5Y07m19QvLL69
	 RkzK/FW/Ppjbo+ACHb9pa169DzgzyS4tLOk+KR0KpMKTwD2Mbl0C6nqlAV7NeI8bP8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b="Xqn/2yUi";
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C35606A31B
	for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 08:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2C35606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=Xqn/2yUi
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1dede3c2cso20034795e9.2
        for <linux-api@vger.kernel.org>; Thu, 22 Oct 2026 01:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792657677; x=1793262477; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=asTQwS3Q/pIZmKtVtb/ZZcYojtRdxCAchkNTDOljnRg=;
        b=Xqn/2yUifSYwd1lLkvjTelhwbh1/fDxIkgCiTBzt6jpzF2b6Jtj1W+vx0Bue+MUy58
         9u42cvxmjlsJRbnQR2g3CWbj4u0rkL/k1ULnZYHkA6SYgBSLjiaJLKo7XUYZtC7tNenJ
         rsFukD01VvOvzDd3SE4W8Oqv/En+hGSOb1IleVA+BPtjYtldui+qaj/eFrGXDbDTs6Zh
         HQUgjRlg+/mxJFoLyy6ZYJH45n5kbvVwK0xr1YtKjqBE0q6RxnBXsMTT0TqpvW3YuGgS
         6xjeAh+dj5PSGSU8D18ZjCN3TeNPZns36H6lwwUccK2iJaoVhrAUeKBlAglwvy3XGzs4
         TAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792657677; x=1793262477;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=asTQwS3Q/pIZmKtVtb/ZZcYojtRdxCAchkNTDOljnRg=;
        b=wV8mSShgXrEmm8rz7uR4Y1ubA8h0RBD1Q1gw0ysscMoMafiHFK3aCR5l7bvWbtjg/j
         sI+huJcfU1S2trR9/ngBSetyRmoh9u77K76cEDS3FQ64hheXjSKYc3B8kJXzc0rRgNm4
         1e43PLhAUeKYiYQtvv1wtBpq87sgvd4PL3GyuTd++HZlCSE3XC+avxN3P4kPU1Omz1PD
         mJh/HxQPVKt6lt2OpyRqmPBY8YNH2i/54SLtdZZFxLCInpU0lbIhIwmaExVsOMqCFoN5
         mFaQop3KR+bZcU6QvXo3JXEDMAVbJGhtMTUCxx+HNB36QzHMEW1bVELTv7GpPkdWAx1x
         sxPA==
X-Forwarded-Encrypted: i=1; AKwUvBwpC0PTLQVhwjBjKaDmPy0SuYEimwo60v+UmkjXIEJLBayCs5p/rigHKjW8eVXVxmDpLrgL6sn60MY=@vger.kernel.org
X-Gm-Message-State: AFq9FYIg847ieEqirZfA5kIZAWPmeIPzg01yHEDIp3DIU6VgqV4hqUbD
	27x6C9qF7WQ+EHKz2q1/nvjI+77vMqJ1YlSqRL4tArIbiJLAWz3SwV/dQ3MPKsC80Dc=
X-Gm-Gg: AYBFou0rEh0n2Vahzx2tMGRFbQc2tFAb0U69FpDwLggxB6XiXOEJqmiTn2lxQ99n87s
	BHl62RCIp7vT+wF4QGcnMCXIzAVY21qwuZQI9I9LapdURIE1hws/CzyH1iptnuu+xi1sjISdwhD
	t0ygGZgIiODS91ahv5OoXIBm9iDdiv/aL5/9HuHC1Svs+97qCVb7EtsRsP6+Kho02PzgV10FGBj
	l6b1kW0Xatl9oJTBm3JYes0lMtrh9bXPw+TpPD5ZP/MK23p0VF/6g+CaYgVX+j1QARh88QF/bR8
	jzdlkDU/Vx4FTHz+e6wNkz+YVRoa+zZua0wIo1ODtqy+FmXQwYZfYFyPOrrMJ7vpl1UIL3cQRHW
	fxTtK7yTQ3khipRfHRA3EaHYi96F1z82/Z3tVXwN7fvmMEkyQlAzKnPpx/P2J+5xayfc3VbRpQt
	TlroVmO0/v3vo56zgF26UU4bAcMgcmra4k2Ms5ZpPdzybVaTDoEmSJBfAVcxF0UBMMPyGejS4J5
	6zrtmnMGA8iLB6efoPepdnI/UeNuXn3y3ypYmlYPWWHTBgwd9QtE8RYPOK0lhHW
X-Received: by 2002:a05:600c:524a:b0:4a2:994:5750 with SMTP id 5b1f17b1804b1-4a209945818mr14069445e9.32.1792657677030;
        Thu, 22 Oct 2026 01:27:57 -0700 (PDT)
Received: from localhost ([128.77.52.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e258426f4sm10865456f8f.54.2026.10.22.01.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 01:27:56 -0700 (PDT)
Date: Thu, 22 Oct 2026 10:27:52 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 05/20] ctlv: Prepare message input handling
Message-ID: <atnIDx6qmLe-geb4@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-6-jiri@resnulli.us>
 <20261021014324.58376589@jic23-hlaptop>
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
In-Reply-To: <20261021014324.58376589@jic23-hlaptop>

Wed, Oct 21, 2026 at 02:43:24AM +0200, jic23@kernel.org wrote:
>On Thu, 15 Oct 2026 16:50:38 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Add wire walking, request indexing and validated input accessors for
>> generated family readers.
>> 
>> Keep CONFIG_CTLV unwired until dispatch completes the module.
>> 
>> Assisted-by: Cursor: GPT-5.6 Sol
>> Assisted-by: Cursor: Claude Opus 5.5
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>Trivial stuff only. I didn't attempt (yet) to check
>all the walking code, just get a feeling for what was here. 
>
>
>> diff --git a/drivers/ctlv/Kconfig b/drivers/ctlv/Kconfig
>> new file mode 100644
>> index 000000000000..aed3243c55fd
>> --- /dev/null
>> +++ b/drivers/ctlv/Kconfig
>> @@ -0,0 +1,12 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +menuconfig CTLV
>> +	tristate "CTLV character device TLV UAPI"
>> +	help
>> +	  CTLV provides character device UAPIs described by a checked-in YAML
>> +	  specification. It owns the character device lifetime, the strict TLV
>> +	  message format, request validation, reply serialization, the large
>> +	  payloads a request describes rather than carries, per-open event
>> +	  queues and runtime schema introspection, so families only implement
>> +	  semantics.
>> +
>> +	  If you don't know what to do here, say N.
>
>I'd not say that.  Overly cautious for something we expect
>to get fairly extensive use.

Okay.


>
>
>> diff --git a/drivers/ctlv/message.c b/drivers/ctlv/message.c
>> new file mode 100644
>> index 000000000000..7e5742ba8f70
>> --- /dev/null
>> +++ b/drivers/ctlv/message.c
>
>> +
>> +bool ctlv_message_input_rebind(struct ctlv_cursor *nest, const struct ctlv_schema_tree *tree,
>> +			       u32 node)
>> +{
>> +	const struct ctlv_message_input_scope *bound_scope;
>> +	const struct ctlv_message_input_nest *indexed;
>> +	u32 i;
>> +
>> +	if (WARN_ON_ONCE(!nest->attr || !nest->msg || !nest->msg->index))
>> +		return false;
>> +	if (!ctlv_message_nest_index_ok(nest))
>> +		return false;
>> +	bound_scope = &nest->msg->index->scopes[nest->index_nest_scope];
>> +	indexed = &nest->msg->index->nests[bound_scope->nest];
>> +	for (i = 0; i < indexed->scopes_count; i++) {
>
>	for (u32 i = 0; ...

Okay.


>
>> +		u32 scope_index = indexed->first_scope + i;
>> +		const struct ctlv_message_input_scope *scope =
>> +			&nest->msg->index->scopes[scope_index];
>> +
>> +		if (scope->tree != tree || scope->node != node)
>> +			continue;
>> +		nest->tree = tree;
>> +		nest->node = node;
>> +		nest->index_nest_scope = scope_index;
>> +		return true;
>> +	}
>> +	return false;
>> +}
>
>> +
>> +void ctlv_attr_next(struct ctlv_cursor *cursor)
>> +{
>> +	const struct ctlv_message_input_slot *slot;
>> +	const struct ctlv_message_input_scope *scope;
>> +	const struct ctlv_node_schema *node;
>> +	const struct ctlv_attr *next;
>> +	u32 next_nest;
>> +	u32 next_offset;
>> +
>> +	slot = ctlv_message_cursor_index(cursor);
>> +	if (!slot || WARN_ON_ONCE(!cursor->attr))
>> +		return;
>> +	next = (const void *)((const u8 *)cursor->attr +
>> +			      ALIGN((size_t)cursor->attr->len, CTLV_ALIGNTO));
>
>kernel code is allowed to rely on void * arithmetic, so this can be
>	next = (const void *)cursor->attr +
>	       ALIGN((size_t)cursor->attr->len, CTLV_ALIGNTO);
>
>container_of() for instance makes use of sizeof(void) == 1.

Okay.


> 
>
>
>> +const void *ctlv_attr_binary(const struct ctlv_cursor *cursor, u32 *len)
>> +{
>> +	const void *value;
>> +
>> +	*len = 0;
>> +	value = ctlv_message_cursor_payload(cursor, BIT(CTLV_SCHEMA_BINARY), len);
>> +	if (!value)
>> +		*len = 0;
>
>I'd kind of have assumed that ctlv_message_cursor_payload() would not
>set len to anything if it returns NULL.  Thus the default *len = 0 would
>be intact.  From a quick look that seems to be the case making this
>code a little odd. 
>
>Perhaps overly defensive or keeping an LLM happy?
>Same applies on some other functions.

You are right. Will remove these.


>
>
>
>> +	return value;
>> +}
>> +EXPORT_SYMBOL_NS_GPL(ctlv_attr_binary, "CTLV");
>> +
>> +/*
>> + * The room is measured before anything is written, which is what leaves a
>> + * refused attr's message exactly as it was, padding included.
>> + */
>
>Having a trailing comment in a file rarely adds much or indeed
>even more rarely gets read.

True, will remove.


Thanks!

>
>
>> diff --git a/drivers/ctlv/message.h b/drivers/ctlv/message.h
