From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers
 per syscall
Date: Thu, 1 Sep 2016 11:24:28 -0400
Message-ID: <20160901112428.7c05dede@gandalf.local.home>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
        <20160830152955.17633511@gandalf.local.home>
        <CALCETrXA0XbYuqYzWMJA+KjFS31YL0cTVtrvCnmRY_GMK6oNpw@mail.gmail.com>
        <5227283.eAVLXfitJh@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5227283.eAVLXfitJh@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MIPS Mailing List <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 31 Aug 2016 10:24:56 +0200
Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:

> On Tuesday, August 30, 2016 12:53:53 PM CEST Andy Lutomirski wrote:
> > Egads!  OK, I see why this is a mess.
> > 
> > I guess we should be creating the metadata from the syscall tables
> > instead of from the syscall definitions, but I guess that's currently
> > a nasty per-arch mess.
> >   
> 
> I've been thinking for a while about how to improve the situation
> around adding new syscalls, which currently involves adding a number
> and an entry in a .S file on most architectures (some already have
> their own method to simplify it, and others using a shared table
> in asm-generic).
> 
> I was thinking of extending the x86 way of doing this to all
> architectures, and adding a way to have all future syscalls require
> only one addition in a single file that gets included by the
> architecture specific files for the existing syscalls.
> 
> Assuming we do this, would that work for generating the metadata
> from the same file like we do with
> arch/x86/entry/syscalls/syscall{tbl,hdr}.sh ?

I can't answer this because I'm not sure exactly how you would do this.
Perhaps you could give it a try and code will be the answer to all my
questions ;-)

-- Steve
