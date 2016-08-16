From: Chris Mason <clm-b10kYP2dOMg@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Tue, 16 Aug 2016 10:58:01 -0400
Message-ID: <20a152f9-664f-f503-dbb5-1dc857aa9088@fb.com>
References: <20160805170752.GK2542@mtj.duckdns.org>
 <1470474291.4117.243.camel@gmail.com> <20160810220944.GB3085@cmpxchg.org>
 <20160816140738.GW6879@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160816140738.GW6879-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 08/16/2016 10:07 AM, Peter Zijlstra wrote:
> On Wed, Aug 10, 2016 at 06:09:44PM -0400, Johannes Weiner wrote:
>
>> [ That, and a disturbing number of emotional outbursts against
>>   systemd, which has nothing to do with any of this. ]
>
> Oh, so I'm entirely dreaming this then:
>
>   https://github.com/systemd/systemd/pull/3905
>
> Completely unrelated.
>
> Also, the argument there seems unfair at best, you don't need cpu-v2 for
> buffered write control, you only need memcg and block co-mounted.
>

This isn't systemd dictating cgroups2 or systemd trying to get rid of 
v1.  But systemd is a common user of cgroups, and we do use it here in 
production.

We're just sending patches upstream for the tools we're using.  It's 
better than keeping them private, or reinventing a completely different 
tool that does almost the same thing.

-chris
