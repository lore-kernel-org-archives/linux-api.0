From: Andrey Vagin <avagin@openvz.org>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Thu, 9 Jul 2015 01:49:01 +0300
Message-ID: <CANaxB-yMKGWJ1r0GMR9VfAq_xHn6bTjYmkDXST4suNNqu4GVjA@mail.gmail.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
	<CALCETrVg5AyeXW_AGguFoGCPK9_2zeobEgT9JJFsakH6PyQf_A@mail.gmail.com>
	<20150707154345.GA1593@odin.com>
	<CALCETrVSRkMSAVPz9JW4XCV7DmrgkyGK54HRUrue2R756f5C=Q@mail.gmail.com>
	<20150708161022.GA1705@odin.com>
	<CALCETrW4LU3M2OAWjnckFR-rqenBjV+ROBi8B3eOo=Y_mCWfGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrW4LU3M2OAWjnckFR-rqenBjV+ROBi8B3eOo=Y_mCWfGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Vagin <avagin@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

2015-07-08 20:39 GMT+03:00 Andy Lutomirski <luto@amacapital.net>:
> On Wed, Jul 8, 2015 at 9:10 AM, Andrew Vagin <avagin@odin.com> wrote:
>> On Tue, Jul 07, 2015 at 08:56:37AM -0700, Andy Lutomirski wrote:
>>> On Tue, Jul 7, 2015 at 8:43 AM, Andrew Vagin <avagin@odin.com> wrote:
>>> > On Mon, Jul 06, 2015 at 10:10:32AM -0700, Andy Lutomirski wrote:
>>> >> On Mon, Jul 6, 2015 at 1:47 AM, Andrey Vagin <avagin@openvz.org> wrote:
>>> >> > Currently we use the proc file system, where all information are
>>> >> > presented in text files, what is convenient for humans.  But if we need
>>> >> > to get information about processes from code (e.g. in C), the procfs
>>> >> > doesn't look so cool.
>>> >> >
>>> >> > From code we would prefer to get information in binary format and to be
>>> >> > able to specify which information and for which tasks are required. Here
>>> >> > is a new interface with all these features, which is called task_diag.
>>> >> > In addition it's much faster than procfs.
>>> >> >
>>> >> > task_diag is based on netlink sockets and looks like socket-diag, which
>>> >> > is used to get information about sockets.
>>> >>
>>> >> I think I like this in principle, but I have can see a few potential
>>> >> problems with using netlink for this:
>>> >>
>>> >> 1. Netlink very naturally handles net namespaces, but it doesn't
>>> >> naturally handle any other kind of namespace.  In fact, the taskstats
>>> >> code that you're building on has highly broken user and pid namespace
>>> >> support.  (Look for some obviously useless init_user_ns and
>>> >> init_pid_ns references.  But that's only the obvious problem.  That
>>> >> code calls current_user_ns() and task_active_pid_ns(current) from
>>> >> .doit, which is, in turn, called from sys_write, and looking at
>>> >> current's security state from sys_write is a big no-no.)
>>> >>
>>> >> You could partially fix it by looking at f_cred's namespaces, but that
>>> >> would be a change of what it means to create a netlink socket, and I'm
>>> >> not sure that's a good idea.
>>> >
>>> > If I don't miss something, all problems around pidns and userns are
>>> > related with multicast functionality. task_diag is using
>>> > request/response scheme and doesn't send multicast packets.
>>>
>>> It has nothing to do with multicast.  task_diag needs to know what
>>> pidns and userns to use for a request, but netlink isn't set up to
>>> give you any reasonably way to do that.  A netlink socket is
>>> fundamentally tied to a *net* ns (it's a socket, after all).  But you
>>> can send it requests using write(2), and calling current_user_ns()
>>> from write(2) is bad.  There's a long history of bugs and
>>> vulnerabilities related to thinking that current_cred() and similar
>>> are acceptable things to use in write(2) implementations.
>>>
>>
>> As far as I understand, socket_diag doesn't have this problem, becaus
>> each socket has a link on a namespace where it was created.
>>
>> What if we will pin the current pidns and credentials to a task_diag
>> socket in a moment when it's created.
>
> That's certainly doable.  OTOH, if anything does:
>
> socket(AF_NETLINK, ...);
> unshare(CLONE_PID);
> fork();
>
> then they now have a (minor) security problem.

What do you mean? Is it not the same when we open a file and change
uid and gid? Permissions are checked only in the "open" syscall.

[root@avagin-fc19-cr ~]# ls -l xxx
-rw-r--r-- 1 root root 5 Jul  9 01:42 xxx

open("xxx", O_WRONLY|O_APPEND)          = 3
setgid(1000)                            = 0
setuid(1000)                            = 0
write(3, "a", 1)                        = 1
close(1)                                = 0

>
> --Andy
