Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795474038;
	b=pUC19VxIkml9svW5mQ1AltqTiqAXXo1HZe0f3s5Dzw8mYP0S7wipSBgYVcAtV5rdtHVT
	 6MPQS9RsakLdN8DHUJu9R6QTbEBuEN/ae0USSzUB0Q+jhDLNZGU/o8sl1pLK1FPdWZZ+3
	 LzVx4HMZ5xxwRtGQ58xnn2BPOULXAR7IvL92aiWnKf7phFSNsgPtLKFOz0RwVwY2csuk0
	 7e1pvpNMXnjNUVVIexWnfbvyUxwZzaOhW3w3Kmc/xl8THRlNc66O2Jy5NuqUUMQCqW6wN
	 xU+nFGD50kYXO27xvvjIaLVYJkwzRvJjWR1QYMM9bkWfSZ2U3UQokUCS7yncQS5l9WQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795474038;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
	b=Hn7uTZu1c/T3hEmiDUmCZrMhBB/mJvc0kQ+3TtfBelbOYjbDJNOC5U5tDpO2zVhCKMhk
	 QdWliN7HSjs8iM2Z2zu41iO2dcheeLNjGP1SbDlhTdoY0sbNT2fDLdCqcASFIhXtvEkoM
	 yBoo7BeWItBqPdmJzdOX51BRaOZ5cIxIIzFvHcq2r3TtPa88snypkOqyak5cEyeb+6QhA
	 /xUy08bRtjiwdRw17GCXzOYHFJe+dvh8v0Cfkzbf/3vn7E+KULQKRbv92mz1dE5mAfqUO
	 yxDTc+K/KSECcy4xwwxl83E7pMoOsvpD/IgbaHqrILUqfeCPW4wWxCmniRSQYG++YmQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e9TlTdXc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4DF606A31E
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 22:47:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB4DF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e9TlTdXc
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b876afbb86so4940317a12.3
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 14:47:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795474036; cv=none;
        d=google.com; s=arc-20260327;
        b=VnPDA6K3i3krpei1Arq45iB4ptxDML9BvO7ZsGhBb/1erwSjxxAT24Bs2j+B0lDyzZ
         VVWMxnfybCJstGW5w8dhjeB++6un1MyLkbcyD09D/AFikhOBN5HW2NZ2fj9Yoqeh+75h
         InO2XkeAOkT6UMh/8rfdp/s/nKd1pbrALhO+EwV59AHybgtlc6CVGyyXLyK/P6lA8W8r
         CF5XJ+rEITPxBiRDULOHAtQEtt3CSN8bTuzrUCfhLS5F+0JgpymByimqk7lv0/FmYulh
         7a9LwHdmDCd5Q9APs5K3Di3rEvmN3HL32JtB7BNBKJfAWIJxe427cKa0JPhGsnQJlK+Y
         PM3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
        fh=jb+Sy7+fGP3sW8XmpnHhuW2SEvEQ02+melz4CpTBfT0=;
        b=CQu1iCeITqs8T+MbWDL9koZDzI8gsKIkIbOd2WUVgRSbHoA4e15xjbd6uh9xL0VLOD
         sPklJXBod00llaqPwTLdVwMfjs9JIbxmMhOb8LuRqD3kliX17xdckyUj8u95JLjqUeRP
         arX0UEB4JQTTE0dx0LQp2HrPauoVtH/h62kd+mgkSkoyG+S4S5fwYgge8blGBXP8EHLH
         I68KV9wEBjHaiqwD0oVA9XB1ZeWcAV/8+pM2g9sGkbEny35v32oGGgsPvV/tx7gS7Gem
         afY0YiXZr1i80bX7I7gaaVQ+uGk+to5xBCWossDz1D2VIUbJ1coNcbNlgtaSM6bXZTyv
         Oicw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795474036; x=1796078836; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
        b=e9TlTdXc+gatXcuCFKKb7aj/RyvKZZs3Fc22DsvCbrqYMGGtwci3FfIjibOfYQ/CZW
         9N8fj6eIrKNnVRdbxmnkFIx1GgLKrWEmFGL9vOQOEa0GR8Bc8q6jIgpflc/R1WmaKkIq
         a1L/XNzQgQR2OfVdP5ZWakzu06AC21i4FBAOG3jwYP8Lhy9AUkzJO9T8iBSrC7rM4aSU
         +QCy52SpD8tCCzGsrVoCDffQdo0iiSxV39ldqNaCG7VxnqiWEDVWhmyRn5+Uk0DxMQhg
         +jgf5l52Pyk6Ega5GmFX/ULCv5YHSq3eiAljutksNIdRm4c/i9EcMfRht5xGucVDbs5/
         qj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795474036; x=1796078836;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=prDmnot/bOxVS2gCc8v9HfYcjzpcvwnB8HRgvfXYsr0=;
        b=gUlaW74++suwQRt6DoxBLIyRMV8go+vsbqOVtHm3vO77u9prcKWxjF04kOT2xPlw7k
         72dGm+ypWzBMO1QOZlsXr1bbSzY62t7ObE0LQgsQDmpttywj6nT8flzuv+RWvv8Rn3fn
         1GlIBqQEwL+sDoDywj9NSzkPFdZP8wrTyt0+pc9hlhpmG+AQNY68abXSgkjAg+s4DY6E
         ZT2XhjxQ55Jt4o/2vyJhAk9lik93Aap7UL8KSnLV2zGv7c3WvIqy04EEdhsq4C6uRo25
         CS0C2cSkri05HX9eTnSoswy3tQmAhPJZfT5zwM6BByz6Rx2hw9aSRBRa+o7mrWgq4cc+
         eVvA==
