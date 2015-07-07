From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Tue, 07 Jul 2015 10:41:16 -0600
Message-ID: <559C012C.2090900@gmail.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org> <CALCETrVg5AyeXW_AGguFoGCPK9_2zeobEgT9JJFsakH6PyQf_A@mail.gmail.com> <20150707154345.GA1593@odin.com> <CALCETrVSRkMSAVPz9JW4XCV7DmrgkyGK54HRUrue2R756f5C=Q@mail.gmail.com> <559BFB9C.5010801@gmail.com> <CALCETrWRT--XO6jYyno_i0nUZEoRuq3S5_n-qFRSt2rmkd3jMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWRT--XO6jYyno_i0nUZEoRuq3S5_n-qFRSt2rmkd3jMQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andrew Vagin <avagin-wo1vFcy6AUs@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 7/7/15 10:24 AM, Andy Lutomirski wrote:
> On Tue, Jul 7, 2015 at 9:17 AM, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On 7/7/15 9:56 AM, Andy Lutomirski wrote:
>>>
>>> Netlink is fine for these use cases (if they were related to the
>>> netns, not the pid ns or user ns), and it works.  It's still tedious
>>> -- I bet that if you used a syscall, the user code would be
>>> considerable shorter, though. :)
>>>
>>> How would this be a problem if you used plain syscalls?  The user
>>> would make a request, and the syscall would tell the user that their
>>> result buffer was too small if it was, in fact, too small.
>>
>>
>> It will be impossible to tell a user what sized buffer is needed. The size
>> is largely a function of the number of tasks and number of maps per thread
>> group and both of those will be changing. With the growing size of systems
>> (I was sparc systems with 1024 cpus) the workload can be 10's of thousands
>> of tasks each with a lot of maps (e.g., java workloads). That amounts to a
>> non-trivial amount of data that has to be pushed to userspace.
>>
>> One of the benefits of the netlink approach is breaking the data across
>> multiple messages and picking up where you left off. That infrastructure is
>> already in place.
>>
>
> How does picking up where you left off work?  I assumed the interface
> was something along the lines of "give me information starting from
> pid N", but maybe I missed something.

There are different use cases:
1. specific pid

2. specific thread group id

3. all child processes

4. all tasks in the system (perf record/top -a mode)

5. all tasks for a uid is another but not coded yet

The big hitter is 4 in terms of data volume.

Essentially the kernel side changes saves where you are when an skb 
fills -- which task and which map. e.g, see the cb usage in patch 5. On 
return if the task is still there continue dumping its data. If it 
disappeared move on to the next.
