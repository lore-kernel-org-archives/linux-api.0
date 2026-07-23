Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144EA3E639E
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 09:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798375; cv=pass; b=fnNgof/K8t0y9HqaOqZM16Zoe2LQ6lAhwQPX1Pti2S+bhsvIYJlvUf6ycxqV5LryQzk956DoppqfTHR+vG8adXGuoMja7yPjIBo+86MVoAKV3AYz6NJnOGRYhrcWC1k1dUe1JsL7Lb4Pjo7UUgTE/JF1s67RaybZJQAc5LaRw5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798375; c=relaxed/simple;
	bh=ptb5ZxUirqu3cGwvf8pr6jbj/gODGCQR5YHXZ8pfSO0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nd7X4P7axAcVm908MdD0X38c55SG9EI/lbVXYQsAZoaIOIa4BoaFoXuLSgJVCRuIXE0OluXW+Bb7zxcso14XFMbqiWmlaUgd35yPa+d8VqlyUvFFPd8jELcPVU9emHNGfN43QuyZ6mY5jVivntWSTStChIXMAYjDamqezX4qW4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=keOlB1AH; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="keOlB1AH"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c2149571dso3025431cf.3
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 02:19:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784798368; cv=none;
        d=google.com; s=arc-20260327;
        b=ZIp+1+Dx/dzddtgvOsQsxOI2zJhGC5IVKW5I3Hr5lvY3TiIODstsbj1+euc5Kx0IJ8
         Gh6URhUVnXT6vgq8BEZey8M+LWwP9u/7Inu+4iTf6dGlqTjsPAD9znRainTIR7Icn8Yg
         0Frw3mkddSIfoi+m+mkJebzvJRYAXzleCYuYIRbPi2OQsRwBdBkfmgtGaU4SH8vlYZCQ
         1+HFbWjw32fZC6Cwh85zSN8p5XUSCy/aiLrkc0vG9YF1vNA3K5xTUO7m28bBUj81RJPl
         85wVptsjBuriKouqFEIjCm2NNJRyhlGBzSFXk9SXDwWii/QIZXB8gT4w+WZ0AmJ71rOZ
         VxHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kfYZU6mmSr/3MS4E2nALRlpwiopOrciEufMpSapbBDU=;
        fh=VCNGHb52oGZ3a/PyMBfiKhftD4EgifMMexM0Sd30Rz8=;
        b=BU1yZmBy146QuhkS3drQdkl3rSvnrejx1ySC24RDEPSNnFP4FTSM1GgmGVfz+A/KrP
         v3PHvaoagk7RCwZ1QyMlN+wqxFlWI/24MZ92L6Y42OTPZU6/QBZPqGdXE0mMHr3eGGnw
         NtAKp7m9fyUNm4WJFCV/vgsn6VLrwfj8l+mw0KnrDBVE/DzneL16+Zb4wtl0wsG/tQ/4
         tXeCa0rggQLQkBeslBMp7oAobkeqUc6WoF2kyIk7qdfN2X7HnJAYVQVHuq8S6+E2FE1e
         YGsF2/Y0203ynvgNV2nIyxzGOEIKTJzMX6zLgSPy4jPf6YoCLQNKaMPWUirUaR69yOX+
         gOsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784798368; x=1785403168; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kfYZU6mmSr/3MS4E2nALRlpwiopOrciEufMpSapbBDU=;
        b=keOlB1AHBBO6T/T1hkgCA6EQ0WgybPZ/+m0GoxIu0MtX5Jhz5FRd9RjOkni5HCsGVD
         1io27rV8ikCj2LQfGSvlA7ZcSH8v21LLVgVLTS7dAOFbdz2lZsR+AIFiYb7IJZefSKvo
         w9ODy+WQ2kChww/7p+4YeozuzCm5dAQI+GEfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798368; x=1785403168;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kfYZU6mmSr/3MS4E2nALRlpwiopOrciEufMpSapbBDU=;
        b=ikluyOPKpNRFKBTx6sL66SRiinAj+P+ajTLZ1WbJdXj93DrYpz91hTCqgJi5l/ZjfP
         bbrqi81kVxagUfVjoyGmb5Dy0bUfNqfh/C2TAJFEQZFpsDphgEkKj0W6lH7Ym6oChuuE
         LokAtf/2HMxf2IOLfRWgPd08SJkjGyCsgzSDaJv7ii+rKG5YkNSHkmjiDgWPECEbdOJk
         E3UdVm8ap4xmfulIav8BYl2wk3xFgeZW/Wu058N8Q4zw3e9qOKgoq3lfSzzNo7Q/sxcu
         mMOE30unFLStaZzkHyOEDOM5M19ev+UdOttOcHMS+Q/EceCptNaRZL5Db64dIwhFDzNR
         NwFg==
