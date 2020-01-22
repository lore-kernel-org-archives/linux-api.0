From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Re: [PATCH v2 2/5] mm: introduce external memory hinting API
Date: Wed, 22 Jan 2020 11:02:33 +0100
Message-ID: <20200122100233.GT29276@dhcp22.suse.cz>
References: <20200122082853.GS29276@dhcp22.suse.cz>
 <20200122093624.14799-1-sjpark@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200122093624.14799-1-sjpark-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SeongJae Park <sjpark-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, sjpark-ebkRAfMGSJGzQB+pC5nmwQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 22-01-20 10:36:24, SeongJae Park wrote:
> On Wed, 22 Jan 2020 09:28:53 +0100 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > On Tue 21-01-20 10:32:12, Minchan Kim wrote:
> > > On Mon, Jan 20, 2020 at 08:58:25AM +0100, Michal Hocko wrote:
> > [...]
> > > > The interface really has to be robust to future potential usecases.
> > > 
> > > I do understand your concern but for me, it's chicken and egg problem.
> > > We usually do best effort to make something perfect as far as possible
> > > but we also don't do over-engineering without real usecase from the
> > > beginning.
> > > 
> > > I already told you how we could synchronize among processes and potential
> > > way to be extended Daniel suggested(That's why current API has extra field
> > > for the cookie) even though we don't need it right now.
> > 
> > If you can synchronize with the target task then you do not need a
> > remote interface. Just use ptrace and you are done with it.
> > 
> > > If you want to suggest the other way, please explain why your idea is
> > > better and why we need it at this moment.
> > 
> > I believe I have explained my concerns and why they matter. All you are
> > saying is that you do not care because your particular usecase doesn't
> > care. And that is a first signal of a future disaster when we end up
> > with a broken and unfixable interface we have to maintain for ever.
> > 
> > I will not go as far as to nack this but you should seriously think
> > about other potential usecases and how they would work and what we are
> > going to do when a first non-cooperative userspace memory management
> > usecase materializes.
> 
> Beside of the specific environment of Android, I think there are many ways to
> know the address space layout and access patterns of other processes.  The
> idle_page_tracking might be an example that widelay available.
> 
> Of course, the information might not strictly correct due to the timing issue,
> but could be still worth to be used under some extreme situations, such as
> memory pressure or fragmentation.  For the same reason, ptrace() would not be
> sufficient, as we have no perfect control, but only some level of control that
> would be useful under specific situations.

I am not sure I see your point. I am talking about races where a remote
task is operating on a completely different object because the one it
checked for has been unmapped and new one mapped over it. Memory
pressure or a fragmentation will not change the object itself. Sure the
memory might be reclaimed but that should be completely OK unless I am
missing something.

> I assume the users of this systemcall would understand the tradeoff and make
> decisions.

I disagree. My experience tells me that users tend to squeeze the
maximum and beyond and hope they get what they want.

> Also, as the users already have the right to do the tradeoff, I
> think it's fair.  In other words, I think the caller has both the power and the
> responsibility to deal with the time-to-check-time-to-react problem.
> 
> Nonetheless, I also agree this is important concern and the patch would be
> better if it adds more detailed documentation regarding this issue.

If there is _really_ a strong consensus that the racy interface is
reasonable then it absolutely has to be described with a clearly state
that those races might result in hard to predict behavior unless all
tasks sharing the address space are blocked between the check and the
madvise call.
-- 
Michal Hocko
SUSE Labs
