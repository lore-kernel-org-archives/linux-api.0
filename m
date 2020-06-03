Return-Path: <SRS0=iV4/=7Q=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD4BC433DF
	for <linux-api@archiver.kernel.org>; Wed,  3 Jun 2020 00:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DF7E2072F
	for <linux-api@archiver.kernel.org>; Wed,  3 Jun 2020 00:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591142924;
	bh=Bvw7ta+8yXtDruHwIqmG1lpokg0cCz02Wn1FrM7aELY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=vdG4bSHgAPgeOXnovUsvHVe8gqLeDcF+RFifeLEVIwbMDqnt2lt0Y2OwDw+2rP3Hj
	 HkXz9R6TeTErx5AOO0eu87+fu4w/VuPf+cj9+snsqlCOIkFPLRiBFrQZTvgeQns2iL
	 3gPkfWJZcNZzuM0xZmvDBapFZ5BGlUHB+usboh4c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgFCAIn (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 2 Jun 2020 20:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgFCAIn (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 2 Jun 2020 20:08:43 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD07C08C5C0
        for <linux-api@vger.kernel.org>; Tue,  2 Jun 2020 17:08:42 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id x22so164616lfd.4
        for <linux-api@vger.kernel.org>; Tue, 02 Jun 2020 17:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PazKvjjbmAQeUYiZad4yyf2QZKpFBXiEaJOc1KsToFM=;
        b=cxQ3fmuQWsQSr6abyNc9/tsWVhRgX+CIskaA0+9tWleBkBxH+nD83NbhOrLA4+l62q
         IHd7DWRbt8QX/EQhJmNdBB/KVbcm3z19PVF4njNDsJ2EVCzILIGOTxNV+HKYvlu2vYC2
         U0ZUjz234y+0uLMwggsMalqWy5B+hZTC5aMVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PazKvjjbmAQeUYiZad4yyf2QZKpFBXiEaJOc1KsToFM=;
        b=L0c3bE6MnVjMj7Fu+QLEM1OfRVx/vmmbIY/83JoDLCGLhhNhRfK7ZjR8omBdWnllhv
         +pRwV30Vi2HFX2oiJAXEMiCwWiikUwf4TUIORW1X/iNrTlby79HbWKFh+t0GAF3yurXp
         4QSb3G8PuyqJpzxyaapCRrCwKOjdkNaLQMqE/2NgHyDMB5PCx8oUYoqoA9P8NnDGx6wa
         o3gcT8WtTzFhfklcWIADqrC+fV5iaR2yAEtaRyLXl2NaA55uKfZ6EolUIKicmlbHKtxV
         nxZg6vlrbgIqodl0h8Rx04C2yw7abzxRaXmwJZ5s/laeYfWp7gyZih9B/yfCSb+r/AsQ
         //4Q==
X-Gm-Message-State: AOAM531W5uKxDt3/nBcL0K79VcqEftQTpYzYM3fIWS0YKOuwiJN4DFjI
        rU5N5a9YrvgXVBCUPHVa7xyWM66bqWY=
X-Google-Smtp-Source: ABdhPJwenOX2y8pPvpYmuGCSS69IMaujzWTwoBp5sk4KVI33gWhA5Mx2rFfdkilgDpYxeVBKCF22gQ==
X-Received: by 2002:ac2:490f:: with SMTP id n15mr925999lfi.39.1591142921025;
        Tue, 02 Jun 2020 17:08:41 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id w15sm142598lfl.51.2020.06.02.17.08.39
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 17:08:40 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id e125so175121lfd.1
        for <linux-api@vger.kernel.org>; Tue, 02 Jun 2020 17:08:39 -0700 (PDT)
X-Received: by 2002:ac2:5a4c:: with SMTP id r12mr947879lfn.10.1591142919097;
 Tue, 02 Jun 2020 17:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200602204219.186620-1-christian.brauner@ubuntu.com>
 <CAHk-=wjy234P7tvpQb6bnd1rhO78Uc+B0g1CPg9VOhJNTxmtWw@mail.gmail.com> <20200602233355.zdwcfow3ff4o2dol@wittgenstein>
In-Reply-To: <20200602233355.zdwcfow3ff4o2dol@wittgenstein>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 2 Jun 2020 17:08:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wimp3tNuMcix2Z3uCF0sFfQt5GhVku=yhJAmSALucYGjg@mail.gmail.com>
Message-ID: <CAHk-=wimp3tNuMcix2Z3uCF0sFfQt5GhVku=yhJAmSALucYGjg@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] close_range()
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyle Evans <self@kyle-evans.net>,
        Victor Stinner <victor.stinner@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuah@kernel.org>,
        David Howells <dhowells@redhat.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Jun 2, 2020 at 4:33 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> >
> > And maybe this _did_ get mentioned last time, and I just don't find
> > it. I also don't see anything like that in the patches, although the
> > flags argument is there.
>
> I spent some good time digging and I couldn't find this mentioned
> anywhere so maybe it just never got sent to the list?

It's entirely possible that it was just a private musing, and you
re-opening this issue just resurrected the thought.

I'm not sure how simple it would be to implement, but looking at it it
shouldn't be problematic to add a "max_fd" argument to unshare_fd()
and dup_fd().

Although the range for unsharing is obviously reversed, so I'd suggest
not trying to make "dup_fd()" take the exact range into account.

More like just making __close_range() do basically something like

        rcu_read_lock();
        cur_max = files_fdtable(files)->max_fds;
        rcu_read_unlock();

        if (flags & CLOSE_RANGE_UNSHARE) {
                unsigned int max_unshare_fd = ~0u;
                if (cur_max >= max_fd)
                        max_unshare_fd = fd;
                unshare_fd(max_unsgare_fd);
        }

        .. do the rest of __close_range() here ..

and all that "max_unsgare_fd" would do would be to limit the top end
of the file descriptor table unsharing: we'd still do the exact range
handling in __close_range() itself.

Because teaching unshare_fd() and dup_fd() about anything more complex
than the above doesn't sound worth it, but adding a way to just avoid
the unnecessary copy of any high file descriptors sounds simple
enough.

But I haven't thought deeply about this. I might have missed something.

            Linus
