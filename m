From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 1/3] procfs: fdinfo -- Extend information about epoll
 target files
Date: Wed, 22 Feb 2017 11:35:34 +0300
Message-ID: <20170222083534.GG22938@uranus>
References: <20170221171254.954209904@openvz.org>
 <CALCETrUJcMuLpcLf5iQurGCnA1hqVH5YtHAq+=f81PF1OZy1Fg@mail.gmail.com>
 <20170221191655.GC27653@uranus>
 <58AD4147.20801@virtuozzo.com>
 <20170222075438.GB22938@uranus>
 <58AD4733.5060304@virtuozzo.com>
 <20170222081833.GE22938@uranus>
 <58AD4BE3.2080803@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58AD4BE3.2080803-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kirill Kolyshkin <kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 22, 2017 at 11:29:23AM +0300, Pavel Emelyanov wrote:
> On 02/22/2017 11:18 AM, Cyrill Gorcunov wrote:
> > On Wed, Feb 22, 2017 at 11:09:23AM +0300, Pavel Emelyanov wrote:
> >>>>
> >>>> Actually it shouldn't. If you extend the kcmp argument to accept the
> >>>> epollfd:epollslot pair, this would be effectively the same as if you
> >>>> had all your epoll-ed files injected into your fdtable with "strange"
> >>>> fd numbers. We already have two-level rbtree for this in criu, adding
> >>>> extended ("strange") fd to it should be OK.
> >>>
> >>> Nope. Pavel, I guess you forget how we handle file tree in criu currently.
> >>> We call for kcmp only if we have to -- when primary key for two entries
> >>> is the same.
> >>
> >> True, but the latter is an optimization to reduce the number of syscalls.
> > 
> > Exactly. While syscalls are quite effective, they are still not coming
> > for free, so I'm trying to reduce their number as much as possible.
> > 
> >> Look, in order to have a primary key you need to do some system call for the
> >> fd you check (read from proc or stat the descriptor). But for target files in
> >> e-polls you don't make this per-fd syscall to get primary key, just call the
> >> kcmp instead.
> > 
> > I have to parse fdinfo anyway, because I need to fetch queued events and mask.
> > So I'll _have_ to make this per-fd syscall for parsing. And this opens
> > a way to optimize overall picture -- we can immediately read primary
> > key and reduce kcmp calls.
> 
> You read fdinfo per-epoll, but kcmp-s we're talking here are about per-target-files.
> So having dev:ino pair would help to reduce the number of kcmps, but even w/o
> this extension we can work OK.

I didn't say we can't. But since we're reading fdinfo anyway it will help I don't
see a single reason why should not we take this opportunity to speedup.

> Besides, in most of the cases fd number you'd read from epoll's fdinfo will actually
> be present in task's fdtable, so you can call a single kcmp, make sure the file is
> correct and that's it. The need to actually _search_ for the runaway file with the
> set of kcmp will (should) be quite rare case.

Yes. But this rare cases are the reason why I started this series :( I would
love to not add new code at all but simply had to.
