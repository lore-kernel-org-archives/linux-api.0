From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers per syscall
Date: Tue, 30 Aug 2016 12:53:53 -0700
Message-ID: <CALCETrXA0XbYuqYzWMJA+KjFS31YL0cTVtrvCnmRY_GMK6oNpw@mail.gmail.com>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
 <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com>
 <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com> <CALCETrWy5cUDJmTVrjSSqWHc4KyxTPjoD7yU7iqTSHfkK4UwvA@mail.gmail.com>
 <20160830152955.17633511@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160830152955.17633511-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MIPS Mailing List <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 30, 2016 at 12:29 PM, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> wrote:
> On Tue, 30 Aug 2016 11:52:39 -0700
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>
>
>> Okay, I think I see what's going on.  init_ftrace_syscalls() does:
>>
>>         meta = find_syscall_meta(addr);
>>
>> Unless I'm missing some reason why this is a sensible thing to do,
>> this seems overcomplicated and incorrect.  There is exactly one caller
>> of find_syscall_meta() and that caller knows the syscall number.  Why
>> doesn't it just look up the metadata by *number* instead of by syscall
>> implementation address?  There are plenty of architectures for which
>> multiple logically different syscalls can share an implementation
>> (e.g. pretty much everything that calls in_compat_syscall()).
>
> The problem is that the meta data is created at the syscalls
> themselves. Look at all the macro magic in include/linux/syscalls.h,
> and search for __syscall_metadata. The meta data is created via linker
> magic, and the find_syscall_meta() is what finds a specific system call
> and the meta data associated with it.

Egads!  OK, I see why this is a mess.

I guess we should be creating the metadata from the syscall tables
instead of from the syscall definitions, but I guess that's currently
a nasty per-arch mess.

Could we at least have an array of (arch, nr) instead of just an array
of nrs in the metadata?

--Andy
