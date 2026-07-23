Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C815E48BD46
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 14:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784815696; cv=pass; b=Chyj+wtHHkKGQAIe5bdC5/+Ih2uXSSVcOdcOfKhAx7Bz6J4XithHoNQKji69ieK5J34X5da1z46TEgE2JK6yojrdWfans/G5xpysW9IDRLUzVh0PP2Ut6MSGYVIa0e2MCzMUDfABFuA6H8XtjtN9F7Rc4jmHM6mx4Kn1EvhnThQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784815696; c=relaxed/simple;
	bh=My0yYJ9gfBuiqRns4rQHBKbjK6CnjyaqD+SHjIQuSfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fN1OnH10KuVngB7ixDVh1gMAC4adxcTOoIc4nrQsHzIvqtgZR0NOVmPtzclOLF5rVgYggsFTWjUZrHEjSwn+k13RBBrceb0BZx9qMJTF1FY8fdVH5MV3bgWZLaLxqlUfCbup8ytifacYsI4ehA/QzmQZLlep6ZvR+i9lj1Dn5ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y986YNCS; arc=pass smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y986YNCS"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ccdf36f63dso120305ad.0
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 07:08:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784815691; cv=none;
        d=google.com; s=arc-20260327;
        b=HvTbM2qGPKHhM3Oh7aevuVRMgs6G7HMGRlwvfP0YodvAMrsJ15M3AeBZ8F/pej91HQ
         iAVqo7KcpygWmQr2Eh4mk13+q74xiQmGxmMvG0zAk47+fsVGxvASPOEycTvTJMrhEOdq
         PgxY6rMV4YeoR5uWTjRlVK1b2vHF4HD6iILcJG7khtl9foiUEvPveZ+Uc0NjVUT5URdP
         M+5YU0ciZ0lfUJNuFuqvogXb39egdZCP/x2NbqTggxEUH2XeCoEysbroLFZuTfiTZErz
         PNfQs2nTpyZ4eXVjRZKqSN0biXP0+GogUoAehvzaifQUcuhT8JIBkDZa0RJOLISj7PbL
         Sl3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=My0yYJ9gfBuiqRns4rQHBKbjK6CnjyaqD+SHjIQuSfg=;
        fh=s9JufcGKzMRwcA0jfm3bKIGttCc7/o5CXR1vTV11BVk=;
        b=UmyokQ7ipfQid8ckqtYaNLzm7jxNivTQbqfo0cGhzTei+YFWySk1xygdfiXgsHXuQZ
         6trRStrCHNM/bzSyNjLhCKMyoHCBq0CUBhGm7LcMiaBwBlVBG7H7x/xKcRuTnXvzaJCA
         O2mpILmTUOZP2po5aOcJKeaWGyHSATpelVD9cach7Zq/O551kcPlQtc3rYN00/L9E5n1
         iuiSh9Ce0LBoN3NYX1imz0gRTx6p4Bs1qxK4ePplyvZzqg0Yr71IPpHu5MIY09CAcxow
         cyEXGLb+LncAcoPhlHizNYLdZNjvOVx2pT5mK98KmVro+IlC1tnp2qlyJdNUxIgurGQr
         IavA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784815691; x=1785420491; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=My0yYJ9gfBuiqRns4rQHBKbjK6CnjyaqD+SHjIQuSfg=;
        b=Y986YNCSkmgo72X6PBt396rFEQKIvPpqiCoYdJJjTsQ4n0oteOOFGO53kLlkR2dCVm
         PreQdE/OwXCQda9G1WvPG9jSRmatuVp24BqzBwhAEcMa2Ophfw+MS0QWg0IzoHRMOXY6
         a1KdU9O7P4i6SsHM6fn8XySnEGSw1XPcn2wIoIofWDzw//1TZxaV/6qDqE+i+BOT9DjR
         rhm8dIjJsUaWbSpxoXcR9Evp1KS2aXyh1GEMZ6wVcAigGpB+ekJV7mcqeVhEBjkqXzcg
         AdNIR/nYklwzaO4tJlNrN/UxFtS1KCxoU676bVdglVxmF8sUzxyW2oSAuEE/KCFInVkA
         bi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784815691; x=1785420491;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=My0yYJ9gfBuiqRns4rQHBKbjK6CnjyaqD+SHjIQuSfg=;
        b=mUN7rNsRuN9VA/AF/GmBKH7hYIEEmngAmYtzKA5JEdeFZiSLfMqxljlzqExqpdEGH2
         C17OhgH8S4A5hsw0XO5IrYyGtlJZiQfjR+nPi/pM6t9oMvwH6hSd9w+O7RtRiWvtuRum
         hhETypFI3GfN1q8ixDvoA6N4GZ+hRNr5syDG68T0yUrmeH5GEramstS88V8Tk0lN6FXR
         Bl6cqksXcaubcpz3fA1t+QDGNgjaRb/RRKyFJ96bmsJEnDLpqW2XNn7j3IXbbtHv35YZ
         /EMfAN9KAjFBBTz+jwEzY23F5eFy8IOHoEUtjuhMApHLNY9/gWV5+I9YYBqspCe8aFzJ
         jSMg==
