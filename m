Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1223914F0
	for <linux-api@vger.kernel.org>; Sun, 19 Jul 2026 14:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784470378; cv=pass; b=rmj99QWFHSVIaxHz+9SX+ZyrMZOW5pDeKKW0wqmIP6YVS7cCzwyZbyfYvYLW0LQL6YJ0V/BjYCQYzq7k/+TCu0TWsUDJGKqhIgAHpSZfwbWe+q+7QLMgEpjlfBijWIReMwOJPiZbfqZmZAyFWEROSuYoafmeKXF4lWWahgauqf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784470378; c=relaxed/simple;
	bh=Gf39QtDs1NJUG97yBMAnk9ZJwy/ZHg7aeBsaEUjF3/g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QH9nIWSifTVJrUe0pDAWXy8UstfPxzoycrxPIwsMxR3YWDBJ3VL52UN0/ohBcHRYx1f8xDN9tosGS4kuFfhVwkbQvwBhWE9xAqK6V9ZzuNXIMvpkbNe2t6aZp/KDHibAW8hkOoJNDh7zqKkcE8mEhN8rUHzcBae7C9MVBtorWPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=d9wy5ZKV; arc=pass smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="d9wy5ZKV"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39c9107baa7so96309711fa.3
        for <linux-api@vger.kernel.org>; Sun, 19 Jul 2026 07:12:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784470375; cv=none;
        d=google.com; s=arc-20260327;
        b=oTS5D8qpujsZHtbup21Qoe4vAIc3PvFLJOdBq//etPuhe/W0EXfeCvLXsv/vTtyj2K
         oP5iRAMtweHmkcrEkNW9vTDFK16ibDmtmJoOQM88rnfuu22MUV672JXB7hfaI7sm/9EW
         RUjwncRNSVRnMZhKaLelgdJA4zBc7nPsxdoqPkTuqfNbj0LhzQ4v0Ny2fRG1BUCcp8kh
         IcbRj1ePnKMRzkJ6CuwJg3q+vEDAP1Lplqal+lOrmmwKtmSGChtIUnbqYABNwNFDI0ym
         jebrwGYwu5vWni8YQ1R3gg/nTHEiqIZK3+DfX8cqmAseRUPuByM7wqkMZhcs38WQdE9q
         uJ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8fnfVrhkwP422PxO/5FsFZHAUY1r3GNO+87kR51xMWc=;
        fh=AuIzExGaXiix9TIOifwAyamYG0uHpm4xH9flddvCGes=;
        b=KOE+u/c4tHPILRC5sm9GrJEjB7TsY6Dd2iNW1yQ+bvJ2PTmTbnLYWXHGNDNFwrgD/a
         1r9cczmxC0oBVUeso/M//cDdsvKma8IN1z7wUjw12IFy1ukOxr7YE01f/wXdBQxCWvTB
         MDlBwVLCVE59ZwoLggLLEMQ5jwhR1yPJ3P2HmrgP8LKn+QD1b6SOLQlrSqQjC9iNHnmt
         pa5bdeiBBvqLnUxE5/XrFPYvHeYcbMlRHMY5ryZR04c/panZjhxom7+yHRP6nmw4Dp7f
         deAqGm5C3O8DhZV7095BrIEwKogWvzbE3J32F5hgzueHQKMCoTA+7LtLQu+SMOBB8BJO
         jYdg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1784470375; x=1785075175; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8fnfVrhkwP422PxO/5FsFZHAUY1r3GNO+87kR51xMWc=;
        b=d9wy5ZKVfznR4qbSmLHM5wLxuSjQRPGy4i0VLYQtK5dLLnwGkRiddDA/VLgetiMi05
         Y+I5UVuKvV9E3SM3HWug7hMlD4PFdtZXvAOxx5/lQIh2bzY+pz1wpzt6Bzg0w3hILDMW
         e3GsK76nCbgIptHRnYDLRt9rCOZy8ameABUXCEZA8dK9EblMfR74xzbuPGYobV75OCGT
         5dmKGa4DA83unOer5/p/6wDrCqXELBQgzfxOhfojRcG7ht8/0nlpdK50hruoJQPTrjAj
         m2PabkRjHvH6MgKwQzHgdBgP8HHyIdR7r2EMuqKn+CkNA0aIbcifu3rVZlrjzFttBdzl
         Ph6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784470375; x=1785075175;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8fnfVrhkwP422PxO/5FsFZHAUY1r3GNO+87kR51xMWc=;
        b=VDdYNNk1QiBiu6c0MZ3nnJ8F3P935D6vtE19RsKu0XEvOp90jSRsbclxi/17L6wnOk
         ktNI7NtJokBid6kvyPMIeN8GXHSXKvAXZ45wCi+YvSpaxLpBH92jDQQSIG5IlSEjfsIN
         XlSbCuS43izr/UbxiGm+R4d2iR3qCHIelCpBNJruXAaedpyj4S7fXFMqNbA7NdhdFw8R
         qczSD0VBc2S1vZZscTG0OAmgNmDXdYVqxFNB7LwO0viJyM54ILJdLGhn2Rxsq593NV68
         EmLUMDdrLSlEQztdA2/qRLxnga2frV6eDhApj9MN3aazCJ/X2/kS/hiENTuhWmaEOxNu
         f/6g==
