Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792499230;
	b=MUNN+zauXrPnGFYkxXuRf5JV467vs0DKch/zCoWtRIhMYGQnoGRbDUE0r1Nq2g6tXrPN
	 lLGY4rpxfWpHZNVDOfVxsGSAept/NBMvqLemGC/PZM779z5zXc9O3z7yVVlXc15AJ6sIT
	 pfyN8bWXw3/1jodzS0UpURaiw27F3cQ3GY/zTKmJ/mGHLcYhzxPqtvKEhNOsYqkXb1Ckg
	 NsAt14LgNv6HM3fCgtBs3gIRkz4V5xl6KxO0kgCIF9/qwJxP06wAf2VlvE+Rmz34QA8p2
	 1Xfn2OyjZxSvD8qwIf3cHy5/emL7a/XmQB7PCUu6s+ErLO7i3fcTAcFDym5OSpAAhtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792499230;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=r+JXJ7/RizMzNWpQZbCi3pXUDD6ZYso7OnyQ+kdiZlM=;
	b=KEKNJwnF46/IflXHOKNi8LY5hu00SMFmC+UC8l41q9wN2MRsG6jLZBaqF9zdm5xaW2FZ
	 poJQDyJE7YhbBjtRQIb0ee9u9a4gRwaDQW5w+piafw3uWK/lLg+JK7g2j+0bbtruIkpc3
	 cycTJvYCeNwUhlLljpHWn+jqHFu3s1qc61iSdGX1KH02ZPtsKrGfKycL0GVfWxMJnZz9s
	 vuvQMRsnC0Yb5AsPy1C1gednd4n585Q9Tg6O0OwMuJ0mHGynOWo6gagxyKhdjm68tol3L
	 Q7hNNG1QMpiyXdh9OyhkcTwlcMOXxSbpXNQGTLUSlqRIu0VWM+L4kP7l18q/hJLmlDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=resnulli.us;
	spf=none smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D38606A31B
	for <linux-api@vger.kernel.org>; Tue, 20 Oct 2026 12:26:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57D38606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a1d75f2f11so22222455e9.3
        for <linux-api@vger.kernel.org>; Tue, 20 Oct 2026 05:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1792499217; x=1793104017; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r+JXJ7/RizMzNWpQZbCi3pXUDD6ZYso7OnyQ+kdiZlM=;
        b=hFWwiKZYM9mL6E9PjvXPJ3WGnS6fCoA5M4DIXCiZ7QxzFi2/LcC4qvf+KiToBx11vf
         GRItbzTNaPMrrqtIFRswHSZ98neyu90Uq5IfSu4sQ36KzvEhbpjmB1UwNwd7qYf4BWxN
         bDz3iEsnC7hCleu9A1kqlb5Rzg4kdPeLjcGlV31/IXxUBLh7w3J02q1/tfvUIz81uOS/
         UEM6+101n2rlxfRua/iUXIXttcSlcn3JJy+8PQ0VU6ITRl8uQjt14rR220smlHCvOj+l
         C6Q2+TncSYuWzfBvITAgECC4jVu0YXsBeECg75adzeCZE0pz4lYpLhgty1FCkfWqLh1e
         sotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792499217; x=1793104017;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r+JXJ7/RizMzNWpQZbCi3pXUDD6ZYso7OnyQ+kdiZlM=;
        b=nqCd9ImOZwQhD1Ut8J5pVb172W8LjDh636NuefKzQID4fA/QagNA2sGY0U5xgbFqU+
         GIydC3EQlgdj0tHblu3JQDESBW5OLNn8t9ZBz1g/Hh+q0BSWYy89fDXOW9rwYpNF3Msy
         NXEd61c/OnrVu/MMUuOq3ga32GrtZoEJ0bNsJDMMRbccR1jqk023P9crZAbIrp7K4ltK
         0UfiI4QuOYwoOF7K33utcmiJTEWPKRwTVp7RRHSpwCkNu9VFFOjZ168CiHXcaNXBkdhs
         mZiEEHshcRshkchv4Zb2Ejg2vjd95LCuc8HL6+9WzN9MHj4+Uv9zffQ3fvWCUoMeHTyU
         6kHg==
X-Forwarded-Encrypted: i=1; AKwUvBy3HCxfrGt8/uZ9jrchJ7bhjRbNnlcQmAjD4VsB0Clrn8zlby6BObAeMVYCjchbgXz6/HleMwShFZY=@vger.kernel.org
X-Gm-Message-State: AFq9FYJqonOd7ee9g9Q3VwvlHMJfT2V8ejiOTCv3Bh/qnGpF5AwquhTP
	N6VB70KKORGcc0NZwruCUrNYsacLR4lZhYVrIDm8B5vlJi9nss4iiLwB8aSPo/EeU7s=
