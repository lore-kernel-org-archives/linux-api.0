Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91453A5E7E
	for <linux-api@vger.kernel.org>; Wed,  3 Jun 2026 19:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780516802; cv=none; b=QI6js4u6VP3jDODg2nCSA75IvZDxfE40jQ40GB1IPuR8DAbHRm0VFYFxlNpL3CBIEe9smumIgx7Cnp6eVvhhOP2/TKr1Mhe2ZrED1R0x/p2Qqh3OPLCc9iG4LhH469XKwC1oPd+qzuNdbbmhV+aO5AHzonS6lRyb1vNNMu+K8yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780516802; c=relaxed/simple;
	bh=cJCdMggMBtlaRufFOzf56NF2SmvXVse1UnTO+KmUUY8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CqCf/O29C7PSAXW/5y4glOoIC7/95uZ9hj2HklAOKbomYHClprcqKL2mtim21vjcKttk3zFLtB8QOxr6H7KqByofzD6PYqoeylV/iYnTb3EPkNv0XMs4f+gFC5ma3mZUdubqz2JIDgacLrVzEi+8gapiFlFhaIX78wId/pPlRNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FdaO0QAS; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FdaO0QAS"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c0c2d792c8so28155655ad.1
        for <linux-api@vger.kernel.org>; Wed, 03 Jun 2026 12:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780516799; x=1781121599; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rLwU6+VwyCgHprpb82bpoZ1vCU00viaTeQ4mjhQKQr0=;
        b=FdaO0QAS68QWZT6jQqIW4sa4Ov++CF4dW/hkpwuHa5YogIfOMTRRb7tEkWBZe/Wg2w
         5lPTmM5Qk0b4p3OD4lBcrq7256uc2LWeh6DFFlNa07IFXkwp3dKExRcXNUJus6YMUWBc
         8GGY63KpV6K9UZc69JVnJZfsEIZNNMNyam9OI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780516799; x=1781121599;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rLwU6+VwyCgHprpb82bpoZ1vCU00viaTeQ4mjhQKQr0=;
        b=nfBwN5JY658971TtRqEEqm1tJMNtX3dl1yaG1t2lgGPXMRGxt3gSMB0Llxc2EWlVyo
         L21eJ3Fiztri39iXSiofGyttCewhNeGKNpnPEP+tPB41V+JL7ppbaIsqvf28RLL0MQvE
         MQ7scJIpvKpygssF3Zb1xpY0rAfUIkPJx3f2O0DcwG3WsZ8iTXNwgsm7iWbj5CFJqzMR
         UShmNvmJWzuXVVd8wvSArZGLERIvuCFC4whMhb/QumdBrSZISRtlEw2DyMWyli59h02U
         X75ST3Bm3Q8/hwqoD1Xnv89Nh8k5DfEHP7iRyxO93cnTLkp0K7c87k7pVpP9fIYokKkU
         ZTFw==
X-Forwarded-Encrypted: i=1; AFNElJ+OVnkYBRIJn6KhF1KFpSswP4o+1EzoDmNCtEO0v6AHTIrdmHhnfvhi8++/6tT83E730e6X5zhFQbI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyU74f+rFQaJr9HHBPj6KyxVcC+WYv/8Xq4ZOyRZfdthVK4WDQJ
	BtkGG+7aW8HWawgzEh/IcU+7Lr613tzw9POOfNCnXmo06TuiNgXXG4V0avXj+A2o8aT01Wc4+Pf
	SN9d05Bum9A==
X-Gm-Gg: Acq92OHVmc/eRuY/eOAVXzWP408RhJiDJJx1Y+FRdMo3lYCu0LLEXqdG/CTvMm3YQYQ
	yQQC6anqlmo/EGD3M2YK4ecemN5oURPkdyEcSM4q6dt2evgHKaDwfWQKNI3gMdiz+y4Ov6S+Isj
	+GD2s7nM0DN4nDbYXG2KVK48/6Aqg4MTsUu+xPNgSwW7pobUnyLieEctFzbfvhz/hrlU/yXjcKB
	32U6RMeTka09VyCx77Bn2PXTx/GDpEVPyC7NfnXJFFudJPpIe8mAjVkmE1XQ40Z8hvgrqhInbPK
	hLAgGcVaO6Kn3fYVAnGa1n2ooBgYvg59HSF6hIzNOKs/rgx7fe4mAqSXJxyK5p31N8nLkAjdQxd
	YKhtkR4MujOY2GUiDCq23r3WC9kTtqvL3QuWi7ooCUUln0oB+9j7Cc9y0xNGBsrWZEb4K3qIZqi
	kAlWXsJl1HJ4gxqKfU7/JPWaMVNm5wKL4e6jYyhhRswxC7ZYn14dOV6MvAEfNEk8VF/QyWKfhZD
	FfQA9WfpHM=