X-Forwarded-Encrypted: i=1; AL+hErGsYGflltJADxDEy1cc2OrIDcxbecM9eCPMlw65zf/mgv9wbZUliQ/5OADmytjzloWBr0BLYSI3qCI=@vger.kernel.org
X-Gm-Message-State: APuU4Z9d1n6GRcR4wh+rXq/XVjEggJOB2IZaWH8AvGgbb8fp6X4IDgvK
	bnQ+1KGPuUXce/z4k9ACcGIuwqxnU97U882O7g3n9bywzOwUZJL+4un9M7Csx+5naN6zQJxqKWO
	OQTRgkrdY1fO0zbf755J8JacHwSzK8dQ=
X-Gm-Gg: AZFdTZf1obS42Emfi347ljDMOv/gP7hMwELs0Xs/WT8eLgRwE7gEH8MZ3YGj/oPFvbS
	auwhcGluGG2N1Dz90kSO4rRb9NJI5cPUYB3//W4k/R97zgc3UoWdEcNxJhikR5FlafC5+bAAc1g
	rRTx6+iRGkzbI3e0QWbwagae3QNPrwuFbk7AyT4NgDD7gWRfJy9SXqHmlKaLP3xwqcy6n9/r3wR
	a5Lk5q/AleuVVW9SscMRe1bebhTCNoM5MLCvlLU/HpUU914x1caiHCxgPvbXLM0QWi4K1RGu1uq
	zhdyoAUs4EqXC7dJcGYtCU48O69hQTWKQoem61jM/TJW0NaavYNT87ZF6FIEZA98Xtf3A500Fjl
	z/djO+kc7psDPc+jcNOWHMjFs/to5sau9fp4UrHQlQE3hAtahQL1IJjTXtzVLNxjcC1NLgQ==
X-Received: by 2002:aa7:c710:0:b0:6b8:e848:d004 with SMTP id
 4fb4d7f45d1cf-6ba37e8dec5mr6855932a12.29.1795474036043; Mon, 23 Nov 2026
 14:47:16 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>
 <DN2X3RC5JUFQ.2LNGLQOUX4ZPF@gmail.com>
In-Reply-To: <DN2X3RC5JUFQ.2LNGLQOUX4ZPF@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 23:47:04 +0100
X-Gm-Features: Aa3M54pZr_aGN97hdgjJEJclpmHDWTbmXWMujrk4s8rCr1BMot2r_DEgpbuT4T0
Message-ID: <CAOQ4uxhsv_1EEqAZ3Ebp5Uy8Q6nvEnE3EAomJjjQO86nTcW0cg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add f*_xflags_{rw,ro}_mask flags to the fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 10:45=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Mon Nov 23, 2026 at 2:35 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> This is a follow up patch series stemmed from [1] and [2], splitting t=
he
> >> _mask change for the fileattr API into its own separate patch.
> >>
> >> The first patch is a preparatory patch so that the code in the patch
> >> after can be formatted better.
> >>
> >> The second patch is the actual implementation, which introduces:
> >> - fa_xflags_{rw,ro}_mask fields to struct file_attr
> >> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file=
_kattr
> >>
> >> These masks have the following semantics:
> >> - rw_mask:
> >>   * for filesystems: advertise which xflags they support changing
> >>   * for userspace: specify which xflags it wants to modify
> >> - ro_mask:
> >>   * for filesystems: advertise which xflags they support only reading
> >>   * for userspace: ignored
> >
> > Nice!
> > I think this API description is very clear and coherent
>
> By the way, should I use this description in the commit message (and

You could use that as a short TLDR intro

> integrate it with missing information before/after the bullet points),
> or should I keep the current one?
>
> (current one:)
> > This lets filesystems advertise their support for specific xflags, like
> > statx.stx_attributes_mask does, and userspace can specify only which
> > xflags it wants to change without needing a RMW cycle:
> > - on GET: each filesystem that wants to support this new API fills the
> >   masks according to its supported and read-only xflags, then:
> >   * for boolean xflags: it fills fsx_xflags with the current on-disk va=
lue
> >   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
> >     xflag value in the struct field;
> > - on SET: userspace fills the rw_mask with the bits of the xflags it
> >   wants to change, then:
> >   * for boolean xflags: it provides the xflag value as a bit in fa_xfla=
gs
> >   * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
> >     provides the value in the struct field; if the xflag bit is set to =
0
> >     instead, this informs the kernel to unset/clear that value.

You can keep it also but tbh UAPI documentation is more useful in
comments and in Documentation than in commit messages.

Thanks,
Amir.
