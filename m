Return-Path: <SRS0=IXk3=6M=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022B3C83000
	for <linux-api@archiver.kernel.org>; Tue, 28 Apr 2020 23:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D28582076A
	for <linux-api@archiver.kernel.org>; Tue, 28 Apr 2020 23:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588117701;
	bh=+CmCVpLvW0aUd8fDAt5wjRwWtdOsyPOjWET1BE5+qwQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=S9S3/sYNdAF1cIN5UqeSOi1Y7I5qD/PkqNZMxNEjrDgc9vXGnJ+aMP890eJ0lH9n4
	 cM/0dcmUWP/ocXmoMe97/nZo59MpkIrJFDsz3H3r9gzk5PyXkYTCj50/05Wp5n4o8D
	 Fph0AvicY3lTqCMrsKI7NKkQUXV6XrGHgkTxtMsc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgD1XsV (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 28 Apr 2020 19:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgD1XsV (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 28 Apr 2020 19:48:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64670206A1;
        Tue, 28 Apr 2020 23:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588117700;
        bh=+CmCVpLvW0aUd8fDAt5wjRwWtdOsyPOjWET1BE5+qwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UzcQCfPAFOKA/6PEgdmeRdlHnfbDuQ8Pg5aOaX2wtD8BMZfq1z77KVDWKNNxJFDer
         rCo0AagQ44K0xdF95dCVNGEfQLHelohxHR9dLLr+iQTES4VJ3R1c8BIwXKc5kl/tx9
         FqHH8g1hluOISoSgRXzx1x4Lk+H3kLcerhgZnqv0=
Date:   Tue, 28 Apr 2020 16:48:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        andres@anarazel.de, willy@infradead.org, dhowells@redhat.com,
        hch@infradead.org, jack@suse.cz, david@fromorbit.com
Subject: Re: [PATCH v6 RESEND 0/2] vfs: have syncfs() return error when
 there are writeback errors
Message-Id: <20200428164819.7b58666b755d2156aa46c56c@linux-foundation.org>
In-Reply-To: <20200428135155.19223-1-jlayton@kernel.org>
References: <20200428135155.19223-1-jlayton@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, 28 Apr 2020 09:51:53 -0400 Jeff Layton <jlayton@kernel.org> wrote:

> Just a resend since this hasn't been picked up yet. No real changes
> from the last set (other than adding Jan's Reviewed-bys). Latest
> cover letter follows:

I see no cover letter here.

> 
> --------------------------8<----------------------------
> 
> v6:
> - use READ_ONCE to ensure that compiler doesn't optimize away local var
> 
> The only difference from v5 is the change to use READ_ONCE to fetch the
> bd_super pointer, to ensure that the compiler doesn't refetch it
> afterward. Many thanks to Jan K. for the explanation!
> 
> Jeff Layton (2):
>   vfs: track per-sb writeback errors and report them to syncfs
>   buffer: record blockdev write errors in super_block that it backs

http://lkml.kernel.org/r/20200207170423.377931-1-jlayton@kernel.org

has suitable-looking words, but is it up to date?

