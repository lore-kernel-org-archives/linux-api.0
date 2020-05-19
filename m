Return-Path: <SRS0=YSuu=7B=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69717C433E1
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 08:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5348F20709
	for <linux-api@archiver.kernel.org>; Tue, 19 May 2020 08:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgESIau (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 19 May 2020 04:30:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38751 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728456AbgESIat (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 19 May 2020 04:30:49 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jaxe9-0002B4-6Y; Tue, 19 May 2020 08:30:45 +0000
Date:   Tue, 19 May 2020 10:30:44 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
        Tycho Andersen <tycho@tycho.ws>,
        Matt Denton <mpdenton@google.com>,
        Chris Palmer <palmer@google.com>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: seccomp feature development
Message-ID: <20200519083044.lo5d22hdd5nc3dcm@wittgenstein>
References: <202005181120.971232B7B@keescook>
 <CAG48ez1LrQvR2RHD5-ZCEihL4YT1tVgoAJfGYo+M3QukumX=OQ@mail.gmail.com>
 <20200519072451.GA3128@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200519072451.GA3128@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, May 19, 2020 at 07:24:52AM +0000, Sargun Dhillon wrote:
> On Tue, May 19, 2020 at 12:39:39AM +0200, Jann Horn wrote:
> > > For user_notif, I think we need something in and around these options:
> > >
> > > - make a new API that explicitly follows EA struct design
> > >   (and while read()/write() might be easier[4], I tend to agree with
> > >   Jann and we need to stick to ioctl(): as Tycho noted, "read/write is
> > >   for data". Though I wonder if read() could be used for the notifications,
> > >   which ARE data, and use ioctl() for the responses?)
> > 
> > Just as a note: If we use read() there, we'll never be able to
> > transfer things like FDs through that API.

(Hm, how did I not get that message? Weird. :))

I hope we won't be able to receive fds through read(). This quickly
becomes quite problematic, I think.

> > 
> Although there is no good reason for read being able to receive FDs, there is
> precedence for recvmsg being able to do this. Either way, I do not think

Right, and recvmsg() is quite dangerous because of that because you need
to be extremely careful when e.g. the message is truncated and you want
to error out and you need to carefully close all fds and other shenanigans.

Also, recvmsg() imho, is a bit different from read simply because
it's sort-of a "typed" read; it's plumbed on top of a message protocol and
that protocal includes the ability to read fds. read() on the other hand
is completely agnostic and doesn't care about the data at all. But
that's just how I always conceptualized it...

> it's a good idea to recv file descriptors, and instead file descriptors
> should be fetched via the pidfd_getfd syscall.

+1

> 
> Injection is more complicated, and for now, I believe that "writes" should
> be done via ioctl, or in the future, something like sendmsg might work.
