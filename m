Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED819C11F64
	for <linux-api@archiver.kernel.org>; Mon, 28 Jun 2021 19:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D249861361
	for <linux-api@archiver.kernel.org>; Mon, 28 Jun 2021 19:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbhF1Tia (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 28 Jun 2021 15:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbhF1Ti3 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 28 Jun 2021 15:38:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE24C061574;
        Mon, 28 Jun 2021 12:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gFOuyW3wyuM/PP9zDs6kHOxY1vtd3EJQ4+qFhD6k1H8=; b=raSjpWt4jQDzFP75XKdDSen7eF
        SQMJWt/dhtS5EpCidxC94OF31jwKvNi3kmOoRCJH6GOx5QOix6lNKN0LWYYXjMuq1dx8uga9FDp+C
        IPiEvu3afbmclCCZTx4TcC4f+BG3R2bWtn1JgmPIJbST1JCP4w2gD1m/xrA/jaZNHGYyKkQSfkJl7
        roXWdTUJCoo6rFs6vs94BdzQUngDDg1G1tDbfJ9xB7YJvfGHvXVkj7Y2s22ap/v5WJzd3HYv3QH7+
        5kPldy7NmRHqXIt5BqCqoys+qAqBk+LiZGCSJkRPqvvyPHRrPSI53ziY85xEJAf+gI3F9HgGxny4f
        2BgZE/dQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lxx0h-003NPt-84; Mon, 28 Jun 2021 19:33:43 +0000
Date:   Mon, 28 Jun 2021 20:33:35 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Jann Horn <jannh@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mm@kvack.org, kernel test robot <lkp@intel.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4] mm: introduce reference pages
Message-ID: <YNokDwjyysHGwTy/@casper.infradead.org>
References: <20210619092002.1791322-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210619092002.1791322-1-pcc@google.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Sat, Jun 19, 2021 at 02:20:02AM -0700, Peter Collingbourne wrote:
> +void prep_refpage_private_data(struct refpage_private_data *priv)
> +{
> +	u8 *addr = page_address(priv->refpage);
> +	u8 pattern = addr[0];
> +	int i;
> +
> +	for (i = 1; i != PAGE_SIZE; ++i)
> +		if (addr[i] != pattern)
> +			return;
> +
> +	priv->optzn_kind = REFPAGE_OPTZN_PATTERN;
> +	priv->optzn_info = pattern;
> +}
> +
> +void copy_refpage(struct page *page, unsigned long addr,
> +		  struct vm_area_struct *vma)
> +{
> +	struct refpage_private_data *priv = vma->vm_private_data;
> +
> +	if (priv->optzn_kind == REFPAGE_OPTZN_PATTERN)
> +		memset(page_address(page), priv->optzn_info, PAGE_SIZE);
> +	else
> +		copy_user_highpage(page, priv->refpage, addr, vma);
> +}

I wonder if single-byte captures enough of the useful possibilities.
In the kernel we have memset32() and memset64() [1] so we could support
a larger pattern than just an 8-bit byte.  It all depends what userspace
would find useful.

[1] Along with memset_p(), memset_l() and memset16() that aren't terribly
relevant to this use case.  Although maybe memset_l() would be the right
one to use since there probably aren't too many 32-bit apps that want
a 64-bit pattern and memset64() might not be the fastest on a 32-bit
kernel).
