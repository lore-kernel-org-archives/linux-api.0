From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Thu, 17 Jan 2019 09:18:41 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1901170917490.6626@cbobk.fhfr.pm>
References: <CAHk-=wg1A44Roa8C4dmfdXLRLmNysEW36=3R7f+tzZzbcJ2d2g@mail.gmail.com> <CAHk-=wiqbKEC5jUXr3ax+oUuiRrp=QMv_ZnUfO-SPv=UNJ-OTw@mail.gmail.com> <20190108044336.GB27534@dastard> <CAHk-=wjvzEFQcTGJFh9cyV_MPQftNrjOLon8YMMxaX0G1TLqkg@mail.gmail.com>
 <20190109022430.GE27534@dastard> <nycvar.YFH.7.76.1901090326460.16954@cbobk.fhfr.pm> <20190109043906.GF27534@dastard> <CAHk-=wic28fSkwmPbBHZcJ3BGbiftprNy861M53k+=OAB9n0=w@mail.gmail.com> <20190110004424.GH27534@dastard> <nycvar.YFH.7.76.1901110836110.6626@cbobk.fhfr.pm>
 <20190117022244.GV4205@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190117022244.GV4205@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 17 Jan 2019, Dave Chinner wrote:

> > > commit e837eac23662afae603aaaef7c94bc839c1b8f67
> > > Author: Steve Lord <lord@sgi.com>
> > > Date:   Mon Mar 5 16:47:52 2001 +0000
> > > 
> > >     Add bounds checking for direct I/O, do the cache invalidation for
> > >     data coherency on direct I/O.
> > 
> > Out of curiosity, which repository is this from please? Even google 
> > doesn't seem to know about this SHA.
> 
> because oss.sgi.com is no longer with us, it's fallen out of all the
> search engines.  It was from the "archive/xfs-import.git" tree on
> oss.sgi.com:
> 
> https://web.archive.org/web/20120326044237/http://oss.sgi.com:80/cgi-bin/gitweb.cgi
> 
> but archive.org doesn't have a copy of the git tree. It contained
> the XFS history right back to the first Irix commit in 1993. Some of
> us still have copies of it sitting around....

For cases like this, would it be worth pushing it to git.kernel.org as an 
frozen historical reference archive?

Thanks,

-- 
Jiri Kosina
SUSE Labs
