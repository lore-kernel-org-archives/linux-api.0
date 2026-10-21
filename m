Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792545140;
	b=jsCB9jlTTGZE8cQVHG7JMZPgJskA9489d1DJ1tyRk+XHjAwTh37wqhTp7pxpYK+02A27
	 DBB93wvn5IzWkLbGyfZcjesQMqnrJqc5zI/8pFAe1ywSvtHkdWOQTaurIaFi9h8LN1PQw
	 xwpha4zF+AyJifb6YyP8YuyeO2KaaomkirHtTY6tptCf5ZHvZZ7yF9lTElHXVUQOYp843
	 Qwmv0sCjIgjIW44sl+J8YFYN9mhNvddYVpiD0ztdPEucwVyTY7fMNfRRCb2Cskv3o980E
	 GhYPQS5bGfbmLZAshe92LG37QAj70XkZPUW/nNGxDIgYq+KPvm1X9zjQEKvNC94tE0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792545140;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=xhRR7nZ0krlDfz4UjHLuhwtedGeJ5dw0/R97qGxnioo=;
	b=omt6mnjKmYySWiAxzsshhMaYy9pYu+RioyTt2tiAM9z1Tjc2NTLb6gomIt581+UEXA7T
	 jkff1R4GZGuW1kE00dFlbeKTet3fdMwl8RmLVvoyudOKQa/l/aKEL3JEw6wEHbsBG3FZc
	 R0Ou+pM/fO2HB11xM7HPD/NjUiprJhvI2MVaHm4NTKQQ5rn2WkqU5Axujdv2Z7k6LBydb
	 hqXwkCiBNnpq9rpnmpBKHQEK/3h7btT3zztr95aZaMUlco5GKa/H/NWoMQPQwQXM+10Fu
	 l7K2caSyyU9wypuCE1bJ6YHR6zCBbjZ2wJiqCWc4ATROuZK/r4O3ZktyEbnxryuLq3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MTkOcOBu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3CE606A31A;
	Wed, 21 Oct 2026 01:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MTkOcOBu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBE01F000C9;
	Wed, 21 Oct 2026 01:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792545139;
	bh=xhRR7nZ0krlDfz4UjHLuhwtedGeJ5dw0/R97qGxnioo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MTkOcOBueSNtnaznDqIjuqEbFcK8ewmcBwwB1W/IoRNg/sCZ2nrd0cxP9khexpgla
	 tZcbaO7x6d7N9zbVXAof77yJkAvQPRoNBVnx3pFZcFe/cDVoPe6C2+22mX7mu9nwnn
	 YT/J8C7yjw/SOp5kGu/jpsBoIiF8qMQXRu3tbhOy0PJOKTJ+EiO19T9BvOBrkTH7Ys
	 qCx2X+BzXZnjrZ3bMa+F5W2QXe3CknS5fRwnznwSV4Fu5WweXxBJiwQ7vUkxpdcc0y
	 ielHYa/0UM/1mEVOqSRQqcxKMSsv88EahtNr5Ijj8tdq4wb1wGeLYheRCgcI5WQpHS
	 dSlH2KkR2Z3nw==
Date: Wed, 21 Oct 2026 02:12:08 +0100
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
Subject: Re: [PATCH RFC 10/20] ctlv: Prepare event queue support
Message-ID: <20261021021208.6909d4e3@jic23-hlaptop>
In-Reply-To: <20261015145053.3664509-11-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	<20261015145053.3664509-11-jiri@resnulli.us>
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

On Thu, 15 Oct 2026 16:50:43 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@nvidia.com>
> 
> Add per-open subscriptions, bounded event queues and event creation for
> CTLV families. Add the generated root family kernel bindings now that their
> message and event helpers are available.
> 
> The event and generated root objects can be compile-checked here.
> CONFIG_CTLV remains unwired until device dispatch completes the module.
> 
> Assisted-by: Cursor: GPT-5.6 Sol
> Assisted-by: Cursor: Claude Opus 5.5
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Nothing fundamental - just a few passing comments.

I'm running low on time, so will take a closer look at
this in a future revision.

> diff --git a/drivers/ctlv/event.c b/drivers/ctlv/event.c
> new file mode 100644
> index 000000000000..0f68d33e031c
> --- /dev/null
> +++ b/drivers/ctlv/event.c
> @@ -0,0 +1,713 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
> + *
> + * Per-open event queues and loss reporting.
> + */
> +
> +#include <linux/bitmap.h>
> +#include <linux/build_bug.h>

cleanup.h given you are making quite a bit of use
of guard() in here.

> +#include <linux/ctlv.h>
> +#include <linux/ctlv_gen.h>
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/list.h>
> +#include <linux/minmax.h>
> +#include <linux/overflow.h>
> +#include <linux/poll.h>
> +#include <linux/sizes.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/string.h>
> +#include <linux/uaccess.h>
> +#include <linux/wait.h>
> +
> +#include "builder.h"
> +#include "device.h"
> +#include "event.h"
> +#include "internal.h"
> +#include "message.h"
> +#include "schema.h"

