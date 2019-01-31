From: Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [PATCH 1/3] mm/mincore: make mincore() more conservative
Date: Thu, 31 Jan 2019 10:51:21 +0100
Message-ID: <20190131095121.GA26131@nautica>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz>
 <20190130124420.1834-2-vbabka@suse.cz>
 <20190131094357.GQ18811@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190131094357.GQ18811@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, Josh Snyder <joshs@netflix.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, Jiri Kosina <jikos@kernel.org>
List-Id: linux-api@vger.kernel.org

Michal Hocko wrote on Thu, Jan 31, 2019:
> > Change the semantics of mincore() so that it only reveals pagecache information
> > for non-anonymous mappings that belog to files that the calling process could
> > (if it tried to) successfully open for writing.
> 
> I agree that this is a better way than the original 574823bfab82
> ("Change mincore() to count "mapped" pages rather than "cached" pages").
> One thing is still not clear to me though. Is the new owner/writeable
> check OK for the Netflix-like usecases? I mean does happycache have
> appropriate access to the cache data? I have tried to re-read the
> original thread but couldn't find any confirmation.

It's enough for my use cases and Josh didn't seem to oppose, but since
he's not in Cc I don't think he would answer -- added him now :)

FWIW happycache writes in the current directory by default so I assume
in the way they use it it would usually have access one way or another.

> If this still doesn't help happycache kind of workloads then we should
> add a capability check IMO but this looks like a decent foundation to
> me.

the inode_owner_or_capable/inode_permission helpers already do allow
quite a few capabilities there


-- 
Dominique
