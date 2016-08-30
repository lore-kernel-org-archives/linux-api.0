From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers per syscall
Date: Tue, 30 Aug 2016 15:08:19 -0700
Message-ID: <CALCETrWjpcKqFHvxS35Csd3An1QNMXW8yiHChuWfuWTvVu8_ig@mail.gmail.com>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
 <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com>
 <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com> <CALCETrWy5cUDJmTVrjSSqWHc4KyxTPjoD7yU7iqTSHfkK4UwvA@mail.gmail.com>
 <20160830152955.17633511@gandalf.local.home> <CALCETrXA0XbYuqYzWMJA+KjFS31YL0cTVtrvCnmRY_GMK6oNpw@mail.gmail.com>
 <20160830165830.5e494c43@gandalf.local.home> <CALCETrW_bnmqBRp3qWoaWUu=m7Bi19VcH9kMBifyL06JuGGVzg@mail.gmail.com>
 <20160830180328.4e579db3@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160830180328.4e579db3-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MIPS Mailing List <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 30, 2016 at 3:03 PM, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> wrote:
> On Tue, 30 Aug 2016 14:45:05 -0700
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>
>> I wonder: could more of it be dynamically allocated?  I.e. statically
>> generate metadata with args and name and whatever but without any nr.
>> Then dynamically allocate the map from nr to metadata?
>
> Any ideas on how to do that?

This might be as simple as dropping the syscall_nr field from
syscall_metadata.  I admit I'm not familiar with this code at all, but
I'm not really sure why that field is needed.  init_ftrace_syscalls is
already dynamically allocating an array that maps nr to metadata, and
I don't see what in the code actually needs that mapping to be
one-to-one or needs the reverse mapping.

>
>>
>> > >
>> > > Could we at least have an array of (arch, nr) instead of just an array
>> > > of nrs in the metadata?
>> >
>> > I guess I'm not following you on what would be used for "arch".
>>
>> Whatever syscall_get_arch() would return for the syscall.  For x86,
>> for example, most syscalls have a compat nr and a non-compat nr.  How
>> does tracing currently handle that?
>
> We currently disable tracing compat syscalls.
>
> What the current code does, is that the macro and linker magic creates
> a list of meta data structures, that have a name attached to them.
>
> Then on boot up, we scan the list of syscall numbers and then ask the
> arch for the system call they represent to get the actual function
> itself:
>
>         addr = arch_syscall_addr(i);
>
> where 'i' is the system call nr.
>
> Then the find_syscall_meta(addr) will do a ksyms_lookup to convert the
> addr into the system call name, and then search the meta data for one
> that has that name attached to it.
>
> Yes it is ugly. But we don't currently have a method to automatically
> match the meta data with the system call numbers. The system call
> macros only have access to the names and the parameters, not the
> numbers that are associated with them.
>

Yeah, I think I get it now.  But I think my suggestion of removing
syscall_nr entirely might actually work.  You'd have to initialize
more than one syscalls_metadata array, but they could share the
underlying metadata objects.

--Andy


-- 
Andy Lutomirski
AMA Capital Management, LLC