X-Forwarded-Encrypted: i=1; AHgh+Rpd5rqyijutLNr8f05cHoVIYAJWxlJskyZuqLqZxXXIjAnEFa8YZj1e2FMd41joph1Tm8lz0chk1W0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwKgVqWiGZdyzLrm1say90LzFUmmGsaB0w88s1Rs/TVKuTtU/X
	j0lOyXrc7ldCg7pVaeEJ8zwvgfSa/FU3tzrLUEyLcSqDHbdSXgiqm46ZAA5t02CRgcu5X1MQjjK
	94T54MO5L60ZTzkzhlDP+Hsiaba4ECJMG8P/BCUhd
X-Gm-Gg: AR+sD10+Gl+PPGe53vdsd5osNUlZlBzXkdvQjZ2Xsu7K5PmifH+RMPvU9U71u+9NE1/
	pd+hL4LyHZmstRwJTKPdAxIrZYUvWp73qPRT6eFufnw4twJcU2FhX406sDQy6PExSPvTwmL0LBM
	nSnzsMmQTIz07rwtatrTrj+dukF3iSBFevs696bunR34U8PuBDFgtSgcLR4eQjH/aEBeSpIAVNM
	1LFDfcAvfPCT7VCy4wEdcXUOZkmFMJKb/kGMuGlwf6u01vqZb7qFeAxj1xRAlyd2nuHCJXt+OPO
	rFfVMEiU+SHXMP0Ag9n1moJ+bQAVWhkjWJtIGK20oDyf6R6xdpsHJVstvw==
X-Received: by 2002:a17:902:c74c:b0:2c6:cbcb:bc72 with SMTP id
 d9443c01a7336-2cfa80814ffmr2462775ad.23.1784815690567; Thu, 23 Jul 2026
 07:08:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org> <20260723-work-failfs-v1-4-3f69b9a9e958@kernel.org>
In-Reply-To: <20260723-work-failfs-v1-4-3f69b9a9e958@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Thu, 23 Jul 2026 16:07:33 +0200
X-Gm-Features: AUfX_mz_mzCvw2h5o1pR1qMvYWw2B5M-LX-GbZFx68Jm-lMghOI_PEmMW2ywzbo
Message-ID: <CAG48ez1psv82Y98XT1p7vujYgj5a9hbPZ4=h7x4-yXQO5FQr6A@mail.gmail.com>
Subject: Re: [PATCH RFC 4/7] fs: support FD_FAILFS_ROOT in fchroot()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, 
	John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 1:30=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> There's also some thought needed around shared fs_struct state. It's
> obviously possible to chroot into failfs with a shared fs_struct if the
> caller has CAP_SYS_CHROOT and shares the fs_struct or if the caller is
> no_new_privs and shares the fs_struct. The non-chrooted-currently
> requirement still applies.

Having CAP_SYS_CHROOT and sharing the fs_struct should not be an issue
because we already ensure that any tasks that share fs_struct are in
the same user namespace, so CAP_SYS_CHROOT is implicitly also held
relative to other users of the fs_struct. (In particular,
userns_install() and unshare_fs() ensure this.) (Except if LSMs get
involved with weird policy, I guess.) That's what makes the existing
chroot() syscall safe.

But yeah, the no_new_privs check I suggested is kind of a pain...