X-Received: by 2002:a17:902:e54f:b0:2bf:2114:ecc2 with SMTP id d9443c01a7336-2c1644b2691mr53104055ad.35.1780516798866;
        Wed, 03 Jun 2026 12:59:58 -0700 (PDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com. [209.85.216.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164fa404fsm35575645ad.37.2026.06.03.12.59.58
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 12:59:58 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-36babe2c4bdso3878719a91.1
        for <linux-api@vger.kernel.org>; Wed, 03 Jun 2026 12:59:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9LR7Qq/X2LNhOTM7zwUj23/ZfXy7Rp111YiWUTq6aaO/YF8uu2yNRoRMMMrNEE4vfsJxMI5Abni6E=@vger.kernel.org
X-Received: by 2002:a17:90b:2f86:b0:36b:77b9:5c8c with SMTP id
 98e67ed59e1d1-36e3237e125mr4484034a91.17.1780516797989; Wed, 03 Jun 2026
 12:59:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com> <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
In-Reply-To: <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 12:59:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=whkGbMoP-Dym8pAd3hV21=BZST+6sK++1X038+9Q-TgeA@mail.gmail.com>
X-Gm-Features: AVHnY4Jw9pwWVUIawcRWYEJbSOr_4eFJHRjDI61fxjs_qgnMfY70yBDODQXhxd4
Message-ID: <CAHk-=whkGbMoP-Dym8pAd3hV21=BZST+6sK++1X038+9Q-TgeA@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jun 2026 at 11:28, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But even then you need to have a *handle* to the buffers for the
> general case, and that's what the pipe fd ends up then still
> effectively being.

Again: for sendfile, you don't need the handle, because you can just
"read the file data again".

But the the handle is needed for any buffering that can't do that -
iow pretty much *any* other case than a file-backed source.

So the original use-cases included things like copying media data from
a TV capture card to a GPU for outputting in a window.

There it's actually the intermediate buffer that is the important
thing, and it needs to have a lifetime that is independent of the
system call itself, because the system call may be interrupted by
signals etc, and you can't just "read the data again" when you
restart.

So the whole idea with splice() is that you have an input, an output,
and a stateful buffer between the two that has a lifetime.

Having just a iov_iter isn't enough - even with the current much more
capable iov_iter we have now (compared to when splice came to be: two
decades ago when the modern iov_iter didn't even exist). You have to
have that notion of a buffer with a lifetime.

(iov_iter came a couple of years later, but it then took many many
years for it to become the powerful thing it is today where you can
put almost arbitrary data into it - it started as purely a user space
iovec iterator, all the bvec/kvec etc stuff that you need for IO
buffering came a decade later)

So there's historical reasons for the use of pipes, but there really
is a very fundamental reason for it too: wanting to *generic* data
transfer between two points, not sendfile.

It's worth noticing that in the generic case, zero-copy isn't really
even an issue.

When you think operations like "splice TV capture input to a pipe",
you typically need to allocate the pages that you then DMA into
*anyway*, and you'd just put those pages into the pipe. And the facty
that you can then just take the data directly from those pages when
you splice from the pipe to whatever GPU engine that does the decoding
is kind of secondary.

So again: the big deal with splice() and the pipe isn't really about
zero-copy. It's the in-kernel buffers where the drivers control the
allocation and you don't have some "user space allocates memory, then
kernel looks that allocation up and uses it" model.

Having less copies is kind of incidental. It *might* happen just
because it's natural when some streaming device just gives it data
away and doesn't care after the fact.

The problem with splicing from a file has been exactly the fact that
it's *not* streaming data, and the filesystem zero-copy case gave
direct access to the long-term cache.

Which is undoubtedly good for performance. But it fundamentally
*requires* that the sink is trustworthy. Which has been problematic.

That's why sendfile() is bad. Not because splice itself is a bad
concept, but because you have to have that absolute trust across
components.

          Linus
