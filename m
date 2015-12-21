From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v1 1/4] um: Fix ptrace GETREGS/SETREGS bugs
Date: Mon, 21 Dec 2015 11:13:33 +0100
Message-ID: <5677D0CD.1070602@nod.at>
References: <1450656209-2676-1-git-send-email-mic@digikod.net>
 <1450656209-2676-2-git-send-email-mic@digikod.net> <567745E3.1030509@nod.at>
 <5677BD23.4060602@digikod.net> <5677BFBD.3090200@nod.at>
 <5677C526.5070803@digikod.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090405060008050504000809"
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <5677C526.5070803@digikod.net>
Sender: linux-doc-owner@vger.kernel.org
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Jeff Dike <jdike@addtoit.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuahkh@osg.samsung.com>, Chris Metcalf <cmetcalf@ezchip.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, James Hogan <james.hogan@imgtec.com>, Thomas Meyer <thomas@m3y3r.de>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Anton Ivanov <aivanov@brocade.com>, linux-doc@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-api@vger.kernel.org, Meredydd Luff <meredydd@senatehouse.org>, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------090405060008050504000809
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Am 21.12.2015 um 10:23 schrieb Mickaël Salaün:
>>>> Doesn't this break the support for changing syscall numbers using PTRACE_SETREGS?
>>>
>>> The logic is unchanged except updating the UPT_SYSCALL_NR before syscall_trace_enter(). I did my last tests with the x86_32 subarchitecture and all tests (from selftest/seccomp), including PTRACE_SETREGS for syscall numbers tests, passed. However, 2 of this tests still fail for x86_64 (only).
>>
>> No, the logic is different.
>> syscall_trace_enter(regs) enters the ptrace() path and here registers can be changed.
>> Hence "syscall = UPT_SYSCALL_NR(r);" will see the old syscall number.
>> UPT_SYSCALL_NR() returns the syscall number before the ptrace() path...
> 
> The thing is, PTRACE_SETREGS give access to *orig_ax* in the user_regs_struct from arch/x86/include/asm/user_*.h and selftest/seccomp only update this (virtual) register, not the EAX/RAX. Am I missing something?

Sorry, meant orig...

Please see the attached program. It proves that your patch is breaking stuff.
The test is extracted from UML's selftests.

Thanks,
//richard

--------------090405060008050504000809
Content-Type: text/x-csrc;
 name="ptsc.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ptsc.c"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <signal.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/user.h>
#include <sys/syscall.h>
#include <sys/reg.h>

#define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
#define PT_OFFSET(r) ((r) * sizeof(long))
#define PT_SYSCALL_NR_OFFSET PT_OFFSET(ORIG_RAX)
#define PTRACE_OLDSETOPTIONS      21

static void ptrace_child(void)
{
        int ret;
        int pid = syscall(__NR_getpid), ppid = getppid();
        int sc_result;

        if (ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
                perror("ptrace");
                kill(pid, SIGKILL);
        }
        kill(pid, SIGSTOP);

        /*
         * This syscall will be intercepted by the parent. Don't call more than
         * once, please.
         */
        sc_result = syscall(__NR_getpid);

        if (sc_result == pid)
                /* Nothing modified by the parent, we are running normally. */
                ret = 1;
        else if (sc_result == ppid)
                /*
                 * Expected in check_ptrace and check_sysemu when they succeed
                 * in modifying the stack frame
                 */
                ret = 0;
        else
                /* Serious trouble! This could be caused by a bug in host 2.6
                 * SKAS3/2.6 patch before release -V6, together with a bug in
                 * the UML code itself.
                 */
                ret = 2;

        exit(ret);
}

static int stop_ptraced_child(int pid, int exitcode, int mustexit)
{
        int status, n, ret = 0;

        if (ptrace(PTRACE_CONT, pid, 0, 0) < 0) {
                perror("stop_ptraced_child : ptrace failed");
                return -1;
        }
        CATCH_EINTR(n = waitpid(pid, &status, 0));
        if (!WIFEXITED(status) || (WEXITSTATUS(status) != exitcode)) {
                int exit_with = WEXITSTATUS(status);
                if (exit_with == 2)
                        printf("check_ptrace : child exited with status 2. "
                                  "\nDisabling SYSEMU support.\n");
                printf("check_ptrace : child exited with exitcode %d, while "
                          "expecting %d; status 0x%x\n", exit_with,
                          exitcode, status);
                if (mustexit)
                        exit(1);
                ret = -1;
        }

        return ret;
}


static int start_ptraced_child(void)
{
        int pid, n, status;

        pid = fork();
        if (pid == 0)
                ptrace_child();
        else if (pid < 0)
                printf("start_ptraced_child : fork failed");

        CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
        if (n < 0)
                printf("check_ptrace : waitpid failed");
        if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP))
                printf("check_ptrace : expected SIGSTOP, got status = %d",
                      status);

        return pid;
}

static void check_ptrace(void)
{       
        int pid, syscall, n, status;
        
        printf("Checking that ptrace can change system call numbers...");
	fflush(stdout);

        pid = start_ptraced_child();

        if ((ptrace(PTRACE_OLDSETOPTIONS, pid, 0,
                   (void *) PTRACE_O_TRACESYSGOOD) < 0))
                printf("check_ptrace: PTRACE_OLDSETOPTIONS failed");

        while (1) {
                if (ptrace(PTRACE_SYSCALL, pid, 0, 0) < 0)
                        printf("check_ptrace : ptrace failed");
                
                CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
                if (n < 0)
                        printf("check_ptrace : wait failed");
                
                if (!WIFSTOPPED(status) ||
                   (WSTOPSIG(status) != (SIGTRAP | 0x80)))
                        printf("check_ptrace : expected (SIGTRAP|0x80), "
                               "got status = %d", status);
                
                syscall = ptrace(PTRACE_PEEKUSER, pid, PT_SYSCALL_NR_OFFSET,
                                 0);
                if (syscall == __NR_getpid) {
                        n = ptrace(PTRACE_POKEUSER, pid, PT_SYSCALL_NR_OFFSET,
                                   __NR_getppid);
                        if (n < 0)
                                printf("check_ptrace : failed to modify "
                                             "system call");
                        break;
                }
        }
        stop_ptraced_child(pid, 0, 1);
        printf("OK\n");
}

int main(void)
{
	check_ptrace();

	return 0;
}

--------------090405060008050504000809--
