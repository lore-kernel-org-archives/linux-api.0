Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858E7C433E0
	for <linux-api@archiver.kernel.org>; Wed, 23 Dec 2020 07:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EE4D207A2
	for <linux-api@archiver.kernel.org>; Wed, 23 Dec 2020 07:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgLWH55 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 23 Dec 2020 02:57:57 -0500
Received: from verein.lst.de ([213.95.11.211]:33687 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727372AbgLWH55 (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 23 Dec 2020 02:57:57 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0958467373; Wed, 23 Dec 2020 08:57:12 +0100 (CET)
Date:   Wed, 23 Dec 2020 08:57:12 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jann Horn <jannh@google.com>, Minchan Kim <minchan@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>, Rik van Riel <riel@surriel.com>,
        Christian Brauner <christian@brauner.io>,
        Oleg Nesterov <oleg@redhat.com>,
        Tim Murray <timmurray@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>
Subject: Re: [PATCH 1/2] mm/madvise: allow process_madvise operations on
 entire memory range
Message-ID: <20201223075712.GA4719@lst.de>
References: <20201124053943.1684874-1-surenb@google.com> <20201124053943.1684874-2-surenb@google.com> <20201125231322.GF1484898@google.com> <CAG48ez0UKYCdgyW91SmOcT52vbLFz9RjLpaucWpj6bTrgQCwnA@mail.gmail.com> <20201222134438.GA7170@infradead.org> <CAJuCfpGiVS69kznSrAdosxnRd-zgXPJd8MXou=gd8K8j7xLMjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpGiVS69kznSrAdosxnRd-zgXPJd8MXou=gd8K8j7xLMjA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Dec 22, 2020 at 09:48:43AM -0800, Suren Baghdasaryan wrote:
> Thanks for the feedback! The use case is userspace memory reaping
> similar to oom-reaper. Detailed justification is here:
> https://lore.kernel.org/linux-mm/20201124053943.1684874-1-surenb@google.com

Given that this new variant of process_madvise

  a) does not work on an address range
  b) is destructive
  c) doesn't share much code at all with the rest of process_madvise

Why not add a proper separate syscall?
