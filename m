From: Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Mon, 28 Jan 2019 01:05:48 +0100
Message-ID: <20190128000547.GA25155@nautica>
References: <nycvar.YFH.7.76.1901240009560.6626@cbobk.fhfr.pm>
 <CAHk-=wg+C65FJHB=Jx1OvuJP4kvpWdw+5G=XOXB6X_KB2XuofA@mail.gmail.com>
 <20190124002455.GA23181@nautica>
 <20190124124501.GA18012@nautica>
 <nycvar.YFH.7.76.1901241523500.6626@cbobk.fhfr.pm>
 <nycvar.YFH.7.76.1901272335040.6626@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1901272335040.6626@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Josh Snyder <joshs@netflix.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Jiri Kosina wrote on Sun, Jan 27, 2019:
> So, any objections to aproaching it this way?

I'm not sure why I'm the main recipient of that mail but answering
because I am -- let's get these patches in through the regular -mm tree
though

-- 
Dominique
