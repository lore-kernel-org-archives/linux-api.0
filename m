From: Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Thu, 10 Jan 2019 13:24:42 +0100
Message-ID: <20190110122442.GA21216@nautica>
References: <20190108044336.GB27534@dastard>
 <CAHk-=wjvzEFQcTGJFh9cyV_MPQftNrjOLon8YMMxaX0G1TLqkg@mail.gmail.com>
 <20190109022430.GE27534@dastard>
 <nycvar.YFH.7.76.1901090326460.16954@cbobk.fhfr.pm>
 <20190109043906.GF27534@dastard>
 <CAHk-=wic28fSkwmPbBHZcJ3BGbiftprNy861M53k+=OAB9n0=w@mail.gmail.com>
 <20190110004424.GH27534@dastard>
 <CAHk-=wg1jSQ-gq-M3+HeTBbDs1VCjyiwF4gqnnBhHeWizyrigg@mail.gmail.com>
 <20190110070355.GJ27534@dastard>
 <CAHk-=wigwXV_G-V1VxLs6BAvVkvW5=Oj+xrNHxE_7yxEVwoe3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wigwXV_G-V1VxLs6BAvVkvW5=Oj+xrNHxE_7yxEVwoe3w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Jiri Kosina <jikos@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds wrote on Thu, Jan 10, 2019:
> (Except, of course, if somebody actually notices outside of tests.
> Which may well happen and just force us to revert that commit. But
> that's a separate issue entirely).

Both Dave and I pointed at a couple of utilities that break with
this. nocache can arguably work with the new behaviour but will behave
differently; vmtouch on the other hand is no longer able to display
what's in cache or not - people use that for example to "warm up" a
container in page cache based on how it appears after it had been
running for a while is a pretty valid usecase to me.

>From the list Kevin harvested out of the debian code search, the
postgresql use case is pretty similar - probe what pages of the database
were in cache at shutdown so when you restart it you can preload these
and reach "cruse speed" faster.

Sure that's probably not billions of users but this all looks fairly
valid to me...

-- 
Dominique
