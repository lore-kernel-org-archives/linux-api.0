Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8729F3DB320
	for <linux-api@vger.kernel.org>; Thu,  4 Jun 2026 21:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780608742; cv=none; b=e/DsXA0eoAVUUkpWphZ4H3ROV8h+Mg5w86UoKHR2hkuz9fBlWESDT3v0IIueHWC/BKobX1bxMLErx130mw5nfyUQkg7BHK2TndraFKFl766iBLpfe8vv4er+Ch+38XhDzZbuu6k7KkKDnChwRtx+Or/b0E25URbAP0vzw4JUwRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780608742; c=relaxed/simple;
	bh=SgWKOY85N4QXHw6DJquJOy0hqfu11eB/INo5oQyQqiw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=suf9qjP33xHCjjCdksMrXGqrFXpiUwwIkzP8Vv/HR2VUlzDNEbYI8x29Esd7mnVaFlYv4SLWxPqII0NTFZvqXB/b9rdUi83zLvlabOBwXy+Z9c5VyCz3eHUvEpNAG6QeDJBJmwIeT90W3EBuOVVK17h3rzABlSWaUdiJ1fOCwsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FRNqCzl3; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FRNqCzl3"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490b8ac62baso15811405e9.0
        for <linux-api@vger.kernel.org>; Thu, 04 Jun 2026 14:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780608739; x=1781213539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQN7agybo6gzy0fVoImTNH+8qqV3opcO9FSCB/3Heuk=;
        b=FRNqCzl3sbzOovDDK978itlbuhw2Msse9nhImaUZTPk6UF67PziAOWjVIcPIk+8ALo
         8YY5/h8G1rsC0C041mmtds/9kfbCfhpe5OroEUoax84EXhJ/rQEaWVwG8zWS73M0FXG+
         5780ygw4cLNX4n9G2SDqg4BbQAmPB3ehcbTy6IRURs/lv6iNBm61LMY3QxQq/FEiB74L
         1H/iSXfZQ2XiRKAHo/hLDw/6khkBJIu8xChkKgkALJPhdzgMcNsyz7pF2NTwdiQ6JwE9
         Ci2332wI0A0RwxWDFOaMf603qqFIIHQkl8aLC3n3BeKqCghDikbtGmFTracqB+y/P7Cf
         5t9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780608739; x=1781213539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IQN7agybo6gzy0fVoImTNH+8qqV3opcO9FSCB/3Heuk=;
        b=slf8y0tjhLBzCOFBrUVpmg6ABp2CfmWL1bLuHt/58kv87KorO3TBQLIthFi5sMbC9e
         jRA5hBNaT6C+BK1vZhjENxmzcLuQCuh5cj00wvGFDpSI/C4ewpD+6pQaUo0aQiZ+PcKg
         Wb2uZozNExIL+BgrA2yLjjchm8PW1lNzWSMBsThoR2zdmNu9H1+RDSxMIKIYvN1M4dHp
         CXVh4r4PefJpB//iHCWUnVWOQpFXzjWdMpeES/hsLjxtdWTi4j2uflW2y86UeybwouBs
         CI5kubNLLgxFGlzvVslT7rdI9IbCRz+2Hs4/f+GTIQlRnDvQfYRhb3EDdbIjEyWdlYS2
         Xc6Q==
X-Forwarded-Encrypted: i=1; AFNElJ+C36/+sb8tOAGgWenY5FmmnXRWVMWEbInSCnbjWEki1JifLYEyFvJh/FBhcX9TqR5S0+GtWlK0w7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV7b5f297S4BkRY3yeoKKF73YpG8dhG2I+SYv/72z0sbLv9p/G
	/uj5kPGQYP5eMq5Zupq+bm07AfvK5YUrExwyRIoxkQFcmMqgDvHRBe1a
