From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers per syscall
Date: Tue, 30 Aug 2016 14:45:05 -0700
Message-ID: <CALCETrW_bnmqBRp3qWoaWUu=m7Bi19VcH9kMBifyL06JuGGVzg@mail.gmail.com>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
 <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com>
 <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com> <CALCETrWy5cUDJmTVrjSSqWHc4KyxTPjoD7yU7iqTSHfkK4UwvA@mail.gmail.com>
 <20160830152955.17633511@gandalf.local.home> <CALCETrXA0XbYuqYzWMJA+KjFS31YL0cTVtrvCnmRY_GMK6oNpw@mail.gmail.com>
 <20160830165830.5e494c43@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160830165830.5e494c43-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MIPS Mailing List <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Aug 30, 2016 1:58 PM, "Steven Rostedt" <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> wrote:
>
> On Tue, 30 Aug 2016 12:53:53 -0700
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>
>
> > Egads!  OK, I see why this is a mess.
>
> :-)
>
> >
> > I guess we should be creating the metadata from the syscall tables
> > instead of from the syscall definitions, but I guess that's currently
> > a nasty per-arch mess.
>
> Yep.
>

I wonder: could more of it be dynamically allocated?  I.e. statically
generate metadata with args and name and whatever but without any nr.
Then dynamically allocate the map from nr to metadata?

> >
> > Could we at least have an array of (arch, nr) instead of just an array
> > of nrs in the metadata?
>
> I guess I'm not following you on what would be used for "arch".

Whatever syscall_get_arch() would return for the syscall.  For x86,
for example, most syscalls have a compat nr and a non-compat nr.  How
does tracing currently handle that?

--Andy
