From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC v2] Add /proc/pid/smaps_rollup
Date: Mon, 28 Aug 2017 13:30:23 +0200
Message-ID: <20170828113023.GH17097@dhcp22.suse.cz>
References: <20170808132554.141143-1-dancol@google.com>
 <20170810001557.147285-1-dancol@google.com>
 <20170810043831.GB2249@bbox>
 <20170810084617.GI23863@dhcp22.suse.cz>
 <r0251soju3fo.fsf@dancol.org>
 <20170810105852.GM23863@dhcp22.suse.cz>
 <CAPz6YkUNu1uH057ENuH+Umq5J=J24my0p91mvYMtEb4Vy6Dhqg@mail.gmail.com>
 <CAEe=SxkgPUEkHdQm+M49EBc_Y_bEnNbe5fed3yALUx2eUbMrGQ@mail.gmail.com>
 <20170824085553.GB5943@dhcp22.suse.cz>
 <20170825141637.f11a36a9997b4b705d5b6481@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170825141637.f11a36a9997b4b705d5b6481-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joel Fernandes <joelaf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Luigi Semenzato <semenzato-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri 25-08-17 14:16:37, Andrew Morton wrote:
> On Thu, 24 Aug 2017 10:55:53 +0200 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > > If we assume that the number of VMAs is going to increase over time,
> > > then doing anything we can do to reduce the overhead of each VMA
> > > during PSS collection seems like the right way to go, and that means
> > > outputting an aggregate statistic (to avoid whatever overhead there is
> > > per line in writing smaps and in reading each line from userspace).
> > > 
> > > Also, Dan sent me some numbers from his benchmark measuring PSS on
> > > system_server (the big Android process) using smaps vs smaps_rollup:
> > > 
> > > using smaps:
> > > iterations:1000 pid:1163 pss:220023808
> > >  0m29.46s real 0m08.28s user 0m20.98s system
> > > 
> > > using smaps_rollup:
> > > iterations:1000 pid:1163 pss:220702720
> > >  0m04.39s real 0m00.03s user 0m04.31s system
> > 
> > I would assume we would do all we can to reduce this kernel->user
> > overhead first before considering a new user visible file. I haven't
> > seen any attempts except from the low hanging fruid I have tried.
> 
> It's hard to believe that we'll get anything like a 5x speedup via
> optimization of the existing code?

Maybe we will not get that much of a boost but having misleading numbers
really quick is not something we should aim for. Just try to think what
the cumulative numbers actually mean. How can you even consider
cumulative PSS when you have no idea about mappings that were
considered?

-- 
Michal Hocko
SUSE Labs
