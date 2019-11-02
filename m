From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH 11/10] pipe: Add fsync() support [ver #2]
Date: Sat, 2 Nov 2019 16:14:45 -0700
Message-ID: <CALCETrWZjW88OY2mh7v8cUU_6XTSJTkQhAfNbSC17AdhEWwVAA@mail.gmail.com>
References: <CAHk-=wj1BLz6s9cG9Ptk4ULxrTy=MkF7ZH=HF67d7M5HL1fd_A@mail.gmail.com>
 <E590C3AF-1D09-4927-B83F-DD0A6A148B6D@amacapital.net> <CAHk-=wgzRU9RjkZG0L9_yrnFN69REkrSokTQOGZMUkvdispvuQ@mail.gmail.com>
 <CAHk-=wgPQutQ8d8kUCvAFi+hfNWgaNLiZPkbg-GXY2DCtD-Z5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wgPQutQ8d8kUCvAFi+hfNWgaNLiZPkbg-GXY2DCtD-Z5Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, USB list <linux-usb@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 2, 2019 at 4:10 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Nov 2, 2019 at 4:02 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But I don't think anybody actually _did_ any of that. But that's
> > basically the argument for the three splice operations:
> > write/vmsplice/splice(). Which one you use depends on the lifetime and
> > the source of your data. write() is obviously for the copy case (the
> > source data might not be stable), while splice() is for the "data from
> > another source", and vmsplace() is "data is from stable data in my
> > vm".
>
> Btw, it's really worth noting that "splice()" and friends are from a
> more happy-go-lucky time when we were experimenting with new
> interfaces, and in a day and age when people thought that interfaces
> like "sendpage()" and zero-copy and playing games with the VM was a
> great thing to do.

I suppose a nicer interface might be:


madvise(buf, len, MADV_STABILIZE);

(MADV_STABILIZE is an imaginary operation that write protects the
memory a la fork() but without the copying part.)

vmsplice_safer(fd, ...);

Where vmsplice_safer() is like vmsplice, except that it only works on
write-protected pages.  If you vmsplice_safer() some memory and then
write to the memory, the pipe keeps the old copy.

But this can all be done with memfd and splice, too, I think.


>
> It turns out that VM games are almost always more expensive than just
> copying the data in the first place, but hey, people didn't know that,
> and zero-copy was seen a big deal.
>
> The reality is that almost nobody uses splice and vmsplice at all, and
> they have been a much bigger headache than they are worth. If I could
> go back in time and not do them, I would. But there have been a few
> very special uses that seem to actually like the interfaces.
>
> But it's entirely possible that we should kill vmsplice() (likely by
> just implementing the semantics as "write()") because it's not common
> enough to have the complexity.

I think this is the right choice.

FWIW, the openssl vmsplice() call looks dubious, but I suspect it's
okay because it's vmsplicing to a netlink socket, and the kernel code
on the other end won't read the data after it returns a response.

--Andy
