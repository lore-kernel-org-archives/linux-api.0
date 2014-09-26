From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/2] perf: Add sampling of the raw monotonic clock
Date: Fri, 26 Sep 2014 13:25:08 -0600
Message-ID: <5425BD94.4030006@gmail.com>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>	 <1411491787-25938-2-git-send-email-pawel.moll@arm.com>	 <87sijhk21x.fsf@sejong.aot.lge.com> <1411642198.4768.30.camel@hornet>	 <8738bekith.fsf@sejong.aot.lge.com>  <1411729103.3852.19.camel@hornet>	 <1411742306.1669.6.camel@leonhard> <1411743959.3852.45.camel@hornet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411743959.3852.45.camel@hornet>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 9/26/14, 9:05 AM, Pawel Moll wrote:
> To do the correlation you need both timestamps to be "taken"
> simultaneously:
>
>          perf event     user event
>         -----O--------------+-------------O------> t_mono
>              :              |             :
>              :              V             :
>         -----O----------------------------O------> t_perf
>
> Of course it's not possible get both values literally at the same time,
> but placing them in a atomic context a couple of instructions from each
> other still gives pretty good results. The larger this distance is, the

An early patchset on this topic added the realtime clock as an event and 
an ioctl was used to push a sample into the event stream. In that case 
you have wall clock and perf-clock samples taken in the same kernel 
context and about as close together as you can get.

https://lkml.org/lkml/2011/2/27/158
https://lkml.org/lkml/2011/2/27/159

David