X-Forwarded-Encrypted: i=1; AHgh+RrK885WVL3fPI9NLCV0oTBtDLvD1iNDxE7uHezUx/LkEdaMps1GoJHMw0ZlW2LQL4fu2HPzU0/tpbI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7dJL2LfX/rsNp+G/SHqD8XvNLsnYlz0wJcDUl6nLOTrJ8D86d
	CwvW+Ep8+VYW5LOwY0qf/dntHTYnAbL25YQXeOgWYmh/58AJvxCMt6JxGNrxqa8CWue1fUjRoHp
	R96DKVgaJ/3rfPqCNe8iNpBiDPQQN+1ZFhzQiiS6x31O66zo7BxLpXsA=
X-Gm-Gg: AR+sD10iEmq6c6Vrs5lsQJwVWavo4HigDiUSFR04vgh2WqbI9dqfSnIOiVDzYyzX0s7
	G2bMhf/bleLJ8a+obTz1p+VzngvScibVIukvPvMLMMcdhF0H1PkcltOam1CNhKMGeFgRKd8Elqo
	AxbTo9dbpauBjE7zQ05wx7el7WSs0ZpAdp5Ha7cdl418GO3tbGR7suDRhypAKgLcNvCXZQZ/XA8
	xoaJgkycEYJItcZduF43xVQflidBs3WB+fVUdo9N3ayKk6oTAxps/JgZe7eDlfGHp5m80DOS4g6
	sbOVk0aVeNOtfUwykx0kunN/Guzx
X-Received: by 2002:a05:622a:1829:b0:51c:8439:14d1 with SMTP id
 d75a77b69052e-5283dfcded8mr20528451cf.63.1784798368136; Thu, 23 Jul 2026
 02:19:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
 <6C96C8A7-345E-4388-8EDC-D94E9463D214@amacapital.net>
In-Reply-To: <6C96C8A7-345E-4388-8EDC-D94E9463D214@amacapital.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jul 2026 11:19:16 +0200
X-Gm-Features: AUfX_mwYbGEjI6yeBtsXmiyva2-bOQkj3_zJ1N3_FyC9B2rBmuR5k88F1rTJxak
Message-ID: <CAJfpegteZbnPkiTSAPWXDqZbf5eALK0E_npBLtLTmJyZaHXdyg@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Xiang Gao <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Jul 2026 at 11:01, Andy Lutomirski <luto@amacapital.net> wrote:

> - O_XYZ flags to open() are all kinds of awful, for historical reasons th=
at are not fundamental to the concept.

I'm fine with limiting this to openat2().

> - symlinks. If we have a new API where opening /proc/something/magic/blah=
 can access something that ought to be inaccessible when accessed intention=
ally and with privilege, a symlink pointing at /proc/something/=E2=80=A6 ca=
n cause the API to be used inadvertently.  Admittedly we have this problem =
with basically all symlinks, so this isn=E2=80=99t exactly unique.
>
> - our nasty fs permission model. We gave a sort of gnarly mix of a bit of=
 fd-based permission and mostly mode/ACL-based permissions for path travers=
al and opening, and mapping this nicely only new APIs (as opposed to actual=
 files and directories) can have unpleasant results.

Pseudo filesystems don't usually do mode/acl based permission checks.
 I don't see any issue with that.

> Of course, I=E2=80=99m busy arguing (slowly and without a concrete propos=
al) that we should have proper capability-like fds, and maybe that=E2=80=99=
s kind of an answer to this:
>
> What if we had an API to get an fd to the =E2=80=9Ccontrol filesystem=E2=
=80=9D for a superblock, like your O_ALT but as a real syscall or maybe onl=
y accessible via one of the newer and less janky open variants?  And what i=
f the resulting fd and the filesystem tree it represented had a few propert=
ies that made it very different from normal directory fds:
>
> - You cannot mount anything on it or its subdirectories, nor can you open=
_tree or otherwise mount it anywhere.  But you can open_tree the very speci=
fic things in it that point outside of the special API (e.g. the overlayfs =
layers).

This patch provides exeactly those properties.

> - Privilege is fully captured by the original call that gets you the fd. =
 current->cred is not checked when *using* it except to the extent that you=
 might need privileges over your own namespaces to do operations that might=
 affect them.

This is trivial to add to metafs: just store a ref to current->cred
besides the path.

Not sure how this security model would work, though.

>
> - You can=E2=80=99t fchdir or (hypothetically) fchroot into it.  (Not sur=
e how important this is.)

Not sure if there are internal mounts that have directories?  If not,
we can just add a check to fchdir/chroot against mnt_ns being NULL.

> - Maybe you can=E2=80=99t follow /proc/pid/fd/N links into it either?  Or=
 maybe that would break CRIU too badly.
>
> The basic idea here is to try to treat it like an API that happens to use=
 the open machinery but not as part of the filesystem hierarchy.

I'm not opposed to limiting this in various ways, though I don't
really see the advantage.

One thing I hate vehemently is directory lseek to a non-zero offset.
I'd happily error out on that one.

Thanks,
Miklos
