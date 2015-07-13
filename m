From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU
 number (x86)
Date: Mon, 13 Jul 2015 16:07:21 +0000 (UTC)
Message-ID: <656785149.1275.1436803641626.JavaMail.zimbra@efficios.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com> <CALCETrV1suAbvMgD1jOEFyn3JcDE_hhi6X7+sGs9e3Oqw_6jUw@mail.gmail.com> <1050138282.1065.1436801252018.JavaMail.zimbra@efficios.com> <CADroS=7MnUULrjDeQtmscxjkpjCtti9V-HfFXU0sjKhi6PsaAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADroS=7MnUULrjDeQtmscxjkpjCtti9V-HfFXU0sjKhi6PsaAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jul 13, 2015, at 11:30 AM, Andrew Hunter ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org wrote:

> On Mon, Jul 13, 2015 at 8:27 AM, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> percpu segments will likely not solve everything. I have a use-case
>> with dynamically allocated per-cpu ring buffer in user-space (lttng-ust)
>> which can be a challenge for percpu segments. Having a fast getcpu()
>> is a win in those cases.
>>
> 
> Note that percpu segments allow userspace to trivially implement fast getcpu.
> 
> For the record, Paul and I currently think the best solution is percpu
> segments + some variant of a restart-sequence API (we'll have a patch
> soon.)

Although useful in many situations, percpu segments still have some
limitations AFAIU:

- They are not available on all architectures (very x86-specific),
- Some user-space applications already use those segments.

So as long as we only target user-space code that does not use GS,
and which runs on x86, the percpu segments seems to be a good idea.
However, implementing a more general approach for a fast getcpu cache
still appears somewhat useful for the general case.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