X-Gm-Gg: AYBFou3LX0gafYBwsBfAgZ+sbMu1ATu3AqIDxkHsNqtAqiRCpAmM4gVqoD/vILBFySv
	q76xZawl6bd0eGT8sgrD9pWZc5QQw1isJ63qTse8AOWjhb/ta23tWCQyV4m1lxgLUpcR3da5ob1
	4ski20UvlL21RqBSyGVWpP3VMxL+y24m+1t4csQy8uZp5z3T5AGiMBerthadm41Q9PrNEtNaecb
	EmjoRcCqwjic+9o+KyH2jKL8ybZhYjuXNR1QIa/nzGQOuTxHNViaN+ViIoEd35GA0LyLx4h4HO0
	jOG7NfncJ6OMTxqM6V5OMdDAIoMCmuTO7Mm9rH23ODtuVaW5KIajyeSAyE7SPwU+W8ztvYvbydb
	eiCl3MM/lw1rlLK2aQ8Kv6FFdVE0uad77g2mFbHRfk2D2CQqv9tRmOnlvG5boApv+hXnEqQ+I9R
	afqjcgNBgoQ24+eKvcDrMhuBBoLWV5NVyMulo35gijnEqz05LGObLXXKDyYETDGsP3bA71nf1nk
	a/n
X-Received: by 2002:a05:600c:34c5:b0:4a1:dc8e:edc1 with SMTP id 5b1f17b1804b1-4a1dc8eee6dmr208638065e9.0.1792499217319;
        Tue, 20 Oct 2026 05:26:57 -0700 (PDT)
