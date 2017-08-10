From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Thu, 10 Aug 2017 19:01:44 +0200
Message-ID: <20170810170144.GA987@dhcp22.suse.cz>
References: <20170806140425.20937-1-riel@redhat.com>
 <20170807132257.GH32434@dhcp22.suse.cz>
 <20170807134648.GI32434@dhcp22.suse.cz>
 <1502117991.6577.13.camel@redhat.com>
 <20170810130531.GS23863@dhcp22.suse.cz>
 <CAAF6GDc2hsj-XJj=Rx2ZF6Sh3Ke6nKewABXfqQxQjfDd5QN7Ug@mail.gmail.com>
 <20170810153639.GB23863@dhcp22.suse.cz>
 <CAAF6GDeno6RpHf1KORVSxUL7M-CQfbWFFdyKK8LAWd_6PcJ55Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAF6GDeno6RpHf1KORVSxUL7M-CQfbWFFdyKK8LAWd_6PcJ55Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colm =?iso-8859-1?Q?MacC=E1rthaigh?= <colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org>
Cc: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 10-08-17 16:17:18, Colm MacCárthaigh wrote:
> On Déar 10 Lún 2017 at 17:36 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > On Thu 10-08-17 15:23:05, Colm MacCįrthaigh wrote:
> > > On Thu, Aug 10, 2017 at 3:05 PM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > >> Too late for that. VM_DONTFORK is already implemented
> > > >> through MADV_DONTFORK & MADV_DOFORK, in a way that is
> > > >> very similar to the MADV_WIPEONFORK from these patches.
> > > >
> > > > Yeah, those two seem to be breaking the "madvise as an advise"
> > semantic as
> > > > well but that doesn't mean we should follow that pattern any further.
> > >
> > > I would imagine that many of the crypto applications using
> > > MADV_WIPEONFORK will also be using MADV_DONTDUMP. In cases where it's
> > > for protecting secret keys, I'd like to use both in my code, for
> > > example. Though that doesn't really help decide this.
> > >
> > > There is also at least one case for being able to turn WIPEONFORK
> > > on/off with an existing page; a process that uses privilege separation
> > > often goes through the following flow:
> > >
> > > 1. [ Access privileged keys as a power user and initialize memory ]
> > > 2. [ Fork a child process that actually does the work ]
> > > 3. [ Child drops privileges and uses the memory to do work ]
> > > 4. [ Parent hangs around to re-spawn a child if it crashes ]
> > >
> > > In that mode it would be convenient to be able to mark the memory as
> > > WIPEONFORK in the child, but not the parent.
> >
> > I am not sure I understand. The child will have an own VMA so chaging
> > the attribute will not affect parent. Or did I misunderstand your
> > example?
> >
> 
> Typically with privilege separation the parent has to share some minimal
> state with the child. In this case that's why the page is left alone.
> Though a smart parent could unset and set just immediately around the fork.
> 
> The point then of protecting it in the child is to ensure that a grandchild
> doesn't inherit the secret data.

Does anybody actually do that using the minherit BSD interface?
-- 
Michal Hocko
SUSE Labs
