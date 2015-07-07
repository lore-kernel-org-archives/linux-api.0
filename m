From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Tue, 7 Jul 2015 09:24:05 -0700
Message-ID: <CALCETrWRT--XO6jYyno_i0nUZEoRuq3S5_n-qFRSt2rmkd3jMQ@mail.gmail.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
 <CALCETrVg5AyeXW_AGguFoGCPK9_2zeobEgT9JJFsakH6PyQf_A@mail.gmail.com>
 <20150707154345.GA1593@odin.com> <CALCETrVSRkMSAVPz9JW4XCV7DmrgkyGK54HRUrue2R756f5C=Q@mail.gmail.com>
 <559BFB9C.5010801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <559BFB9C.5010801@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Andrew Vagin <avagin@odin.com>, Andrey Vagin <avagin@openvz.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 7, 2015 at 9:17 AM, David Ahern <dsahern@gmail.com> wrote:
> On 7/7/15 9:56 AM, Andy Lutomirski wrote:
>>
>> Netlink is fine for these use cases (if they were related to the
>> netns, not the pid ns or user ns), and it works.  It's still tedious
>> -- I bet that if you used a syscall, the user code would be
>> considerable shorter, though. :)
>>
>> How would this be a problem if you used plain syscalls?  The user
>> would make a request, and the syscall would tell the user that their
>> result buffer was too small if it was, in fact, too small.
>
>
> It will be impossible to tell a user what sized buffer is needed. The size
> is largely a function of the number of tasks and number of maps per thread
> group and both of those will be changing. With the growing size of systems
> (I was sparc systems with 1024 cpus) the workload can be 10's of thousands
> of tasks each with a lot of maps (e.g., java workloads). That amounts to a
> non-trivial amount of data that has to be pushed to userspace.
>
> One of the benefits of the netlink approach is breaking the data across
> multiple messages and picking up where you left off. That infrastructure is
> already in place.
>

How does picking up where you left off work?  I assumed the interface
was something along the lines of "give me information starting from
pid N", but maybe I missed something.

--Andy
