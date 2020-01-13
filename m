From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/4] mm: introduce external memory hinting API
Date: Mon, 13 Jan 2020 10:44:08 -0800
Message-ID: <20200113184408.GD110363@google.com>
References: <20200110213433.94739-1-minchan@kernel.org>
 <20200110213433.94739-3-minchan@kernel.org>
 <56ea0927-ad2e-3fbd-3366-3813330f6cec@virtuozzo.com>
 <20200113104256.5ujbplyec2sk4onn@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200113104256.5ujbplyec2sk4onn@wittgenstein>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Dias <joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 13, 2020 at 11:42:57AM +0100, Christian Brauner wrote:
> On Mon, Jan 13, 2020 at 11:47:11AM +0300, Kirill Tkhai wrote:

< snip >

> > > +SYSCALL_DEFINE5(process_madvise, int, pidfd, unsigned long, start,
> > > +		size_t, len_in, int, behavior, unsigned long, flags)
> > 
> > I don't like the interface. The fact we have pidfd does not mean,
> > we have to use it for new syscalls always. A user may want to set
> > madvise for specific pid from console and pass pid as argument.
> > pidfd would be an overkill in this case.
> > We usually call "kill -9 pid" from console. Why shouldn't process_madvise()
> > allow this?
> > 
> > I suggent to extend first argument to work with both pid and pidfd.
> > Look at what we have for waitid(idtype, id_t id, ...) for example:
> > 
> >        idtype == P_PID
> >               Wait for the child whose process ID matches id.
> > 
> >        idtype == P_PIDFD (since Linux 5.4)
> >               Wait for the child referred to by the PID file descriptor specified in id.  (See pidfd_open(2) for  further  information  on
> >               PID file descriptors.)
> > 
> > We may use @flags argument for this.
> 
> Sorry for chiming in just a comment. Overall, I don't particularly care
> how or if you integrate pidfd here. One thing I would like to point out
> is that we're working on a patch to place new features under pidfd
> specific flags. This e.g. means a pidfd would be only be able to be used
> for madvise operations (or getfd operations) if it was created with that
> specific flag set making it easier to share them with other processes.
> So if you integrate them here I would be quite thankful if you target
> the patchset for the v5.7 merge window, not for v5.6.

Hi Christian,
Sorry but I couldn't understand your point.
Could you clarify what you meant?

Thanks.
