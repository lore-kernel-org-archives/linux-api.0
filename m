From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 3/3] mm/mincore: provide mapped status when cached status
 is not allowed
Date: Fri, 1 Feb 2019 10:27:38 +0100
Message-ID: <e1478ab8-e009-9bdd-3866-f319bd7259a0@suse.cz>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-4-vbabka@suse.cz>
 <20190131100907.GS18811@dhcp22.suse.cz>
 <99ee4d3e-aeb2-0104-22be-b028938e7f88@suse.cz>
 <20190201091152.GG11599@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201091152.GG11599@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Jiri Kosina <jikos@kernel.org>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, Jiri Kosina <jkosina@suse.cz>, Josh Snyder <joshs@netflix.com>
List-Id: linux-api@vger.kernel.org

On 2/1/19 10:11 AM, Michal Hocko wrote:
> On Fri 01-02-19 10:04:23, Vlastimil Babka wrote:
>> The side channel exists anyway as long as process can e.g. check if
>> its rss shrinked, and I doubt we are going to remove that possibility.
> 
> Well, but rss update will not tell you that the page has been faulted in
> which is the most interesting part.

Sure, but the patch doesn't add back that capability neither. It allows
to recognize page being reclaimed, and I argue you can infer that from
rss change as well. That change is mentioned in the last paragraph in
changelog, and I thought "add a hard to evaluate side channel" in your
reply referred to that. It doesn't add back the "original" side channel
to detect somebody else accessed a page.

> You shouldn't be able to sniff on
> /proc/$vicimt/smaps as an attacker.
