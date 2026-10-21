Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792543415;
	b=MPRO+cB8KD1sWqJbmzvl6jDjZpinfd5g0FbYqX3mH5NpzMPmFWHpt6v0w5GrM9+T7KKg
	 TshsbdTIC8t5offr2FHa0Riol6ZJFp8dUoWBqs5zYTBZkeQoKWgEfouha4JKpdgjvopUy
	 ZqHRgWSzqGSIqqurMsgw1e7QeXT8s6tgH8Dpmm2G3Q8gQUgCd/Qbe7kALafLij2+OZ6Ha
	 52JXgCVcocehRRWUUQjDg6tHpfjKPM2oiRp9Powgxs/eeGyfkZypRA4ovkoXERBd2zpQ+
	 zrRaSZs6vIDdnZ2XgvZs+D+utyLuiULL2fLVgHmPU3w7egO+neBZ6JqjLG9/VSBBnOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792543415;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=+nsFjOW7BqpbTIqHalWaePbKIO7ywrm1YspyvTTDJtI=;
	b=X25bysreya8fYQLdf+2yLtNuWSZDgCCgaeZsV8CT1MBpX8Pl5HUGQLxrcKF4C+6u71mD
	 hQFxKhNp+2FppUF0Dlb+QxARSTc87TidZv4YMWFeEyekQVgS6FvK3FL/MDrZzn0w4MAoD
	 U+TH5xMaq/r4m9cOqdGR4a9m5XQE33V7YYbnH2EaNRm/TahRXhIj2iV0zPpHPht9MBuhB
	 DmbJL96v7ZDaEG0QWfCF1SUOmwTZDFUFA9Gslgz2ISHu66K+g9/ttt8jHPtPdj/VJhi9S
	 tEV2YmQWsaF0ldHoKP9TbLHhppGe4V0uiIahPm8R3WfGGXdDa1vzllzu2KampoIK5XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DxcF7P9Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC11606A319;
	Wed, 21 Oct 2026 00:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DxcF7P9Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F321F000CB;
	Wed, 21 Oct 2026 00:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792543415;
	bh=+nsFjOW7BqpbTIqHalWaePbKIO7ywrm1YspyvTTDJtI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DxcF7P9Z8g9YonBWeXdP7GBGjT2smZ0f5bgEtvl7J2t4zP4ETROvhigfV8h151wzc
	 LIfDwx4M/0LBeRjp33bTltFl023pkl94jXkiwX0i25JhHsbeCeKHVXH/oIbW0+9bxA
	 HYYEmnbflmRQ3yza6Xba4HjF/k3Nf6UNv8WMYYqTwy2dwAc/hL5BCVTS/CY3oZzbqe
	 YDbK6eRvAU3STAbb2jBawAmCzDD86hXg5xitwqBq3UkMFwHIYOQd7FYr8oHkHnG4ue
	 whDknX3N7JSVkNgvSjnWi/1p0aw4ykAmdez+cN+5EdinjhAtZrHasyW4lRf1gniW1T
	 MJXqzY0ZyMzgA==
Date: Wed, 21 Oct 2026 01:43:24 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
 lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
 cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
 James.Bottomley@HansenPartnership.com, aik@amd.com, jpiotrowski@nvidia.com,
 qinkun@google.com, pgonda@google.com, alistair.francis@wdc.com,
 ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
 dave.hansen@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 peter.fang@intel.com
Subject: Re: [PATCH RFC 05/20] ctlv: Prepare message input handling
Message-ID: <20261021014324.58376589@jic23-hlaptop>
In-Reply-To: <20261015145053.3664509-6-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	<20261015145053.3664509-6-jiri@resnulli.us>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Oct 2026 16:50:38 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@nvidia.com>
> 
> Add wire walking, request indexing and validated input accessors for
> generated family readers.
> 
> Keep CONFIG_CTLV unwired until dispatch completes the module.
> 
> Assisted-by: Cursor: GPT-5.6 Sol
> Assisted-by: Cursor: Claude Opus 5.5
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Trivial stuff only. I didn't attempt (yet) to check
all the walking code, just get a feeling for what was here. 


