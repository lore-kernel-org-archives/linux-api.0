Return-Path: <SRS0=+5Ll=4H=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B4FC34056
	for <linux-api@archiver.kernel.org>; Wed, 19 Feb 2020 20:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11BB824673
	for <linux-api@archiver.kernel.org>; Wed, 19 Feb 2020 20:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582142486;
	bh=+/l+ISz2zmfaggvLJhJywVyRv2xWn2G7HKyyyAOP1zk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=dl4o2aXB2m/R16/UxURYwsl0fBS376i5XmlTsfhpBrxetDL1u2WQgr8+7k1Crz3X/
	 s6SHxq2Ab3yvimgHxkQwFmVVeHr5+0CU81l1p7rplj9HSelE1xPI5qGUBiLWOuTsAM
	 UoQqg6U5Vnj4+BO85Alf9RGIkjQ2Wy39kN83laxs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgBSUBZ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 19 Feb 2020 15:01:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgBSUBZ (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 19 Feb 2020 15:01:25 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C3C22465D;
        Wed, 19 Feb 2020 20:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582142484;
        bh=+/l+ISz2zmfaggvLJhJywVyRv2xWn2G7HKyyyAOP1zk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ysUl2peu2TUtF2DeG5aaTwij408wk5ZqzOvM/nzBNQoGIjSTenXrYh35ZV85FWdNt
         +R/M+on8VzJe9wapKRHpCjBGvvCiTuZYjf3zwBukBopk4MqZPszAqx9qHt8XIfafup
         Wlp2YKQfFdz+Oi2Flp0YYH2B67nKage1rIlUy/cU=
Date:   Wed, 19 Feb 2020 12:01:23 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linux-api@vger.kernel.org, oleksandr@redhat.com,
        Suren Baghdasaryan <surenb@google.com>,
        Tim Murray <timmurray@google.com>,
        Daniel Colascione <dancol@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Sonny Rao <sonnyrao@google.com>,
        Brian Geffon <bgeffon@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        John Dias <joaodias@google.com>,
        Joel Fernandes <joel@joelfernandes.org>, sj38.park@gmail.com,
        alexander.h.duyck@linux.intel.com, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v6 0/7] introduce memory hinting API for external
 process
Message-Id: <20200219120123.07dda51c29006a892059ccde@linux-foundation.org>
In-Reply-To: <20200219014433.88424-1-minchan@kernel.org>
References: <20200219014433.88424-1-minchan@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, 18 Feb 2020 17:44:26 -0800 Minchan Kim <minchan@kernel.org> wrote:

> Now, we have MADV_PAGEOUT and MADV_COLD as madvise hinting API. With that,
> application could give hints to kernel what memory range are preferred to be
> reclaimed. However, in some platform(e.g., Android), the information
> required to make the hinting decision is not known to the app.
> Instead, it is known to a centralized userspace daemon(e.g., ActivityManagerService),
> and that daemon must be able to initiate reclaim on its own without any app
> involvement.
> 

This patchset doesn't seem to be getting a lot of interest from other
potential users?  It seems very specialized.  Are there or will there
ever be any users of this apart from one Android daemon?

Also, it doesn't terribly hard for ActivityManagerService to tell
another process "now run madvise with these arguments".  Please explain
why this is not practical in ActivityManagerService and also within
other potential users of this syscall.

