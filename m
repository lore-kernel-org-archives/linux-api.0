From: Subrata Modak <subrata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [patch 1/2][RFC] add socketat syscall
Date: Fri, 07 Nov 2008 15:15:05 +0530
Message-ID: <1226051105.5063.17.camel@subratamodak.linux.ibm.com>
References: <20081031215602.655672481@fr.ibm.com>
	 <20081031215900.810348746@fr.ibm.com>
	 <517f3f820811060522i7b3518aen47907a34b38adee9@mail.gmail.com>
	 <cfd18e0f0811060746l77fbe6fel83402ba543fccb38@mail.gmail.com>
	 <491318DC.4000300@fr.ibm.com>
Reply-To: subrata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <491318DC.4000300-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Lezcano <dlezcano-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, vivien.chappelier-L+G57L1VLRbR7s880joybQ@public.gmane.org, andreas.aaen-546VmZ+UeKYX2WXlbB3fKg@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ltp-list <ltp-list-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org>, Veerendra <veeren-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, sudhirkumarmalik <sudhirkumarmalik-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>, Gowrishankar <gowrishankar.m-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thanks Daniel/Michael,

Adding Veerendra, Sudhir & Gowri as they are handling NS tests now and
they may include it in their Plan.

Regards--
Subrata

On Thu, 2008-11-06 at 17:18 +0100, Daniel Lezcano wrote:
> Michael Kerrisk wrote:
> >> On Fri, Oct 31, 2008 at 4:56 PM, Daniel Lezcano <dlezcano-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org> wrote:
> >>> This patch adds the socketat syscall which allows to specify in
> >>> which network namespace we want to create a socket. The network
> >>> namespace destination is referred by a socket fd previously opened
> >>> in the destination network namespace.
> > 
> > Daniel,
> > 
> > Is there any documentation for this system call, and/or test programs?
> 
> Not yet.
> 
> This small patch is a proposition to Andreas and Vivien to have a single 
> process being able to manage several network namespaces.
> 
> When a process unshares the network, it creates a socket which is used 
> as a socket control (it belongs to the network namespace). Each time a 
> network namespace is created, a socket control is created.
> 
> When the process has to create a socket for a specific network 
> namespace, it can use the socket control to specify it. This is the 
> purpose of the socketat syscall.
> 
> One example for a program in userspace:
> 
> int main(int argc, char *argv[])
> {
> 	const int maxunshare = 128;
> 	int scs[maxunshare];
> 	int i, fd;
> 	
> 	for (i = 0; i < maxunshare; i++) {
> 		scs[i] = socket(PF_INET, SOCK_DGRAM, 0);
> 		unshare(CLONE_NEWNET);
> 	}
> 
> 	....
> 
> 	/* I want to create a socket inside the network namespace #10 */
> 
> 	fd = socketat(scs[10], PF_INET, SOCKET_STREAM, 0);
> 
> 	....
> 
> 	bind, listen, etc ...
> }
> 
> >>> Signed-off-by: Daniel Lezcano <dlezcano-NmTC/0ZBporQT0dZR+AlfA@public.gmane.org>
> >>> ---
> >>>  arch/x86/include/asm/unistd_32.h   |    1
> >>>  arch/x86/include/asm/unistd_64.h   |    3 +-
> >>>  arch/x86/kernel/syscall_table_32.S |    1
> >>>  include/linux/syscalls.h           |    1
> >>>  kernel/sys_ni.c                    |    1
> >>>  net/socket.c                       |   45 +++++++++++++++++++++++++++++++++++++
> >>>  6 files changed, 51 insertions(+), 1 deletion(-)
> >>>
> >>> Index: net-next-2.6/arch/x86/include/asm/unistd_32.h
> >>> ===================================================================
> >>> --- net-next-2.6.orig/arch/x86/include/asm/unistd_32.h
> >>> +++ net-next-2.6/arch/x86/include/asm/unistd_32.h
> >>> @@ -338,6 +338,7 @@
> >>>  #define __NR_dup3              330
> >>>  #define __NR_pipe2             331
> >>>  #define __NR_inotify_init1     332
> >>> +#define __NR_socketat           333
> >>>
> >>>  #ifdef __KERNEL__
> >>>
> >>> Index: net-next-2.6/arch/x86/include/asm/unistd_64.h
> >>> ===================================================================
> >>> --- net-next-2.6.orig/arch/x86/include/asm/unistd_64.h
> >>> +++ net-next-2.6/arch/x86/include/asm/unistd_64.h
> >>> @@ -653,7 +653,8 @@ __SYSCALL(__NR_dup3, sys_dup3)
> >>>  __SYSCALL(__NR_pipe2, sys_pipe2)
> >>>  #define __NR_inotify_init1                     294
> >>>  __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
> >>> -
> >>> +#define __NR_socketat                           295
> >>> +__SYSCALL(__NR_socketat, sys_socketat)
> >>>
> >>>  #ifndef __NO_STUBS
> >>>  #define __ARCH_WANT_OLD_READDIR
> >>> Index: net-next-2.6/arch/x86/kernel/syscall_table_32.S
> >>> ===================================================================
> >>> --- net-next-2.6.orig/arch/x86/kernel/syscall_table_32.S
> >>> +++ net-next-2.6/arch/x86/kernel/syscall_table_32.S
> >>> @@ -332,3 +332,4 @@ ENTRY(sys_call_table)
> >>>        .long sys_dup3                  /* 330 */
> >>>        .long sys_pipe2
> >>>        .long sys_inotify_init1
> >>> +       .long sys_socketat
> >>> Index: net-next-2.6/net/socket.c
> >>> ===================================================================
> >>> --- net-next-2.6.orig/net/socket.c
> >>> +++ net-next-2.6/net/socket.c
> >>> @@ -1253,6 +1253,51 @@ out_release:
> >>>        return retval;
> >>>  }
> >>>
> >>> +asmlinkage long sys_socketat(int fd, int family, int type, int protocol)
> >>> +{
> >>> +       int retval, fput_needed;
> >>> +       struct socket *sock;
> >>> +       struct socket *sockat;
> >>> +       struct net *net;
> >>> +       int flags;
> >>> +
> >>> +       /* Check the SOCK_* constants for consistency.  */
> >>> +       BUILD_BUG_ON(SOCK_CLOEXEC != O_CLOEXEC);
> >>> +       BUILD_BUG_ON((SOCK_MAX | SOCK_TYPE_MASK) != SOCK_TYPE_MASK);
> >>> +       BUILD_BUG_ON(SOCK_CLOEXEC & SOCK_TYPE_MASK);
> >>> +       BUILD_BUG_ON(SOCK_NONBLOCK & SOCK_TYPE_MASK);
> >>> +
> >>> +       flags = type & ~SOCK_TYPE_MASK;
> >>> +       if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
> >>> +               return -EINVAL;
> >>> +       type &= SOCK_TYPE_MASK;
> >>> +
> >>> +       if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
> >>> +               flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
> >>> +
> >>> +       sock = sockfd_lookup_light(fd, &retval, &fput_needed);
> >>> +       if (!sock)
> >>> +               goto out;
> >>> +
> >>> +       net = sock_net(sock->sk);
> >>> +
> >>> +       retval = __sock_create(net, family, type, protocol, &sockat, 0);
> >>> +       if (retval)
> >>> +               goto out_fput;
> >>> +
> >>> +       retval = sock_map_fd(sock, flags & (O_CLOEXEC | O_NONBLOCK));
> >>> +       if (retval < 0)
> >>> +               goto out_release;
> >>> +out_fput:
> >>> +       fput_light(sock->file, fput_needed);
> >>> +out:
> >>> +       return retval;
> >>> +
> >>> +out_release:
> >>> +       sock_release(sockat);
> >>> +       goto out;
> >>> +}
> >>> +
> >>>  /*
> >>>  *     Create a pair of connected sockets.
> >>>  */
> >>> Index: net-next-2.6/include/linux/syscalls.h
> >>> ===================================================================
> >>> --- net-next-2.6.orig/include/linux/syscalls.h
> >>> +++ net-next-2.6/include/linux/syscalls.h
> >>> @@ -423,6 +423,7 @@ asmlinkage long sys_recvfrom(int, void _
> >>>                                struct sockaddr __user *, int __user *);
> >>>  asmlinkage long sys_recvmsg(int fd, struct msghdr __user *msg, unsigned flags);
> >>>  asmlinkage long sys_socket(int, int, int);
> >>> +asmlinkage long sys_socketat(int, int, int, int);
> >>>  asmlinkage long sys_socketpair(int, int, int, int __user *);
> >>>  asmlinkage long sys_socketcall(int call, unsigned long __user *args);
> >>>  asmlinkage long sys_listen(int, int);
> >>> Index: net-next-2.6/kernel/sys_ni.c
> >>> ===================================================================
> >>> --- net-next-2.6.orig/kernel/sys_ni.c
> >>> +++ net-next-2.6/kernel/sys_ni.c
> >>> @@ -40,6 +40,7 @@ cond_syscall(sys_send);
> >>>  cond_syscall(sys_recvfrom);
> >>>  cond_syscall(sys_recv);
> >>>  cond_syscall(sys_socket);
> >>> +cond_syscall(sys_socketat);
> >>>  cond_syscall(sys_setsockopt);
> >>>  cond_syscall(compat_sys_setsockopt);
> >>>  cond_syscall(sys_getsockopt);
> >>>
> >>> --
> >>> _______________________________________________
> >>> Containers mailing list
> >>> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> >>> https://lists.linux-foundation.org/mailman/listinfo/containers
> >>>
> >>
> >>
> >> --
> >> Michael Kerrisk Linux man-pages maintainer;
> >> http://www.kernel.org/doc/man-pages/ Found a documentation bug?
> >> http://www.kernel.org/doc/man-pages/reporting_bugs.html
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > 
> > 
> > 
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
