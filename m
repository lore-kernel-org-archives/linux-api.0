Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26453F1660
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 08:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784793629; cv=pass; b=CR2gdGcocutHA2rJHiszs50IxSvcWnodZXU+hRtUg3FpbhS4h/3L4NZ8Dx3MH1QkQNRN0dH5+i46H0Rp5TvWJ29JgM/0ixuan2ZuUUD7mA0g5grLMmW5C4x22V31vRtPeh+GQ+3lwGCtohavU2Qk+UbwvNrI05D75H/i8/wa0hU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784793629; c=relaxed/simple;
	bh=01lHwYFuZnQbN8PHIAgwHtlEdJ/vNcJ+QxlGxzJvbrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oCxgOYtdFWuUlcptzE53nIBhTzhNb2NhOnOBIfrCmkuWxJZNrkRgi2n1TXMeuim+XdKAEjKs6FbI/d5vwiZgwbjiISvx1/4IL4ceUYRE2ifVe7YZtzwAmD3RbJWjxxoEyIOHs5y/wYWAdfeIo90IHaaTHrdRHZZUMgpjlA4hqpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=fyKFttsW; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="fyKFttsW"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51bfad59921so2888391cf.0
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 01:00:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784793627; cv=none;
        d=google.com; s=arc-20260327;
        b=KGjy4hP+7GLdwWE8Fu3pllIgnw7qienKPUx9LE/+EyfqQJ2MyqcliNfmIjw73Aliv0
         P07PgOwageV+N+LLtBbwgGJj2bL07NLRFgpIMnc+bsSN5DJgub8sd21gVrdvfxD1+ISh
         6Sq5yHERv0gtgbkRtOG9OiexI6OtjuPbOTG2qipRyuyp1njf/5itoDf560o4U8E9U3MA
         cHGjikNzQcRccnF/fTb9YopX7TdainmmWhxwcFH3obPUoAoXIkgUskDStKoEBqQt9fm4
         0rkcMnjxn3+lHZYyKI8wSy9wbmJe8l85zl4D/7pl7pW8qZQmShirKukJzFRe3GiHJOcc
         vRoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=aJJyvzLCovMudd4JAugLONkO2PNspQZPslZQeXuUmI0=;
        fh=+pIqG0aTbWZCYbHA5RLpDjN0mXqzIo9eW6LtKPUuxSQ=;
        b=HjzZqfbPYMVh8OpwseixXPwuxhzefBljmnMJGINXd3U8tuDxtuaM8LuJgamXTcBLae
         EuuTnLyGbykcVyMxHsUaR5dRqQ/viHily22YeazoQQraOFi852uilfepgY8F5bSj5tN6
         E0Hd0Axger4ewwZiO21Qyn6bFQSEzNL7F0MSgdAc2PAi6LE29lWEYf8aGN9B483ZjQgA
         QhXDnxYJnMj8+0nTkw6NcEE7gA0i1+ntDtswi6bQpThmVJOezu9mla6lRGcwccCS/R2i
         8+jhpfu8qYRb43Mfyxt6iu4AE97mtuatwT3ZE6VG4qfB/cay5PSLd9aanL3PWRCStFPi
         IoZA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784793627; x=1785398427; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aJJyvzLCovMudd4JAugLONkO2PNspQZPslZQeXuUmI0=;
        b=fyKFttsWz2DOyLtPnYauQQPYmkm2e/OIaFutCA19BKBPecaxcRba025AoAZzkU/f7E
         6/vfvMqYq6V5IXujJaouvPuU/8eQoL0+HIIlp+uJ7/S33XYv9XS13w5FLMGpcJgHiEIn
         ccX0LqfKPXnNSpHD9q/Mm+8q9hdsD9NDhRAiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793627; x=1785398427;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aJJyvzLCovMudd4JAugLONkO2PNspQZPslZQeXuUmI0=;
        b=VTCf9vA0S3bSbCBDzlDuVA+nY2PM9hwgiHtEDNk6MxwW3ngVRxFKJpa3uHqqcuzrWw
         R2KujkbFpEzz3uf/VZklUuYVqGqwmlxvvty34nsZx3gQ20oeRuEBTrdfHOuvCsuOsh4C
         QwoBSsY4uw1GIsXsMRuzIMcRwb8M3xDxXEiMKfy2eJNIR+VaQ86QLqP6HBQ5vthnHnAN
         J223Uge7xdmw39jjGecuqecgnOBsv3HIsUWiMQiLYjYAdjI/75pY4HNVlmXGrDNWcL2A
         YmYLYMqy31Db0BZiIglr7evSCYpc16qijXVuEzkbK1HRvkJED2gMjF8T13gGtrL+MA87
         QJqA==
X-Forwarded-Encrypted: i=1; AHgh+RpqlvGsn8qDnJPpq9Vbvkty4sxqzHXRhmEnw8gtewvNRl6d/7ZpUgJKBYB4hoH1jC7LpalcsMbraaY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvu81wwpMkxDcw7ySThl02bGdAsFxYMdUSgUwORY5DGBPi8h7b
	EjY15Bz0ZEoLC1h1xiRlmFxMZ6KYpnxQpjCF/NOj1O8IEji7jjmmqkCRhpI6G5oNk15MMWddUrN
	8Y6mUSebq2o+eXd1IhEqBVX6wzuqOwuNlB4XDWUHexg==
