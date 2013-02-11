From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without dequeuing signals (v2)
Date: Mon, 11 Feb 2013 10:29:50 +0100
Message-ID: <201302111029.50998.vda.linux@googlemail.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org> <20130208191056.GA13674@redhat.com> <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>, Andrey Wagin <avagin@gmail.com>, linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

On Friday 08 February 2013 21:15, Michael Kerrisk (man-pages) wrote:
> >> >Damn. But after I wrote this email I realized that llseek() probably can't
> >> > work. Because peek_offset/f_pos/whatever has to be shared with all processes
> >> > which have this file opened.
> >
> > Yes. but I thought you decided to ignore this oddity ;)
> >
> >> So I want to suggest a way how to forbid read() for SIGNALFD_PEEK.
> >> file->f_pos can be initialized to -1. read() returns EINVAL in this
> >> case. In a man page we will write that signals can be dumped only with
> >> help pread(). Is it overload or too ugly?
> >
> > Well. I do not know. Up to you and Michael.
> >
> > But honestly, I can't say this all looks really nice. And why do we
> > need SIGNALFD_PEEK then?
> 
> It surely is no beauty. The hope is at least to make it less ugly than it was.
> 
> > Seriously, perhaps we should simply add signalfd_fops->ioctl() for PEEK.
> > Or add PTRACE_{PEEK,POKE}_SIGNAL which looks even logical and useful...
> > And much simpler/straightforward.
> >
> > But I am not going to argue.

ptrace interface might find some use in debuggers.
Not that any of them expressed such desires so far,
but just maybe.

However, it needs coding in C to read it,
which brings me to:


> I suppose I had wondered along similar lines, but in a slightly
> different direction: would the use of a /proc interface to get the
> queued signals make some sense?

I think that /proc interface beats adding magic flags and magic semantic
to [p]read.

It also has the benefit of being human-readable. You don't need
to write a special C program to "cat /proc/$$/foo".

Andrey, I know that it is hard to let go of the code you invested time
and efforts in creating. But this isn't the last patch, is it?
You will need to retrieve yet more data for process checkpointing.
When you start working on the next patch for it, consider trying
/proc approach.

-- 
vda
