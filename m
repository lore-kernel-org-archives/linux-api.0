From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -mm v9 0/8] idle memory tracking
Date: Wed, 29 Jul 2015 19:37:26 +0300
Message-ID: <20150729163725.GZ8100@esperanza>
References: <cover.1437303956.git.vdavydov@parallels.com>
 <20150729123629.GI15801@dhcp22.suse.cz>
 <20150729135907.GT8100@esperanza>
 <20150729142618.GJ15801@dhcp22.suse.cz>
 <20150729152817.GV8100@esperanza>
 <CAJu=L59RdowYjTyVM0Vhz79A4d=d8=ZmU7PB59CmEj5B0_c48Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJu=L59RdowYjTyVM0Vhz79A4d=d8=ZmU7PB59CmEj5B0_c48Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 29, 2015 at 08:55:01AM -0700, Andres Lagar-Cavilla wrote:
> On Wed, Jul 29, 2015 at 8:28 AM, Vladimir Davydov
> <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> > On Wed, Jul 29, 2015 at 04:26:19PM +0200, Michal Hocko wrote:
> >> On Wed 29-07-15 16:59:07, Vladimir Davydov wrote:
> >> > On Wed, Jul 29, 2015 at 02:36:30PM +0200, Michal Hocko wrote:
> >> > > On Sun 19-07-15 15:31:09, Vladimir Davydov wrote:
> >> > > [...]
> >> > > > ---- USER API ----
> >> > > >
> >> > > > The user API consists of two new proc files:
> >> > >
> >> > > I was thinking about this for a while. I dislike the interface.  It is
> >> > > quite awkward to use - e.g. you have to read the full memory to check a
> >> > > single memcg idleness. This might turn out being a problem especially on
> >> > > large machines.
> >> >
> >> > Yes, with this API estimating the wss of a single memory cgroup will
> >> > cost almost as much as doing this for the whole system.
> >> >
> >> > Come to think of it, does anyone really need to estimate idleness of one
> >> > particular cgroup?
> 
> You can always adorn memcg with a boolean, trivially configurable from
> user-space, and have all the idle computation paths skip the code if
> memcg->dont_care_about_idle

Or we can filter out cgroups in which we're not interested using
/proc/kpagecgroup.

> 
> >>
> >> It is certainly interesting for setting the low limit.
> >
> 
> Valuable, IMHO
> 
> > Yes, but IMO there is no point in setting the low limit for one
> > particular cgroup w/o considering what's going on with the rest of the
> > system.
> >
> 
> Probably worth more fleshing out. Why not? Because global reclaim can
> execute in any given context, so a noisy neighbor hurts all?

The low limit does not necessarily mean, the cgroup will never get
pushed below it. It will, if others feel really bad.

Also, by setting the low limit too high, you can make others thrash
constantly, which will increase IO, which, in turn, might hurt the
workload you're trying to protect. Blkio cgroup might help in this case
though.

Thanks,
Vladimir
