From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Mon, 6 Jul 2015 10:10:32 -0700
Message-ID: <CALCETrVg5AyeXW_AGguFoGCPK9_2zeobEgT9JJFsakH6PyQf_A@mail.gmail.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Vagin <avagin@openvz.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 6, 2015 at 1:47 AM, Andrey Vagin <avagin@openvz.org> wrote:
> Currently we use the proc file system, where all information are
> presented in text files, what is convenient for humans.  But if we need
> to get information about processes from code (e.g. in C), the procfs
> doesn't look so cool.
>
> From code we would prefer to get information in binary format and to be
> able to specify which information and for which tasks are required. Here
> is a new interface with all these features, which is called task_diag.
> In addition it's much faster than procfs.
>
> task_diag is based on netlink sockets and looks like socket-diag, which
> is used to get information about sockets.

I think I like this in principle, but I have can see a few potential
problems with using netlink for this:

1. Netlink very naturally handles net namespaces, but it doesn't
naturally handle any other kind of namespace.  In fact, the taskstats
code that you're building on has highly broken user and pid namespace
support.  (Look for some obviously useless init_user_ns and
init_pid_ns references.  But that's only the obvious problem.  That
code calls current_user_ns() and task_active_pid_ns(current) from
.doit, which is, in turn, called from sys_write, and looking at
current's security state from sys_write is a big no-no.)

You could partially fix it by looking at f_cred's namespaces, but that
would be a change of what it means to create a netlink socket, and I'm
not sure that's a good idea.

2. These look like generally useful interfaces, which means that
people might want to use them in common non-system software, which
means that some of that software might get run inside of sandboxes
(Sandstorm, xdg-app, etc.)  Sandboxes like that might block netlink
outright, since it can't be usefully filtered by seccomp.  (This isn't
really the case now, since netlink route queries are too common, but
still.)

3. Netlink is a bit tedious to use from userspace.  Especially for
things like task_diag, which are really just queries that generate
single replies.

Would it make more sense to have a new syscall instead?  You could
even still use nlattr formatting for the syscall results.

--Andy
