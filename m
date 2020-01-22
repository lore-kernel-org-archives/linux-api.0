From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/5] mm: introduce external memory hinting API
Date: Wed, 22 Jan 2020 09:28:53 +0100
Message-ID: <20200122082853.GS29276@dhcp22.suse.cz>
References: <20200116235953.163318-1-minchan@kernel.org>
 <20200116235953.163318-3-minchan@kernel.org>
 <20200117115225.GV19428@dhcp22.suse.cz>
 <20200117155837.bowyjpndfiym6cgs@box>
 <20200117173239.GB140922@google.com>
 <20200117212653.7uftw3lk35oykkmb@box>
 <20200119161431.GA94410@google.com>
 <20200120075825.GH18451@dhcp22.suse.cz>
 <20200121183212.GF140922@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200121183212.GF140922-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, sjpark-ebkRAfMGSJGzQB+pC5nmwQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 21-01-20 10:32:12, Minchan Kim wrote:
> On Mon, Jan 20, 2020 at 08:58:25AM +0100, Michal Hocko wrote:
[...]
> > The interface really has to be robust to future potential usecases.
> 
> I do understand your concern but for me, it's chicken and egg problem.
> We usually do best effort to make something perfect as far as possible
> but we also don't do over-engineering without real usecase from the
> beginning.
> 
> I already told you how we could synchronize among processes and potential
> way to be extended Daniel suggested(That's why current API has extra field
> for the cookie) even though we don't need it right now.

If you can synchronize with the target task then you do not need a
remote interface. Just use ptrace and you are done with it.

> If you want to suggest the other way, please explain why your idea is
> better and why we need it at this moment.

I believe I have explained my concerns and why they matter. All you are
saying is that you do not care because your particular usecase doesn't
care. And that is a first signal of a future disaster when we end up
with a broken and unfixable interface we have to maintain for ever.

I will not go as far as to nack this but you should seriously think
about other potential usecases and how they would work and what we are
going to do when a first non-cooperative userspace memory management
usecase materializes.
-- 
Michal Hocko
SUSE Labs