X-Forwarded-Encrypted: i=1; AHgh+Rogc6+9lAdNu9P1cGgAWxSBG7VeO9FE/o/8N6nu+iAkA/tpXPlbicDnDyAZBMcEHx7NNOxemmV4TGM=@vger.kernel.org
X-Gm-Message-State: AOJu0YydG9dXfpNusIzv5lYjux1/MyPgJMaS9fu9aw5TszMuUjiaNVi7
	dBLUDaqCsCa7cS1v75p9lJYdn2CCHxNaDEy4Vnwla+hoDdC5Mxnus+uI5CzA497I7K2ZD1SRwR0
	pjjgI/wOfrbb4XoBCnRvHtXTZ6EVEuCIt6BOaw1k3
X-Gm-Gg: AfdE7cluXaLRtFixN0YFZgNM6c8D6wNZGa13fUagdJ+qTJS5m8t/iIzzwfxvgy/unLL
	gmGhAssdm6rs40WgRpYwiDswO5rZBHK3uS61VZhyplIbiJj0SBm0Clr8/O6rK7DHvEfNIoZgTmf
	Bx/v8FmyBJGBrxGWCA+vW6s5s/qbc4JWCIRatDQmio3rUzr+wx9/HfIEhIbeB/KO//+LTTt0Yjx
	vMV6UN+KkiiFehammkJdZN7aB7KMteaJ3ANNmqgWpElhR6Bvamm0JRdNgg=
X-Received: by 2002:a05:6512:3d8f:b0:5b0:1879:1ba9 with SMTP id
 2adb3069b0e04-5b28f9a5720mr2256451e87.33.1784470374426; Sun, 19 Jul 2026
 07:12:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com>
In-Reply-To: <20260715101107.973997-1-mszeredi@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 19 Jul 2026 07:12:42 -0700
X-Gm-Features: AUfX_mx-VrWAtPNuDviKfVjbn51tqQht-nWAXr-HfoWBbjn3eDOh3hiCtUPefpg
Message-ID: <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 3:17=E2=80=AFAM Miklos Szeredi <mszeredi@redhat.com=
> wrote:
>
> This is a prototype patch. Needs to be split up!
>
> 1) O_ALT / OPEN_TREE_ALT
>
>   These open an alternative namespace rooted at dfd - instead of resolvin=
g
>   the path in the real filesystem, it resolves it in a virtual tree that
>   exposes metadata about that file.
>
>   This is intended to provide an alternative to adding new ioctls:
>
>    - provides structured namespace
>    - allows accessing data through fs ops
>
>   Could call this O_META, but O_ALT seems more generic and there could be
>   uses beyond metadata (e.g. seekable, in-place decompression).

This gives me the willies a bit.  It's very cool, but it has some
potential security issues that I think we need to watch out for.  As
sort-of prior art, NTFS supports alternate streams and Reiser4, ahem,
supported files-as-directories.

Some questions that we would need to consider:

1. Can you open an fd referring to a "directory" within an O_ALT tree?
 What happens when an unsuspecting process gets such an fd?  Can you
fchdir to it?  chroot to it?  clone its tree and possibly bind-mount
it somewhere?

2. Can you bind-mount *onto* something inside O_ALT?

3. Whose creds are used for which operations?

4. Can you mmap the things in O_ALT?  Is this determined per object or
generically?

5. Would we ever allow FUSE to expose custom things inside O_ALT?
What contents of O_ALT can a program trust come from the kernel and
have the expected semantics?

--Andy

--=20
Andy Lutomirski
AMA Capital Management, LLC
