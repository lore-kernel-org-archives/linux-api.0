Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21833C343B
	for <linux-api@vger.kernel.org>; Thu,  4 Jun 2026 21:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609393; cv=none; b=u0BdJQnJ2ZeSBPCo446/JY97NZdmc4mK0xCNF69txNqZUG7EGG5gBt9xznmGKqab5g41dUm7bXLR9bH6Ewf7d/mI58GJnD1UxObwpr0DYV/Dl6g9E0zg6hGrWBA6r5UWyiid74ipQEpsT7rH5rDO1LufSTxeTpgK97Xp93MmQyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609393; c=relaxed/simple;
	bh=ZWDSpacEFEQZGnIVBEbJF0VYYuNfWke7vLWrwwZT/Sc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ioOiKXiDDwzbc37jD9oAT/hPt8mS5jaAKy+22Cbd8WyMxk8ka6/uJR6+rpVV7Oq6BowvahM13BlVnZiH2pAmAVtcBmieHOt6j/C6Xxz34mRUsjoEa9C9yneNeVesIKKreIEEbRw5suMrUozqyrpBvvMAewnT3Zw5HHIq75KqYjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cGCqekVw; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cGCqekVw"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bf0170c80f7so221289866b.3
        for <linux-api@vger.kernel.org>; Thu, 04 Jun 2026 14:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780609390; x=1781214190; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C0rKRLQ7b0xQkDszK4kB86a8NKDdPGLBrBut9iuJxEs=;
        b=cGCqekVw78n5ZIPveO7LHJDqnrEPR21SeuXk7KlfXlBcUevB3eBj0OssT0LUPi0Ds1
         55s4r5GenpFBZnFRQYHrbhjdNcdlOKk3RVxjAXL4/1D7Vrntz4bvQi0Faai493uAlY2J
         5NvMqC/du8RbPgU6taIIAZbty6L4rCVStvKeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780609390; x=1781214190;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0rKRLQ7b0xQkDszK4kB86a8NKDdPGLBrBut9iuJxEs=;
        b=LPXpBLKUXvU0vO3mS/sxRHzaaSsVLPqtn2tf3B9oDVIBaNaj4wc2j4Dlm7kOAKYsn0
         2AsAjBD6w+jY3XIvPtpESM8Pq8J2ejqINXuVBqVwErV5q5X2xqGupBoZxJXq47He1iOz
         08qucMxp+vgfD1pkjLi+3LE5fIAI2Fs0AnUReI8IM8Ik+T431PT9NXEJvWDajOxG6GMT
         Z+fVELAcUiryQ1oE+8zH0Qx5fNc7x2+bn6JiGv8fmfy7ldzwvup0lS6veTeJ4FwvamRY
         k5yMePhlYryAD1ITtULonMBjd1hyyB4xNiSqoFdb8ACDSzXe0/qMlznFJV4zkx3kiOIJ
         7PoA==
X-Forwarded-Encrypted: i=1; AFNElJ8eInls7Z+C2ZIXSpMcYSjUgr7mMiN/Nkf7JZW8izvA5DrxklyLcqA/OpcOj5XlMJ4+3irFz13vDI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMlqSk1ScsqqVr/g8JlUiZ4ClXeq0CviMI+nlLc6Kd7/fVZMjB
	RYtbInIif0z+1f0d0GXrnwjjqTc8OZp8T83084SEtN1ZsrxpNTYLfqh9EV8idqru0KHZ2SIIKu4
	yuRQKPE1cIg==
X-Gm-Gg: Acq92OGN9s9d/2JkO6W7WTZ2003hX87aaKxewWxMb9VtQy1+fU+ra43hYMdNIU2HT9p
	GajGC4cbBj6UTiE0LJr3EU6iFm+4EYvWf7SWFVXKiQoLwaNIM4k3hGTCcLjFD8CWCR7ghHLRmBQ
	HmLyeH8yaOsp9UsrCT30ddFYKNDTMhCBmdyI9dLiyLw3PbuTGlfRTxv9Q4BFulaLwrMXOWxTje/
	NQ5w95ijKA26agJeYL1s+VJ8EYz4ch0V1TEr5MH0I2/CVjPxGYDy0h8klGquOJXb7lmr2j/Ytap
	I48VE3vONRtykzuIv03VYPCuwWlVf0jN+hXzXxdrI7QhhCdPS0IUrkxaoORizweMtT4dKVcgcDv
	w0rxMCSahrqq7aWtwQD1cAA9LEs/ETwaxYz7sfajWrzTHUXKwYemfVoUkK07/nnnz2xoVT8jWc8
	G8HoCv8R4HT7MN79Z4TYE5qaZd17lNmv+Ima95kkJnWMBmK0nocb5bDXBcROgHyrHKVxS/xdkSB
	r34WuZIObE=
X-Received: by 2002:a17:907:3f14:b0:bed:a7d7:82c8 with SMTP id a640c23a62f3a-bf3737eebd6mr21900566b.37.1780609389940;
        Thu, 04 Jun 2026 14:43:09 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0559f1ac0sm353454866b.62.2026.06.04.14.43.08
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 14:43:09 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bf1141c26ecso179340866b.0
        for <linux-api@vger.kernel.org>; Thu, 04 Jun 2026 14:43:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9mHtw40jqG0qyyl+ReNFP1clk7ZCmtdK2BegiGgWw7DMVYrYnF6p4/A377wEfcaTNKxfeSdC4r2EQ=@vger.kernel.org
X-Received: by 2002:a17:907:a03:b0:be2:dd37:facd with SMTP id
 a640c23a62f3a-bf370e6211cmr21551966b.20.1780609388179; Thu, 04 Jun 2026
 14:43:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com> <20260604100609.6b37f500@pumpkin>
 <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
 <20260604183829.63c35fd9@pumpkin> <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
 <20260604223216.73468830@pumpkin>
In-Reply-To: <20260604223216.73468830@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 14:42:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
X-Gm-Features: AVVi8CfSQTIVkCCY1e0qHuDIqCVA2aM8un_0a9-AOfB95snGVQXFlgTgq5lonE8
Message-ID: <CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: David Laight <david.laight.linux@gmail.com>
Cc: Askar Safin <safinaskar@gmail.com>, metze@samba.org, akpm@linux-foundation.org, 
	axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com, 
	hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Jun 2026 at 14:32, David Laight <david.laight.linux@gmail.com> wrote:
>
> I think riscv might sign extend 32bit values in 64bit registers.
> x86 and arm both zero extend.

That's different.

x86 really doesn't *care*. If the caller zero-extends or leaves high
bits set randomly, according to the x86 ABI that's perfectly fine: the
callee will only care about the low 32 bits. So the high bits are
simply not relevant for the ABI.

The Powerpc ABI makes the the sign extension part of the calling conventions.

So if a caller doesn't sign extend a 32-bit value, the result is
random behavior - if you pass some function an 'int' argument, the
function may end up looking at bit 63 to see if it's negative (except
IBM calls it "bit 0" because they have to be different from everybody
else)

            Linus
