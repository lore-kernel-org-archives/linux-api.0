From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v8 2/3] pid: Introduce pidfd_getfd syscall
Date: Sun, 5 Jan 2020 14:30:07 +0100
Message-ID: <20200105133005.ezt4y4d4oat55u6h@wittgenstein>
References: <20200103162928.5271-1-sargun@sargun.me>
 <20200103162928.5271-3-sargun@sargun.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200103162928.5271-3-sargun@sargun.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk, gpascutto@mozilla.com, ealvarez@mozilla.com, fweimer@redhat.com, jld@mozilla.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

On Fri, Jan 03, 2020 at 08:29:27AM -0800, Sargun Dhillon wrote:
> This syscall allows for the retrieval of file descriptors from other
> processes, based on their pidfd. This is possible using ptrace, and
> injection of parasitic code to inject code which leverages SCM_RIGHTS
> to move file descriptors between a tracee and a tracer. Unfortunately,
> ptrace comes with a high cost of requiring the process to be stopped,
> and breaks debuggers. This does not require stopping the process under
> manipulation.
> 
> One reason to use this is to allow sandboxers to take actions on file
> descriptors on the behalf of another process. For example, this can be
> combined with seccomp-bpf's user notification to do on-demand fd
> extraction and take privileged actions. One such privileged action
> is binding a socket to a privileged port.
> 
> This also adds the syscall to all architectures at the same time.
> 
> /* prototype */
>   /* flags is currently reserved and should be set to 0 */
>   int sys_pidfd_getfd(int pidfd, int fd, unsigned int flags);
> 
> /* testing */
> Ran self-test suite on x86_64
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>

The prefered way of adding a syscall is to keep the implementation
separate from the wiring up into the syscall tables. So please split the
patch into two:
- [2/4] pidfd_getfd() implementation
- [3/4] pidfd_getfd() wiring up 
otherwise

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
