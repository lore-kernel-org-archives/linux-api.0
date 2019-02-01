From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT is
 set for the I/O
Date: Thu, 31 Jan 2019 23:05:32 -0800
Message-ID: <CAHk-=wg0FXvwB09WJaZk039CfQ0hEnyES_ANE392dfsx6U8WUQ@mail.gmail.com>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-3-vbabka@suse.cz>
 <20190131095644.GR18811@dhcp22.suse.cz> <nycvar.YFH.7.76.1901311114260.6626@cbobk.fhfr.pm>
 <20190131102348.GT18811@dhcp22.suse.cz> <CAHk-=wjkiNPWb97JXV6=J6DzscB1g7moGJ6G_nSe=AEbMugTNw@mail.gmail.com>
 <20190201051355.GV6173@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201051355.GV6173@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@kernel.org>, Jiri Kosina <jikos@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 31, 2019 at 9:16 PM Dave Chinner <david@fromorbit.com> wrote:
>
> You are conflating "best effort non-blocking operation" with
> "atomic guarantee".  RWF_NOWAIT/IOCB_NOWAIT is the
> former, not the latter.

Right.

That's my *point*, Dave.

It's not 'atomic guarantee", and never will be. We are in 100%
agreement. That's what I _said_.

And part of "best effort" is very much "not a security information leak".

I really don't see why you are so argumentative.

As I mentioned earlier in the thread, it's actually quite possible
that users will actually find that starting read-ahead is a *good*
thing, Dave.

Even - in fact *particularly* - the user you brought up: samba using
RWF_NOWAIT to try to do things synchronously quickly.

So Dave, why are you being so negative?

             Linus
