From: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH 0/7] locking/rwsem: enable reader opt-spinning & writer
 respin
Date: Sun, 03 Aug 2014 21:25:13 -0700
Message-ID: <1407126313.3216.10.camel@buesod1.americas.hpqcorp.net>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407119782-41119-1-git-send-email-Waiman.Long-VXdhtT5mjnY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, 2014-08-03 at 22:36 -0400, Waiman Long wrote:
> This patch set improves upon the rwsem optimistic spinning patch set
> from Davidlohr to enable better performing rwsem and more aggressive
> use of optimistic spinning.
> 
> By using a microbenchmark running 1 million lock-unlock operations per
> thread on a 4-socket 40-core Westmere-EX x86-64 test machine running
> 3.16-rc7 based kernels, the following table shows the execution times
> with 2/10 threads running on different CPUs on the same socket where
> load is the number of pause instructions in the critical section:
> 
>   lock/r:w ratio # of threads	Load:Execution Time (ms)
>   -------------- ------------	------------------------
>   mutex		      2		1:530.7, 5:406.0, 10:472.7
>   mutex		     10		1:1848 , 5:2046 , 10:4394
> 
> Before patch:
>   rwsem/0:1	      2		1:339.4, 5:368.9, 10:394.0
>   rwsem/1:1	      2		1:2915 , 5:2621 , 10:2764
>   rwsem/10:1	      2		1:891.2, 5:779.2, 10:827.2
>   rwsem/0:1	     10		1:5618 , 5:5722 , 10:5683
>   rwsem/1:1	     10		1:14562, 5:14561, 10:14770
>   rwsem/10:1	     10		1:5914 , 5:5971 , 10:5912
> 
> After patch:
>   rwsem/0:1	     2		1:161.1, 5:244.4, 10:271.4
>   rwsem/1:1	     2		1:188.8, 5:212.4, 10:312.9
>   rwsem/10:1	     2		1:168.8, 5:179.5, 10:209.8
>   rwsem/0:1	    10		1:1306 , 5:1733 , 10:1998
>   rwsem/1:1	    10		1:1512 , 5:1602 , 10:2093
>   rwsem/10:1	    10		1:1267 , 5:1458 , 10:2233
> 
> % Change:
>   rwsem/0:1	     2		1:-52.5%, 5:-33.7%, 10:-31.1%
>   rwsem/1:1	     2		1:-93.5%, 5:-91.9%, 10:-88.7%
>   rwsem/10:1	     2		1:-81.1%, 5:-77.0%, 10:-74.6%
>   rwsem/0:1	    10		1:-76.8%, 5:-69.7%, 10:-64.8%
>   rwsem/1:1	    10		1:-89.6%, 5:-89.0%, 10:-85.8%
>   rwsem/10:1	    10		1:-78.6%, 5:-75.6%, 10:-62.2%

So at a very low level you see nicer results, which aren't really
translating to much of a significant impact at a higher level (aim7).

> It can be seen that there is dramatic reduction in the execution
> times. The new rwsem is now even faster than mutex whether it is all
> writers or a mixture of writers and readers.
> 
> Running the AIM7 benchmarks on the same 40-core system (HT off),
> the performance improvements on some of the workloads were as follows:
> 
>       Workload	     Before Patch	After Patch	% Change
>       --------	     ------------	-----------	--------
>   custom (200-1000)	446135		  477404	 +7.0%
>   custom (1100-2000)	449665		  484734	 +7.8%
>   high_systime		152437		  154217	 +1.2%
>    (200-1000)
>   high_systime		269695		  278942	 +3.4%
>    (1100-2000)

I worry about complicating rwsems even _more_ than they are, specially
for such a marginal gain. You might want to try other workloads -- ie:
postgresql (pgbench), I normally get pretty useful data when dealing
with rwsems.
