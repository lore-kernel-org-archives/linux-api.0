From: Kevin Easton <kevin@guarana.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Wed, 16 Jan 2019 12:18:11 +0000
Message-ID: <20190116121811.GA6971@ip-172-31-15-78>
References: <20190110122442.GA21216@nautica>
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
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+t-nXTfdo07EBvVo+mu8SRhrVyB=mEPLDQikHfpJue1jALJtQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Snyder <joshs@netflix.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Jiri Kosina <jikos@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 15, 2019 at 11:52:25PM -0800, Josh Snyder wrote:
> On Tue, Jan 15, 2019 at 10:34 PM Dominique Martinet <asmadeus@codewreck.org>
> wrote:
> >
> > There is a difference with your previous patch though, that used to list no
> > page in core when it didn't know; this patch lists pages as in core when it
> > refuses to tell. I don't think that's very important, though.
> 
> Is there a reason not to return -EPERM in this case?

When I was looking through the Debian Code Search results, quite a few
of the hits were for code that uses mincore() as a way to check if
_anything_ is mapped at an address or not.  This code doesn't care about
the in core / not in core result of mincore(), just whether it returned
an error or not.

I think a new error return would break most of the instances of that
code I saw.

    - Kevin
