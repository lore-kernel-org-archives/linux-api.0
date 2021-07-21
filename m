Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC05C6377B
	for <linux-api@archiver.kernel.org>; Wed, 21 Jul 2021 22:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4033D6121F
	for <linux-api@archiver.kernel.org>; Wed, 21 Jul 2021 22:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhGUV2w (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 21 Jul 2021 17:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhGUV2w (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 21 Jul 2021 17:28:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1768560FD7;
        Wed, 21 Jul 2021 22:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626905368;
        bh=vXdm+vn+XFhJA3Kvx7SiR6QB9bWzL6cufqSZNd0/ZjI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CzFN5nvRhWnOXfFa5pKgVVGsOSxFkTBYZkbC8+GFmLi1HGIoXOYxLTcl0z+yBibG7
         guR6c260lMY+0YTCtGCn5RNmBDCVQl/XBtkgbYmTB4l8DnrXDgsCggDZifbf19Mtp/
         jF9KM70Xr74hrDPINGcTMCrBuSTZCsYTcMFg2eu8=
Date:   Wed, 21 Jul 2021 15:09:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Evan Green <evgreen@chromium.org>
Cc:     linux-api@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>, Pavel Machek <pavel@ucw.cz>,
        Alex Shi <alexs@kernel.org>,
        Alistair Popple <apopple@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Minchan Kim <minchan@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: Enable suspend-only swap spaces
Message-Id: <20210721150926.ce56fb8b5fa733d9727bd37e@linux-foundation.org>
In-Reply-To: <20210721143946.v3.1.I09866d90c6de14f21223a03e9e6a31f8a02ecbaf@changeid>
References: <20210721143946.v3.1.I09866d90c6de14f21223a03e9e6a31f8a02ecbaf@changeid>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, 21 Jul 2021 14:40:28 -0700 Evan Green <evgreen@chromium.org> wrote:

> Currently it's not possible to enable hibernation without also enabling
> generic swap for a given swap area. These two use cases are not the
> same. For example there may be users who want to enable hibernation,
> but whose drives don't have the write endurance for generic swap
> activities. Swap and hibernate also have different security/integrity
> requirements, prompting folks to possibly set up something like block-level
> integrity for swap and image-level integrity for hibernate. Keeping swap
> and hibernate separate in these cases becomes not just a matter of
> preference, but correctness.
> 
> Add a new SWAP_FLAG_NOSWAP that adds a swap region but refuses to allow
> generic swapping to it. This region can still be wired up for use in
> suspend-to-disk activities, but will never have regular pages swapped to
> it. This flag will be passed in by utilities like swapon(8), usage would
> probably look something like: swapon -o noswap /dev/sda2.

Will patches to swapon and its manpage be prepared?

> Swap regions with SWAP_FLAG_NOSWAP set will not appear in /proc/meminfo
> under SwapTotal and SwapFree, since they are not usable as general swap.
> 

