Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415F44B514D
	for <linux-api@vger.kernel.org>; Wed, 16 Sep 2026 23:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600585; cv=pass; b=QsUEKbAT40HozKZNeK5n1zYq5TTndgjAy4rG2J6RcRKPTu51agNWKKtHKJFOEGpqjsC67R3QTLQH8UpwOJYPqgIdMLGXoZnrI3x0G9ohXJPFjOuMR+0tu2STg1aQdbww/A3/C/Y1esWzRArB4Zj3pSaFzhUGw/F7gk2A4OJFgQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600585; c=relaxed/simple;
	bh=PGqCNKVZCKuQE7jwiEPuuSZ/IDgGiFbjWnBb1wGsCq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b55ocFl9ouFjlXfEJyyU4qNd1HRuI1eZ24umkqiKOXLjvJsngEvJXRcxW8EvsVfxXKvTef/TCl6FaaB8qZvG3m1F54g5gx0rTFK3zWMIquFTo6UvwMndAtTaHj/X5UmZVgy77+G35Vj+J6WCzImopP5dv7oIdg741AXciQIf44Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=UNsMKJo2; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="UNsMKJo2"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f15cfdso141289e87.3
        for <linux-api@vger.kernel.org>; Wed, 16 Sep 2026 16:16:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789600581; cv=none;
        d=google.com; s=arc-20260327;
        b=lj6glm7gZuKXPUAE2nS8OTi4xBZUx5TW1lHB1zpYNiicKStZ72VlcsILRdyUWfzP3R
         kyWYmOFDfbV/59rU4rDtsDRURykjsKF2UMEq/ZFu8J4sjOskWZlUfdF0TzwKUYdz4pMG
         /ttksAwKbnMKWx7n6ncJ0pM92mL99GVdow6zBP4GYiL4Cih/giTL/vaQn9uqRlBBExxn
         RvwaO801ljP7X9d70Ap0CqhvAtO//Rre1ycbeBZtyBK8MxjuTklfzTwlSCqD9vIJZ5yQ
         2y0EJKwKN1PVo9H9n0UCICQaYYmGVPxBa6s9NQtcpHdYZptazH4fsW7ZExhy7iPgAzb4
         AXTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XuO1Ijt2sJ14x5nHlyhOYgW7+udniPE80quffc8DQvg=;
        fh=s1RDaaevCuzHM9rp+HBobr+BSXsuM3aH/FtXT5ZJ57A=;
        b=DkHQVPunctriC96Ebmwq8/jmjRmFTyXl+ITLm4+0w66T2ucStWVodPubdczlmK8l9U
         3yAh+t5rn5WOkdH147g9rRGK9c3cz4UMVKpMnZGgV5qH+M+GRApuuKoTUos9wgobrdpo
         uAwy0gBHpLepLR+4va7BKbUohwZeHLl7h6fJFkEX6w334m3ecV8xEos8VzvwN3OSwi4e
         rfI/I6lPif3p1+IwvsIjzkgCn9q4kqkgHN+I1S7CF8C9YE+/D5xTSXy9f4YksqPY5gYw
         favTM8CjiZw6kmJ3AqwzWu3l1E1BtJS0yOayqmVChKvEcLnTeeyouDVlPs64U+d23dax
         K/EQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1789600581; x=1790205381; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XuO1Ijt2sJ14x5nHlyhOYgW7+udniPE80quffc8DQvg=;
        b=UNsMKJo2T6wCVhfzR26gvQPxMH2MFDhqPuI/hzcovTS5zs6CWJ+2olJEkH57SFtFCf
         zWTufsKEyJSmXcNom+NICA6udCi/cb6EsKlWZe5IH8uEJkMIWsASwxE/u8dk1qB395Vp
         O6r3li8izs13s3JHUW5DyGOwh1qssoK5icXYBlWJ86W3FyuOvi79ZxLw2qbw75a5hHTs
         22bvvOfGSRs/aUIaMEuwfjYbO7vHKzOxF2dcy7k9baG8XFnC0ON6gi383zGpQ9WYaZxK
         BLW3thCFFj3D8q0pRX68Rr5xvKK7/Ws6dIzEQyJVqtSFpvZ/ZcmS2CgJY6PYlmtlWZD3
         ODsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789600581; x=1790205381;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XuO1Ijt2sJ14x5nHlyhOYgW7+udniPE80quffc8DQvg=;
        b=uPbJ96tADgAB5CY8aCSEj3TfYb5Kdyw2IGU4Yz4BRFDKxSHRXO/+V31OW4353e/Dw3
         I1jdh3K7eQGNgq55yCZ6jJ+4k6YUdiEAU1bIgm9Z0QAwzMPTuDehJOhSzP5G/GvVzrBF
         Bg6kCH+G805rILe0w5oEACZT96LqLQ5uC4uU4+R02Ca5qwO7GMPSKHEC7KJUWIrHVWig
         fJa3f/xGhH47XFNZZZ0vzpQ7eCBtWEHJBgNgCV0dJmaEV6ALVKNu0Fj3VYPqoqsupi6U
         6EQGuzrGss5HbiIRFIY7JILaOn2/TFD1aQLYb2KZckUQfmNY4WUXZO2QwVhTgAH4fvbA
         6JVA==
