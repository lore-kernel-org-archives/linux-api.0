From: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Mon, 13 Jul 2015 08:30:42 -0700
Message-ID: <CADroS=7MnUULrjDeQtmscxjkpjCtti9V-HfFXU0sjKhi6PsaAg@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
	<CALCETrV1suAbvMgD1jOEFyn3JcDE_hhi6X7+sGs9e3Oqw_6jUw@mail.gmail.com>
	<1050138282.1065.1436801252018.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1050138282.1065.1436801252018.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 13, 2015 at 8:27 AM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> percpu segments will likely not solve everything. I have a use-case
> with dynamically allocated per-cpu ring buffer in user-space (lttng-ust)
> which can be a challenge for percpu segments. Having a fast getcpu()
> is a win in those cases.
>

Note that percpu segments allow userspace to trivially implement fast getcpu.

For the record, Paul and I currently think the best solution is percpu
segments + some variant of a restart-sequence API (we'll have a patch
soon.)
