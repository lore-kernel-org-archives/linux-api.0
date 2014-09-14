From: David Ahern <dsahern@gmail.com>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
Date: Sun, 14 Sep 2014 09:43:12 -0600
Message-ID: <5415B790.5010607@gmail.com>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com> <1410522513-1045-3-git-send-email-pawel.moll@arm.com> <54132F63.1010401@gmail.com> <20140912204444.GA11199@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140912204444.GA11199@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Pawel Moll <pawel.moll@arm.com>, Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 9/12/14, 2:44 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Sep 12, 2014 at 10:37:39AM -0700, David Ahern escreveu:
>> On 9/12/14, 4:48 AM, Pawel Moll wrote:
>>> This patch adds a PERF_COUNT_SW_MARKER event type, which
>>> can be requested by user and a PERF_EVENT_IOC_MARKER
>>> ioctl command which will inject an event of said type into
>>> the perf buffer. The ioctl can take a zero-terminated
>>> string argument, similar to tracing_marker in ftrace,
>>> which will be kept in the "raw" field of the sample.
>>>
>>> The main use case for this is synchronisation of
>>> performance data generated in user space with the perf
>>> stream coming from the kernel. For example, the marker
>>> can be inserted by a JIT engine after it generated
>>> portion of the code, but before the code is executed
>>> for the first time, allowing the post-processor to
>>> pick the correct debugging information. Other example
>>> is a system profiling tool taking data from other
>>> sources than just perf, which generates a marker
>>> at the beginning at at the end of the session
>>> (also possibly periodically during the session) to
>>> synchronise kernel timestamps with clock values
>>> obtained in userspace (gtod or raw_monotonic).
>>
>> Seems really similar to what I proposed in the past:
>>
>> https://lkml.org/lkml/2011/2/27/159
>>
>> Which was rejected.
>
> I took a look at that thread, but just barely, emphasis on that.
>
> Injecting something from userspace, a la ftrace, seems to be something,
> as tglx mentioned, "buried" in that patchset.

Thomas object to an ioctl buried deep in a patch -- newbie mistake.

Peter objected to the ioctl https://lkml.org/lkml/2011/3/1/229

It was not userspace injecting random data into the stream but rather 
forcing the sample to be generated and added to the stream.

David

David
