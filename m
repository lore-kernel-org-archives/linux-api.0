Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABB83B3C14
	for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792338894; cv=pass; b=pVxDZ9e3ZIL4jk25nSoU2viwgPACLkfvdtRc4MgrqwtdMz3LDUBymswxjVdmNIu0Ujuzm6vq8ATK62IqkfK0x1zIKUEblGeLMnpYJ6AFRUkJBvpDX7o7fzWoRia2rnoDIErldXf9XonCOKfDkqG4w0+5iCIV9PABpcroN1bp6QA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792338894; c=relaxed/simple;
	bh=GSO3CyviX3Qgm/6Zh8OnLHBZ1RQQFZp2XJC7uhyyykE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UTeNteIv5BiH4P3qnOpSF0qwA+m97C3zcGLdkIlt5QKtkWUFVpv/adnu8Wct0dRXalcRHgiNzB9Ka8XPYi6CpoMAxCkU1hTVpZu3HF1PKHA8iPVncyVoSFUjo3UxF317zO2CrS/uxHs7pp/e1kpUfO8yECeZ4dL1yfQ+yuSk5Bg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=OABw59HL; arc=pass smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="OABw59HL"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3ab3dd9670bso2315781fa.1
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 08:54:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792338890; cv=none;
        d=google.com; s=arc-20260327;
        b=WoPVPPAlRM/bEcrgO6kySgFq00cslDnDFExaUqJxyNUMWPdOM7BdV9XCePxpYvY92M
         gayrCUOSm00qUgYrsk41hKcJRQ2HkZZOQTleZBVcgi5cT8pjsqaLeg1/bVQtLKRn65IL
         NvVeBFPHZnuduNq+S5hCl8rBWHCYympMFtcMzU9hOigtGIh02TqXr0H5oZxWd1ysgHpn
         H1BdnISba7RW9yuq7vlLEc0zNhohTFMBzGXP5rXWpzbm0jtgW12B2CJewVJlEwubwIQZ
         R/d/q66UPByrvLW2NYZ7Jva8IuHwfUjmP8+dqaoCXgEPEAp8luyihlFD1mtVO1zChF5q
         QqbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kO5X6otFTHv9MhsD7Y3qo3wUX3N68xG5x2FhRCd51xE=;
        fh=KCzag6pb6olSsVV+cbFzO3QDU+LJqsQzmJB9N7SdKwo=;
        b=GRDu52gYJzfbrh/KZWXJM7mYxUkdb91rD+dOlwJssVKHSlMjbkTK/nfZFc22zqUaq1
         MNGQi0sH0XRw6BeSV68pOWhCSVY930NMJtzg+HCQYv8doU6Y8YgLkvGHaXf1AXQbu6yh
         7zcpSWUbe8vmwxSyv6L5YhrkSKUlarAo0cWk5uKTtYKSf2mXC/obTllFvJo05L+QBQgJ
         9syCuknvw+noenl4ATsA6b5Q0NI96bHWY8MboCe/tjV8ALmYTYYXfqCpBM91H5Bu3mzQ
         qYIRCLoes8EBoPxzmdB6y5TV2eXHDe6zkKiKS+VLg/i3uCs5xNW3MeWBl1xmj+f1J9Bv
         N2nQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1792338890; x=1792943690; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kO5X6otFTHv9MhsD7Y3qo3wUX3N68xG5x2FhRCd51xE=;
        b=OABw59HL5A5/ZXntAXfOJWe+sZPCBqT6MYAVSQLybB50/N+7mNx5mRMPL2UkBmDEEe
         SP7HCa+1H3AaKgWgJf3U6Kp5T/eJrKy3oLMFYt5KSilpphp+vfIyAxsSL2PbPJNTvq5S
         gTrDZM2dGXh/TOdODPZche1DC4tvqyLezREa/nN1KXgQKupqTsHfBS/e9MiPHfP0chxi
         yZ98sas5YxPCRwkrP6+/2mPHJXIca+ljSjskYM5XTQAhxwy0eC+5m0HDNaEzofMRHDq8
         /djDbjCo6oQgOLmFbXw6+ackhKuOxqa0vHu+ze0nFcOVWpjRj7haRk67jb5XWb+SUa7S
         7qLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792338890; x=1792943690;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kO5X6otFTHv9MhsD7Y3qo3wUX3N68xG5x2FhRCd51xE=;
        b=dEJ0x99/9a/22yQ2dg9+QWKMuHFjNNUs23P283RbWTz0ewlP07So6ovtyGKJaCiTJr
         LFKdcyL57loPCnxfHMU12BpDxaY3Bd9ZS18StSd0fACYABK05JvvZ/yZ8a8/mzoVy0QA
         k1XqzSsz69xXWfxPf07I8JSB+Nck349jUzPC0aGZ6N5sLKKyoi2fi7UR7OKDbA2aqVds
         Us1GEEvojd9X0gS3jBS+3g/y/3UE0bJBDfihh+6p6zqMU5QjBbFWzyBOgqVHmG0jZNst
         tiGEI66KCJQcL652ys1L0y+qIINJPNC+7yydyY3i0fvWbqBFZRovOHbHLM5SNSKUr9zh
         58+Q==
