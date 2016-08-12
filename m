From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] perf_event_open.2: 4.9 PERF_EVENT_IOC_SET_DRV_CONFIGS support
Date: Fri, 12 Aug 2016 11:56:04 -0600
Message-ID: <CANLsYkyKJJ-qHjyzpus6=Cx7OjN5gigBFdd2-cc7e-ezosJTjQ@mail.gmail.com>
References: <1470935365-2097-1-git-send-email-mathieu.poirier@linaro.org> <alpine.DEB.2.11.1608121248100.10883@pianoman.cluster.toy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1608121248100.10883-C8guHiyadNolD86y6aYYU+kYYgab/bYf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vince Weaver <vince-yfjdyHUqu3OsTnJN9+BGXg@public.gmane.org>
Cc: Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12 August 2016 at 10:52, Vince Weaver <vince-yfjdyHUqu3OsTnJN9+BGXg@public.gmane.org> wrote:
> On Thu, 11 Aug 2016, Mathieu Poirier wrote:
>
>> This manpage patch relates to the addition of the
>> PERF_EVENT_IOC_SET_DRV_CONFIGS ioctl.
>>
>> link: http://www.spinics.net/lists/kernel/msg2318998.html
>> Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  man2/perf_event_open.2 | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/man2/perf_event_open.2 b/man2/perf_event_open.2
>> index 3c894ccd1209..315b6a91079a 100644
>> --- a/man2/perf_event_open.2
>> +++ b/man2/perf_event_open.2
>> @@ -2732,6 +2732,12 @@ The argument is a BPF program file descriptor that was created by
>>  a previous
>>  .BR bpf (2)
>>  system call.
>> +.TP
>> +.BR PERF_EVENT_IOC_SET_DRV_CONFIGS " (since Linux 4.9)"
>> +This makes it possible to pass configuration parameters to PMU drivers.
>> +Configuration parameters are specific to each drivers.
>> +
>> +The argument is a pointer to the desired configuration parameters.
>>  .SS Using prctl
>>  A process can enable or disable all the event groups that are
>>  attached to it using the
>
> This is a bit... vague.  So we're adding an interface to allow passing
> arbitrary binary blobs through the perf_event interface?
>
> Is there any structure at all to these blobs?  From the other commit
> messages it looked like you'd be passing in some sort of string.

I am adding an interface to pass PMU specific configuration to the
driver.  Since PMU drivers exist for different architecture and
drivers I am making the mechanism as generic as possible.

In this case the CoreSight Tracers need to know what "sink" to use for
a trace session.  I've enhanced the perf cmd line tool to accept:

perf -e cs_etm/@sink=some_sink_definition/ ....

Everything falling with the '/' that is preceded by a '@' character is
considered PMU driver material.  At this time the perf lexer accept
two format:

"@cfg" and "@cfg=option".  The lexer will strip off the '@' and pass
"cfg" and "cfg=option" to the kernel.

What gets sent down to the kernel is driver specific - it is up to the
PMU drivers to parse and validate what's given to them.

This feature loosely mimics the filter enhancement where it is now
possible to specify:

perf record -e some_event// --filter 'start 0xstart_addr,stop 0xstop_address' or
perf record -e some_event// --filter 'filter 0xstart_address/offset'

Here it is up to the event to supply the mechanic to deal with the
filter specification (I'm doing the same thing).  Keywords "start",
"stop" and "filter" are common to both IntelPT and CoreSight tracers,
making them ideal candidates for parsing in the core.

But for driver specific configuration "sink" is only applicable to
CoreSight tracers...

Writing these lines I realise that "start", "stop" and "filter" are
applicable to only two drivers (IntelPT and CoreSight).  Peter, do you
think I should look for "sink" in the core parser, just like it is
done for filters?

Guidance would be appreciated here.

Mathieu

>
> Vince
