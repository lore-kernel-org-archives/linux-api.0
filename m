From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH 0/3] restartable sequences benchmarks
Date: Thu, 22 Oct 2015 12:11:42 -0700
Message-ID: <CALCETrWXR0BMeEygiLoT5gbyYpGxren_Fch=S4RSryfqwdxH8g@mail.gmail.com>
References: <cover.1445464158.git.davejwatson@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1445464158.git.davejwatson@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Watson <davejwatson@fb.com>
Cc: kernel-team@fb.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 22, 2015 at 11:06 AM, Dave Watson <davejwatson@fb.com> wrote:
> We've been testing out restartable sequences + malloc changes for use
> at Facebook.  Below are some test results, as well as some possible
> changes based on Paul Turner's original patches

Thanks!  I'll stare at this some time between now and Kernel Summit.

>
> https://lkml.org/lkml/2015/6/24/665
>
> I ran one service with several permutations of various mallocs.  The
> service is CPU-bound, and hits the allocator quite hard.  Requests/s
> are held constant at the source, so we use cpu idle time and latency
> as an indicator of service quality. These are average numbers over
> several hours.  Machines were dual E5-2660, total 16 cores +
> hyperthreading.  This service has ~400 total threads, 70-90 of which
> are doing work at any particular time.
>
>                                    RSS CPUIDLE LATENCYMS
> jemalloc 4.0.0                     31G   33%     390
> jemalloc + this patch              25G   33%     390
> jemalloc + this patch using lsl    25G   30%     420
> jemalloc + PT's rseq patch         25G   32%     405
> glibc malloc 2.20                  27G   30%     420
> tcmalloc gperftools trunk (2.2)    21G   30%     480

Slightly confused.  This is showing a space efficiency improvement but
not a performance improvement?  Is the idea that percpu free lists are
more space efficient than per-thread free lists?

>
> jemalloc rseq patch used for testing:
> https://github.com/djwatson/jemalloc
>
> lsl test - using lsl segment limit to get cpu (i.e. inlined vdso
> getcpu on x86) instead of using the thread caching as in this patch.
> There has been some suggestions to add the thread-cached getcpu()
> feature separately.  It does seem to move the needle in a real service
> by about ~3% to have a thread-cached getcpu vs. not.  I don't think we
> can use restartable sequences in production without a faster getcpu.

If nothing else, I'd like to replace the thread-cached getcpu thing
with percpu gsbase, at least on x86.  That doesn't necessarily have to
be exclusive with restartable sequences.

>
> GS-segment / migration only tests
>
> There's been some interest in seeing if we can do this with only gs
> segment, here's some numbers for those.  This doesn't have to be gs,
> it could just be a migration signal sent to userspace as well, the
> same approaches would apply.
>
> GS patch: https://lkml.org/lkml/2014/9/13/59
>
>                                    RSS CPUIDLE LATENCYMS
> jemalloc 4.0.0                     31G   33%     390
> jemalloc + percpu locking          25G   25%     420
> jemalloc + preempt lock / signal   25G   32%     415

Neat!

--Andy
