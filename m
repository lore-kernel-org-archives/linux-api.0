Return-Path: <SRS0=y6mp=BY=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE21C433E1
	for <linux-api@archiver.kernel.org>; Fri, 14 Aug 2020 11:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFC0B20771
	for <linux-api@archiver.kernel.org>; Fri, 14 Aug 2020 11:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgHNLdk (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 14 Aug 2020 07:33:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49807 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgHNLdj (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 14 Aug 2020 07:33:39 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1k6Xxp-0001hz-8t; Fri, 14 Aug 2020 11:33:37 +0000
Date:   Fri, 14 Aug 2020 13:33:36 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Devin Bayer <dev@doubly.so>
Cc:     linux-api@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: setsid2(sid) proposal - assign current process to existing
 session
Message-ID: <20200814113336.v45vdkos25m4utjc@wittgenstein>
References: <ecede52e-1f5d-8357-37f8-948456688862@doubly.so>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ecede52e-1f5d-8357-37f8-948456688862@doubly.so>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Aug 14, 2020 at 01:09:54PM +0200, Devin Bayer wrote:
> Hello,

Hey Devin,

> 
> I'm wondering about the possibility of introducing a new system call for
> moving a process to an existing session. If `sid` is an existing session
> with the same owner as the current process, one could call:
> 
> 	setsid2(sid)
> 
> This would have similar behavior to setpgid(), and would probably
> effectively call setpgid() internally too.

Honestly, there are already so many transitioning rules between process
groups and session groups (like that a process group leader can't create
new sessions and subsequently also shouldn't be able to move between
sessions and if you move between process groups they both must be in the
same session) I'm really no keen on introducing yet more transitioning
rules.

Also, session ids and process group ids are racy enough as it is and
introduce edge-cases that are annoying in userspace especially when
signaling process groups. I'm not a fan of introducing even more
racyness.

> 
> The use case is for something like `flatpak-spawn --host`, which allows you
> to launch a program in an outer namespace from an inner namespace. It
> behaves as a child of the caller but is actually a child of an external
> daemon.
> 
> It works by connecting stdin/out/err to those of the caller, for example a
> PTY for xterm running in the inner namespace. This works fine for
> non-interactive programs, but it's impossible for the spawned task to share
> the controlling TTY with the shell running in xterm.
> 
> I can't see where the problems are, though I'm surprised such functionally
> doesn't yet exist. Because it deals with such basic concepts, I'm wondering
> if such a change will even be considered.
> 
> There is a workaround; one can create a new PTY on the host and copy the I/O
> streams manually. Not ideal, but okay.

The solution you mentioned is basically the standard way of dealing with
similar problems in every container runtime and in various other places
in userspace and given that it's not that hard to implement this seems
fine.

Thanks!
Christian
