Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB65C6377B
	for <linux-api@archiver.kernel.org>; Wed, 21 Jul 2021 20:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBEB961244
	for <linux-api@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhGUUKW (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 21 Jul 2021 16:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhGUUKW (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 21 Jul 2021 16:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F76460FEA;
        Wed, 21 Jul 2021 20:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626900658;
        bh=iPgc6ODsz4TxG0bpAFE63PzUmM0U3DXOBMd9a7IulMc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tuC7TNZ5RmKRaB07c88XWWZDEI4hetYXiE0Qb7/LwJPcIZEQjmJpI1w/Y8kgHJjNi
         5wYMrf3nlLL4i22bJZXRHDfgvSGWmqflPgI7CFVY+fkPKsGB+P8IMp3/oSU1Qt2pP1
         SqaL65gU1IP7oBK0HyD9zjPysNWnP/OqPWo9pZ+A=
Date:   Wed, 21 Jul 2021 13:50:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>, Rik van Riel <riel@surriel.com>,
        Minchan Kim <minchan@kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Christoph Hellwig <hch@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>,
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
Subject: Re: [PATCH v2 1/3] mm, oom: move task_will_free_mem up in the file
 to be used in process_mrelease
Message-Id: <20210721135056.84d12dd49c07adff7b0beffb@linux-foundation.org>
In-Reply-To: <CAJuCfpHtRzCNH6Cspu8ngjw+WLvZTMsVbmBu_F-z8YY_n=RbvA@mail.gmail.com>
References: <20210718214134.2619099-1-surenb@google.com>
        <7eb17da6-03a6-5eaf-16e6-97b53ba163d8@redhat.com>
        <20210720160707.2332738708948f7d865d67c1@linux-foundation.org>
        <ba763ed3-9ad1-9502-1ffc-3175446570d1@redhat.com>
        <CAJuCfpEB994Xj3FcmzyH1p3yOdLVf6EwZaGaRj7NJi_c9hbsRQ@mail.gmail.com>
        <0ee6775b-589c-3243-1c01-aafad5eecb73@redhat.com>
        <CAJuCfpHtRzCNH6Cspu8ngjw+WLvZTMsVbmBu_F-z8YY_n=RbvA@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, 21 Jul 2021 13:19:35 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> > > This would not require moving other functions.
> > > Would that be better than the current approach or the forward declaration?
> >
> > IMHO that could be an easy, possible alternative.
> 
> Andrew, others? Should I follow this path instead?

Whatever you prefer ;)