> diff --git a/drivers/ctlv/Kconfig b/drivers/ctlv/Kconfig
> new file mode 100644
> index 000000000000..aed3243c55fd
> --- /dev/null
> +++ b/drivers/ctlv/Kconfig
> @@ -0,0 +1,12 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +menuconfig CTLV
> +	tristate "CTLV character device TLV UAPI"
> +	help
> +	  CTLV provides character device UAPIs described by a checked-in YAML
> +	  specification. It owns the character device lifetime, the strict TLV
> +	  message format, request validation, reply serialization, the large
> +	  payloads a request describes rather than carries, per-open event
> +	  queues and runtime schema introspection, so families only implement
> +	  semantics.
> +
> +	  If you don't know what to do here, say N.

I'd not say that.  Overly cautious for something we expect
to get fairly extensive use.


> diff --git a/drivers/ctlv/message.c b/drivers/ctlv/message.c
> new file mode 100644
> index 000000000000..7e5742ba8f70
> --- /dev/null
> +++ b/drivers/ctlv/message.c

> +
> +bool ctlv_message_input_rebind(struct ctlv_cursor *nest, const struct ctlv_schema_tree *tree,
> +			       u32 node)
> +{
> +	const struct ctlv_message_input_scope *bound_scope;
> +	const struct ctlv_message_input_nest *indexed;
> +	u32 i;
> +
> +	if (WARN_ON_ONCE(!nest->attr || !nest->msg || !nest->msg->index))
> +		return false;
> +	if (!ctlv_message_nest_index_ok(nest))
> +		return false;
> +	bound_scope = &nest->msg->index->scopes[nest->index_nest_scope];
> +	indexed = &nest->msg->index->nests[bound_scope->nest];
> +	for (i = 0; i < indexed->scopes_count; i++) {

	for (u32 i = 0; ...

> +		u32 scope_index = indexed->first_scope + i;
> +		const struct ctlv_message_input_scope *scope =
> +			&nest->msg->index->scopes[scope_index];
> +
> +		if (scope->tree != tree || scope->node != node)
> +			continue;
> +		nest->tree = tree;
> +		nest->node = node;
> +		nest->index_nest_scope = scope_index;
> +		return true;
> +	}
> +	return false;
> +}

> +
> +void ctlv_attr_next(struct ctlv_cursor *cursor)
> +{
> +	const struct ctlv_message_input_slot *slot;
> +	const struct ctlv_message_input_scope *scope;
> +	const struct ctlv_node_schema *node;
> +	const struct ctlv_attr *next;
> +	u32 next_nest;
> +	u32 next_offset;
> +
> +	slot = ctlv_message_cursor_index(cursor);
> +	if (!slot || WARN_ON_ONCE(!cursor->attr))
> +		return;
> +	next = (const void *)((const u8 *)cursor->attr +
> +			      ALIGN((size_t)cursor->attr->len, CTLV_ALIGNTO));

kernel code is allowed to rely on void * arithmetic, so this can be
	next = (const void *)cursor->attr +
	       ALIGN((size_t)cursor->attr->len, CTLV_ALIGNTO);

container_of() for instance makes use of sizeof(void) == 1.
 


> +const void *ctlv_attr_binary(const struct ctlv_cursor *cursor, u32 *len)
> +{
> +	const void *value;
> +
> +	*len = 0;
> +	value = ctlv_message_cursor_payload(cursor, BIT(CTLV_SCHEMA_BINARY), len);
> +	if (!value)
> +		*len = 0;

I'd kind of have assumed that ctlv_message_cursor_payload() would not
set len to anything if it returns NULL.  Thus the default *len = 0 would
be intact.  From a quick look that seems to be the case making this
code a little odd. 

Perhaps overly defensive or keeping an LLM happy?
Same applies on some other functions.



> +	return value;
> +}
> +EXPORT_SYMBOL_NS_GPL(ctlv_attr_binary, "CTLV");
> +
> +/*
> + * The room is measured before anything is written, which is what leaves a
> + * refused attr's message exactly as it was, padding included.
> + */

Having a trailing comment in a file rarely adds much or indeed
even more rarely gets read.


> diff --git a/drivers/ctlv/message.h b/drivers/ctlv/message.h
