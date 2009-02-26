From: Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
Date: Fri, 27 Feb 2009 10:19:08 +1300
Message-ID: <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
References: <20090226133339.875832967@linutronix.de>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090226133339.875832967-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thomas,

Please CC linux-api@ (http://thread.gmane.org/gmane.linux.ltp/5658/)
on patches that change the k-u interface...

Further comments below.

On 2/27/09, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> sys_kill has a counterpart sys_tgkill which allows to send signals to
> a particular thread. sys_rt_sigqueueinfo is lacking such a counterpart.
>
> Aside of the asymetry it is a show stopper for migrating applications
> from other unix-alike RTOSes.
>
> The following patch series implements rt_tgsigqueueinfo and hooks it
> up for x86.
>
> Find below the raw documentation.

I haven't looked at this iteration of the patch, to check if it is
different from the version you posted a few months ago.  I assume it
isn't different, since you didn't mention any differences.  In that
case, there are still the questions I raised back then, so I'll just
repeat them now.

Back in October, I did some testing of this interface.  Two potential
issues that I saw, both of which relate to inconsistencies with
rt_sigqueueinfo():

1) With rt_siqueueinfo(), we can get the PID (TGID) of the sender,
which enables the receiver of the signal to know who the sender was,
and perhaps use that information to (for example) send a signal in the
other direction.

With rt_tgsigqueueinfo(), we don't quite have that ability: all that
the receiver gets is the TGID of the sender, not the TID.  This means
that we can't (for example) send a signal back to the precise thread
that signaled us. I'm not sure if this matters or not (but perhaps it
might when sender and receiver are in the same process?).  I'm also
not sure whether we want to do anything about this (i.e., extending
siginfo_t to include a si_tid field), but I wanted to point out this
assymetry w.r.t. to rt_sigqueueinfo(), in case you had not considered
it.

2) With rt_sigqueueinfo(), we can specify the si_pid and and si_uid
fields that should be sent to the receiver.  This is not possible with
rt_tgsigqueueinfo(), which always supplied the caller';s PID and UID
in the si_pid and si_uid fields sent to the receiver.  See the
following, created using my test programs below (the 111 & 222
arguments to t_*sigqueueinfo set the si_pid and si_uid fields in the
siginfo_t given to the *sigqueueinfo() syscall):

$ ./multithread_sig_receiver 0
Main: TGID = 11711; TID = 11711
Main: blocked signals
Thread 1: PID = 11711; TID = 11712
Thread 1: about to wait for signals
Thread 0: about to wait for signals
                        $ ./t_rt_sigqueueinfo 11711 44 1 -1 111 222
                        My PID is 11714
Thread 0: got signal: si_signo=44 si_code=-1 si_pid=111 si_uid=222
si_value.sival_int=1
                        $ ./t_rt_tgsigqueueinfo 11711 11712 44 1 -1 111 222
                        My PID is 11715
Thread 1: got signal: si_signo=44 si_code=-1 si_pid=11715 si_uid=1000
si_value.sival_int=1

The problem is the different code paths taken by
rt_tgsigqueueinfo()/tgkill() versus rt_sigqueueinfo():

sys_rt_sigqueueinfo()  sys_tgkill()                sys_rt_sigqueueinfo()
        |                   |                              |
        v                   v                              v
do_rt_sigqueueinfo()   do_tkill()                  kill_proc_info()
        |                   |                              |
        |                   v                              v
        +------------> do_send_specific()          kill_pid_info()
                            |                              |
                            v                              v
                       specific_send_sig_info()    group_send_sig_info()
                            |                              |
                            |                              v
                            |                      __group_send_sig_info()
                            |                              |
                            |                              v
                            +--------------------> send_signal()

And in do_send_specifc() there are the lines:

        info->si_pid = task_tgid_vnr(current);
        info->si_uid = current->uid;

I suspect this should be fixed to be consistent with sigqueueinfo().

Cheers,

Michael

=====

