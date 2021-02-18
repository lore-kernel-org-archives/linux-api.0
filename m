Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0CFC433E0
	for <linux-api@archiver.kernel.org>; Thu, 18 Feb 2021 16:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19DD264DFF
	for <linux-api@archiver.kernel.org>; Thu, 18 Feb 2021 16:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhBRQfU (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:35:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:37656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231380AbhBRNpC (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 18 Feb 2021 08:45:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AD3F3AF31;
        Thu, 18 Feb 2021 13:43:57 +0000 (UTC)
To:     Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>
Cc:     Alex Shi <alex.shi@linux.alibaba.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Song Liu <songliubraving@fb.com>,
        Matthew Wilcox <willy@infradead.org>,
        Minchan Kim <minchan@kernel.org>,
        Chris Kennelly <ckennelly@google.com>, linux-mm@kvack.org,
        linux-api@vger.kernel.org, David Hildenbrand <david@redhat.com>
References: <d098c392-273a-36a4-1a29-59731cdf5d3d@google.com>
 <YCzSDPbBsksCX5zP@dhcp22.suse.cz>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC] Hugepage collapse in process context
Message-ID: <0b51a213-650e-7801-b6ed-9545466c15db@suse.cz>
Date:   Thu, 18 Feb 2021 14:43:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YCzSDPbBsksCX5zP@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On 2/17/21 9:21 AM, Michal Hocko wrote:
> [Cc linux-api]
> 
> On Tue 16-02-21 20:24:16, David Rientjes wrote:
>> Hi everybody,
>> 
>> Khugepaged is slow by default, it scans at most 4096 pages every 10s.  
>> That's normally fine as a system-wide setting, but some applications would 
>> benefit from a more aggressive approach (as long as they are willing to 
>> pay for it).
>> 
>> Instead of adding priorities for eligible ranges of memory to khugepaged, 
>> temporarily speeding khugepaged up for the whole system, or sharding its 
>> work for memory belonging to a certain process, one approach would be to 
>> allow userspace to induce hugepage collapse.
>> 
>> The benefit to this approach would be that this is done in process context 
>> so its cpu is charged to the process that is inducing the collapse.  
>> Khugepaged is not involved.
> 
> Yes, this makes a lot of sense to me.
> 
>> Idea was to allow userspace to induce hugepage collapse through the new 
>> process_madvise() call.  This allows us to collapse hugepages on behalf of 
>> current or another process for a vectored set of ranges.
> 
> Yes, madvise sounds like a good fit for the purpose.

Agreed on both points.

>> This could be done through a new process_madvise() mode *or* it could be a 
>> flag to MADV_HUGEPAGE since process_madvise() allows for a flag parameter 
>> to be passed.  For example, MADV_F_SYNC.
> 
> Would this MADV_F_SYNC be applicable to other madvise modes? Most
> existing madvise modes do not seem to make much sense. We can argue that
> MADV_PAGEOUT would guarantee the range was indeed reclaimed but I am not
> sure we want to provide such a strong semantic because it can limit
> future reclaim optimizations.
> 
> To me MADV_HUGEPAGE_COLLAPSE sounds like the easiest way forward.

I guess in the old madvise(2) we could create a new combo of MADV_HUGEPAGE |
MADV_WILLNEED with this semantic? But you are probably more interested in
process_madvise() anyway. There the new flag would make more sense. But there's
also David H.'s proposal for MADV_POPULATE and there might be benefit in
considering both at the same time? Should e.g. MADV_POPULATE with MADV_HUGEPAGE
have the collapse semantics? But would MADV_POPULATE be added to
process_madvise() as well? Just thinking out loud so we don't end up with more
flags than necessary, it's already confusing enough as it is.
