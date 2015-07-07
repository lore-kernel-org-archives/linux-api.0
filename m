From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Tue, 07 Jul 2015 10:56:34 -0600
Message-ID: <559C04C2.8090508@gmail.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org> <CALCETrVg5AyeXW_AGguFoGCPK9_2zeobEgT9JJFsakH6PyQf_A@mail.gmail.com> <20150707154345.GA1593@odin.com> <20150707162552.GM3326@kernel.org> <CALCETrWEXRif4pFUzVJq1T=KWKvd=tbEDf-vpr5MJtVK1_RWYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWEXRif4pFUzVJq1T=KWKvd=tbEDf-vpr5MJtVK1_RWYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Vagin <avagin-wo1vFcy6AUs@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 7/7/15 10:27 AM, Andy Lutomirski wrote:
> On Tue, Jul 7, 2015 at 9:25 AM, Arnaldo Carvalho de Melo
> <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Em Tue, Jul 07, 2015 at 06:43:46PM +0300, Andrew Vagin escreveu:
>>> On Mon, Jul 06, 2015 at 10:10:32AM -0700, Andy Lutomirski wrote:
>>>> On Mon, Jul 6, 2015 at 1:47 AM, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>>>> Would it make more sense to have a new syscall instead?  You could
>>>> even still use nlattr formatting for the syscall results.
>>>
>>> Andy, thank you for the feedback. I got your points. I need time to
>>> think about them. I suppose that a new syscall can be more suitable in
>>> this case, and I need time to form a vision of it. If you have any ideas
>>> or thoughts, I would be glad to know about them.
>>
>> If a new syscall would indeed be better for this, then using
>> sys_perf_event_open and on one of the perf_event_attr flip a bit to ask
>> for those PERF_RECORD_{COMM,FORK,PERF_RECORD_MMAP2, etc} to be generated
>> in the perf buffer could make it reuse all the userspace tooling, with
>> really minimal change: flip the bit, don't synthesize it from /proc.
>>
>
> Hmm, that's an interesting thought.
>
> Andrew, would that work for you?

It's an interesting option to look at. It provides a fixed sized ring 
buffer. The dummy event can be used as the event to trigger the 
generation of task data. The LOST event can tell you if the buffer is 
too small.

Of course the devil is in the details. The buffer for event tasks will 
need to be fairly large. That size is only needed for the initial task 
data meaning the global mmap size is not right for it and this 
particular buffer can be reduced after startup.

The initial task detection can generate a flood of data in a very short 
amount of time since kernel side is in a tight loop walking tasks and 
maps and there is nothing to throttle it beyond the buffer filling -- 
and that just means lost data -- and an occasional need_resched check. 
Perhaps the kernel loop will need to pause if the buffer is full to give 
userspace a moment to collect data rather than just dropping it.
