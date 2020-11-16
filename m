Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53781C4742C
	for <linux-api@archiver.kernel.org>; Mon, 16 Nov 2020 16:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 002DE2222C
	for <linux-api@archiver.kernel.org>; Mon, 16 Nov 2020 16:23:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p5b/OlOP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbgKPQXP (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 16 Nov 2020 11:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731408AbgKPQXO (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 16 Nov 2020 11:23:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35989C0613CF;
        Mon, 16 Nov 2020 08:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wC11BFLS0HKPwQDYmOMG66/U+ahe9yd42lCMXwv4QE8=; b=p5b/OlOPoWFD7iH9PzjPFWdyd5
        katY9Q8Qryawj7Dd9i5Q2xNiaw5sqnhADtfH7aSyFDqoh6HOzlv92fTDTDSK/cKAQMGNQnB1/T/xS
        gTjmm9N6EKqEjAtAl0xlN0QBYYbu/yGKq3+Pqp/HieNy38UQbZ3VM7NstEA32hDwGKSmd1EPBuhmi
        NZbaAHMgPO7XX7CHUGKYR/xNkngx4pZHUKDlFaRB3sBUMbH//6Ni8fYAIU+k9y0fcUPRGhKIVwYBc
        vahP4dAHLJizP9DB78d6qntiYJKc99dv/z/1Fh3SrvobnhAkIr/fEi/iMx/VNxV0eyELAU9qsl/+Q
        AGxtXTWQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kehHb-000479-5d; Mon, 16 Nov 2020 16:23:11 +0000
Date:   Mon, 16 Nov 2020 16:23:11 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Tal Zussman <tz2294@columbia.edu>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] syscalls: Fix file comments for syscalls implemented in
 kernel/sys.c
Message-ID: <20201116162311.GA15585@infradead.org>
References: <20201112215657.GA4539@charmander>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112215657.GA4539@charmander>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Nov 12, 2020 at 04:56:57PM -0500, Tal Zussman wrote:
> The relevant syscalls were previously moved from kernel/timer.c to kernel/sys.c,
> but the comments weren't updated to reflect this change.
> 
> Fixing these comments messes up the alphabetical ordering of syscalls by
> filename. This could be fixed by merging the two groups of kernel/sys.c syscalls,
> but that would require reordering the syscalls and renumbering them to maintain
> the numerical order in unistd.h.

Lots of overly long lines in your commit log.

As for the patch itself:  IMHO we should just remove the comments
about the files as that information is completely irrelevant.