/*#* multithread_sig_receiver.c

   Copyright 2008, Linux Foundation;
   written by Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
*/
#define _GNU_SOURCE
#include <sys/syscall.h>
#include <ctype.h>
#include <unistd.h>
#include <signal.h>
#include <pthread.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

#define errExitEN(en, msg) \
                        do { errno = en; perror(msg); \
                             exit(EXIT_FAILURE); } while (0)

static sigset_t test_sigs;

struct thread_arg {
    int   thread_num;
    char *argv_string;
};

static pid_t
gettid(void)
{
    return syscall(SYS_gettid);
}

#if 0
static void
handler(int sig, siginfo_t *si, void *uc)
{
    printf("PID = %ld; TID = %ld; caught signal %d: \n",
            (long) getpid(), (long) gettid(), sig);
    printf("%p\n", si);
    printf("si_signo=%d ", si->si_signo);
    printf("si_code=%d ", si->si_code);
    printf("si_pid=%ld ", (long) si->si_pid);
    printf("si_uid=%ld ", (long) si->si_uid);
    printf("si_value.sival_int=%d\n", si->si_value.sival_int);
}
#endif

static void
wait_for_signals(int tnum)
{
    siginfo_t si;

    printf("Thread %d: about to wait for signals\n", tnum);

    for (;;) {
        if (sigwaitinfo(&test_sigs, &si) == -1)
            errExit("sigwaitinfo");
        printf("Thread %d: got signal: ", tnum);
        printf("si_signo=%d ", si.si_signo);
        printf("si_code=%d ", si.si_code);
        printf("si_pid=%ld ", (long) si.si_pid);
        printf("si_uid=%ld ", (long) si.si_uid);
        printf("si_value.sival_int=%d\n", si.si_value.sival_int);
    }
} /* wait_for_signals */


static void *
threadFunc(void *arg)
{
    struct thread_arg *ta = (struct thread_arg *) arg;
    int nsecs;

    printf("Thread %d: PID = %ld; TID = %ld\n", ta->thread_num,
            (long) getpid(), (long) gettid());

    nsecs = atoi(ta->argv_string);

    if (nsecs > 0) {
        printf("Thread %d: sleeping\n", ta->thread_num);
        sleep(nsecs);
        printf("Thread %d: finished sleeping\n", ta->thread_num);
    }

    wait_for_signals(ta->thread_num);
    return NULL;        /* NOTREACHED */
} /* threadFunc */


#define MAX_ARGS 1000

int
main(int argc, char *argv[])
{
    pthread_t t;
    int s, j;
//    struct sigaction sa;
    struct thread_arg ta[MAX_ARGS];
    sigset_t new;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s <nsecs>...\n", argv[0]);
        fprintf(stderr, "Each <nsecs> argument causes a separate "
                "thread to be created;\n");
        fprintf(stderr, "The thread sleeps <nsecs> seconds before "
                "accepting signals with sigwaitinfo()\n");

        fprintf(stderr, "\n");
        exit(EXIT_SUCCESS);
    }

    if (argc > MAX_ARGS) {
        fprintf(stderr, "Too many arguments\n");
        exit(EXIT_SUCCESS);
    }

    sigemptyset(&test_sigs);
    for (s = 1; s < NSIG; s++)
        if (s != SIGINT && s != SIGQUIT && s != SIGTERM)
            sigaddset(&test_sigs, s);

    sigemptyset(&new);
    if (sigprocmask(SIG_SETMASK, &new, NULL) == -1)
        errExit("sigprocmask");

#if 0
    for (s = 1; s < NSIG; s++) {
        if (sigismember(&test_sigs, s)) {
            sa.sa_flags = SA_SIGINFO;
            sa.sa_sigaction = handler;
            sigemptyset(&sa.sa_mask);
            if (sigaction(s, &sa, NULL) == -1 && errno != EINVAL)
                errExit("sigaction");
        }
    }
    printf("Established handler for signals\n");
