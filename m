From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 0/7] [RFC] kernel: add a netlink interface to get
 information about processes
Date: Fri, 20 Feb 2015 12:33:31 -0800
Message-ID: <CALCETrU5BWUrityiHnSnz5fJLynfkEBLrvU9G1RxYFdPzgbGrg@mail.gmail.com>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
 <CALCETrWyQpr-x=No4mK_95gSANL-_fTr3qC7WjT_5TyFQb_rGw@mail.gmail.com>
 <20150218142718.GA30542@paralelels.com> <CALCETrU5B+1g9B3GH2WpPMaB98thXxpL1fAsHjssK1t_fDM_ZQ@mail.gmail.com>
 <20150219213929.GA16250@paralelels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150219213929.GA16250-yYYamFZzV1regbzhZkK2zA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 19, 2015 at 1:39 PM, Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> On Wed, Feb 18, 2015 at 05:18:38PM -0800, Andy Lutomirski wrote:
>> > > I don't suppose this could use real syscalls instead of netlink.  If
>> > > nothing else, netlink seems to conflate pid and net namespaces.
>> >
>> > What do you mean by "conflate pid and net namespaces"?
>>
>> A netlink socket is bound to a network namespace, but you should be
>> returning data specific to a pid namespace.
>
> Here is a good question. When we mount a procfs instance, the current
> pidns is saved on a superblock. Then if we read data from
> this procfs from another pidns, we will see pid-s from the pidns where
> this procfs has been mounted.
>
> $ unshare -p -- bash -c '(bash)'
> $ cat /proc/self/status | grep ^Pid:
> Pid:    15770
> $ echo $$
> 1
>
> A similar situation with socket_diag. A socket_diag socket is bound to a
> network namespace. If we open a socket_diag socket and change a network
> namespace, it will return infromation about the initial netns.
>
> In this version I always use a current pid namespace.
> But to be consistant with other kernel logic, a socket diag has to be
> linked with a pidns where it has been created.
>

Attaching a pidns to every freshly created netlink socket seems odd,
but I don't see a better solution that still uses netlink.

>>
>> On a related note, how does this interact with hidepid?  More
>
> Currently it always work as procfs with hidepid = 2 (highest level of
> security).
>
>> generally, what privileges are you requiring to obtain what data?
>
> It dumps information only if ptrace_may_access(tsk, PTRACE_MODE_READ) returns true

Sounds good to me.

>
>>
>> >
>> > >
>> > > Also, using an asynchronous interface (send, poll?, recv) for
>> > > something that's inherently synchronous (as the kernel a local
>> > > question) seems awkward to me.
>> >
>> > Actually all requests are handled synchronously. We call sendmsg to send
>> > a request and it is handled in this syscall.
>> >  2)               |  netlink_sendmsg() {
>> >  2)               |    netlink_unicast() {
>> >  2)               |      taskdiag_doit() {
>> >  2)   2.153 us    |        task_diag_fill();
>> >  2)               |        netlink_unicast() {
>> >  2)   0.185 us    |          netlink_attachskb();
>> >  2)   0.291 us    |          __netlink_sendskb();
>> >  2)   2.452 us    |        }
>> >  2) + 33.625 us   |      }
>> >  2) + 54.611 us   |    }
>> >  2) + 76.370 us   |  }
>> >  2)               |  netlink_recvmsg() {
>> >  2)   1.178 us    |    skb_recv_datagram();
>> >  2) + 46.953 us   |  }
>> >
>> > If we request information for a group of tasks (NLM_F_DUMP), a first
>> > portion of data is filled from the sendmsg syscall. And then when we read
>> > it, the kernel fills the next portion.
>> >
>> >  3)               |  netlink_sendmsg() {
>> >  3)               |    __netlink_dump_start() {
>> >  3)               |      netlink_dump() {
>> >  3)               |        taskdiag_dumpid() {
>> >  3)   0.685 us    |          task_diag_fill();
>> > ...
>> >  3)   0.224 us    |          task_diag_fill();
>> >  3) + 74.028 us   |        }
>> >  3) + 88.757 us   |      }
>> >  3) + 89.296 us   |    }
>> >  3) + 98.705 us   |  }
>> >  3)               |  netlink_recvmsg() {
>> >  3)               |    netlink_dump() {
>> >  3)               |      taskdiag_dumpid() {
>> >  3)   0.594 us    |        task_diag_fill();
>> > ...
>> >  3)   0.242 us    |        task_diag_fill();
>> >  3) + 60.634 us   |      }
>> >  3) + 72.803 us   |    }
>> >  3) + 88.005 us   |  }
>> >  3)               |  netlink_recvmsg() {
>> >  3)               |    netlink_dump() {
>> >  3)   2.403 us    |      taskdiag_dumpid();
>> >  3) + 26.236 us   |    }
>> >  3) + 40.522 us   |  }
>> >  0) + 20.407 us   |  netlink_recvmsg();
>> >
>> >
>> > netlink is really good for this type of tasks.  It allows to create an
>> > extendable interface which can be easy customized for different needs.
>> >
>> > I don't think that we would want to create another similar interface
>> > just to be independent from network subsystem.
>>
>> I guess this is a bit streamy in that you ask one question and get
>> multiple answers.
>
> It's like seq_file in procfs. The kernel allocates a buffer then fills
> it, copies it into userspace, fills it again, ... repeats these actions.
> And we can read data from file by portions.
>
> Actually here is one more analogy. When we open a file in procfs,
> we sends a request to the kernel and a file path is a request body in
> this case. But in case of procfs, we can't construct requests, we only
> have a set of predefined requests.

Fair enough.  Procfs is also a bit absurd and only makes sense because
it's compatible with lots of tools.  In a totally sane world, I would
argue that you should issue one syscall asking questions about a bit
and you should get answers immediately.

--Andy
