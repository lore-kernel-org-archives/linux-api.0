From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 2/4] mm: introduce external memory hinting API
Date: Tue, 14 Jan 2020 11:39:28 +0300
Message-ID: <3eec2097-75a3-1e1d-06d9-44ee5eaf1312@virtuozzo.com>
References: <20200110213433.94739-1-minchan@kernel.org>
 <20200110213433.94739-3-minchan@kernel.org>
 <56ea0927-ad2e-3fbd-3366-3813330f6cec@virtuozzo.com>
 <CAKOZuevwbQvrFWqy5GOm4RXuGszKLBvRs9i-KbAi3nPcHhwvSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKOZuevwbQvrFWqy5GOm4RXuGszKLBvRs9i-KbAi3nPcHhwvSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Dias <joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 13.01.2020 22:18, Daniel Colascione wrote:
> On Mon, Jan 13, 2020, 12:47 AM Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>>> +SYSCALL_DEFINE5(process_madvise, int, pidfd, unsigned long, start,
>>> +             size_t, len_in, int, behavior, unsigned long, flags)
>>
>> I don't like the interface. The fact we have pidfd does not mean,
>> we have to use it for new syscalls always. A user may want to set
>> madvise for specific pid from console and pass pid as argument.
>> pidfd would be an overkill in this case.
>> We usually call "kill -9 pid" from console. Why shouldn't process_madvise()
>> allow this?
> 
> All new APIs should use pidfds: they're better than numeric PIDs

Yes

> in every way.

No

> If a program wants to allow users to specify processes by
> numeric PID, it can parse that numeric PID, open the corresponding
> pidfd, and then use that pidfd with whatever system call it wants.
> It's not necessary to support numeric PIDs at the system call level to
> allow a console program to identify a process by numeric PID.

No. It is overkill. Ordinary pid interfaces also should be available.
There are a lot of cases, when they are more comfortable. Say, a calling
of process_madvise() from tracer, when a tracee is stopped. In this moment
the tracer knows everything about tracee state, and pidfd brackets
pidfd_open() and close() around actual action look just stupid, and this
is cpu time wasting.

Another example is a parent task, which manages parameters of its children.
It knows everything about them, whether they are alive or not. Pidfd interface
will just utilize additional cpu time here.

So, no. Both interfaces should be available.
