From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 2/4] mm: introduce external memory hinting API
Date: Mon, 13 Jan 2020 20:10:47 +0100
Message-ID: <20200113191046.2tidyvc544zvchek@wittgenstein>
References: <20200110213433.94739-1-minchan@kernel.org>
 <20200110213433.94739-3-minchan@kernel.org>
 <56ea0927-ad2e-3fbd-3366-3813330f6cec@virtuozzo.com>
 <20200113104256.5ujbplyec2sk4onn@wittgenstein>
 <20200113184408.GD110363@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20200113184408.GD110363@google.com>
Sender: owner-linux-mm@kvack.org
To: Minchan Kim <minchan@kernel.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Daniel Colascione <dancol@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 13, 2020 at 10:44:08AM -0800, Minchan Kim wrote:
> On Mon, Jan 13, 2020 at 11:42:57AM +0100, Christian Brauner wrote:
> > On Mon, Jan 13, 2020 at 11:47:11AM +0300, Kirill Tkhai wrote:
> 
> < snip >
> 
> > > > +SYSCALL_DEFINE5(process_madvise, int, pidfd, unsigned long, start,
> > > > +		size_t, len_in, int, behavior, unsigned long, flags)
> > > 
> > > I don't like the interface. The fact we have pidfd does not mean,
> > > we have to use it for new syscalls always. A user may want to set
> > > madvise for specific pid from console and pass pid as argument.
> > > pidfd would be an overkill in this case.
> > > We usually call "kill -9 pid" from console. Why shouldn't process_madvise()
> > > allow this?
> > > 
> > > I suggent to extend first argument to work with both pid and pidfd.
> > > Look at what we have for waitid(idtype, id_t id, ...) for example:
> > > 
> > >        idtype == P_PID
> > >               Wait for the child whose process ID matches id.
> > > 
> > >        idtype == P_PIDFD (since Linux 5.4)
> > >               Wait for the child referred to by the PID file descriptor specified in id.  (See pidfd_open(2) for  further  information  on
> > >               PID file descriptors.)
> > > 
> > > We may use @flags argument for this.
> > 
> > Sorry for chiming in just a comment. Overall, I don't particularly care
> > how or if you integrate pidfd here. One thing I would like to point out
> > is that we're working on a patch to place new features under pidfd
> > specific flags. This e.g. means a pidfd would be only be able to be used
> > for madvise operations (or getfd operations) if it was created with that
> > specific flag set making it easier to share them with other processes.
> > So if you integrate them here I would be quite thankful if you target
> > the patchset for the v5.7 merge window, not for v5.6.
> 
> Hi Christian,
> Sorry but I couldn't understand your point.
> Could you clarify what you meant?

Hi Minchan,

Sure. When you create a pidfd, e.g. with clone3() and you'd wanted to
use it for madvise you'd need to set a flag like pidfd_cap_madvise or
pidfd_feature_madvise when you create the pidfd. Only if the pidfd was
created with that flag set could you use it with madvise (This does not
affect the permission checking you're performing here.). This has come
up a couple of times and becomes more relevant now that people keep
adding new features on top of pidfd and is similar to what we are now
doing with openat2().

Christian
