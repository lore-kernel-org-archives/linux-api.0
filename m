From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH RESEND v3 3/3] ptrace: add PTRACE_EVENT_SECCOMP
 support to PTRACE_GET_SYSCALL_INFO
Date: Wed, 28 Nov 2018 14:13:48 +0100
Message-ID: <20181128131347.GB30395@redhat.com>
References: <20181125022150.46258a20@akathisia>
 <20181125022340.5703400f@akathisia>
 <20181126143524.GB1660@redhat.com>
 <20181127040732.1c9f7965@akathisia>
 <20181127123116.GA13284@redhat.com>
 <20181127232753.GA18755@altlinux.org>
 <20181128123545.GA30395@redhat.com>
 <20181128124411.GA28206@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128124411.GA28206@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Elvira Khabirova <lineprinter@altlinux.org>, Eugene Syromyatnikov <esyr@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, strace-devel@lists.strace.io
List-Id: linux-api@vger.kernel.org

On 11/28, Dmitry V. Levin wrote:
>
> What about PTRACE_GETSIGINFO?  Can it also be done lockless because
> ptrace_check_attach() has already called ptrace_freeze_traced()?

Yes, only PTRACE_INTERRUPT needs lock_task_sighand() and it can actually
fail because the tracee is not necessarily stopped.

Oleg.