X-Forwarded-Encrypted: i=1; AKwUvBz52o5EHsO8USv4eJ20u3hhMSCmdCEYJNYJyzH7nUgji8iwd2qQpmaYElCtuOwFlb6DwuFDwRn5Dak=@vger.kernel.org
X-Gm-Message-State: AFq9FYIJYRcTbNvz+HwCQmauj1KoPbMJ32KsdVJoaZFb/Nkhmoegyzw7
	oJGjYnbO1YnV2j8uXLQxwOo8nHltIcJLNAW+WCVlWzAWYo/ZpYJg78kIWAHfOCIukV/ajuLnv+4
	6QZ/NmhuPOcetxXTZx2xVP5ThSITi4EfoQdLHoGi5
X-Gm-Gg: AYBFou1nuLk2LfWF+ZBRpY0KQ3S9D6D4/Hx1DKgId/BnU9hZSvCrJT1eZ2P6SKEQFOq
	+I7IXKoDyFZ/l0zcmzlzX+KkiEM0YT0urZhsWKhG/q8imgm7zn4IMY78eMPYMe+GAXO7rN2xvC/
	j0sMQErnGFq04h0jFwRcR/4jK+vHevX6WbzYdhr+PEkuChDwaeoSGWNf+R7DuHF64Lu2113ic43
	w+Ra10yb9OueeDTu0hOroi2A7caBe+ml2A/6EFCTJldiIBbNHTsqfUaBSWCvI3YhEsuuAw6tMZb
	03yRuYJy33ylMVqOPPaU4oCwOD8CLGgAu3WoDQongqxiHkuVpSBx
X-Received: by 2002:a2e:b8c3:0:b0:3ab:3d02:d03d with SMTP id
 38308e7fff4ca-3ab3d02d528mr3467061fa.13.1792338890230; Sun, 18 Oct 2026
 08:54:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <trinity-4d271f4c-4816-435f-b8c9-53eef0ff29c7-1786468770978@trinity-msg-rest-gmx-gmx-live-d7f776569-bpnnk>
 <asvEtnxChV2-dELG@debian> <asvFcQvNlx6Oq9Gc@debian> <87ecdqewg2.ffs@fw13>
In-Reply-To: <87ecdqewg2.ffs@fw13>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 18 Oct 2026 08:54:35 -0700
X-Gm-Features: AclHuK-ONu0WZqaFQArRp5-Ytqy3yAEfKAXHMGAs_i-9qeGWkiZ98IFU7IqaU-0
Message-ID: <CALCETrXnffZfmjjeq=wgfHZJorF6Y=owzBJM-iQ=8j=q0k0Xbg@mail.gmail.com>
Subject: Re: Suggestions for an improvement to the man page "iopl - change I/O
 privilege level".
To: Thomas Gleixner <tglx@kernel.org>
Cc: Alejandro Colomar <alx@kernel.org>, =?UTF-8?B?RGFuacOrbCBIw7ZyY2huZXI=?= <dbjh@gmx.net>, 
	linux-man@vger.kernel.org, Ingo Schwarze <schwarze@openbsd.org>, victorm007@yahoo.com, 
	t.piekarski@deloquencia.de, linux-api@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 11:16=E2=80=AFAM Thomas Gleixner <tglx@kernel.org> =
wrote:
>
> On Sun, Oct 11 2026 at 19:26, Alejandro Colomar wrote:
> >> > However, as far as I can tell, all mentioned BSDs have dropped
> >> > that functionality, but NetBSD and OpenBSD retained their version
> >> > of iopl(): i386_iopl(), x86_64_iopl() (NetBSD/x86_64) and
> >> > amd64_iopl() (OpenBSD/x86_64). FreeBSD and DragonFly BSD set the
> >> > IOPL of the relevant process to 3 in the kernel, when the process
> >> > successfully opens /dev/io.
> >> > In other words, the BSD projects all preferred to drop their
> >> > versions of ioperm() in favor of continuing to provide user
> >> > programs a way to change the IOPL. It is interesting and perhaps
> >> > noteworthy that the Linux project appears to head in the opposite
> >> > direction.
> >
> > Ingo, Thomas, do you have any comments from the OpenBSD and Linux sides=
?
>
> The 'iopl() is slower' comment is just voodoo as it really does not
> matter whether a syscall at setup time takes a bit longer or not. But
> 30+ years ago syscall performance bragging was part of the game :)

iopl() should actually be faster: it uses a static bitmap instead of
copying it on return to usermode after a context switch.  See
native_tss_update_io_bitmap.  Not that any real application will care.

>
> But as kernels might have the syscalls disabled or security measures
> make them unacessible at runtime, these syscalls and IOCTLs might be
> indeed just nostalgia.
>
> My personal preference would be to just delete them, but if there is a
> legitimate use case then I prefer to have ioperm() as that allows at
> least fine granular permission checks via the syscall security controls
> instead of having the binary all or nothing iopl() mechanism.

iopl() is very low maintenance these days.  Is there actually any
reason to remove it?

--Andy