#endif

    printf("Main: TGID = %ld; TID = %ld\n",
            (long) getpid(), (long) gettid());

    s = pthread_sigmask(SIG_SETMASK, &test_sigs, NULL);
    if (s != 0)
        errExit("pthread_sigmask");
    printf("Main: blocked signals\n");

    for (j = 0; j + 1 < argc; j++) {
        ta[j].thread_num = j + 1;
        ta[j].argv_string = argv[j + 1];

        s = pthread_create(&t, NULL, threadFunc, &ta[j]);
        if (s != 0)
            errExitEN(s, "pthread_create");
    }

    wait_for_signals(0);
} /* main */

=====

/*#* t_rt_tgsigqueueinfo.c

   Copyright 2008, Linux Foundation;
   written by Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
*/
#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <signal.h>
#include <sys/types.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

#if defined(__i386__)
#define SYS_rt_tgsigqueueinfo 333
#endif

static int
rt_tgsigqueueinfo(pid_t tgid, pid_t tid, int sig, siginfo_t *si)
{
    return syscall(SYS_rt_tgsigqueueinfo, tgid, tid, sig, si);
}


int
main(int argc, char *argv[])
{
    pid_t tgid, tid;
    siginfo_t si;
    int sig, val;

    if (argc < 5) {
        fprintf(stderr, "Usage: %s <tgid> <tid> <sig> <val> "
                "[<si_code> [<si_pid [<si_uid>]]]\n", argv[0]);
        exit(EXIT_SUCCESS);
    }

    printf("My PID is %ld\n", (long) getpid());

    tgid = atoi(argv[1]);
    tid = atoi(argv[2]);
    sig = atoi(argv[3]);
    val = atoi(argv[4]);

    si.si_signo = sig + 1;
    si.si_code = (argc > 5) ? atoi(argv[5]) : SI_QUEUE;
    si.si_pid = (argc > 6) ? atoi(argv[6]) : getpid();
    si.si_uid = (argc > 7) ? atoi(argv[7]) : getuid();
    si.si_value.sival_int = val;

    /*
    printf("Sending: si.si_signo = %d, si.si_code = %d, "
            "si.si_pid = %ld, si.si_uid = %ld\n",
            si.si_signo, si.si_code, (long) si.si_pid, (long) si.si_uid);
    */
    if (rt_tgsigqueueinfo(tgid, tid, sig, &si) == -1)
        errExit("rt_tgsigqueueinfo");

    exit(EXIT_SUCCESS);
} /* main */

=====

/*#* t_rt_sigqueueinfo.c

   Copyright 2008, Linux Foundation;
   written by Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
*/
#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <signal.h>
#include <sys/types.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

static int
rt_sigqueueinfo(pid_t tgid, int sig, siginfo_t *si)
{
    return syscall(SYS_rt_sigqueueinfo, tgid, sig, si);
}


int
main(int argc, char *argv[])
{
    pid_t tgid;
    siginfo_t si;
    int sig, val;

    if (argc < 4) {
        fprintf(stderr, "Usage: %s <tgid> <sig> <val> "
                "[<si_code> [<si_pid [<si_uid>]]]\n", argv[0]);
        exit(EXIT_SUCCESS);
    }

    printf("My PID is %ld\n", (long) getpid());

    tgid = atoi(argv[1]);
    sig = atoi(argv[2]);
    val = atoi(argv[3]);

    si.si_signo = sig + 1;
    si.si_code = (argc > 4) ? atoi(argv[4]) : SI_QUEUE;
    si.si_pid = (argc > 5) ? atoi(argv[5]) : getpid();
    si.si_uid = (argc > 6) ? atoi(argv[6]) : getuid();
    si.si_value.sival_int = val;

    /*
    printf("Sending: si.si_signo = %d, si.si_code = %d, "
            "si.si_pid = %ld, si.si_uid = %ld\n",
            si.si_signo, si.si_code, (long) si.si_pid, (long) si.si_uid);
    */
    if (rt_sigqueueinfo(tgid, sig, &si) == -1)
        errExit("rt_sigqueueinfo");

    exit(EXIT_SUCCESS);
} /* main */

=====



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
