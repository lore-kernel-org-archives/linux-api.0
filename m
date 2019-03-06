From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] mincore() and IOCB_NOWAIT adjustments
Date: Wed, 6 Mar 2019 14:35:47 -0800
Message-ID: <20190306143547.c686225447822beaf3b6e139@linux-foundation.org>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
        <20190130124420.1834-1-vbabka@suse.cz>
        <nycvar.YFH.7.76.1903061310170.19912@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <nycvar.YFH.7.76.1903061310170.19912@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@amacapital.net>, Cyril Hrubis <chrubis@suse.cz>, Daniel Gruss <daniel@gruss.cc>, Dave Chinner <david@fromorbit.com>, Dominique Martinet <asmadeus@codewreck.org>, Kevin Easton <kevin@guarana.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 6 Mar 2019 13:11:39 +0100 (CET) Jiri Kosina <jikos@kernel.org> wrote:

> On Wed, 30 Jan 2019, Vlastimil Babka wrote:
> 
> > I've collected the patches from the discussion for formal posting. The first
> > two should be settled already, third one is the possible improvement I've
> > mentioned earlier, where only in restricted case we resort to existence of page
> > table mapping (the original and later reverted approach from Linus) instead of
> > faking the result completely. Review and testing welcome.
> > 
> > The consensus seems to be going through -mm tree for 5.1, unless Linus wants
> > them alredy for 5.0.
> > 
> > Jiri Kosina (2):
> >   mm/mincore: make mincore() more conservative
> >   mm/filemap: initiate readahead even if IOCB_NOWAIT is set for the I/O
> > 
> > Vlastimil Babka (1):
> >   mm/mincore: provide mapped status when cached status is not allowed
> 
> Andrew,
> 
> could you please take at least the correct and straightforward fix for 
> mincore() before we figure out how to deal with the slightly less 
> practical RWF_NOWAIT? Thanks.

I assume we're talking about [1/3] and [2/3] from this thread?

Can we have a resend please?  Gather the various acks and revisions,
make changelog changes to address the review questions and comments?

Thanks.
