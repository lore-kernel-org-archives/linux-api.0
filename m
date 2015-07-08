From: Andrew Vagin <avagin-wo1vFcy6AUs@public.gmane.org>
Subject: Re: [PATCH 0/24] kernel: add a netlink interface to get information
 about processes (v2)
Date: Wed, 8 Jul 2015 19:10:24 +0300
Message-ID: <20150708161022.GA1705@odin.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
 <CALCETrVg5AyeXW_AGguFoGCPK9_2zeobEgT9JJFsakH6PyQf_A@mail.gmail.com>
 <20150707154345.GA1593@odin.com>
 <CALCETrVSRkMSAVPz9JW4XCV7DmrgkyGK54HRUrue2R756f5C=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVSRkMSAVPz9JW4XCV7DmrgkyGK54HRUrue2R756f5C=Q@mail.gmail.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 07, 2015 at 08:56:37AM -0700, Andy Lutomirski wrote:
> On Tue, Jul 7, 2015 at 8:43 AM, Andrew Vagin <avagin-wo1vFcy6AUs@public.gmane.org> wrote:
> > On Mon, Jul 06, 2015 at 10:10:32AM -0700, Andy Lutomirski wrote:
> >> On Mon, Jul 6, 2015 at 1:47 AM, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> >> > Currently we use the proc file system, where all information are
> >> > presented in text files, what is convenient for humans.  But if we need
> >> > to get information about processes from code (e.g. in C), the procfs
> >> > doesn't look so cool.
> >> >
> >> > From code we would prefer to get information in binary format and to be
> >> > able to specify which information and for which tasks are required. Here
> >> > is a new interface with all these features, which is called task_diag.
> >> > In addition it's much faster than procfs.
> >> >
> >> > task_diag is based on netlink sockets and looks like socket-diag, which
> >> > is used to get information about sockets.
> >>
> >> I think I like this in principle, but I have can see a few potential
> >> problems with using netlink for this:
> >>
> >> 1. Netlink very naturally handles net namespaces, but it doesn't
> >> naturally handle any other kind of namespace.  In fact, the taskstats
> >> code that you're building on has highly broken user and pid namespace
> >> support.  (Look for some obviously useless init_user_ns and
> >> init_pid_ns references.  But that's only the obvious problem.  That
> >> code calls current_user_ns() and task_active_pid_ns(current) from
> >> .doit, which is, in turn, called from sys_write, and looking at
> >> current's security state from sys_write is a big no-no.)
> >>
> >> You could partially fix it by looking at f_cred's namespaces, but that
> >> would be a change of what it means to create a netlink socket, and I'm
> >> not sure that's a good idea.
> >
> > If I don't miss something, all problems around pidns and userns are
> > related with multicast functionality. task_diag is using
> > request/response scheme and doesn't send multicast packets.
> 
> It has nothing to do with multicast.  task_diag needs to know what
> pidns and userns to use for a request, but netlink isn't set up to
> give you any reasonably way to do that.  A netlink socket is
> fundamentally tied to a *net* ns (it's a socket, after all).  But you
> can send it requests using write(2), and calling current_user_ns()
> from write(2) is bad.  There's a long history of bugs and
> vulnerabilities related to thinking that current_cred() and similar
> are acceptable things to use in write(2) implementations.
> 

As far as I understand, socket_diag doesn't have this problem, becaus
each socket has a link on a namespace where it was created.

What if we will pin the current pidns and credentials to a task_diag
socket in a moment when it's created.

Thanks,
Andrew