X-Forwarded-Encrypted: i=1; AKwUvBwXTf95uwB90yPx6oWizhvc4W71hdJU/t4sBsCdnJn2riBGcgXXbL27um5VHAbr8ZtEqk1xt4s7+28=@vger.kernel.org
X-Gm-Message-State: AFuF++l9lAx4qW0329dJlr2YuBfprjRgYWAeMtxWvxsIH8y5Nfh3j2Y6
	5KfXR4VU/ql181BdAyTkxiH1JLa3ntTtbzSz5UgaJLSoLKkQU435R92SdtJI20vNx8Y0HIadN0b
	9eL7ay+P7QUk9/LTIZows+lNYdq5x/FTYYdauGxw8
X-Gm-Gg: AYBFou13fbFDEQRd/9QC8muokEINls5HLTyji/U51y0YLForZqL0Z17E8YpxKuIwKje
	/1Q2XxQuaVhayT2pm2PIrptXQlu4N1ENgOaKzSANe/c7MvEW2Bgiqnn2i57BNU1xbzv1Teh7D7U
	7kp1HCv9x3IKMAqpttTuLAJcszW4gcPHjbg+fnANg7Rh/SQinjIUWin1llzZWQ8ACkeMTKoU6xb
	qt/S3sW/rbjvc/0tRW+2Hy1QKzw1SICopQYHOeEE+reSxgMzYPbWqZ+/AZMUJgsAdlAZptRz3Uy
	rgj8A/RACM9q8p+KO3fdaTbpqnLHcOJs4vV6UMiab6b8PcdBt8vO
X-Received: by 2002:a05:6512:1192:b0:5b6:1a7c:59cb with SMTP id
 2adb3069b0e04-5b8b6643a3amr1205595e87.37.1789600581075; Wed, 16 Sep 2026
 16:16:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <aqcmz5uI7PgN5CT7@casper.infradead.org> <20260913235145.GY25906@brightrain.aerifal.cx>
 <eeb50cae-87af-4a40-b9c6-f4fa9981425e@peda.net>
In-Reply-To: <eeb50cae-87af-4a40-b9c6-f4fa9981425e@peda.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 16 Sep 2026 16:16:09 -0700
X-Gm-Features: AcwNN1XX9temToosIZFGFf0_oya4M6aRcGTN4rFbjsWI4-f9wQoGiIGursSmD04
Message-ID: <CALCETrUgLj4Dz0s6PMofViJwausRWCvNvJphxWHUeWCCaRBtQg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
To: Mikko Rantalainen <mikko.rantalainen@peda.net>
Cc: Rich Felker <dalias@libc.org>, Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, jack@suse.cz, alx@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 2:44=E2=80=AFAM Mikko Rantalainen
<mikko.rantalainen@peda.net> wrote:

> NFS and devices make the question more interesting, though. Some
> implementations put meaningful state transitions into their close path.
> Tape devices are an obvious historical example: depending on the
> device/mode, close may write filemarks, flush tape buffers, rewind, etc.
> Those operations are not necessarily replaceable by fsync() before
> close().

I realize this would be complex and maybe a can of worms, but maybe we
should have a new improved syscall here.  close() is indeed deeply
problematic.

On the one hand, we have the actual task of closing an fd in the sense
of removing it from the table.  This should really be doable without
blocking or without side effects (except possibly for zapping
old-style POSIX locks -- it doesn't really make sense to be able to
close all fds to a file while still keeping it locked, especially
since we report the pid of the lock-holding process).

On the other hand, close has actual *meaningful* effects, many of
which you've mentioned in your email.  IMO it would be really nice to
be able to explicitly *do* those effects separately from closing the
fd, maybe even asynchronously via io_uring.

Would it be so bad to have a new operation to do (possibly with
moderately fine control) the close work and another one to just
release fd- and process-associated locks and drop the fd?

(Hmm, for OFD locks, it really does make sense to unlock when the OFD
goes away.  For old-style locks, maybe we want a way to release an fd
without dropping the lock if it's not the last reference to the
underlying file in the process.  But maybe specifying and implementing
that would be a nightmare.)

--Andy
