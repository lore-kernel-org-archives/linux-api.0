From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers
 per syscall
Date: Tue, 30 Aug 2016 15:29:55 -0400
Message-ID: <20160830152955.17633511@gandalf.local.home>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
        <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com>
        <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com>
        <CALCETrWy5cUDJmTVrjSSqWHc4KyxTPjoD7yU7iqTSHfkK4UwvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWy5cUDJmTVrjSSqWHc4KyxTPjoD7yU7iqTSHfkK4UwvA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Marcin Nowakowski <marcin.nowakowski@imgtec.com>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, open list <linux-kernel@vger.kernel.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>
List-Id: linux-api@vger.kernel.org

On Tue, 30 Aug 2016 11:52:39 -0700
Andy Lutomirski <luto@amacapital.net> wrote:


> Okay, I think I see what's going on.  init_ftrace_syscalls() does:
> 
>         meta = find_syscall_meta(addr);
> 
> Unless I'm missing some reason why this is a sensible thing to do,
> this seems overcomplicated and incorrect.  There is exactly one caller
> of find_syscall_meta() and that caller knows the syscall number.  Why
> doesn't it just look up the metadata by *number* instead of by syscall
> implementation address?  There are plenty of architectures for which
> multiple logically different syscalls can share an implementation
> (e.g. pretty much everything that calls in_compat_syscall()).

The problem is that the meta data is created at the syscalls
themselves. Look at all the macro magic in include/linux/syscalls.h,
and search for __syscall_metadata. The meta data is created via linker
magic, and the find_syscall_meta() is what finds a specific system call
and the meta data associated with it.

Then it can use the number to system call mapping.

Yes, this code needs some loving.

-- Steve
