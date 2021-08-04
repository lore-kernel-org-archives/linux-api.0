Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75EBC4338F
	for <linux-api@archiver.kernel.org>; Wed,  4 Aug 2021 06:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A40A7600EF
	for <linux-api@archiver.kernel.org>; Wed,  4 Aug 2021 06:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbhHDGVf (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 4 Aug 2021 02:21:35 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36882 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhHDGVf (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 4 Aug 2021 02:21:35 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id BA5C822139;
        Wed,  4 Aug 2021 06:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1628058081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J26bRC9AqL9yzAXTcNmpFXfcnAuaPb5GeWdDw/9Ibro=;
        b=PrH3TePlw7r5kZOL2S/iTUbxAUPK0XpagG2SryHdrg0f8+d1Srw0oXSrsPXXpXzrBiLWAr
        JC0zwPOk5NYaUwnBlfO7vYOiLjZPq45XJbCZrvj9Ck0uAyMA52dSopLxTZnlGrIZ2dsNS7
        qRsHFG/D6pACnxLt5b8rF7EiuBaZKlg=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id F2469A3B84;
        Wed,  4 Aug 2021 06:21:20 +0000 (UTC)
Date:   Wed, 4 Aug 2021 08:21:12 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>, Rik van Riel <riel@surriel.com>,
        Minchan Kim <minchan@kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Christoph Hellwig <hch@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jann Horn <jannh@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Florian Weimer <fweimer@redhat.com>,
        Jan Engelhardt <jengelh@inai.de>,
        Tim Murray <timmurray@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>
Subject: Re: [PATCH v4 1/2] mm: introduce process_mrelease system call
Message-ID: <YQox2Ems40WXmJ3z@dhcp22.suse.cz>
References: <20210802221431.2251210-1-surenb@google.com>
 <YQkAqwZIF+AnpexA@dhcp22.suse.cz>
 <CAJuCfpGiYAdvOydimHbK73oKS-ZfMMBtADXxWCYpxkX2qJX08g@mail.gmail.com>
 <CAJuCfpEjb+o_TuQqxYALcvpr+4kq7tVNjq7A3oahB=1=JPyWtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpEjb+o_TuQqxYALcvpr+4kq7tVNjq7A3oahB=1=JPyWtw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue 03-08-21 15:09:43, Suren Baghdasaryan wrote:
> On Tue, Aug 3, 2021 at 10:27 AM Suren Baghdasaryan <surenb@google.com> wrote:
[...]
> > > > +     if (task_will_free_mem(task) && (task->flags & PF_KTHREAD) == 0) {
> > > > +             mm = task->mm;
> > > > +             mmget(mm);
> > > > +     }
> > > > +     task_unlock(task);
> > > > +     if (!mm) {
> > >
> > > Do we want to treat MMF_OOM_SKIP as a failure?
> >
> > Yeah, I don't think we want to create additional contention if
> > oom-killer is already working on this mm. Should we return EBUSY in
> > this case? Other possible options is ESRCH, indicating that this
> > process is a goner, so don't bother. WDYT?
> 
> After considering this some more I think ESRCH would be more
> appropriate. EBUSY might be understood as "I need to retry at a better
> time", which is not what we want here.

Why cannot we simply return 0 in that case. The work has been done
already by the kernel so why should we tell the caller that there was
something wrong?

-- 
Michal Hocko
SUSE Labs
