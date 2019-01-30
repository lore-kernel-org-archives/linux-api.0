From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Wed, 30 Jan 2019 10:09:45 +0100
Message-ID: <20190130090945.GS18811@dhcp22.suse.cz>
References: <nycvar.YFH.7.76.1901240009560.6626@cbobk.fhfr.pm>
 <CAHk-=wg+C65FJHB=Jx1OvuJP4kvpWdw+5G=XOXB6X_KB2XuofA@mail.gmail.com>
 <20190124002455.GA23181@nautica>
 <20190124124501.GA18012@nautica>
 <nycvar.YFH.7.76.1901241523500.6626@cbobk.fhfr.pm>
 <nycvar.YFH.7.76.1901272335040.6626@cbobk.fhfr.pm>
 <20190128000547.GA25155@nautica>
 <nycvar.YFH.7.76.1901300050550.6626@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1901300050550.6626@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Dominique Martinet <asmadeus@codewreck.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Josh Snyder <joshs@netflix.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed 30-01-19 00:52:02, Jiri Kosina wrote:
> On Mon, 28 Jan 2019, Dominique Martinet wrote:
> 
> > > So, any objections to aproaching it this way?
> > 
> > I'm not sure why I'm the main recipient of that mail but answering
> > because I am -- let's get these patches in through the regular -mm tree
> > though
> 
> *prod to mm maintainers* (at least for an opinion)

Could you repost those patches please? The thread is long and it is not
really clear what is the most up-to-date state of patches (at least to
me).
-- 
Michal Hocko
SUSE Labs
