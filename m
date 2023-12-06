Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="iGq/vxTd"
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE95FA
	for <linux-api@vger.kernel.org>; Wed,  6 Dec 2023 01:40:59 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-548f853fc9eso8421712a12.1
        for <linux-api@vger.kernel.org>; Wed, 06 Dec 2023 01:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1701855657; x=1702460457; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NdsXEprLd6HHm6fn4LOj1PkScl+mGSgUDIFGPbATAlo=;
        b=iGq/vxTdjezu281ZT1I6ZZiZHUBt9u3Znww51YBIR+MefU6EyT3H1VTUI5Stf6jV4h
         /Ggp1mm1lV5ZLMxnaJQfAybasFUUtpliC+md6nA+m8ZGiJFslWFYJpzKanW/iHFtJJ0V
         1C39fKEeE+WYiqagNcRd/Bj4CYvRF5pVq4ngE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701855657; x=1702460457;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NdsXEprLd6HHm6fn4LOj1PkScl+mGSgUDIFGPbATAlo=;
        b=lhzI8IyzBfsTxJDMtDU6lC793F8Us9Rn5pRIV5ZLKWMnupGyUo37p3Tv0G5n4LQLRM
         6YRgWibplGoJ9Jz78bxUC+vVLhyTPGjKr3CaLhHLmS4eystZ/nbcBSXJGZ4BhcM+uoVl
         kFTJ6BX2TLsCrNpoHtdLcuupzFcU+4OXP6b4PMeEkLn8JRzyYe3ovQ38QzVPRL64CbDD
         oMPTJPmqFe0NXTgvpiF3FrKd7UGRbStMO7019ki9qyeIxHfB2XJUiE5L+awlev5t7//v
         xPqhRlLo1YMpEZgfu2KWshvQSlQj1PeLSBXRw8FO6Xd2rtobN8jts/rPnqT+uXwCi8Ii
         hcuA==
X-Gm-Message-State: AOJu0YyDKYL9y2mpj3ADPkAGuIjHP3CMpIJccuX8qA5PKfrnHDgZmd7m
	1VGwF19jWa4dXu2j4zXRqxXxWLtGGWkbCnOx818V9g==
X-Google-Smtp-Source: AGHT+IGiyiuky8gen+Lzcnom3IM1I854rjHl5xZVAp0PjEd3Lm828jNZa172WoDAsNxUJddzDdXafiVboFAQHKaioyM=
X-Received: by 2002:a17:906:1c3:b0:a1c:e6aa:4c47 with SMTP id
 3-20020a17090601c300b00a1ce6aa4c47mr215992ejj.36.1701855657496; Wed, 06 Dec
 2023 01:40:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpeguMViqawKfJtM7_M9=m+6WsTcPfa_18t_rM9iuMG096RA@mail.gmail.com>
 <20231205182629.qk5s6f7m7sas4anh@ws.net.home>
In-Reply-To: <20231205182629.qk5s6f7m7sas4anh@ws.net.home>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 6 Dec 2023 10:40:46 +0100
Message-ID: <CAJfpegtv0A8b2Ex7O0AUwZCFsB_OfXvD_ehYR0a6jMr0F_Okdw@mail.gmail.com>
Subject: Re: [RFC] proposed libc interface and man page for listmount
To: Karel Zak <kzak@redhat.com>
Cc: libc-alpha@sourceware.org, linux-man <linux-man@vger.kernel.org>, 
	Alejandro Colomar <alx@kernel.org>, Linux API <linux-api@vger.kernel.org>, 
	Florian Weimer <fweimer@redhat.com>, linux-fsdevel@vger.kernel.org, 
	Ian Kent <raven@themaw.net>, David Howells <dhowells@redhat.com>, 
	Christian Brauner <christian@brauner.io>, Amir Goldstein <amir73il@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Dec 2023 at 19:26, Karel Zak <kzak@redhat.com> wrote:
>
> On Tue, Dec 05, 2023 at 05:27:58PM +0100, Miklos Szeredi wrote:
> > Attaching the proposed man page for listing mounts (based on the new
> > listmount() syscall).
> >
> > The raw interface is:
> >
> >        syscall(__NR_listmount, const struct mnt_id_req __user *, req,
> >                   u64 __user *, buf, size_t, bufsize, unsigned int, flags);
> >
> > The proposed libc API is.
> >
> >        struct listmount *listmount_start(uint64_t mnt_id, unsigned int flags);
> >        uint64_t listmount_next(struct listmount *lm);
> >        void listmount_end(struct listmount *lm);
>
> What about:
>
>     getmountlist()
>     nextmountlist()
>     freemountlist()
>
> For me, _start and _end() sounds strange. For example, We already use
> get+free for getaddrinfo().

Fine by me.  Just wanted to get the general scheme out for comment.

Thanks,
Miklos
