From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing
 a timeslice
Date: Tue, 23 Dec 2014 17:33:49 -0500
Message-ID: <5499EDCD.4090702@redhat.com>
References: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com> <20141218222846.GH30905@twins.programming.kicks-ass.net> <54935842.5020507@oracle.com> <alpine.DEB.2.11.1412182355020.17382@nanos> <54936562.5070502@oracle.com> <alpine.DEB.2.11.1412190045590.17382@nanos> <54949BF0.8030403@oracle.com> <alpine.DEB.2.11.1412200041220.17382@nanos> <5498498B.90703@oracle.com> <20141223105251.GB22203@gmail.com> <5499867C.1010201@oracle.com> <5499B8A2.4080008@redhat.com> <5499D4D7.90109@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5499D4D7.90109-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, raistlin-k2GhghHVRtY@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, atomlin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, athorlton-sJ/iWh9BUns@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, sbauer-F61uvSdQLzf2fBVCVOL8/A@public.gmane.org, vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/23/2014 03:47 PM, Khalid Aziz wrote:

>> You are right. Uncontended futex is very fast since it never goes
>> into kernel. Queuing problem happens when the lock holder has
>> been pre-empted. Adaptive spinning does the smart thing os
>> spin-waiting only if the lock holder is still running on another
>> core. If lock holder is not scheduled on any core, even adaptive
>> spinning has to go into the kernel to be put on wait queue. What
>> would avoid queuing problem and reduce the cost of contention is
>> a combination of adaptive spinning, and a way to keep the lock
>> holder running on one of the cores just a little longer so it can
>> release the lock. Without creating special case and a new API in
>> kernel, one way I can think of accomplishing the second part is
>> to boost the priority of lock holder when contention happens and 
>> priority ceiling is meant to do exactly that. Priority ceiling 
>> implementation in glibc boosts the priority by calling into
>> scheduler which does incur the cost of a system call. Priority
>> boost is a reliable solution that does not change scheduling
>> semantics. The solution allowing lock holder to use one extra
>> timeslice is not a definitive solution but tpcc workload shows it
>> does work and it works without requiring changes to database
>> locking code.
> 
>> Theoretically a new locking library that uses both these
>> techniques will help solve the problem but being a new locking
>> library, there is a big unknown of what new problems, performance
>> and otherwise, it will bring and database has to recode to this
>> new library. Nevertheless this is the path I am exploring now.
>> The challenge being how to do this without requiring changes to
>> database code or the kernel. The hooks available to me into
>> current database code are schedctl_init(), schedctl_start() and 
>> schedctl_stop() which are no-op on Linux at this time.

That sounds like a feature.  Keep the uncontended operations fast
by not doing anything, and only slow down when there is contention.

Presumably the database people will optimize their code to avoid
contention, so any complexity can happen in the slow path, instead
of by adding things to the fast path...

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUme3NAAoJEM553pKExN6DD8gH/3am5Izrobk/AiN8sijg3YXA
a9orVuoWNE+BLt49PwWrYpjsR2AgN4G3BbUrb4GVhaFBL5/v/frUhk0As3w3uM21
QjxMtaFvqZviLWCFgtIna7zSxHom+v/eRiAjLtCoX+GtHs+t25Jyf1GowmZnkoNd
UtDPHPXmyA2CqZC0E9d53Uzb9XaP/T4G3J8U2aPSvwoj4Nw85H2S/QMptNQEJDjY
0Qpx/fv2Ze/gJ7GujU3gloX6cH5DDU+p9/pFZ7iDEB6jbbb384Zuacq6R6CeJMVB
EAxKW1tpFtPvaRC51x8TFNJY5FxSISbXKbehxKjXQ8rlkcM/k1euzo2KCKOp68w=
=cTlU
-----END PGP SIGNATURE-----
