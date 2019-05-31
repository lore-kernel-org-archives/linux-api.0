From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFCv2 5/6] mm: introduce external memory hinting API
Date: Fri, 31 May 2019 10:35:20 -0700
Message-ID: <CAKOZuevswVxZjffQcwjqJFa5V4Vv2jxq=mq6hWhd1SpNrGAGkg@mail.gmail.com>
References: <20190531064313.193437-1-minchan@kernel.org> <20190531064313.193437-6-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531064313.193437-6-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, oleksandr@redhat.com, hdanton@sina.com
List-Id: linux-api@vger.kernel.org

On Thu, May 30, 2019 at 11:43 PM Minchan Kim <minchan@kernel.org> wrote:
>
> There is some usecase that centralized userspace daemon want to give
> a memory hint like MADV_[COLD|PAGEEOUT] to other process. Android's
> ActivityManagerService is one of them.
>
> It's similar in spirit to madvise(MADV_WONTNEED), but the information
> required to make the reclaim decision is not known to the app. Instead,
> it is known to the centralized userspace daemon(ActivityManagerService),
> and that daemon must be able to initiate reclaim on its own without
> any app involvement.
>
> To solve the issue, this patch introduces new syscall process_madvise(2).
> It could give a hint to the exeternal process of pidfd.
>
>  int process_madvise(int pidfd, void *addr, size_t length, int advise,
>                         unsigned long cookie, unsigned long flag);
>
> Since it could affect other process's address range, only privileged
> process(CAP_SYS_PTRACE) or something else(e.g., being the same UID)
> gives it the right to ptrace the process could use it successfully.
>
> The syscall has a cookie argument to privode atomicity(i.e., detect
> target process's address space change since monitor process has parsed
> the address range of target process so the operaion could fail in case
> of happening race). Although there is no interface to get a cookie
> at this moment, it could be useful to consider it as argument to avoid
> introducing another new syscall in future. It could support *atomicity*
> for disruptive hint(e.g., MADV_DONTNEED|FREE).
> flag argument is reserved for future use if we need to extend the API.

How about a compromise? Let's allow all madvise hints if the process
is calling process_madvise *on itself* (which will be useful once we
wire up the atomicity cookie) and restrict the cross-process case to
the hints you've mentioned. This way, the restriction on madvise hints
isn't tied to the specific API, but to the relationship between hinter
and hintee.