X-Gm-Gg: Acq92OFpQdxZTUCrunBs3rVUAxIKPeHT9+m8Kieo7nGgmOsP9Yxtrze6qsm8YTjUHFd
	If3O1hsUA5o6z0SOINyNyPsPFtsaJ74BSLXGQuIDexM/EPXSh/HlOlx1fPNNOtG4vFcBEKJChWK
	mmYB72zCXR+21hU0oqQIscUmxeeGFm3eCLQMK9UUk1Np58YbiGcVtI0AvaG26HkI5bWBL+FJMie
	1nxPsBHUrKEHSwMo/xObVO5akk1ybK+SVXy5sCkj6nzNK9T+bRiQ4U2F2hCFTK2s4Z6a2iLdP5n
	Hvp3VKo0iNQRXVFV5e5yfcj+N8viLn1ohVeovNphsjXDk5s/mA8EKIEb2W5X8XulEOXtAzUXhoT
	OO4ZZJRlyAHmCsjHyI+nYcL0rcbJlbryI+GIN5b7u2xOwZfXBNVm/nj2aBf157qGmBjoaPmlFWu
	vTwp5h5XglQO4qp+mxXtAZ3rlloRRo6MBi6g6aLIMehe6eD7eG+IoXZCbvK462gx4lZMNZ38g=
X-Received: by 2002:a05:600c:348f:b0:490:4b89:5372 with SMTP id 5b1f17b1804b1-490c25e2739mr4133095e9.11.1780608738825;
        Thu, 04 Jun 2026 14:32:18 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3918fcsm111713545e9.3.2026.06.04.14.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 14:32:18 -0700 (PDT)
Date: Thu, 4 Jun 2026 22:32:16 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, metze@samba.org,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260604223216.73468830@pumpkin>
In-Reply-To: <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
	<20260604100609.6b37f500@pumpkin>
	<CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
	<20260604183829.63c35fd9@pumpkin>
	<CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Jun 2026 12:30:30 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 4 Jun 2026 at 10:38, David Laight <david.laight.linux@gmail.com> wrote:
> >
> > Bool is another matter entirely, (IIRC from a couple of weeks ago)
> > gcc will assume that the low 8 bits of the parameter register are
> > either 0 or 1 and clang assumes that the low 32 bits are 0 or 1.
> > You can't even check with 'if ((u32)bool_param > 1) error()' because
> > the compiler 'knows' it can't be false.  
> 
> Nobody should ever use 'bool' as a system call argument. Anything that
> takes a boolean should take a 'flags' field with bits.

I was thinking of more generally, not syscall arguments.
In C you can't really guarantee that a 'bool' variable will always
contain 0 or 1.

Even if you write: https://godbolt.org/z/81P87vv7o
int f(char *p, _Bool b)
{
    return p[b ? 1 : 0];
}
you get *(p + b), neither (int)b, !!b or (b & 1) make any difference.

Talking of broken compilers, had you noticed that:
struct foo {
    int a;
    char c[32];
};

int b(struct foo *f)
{
    return __builtin_object_size(f->c, 1);
}
returns -1 (size unknown/indefinite).
You can't use __builtin_object_size() to stop code running off the end
of anything referenced by address - even when the size is constant.


> But this is basically what a lot of the SYSCALL_DEFINEx() macros are
> all about - sorting out ABI assumptions.
> 
> For example, on powerpc (iirc - maybe it was 390), a 32-bit argument
> is always sign-extended by the ABI, and the compiler *depends* on
> that.

I think riscv might sign extend 32bit values in 64bit registers.
x86 and arm both zero extend.
Zero extending is more friendly to the kernel where pretty much
all values are non-negative.
I think I've used signed variables slightly more often than fp in the
last 47+ years.

-- David

> But at system call boundaries we can't trust that the user side
> actually follows the ABI, so SYSCALL_DEFINEx() will actually take a
> 'unsigned long' and turn it into a 32-bit argument so that things like
> this are well-defined and you can't fool the kernel by not following
> the ABI rules.
> 
> The same would be the case if some system call actually takes bool
> (but I don't think such garbage exists). The SYSCALL_DEFINE() macro
> magic would take the full register content and *force* it to follow
> the ABI conventions, whatever they are on that platform.
> 
>               Linus