X-Gm-Gg: AR+sD12JZqb5O+Qfftp2+sEA9zdoa8JSZA8PanxRld0HqcAutucJ5vh4lqS/Ld27WMb
	21vK4E/6lGGVEC4nTYqcgnwbpD+IAd1A6J+V8v288F1P6i/RqJJvbHHF3I3Wth4zUmMT4uIb/m1
	mwfDyM1VgX6l9g+L8RzpHdzxEdVjm2j9A0pIYuMFGGYKnHr4nId1Ff1SQUihPNSJstav9u4b4wL
	Fdh70+d9L3FPPhlvG49kkJKb7KSbD40DCWh8LMNmODkQHvesJNI6AyldMcC0xoMrQhgHlne0E2K
	rzGTrKdVruUbKDBDiQ==
X-Received: by 2002:a05:622a:a06:b0:528:3ae6:14b1 with SMTP id
 d75a77b69052e-5283ded5b58mr17799601cf.43.1784793626482; Thu, 23 Jul 2026
 01:00:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
In-Reply-To: <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jul 2026 10:00:14 +0200
X-Gm-Features: AUfX_mxrAWDoGqE_Z2q7dsB9hEn4mw686sbiCfQ_kvnOWqvfJ8QAiTiMbX_EDHA
Message-ID: <CAJfpegs9Mzx2bPTmWWzGWv7D2jF5Nspns-U6jf=KeAufiFMXyA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 at 18:06, Christian Brauner <brauner@kernel.org> wrote:

> We've added a primary set of apis to retrieve mount options. I really
> dislike the idea of introducing a completely orthogonal layer to do the
> same thing (or more) and also make it filesystem based while at it.

Fair enough.

> The other proposal of moving it into procfs doesn't lower the creepiness
> factor. It just paints it a different color. My objection is to the
> shape of this not where the entry point lives.

Also fair point.  The reason I like the proc entry point is that it
makes this accessible in the global namespace.

> Like, I'm fine having an api where we can use open_tree() to see through
> into underlying layers and given the right permission pull a mount out
> of it. That seems something we can potentially do.

That's exactly what I was proposing.  The "retrieve all mount options"
was a bad idea.  Will drop it.

> There's a few issues on top of that. O_ALT is silently ignored unless
> you spell the open as openat(dirfd, relative, ...). path_init() only
> looks at LOOKUP_ALT in the dirfd branch. open("/abs", O_ALT) and
> openat(AT_FDCWD, "rel", O_ALT) fall straight through and open the real
> file.

Good point.   It should either reject the non fd case (including plain
open(2) or use cwd as the base.  I'm leaning towards the former.

> The layer symlinks are an unchecked jump into internal, out-of-namespace
> mounts. Following mount/options/upperdir/0 ends in nd_jump_link(). That
> doesn't do permission checks and no mnt_ns check.

It should do the permission check, will fix.

It's jumping into an anonymous mount, why should it check mnt_ns?

> The overlay upper/lower layers are internal mounts with no mountpoint in
> any namespace. So any unprivileged process that can open the overlay
> root gets an O_PATH handle to a layer root it has no search-permission
> path to and on a mount outside its namespace and can then use it as a
> dirfd.

It's just missing the permission check in metafs_path_get_link().

> Pulling the mount out is gated by CAP_SYS_ADMIN, but the handle and the
> traversal are not. That's exactly Andy's "whose creds" question, it's
> inherent to the design, and the procfs variant has it too.

Maybe I'm not getting something.   Why would the metafs based design
be more limited in how it checks permission and with which creds than
any other interface?

>
> get_options() forks ->show_options() permanently. It's added
> alongside the existing method and mnt_show_options() now tries one then
> the other.
>
> That leaves the tree split forever or commits us to a flag-day
> conversion of everything. The new thig is also heavie and loses the
> seq_file overflow-retry. All so the 99% of filesystems that will never
> expose a path option can carry a more complicated interface.

This is something that would be useful anyway.  Would prevent the back
and forth escaping for statmount.  I can do a full conversion patch
either with coccinelle or claude in a couple hours.   And nothing is
lost, the layer above seq_file is just an abstract class, could make
it call exactly the same seq_file ops as before.

> mnt_devname to s_devname move is a behavioral change. alloc_super()
> records fc->source only on the sb-create path in sget_fc(). Sharing an
> existing sb path never updates it. For filesystems that share a
> superblock across mounts every mount now reports the first mounter's
> source in /proc/self/mountinfo and statmount().

Well, drat.  Doesn't really matter, though.

> And the smaller details really show how inelegant this model is and why
> Al and I have opposed it multiple times before. Scalar options are
> modeled as symlinks and non-path options are dangling links whose
> readlink still returns the value while for path options readlink returns
> the option string but following the link jumps somewhere else entirely.

Hey, this is was a prototype to show that this can do what Giuseppe
needs.  Not with nicely polished interfaces.

Completely agree with you, that's a shitty interface that I've done in
there.  Not proud of it.

But that's completely besides the point.  The point is that it would
allow a lot of things to be done more elegantly, without adding
special interfaces all over the place.

> But a generic metadata interface layered on top of yet another magic
> filesystem whether it's mounted or hidden behind procfs I feel very
> strongly about. I also have great difficulty seeing Al supporting it.

Me too, as you have obviously noted.

I'm going offline for two weeks starting this weekend, so no lengthy
and heated discussions for a while.

But I'll be back!  HA HA HA ha

Thanks,
Miklos
