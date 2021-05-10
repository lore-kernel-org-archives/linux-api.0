Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA47C433B4
	for <linux-api@archiver.kernel.org>; Mon, 10 May 2021 04:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 654AD613CD
	for <linux-api@archiver.kernel.org>; Mon, 10 May 2021 04:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhEJEWM (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 10 May 2021 00:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhEJEWL (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Mon, 10 May 2021 00:22:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6EA8613C0;
        Mon, 10 May 2021 04:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620620466;
        bh=Xm87W7GOJAQ6qAgNGiejOmK3PNImKl3B2EE3JRitsjw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U4QUz9B5tMeM4GCXhtq6MXD2U2fnFhv7juUfBCMb9bf9t3dT5NDu2diP4kHcggd0O
         K2LCo/XtfTueBotIk3WrbnYv+CDfGD9WTDuR56r181+qldhg+jiQPFYDICOwzpC4Gz
         gqtUI4xX2JMq8nWCjCQeqU9xFqyY+j11Ih/S/MpM=
Date:   Sun, 9 May 2021 21:21:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Chris Zankel <chris@zankel.net>,
        Dave Hansen <dave.hansen@intel.com>,
        Helge Deller <deller@gmx.de>, Hugh Dickins <hughd@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux API <linux-api@vger.kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Ram Pai <linuxram@us.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        Rik van Riel <riel@surriel.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2 0/5] mm/madvise: introduce MADV_POPULATE_(READ|WRITE)
 to prefault page tables
Message-Id: <20210509212105.d741b7026ca6dca86bdb56d2@linux-foundation.org>
In-Reply-To: <20210419135443.12822-1-david@redhat.com>
References: <20210419135443.12822-1-david@redhat.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, 19 Apr 2021 15:54:38 +0200 David Hildenbrand <david@redhat.com> wrote:

> Excessive details on MADV_POPULATE_(READ|WRITE) can be found in patch #2.

I grabbed the series, but some additional review would help things
along here..

Did patch #2 actually make it to linux-mm?  It's missing from my
archive. 
https://lkml.kernel.org/r/20210419135443.12822-3-david@redhat.com lands
on the linux-api@vger copy.
