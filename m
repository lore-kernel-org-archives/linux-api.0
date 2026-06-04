Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303D137646A
	for <linux-api@vger.kernel.org>; Thu,  4 Jun 2026 15:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780588735; cv=none; b=kabVpV8qgdRY6gWSESd/3cN0Ym8wWg3uxiNptyNnEtKDT/hprh/MvpcqUX9s7eoCaPClDi6ryhITLzyosrBe/xWsmBbXJwv/Zme9dTHC60tL+orDBQQ4dLcRfBibmrfey4yiUG44aRQJ+mjx38B+uSNOlLBWMNpHOszeS3AhHiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780588735; c=relaxed/simple;
	bh=7s0rKR9scvgD84QvTOBiJiUg2JjvF9nGtFbIGJxaif4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VGiu/GeH+4MM4kY4w8lW5BGg2ADb6XGw+r8aMVHbrWlHAuolwFg/otgBRzWCmIVuQjdoYq8uxuSfn2CR1oa67MNimjKtJN2bpz31AJQiYrDFKPuZd497VN85P+kri02yirWhFGJvH+RgQ2itnwDlewxBe9uVmz7sjAGwk006S8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4FJDlN2; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4FJDlN2"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-beb8a08a6c8so125710166b.2
        for <linux-api@vger.kernel.org>; Thu, 04 Jun 2026 08:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780588733; x=1781193533; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7+wqPGUkYgYLzLpNrBl5F+HLbRSqQcg4ZruoWvmFRPs=;
        b=V4FJDlN2QRtshiMYZGGbydoQe4xWwRtD5x/+4DCqEsX8Wzn9IUl0DCBg/+s2ltZ521
         tOArkCHS0+2OEUUPgsBTcrNILmywzR0s/fBn7NXQEipv+EyCNZifzlV17aKVn8HwwqnT
         U41kFb3bOSDeiRj8v/mrxU7hETz6aIAt6vzow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780588733; x=1781193533;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+wqPGUkYgYLzLpNrBl5F+HLbRSqQcg4ZruoWvmFRPs=;
        b=gLjqkPiGIC97HoQlBb5wYJZQzTVJm56D+lST8sB70Fuqr0hZZsW1QfB0l9SgDUmgi0
         KQjkymwpjg0MR/+eIyNRurA4B1YdiDBi217C9ADaXsa8aYm3GbKbZONEv9bdPBYOsjFC
         F/I3+DxLtqxfCOgADFkLYT1vQoG7QyL4QC2kfwgYo366LN5rc9AG6R3wu2JOXlJ0woWw
         J4yllAZQV5b8ruQml0BNHe7VRAiziw90YzfM7iY8BEreWVckFjdYgnMRJ+E26JAhGREU
         xfvJSzjJfMAJTtbjgnzi17XeNY68yF9iQPGihQge5Y+hz/8NZZe0W7RsVRRF3pDxfRgQ
         0Nfw==
X-Forwarded-Encrypted: i=1; AFNElJ8v2CvjJf4WBlW+KVdJSTKbrRzNihU04y2sLV/xlhJjs2ypmansOumtFj/PgoPYYLhAiS1iFdqYm24=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVkY6xpiPTnX0uWJBgsohN10C8oXKrpIw9gDwazcazM8D/O2SO
	Z6FI8jde5WhfdQIUdoQugTOJGqlL4sb9/a0ruDBb7Ic3JuZZbRoT+kDjYQG4FcKcHemsCKXIOHT
	9pEOLHAhnfg==
X-Gm-Gg: Acq92OG4JldtIThKyf6Y9gBmUm0XIFkoZn6Cj1Cgw1cgLknMVy9g5SnfbvGjcIyuulb
	XX/6JgbpFXtsiaXHv0ZNxP1vWT7mJ1yjgLjbPtR5Ydr2gK/Vt6kKzlZQFC2bI545KHcvwApc5ay
	JSFzZpYTm6ge7vwbOu1EU+CzMn4OFqxRU3l2HnWRzNd7q8abjbX41jFLZFdVtyCOPYrtzm5yQOy
	cjL/o9V/vaTFiBoIMIjFyPtJqe8/qjNOtWYGJHMZJw2QlVOb5J75lPNv3BRfyqoJREBlFoWrcoX
	5XPpQgtSh/CxufXiEwPEoZGt5TT0Skbbqn9IQ6Zyi0HW+t0mx85pMpQTq17IRu895caeffoSJV1
	HmbOj3TlM438sw9MV1CFPmQIs//VcjqD6xncZ6uRCv4Tvb+osB6d/3AKmLY0b3c0UmUfTbAnvNi
	eIB0JQl3yCKjO2zz6HS9o9z6xuNJv5gCOl00/V22SEDKSVqtVMPxcHnYlsYZsp+Tc0SHM066LV6
	lFvQynhhwPUwbeJTSEu3w==
X-Received: by 2002:a17:907:689c:b0:bf0:2253:ad67 with SMTP id a640c23a62f3a-bf0b3ca9707mr318105966b.46.1780588732627;
        Thu, 04 Jun 2026 08:58:52 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf054e06dddsm329867866b.36.2026.06.04.08.58.50
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 08:58:51 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-68be16c61d1so1767582a12.2
        for <linux-api@vger.kernel.org>; Thu, 04 Jun 2026 08:58:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8h4cRdIU2ZEeWGUELuAOv+AB5nypxUnFWzuIeYHLuxj1Hdpt6JUV1Mq7lNUfJ3+NqEoehWo0nfMME=@vger.kernel.org
X-Received: by 2002:a05:6402:268d:b0:68d:235a:cdaf with SMTP id
 4fb4d7f45d1cf-68e6e447981mr4450863a12.5.1780588730255; Thu, 04 Jun 2026
 08:58:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <aiEb8CTM-ovMIq7-@1wt.eu> <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
 <aiGfgRch99l_5z11@1wt.eu>
In-Reply-To: <aiGfgRch99l_5z11@1wt.eu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 08:58:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
X-Gm-Features: AVVi8Cfm3XRgcYqAOfqktIkPjsqV4jnNlBPsed_wU8pvtWHjKA_FxUEOuJC1FXo
Message-ID: <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, 
	patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Jun 2026 at 08:53, Willy Tarreau <w@1wt.eu> wrote:
>
> > It looks like you're actually doing exactly the thing that I thought
> > was crazy and wouldn't even work reliably: you change the
> > common_response[] contents dynamically *after* the vmsplice, and
> > depend on the fact that changing it in user space changes the buffer
> > in the pipe too.
>
> No no, it's definitely not doing that (or it's a bug, but it's not
> supposed to happen). I'm perfectly aware that one must definitely not
> do that, and it's a guarantee the user of vmsplice() must provide.

Whew, good.

In that case, can you just try the vmsplice patch series (Christian
already found a bug, but I don't think it will necessarily matter in
practice - famous last words) and that test patch of mine, and see if
it all (a) works for you and (b) if you have any numbers for
performance that would be *great*.

There aren't many obvious splice users out there, and even if they
were to exist they are typically specialized enough that you have to
have a real use case to then tell if the patches make a difference in
real life or not.

So you testing that thing would seem to be a great first test of
whether any of this is realistic..

               Linus
