From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT is
 set for the I/O
Date: Thu, 31 Jan 2019 23:21:53 -0800
Message-ID: <CAHk-=wibb_cXG2e81ZiapC-SJPDwG4kaQ16XgJ_1cb3jgF9X3Q@mail.gmail.com>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-3-vbabka@suse.cz>
 <20190131095644.GR18811@dhcp22.suse.cz> <nycvar.YFH.7.76.1901311114260.6626@cbobk.fhfr.pm>
 <20190131102348.GT18811@dhcp22.suse.cz> <CAHk-=wjkiNPWb97JXV6=J6DzscB1g7moGJ6G_nSe=AEbMugTNw@mail.gmail.com>
 <20190201051355.GV6173@dastard> <CAHk-=wg0FXvwB09WJaZk039CfQ0hEnyES_ANE392dfsx6U8WUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wg0FXvwB09WJaZk039CfQ0hEnyES_ANE392dfsx6U8WUQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@kernel.org>, Jiri Kosina <jikos@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 31, 2019 at 11:05 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And part of "best effort" is very much "not a security information leak".

Side note: it's entirely possible that the preadv2(RWF_NOWAIT)
interface is actually already effectively too slow to be effectively
used as much of an attack vector.

One of the advantages of mincore() for the attack was that you could
just get a lot of page status information in one go. With RWF_NOWAIT,
you only really get "up to the first non-cached page", so it's already
a weaker signal than mincore() gave.

System calls aren't horrendously slow (at least not with fixed
non-meltdown CPU's), but it might still be a somewhat noticeable
inconvenience in an attack that is already probably not all that easy
to do on an arbitrary target.

So it might not be a huge deal. But I think we should at least try to
make things less useful for these kinds of attack vectors.

And no, that doesn't mean "stop all theoretical attacks". It means
"let's try to make things less convenient as a data leak".

That's why things like "oh, you can still see the signal if you can
keep the backing device congested" is not something I'd worry about.
It's just another (big) inconvenience, and not all that simple to do.
At some point, it's simply not worth it as an attack vector any more.

               Linus
