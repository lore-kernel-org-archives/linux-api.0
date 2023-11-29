Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="EuilvnO2"
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83A0E1
	for <linux-api@vger.kernel.org>; Wed, 29 Nov 2023 02:22:16 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-a0064353af8so143349266b.0
        for <linux-api@vger.kernel.org>; Wed, 29 Nov 2023 02:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1701253335; x=1701858135; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9+e0dRtq/eVvLjlvv0ngS2mg6O6proBJR0bbQEcbEis=;
        b=EuilvnO2ySuvARzfTdfao9rmmv+y4MwgZF8tyBr3epm5frC9kqehKwVq5jVfxXlrfH
         +294uXc/tzV0T7ylOYzLcNWSonRX0UybZYrFe5SYcfiFRpRUQfAWPX5H4edLj8pb10un
         C2Rg0IjhiXZeCxfFz+uIiZeztY3sfcLqSZM9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701253335; x=1701858135;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9+e0dRtq/eVvLjlvv0ngS2mg6O6proBJR0bbQEcbEis=;
        b=Xvi24oxdkrQ1eaevvjIM22AW+dguKhRJcpODK/48/NrK0GPbgbBiWnuGudJuaZ7HZN
         s/FyGU1avLna2JmCuzjBOmHiEomtFyvurjZQiwDDYs6XDfRwgG1wIAZTPGAqwCRkwEAJ
         2+wjVRvTFvWOytZym3MIO6jyvLD6TWKf0Rb7hSvHp93U0KQUKPOls1E+j1WVqDmy4/le
         HbNMK8AzjNcjC2EzZLXz4434WtomEdvkYqIhZy4ufA4EkgLTDPWNaJpBusG/JSrEGce9
         eP6ziwEGeVoZftfCXRsk34CmkUH5FASM/xzg7un3SFuo9vVRTiSGdD55iN93zQ/i8pKU
         gf9g==
X-Gm-Message-State: AOJu0YyPQcv9HeWQAKDKirKTZBqXhA5yv26zOEBDIjbmvS3/hAbKcQZ6
	IbX2dPzesjNFgjyibooY+Xx0vEg2/Hw6yAwYt0OIfg==
X-Google-Smtp-Source: AGHT+IFe2Auyy4JtaCYUTdFf1+k/Lokr/YEBdAfPiw0kmqkfN2zVsdt+ss1NgQC1HNqb46A1IyXx57LD6A+Zxv5YRCY=
X-Received: by 2002:a17:906:74dc:b0:a17:89f4:72b2 with SMTP id
 z28-20020a17090674dc00b00a1789f472b2mr895144ejl.25.1701253335332; Wed, 29 Nov
 2023 02:22:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231128160337.29094-1-mszeredi@redhat.com> <20231129-rinnen-gekapert-c3875be7c9da@brauner>
In-Reply-To: <20231129-rinnen-gekapert-c3875be7c9da@brauner>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 29 Nov 2023 11:22:03 +0100
Message-ID: <CAJfpegsTGq0TW0oFDnYiTeM+z66M73k1jXXjFE6GwebPQYSgGA@mail.gmail.com>
Subject: Re: [PATCH 0/4] listmount changes
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-api@vger.kernel.org, 
	linux-man@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Karel Zak <kzak@redhat.com>, linux-fsdevel@vger.kernel.org, 
	Ian Kent <raven@themaw.net>, David Howells <dhowells@redhat.com>, 
	Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"

On Wed, 29 Nov 2023 at 10:53, Christian Brauner <brauner@kernel.org> wrote:
>
> On Tue, 28 Nov 2023 17:03:31 +0100, Miklos Szeredi wrote:
> > This came out from me thinking about the best libc API.  It contains a few
> > changes that simplify and (I think) improve the interface.
> >
> > Tree:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git#vfs.mount
> >
> > [...]
>
> Afaict, all changes as discussed. Thanks. I folded the fixes into the
> main commit. Links to the patches that were folded are in the commit
> message and explained in there as well. The final commit is now rather
> small and easy to read.

Looks good, thanks for folding the patches.

>    * Remove explicit LISTMOUNT_UNREACHABLE flag (cf. [1]). That
>      functionality can simply be made available by checking for required
>      privileges. If the caller is sufficiently privileged then list mounts
>      that can't be reached from the current root. If the caller isn't skip
>      mounts that can't be reached from the current root. This also makes
>      permission checking consistent with statmount() (cf. [3]).

Skipping mounts based on privileges was what the initial version did.
That inconsistency was the reason for introducing
LISTMOUNT_UNREACHABLE.  The final version doesn't skip mounts based on
privileges, either all submounts are listed or the request is rejected
with -EPERM.

For the case when some submounts are inside root and some are outside
useing LSMT_ROOT should be sufficient.  LSMT_ROOT won't fail due to
insufficient privileges, since by definition it lists only mounts that
are below root.

Thanks,
Miklos
