Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792592605;
	b=EilCd8AUf7Rr9nAxKByKj2lmG7Jsp5XoBFm5lxQNjSRQnH6vBzeAhK9A88pU6MxmhH3w
	 C/cZ94Vg4D3VmdxwQ9mGWZvjECc7wtK8UwbnAmRhtjbZiZATk+5sV062GOwsgBTnKtWzM
	 MFBOingLRYW+E1ha1iptBlpJbGdRrJ7DD7jaErqbfgf/gMRu7J+r0TIbwZsEvglO0c37T
	 P5Jp2wzQKdo+fm8AfAGH1K5Mc3CHa6+08K8tY/cVhhYdt7jLuC5cYFqRnllyG8P7k0pu2
	 Xi3cYVNQkaAKvh5pYYW3E6KKe87rwyVY9HyBZEpkcFc2XLEoFJNA8pIoUEdSvbPLwxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792592605;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=iuEnBt+F5UUTH/XMt7g5zZaMh5IRL3eqw/WM+8xQBzo=;
	b=0VLn1dT7vdP1wiiD2tYdVWdrIfuNPgL9FFqr6HZr7tRPUIlzoqJKVbWChvt208f1aDuF
	 41vWqWEeT9s2CP04zGieBXCpnuRf2Mzeuc9kzKeDlyyebBwXq0WVfjmtZtTBjPpZVTAmE
	 HPTWirj3uVyST8bUIgw32RMVyKT2fxY3V6evA8z/mF18d8Op1bY/Ppe1bIKMD/j1Taahw
	 xZqQ4ovletsNUY/vXdfrUXuOlJuyy4NeC1eI+XF/ghV3dteE2b1CQPG1TmP8qUK3kOF3D
	 vUBzZ3cmBLSGSzo1isYSZTx5Q7quykmvxRSeH4fN6EpDOwGBHL2UxJz9LhVxoQHDIwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=C4Na7Qt4;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE84860A261C
	for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 14:23:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE84860A261C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=C4Na7Qt4
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so3658735e9.1
        for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 07:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792592603; x=1793197403; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iuEnBt+F5UUTH/XMt7g5zZaMh5IRL3eqw/WM+8xQBzo=;
        b=C4Na7Qt4QPYOnjreA475v12gom9L6cej5R4nItHHXln44tIP/GcaClek6mHF01Z0/j
         SDhmNM8WHQDlXWXPojgndMS/5tEriQwyoUn+pA116DzaN/nDlff0hDnlxG66IZckjgAc
         4AcbsRpXDVXIP8S0nxHLtIEl4ei7IQ5UZD879wobk0Ke5jl34776yjHI5E8Rr3qoy4tn
         +AhtC8q6sVhG1I1YnTZsR4SFQQB4MZ1WX1RIJTvc24pqnykiVVJ0lhVf741nEGy2/nMQ
         a/pueUWBye7AFk46vDNkFzUr00rAB13Q1W4sGgnDE3bDdxFxpLZy8Ky4UMwwM7eV4LO5
         +GYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792592603; x=1793197403;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iuEnBt+F5UUTH/XMt7g5zZaMh5IRL3eqw/WM+8xQBzo=;
        b=GWWT9dBulvggO8Ex2i/ujMawFqLN66qK1Wc3iBtpZgjqqhkl2mzHlKqI6zgELwb8n9
         AkU5HdGbrqiQDoy4k+UXvV5o78vZtwpCamgcIwForlpLGrD6USBIk9WdSNB3BOLUb+Vm
         CaeAz4ycqf6hO7E96rtOKK1UdDvvD+WyDiwPpIishjSGbr36XXLXUu0caF8oHM7BsIh0
         8ggodCBWSqWDMAhR7KD17/XQP4F36c3UK/rdw76Aiea8PJScUayqaXOPUiiTUwZXg+KP
         47gFAsBLs+w1lMfz6ulEZERXDcjbCJunaX7s3MMGc9uEHVmplLoJ4/Xe8PS3JXyDgJYX
         NUag==
X-Forwarded-Encrypted: i=1; AKwUvBxckRBhkFrGHt7s5q8FdurzhasVe5EcWCFjpFnrgKJZJ8hfMaUzNdi5mEHdxLsPMzxA3gjPe3X/984=@vger.kernel.org
X-Gm-Message-State: AFq9FYJP0CInTCDNzLDk4yMxNVneUIvEDT8SUTIDiAXfb55egsGYbiL1
	astumv6OBxHJhirzD78Qa8N9OuSelnvOrddO1Lt12Y5JkN+0TPd3xEEtS01Zhu3XAwY=
