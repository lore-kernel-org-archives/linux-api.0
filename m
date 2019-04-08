From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] sched/core: expand sched_getaffinity(2) to return number of CPUs
Date: Mon, 08 Apr 2019 09:49:35 +0200
Message-ID: <878swlszqo.fsf@oldenburg2.str.redhat.com>
References: <20190403200809.GA13876@avx2>
        <20190404084249.GS4038@hirez.programming.kicks-ass.net>
        <87wok83gfs.fsf@oldenburg2.str.redhat.com>
        <20190406194825.GA5106@avx2>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190406194825.GA5106@avx2> (Alexey Dobriyan's message of "Sat,
        6 Apr 2019 22:48:25 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Alexey Dobriyan:

>> >> Patch overloads sched_getaffinity(len=0) to simply return "nr_cpu_ids".
>> >> This will make gettting CPU mask require at most 2 system calls
>> >> and will eliminate unnecessary code.
>> >> 
>> >> len=0 is chosen so that
>> >> * passing zeroes is the simplest thing
>> >> 
>> >> 	syscall(__NR_sched_getaffinity, 0, 0, NULL)
>> >> 
>> >>   will simply do the right thing,
>> >> 
>> >> * old kernels returned -EINVAL unconditionally.
>> >> 
>> >> Note: glibc segfaults upon exiting from system call because it tries to
>> >> clear the rest of the buffer if return value is positive, so
>> >> applications will have to use syscall(3).
>> >> Good news is that it proves noone uses sched_getaffinity(pid, 0, NULL).
>> 
>> Given that old kernels fail with EINVAL, that evidence is fairly
>> restricted.
>> 
>> I'm not sure if it's a good idea to overload this interface.  I expect
>> that users will want to call sched_getaffinity (the system call wrapper)
>> with cpusetsize == 0 to query the value, so there will be pressure on
>> glibc to remove the memset.  At that point we have an API that obscurely
>> fails with old glibc versions, but suceeds with newer ones, which isn't
>> great.
>
> I can do "if (len == 536870912)" so that bit count overflows on old
> kernels into EINVAL and is unlikely to be used ever.

I don't see how this solves this particular issue.  It will still result
in a mysterious crash if programs use an updated system call wrapper.

Thanks,
Florian
