From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 3/3] mm/mincore: provide mapped status when cached status
 is not allowed
Date: Wed, 6 Feb 2019 21:14:26 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1902062111120.11598@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-4-vbabka@suse.cz> <20190131100907.GS18811@dhcp22.suse.cz> <99ee4d3e-aeb2-0104-22be-b028938e7f88@suse.cz> <20190201091152.GG11599@dhcp22.suse.cz>
 <e1478ab8-e009-9bdd-3866-f319bd7259a0@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e1478ab8-e009-9bdd-3866-f319bd7259a0@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, Josh Snyder <joshs@netflix.com>
List-Id: linux-api@vger.kernel.org

On Fri, 1 Feb 2019, Vlastimil Babka wrote:

> > Well, but rss update will not tell you that the page has been faulted in
> > which is the most interesting part.
> 
> Sure, but the patch doesn't add back that capability neither. It allows
> to recognize page being reclaimed, and I argue you can infer that from
> rss change as well. That change is mentioned in the last paragraph in
> changelog, and I thought "add a hard to evaluate side channel" in your
> reply referred to that. It doesn't add back the "original" side channel
> to detect somebody else accessed a page.

On Fri, 1 Feb 2019, Vlastimil Babka wrote:

> > Is this really worth it? Do we know about any specific usecase that
> > would benefit from this change? TBH I would rather wait for the report
> > than add a hard to evaluate side channel.
> 
> Well it's not that complicated IMHO. Linus said it's worth trying, so
> let's see how he likes the result. The side channel exists anyway as
> long as process can e.g. check if its rss shrinked, and I doubt we are
> going to remove that possibility.

Linus, do you have any opinion here?

I have a hunch that mm maintainers are keeping this on a backburner 
because there might still open question(s) in the air.

Thanks,

-- 
Jiri Kosina
SUSE Labs
