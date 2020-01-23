From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/5] mm: introduce external memory hinting API
Date: Wed, 22 Jan 2020 17:41:31 -0800
Message-ID: <20200123014131.GA249784@google.com>
References: <20200116235953.163318-1-minchan@kernel.org>
 <20200116235953.163318-3-minchan@kernel.org>
 <20200117115225.GV19428@dhcp22.suse.cz>
 <20200117155837.bowyjpndfiym6cgs@box>
 <20200117173239.GB140922@google.com>
 <20200117212653.7uftw3lk35oykkmb@box>
 <20200119161431.GA94410@google.com>
 <20200120075825.GH18451@dhcp22.suse.cz>
 <20200121183212.GF140922@google.com>
 <20200122082853.GS29276@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200122082853.GS29276-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, sjpark-ebkRAfMGSJGzQB+pC5nmwQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 22, 2020 at 09:28:53AM +0100, Michal Hocko wrote:
> On Tue 21-01-20 10:32:12, Minchan Kim wrote:
> > On Mon, Jan 20, 2020 at 08:58:25AM +0100, Michal Hocko wrote:
> [...]
> > > The interface really has to be robust to future potential usecases.
> > 
> > I do understand your concern but for me, it's chicken and egg problem.
> > We usually do best effort to make something perfect as far as possible
> > but we also don't do over-engineering without real usecase from the
> > beginning.
> > 
> > I already told you how we could synchronize among processes and potential
> > way to be extended Daniel suggested(That's why current API has extra field
> > for the cookie) even though we don't need it right now.
> 
> If you can synchronize with the target task then you do not need a
> remote interface. Just use ptrace and you are done with it.

As I mentioned in other reply, we want to do in caller's context, not
callee's one because target processes stay in little cores, which are
much slower than the core the manager lives in.
The other reason is the apps are already freezed so they couldn't response
by ptrace.

> 
> > If you want to suggest the other way, please explain why your idea is
> > better and why we need it at this moment.
> 
> I believe I have explained my concerns and why they matter. All you are
> saying is that you do not care because your particular usecase doesn't
> care. And that is a first signal of a future disaster when we end up
> with a broken and unfixable interface we have to maintain for ever.

We already had suggested cookie and fd based approaches so I reserved a
argument for that to make the API extendable.
Thing is currently it's a just optimization idea since we have several
ways to sychronize processes(e.g., signal, cgroup freezer, userfaultfd
and so). It's a just matter of granularity, not necessary one we should
introduce it from the beginnig.
If someone needs that kinds of fine-grained consistency, we could extend
it then. And that's the usual way we make progress when we couldn't
know the future.

What do you want to see further?
