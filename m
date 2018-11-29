From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 1/2] ptrace: save the type of syscall-stop in
 ptrace_message
Date: Thu, 29 Nov 2018 15:47:43 +0100
Message-ID: <20181129144742.GB10645@redhat.com>
References: <20181128130439.GB28206@altlinux.org>
 <20181128130601.GC28206@altlinux.org>
 <20181128134913.GC30395@redhat.com>
 <20181128140533.GF28206@altlinux.org>
 <20181128142006.GE30395@redhat.com>
 <20181128152346.GG28206@altlinux.org>
 <20181128221125.GA2800@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128221125.GA2800@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Michael Ellerman <mpe@ellerman.id.au>, Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromyatnikov <esyr@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org

On 11/29, Dmitry V. Levin wrote:
>
> 2. Document these values

sure, they should be documented and live in include/uapi/,

> chosen to avoid collisions with ptrace_message values
> set by other ptrace events

this is what I can't understand. But to clarify, I don't really care and
won't argue.

If an application wants to use PTRACE_GETEVENTMSG to distinguish entry/exit
(without PTRACE_GET_SYSCALL_INFO) it needs to do wait(status) and check status
anyway, otherwise PTRACE_GETEVENTMSG is simply pointless (wrt syscall entry/
exit). So we do not care if PTRACE_EVENTMSG_SYSCALL_ENTRY conflicts with, say,
SECCOMP_RET_DATA.

> so that PTRACE_GETEVENTMSG users can easily tell
> whether this new semantics is supported by the kernel or not.

Yes. And how much this can help? Again, an application can trivially detect
if this feature implemented or not, and it should do this anyway if it wants
to (try to) use PTRACE_EVENTMSG_SYSCALL_ENTRY/EXIT ?


Again, I won't reallly argue. But if you insist that these values must be
unique then you probably need to add

	BUILD_BUG_ON(PTRACE_EVENTMSG_SYSCALL_ENTRY <= PID_MAX_LIMIT);

?

OK, please forget...

Oleg.
