Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792541492;
	b=T8XdnCicc5QIwVkTGsP4DEPKtcYyKsjt6LU+129JIWSMxFROsYeJJ+CKdD2ZKpfSN5N2
	 EZ0ZFag7La63iJeK7RcSSE/i8fygbq+i3uaoAr8lJOk422an24u+6P4gtGUbc40Ret7dd
	 9a1sdd6PsKpsYcIXhxpNCBaGgHnWIqvuVLHhwynV+nTRkLP3pYiIYqyHSQFV2j/WQF920
	 pEvMYVVi95HTCaZ2yZyCgaYUmpO+rUsV3qThW2l0C06y0NeuSJOb3MCYniIBfqHYAs1kq
	 Lwbg2OfJ6uxhz5Zu/PBm+FyzAt6wiqRhCyUamDZRidSHfud2zI1hU40L5+cqHlzDcXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792541492;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hF/NVSIGqhReGkuR8l8l7ldrX98gFDhXwwk03UUZXzo=;
	b=MFIOH0pUg9OI9NxNFvexMMcpmGlt6/Au17HAqxEfxnbZLp4IllHzW9h02vU9kqxpYEQl
	 1WbcR7lqkVSwks9AA37IIwJYN/u4EyYP5EHFulQtPhHO4TUqKUVmwmDWXdR4crRhYI4m0
	 h0COCx15LXst1wvUDM0a3MjkMH93NEDxXNdsxObCGwgtXyKB/VFTsUxk7cpYbneAQsuhI
	 FscvJ3bDk6RZZA3Omth4gw4c1aqkrW9vLSlUj7on8wz7tWoqEQYfAyslI38AQ+pgeWMlp
	 Tvv8uawup9/j/OzMn3eaw0cWb1NSt4vxFhQq19SHxwwGKsuExV+MLhMd5hZ/oDTchiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bh1mPlyR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419FD606A31E;
	Wed, 21 Oct 2026 00:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bh1mPlyR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5631F000C9;
	Wed, 21 Oct 2026 00:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792541491;
	bh=hF/NVSIGqhReGkuR8l8l7ldrX98gFDhXwwk03UUZXzo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Bh1mPlyR4d/Aa6+b0/54lt5FVWSeDh4fsANn5drfHHtVwhwB9sLzY0qNfJq6MDT0A
	 ONBmguIXjydtbIp4Ctn5/hTDK9IaDhqO/uDnxiJ5Jmq/SwCp0+RvKNBtZPb4pEtAIb
	 p6llR7J0PSvXXa61iLI/LcktVR+9+33W5h1SXaNuBgfh4HwuYsuzyzdzzxyS8p85Hg
	 N3Ck/jBJhUP4i9evWJHAKgF8jJJMQDTuo7LUihgmF+wlzuQgf3oO+jTzuFXcS0lYIR
	 RAy7I9ay/BQkXpINvwS71JoH/vIkaqmvm7vC9B7q3pxrpV0oiitqXT4V7qT9FNbdaE
	 CfFaTn49+nvmA==
Date: Wed, 21 Oct 2026 01:11:22 +0100
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
Subject: Re: [PATCH RFC 04/20] Documentation: ctlv: Add userspace ABI
Message-ID: <20261021011122.2cd96901@jic23-hlaptop>
In-Reply-To: <20261015145053.3664509-5-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	<20261015145053.3664509-5-jiri@resnulli.us>
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

On Thu, 15 Oct 2026 16:50:37 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@nvidia.com>
> 
> Describe the CTLV transport, discovery, wire format and userspace
> compatibility rules.
> 
> Assisted-by: Cursor: GPT-5.6 Sol
> Assisted-by: Cursor: Claude Opus 5.5
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
In general looks good to me - this let me get my head around
what was going on nicely (I think!).  A few trivial comments.
> ---
>  Documentation/userspace-api/ctlv.rst  | 507 ++++++++++++++++++++++++++
>  Documentation/userspace-api/index.rst |   1 +
>  MAINTAINERS                           |   1 +
>  3 files changed, 509 insertions(+)
>  create mode 100644 Documentation/userspace-api/ctlv.rst
> 
> diff --git a/Documentation/userspace-api/ctlv.rst b/Documentation/userspace-api/ctlv.rst
> new file mode 100644
> index 000000000000..5ebca3d4d94a
> --- /dev/null
> +++ b/Documentation/userspace-api/ctlv.rst

> +Discovery
> +---------
> +
> +Both uevents, addition and removal, carry the family chain as numbered
> +properties::
> +
> +    CTLV_FAMILY=ctlv-accelerator-foo
> +    CTLV_COMPATIBLE_0=ctlv
> +    CTLV_COMPATIBLE_1=ctlv-accelerator
> +    CTLV_COMPATIBLE_2=ctlv-accelerator-foo
> +    CTLV_COMPATIBLE_N=3
> +
> +``CTLV_FAMILY`` is the family the device answers as, the numbered properties
> +are its ancestry from the root to that family, and
> +``CTLV_COMPATIBLE_N`` is how many there are. An index never moves: changing a
> +family's parent is an ABI
> +break, adding a descendant only appends.

Odd line wrap.

> +
> +A program that wants every device, including ones appearing while it starts,
> +must listen before it looks, which closes the window between enumerating and
> +subscribing::

