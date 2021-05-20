Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE824C433ED
	for <linux-api@archiver.kernel.org>; Thu, 20 May 2021 01:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB8326112F
	for <linux-api@archiver.kernel.org>; Thu, 20 May 2021 01:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhETBHe (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 19 May 2021 21:07:34 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:37172 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhETBHd (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 19 May 2021 21:07:33 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 3FDFF72C8BA;
        Thu, 20 May 2021 04:06:12 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 3018A7CC8A6; Thu, 20 May 2021 04:06:12 +0300 (MSK)
Date:   Thu, 20 May 2021 04:06:12 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Rich Felker <dalias@libc.org>
Cc:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>, musl@lists.openwall.com,
        linuxppc-dev@lists.ozlabs.org, linux-api@vger.kernel.org
Subject: Re: Linux powerpc new system call instruction and ABI
Message-ID: <20210520010612.GA25599@altlinux.org>
References: <20210518231331.GA8464@altlinux.org>
 <9b5ea7059c5a5d4e9ccccd7d73ce2c66b2203f52.camel@infinera.com>
 <1621410291.c7si38sa9q.astroid@bobo.none>
 <fb9b6a6099855bd00efc6ffe540ccad14dd9a365.camel@infinera.com>
 <1621413143.oec64jaci5.astroid@bobo.none>
 <20210519143836.GJ10366@gate.crashing.org>
 <11d62aa2488e51ec00fe77f24a1d7cdcc21af0b8.camel@infinera.com>
 <20210519152205.GL10366@gate.crashing.org>
 <adec4377144a44b6f9ddd10c1b5256b80c9ceb50.camel@infinera.com>
 <20210519234846.GS2546@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519234846.GS2546@brightrain.aerifal.cx>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, May 19, 2021 at 07:48:47PM -0400, Rich Felker wrote:
> On Wed, May 19, 2021 at 06:09:25PM +0000, Joakim Tjernlund wrote:
[...]
> > W.r.t breaking ABI, isn't that what PowerPC is trying to do with the new syscall I/F? 
> 
> No, it's a new independent interface.

Unfortunately, being a new independent interface doesn't mean it isn't
an ABI break.  In fact, it was a severe ABI break, and this thread is
an attempt to find a hotfix.


-- 
ldv
