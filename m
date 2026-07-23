Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A74C388E44
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 16:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825833; cv=none; b=YE46OGbQBOursTle61mydt+YCzcY9SDEmhfe8HPlIJ8wsDD4KyUThxcrLfzADeMfxaH81HZWMr/bTgErUZ+BL0dYaJcRyndKEgWe/A8dG7ciA8+fxodSXsFzL2BGutkOdjYwjdc7Nmr9YM4GwKV8hFFRT3svlj+Ak4MILdWpy9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825833; c=relaxed/simple;
	bh=PqykRVSsrwSwBko7HpI/DI8kB6OMIzURdtEjH0bl4go=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bxf6h1eff1q/qXE2k/Ug9YgHyvKuiC9FvFG+p7Y4FGZFNnkjLPsjKc2YWqDcPGp3mj4BlyGF5kvGUngO2P3S6ATAJvZvlthltPDvjZnwwnLOD3MQNaxSXkR7fGKxXCv4LcFfP+nHdYjlASHhEzDNv7aV8y+F3ys+sv+9JlJWqCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kCh/AVeT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCh/AVeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3C01F000E9
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 16:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784825831;
	bh=+pg0P9VSl+esL6Lh7ACV5pJPyjNye2t1udGbPDB26mw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kCh/AVeTi7hjGJivYLjcMp0USpShwO8oyLvFPC+T3AWClMUp7h1RjZfFJ01Ynywpq
	 9FRt97c6RrpOWL9+CH7a4XRO3U5vhXeSFoqX55NHIqzjC3bQRjNHrZgBmHChltDpxL
	 0AhAf4z2he/z355+z+1Gq3h6clYh22Cd75NuSTiYgFoC7EP6Y71JFSYULbR3cKPWkx
	 JrFOzs/DQXz3cYvyaO7vacXB1gCr7qQBBh5cDpOiKyJaKNIMVO1DUbWbIP6Qt7/1AU
	 XOWgC1kzElonX0L3czEtLPZTP704icG7T2hMvxw7aIPliy0B6JCazOu2nz3UtbSxl6
	 uE4zes0v1a3JQ==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b2a3166398so826730e87.3
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 09:57:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqvIGTTNzI6UKkNd4mcRnNOeuKMBDjRk3neCowDH1DH3FJZ8NIULw7PgMrWJiFUxXfeQgnEuSL/rKE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy38aOOY5kLT2P4EEzQ+NShzJNvRdq9ziC/vtEzdwLI9LxDHYdO
	7LunZ9mZTLSdslLVt8G9+2+fgecIXAdBuyhqCoVTG70iyjIufapssNnyT7wZLL0Tx8zr5+4sLxH
	i38hxLW+3ZbneN5zHicrShD12m6/p2/46Ab/pBuQw
X-Received: by 2002:ac2:4f0e:0:b0:5b2:aa5d:9d34 with SMTP id
 2adb3069b0e04-5b2b2f67c26mr858207e87.32.1784825830324; Thu, 23 Jul 2026
 09:57:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
 <20260723-work-failfs-v1-4-3f69b9a9e958@kernel.org> <CAG48ez1psv82Y98XT1p7vujYgj5a9hbPZ4=h7x4-yXQO5FQr6A@mail.gmail.com>
In-Reply-To: <CAG48ez1psv82Y98XT1p7vujYgj5a9hbPZ4=h7x4-yXQO5FQr6A@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 23 Jul 2026 09:56:57 -0700
X-Gmail-Original-Message-ID: <CALCETrWPQt5JJMiYcO_AdPbeK6zdDJVP71Y38YQ6x9VjcxAPig@mail.gmail.com>
X-Gm-Features: AUfX_mzjeayKkjWxi2CZUKV0qfPJXJwMd1SYkEprE_1eyDdsypuvQgPpb3epMK0
Message-ID: <CALCETrWPQt5JJMiYcO_AdPbeK6zdDJVP71Y38YQ6x9VjcxAPig@mail.gmail.com>
Subject: Re: [PATCH RFC 4/7] fs: support FD_FAILFS_ROOT in fchroot()
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Andy Lutomirski <luto@kernel.org>, John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 7:09=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
>
> On Thu, Jul 23, 2026 at 1:30=E2=80=AFPM Christian Brauner <brauner@kernel=
.org> wrote:
> > There's also some thought needed around shared fs_struct state. It's
> > obviously possible to chroot into failfs with a shared fs_struct if the
> > caller has CAP_SYS_CHROOT and shares the fs_struct or if the caller is
> > no_new_privs and shares the fs_struct. The non-chrooted-currently
> > requirement still applies.
>
> Having CAP_SYS_CHROOT and sharing the fs_struct should not be an issue
> because we already ensure that any tasks that share fs_struct are in
> the same user namespace, so CAP_SYS_CHROOT is implicitly also held
> relative to other users of the fs_struct. (In particular,
> userns_install() and unshare_fs() ensure this.) (Except if LSMs get
> involved with weird policy, I guess.) That's what makes the existing
> chroot() syscall safe.
>
> But yeah, the no_new_privs check I suggested is kind of a pain...
>

It's dorky, but we could say that your fs_struct must be non-shared
for unprivileged chroot to be allowed.

(I'm so mad at Docker for blocking *all* unshare calls in their
default policy.  Not a showstopper, but it's extremely annoying.  Yes,
I have an issue open that has been completely ignored.)