X-Gm-Gg: AYBFou1bvFiTgS3CM2TSHNgQAw3ktWO7FWg6DFN6kY2UV9dz5elI/ZpqA9BmN/yvfps
	kGeMRMgUkg2qWuJmoLkBJ3lcfuSFhix/ypRUGHRjldPbIpcVfukN7gilgsfMQOJ7FJGHcJyBClf
	5DcFMAiXd61rJ2Wgo7xCdjuFl43q8gG1hmIMn2q/aCtRW6tM1GhMl3PghUDv/tsZZKJChyYNMdX
	b30Ah0aESug/PIPzVQXHdUjw7cEz9t3HhKArc9Whk8v/AE0IA076jlMOs/qfhq1Q2x09tOJ6HQw
	Z2Vrxo5lO69QZLgHxa2+nGHCWRA7MvRu7dDoPexgzhHL1iEq+XMOSo7dgrCvvYdMKe9xlsjL30U
	9Z53tkWMIqeossacQEWq7aHG0SvEaV9a9BTHBpOntUS7yK/1nLdO7K7pXuc1ReQo6ChGxkw0bH/
	G5cALrikNM65vUJNciyH66QPWPpR5Lq3Htu81XDvwm92N5Jioc7ww4/7LQoKm8gUi5IsYY8BlMv
	OvqM+gRHx/oNzI+Zctj1nCxh7HOieTa/NI1mM15gq0Xgr2/dcgWBf1LOH9CQd2OagGou04o/2HL
	g8vX8zgeDOrN
X-Received: by 2002:a05:600d:4447:10b0:4a1:d459:db4b with SMTP id 5b1f17b1804b1-4a1fdd32773mr37078515e9.24.1792592601425;
        Wed, 21 Oct 2026 07:23:21 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e258424bcsm5744427f8f.55.2026.10.21.07.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 07:23:21 -0700 (PDT)
Date: Wed, 21 Oct 2026 16:23:17 +0200
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
Subject: Re: [PATCH RFC 13/20] Documentation: ctlv: Describe how to write a
 family
Message-ID: <atjEgLYpgbZNzfkZ@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-14-jiri@resnulli.us>
 <179245258505.58760.3972297562218204862.b4-review@b4>
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
In-Reply-To: <179245258505.58760.3972297562218204862.b4-review@b4>

Tue, Oct 20, 2026 at 01:29:45AM +0200, jgg@nvidia.com wrote:
>> [ ... 34 lines skipped ... ]
>> +Add the specification, registry entry, and output manifest entry in one change::
>> +
>> +    Documentation/ctlv/specs/ctlv-example.yaml
>> +    Documentation/ctlv/families.yaml
>> +    Documentation/ctlv/generated-files.yaml
>> +
>> +``families.yaml`` is append-only. Its array index is the family ID and is part
>> +of every generated attribute and operation ID. Never reorder, remove, rename,
>> +or reuse an entry. ``Documentation/ctlv/abi/families.registry.yaml`` is the
>> +checked-in registry ABI. The output manifest selects the generated UAPI,
>> +kernel and userspace paths and generation modes.
>> +
>> +Generate and verify them with::
>> +
>> +    make -C tools/ctlv regen
>> +    make -C tools/ctlv all
>> +
>
>Maybe mention to inspect git diff and ensure nothing unexpected
>changed?

Okay.


>
>> +Never edit a generated output. Change the YAML or generator and regenerate it.
>> +Optional RST reference pages are written to
>> +``Documentation/output/ctlv/families`` by::
>> +
>> +    make -C tools/ctlv docs
>> +
>> +Write the specification
>> +=======================
>> +
>
>Before introducing the YAML, write out in a more plain text form
>exactly what system calls the example is aiming to create with. I came
>up with:
>
>For an example, define two system calls from userspace that look like this::
>
>    item_set_action(u64 index, string label?, blob data?) -> status;
>    items_dump_query() -> { u64 index; string label?; }[];
>
>And one event::
>
>    item_changed_event -> { u64 index; string label?; };
>
>``index`` is 0..4095, ``label`` is at most 63 bytes excluding NUL, and ``data``
>is at most 1 MiB with 8-byte alignment.

Okay.


>
>> +.. code-block:: yaml
>> +
>> +    # SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>> +    %YAML 1.2
>> +    ---
>> +    family:
>> +      name: ctlv-example
>> +      inherits: ctlv
>> +      post-init: true
>> +      pre-fini: true
>> +
>> +    attr-groups:
>> +      - name: item
>> +        attrs:
>> +          - name: index
>> +            type: uint
>> +            max: 4095
>> +          - name: label
>> +            type: string
>> +            max-length: 63
>> +          - name: data
>> +            blob:
>> +              direction: input
>> +              allowed-backings: [ va ]
>> +              max-length: 1048576
>> +              alignment: 8
>> +      - name: list
>> +        attrs:
>> +          - name: item
>> +            attrs: item-reply
>> +            max-occurrences: unlimited
>> +
>> +    attr-sets:
>> +      - name: item-request
>> +        attrs: item.index
>> +        optional-attrs:
>> +          - item.label
>> +          - item.data
>> +      - name: item-reply
>> +        attrs: item.index
>> +        optional-attrs: item.label
>> +      - name: items-reply
>> +        optional-attrs: list.item
>
>I haven't quite figured out what attr-sets is about. I think these
>blocks should have some # comments with more guidance what is going on.

