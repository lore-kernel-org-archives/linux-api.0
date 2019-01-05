From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Sat, 5 Jan 2019 21:12:22 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1901052108390.16954@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <CAHk-=wicks2BEwm1BhdvEj_P3yawmvQuG3NOnjhdrUDEtTGizw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wicks2BEwm1BhdvEj_P3yawmvQuG3NOnjhdrUDEtTGizw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, 5 Jan 2019, Linus Torvalds wrote:

> > There are possibilities [1] how mincore() could be used as a converyor of
> > a sidechannel information about pagecache metadata.
> 
> Can we please just limit it to vma's that are either anonymous, or map
> a file that the user actually owns?
> 
> Then the capability check could be for "override the file owner check"
> instead, which makes tons of sense.

Makes sense. 

I am still not completely sure what to return in such cases though; we can 
either blatantly lie and always pretend that the pages are resident (to 
avoid calling process entering some prefaulting mode), or return -ENOMEM 
for mappings of files that don't belong to the user (in case it's not 
CAP_SYS_ADMIN one).

-- 
Jiri Kosina
SUSE Labs
