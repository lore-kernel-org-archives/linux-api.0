From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers per syscall
Date: Tue, 30 Aug 2016 16:09:04 -0700
Message-ID: <CALCETrWx+1Pdob8mU_X1hOWPWqj31ihVL3Z1R0PqjVeExZ_HAA@mail.gmail.com>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
 <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com>
 <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com> <CALCETrWy5cUDJmTVrjSSqWHc4KyxTPjoD7yU7iqTSHfkK4UwvA@mail.gmail.com>
 <20160830152955.17633511@gandalf.local.home> <CALCETrXA0XbYuqYzWMJA+KjFS31YL0cTVtrvCnmRY_GMK6oNpw@mail.gmail.com>
 <20160830165830.5e494c43@gandalf.local.home> <CALCETrW_bnmqBRp3qWoaWUu=m7Bi19VcH9kMBifyL06JuGGVzg@mail.gmail.com>
 <20160830180328.4e579db3@gandalf.local.home> <CALCETrWjpcKqFHvxS35Csd3An1QNMXW8yiHChuWfuWTvVu8_ig@mail.gmail.com>
 <20160830183030.3e9f67f0@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160830183030.3e9f67f0-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MIPS Mailing List <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 30, 2016 at 3:30 PM, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> wrote:
> On Tue, 30 Aug 2016 15:08:19 -0700
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>
>> On Tue, Aug 30, 2016 at 3:03 PM, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> wrote:
>> > On Tue, 30 Aug 2016 14:45:05 -0700
>> > Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> >
>> >> I wonder: could more of it be dynamically allocated?  I.e. statically
>> >> generate metadata with args and name and whatever but without any nr.
>> >> Then dynamically allocate the map from nr to metadata?
>> >
>> > Any ideas on how to do that?
>>
>> This might be as simple as dropping the syscall_nr field from
>> syscall_metadata.  I admit I'm not familiar with this code at all, but
>> I'm not really sure why that field is needed.  init_ftrace_syscalls is
>> already dynamically allocating an array that maps nr to metadata, and
>> I don't see what in the code actually needs that mapping to be
>> one-to-one or needs the reverse mapping.
>
> The issue is that the syscall trace points are called by a single
> location, that passes in the syscall_nr, and we need a way to map that
> syscall_nr to the metadata.
>
> System calls are really a meta tracepoint. They share a single real
> tracepoint called raw_syscalls:sys_enter and raw_syscalls:sys_exit.
> When you enable a system call like sys_enter_read, what really happens
> is that the sys_enter tracepoint is attached with a function called
> ftrace_syscall_enter().
>
> This calls trace_get_syscall_nr(current, regs), to extract the actual
> syscall_nr that was called. This is used to find the "file" that is
> mapped to the system call (the tracefs file that enabled the system
> call).
>
>         trace_file = tr->enter_syscall_files[syscall_nr];
>
> And the meta data (what is used to tell us what to save) is found with
> the syscall_nr_to_meta() function.
>
> Now the metadata is used to extract the arguments of the system call:
>
>  syscall_get_arguments(current, regs, 0, sys_data->nb_args,
>         etnry->args);
>
> As well as the size needed.
>
> There's no need to map syscall meta to nr, we need a way to map the nr
> to the syscall metadata, and when there's more than a one to one
> mapping, we need a way to differentiate that in the raw syscall
> tracepoints.

But none of this should be a problem at all for MIPS, right?  AFAICT
the only problem for MIPS is that there *is* a mapping from metadata
to nr.  If that mapping got removed, MIPS should just work, right?

For x86 compat, I think that adding arch should be sufficient.
Specifically, rather than having just one enter_syscall_files array,
have one per audit arch.  Then call syscall_get_arch() as well as
syscall_get_nr() and use both to lookup the metadata.  AFAIK this
should work on all architectures, although you might need some arch
helpers to enumerate all the arches and their respective syscall
tables (and max syscall nrs).

--Andy
