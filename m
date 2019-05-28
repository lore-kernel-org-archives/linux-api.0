From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH RFC] mm/madvise: implement MADV_STOCKPILE (kswapd from
 user space)
Date: Tue, 28 May 2019 07:56:00 -0700
Message-ID: <CALvZod4fZeQiARaMrw8eaw=9Tynb4x4quZx13nen22EwoC5epQ@mail.gmail.com>
References: <155895155861.2824.318013775811596173.stgit@buzz>
 <20190527141223.GD1658@dhcp22.suse.cz> <20190527142156.GE1658@dhcp22.suse.cz>
 <20190527143926.GF1658@dhcp22.suse.cz> <9c55a343-2a91-46c6-166d-41b94bf5e9c8@yandex-team.ru>
 <20190528065153.GB1803@dhcp22.suse.cz> <a4e5eeb8-3560-d4b4-08a0-8a22c677c0f7@yandex-team.ru>
 <20190528073835.GP1658@dhcp22.suse.cz> <5af1ba69-61d1-1472-4aa3-20beb4ae44ae@yandex-team.ru>
 <20190528084243.GT1658@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190528084243.GT1658@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Roman Gushchin <guro@fb.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 1:42 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Tue 28-05-19 11:04:46, Konstantin Khlebnikov wrote:
> > On 28.05.2019 10:38, Michal Hocko wrote:
> [...]
> > > Could you define the exact semantic? Ideally something for the manual
> > > page please?
> > >
> >
> > Like kswapd which works with thresholds of free memory this one reclaims
> > until 'free' (i.e. memory which could be allocated without invoking
> > direct recliam of any kind) is lower than passed 'size' argument.
>
> s@lower@higher@ I guess
>
> > Thus right after madvise(NULL, size, MADV_STOCKPILE) 'size' bytes
> > could be allocated in this memory cgroup without extra latency from
> > reclaimer if there is no other memory consumers.
> >
> > Reclaimed memory is simply put into free lists in common buddy allocator,
> > there is no reserves for particular task or cgroup.
> >
> > If overall memory allocation rate is smooth without rough spikes then
> > calling MADV_STOCKPILE in loop periodically provides enough room for
> > allocations and eliminates direct reclaim from all other tasks.
> > As a result this eliminates unpredictable delays caused by
> > direct reclaim in random places.
>
> OK, this makes it more clear to me. Thanks for the clarification!
> I have clearly misunderstood and misinterpreted target as the reclaim
> target rather than free memory target.  Sorry about the confusion.
> I sill think that this looks like an abuse of the madvise but if there
> is a wider consensus this is acceptable I will not stand in the way.
>
>

I agree with Michal that madvise does not seem like a right API for
this use-case, a 'proactive reclaim'.

This is conflating memcg and global proactive reclaim. There are
use-cases which would prefer to have centralized control on the system
wide proactive reclaim because system level memory overcommit is
controlled by the admin. Decoupling global and per-memcg proactive
reclaim will allow mechanism to implement both use-cases (yours and
this one).

The madvise() is requiring that the proactive reclaim process should
be in the target memcg.  I think a memcg interface instead of madvise
is better as it will allow the job owner to control cpu resources of
the proactive reclaim. With madvise, the proactive reclaim has to
share cpu with the target sub-task of the job (or do some tricks with
the hierarchy).

The current implementation is polling-based. I think a reactive
approach based on some watermarks would be better. Polling may be fine
for servers but for power restricted devices, reactive approach is
preferable.

The current implementation is bypassing PSI for global reclaim.
However I am not sure how should PSI interact with proactive reclaim
in general.

thanks,
Shakeel
