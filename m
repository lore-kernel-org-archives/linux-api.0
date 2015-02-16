From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: RE: [PATCH RFC v3 0/7] epoll: Introduce new syscalls,
 epoll_ctl_batch and epoll_pwait1
Date: Mon, 16 Feb 2015 07:25:40 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BF41130@G9W0766.americas.hpqcorp.net>
References: <1423818243-15410-1-git-send-email-famz@redhat.com>
 <20150215150011.0340686c@lwn.net> <20150216010224.GA32421@ad.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150216010224.GA32421@ad.nay.redhat.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu
List-Id: linux-api@vger.kernel.org

I found the manual pages really confusing so I had a go at rewriting
them - there were places in the manual page that didn't match the
functionality provided by your code as well as I could tell).

My apologies for a few formatting issues though. I still don't like
parts of epoll_pwait1 but it's less confusing than it was.

You are free to take some or all or none of the changes.

I did have a question I marked with **** below about what you
describe and what your code does.

1) epoll_ctl_batch
------------------

NAME
       epoll_ctl_batch - batch control interface for an epoll descriptor

SYNOPSIS

       #include <sys/epoll.h>

       int epoll_ctl_batch(int epfd, int flags,
                           int ncmds, struct epoll_ctl_cmd *cmds);

DESCRIPTION

       This system call is an extension of epoll_ctl(). The primary
       difference is that this system call allows you to batch multiple
       operations with the one system call. This provides a more efficient
       interface for updating events on this epoll file descriptor epfd.

       The flags argument is reserved and must be 0.

       The argument ncmds is the number of cmds entries being passed in.
       This number must be greater than 0.

       Each operation is specified as an element in the cmds array, defined as:

           struct epoll_ctl_cmd {

                  /* Reserved flags for future extension, must be 0. */
                  int flags;

                  /* The same as epoll_ctl() op parameter. */
                  int op;

                  /* The same as epoll_ctl() fd parameter. */
                  int fd;

                  /* The same as the "events" field in struct epoll_event. */
                  uint32_t events;

                  /* The same as the "data" field in struct epoll_event. */
                  uint64_t data;

                  /* Output field, will be set to the return code after this
                   * command is executed by kernel */
                  int result;
           };

       This system call is not atomic when updating the epoll descriptor.
       All entries in cmds are executed in the order provided. If any cmds
       entry fails to be processed no further entries are processed and 
       the number of successfully processed entries is returned.

       Each single operation defined by a struct epoll_ctl_cmd has the same 
       semantics as an epoll_ctl(2) call. See the epoll_ctl() manual page
       for more information about how to correctly setup the members of a
       struct epoll_ctl_cmd.

       Upon completion of the call the result member of each struct epoll_ctl_cmd
       may be set to 0 (sucessfully completed) or an error code depending on the
       result of the command. If the kernel fails to change the result (for
       example the location of the cmds argument is fully or partly read only)
       the result member of each struct epoll_ctl_cmd may be unchanged. 

RETURN VALUE

       epoll_ctl_batch() returns a number greater than 0 to indicate the number
       of cmnd entries processed. If all entries have been processed this will
       equal the ncmds parameter passed in.

       If one or more parameters are incorrect the value returned is -1 with
       errno set appropriately - no cmds entries have been processed when this
       happens.

       If processing any entry in the cmds argument results in an error the
       number returned is the number of the failing entry - this number will be
       less than ncmds. Since ncmds must be greater than 0 a return value of
       0 indicates an error associated with the very first cmds entry. 
       A return value of 0 does not indicate a successful system call.

       To correctly test the return value from epoll_ctl_batch() use code similar
       to the following:

		ret=epoll_ctl_batch(epfd, flags, ncmds, &cmds);
		if (ret < ncmds) {
			if (ret == -1) {
				/* An argument was invalid */
			} else {
				/* ret contains the number of successful entries
                                 * processed. If you (mis?)use it as a C index it
                                 * will index directly to the failing entry to
                                 * get the result use cmds[ret].result which may 
                                 * contain the errno value associated with the
                                 * entry.
                                 */
			}
		} else {
			/* Success */
		}

ERRORS

       EINVAL flags is non-zero, or ncmds is less than or equal to zero, or
              cmds is NULL.

       ENOMEM There was insufficient memory to handle the requested op control
              operation.

       EFAULT The memory area pointed to by cmds is not accessible with read
              permissions.

       In the event that the return value is not the same as the ncmds parameter
       the result member of the failing struct epoll_ctl_cmd will contain a
       negative errno value related to the error. The errno values that can be set
       are those documented on the epoll_ctl(2) manual page.

CONFORMING TO

       epoll_ctl_batch() is Linux-specific.

