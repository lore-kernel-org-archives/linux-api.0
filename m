From: Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [PATCH 0/3] mincore() and IOCB_NOWAIT adjustments
Date: Thu, 7 Mar 2019 00:32:09 +0100
Message-ID: <20190306233209.GA7753@nautica>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz>
 <nycvar.YFH.7.76.1903061310170.19912@cbobk.fhfr.pm>
 <20190306143547.c686225447822beaf3b6e139@linux-foundation.org>
 <nycvar.YFH.7.76.1903062342020.19912@cbobk.fhfr.pm>
 <20190306152337.e06cbc530fbfbcfcfe0dc37c@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190306152337.e06cbc530fbfbcfcfe0dc37c@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <jikos@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@amacapital.net>, Cyril Hrubis <chrubis@suse.cz>, Daniel Gruss <daniel@gruss.cc>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

Andrew Morton wrote on Wed, Mar 06, 2019:
> On Wed, 6 Mar 2019 23:48:03 +0100 (CET) Jiri Kosina <jikos@kernel.org> wrote:
> 
> > 3/3 is actually waiting for your decision, see
> > 
> > 	https://lore.kernel.org/lkml/20190212063643.GL15609@dhcp22.suse.cz/
> 
> I pity anyone who tried to understand this code by reading this code. 
> Can we please get some careful commentary in there explaining what is
> going on, and why things are thus?
> 
> I guess the [3/3] change makes sense, although it's unclear whether
> anyone really needs it?  5.0 was released with 574823bfab8 ("Change
> mincore() to count "mapped" pages rather than "cached" pages") so we'll
> have a release cycle to somewhat determine how much impact 574823bfab8
> has on users.  How about I queue up [3/3] and we reevaluate its
> desirability in a couple of months?

FWIW,

574823bfab8 has been reverted in 30bac164aca750, included in 5.0-rc4, so
the controversial change has only been there from 5.0-rc1 to 5.0-rc3

-- 
Dominique
