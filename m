From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers
 per syscall
Date: Tue, 30 Aug 2016 19:28:18 -0400
Message-ID: <20160830192818.4e16a674@gandalf.local.home>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
        <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com>
        <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com>
        <CALCETrWy5cUDJmTVrjSSqWHc4KyxTPjoD7yU7iqTSHfkK4UwvA@mail.gmail.com>
        <20160830152955.17633511@gandalf.local.home>
        <CALCETrXA0XbYuqYzWMJA+KjFS31YL0cTVtrvCnmRY_GMK6oNpw@mail.gmail.com>
        <20160830165830.5e494c43@gandalf.local.home>
        <CALCETrW_bnmqBRp3qWoaWUu=m7Bi19VcH9kMBifyL06JuGGVzg@mail.gmail.com>
        <20160830180328.4e579db3@gandalf.local.home>
        <CALCETrWjpcKqFHvxS35Csd3An1QNMXW8yiHChuWfuWTvVu8_ig@mail.gmail.com>
        <20160830183030.3e9f67f0@gandalf.local.home>
        <CALCETrWx+1Pdob8mU_X1hOWPWqj31ihVL3Z1R0PqjVeExZ_HAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWx+1Pdob8mU_X1hOWPWqj31ihVL3Z1R0PqjVeExZ_HAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MIPS Mailing List <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 30 Aug 2016 16:09:04 -0700
Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:

> But none of this should be a problem at all for MIPS, right?  AFAICT
> the only problem for MIPS is that there *is* a mapping from metadata
> to nr.  If that mapping got removed, MIPS should just work, right?

Wait, where's the mapping of metadata to nr. I don't see that, nor do I
see a need for that. The issue is that we have metadata that expresses
how to record a syscall, and we map syscall nr to metadata, because
when tracing is active, the only thing we have to find that metadata is
the syscall nr.

Now if a syscall nr has more than one way to record (a single nr for
multiple syscalls), then we get into trouble. That's why we have
trouble with compat syscalls. The same number maps to different
syscalls, and we don't know how to differentiate that.


> 
> For x86 compat, I think that adding arch should be sufficient.
> Specifically, rather than having just one enter_syscall_files array,
> have one per audit arch.  Then call syscall_get_arch() as well as
> syscall_get_nr() and use both to lookup the metadata.  AFAIK this
> should work on all architectures, although you might need some arch
> helpers to enumerate all the arches and their respective syscall
> tables (and max syscall nrs).

OK, if the regs can get us to the arch, then this might work.

That is, perhaps we can have multiple tables (not really sure how to
make that happen in an arch agnostic way), and then have two functions:

trace_get_syscall_nr(current, regs)
trace_get_syscall_arch(current, regs)

Although, that "arch" may be confusing.

-- Steve