> +A whole message with every offset, for a request of one integer and one nest
> +carrying a string and a further nest::
> +
> +    offset  attribute                       len  flags   contents
> +    ------  ------------------------------  ---  ------  ----------------
> +         0  root                            120  NESTED  attr_id = 0
> +        16  .. chunks                        24  -       8-byte integer
> +        40  .. chunk                         80  NESTED
> +        56     .. label                      19  -       "ab" and its NUL
> +        80     .. item                       40  NESTED
> +        96        .. value                   24  -       8-byte integer
> +       120  end of message
> +
> +    +--------------------------------------------------------------+ 0
> +    | root: len = 120, flags = NESTED, attr_id = 0                 |
> +    +--------------------------------------------------------------+ 16

Diagram wise, should chunks and chunk be shown nested inside root like your
.. above is indicating?

> +    | chunks: len = 24 | payload: 8 bytes                          |
> +    +--------------------------------------------------------------+ 40
> +    | chunk: len = 80, flags = NESTED                              |
> +    |   +--------------------------------------------------------+ | 56
> +    |   | label: len = 19 | payload: 'a' 'b' 0 | 5 bytes padding | |
> +    |   +--------------------------------------------------------+ | 80
> +    |   | item: len = 40, flags = NESTED                         | |
> +    |   |   +--------------------------------------------------+ | | 96
> +    |   |   | value: len = 24 | payload: 8 bytes               | | |
> +    |   |   +--------------------------------------------------+ | | 120
> +    +--------------------------------------------------------------+
> +
> +``label.len`` is 19: its header and three payload bytes, not the five bytes of
> +padding after it. ``chunk`` counts those five, its ``len`` of 80 being its
> +header plus ``CTLV_ALIGN(19)`` plus ``CTLV_ALIGN(40)``. A walk over a nest's
> +children advances by ``CTLV_ALIGN(child.len)``, a walk of one payload by
> +``child.len``.

...

> +
> +Request occurrence order
> +------------------------
> +
> +Occurrences of one attribute ID must be contiguous within each request root or
> +nest. ``A A B`` is valid, while ``A B A`` is not. An ignored unknown attribute
> +is not an occurrence of any known attribute, but it ends the preceding run, so

An ignored unknown attribute, whilst not understood, ends the preceding run, so ..

(or something like that to avoid saying unknown is not known ;))

> +``A ignored-unknown A`` is also invalid. Different IDs otherwise have no
> +required numeric or schema order.
> +

> +
> +Executing an operation
> +======================
> +
> +One ioctl executes every operation::
> +
> +    struct ctlv_op_exec {
> +            __aligned_u64 op_id;
> +            __aligned_u64 request;      /* struct ctlv_attr __user * */
> +            __aligned_u64 reply;        /* struct ctlv_attr __user * */
> +            __u32 request_len;
> +            __u32 reply_len;
> +            __aligned_u64 generation;   /* queries only */
> +            __aligned_u64 cursor;       /* queries only */
> +            __aligned_u64 reserved[2];  /* must be zero */
> +    };
> +
> +    #define CTLV_IOC_OP_EXEC _IOWR(0xBB, 0x00, struct ctlv_op_exec)
> +
> +``request_len`` is how many bytes the kernel may read at ``request`` and
> +``reply_len`` how many it may write at ``reply``. They are copy boundaries, not
> +message lengths: a root's ``len`` may be shorter than ``request_len``, the
> +bytes after it being ignored, and may not be longer. 

I don't really mind this but why have this relaxed? Whatever sent this request
just filled in the root len so why wouldn't it use the same value for this structure?


>``reply_len`` is never
> +overwritten; the length written is the reply root's ``len``. The pointers are
> +fixed-width so a 32-bit and a 64-bit process pass the same structure, and in
> +place of a size field the ioctl number encodes the size and ``reserved``, which
> +must be zero, covers compatible growth.
> +
> +Every action and query carries a physical request root, including an empty
> +request. ``request_len`` is therefore at least one attr header and at most the
> +1 MiB transport limit.

Why this particular limit?  Any thought to making that discoverable rather
than fixed? (with a minimum to allow the operation for the length to be discovered).

Maybe it is better to just have fixed size.  I wonder if ultimately we
may end up with cases where the tlv is just passed on to firmware / device
(because it is nice and convenient!) and having to split or marshall
multiple messages would be a pain.

> The ``request-max-len`` reported by ``ops-dump`` is the
> +maximum request composed from the known schema; a newer caller may exceed it
> +with well-formed unknown attrs marked ``IGNORE_IF_UNKNOWN``, up to the
> +transport limit.

> +
> +Events
> +======
> +
> +An event reaches a file description that asked for it, and only that one:
> +
> +1. subscribe with the ``subscriptions-add`` action, naming operation IDs;
> +2. read records with ``read()``, one complete record per call;
> +3. unsubscribe with ``subscriptions-remove``.
> +
> +``poll()`` reports readability when a record is queued. Each record is a
> +header followed by exactly one root attribute::
> +
> +    struct ctlv_event_hdr {
> +            __u32 length;             /* header + aligned root */
> +            __u32 flags;              /* zero */
> +            __aligned_u64 op_id;      /* the event op that produced it */
> +            __aligned_u64 sequence;   /* per file description */
> +    };
> +
> +One ``read()`` returns one record, the header and the aligned root::
> +
> +    +---------------------------------------------------------------+ 0
> +    | length = 24 + CTLV_ALIGN(root.len)     | flags = 0            |
> +    +---------------------------------------------------------------+ 8
> +    | op_id: the event operation that produced this record          |
> +    +---------------------------------------------------------------+ 16
> +    | sequence: counted per file description                        |
> +    +---------------------------------------------------------------+ 24
> +    | root: len, flags = NESTED, attr_id = 0                        |
> +    |   the event's attributes, exactly as a reply carries them      |

stray space.

> +    +---------------------------------------------------------------+ length