SEE ALSO

       epoll_create(2), epoll_ctl(2), epoll_wait(2), epoll_pwait(2), epoll(7)


2) epoll_pwait1
---------------

NAME
       epoll_pwait1 - wait for an I/O event on an epoll file descriptor

SYNOPSIS

       #include <sys/epoll.h>

       int epoll_pwait1(int epfd, int flags,
                        struct epoll_event *events,
                        int maxevents,
                        struct epoll_wait_params *params);

DESCRIPTION

       The epoll_pwait1() syscall differs from epoll_pwait() only in
       parameter list. The epfd, events and maxevents parameters are the same
       as in epoll_wait() and epoll_pwait(). The flags and params are new.

       The flags is reserved and must be zero.

       The params is a pointer to a struct epoll_wait_params which is
       defined as:

           struct epoll_wait_params {
               int clockid;
               struct timespec timeout;
               sigset_t *sigmask;
               size_t sigsetsize;
           };

       The clockid member must be either CLOCK_REALTIME or CLOCK_MONOTONIC.
       This will choose the clock type to use for timeout. This differs to
       epoll_pwait(2) which has an implicit clock type of CLOCK_MONOTONIC.
       
       The timeout member specifies the minimum time that epoll_wait(2) will
       block. The time spent waiting will be rounded up to the clock
       granularity. Kernel scheduling delays mean that the blocking
       interval may overrun by a small amount. Specifying a -1 for either
       tv_sec or tv_nsec member of the struct timespec timeout will cause
       causes epoll_pwait1(2) to block indefinitely. Specifying a timeout
       equal to zero (both tv_sec or tv_nsec member of the struct timespec
       timeout are zero) causes epoll_wait(2) to return immediately, even
       if no events are available.

**** Are you really really sure about this for the -1 stuff? your code copies in the timespec and just passes it to timespec_to_ktime:

+	if (copy_from_user(&p, params, sizeof(p)))
+		return -EFAULT;
...
+	kt = timespec_to_ktime(p.timeout);

Compare that to something like the futex syscall which does this:

		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
			return -EFAULT;
		if (!timespec_valid(&ts))
			return -EINVAL;

		t = timespec_to_ktime(ts);

If the timespec is not valid it returns -EINVAL back to user space. With your settings of tv_sec and/or tv_usec to -1 are you relying on a side effect of the conversion that could break your code in the future if in the unlikely event someone changes timespec_to_ktime() and should it be:

+	if (copy_from_user(&p, params, sizeof(p)))
+		return -EFAULT;
+       if ((p.timeout.tv_sec == -1) || (p.timeout.tv_nsec == -1)) {
+  /* this is off the top of my head no idea if it will compile */
+		p.timeout.tv_sec = KTIME_SEC_MAX;
+		p.timeout.tv_nsec = 0;
+	}
+       if (!timespec_valid(&p.timeout))
+       	return -EINVAL;
...
+	kt = timespec_to_ktime(p.timeout);

I could of course be worried about nothing here is what I've suggested the right thing to do? Anyone feel free to chime in.

       Both sigmask and sigsetsize have the same semantics as epoll_pwait(2). The
       sigmask field may be specified as NULL, in which case epoll_pwait1(2)
       will behave like epoll_wait(2).

   User visibility of sigsetsize

       In epoll_pwait(2) and other syscalls, sigsetsize is not visible to
       an application developer as glibc has a wrapper around epoll_pwait(2).
       Now we pack several parameters in epoll_wait_params. In
       order to hide sigsetsize from application code this system call also
       needs to be wrapped either by expanding parameters and building the
       structure in the wrapper function, or by only asking application to
       provide this part of the structure:

           struct epoll_wait_params_user {
               int clockid;
               struct timespec timeout;
               sigset_t *sigmask;
           };

      In the wrapper function it would be copied to a full structure and
      sigsetsize filled in.

RETURN VALUE

       When successful, epoll_wait1() returns the number of file descriptors
       ready for the requested I/O, or zero if no file descriptor became ready
       during the requested timeout nanoseconds. When an error occurs, 
       epoll_wait1() returns -1 and errno is set appropriately.

ERRORS

       This system call can set errno to the same values as epoll_pwait(2), 
       as well as the following additional reasons:

       EINVAL flags is not zero, or clockid is not one of CLOCK_REALTIME or
              CLOCK_MONOTONIC.

       EFAULT The memory area pointed to by params is not accessible.


CONFORMING TO

       epoll_pwait1() is Linux-specific.

SEE ALSO

       epoll_create(2), epoll_ctl(2), epoll_wait(2), epoll_pwait(2), epoll(7)