> +
> +struct ctlv_op_ctx *ctlv_event_create(struct ctlv_device *ctlvdev, u64 op_id,
> +				      struct ctlv_cursor **reply, gfp_t gfp)
> +{
> +	const struct ctlv_op_entry *op;
> +	struct ctlv_op_ctx *ctx;
> +	void *out;
> +	u32 room;
> +	int ret;
> +
> +	ctx = kzalloc_obj(*ctx, gfp);
> +	if (!ctx)
> +		return ERR_PTR(-ENOMEM);
> +	scoped_guard(spinlock, &ctlvdev->events_lock) {

Generally mixing anything cleanup.h with gotos is
a bad idea. Tends to get Linus saying your code needs
restructuring even if it isn't an actual bug.

> +		const struct ctlv_family *family;
> +
> +		if (!ctlvdev->events_live) {
> +			ret = -ENODEV;
> +			goto err_free_ctx;
> +		}
> +		if (WARN_ON_ONCE(ctlvdev->active_event_contexts == U32_MAX)) {
> +			ret = -EOVERFLOW;
> +			goto err_free_ctx;
> +		}
> +		/* Admission pins the op until emit or abort. */
> +		family = READ_ONCE(ctlvdev->family);
> +		if (!family) {
> +			ret = -ENODEV;
> +			goto err_free_ctx;
> +		}
> +		get_device(&ctlvdev->dev);
> +		ctlvdev->active_event_contexts++;
> +		ctx->ctlvdev = ctlvdev;
> +		ctx->family = family;
> +	}
> +
> +	op = ctlv_op_find(ctlvdev, op_id);
> +	if (WARN_ON_ONCE(!op) || WARN_ON_ONCE(op->schema->type != CTLV_OP_TYPE_EVENT)) {
> +		ret = -EINVAL;
> +		goto err_put_ctx;
> +	}
> +	room = ctlv_event_len(op) - sizeof(struct ctlv_event_hdr);
> +	out = kmalloc(room, gfp);
> +	if (!out) {
> +		ret = -ENOMEM;
> +		goto err_put_ctx;
> +	}
> +
> +	ctx->gfp = gfp;
> +	ctx->op = op;
> +	ctlv_message_output_init(&ctx->output, ctx, out, room, &op->schema->reply);
> +	ctlv_message_root(&ctx->output_root, &ctx->output);
> +	ctx->deepest = &ctx->output_root;
> +	*reply = &ctx->output_root;
> +	return ctx;
> +
> +err_put_ctx:
> +	ctlv_event_free(ctx);
> +	return ERR_PTR(ret);
> +err_free_ctx:
> +	kfree(ctx);
> +	return ERR_PTR(ret);

Two different error paths also tend to indicate code needs
a rethink and maybe splitting into a couple of functions for the
different stages.

> +}
> +EXPORT_SYMBOL_NS_GPL(ctlv_event_create, "CTLV");



> +
> +ssize_t ctlv_event_file_read(struct ctlv_file *cfile, char __user *buf, size_t len, bool blocking)
> +{
> +	struct ctlv_device *ctlvdev = cfile->ctlvdev;
> +	struct ctlv_event_record *rec;
> +	ssize_t ret;
> +
> +	/* dup() and SCM_RIGHTS share one serialized queue. */
> +	if (mutex_lock_interruptible(&cfile->reading))
> +		return -ERESTARTSYS;

	ACQUIRE() magic should work here and let you do direct returns on error.

> +
> +	while (!(rec = ctlv_event_queue_take(cfile))) {
> +		/* Drained, and the device is gone. */
> +		if (READ_ONCE(ctlvdev->dead_announced)) {
> +			ret = -ENODEV;
> +			goto out_unlock;
> +		}
> +		if (!blocking) {
> +			ret = -EAGAIN;
> +			goto out_unlock;
> +		}
> +		ret = wait_event_interruptible(cfile->readers, ctlv_event_waiting(cfile));
> +		if (ret) {
> +			ret = -ERESTARTSYS;
> +			goto out_unlock;
> +		}
> +	}
> +
> +	if (rec->len > len) {
> +		ctlv_event_queue_untake(cfile, rec);
> +		ret = -EMSGSIZE;
> +		goto out_unlock;
> +	}
> +	if (copy_to_user(buf, &rec->hdr, rec->len)) {
> +		ctlv_event_queue_untake(cfile, rec);
> +		ret = -EFAULT;
> +		goto out_unlock;
> +	}
> +	ret = rec->len;
> +	ctlv_event_queue_consumed(cfile, rec);
> +
> +out_unlock:
> +	mutex_unlock(&cfile->reading);
> +	return ret;
> +}

> +static int ctlv_event_subscriptions_set(struct ctlv_op_ctx *ctx, const struct ctlv_cursor *request,
> +					struct ctlv_input_ref ref, bool subscribe)
> +{
> +	struct ctlv_device *ctlvdev = ctx->ctlvdev;
> +	struct ctlv_cursor attr;
> +
> +	for (ctlv_input_attr(&attr, request, ref); ctlv_attr_ok(&attr); ctlv_attr_next(&attr)) {
> +		u64 op_id = ctlv_attr_u64(&attr);
> +
> +		if (!ctlv_event_subscription_find(ctlvdev, op_id))
> +			return ctlv_op_errorf(ctx, -EOPNOTSUPP,
> +					      "op %#llx is not an event this device emits",
> +					      (unsigned long long)op_id);
> +	}
> +
> +	guard(spinlock)
> +		(&ctlvdev->events_lock);

That looks odd. 
	guard(spinlock)(&ctlvdev->events_lock);
is more familiar form to me anyway.

> +	for (ctlv_input_attr(&attr, request, ref); ctlv_attr_ok(&attr); ctlv_attr_next(&attr)) {
> +		u64 op_id = ctlv_attr_u64(&attr);
> +		const struct ctlv_op_entry *op = ctlv_event_subscription_find(ctlvdev, op_id);
> +
> +		if (subscribe)
> +			set_bit(op->event_index, ctx->file->subscribed);
> +		else
> +			clear_bit(op->event_index, ctx->file->subscribed);

		assign_bit()

> +	}
> +	return 0;
> +}

