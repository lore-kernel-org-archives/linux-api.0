Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8195C4338F
	for <linux-api@archiver.kernel.org>; Tue,  3 Aug 2021 01:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A609D6101D
	for <linux-api@archiver.kernel.org>; Tue,  3 Aug 2021 01:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhHCBks (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 2 Aug 2021 21:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhHCBks (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 2 Aug 2021 21:40:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326F0C06175F;
        Mon,  2 Aug 2021 18:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VyFA1z5ngZ0mjADNv8+t6fHk/i7xgEzisFeVDdSHspo=; b=rz7Z7Ai+DJR4jVHuhbK7W5UQqk
        4uU26mPOXb3JxjtGC7q9KtfilWl4bAckJod73v+82rcyDeffua5z3/TXWNYET/rHHx/zDI9FQWIcJ
        YhRr1nh6ZKH8jHFAT34+YKd+ufT787Cjv0XzQPCrmlgD24BEbraiMF0Gbjb8uPTkvw5kDVfMPomwX
        cYnNVrIP8U0P7UMqQC45ydrL8KV30eKMH400ev4x0TzoJtvrB/k8qlZWlygTv5TvY+IEg9dI/PzyS
        uex1LisXBNRhzZSCPnqRG6HzaPMrry4QXM0dHWrtVzo3BE/Ptg+mm9UKDCeMYLWd6YarB1RPVItxE
        WRz32YLg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mAjOA-0045lA-3i; Tue, 03 Aug 2021 01:38:46 +0000
Date:   Tue, 3 Aug 2021 02:38:38 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Rik van Riel <riel@surriel.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Gladkov <legion@kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/16] tmpfs: fcntl(fd, F_MEM_LOCK) to memlock a tmpfs
 file
Message-ID: <YQieHio1oUKCfgqq@casper.infradead.org>
References: <2862852d-badd-7486-3a8e-c5ea9666d6fb@google.com>
 <54e03798-d836-ae64-f41-4a1d46bc115b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54e03798-d836-ae64-f41-4a1d46bc115b@google.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Jul 30, 2021 at 12:55:22AM -0700, Hugh Dickins wrote:
> A new uapi to lock the files on tmpfs in memory, to protect against swap
> without mapping the files. This commit introduces two new commands to
> fcntl and shmem: F_MEM_LOCK and F_MEM_UNLOCK. The locking will be
> charged against RLIMIT_MEMLOCK of uid in namespace of the caller.

It's not clear to me why this is limited to shmfs.  Would it not also
make sense for traditional filesystems, eg to force chrome's text pages
to stay in the page cache, no matter how much memory the tabs allocate?
