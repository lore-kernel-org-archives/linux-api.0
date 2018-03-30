From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [REVIEW][PATCH 11/11] ipc/sem: Fix semctl(..., GETPID, ...) between pid namespaces
Date: Fri, 30 Mar 2018 15:12:10 -0500
Message-ID: <87y3i91fxh.fsf@xmission.com>
References: <87vadmobdw.fsf_-_@xmission.com>
        <20180323191614.32489-11-ebiederm@xmission.com>
        <20180329005209.fnzr3hzvyr4oy3wi@linux-n805>
        <20180330190951.nfcdwuzp42bl2lfy@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180330190951.nfcdwuzp42bl2lfy@linux-n805> (Davidlohr Bueso's
        message of "Fri, 30 Mar 2018 12:09:51 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: manfred@colorfullife.com, Linux Containers <containers@lists.linux-foundation.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, khlebnikov@yandex-team.ru, prakash.sangappa@oracle.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, serge.hallyn@ubuntu.com, esyr@redhat.com, jannh@google.com, linux-security-module@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
List-Id: linux-api@vger.kernel.org

Davidlohr Bueso <dave@stgolabs.net> writes:

> I ran this on a 40-core (no ht) Westmere with two benchmarks. The first
> is Manfred's sysvsem lockunlock[1] program which uses _processes_ to,
> well, lock and unlock the semaphore. The options are a little
> unconventional, to keep the "critical region small" and the lock+unlock
> frequency high I added busy_in=busy_out=10. Similarly, to get the
> worst case scenario and have everyone update the same semaphore, a single
> one is used. Here are the results (pretty low stddev from run to run)
> for doing 100,000 lock+unlock.
>
> - 1 proc:
>   * vanilla
> 	total execution time: 0.110638 seconds for 100000 loops
>   * dirty
> 	total execution time: 0.120144 seconds for 100000 loops
>
> - 2 proc:
>   * vanilla
> 	total execution time: 0.379756 seconds for 100000 loops
>   * dirty
> 	total execution time: 0.477778 seconds for 100000 loops
>
> - 4 proc:
>   * vanilla
> 	total execution time: 6.749710 seconds for 100000 loops
>   * dirty
> 	total execution time: 4.651872 seconds for 100000 loops
>
> - 8 proc:
>   * vanilla
>        total execution time: 5.558404 seconds for 100000 loops
>   * dirty
> 	total execution time: 7.143329 seconds for 100000 loops
>
> - 16 proc:
>   * vanilla
> 	total execution time: 9.016398 seconds for 100000 loops
>   * dirty
> 	total execution time: 9.412055 seconds for 100000 loops
>
> - 32 proc:
>   * vanilla
> 	total execution time: 9.694451 seconds for 100000 loops
>   * dirty
> 	total execution time: 9.990451 seconds for 100000 loops
>
> - 64 proc:
>   * vanilla
> 	total execution time: 9.844984 seconds for 100032 loops
>   * dirty
> 	total execution time: 10.016464 seconds for 100032 loops
>
> Lower task counts show pretty massive performance hits of ~9%, ~25%
> and ~30% for single, two and four/eight processes. As more are added
> I guess the overhead tends to disappear as for one you have a lot
> more locking contention going on.

Can you check your notes on the 4 process case?  As I read the 4 process
case above it is ~30% improvement.  Either that is a typo or there is the
potential for quite a bit of noise in the test case.


Eric
