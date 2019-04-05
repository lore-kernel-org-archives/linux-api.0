From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] sched/core: expand sched_getaffinity(2) to return number of CPUs
Date: Fri, 05 Apr 2019 13:08:58 +0200
Message-ID: <87ftqw3e0l.fsf@oldenburg2.str.redhat.com>
References: <20190403200809.GA13876@avx2>
        <20190404084249.GS4038@hirez.programming.kicks-ass.net>
        <87wok83gfs.fsf@oldenburg2.str.redhat.com>
        <20190405110415.GP12232@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190405110415.GP12232@hirez.programming.kicks-ass.net> (Peter
        Zijlstra's message of "Fri, 5 Apr 2019 13:04:15 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, mingo@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Peter Zijlstra:

> On Fri, Apr 05, 2019 at 12:16:39PM +0200, Florian Weimer wrote:
>
>> > True; but I suppose glibc already does lots of that anyway, right? It
>> > does contain the right information.
>> 
>> If I recall correctly my last investigation,
>> /sys/devices/system/cpu/possible does not reflect the size of the
>> affinity mask, either.
>
> Strictly speaking correct; the bitmap can be longer than the highest
> possible cpu number, however the remainder would be 0-padding and could
> thus be stripped without issue.

Doesn't the kernel still enforce the larget bitmap in sched_getaffinity,
even if the bits are always zero?

Thanks,
Florian