Received: from localhost ([85.163.81.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2ce1479sm69425855e9.14.2026.10.20.05.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 05:26:56 -0700 (PDT)
Date: Tue, 20 Oct 2026 14:26:54 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 02/20] ctlv: Add the UAPI wire format and family API
Message-ID: <atddoIx-sA2eheSu@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-3-jiri@resnulli.us>
 <179245258504.58760.15790996354033644110.b4-review@b4>
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
In-Reply-To: <179245258504.58760.15790996354033644110.b4-review@b4>

Tue, Oct 20, 2026 at 01:29:45AM +0200, jgg@nvidia.com wrote:
>> [ ... 159 lines skipped ... ]
>> +#define CTLV_NODE_SCHEMA_UNLIMITED 0
>> +
>> +#define __CTLV_NODE_SCHEMA(_attr, _kind, _occurrences, ...)	\
>> +	{ .attr_id = (_attr), .kind = (_kind),			\
>> +	  .max_occurrences = (_occurrences), __VA_ARGS__ }
>
>This reads alot better without the extra macro layer. The point of
>this is to allow the codegen output to be concise it is worth being a
>bit more verbose here so the exact form is easier to see.
>
>> +
>> +#define __CTLV_NODE_SCHEMA_CHILDREN(_first, _count, _required)	\
>> +	.first_child = (_first), .children_count = (_count),	\
>> +	.required_children_count = (_required)
>> +
>> +#define CTLV_NODE_SCHEMA_ROOT(_first, _count, _required)	\
>> +	__CTLV_NODE_SCHEMA(CTLV_ATTR_ROOT, CTLV_SCHEMA_NEST, 1,	\
>> +			   __CTLV_NODE_SCHEMA_CHILDREN(_first, _count, _required))
>
>For instance this is much more directly readable:
>
>#define CTLV_NODE_SCHEMA_ROOT(_first, _count, _required) \
>	((struct ctlv_node_schema){                      \
>		.attr_id = CTLV_ATTR_ROOT,               \
>		.kind = CTLV_SCHEMA_NEST,                \
>		.max_occurrences = 1,                    \
>		.first_child = _first,                   \
>		.children_count = _count,                \
>		.required_children_count = _required,    \
>	})
>
>Even if it is longer, and and clangd can now jump to the struct members
>
>I also think each of these should have a one line comment explaining
>when it is used.

Okay, makes sense.


>
>> [ ... 61 lines skipped ... ]
>> +#define __CTLV_STUB_SCHEMA(_family, _set, _node, _optional)	\
>> +	{ .family_id = (_family), .set_id = (_set),		\
>> +	  .node = (_node), .optional = (_optional) }
>
>Same here

Ok.


>
>> +
>> +#define CTLV_STUB_SCHEMA(_family, _set, _node)			\
>> +	__CTLV_STUB_SCHEMA(_family, _set, _node, false)
>> +
>> +#define CTLV_STUB_SCHEMA_OPTIONAL(_family, _set, _node)		\
>> +	__CTLV_STUB_SCHEMA(_family, _set, _node, true)
>> +
>> +struct ctlv_schema_tree {
>> +	const struct ctlv_node_schema *node_schemas;
>> +	u32 node_schemas_count;
>> +	const struct ctlv_stub_schema *stub_schemas;
>> +	u32 stub_schemas_count;
>> +};
>
>I've been ponding for a while what 'stub' means in this context.
>
>AI suggested "extension_points would be a clearer name here." I guess
>because ctlv.rst calls it "Inheritance and extension points" ?

Will think about rename. Pehaps better documentation&comments would be
enough, IDK.


>
>> +
>> +#define CTLV_SCHEMA_TREE(_name) {				\
>> +	.node_schemas = _name##_node_schemas,			\
>> +	.node_schemas_count = ARRAY_SIZE(_name##_node_schemas),	\
>> +}
>
>It is helpful to put the struct on these macros ((struct X){})
>
>#define CTLV_SCHEMA_TREE(_name)                                         \
>	((struct ctlv_schema_tree){                                     \
>		.node_schemas = _name##_node_schemas,                   \
>		.node_schemas_count = ARRAY_SIZE(_name##_node_schemas), \
>	})

okay.


>
>> [ ... 127 lines skipped ... ]
>> +typedef size_t (*ctlv_family_priv_size_fn)(void);
>> +typedef const void *(*ctlv_family_pre_init_fn)(const void *init_info);
>> +typedef int (*ctlv_family_init_fn)(struct ctlv_device *ctlvdev,
>> +				   const void *init_info, void *priv);
>> +typedef int (*ctlv_family_post_init_fn)(struct ctlv_device *ctlvdev,
>> +					void *priv);
>> +typedef void (*ctlv_family_pre_fini_fn)(struct ctlv_device *ctlvdev,
>> +					void *priv);
>> +typedef void (*ctlv_family_fini_fn)(struct ctlv_device *ctlvdev, void *priv);
>> +
>> +typedef int (*ctlv_stub_fill_fn)(void *priv, struct ctlv_op_ctx *ctx,
>> +				 const struct ctlv_cursor *request,
>> +				 struct ctlv_cursor *nest);
>> +
>> +struct ctlv_stub_ops {
>> +	u16 family_id;
>> +	u32 set_id;
>> +	ctlv_stub_fill_fn fill;
>> +};
>> +
>> +#define CTLV_STUB_OPS(_family, _set, _name) {			\
>> +	.family_id = (_family),					\
>> +	.set_id = (_set),					\
>> +	.fill = _name##_fill,					\
>> +}
>> +
>> +struct ctlv_family {
>> +	const struct ctlv_family_schema *schema;
>> +	const struct ctlv_family *parent;
>> +	const struct ctlv_op *ops;
>> +	u32 ops_count;
>> +	ctlv_op_pre_fn pre;
>> +	ctlv_op_post_fn post;
>> +	ctlv_family_priv_size_fn priv_size;
>> +	ctlv_family_pre_init_fn pre_init;
>> +	ctlv_family_init_fn init;
>> +	ctlv_family_post_init_fn post_init;
>> +	ctlv_family_pre_fini_fn pre_fini;
>> +	ctlv_family_fini_fn fini;
>> +	const struct ctlv_stub_ops *stub_ops;
>> +	u32 stub_ops_count;
>
>Having the function ops in a struct use typedefs instead of just
>coding the signature is unkernelly, I couldn't figure out what this
>was done, it seems there is no user of the typedef

Right, will remove.


>
>> [ ... 182 lines skipped ... ]
>> +/* Implementation limits, not wire-field maxima: raising them is compatible. */
>> +
>> +/* Request roots, action replies, query reply fragments and event roots. */
>> +#define CTLV_MAX_INLINE_MESSAGE_LEN	0x100000	/* 1 MiB */
>> +/* Includes the error information root. */
>> +#define CTLV_MAX_ERROR_LEN		0x4000		/* 16 KiB */
>> +/* The root attr is at depth zero. */
>> +#define CTLV_MAX_NEST_DEPTH		32
>> +#define CTLV_DEFAULT_QUERY_REPLY_LEN	0x10000		/* 64 KiB */
>> +#define CTLV_MAX_EVENT_QUEUE_LEN	0x1000000	/* 16 MiB */
>
>If they are just random kernel limits I'm not sure they should be in
>this uapi header?

True, will move to internal c/h

>
>-- 
>Jason
