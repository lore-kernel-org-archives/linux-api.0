From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 1/2] ptrace: save the type of syscall-stop in
 ptrace_message
Date: Fri, 30 Nov 2018 12:29:21 +0100
Message-ID: <20181130112920.GD23670@redhat.com>
References: <20181128130439.GB28206@altlinux.org>
 <20181128130601.GC28206@altlinux.org>
 <20181128134913.GC30395@redhat.com>
 <20181128140533.GF28206@altlinux.org>
 <20181128142006.GE30395@redhat.com>
 <20181128152346.GG28206@altlinux.org>
 <20181128221125.GA2800@altlinux.org>
 <20181129144742.GB10645@redhat.com>
 <20181129211044.GA20529@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181129211044.GA20529@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Michael Ellerman <mpe@ellerman.id.au>, Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromyatnikov <esyr@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org

On 11/30, Dmitry V. Levin wrote:
>
> On Thu, Nov 29, 2018 at 03:47:43PM +0100, Oleg Nesterov wrote:
>
> > > so that PTRACE_GETEVENTMSG users can easily tell
> > > whether this new semantics is supported by the kernel or not.
> >
> > Yes. And how much this can help? Again, an application can trivially detect
> > if this feature implemented or not, and it should do this anyway if it wants
> > to (try to) use PTRACE_EVENTMSG_SYSCALL_ENTRY/EXIT ?
>
> How an application can easily detect whether this feature is implemented?

As I already said, it can just do ptrace(PTRACE_GET_SYSCALL_INFO, NULL) ?
If it returns -EIO then this feature is not implemented. Any other error
code (actually EINVAL or EFAULT) means it is implemented.

Oleg.