"group" defines attrs with all the description once. "set" just puts
together multiple atrrs from multiple groups. Will try to document it
more clearly.


>
>> +
>> +    ops:
>> +      - name: item-set
>> +        type: action
>> +        optional: true
>> +        request:
>> +          attrs: item-request
>> +      - name: items-dump
>> +        type: query
>> +        availability: dynamic
>> +        pre-post: true
>> +        reply:
>> +          attrs: items-reply
>> +        suggested-reply-length: 4096
>> +      - name: item-changed
>> +        type: event
>> +        reply:
>> +          attrs: item-reply
>> +
>> +An attribute has one payload form: ``type``, ``enum``, ``flags``, ``attrs``, or
>> +``blob``. An attr set names one message level. ``attrs`` are required and
>> +``optional-attrs`` are optional. Its bounds and membership are ABI.
>
>The attribute first point of view is maybe a little too netlinky, I
>prefer to think of this as a system call first, with a first class
>'query' to get a list of things
>
>Alot of stuff this is going to deal with won't be the netlink esque
>'dump a table, set a table' kind of flow, but a bunch of different
>system calls with arguments.


Can you elaborate a bit more about this please? I'm not clear about what
you mean by this. "'query' to get a list of things" sound cryptic to me.
Are you talking about doc or about family yaml as well?



>
>> +
>> +Inheritance and extension points
>> +================================
>> +
>> +A descendant implements only the operations it declares. Inherited operations
>> +keep the callbacks and operation hooks of their declaring family. Every module
>> +therefore depends on the module containing its parent implementation.
>> +
>
>This section seems hard to understand, it is missing something
>explaining the purpose an intended usage of this mechanism. I think I
>get it.. 
>
>Maybe structure this to be an improvement to the first example solving
>a specific problem 'like the HW driver need to add per-driver
>things to the scheme'

Okay.

>
>Also please use a more neutral term like "HW driver" not vendor
>throughout.

Okay.

>
>> +A parent reserves an extension point with an empty stub set:
>> +
>> +.. code-block:: yaml
>> +
>> +    attr-groups:
>> +      - name: device
>> +        attrs:
>> +          - name: details
>> +            attrs: details-extension
>> +
>> +    attr-sets:
>> +      - name: details-extension
>> +        stub: true
>> +      - name: device-reply
>> +        optional-attrs: device.details
>> +
>> +A child fills that same set:
>> +
>> +.. code-block:: yaml
>> +
>> +    family:
>> +      name: ctlv-example-vendor
>> +      inherits: ctlv-example
>> +      pre-init: true
>> +
>> +    attr-groups:
>> +      - name: vendor
>> +        attrs:
>> +          - name: serial
>> +            type: uint
>> +
>> +    attr-sets:
>> +      - name: details-extension
>> +        optional-attrs: vendor.serial
>> +
>> +The parent implementation opens the physical nest and delegates its members:
>> +
>> +.. code-block:: c
>> +
>> +    if (ctlv_example_device_details_start(reply, &details)) {
>> +            ret = ctlv_stub_fill(ctx, request_details, &details);
>> +            ctlv_nest_end(&details);
>> +            if (ret)
>> +                    return ret;
>> +    }
>> +
>> +The generated child callback fills it:
>> +
>> +.. code-block:: c
>> +
>> +    int ctlv_example_vendor_details_extension_fill(
>> +                            void *priv, struct ctlv_op_ctx *ctx,
>> +                            const struct ctlv_cursor *request,
>> +                            struct ctlv_cursor *nest)
>> +    {
>> +            ctlv_example_vendor_vendor_serial_put(nest,
>> +                                                   example_serial(priv));
>> +            return 0;
>> +    }
>
>I suppose this like RDMA and each HW driver using this gets its own
>full scheme tree that only has its own stuff in it?

It's the "family". Each child inheriting a subsystem family. It fills
up the subsystem family defines stubs/extensions. It can add ops too.


>
>What about userspace, it "knows" somehow what to do?

Userspace sees the family chain. It also has ability to do introspection
seeing right away which op supports with attrs in which nests.

>
>> +
>> +An unfilled stub contributes no nest or message length. Neither side names the
>> +family on the other side.
>
>One of the things I feel strongly about from iommufd is that it should
>be really obvious what HW drivers is being affiliated with these
>operations that have a HW driver struct linked to them.
>
>So, like, if userspace does a query and gets back an item that has one
>of these extended structs it should have a trivial way to branch to
>the right handler for it. Inspecting the attributes doesn't seem like
>a great way to go about that?
>
>Is there some place to put an ID of 'ctlv-example-vendor' someplace?
>Like in the nest start somehow?

Already there. Each attr including nest contains family id. So a fill
of a parent stub/extension by HW driver contains a family id of that
family.


