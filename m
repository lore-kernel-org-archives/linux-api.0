Return-Path: <SRS0=fNma=7R=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD333C433E0
	for <linux-api@archiver.kernel.org>; Thu,  4 Jun 2020 01:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CF6820738
	for <linux-api@archiver.kernel.org>; Thu,  4 Jun 2020 01:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgFDBPN (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 3 Jun 2020 21:15:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42521 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgFDBPN (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 3 Jun 2020 21:15:13 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jgeTO-0006OA-PB; Thu, 04 Jun 2020 01:15:10 +0000
Date:   Thu, 4 Jun 2020 03:15:09 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [PATCH v5 0/3] close_range()
Message-ID: <20200604011509.jcagqr3e3qxru6cl@wittgenstein>
References: <20200602204219.186620-1-christian.brauner@ubuntu.com>
 <CAHk-=wjy234P7tvpQb6bnd1rhO78Uc+B0g1CPg9VOhJNTxmtWw@mail.gmail.com>
 <20200602233355.zdwcfow3ff4o2dol@wittgenstein>
 <CAHk-=wimp3tNuMcix2Z3uCF0sFfQt5GhVku=yhJAmSALucYGjg@mail.gmail.com>
 <20200603232410.i3opsbmepv5ktsjq@wittgenstein>
 <CAHk-=wgTpLOeMjpLOc8hY7KC6Qv+jR-hBacyBSajJ6iUKasmKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgTpLOeMjpLOc8hY7KC6Qv+jR-hBacyBSajJ6iUKasmKA@mail.gmail.com>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Jun 03, 2020 at 05:13:36PM -0700, Linus Torvalds wrote:
> On Wed, Jun 3, 2020 at 4:24 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > Ok, here's what I have. Does the below look somewhat sane?
> 
> Probably. Needs lots of testing. But this one looks wrong:

Right, there's a patch for a test-suite for the new flag too using
CLONE_FILES to create a shared fdtable and the proceeds to close all
(or subsets of) fds:

https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/commit/?h=close_range&id=498e7e844fe6e3f3306b2cd1b5e926e1cd394b99

I've been running that in an endless loop for a while.

> 
> > +int __close_range(unsigned fd, unsigned max_fd, unsigned int flags)
> >  {
> > +               if ((max_fd + 1) >= cur_max)
> > +                       max_unshare_fds = fd;
> 
> A normal value for "close everything starting at X" would have a
> max_fd value of ~0.

Ugh, obvious braino from my side. This should just be:

if (max_fd >= cur_max)
	max_unshare_fds = fd;

> 
> So "max_fd+1" would overflow to 0, and then this would never trigger.
> 
> Other than that it looks what what I imagine my feverdreams were about.

Thanks!
Christian
