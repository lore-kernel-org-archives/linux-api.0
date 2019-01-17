From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Thu, 17 Jan 2019 22:45:25 +0100
Message-ID: <a056deb7-9c11-612e-2b3a-6482acca4ff6@suse.cz>
References: <20190110070355.GJ27534@dastard>
 <CAHk-=wigwXV_G-V1VxLs6BAvVkvW5=Oj+xrNHxE_7yxEVwoe3w@mail.gmail.com>
 <20190110122442.GA21216@nautica>
 <CAHk-=wip2CPrdOwgF0z4n2tsdW7uu+Egtcx9Mxxe3gPfPW_JmQ@mail.gmail.com>
 <5c3e7de6.1c69fb81.4aebb.3fec@mx.google.com>
 <CAHk-=wgF9p9xNzZei_-ejGLy1bJf4VS1C5E9_V0kCTEpCkpCTQ@mail.gmail.com>
 <9E337EA6-7CDA-457B-96C6-E91F83742587@amacapital.net>
 <CAHk-=wjqkbjL2_BwUYxJxJhdadiw6Zx-Yu_mK3E6P7kG3wSGcQ@mail.gmail.com>
 <20190116054613.GA11670@nautica>
 <CAHk-=wjVjecbGRcxZUSwoSgAq9ZbMxbA=MOiqDrPgx7_P3xGhg@mail.gmail.com>
 <20190116063430.GA22938@nautica>
 <CA+t-nXTfdo07EBvVo+mu8SRhrVyB=mEPLDQikHfpJue1jALJtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+t-nXTfdo07EBvVo+mu8SRhrVyB=mEPLDQikHfpJue1jALJtQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Snyder <joshs@netflix.com>, Dominique Martinet <asmadeus@codewreck.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Jiri Kosina <jikos@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 1/16/2019 8:52 AM, Josh Snyder wrote:
> On Tue, Jan 15, 2019 at 10:34 PM Dominique Martinet <asmadeus@codewreck.org>
> wrote:
>>
>> There is a difference with your previous patch though, that used to list no
>> page in core when it didn't know; this patch lists pages as in core when it
>> refuses to tell. I don't think that's very important, though.

I've argued previously that reporting false positives (as your patch does)
should be better, otherwise there might be somebody trying to fault in their
pages in a loop until mincore reports positive, which would become an endless
loop. So agreed with your change.

Or maybe we could resort to the 5.0-rc1 page table check (that is now being
reverted) but only in cases when we are not allowed the page cache residency
check? Or would that be needlessly complicated? And it would be able to leak if
a page was evicted from the page cache...

> Is there a reason not to return -EPERM in this case?

That would definitely break somebody.

>>
>> If anything, the 0400 user-owner file might be a problem in some edge
>> case (e.g. if you're preloading git directories, many objects are 0444);
>> should we *also* check ownership?...
> 
> Yes, this seems valuable. Some databases with immutable files (e.g. git, as
> you've mentioned) conceivably operate this way.
> 
> Josh
> 
