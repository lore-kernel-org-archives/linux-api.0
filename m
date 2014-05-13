From: Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [SCHED_DEADLINE man pages 2/2] sched(7) SCHED_DEADLINE
Date: Tue, 13 May 2014 17:52:10 +0200
Message-ID: <20140513175210.49eed2e34ac06a3c109ce963@gmail.com>
References: <53723235.40101@gmail.com>
	<537233A9.6040102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <537233A9.6040102-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Tue, 13 May 2014 17:00:57 +0200
"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hello Peter et al.
>=20
> Here is the section of the sched(7) page that describes SCHED_DEADLIN=
E,
> as rendered text, with the (entire) raw page source attached. Please=20
> carefully review.
>=20
> Cheers,
>=20
> Michael
>=20
>    SCHED_DEADLINE: Sporadic task model deadline scheduling
>        Since version 3.14, Linux provides a deadline scheduling pol=E2=
=80=90
>        icy (SCHED_DEADLINE).  This policy is  currently  implemented
>        using  GEDF  (Global  Earliest Deadline First) in conjunction
>        with CBS (Constant Bandwidth Server).  To set and fetch  this
>        policy and associated attributes, one must use the Linux-spe=E2=
=80=90
>        cific sched_setattr(2) and sched_getattr(2) system calls.
>=20
>        A sporadic task is one that has a  sequence  of  jobs,  where
>        each job is activated at most once per period.  Each job also
>        has a relative deadline, before which it should finish execu=E2=
=80=90
>        tion, and a computation time, which is the CPU time necessary
>        for executing the job.  The  moment  when  a  task  wakes  up
>        because  a  new  job has to be executed is called the arrival
>        time (also referred to as the request time or release  time).
>        The  start time is the time at which a task starts its execu=E2=
=80=90
>        tion.  The absolute deadline is thus obtained by  adding  the
>        relative deadline to the arrival time.
>=20
>        The following diagram clarifies these terms:
>=20
>            arrival/wakeup                   absolute deadline
>                 |    start time                   |
>                 |        |                        |
>                 v        v                        v
>            -----x--------xooooooooooooooooo-------x--------x---
>                          |<- comp. time ->|
>                 |<------- relative deadline ----->|
>                 |<-------------- period ------------------>|
>=20
>        When  setting  a  SCHED_DEADLINE  policy  for  a thread using
>        sched_setattr(2), one can specify three parameters:  Runtime,
>        Deadline,  and  Period.   These parameters do not necessarily
>        correspond to the aforementioned terms: usual practice is  to
>        set  Runtime to something bigger than the average computation
>        time (or worst-case execution time for hard real-time tasks),
>        Deadline  to  the relative deadline, and Period to the period
>        of the task.  Thus, for SCHED_DEADLINE scheduling, we have:
>=20
>            arrival/wakeup                   absolute deadline
>                 |    start time                   |
>                 |        |                        |
>                 v        v                        v
>            -----x--------xooooooooooooooooo-------x--------x---
>                          |<-- Runtime --->|

                           |<-- Runtime   --->|

I originally drew this slightly bigger than comp. time above because we
usually don't want tasks to be throttled in the average case. It's just
a rule of thumb.

>                 |<----------- Deadline ---------->|
>                 |<-------------- Period ------------------>|
>=20
>        The three deadline-scheduling parameters  correspond  to  the
>        sched_runtime, sched_deadline, and sched_period fields of the
>        sched_attr structure;  see  sched_setattr(2).   These  fields
>        express  value  in nanoseconds.  If sched_period is specified
>        as 0, then it is made the same as sched_deadline.
>=20
>        The kernel requires that:
>=20
>            sched_runtime <=3D sched_deadline <=3D sched_period
>=20
>        In addition, under the current  implementation,  all  of  the
>        parameter  values  must be at least 1024 (i.e., just over one
>        microsecond, which is the resolution of the  implementation).

And below 2^63, as per the last bug fix we discussed.

>        If any of these checks fails, sched_setattr(2) fails with the
>        error EINVAL.
>=20
>        The CBS guarantees non-interference between tasks, by  throt=E2=
=80=90
>        tling  threads  that attempt to over-run their specified Run=E2=
=80=90
>        time.
>=20
>        To ensure deadline scheduling  guarantees,  the  kernel  must
>        prevent situations where the set of SCHED_DEADLINE threads is
>        not feasible (schedulable) within the given constraints.  The
>        kernel  thus  performs  an  admittance  test  when setting or
>        changing SCHED_DEADLINE policy and attributes.   This  admis=E2=
=80=90
>        sion test calculates whether the change is feasible; if it is
>        not sched_setattr(2) fails with the error EBUSY.
>=20
>        For example, it is required (but not necessarily  sufficient)
>        for  the  total  utilization  to be less than or equal to the
>        total number of CPUs available, where, since each thread  can
>        maximally  run for Runtime per Period, that thread's utiliza=E2=
=80=90
>        tion is its Runtime divided by its Period.
>=20
>        In order to fulfil the guarantees that are made when a thread
>        is  admitted  to  the  SCHED_DEADLINE  policy, SCHED_DEADLINE
>        threads are the highest priority (user controllable)  threads
>        in  the  system; if any SCHED_DEADLINE thread is runnable, it
>        will preempt any thread scheduled  under  one  of  the  other
>        policies.
>=20
>        A call to fork(2) by a thread scheduled under the SCHED_DEAD=E2=
=80=90
>        LINE policy will fail  with  the  error  EAGAIN,  unless  the
>        thread has its reset-on-fork flag set (see below).
>=20
>        A  SCHED_DEADLINE thread that calls sched_yield(2) will yield
>        the current job and wait for a new period to begin.
>=20

Thanks,

- Juri
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
