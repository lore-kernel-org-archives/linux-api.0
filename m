From: Waiman Long <waiman.long-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Tue, 22 Jul 2014 15:36:15 -0400
Message-ID: <53CEBD2F.2040705@hp.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <20140721211801.GA12149@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140721211801.GA12149-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/21/2014 05:18 PM, Ingo Molnar wrote:
> * Waiman Long<Waiman.Long-VXdhtT5mjnY@public.gmane.org>  wrote:
>
>> Testing done on a 4-socket Westmere-EX boxes with 40 cores (HT off)
>> showed the following performance data (average kops/s) with various
>> load factor (number of pause instructions) used in the critical
>> section using an userspace mutex microbenchmark.
>>
>>    Threads  Load	Waiting Futex	Spinning Futex 	  %Change
>>    -------  ----	-------------	--------------	  -------
>>      256	     1	     6894	    8883	    +29%
>>      256	    10	     3656	    4912	    +34%
>>      256	    50	     1332	    4358	   +227%
>>      256	   100	      792	    2753	   +248%
>>       10	     1	     6382	    4838	    -24%
>>       10	    10	     3614	    4748	    +31%
>>       10	    50	     1319	    3900	   +196%
>>       10	   100	      782	    2459	   +214%
>>        2	     1	     7905	    7194	   -9.0%
>>        2	    10	     4556	    4717	   +3.5%
>>        2	    50	     2191	    4167	    +90%
>>        2	   100	     1767	    2407	    +36%
> So the numbers look interesting - but it would be _really_ important
> to provide noise/sttdev figures in a sixth column as well (denoted in
> percentage units, not in benchmark units), so that we know how
> significant a particular speedup (or slowdown) is.
>
> Thanks,
>
> 	Ingo

The performance can varies quite a bit depending on what other processes 
are running at the test execution time. I will include stddev data in 
the next iteration of the patch.

-Longman
