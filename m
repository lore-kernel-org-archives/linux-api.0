From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/3] perf: Userspace event
Date: Wed, 05 Nov 2014 15:36:31 +0900
Message-ID: <878ujqw3v4.fsf@sejong.aot.lge.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	<1415060918-19954-3-git-send-email-pawel.moll@arm.com>
	<87ppd35vbk.fsf@sejong.aot.lge.com>
	<1415119331.24819.19.camel@arm.com>
	<20141104184031.GM10501@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141104184031.GM10501-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org> (Peter
	Zijlstra's message of "Tue, 4 Nov 2014 19:40:31 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <public-peterz-wEGCiKHe2LqWVfeAwA7xHQ-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>
Cc: Pawel Moll <public-pawel.moll-5wv7dgnIgG8-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Namhyung Kim <public-namhyung-DgEjT+Ai2ygdnm+yROfE0A-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Richard Cochran <public-richardcochran-Re5JQEeQqe8AvxtiuMwx3w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Steven Rostedt <public-rostedt-nx8X9YLhiw1AfugRpC6u6w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Ingo Molnar <public-mingo-H+wXaHxf7aLQT0dZR+AlfA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Paul Mackerras <public-paulus-eUNUBHrolfbYtjvyW6yDsg-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Arnaldo Carvalho de Melo <public-acme-DgEjT+Ai2ygdnm+yROfE0A-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, John Stultz <public-john.stultz-QSEj5FYQhm4dnm+yROfE0A-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Masami Hiramatsu <public-masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Christopher Covington <public-cov-sgV2jX0FEOL9JmXXK+q4OQ-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, David Ahern <public-dsahern-Re5JQEeQqe8AvxtiuMwx3w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Thomas Gleixner <public-tglx-hfZtesqFncYOwBW4kG4KsQ-wOFGN7rlS/N+urZeOPWqwQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org



Hi Peter and Pawel,

On Tue, 4 Nov 2014 19:40:31 +0100, Peter Zijlstra wrote:
> On Tue, Nov 04, 2014 at 04:42:11PM +0000, Pawel Moll wrote:
>> 
>> 1. I'm wrong and the record doesn't have to be padded to make it 8 bytes
>> aligned. Then I can drop the additional size field.
>
> No, you're right, we're supposed to stay 8 byte aligned.
>
>> 2. I could impose a limitation on the prctl API that the data size must
>> be 8 bytes aligned. Bad idea in my opinion, I'd rather not.
>
> Agreed.
>
>> 3. The additional size (for the data part) field stays. Notice that
>> PERF_SAMPLE_RAW has it as well :-)
>
> Right, with binary data there is no other day. With \0 terminated
> strings there won't be a problem, but I think we decided we wanted to
> allow any binary blow.

Ah, I missed that.  Thank you guys for explanation.

Thanks,
Namhyung
