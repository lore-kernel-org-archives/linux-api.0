Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D24C2D0E4
	for <linux-api@archiver.kernel.org>; Tue, 24 Nov 2020 16:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8A41206D8
	for <linux-api@archiver.kernel.org>; Tue, 24 Nov 2020 16:45:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fb4qefQb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390077AbgKXQpy (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 24 Nov 2020 11:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgKXQpy (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 24 Nov 2020 11:45:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02967C0613D6;
        Tue, 24 Nov 2020 08:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VC3gGuLiBsrRtVyrPRamwgJQDi67qlqWivQZYkAffFs=; b=fb4qefQb3i3AlqrcJroHwaUl78
        ub2HeK0qZ/bl10JOUhzHuDOazyI4H1NAxOZYNNEannYuejpWs0xyyhU2cPD+rTL0f8TJjtSI0uYOS
        T1iT2UGlrXlq1cM3FNTRPkt2Kqcp0WAYT+AGwl68Abx2/qgGJyzqYnD5OWY1gwV1XS7HvM3qtJPHI
        l0Uw/LhDgMkvp9PZjJOTs8bsjGAh1+POXdsWxX6wwDnRnScSL+v71xfSDHsl6/od7alzmwS2onifW
        uQwlZkLKRLPb5tj0HblwW75owISUA2R2jexF3oTZepjuUlZN+4AQHUt0hi6QjJmCmtCcwa/CskFvA
        CewgUPZg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khbRq-0003mS-K0; Tue, 24 Nov 2020 16:45:46 +0000
Date:   Tue, 24 Nov 2020 16:45:46 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Mark Wielaard <mark@klomp.org>
Cc:     Florian Weimer <fweimer@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@opencontainers.org,
        corbet@lwn.net, Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH] syscalls: Document OCI seccomp filter interactions &
 workaround
Message-ID: <20201124164546.GA14094@infradead.org>
References: <87lfer2c0b.fsf@oldenburg2.str.redhat.com>
 <20201124122639.x4zqtxwlpnvw7ycx@wittgenstein>
 <878saq3ofx.fsf@oldenburg2.str.redhat.com>
 <dcffcbacbc75086582ea3f073c9e6a981a6dd27f.camel@klomp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcffcbacbc75086582ea3f073c9e6a981a6dd27f.camel@klomp.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Nov 24, 2020 at 03:08:05PM +0100, Mark Wielaard wrote:
> For valgrind the issue is statx which we try to use before falling back
> to stat64, fstatat or stat (depending on architecture, not all define
> all of these). The problem with these fallbacks is that under some
> containers (libseccomp versions) they might return EPERM instead of
> ENOSYS. This causes really obscure errors that are really hard to
> diagnose.

So find a way to detect these completely broken container run times
and refuse to run under them at all.  After all they've decided to
deliberately break the syscall ABI.  (and yes, we gave the the rope
to do that with seccomp :().
