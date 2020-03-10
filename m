Return-Path: <SRS0=yzTb=43=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6540CC10DCE
	for <linux-api@archiver.kernel.org>; Tue, 10 Mar 2020 22:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27D012071B
	for <linux-api@archiver.kernel.org>; Tue, 10 Mar 2020 22:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583879053;
	bh=iccim/BkgKBZPpO3db15oYp/nGuyqgqOuvUnq2bkmEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DzeDmU05/X99PN1GYDUDGjBuB7EsqRb3syo9bbeaNcPKnugla6Si6YeSdanhZWciW
	 2nJdWBzDHJDOFy5m5HanqxzfTzuLth+sDXh1E+e6d//kQ/BWLfViiSQywo1HGbf09S
	 Yf5z7BJyywvLdv1O2PsrX2l9M2w1a260pyjNNWaA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgCJWYM (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 10 Mar 2020 18:24:12 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41068 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgCJWYM (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 10 Mar 2020 18:24:12 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so89181plr.8;
        Tue, 10 Mar 2020 15:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VHQdCYc7HG4lQiYGqYUT5UP51+C0gUPiE/s2rIkKRtU=;
        b=KkWPHp8FUpWnyRN0umq7ZqUU6jx3hk5cpOiUL4uPzrawKLv6TEL2yRPitkww/xZ7ya
         XOqwqFZQsUEJKkK9U20KiQTHiu14dxVnrL5+EOQzVZSz7hs4StJIAXm3kZxcD9RmNGNM
         emB5EPlE9QfM63BvIiGnpUSAhQrvLunoPAx/lobQa872nLgOuNWUbPUy+Q5Jjhwr/p5n
         D/xRRguId/b38RtD6CE8iZYcd4wFGQHNxmkw98D+feGYjCGUmbc1CZf558wu+g47zvNu
         NfS+KuzM9qvdrLwUlx4Vu+cZ9QOUraHCYo+HIc/IDhoNFUxm2SmtLEbSOIvA5KAuaFR/
         fPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=VHQdCYc7HG4lQiYGqYUT5UP51+C0gUPiE/s2rIkKRtU=;
        b=rwdOuIxuxPQbCRUre7Qm9GCkAlKPVl/ogjRPU0EeOh0idB8C6x6J6rZZaznijHWvU5
         7d4o5/ks17ws98hjEs8ZCXCafU68G6N9jm3eB4PYIpgZl9X4fvaqDRz4dJVArvcmf/rh
         8uBbYdWXtKFOjDuOJgJy5wOouW5UxrspldTKKj3yB0B9D/7cDeHX0G3FTC+R+mXGoMqM
         rhnOldC9e4RopfErI6ZZwDCPEWU6ffU/zHGIq8q4AshokearX9AJhH9qa8G2O3VTb7qp
         x0O8vl15AaEa1KbpjoxlTMiexjHbiqbUdvI+H0ThrJ5ijGyqMnPIKKMXwd4BkD9kczBq
         UWmg==
X-Gm-Message-State: ANhLgQ1RfoYukXk9TfxVou9d9P40CT6vxxunOJgrM0yG7oAzfNszv0b5
        dqcpplyAsxQPfvpQ+Zb5lvc=
X-Google-Smtp-Source: ADFU+vscvd0WY2fsGo8nNRttNgBNSpAdv2WUgdhACEYKmMYI3pA4z6251Yz9qfEoSYIvhhu71/jlYg==
X-Received: by 2002:a17:90a:2ec7:: with SMTP id h7mr138998pjs.107.1583879051429;
        Tue, 10 Mar 2020 15:24:11 -0700 (PDT)
Received: from google.com ([2620:15c:211:1:3e01:2939:5992:52da])
        by smtp.gmail.com with ESMTPSA id 139sm25480434pfy.70.2020.03.10.15.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 15:24:10 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:24:08 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org,
        oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>,
        Tim Murray <timmurray@google.com>,
        Daniel Colascione <dancol@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Sonny Rao <sonnyrao@google.com>,
        Brian Geffon <bgeffon@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        John Dias <joaodias@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Jann Horn <jannh@google.com>,
        alexander.h.duyck@linux.intel.com, sj38.park@gmail.com
Subject: Re: [PATCH v7 3/7] mm: check fatal signal pending of target process
Message-ID: <20200310222408.GC72963@google.com>
References: <20200302193630.68771-1-minchan@kernel.org>
 <20200302193630.68771-4-minchan@kernel.org>
 <2f3a9530-483d-0861-3844-bc12d212dd93@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f3a9530-483d-0861-3844-bc12d212dd93@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Mar 06, 2020 at 11:22:07AM +0100, Vlastimil Babka wrote:
> On 3/2/20 8:36 PM, Minchan Kim wrote:
> > Bail out to prevent unnecessary CPU overhead if target process has
> > pending fatal signal during (MADV_COLD|MADV_PAGEOUT) operation.
> > 
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Nit below:
> 
> > ---
> >  mm/madvise.c | 29 +++++++++++++++++++++--------
> >  1 file changed, 21 insertions(+), 8 deletions(-)
> > 
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 349473fc6683..6543f2bfc3d8 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -36,6 +36,7 @@
> >  struct madvise_walk_private {
> >  	struct mmu_gather *tlb;
> >  	bool pageout;
> > +	struct task_struct *target_task;
> >  };
> >  
> >  /*
> > @@ -316,6 +317,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> >  	if (fatal_signal_pending(current))
> >  		return -EINTR;
> >  
> > +	if (private->target_task &&
> > +			fatal_signal_pending(private->target_task))
> > +		return -EINTR;
> 
> With madvise(2) private->target_task will be current, thus current will be
> tested twice. Not wrong, but maybe add a "private->target_task != current"
> condition?

It was in old series but removed because reviewer(IIRC, suren) wanted it.
I am not strong preference either way. Since you said it's nit and
considering other reviewer wanted to remove it, I will not change
further.

Thanks!
