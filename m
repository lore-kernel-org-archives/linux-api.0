Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1040FC433B4
	for <linux-api@archiver.kernel.org>; Wed, 19 May 2021 15:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D67FE610CB
	for <linux-api@archiver.kernel.org>; Wed, 19 May 2021 15:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbhESP1v (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 19 May 2021 11:27:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:55376 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233470AbhESP1u (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 19 May 2021 11:27:50 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 14JFM7FS030436;
        Wed, 19 May 2021 10:22:07 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 14JFM5pa030435;
        Wed, 19 May 2021 10:22:05 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 19 May 2021 10:22:05 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "npiggin@gmail.com" <npiggin@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "ldv@altlinux.org" <ldv@altlinux.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "musl@lists.openwall.com" <musl@lists.openwall.com>,
        "libc-dev@lists.llvm.org" <libc-dev@lists.llvm.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: Linux powerpc new system call instruction and ABI
Message-ID: <20210519152205.GL10366@gate.crashing.org>
References: <20200611081203.995112-1-npiggin@gmail.com> <20210518231331.GA8464@altlinux.org> <9b5ea7059c5a5d4e9ccccd7d73ce2c66b2203f52.camel@infinera.com> <1621410291.c7si38sa9q.astroid@bobo.none> <fb9b6a6099855bd00efc6ffe540ccad14dd9a365.camel@infinera.com> <1621413143.oec64jaci5.astroid@bobo.none> <20210519143836.GJ10366@gate.crashing.org> <11d62aa2488e51ec00fe77f24a1d7cdcc21af0b8.camel@infinera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11d62aa2488e51ec00fe77f24a1d7cdcc21af0b8.camel@infinera.com>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, May 19, 2021 at 03:06:49PM +0000, Joakim Tjernlund wrote:
> On Wed, 2021-05-19 at 09:38 -0500, Segher Boessenkool wrote:
> > On Wed, May 19, 2021 at 06:42:40PM +1000, Nicholas Piggin wrote:
> > > Excerpts from Joakim Tjernlund's message of May 19, 2021 6:08 pm:
> > > > I always figured the ppc way was superior. It begs the question if not the other archs should
> > > > change instead?
> > > 
> > > It is superior in some ways, not enough to be worth being different.
> > 
> > The PowerPC syscall ABI *requires* using cr0.3 for indicating errors,
> > you will have to do that whether you conflate the concepts of return
> > code and error indicator or not!
> > 
> > > Other archs are unlikely to change because it would be painful for
> > > not much benefit.
> > 
> > Other archs cannot easily change for much the same reason :-)
> 
> Really? I figured you could just add extra error indication in kernel syscall I/F.
> Eventually user space could migrate to the new indication.

You seem to assume all user space uses glibc, or *any* libc even?  This
is false.  Some programs do system calls directly.  Do not break the
kernel ABI :-)


Segher
