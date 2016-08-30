From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers
 per syscall
Date: Tue, 30 Aug 2016 18:03:28 -0400
Message-ID: <20160830180328.4e579db3@gandalf.local.home>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
        <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com>
        <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com>
        <CALCETrWy5cUDJmTVrjSSqWHc4KyxTPjoD7yU7iqTSHfkK4UwvA@mail.gmail.com>
        <20160830152955.17633511@gandalf.local.home>
        <CALCETrXA0XbYuqYzWMJA+KjFS31YL0cTVtrvCnmRY_GMK6oNpw@mail.gmail.com>
        <20160830165830.5e494c43@gandalf.local.home>
        <CALCETrW_bnmqBRp3qWoaWUu=m7Bi19VcH9kMBifyL06JuGGVzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrW_bnmqBRp3qWoaWUu=m7Bi19VcH9kMBifyL06JuGGVzg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, open list <linux-kernel@vger.kernel.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, Marcin Nowakowski <marcin.nowakowski@imgtec.com>
List-Id: linux-api@vger.kernel.org

On Tue, 30 Aug 2016 14:45:05 -0700
Andy Lutomirski <luto@amacapital.net> wrote:

> I wonder: could more of it be dynamically allocated?  I.e. statically
> generate metadata with args and name and whatever but without any nr.
> Then dynamically allocate the map from nr to metadata?

Any ideas on how to do that?

> 
> > >
> > > Could we at least have an array of (arch, nr) instead of just an array
> > > of nrs in the metadata?  
> >
> > I guess I'm not following you on what would be used for "arch".  
> 
> Whatever syscall_get_arch() would return for the syscall.  For x86,
> for example, most syscalls have a compat nr and a non-compat nr.  How
> does tracing currently handle that?

We currently disable tracing compat syscalls.

What the current code does, is that the macro and linker magic creates
a list of meta data structures, that have a name attached to them.

Then on boot up, we scan the list of syscall numbers and then ask the
arch for the system call they represent to get the actual function
itself:

	addr = arch_syscall_addr(i);

where 'i' is the system call nr.

Then the find_syscall_meta(addr) will do a ksyms_lookup to convert the
addr into the system call name, and then search the meta data for one
that has that name attached to it.

Yes it is ugly. But we don't currently have a method to automatically
match the meta data with the system call numbers. The system call
macros only have access to the names and the parameters, not the
numbers that are associated with them.

-- Steve
