From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Wed, 16 Jan 2019 17:34:01 +1200
Message-ID: <CAHk-=wjqkbjL2_BwUYxJxJhdadiw6Zx-Yu_mK3E6P7kG3wSGcQ@mail.gmail.com>
References: <20190108044336.GB27534@dastard> <CAHk-=wjvzEFQcTGJFh9cyV_MPQftNrjOLon8YMMxaX0G1TLqkg@mail.gmail.com>
 <20190109022430.GE27534@dastard> <nycvar.YFH.7.76.1901090326460.16954@cbobk.fhfr.pm>
 <20190109043906.GF27534@dastard> <CAHk-=wic28fSkwmPbBHZcJ3BGbiftprNy861M53k+=OAB9n0=w@mail.gmail.com>
 <20190110004424.GH27534@dastard> <CAHk-=wg1jSQ-gq-M3+HeTBbDs1VCjyiwF4gqnnBhHeWizyrigg@mail.gmail.com>
 <20190110070355.GJ27534@dastard> <CAHk-=wigwXV_G-V1VxLs6BAvVkvW5=Oj+xrNHxE_7yxEVwoe3w@mail.gmail.com>
 <20190110122442.GA21216@nautica> <CAHk-=wip2CPrdOwgF0z4n2tsdW7uu+Egtcx9Mxxe3gPfPW_JmQ@mail.gmail.com>
 <5c3e7de6.1c69fb81.4aebb.3fec@mx.google.com> <CAHk-=wgF9p9xNzZei_-ejGLy1bJf4VS1C5E9_V0kCTEpCkpCTQ@mail.gmail.com>
 <9E337EA6-7CDA-457B-96C6-E91F83742587@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9E337EA6-7CDA-457B-96C6-E91F83742587@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Josh Snyder <joshs@netflix.com>, Dominique Martinet <asmadeus@codewreck.org>, Dave Chinner <david@fromorbit.com>, Jiri Kosina <jikos@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 16, 2019 at 5:25 PM Andy Lutomirski <luto@amacapital.net> wrote:
>
> Something like CAP_DAC_READ_SEARCH might not be crazy.

I agree that it would work. In fact' it's what Jiri's patch basically
did. Except Jiri used CAP_SYS_ADMIN instead.

But that then basically limits it to root (or root-like with
capability masks), which is quite likely to not work in practice all
that well. That's why I wanted to find alternatives.

*Very* few people want to run their databases as root.

Jiri's original patch kind of acknowledged that by making the new test
be conditional, and off by default. So then it's a "only do this for
lockdown mode, because normal people won't find it acceptable".

And I'm not a huge fan of that approach. If you don't protect normal
people, then what's the point, really?

              Linus
