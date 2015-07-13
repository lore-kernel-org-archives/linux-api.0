From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU
 number (x86)
Date: Mon, 13 Jul 2015 17:36:32 +0000 (UTC)
Message-ID: <587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6-f8hGUhss0nh9TZdEUguypQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

----- On Jul 13, 2015, at 7:17 AM, Ben Maurer bmaurer-b10kYP2dOMg@public.gmane.org wrote:

> At Facebook we already use getcpu in folly, our base C++ library, to provide
> high performance concurrency algorithms. Folly includes an abstraction called
> AccessSpreader which helps engineers write abstractions which shard themselves
> across different cores to prevent cache contention
> (https://github.com/facebook/folly/blob/master/folly/detail/CacheLocality.cpp).
> We have used this primative to create faster reader writer locks
> (https://github.com/facebook/folly/blob/master/folly/SharedMutex.h), as well as
> in an abstraction that powers workqueues
> (https://github.com/facebook/folly/blob/master/folly/IndexedMemPool.h). This
> would be a great perf improvement for these types of abstractions and probably
> encourage us to use the idea more widely.
> 
> One quick comment on the approach -- it'd be really great if we had a method
> that didn't require users to register each thread. This can often lead to
> requiring an additional branch in critical code to check if the appropriate
> caches have been initialized. Also, one of the most interesting potential
> applications of the restartable sequences concept is in malloc. having a brief
> period at the beginning of the life of a thread where malloc didn't work would
> be pretty tricky to program around.

If we invoke this per-thread registration directly in the glibc NPTL implementation,
in start_thread, do you think it would fit your requirements ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
