From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Fri, 12 May 2017 14:04:49 -0700
Message-ID: <CAGXu5jJEoTEkOdbVu+AQF8=_NRem3g5vECJYU=n8UNpfHbBHTA@mail.gmail.com>
References: <CAJcbSZEoRyewUtBHvqmNZL9FtT_q42Vmmd-EuC50x-ZRASiHHg@mail.gmail.com>
 <CA+55aFwvQfs_X+paQF6Luc0Rq+W3J2fKuHRou7=ANcquDdXdDA@mail.gmail.com>
 <20170512072802.5a686f23@mschwideX1> <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
 <20170512075458.09a3a1ce@mschwideX1> <CAGXu5jL9vUrn4kpjO+qa4cHmWBypeqP17OGbrMs=5Nz0YpQMZw@mail.gmail.com>
 <CA+55aFzbiBqsYb7vwO=+L4Vp_GOgPu+DBOrq4fBnyzq5DbBehg@mail.gmail.com>
 <CAGXu5j+xmyJ6RhtPw9rUgs7k3sZ1KKWffvyGGG--oPfu9W42ng@mail.gmail.com>
 <20170512202106.GO22219@n2100.armlinux.org.uk> <20170512203044.GI4626@worktop.programming.kicks-ass.net>
 <20170512204556.GP22219@n2100.armlinux.org.uk> <CAGXu5jL6FPuShBpZfi6+XHqOk4gxocUJRYPHT5oR3HYh3xm+sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jL6FPuShBpZfi6+XHqOk4gxocUJRYPHT5oR3HYh3xm+sA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-s390 <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Rik van Riel <rie>
List-Id: linux-api@vger.kernel.org

On Fri, May 12, 2017 at 2:00 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Fri, May 12, 2017 at 1:45 PM, Russell King - ARM Linux
> <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org> wrote:
>> On Fri, May 12, 2017 at 10:30:44PM +0200, Peter Zijlstra wrote:
>>> On Fri, May 12, 2017 at 09:21:06PM +0100, Russell King - ARM Linux wrote:
>>> > On Fri, May 12, 2017 at 12:30:02PM -0700, Kees Cook wrote:
>>> > > I'm clearly not explaining things well enough. I shouldn't say
>>> > > "corruption", I should say "malicious manipulation". The methodology
>>> > > of attacks against the stack are quite different from the other kinds
>>> > > of attacks like use-after-free, heap overflow, etc. Being able to
>>> > > exhaust the kernel stack (either due to deep recursion or unbounded
>>> > > alloca())
>>> >
>>> > I really hope we don't have alloca() use in the kernel.  Do you have
>>> > evidence to support that assertion?
>>> >
>>> > IMHO alloca() (or similar) should not be present in any kernel code
>>> > because we have a limited stack - we have kmalloc() etc for that kind
>>> > of thing.
>>>
>>> On stack variable length arrays get implemented by the compiler doing
>>> alloca(), and we sadly have a few of those around.
>>
>> I hope their size is appropriately limited, but something tells me it
>> would be foolish to assume that.
>>
>>> But yes, fully agreed on the desirability of alloca() and things.
>>
>> Hmm, I wonder if -fno-builtin-alloca would prevent those... it looks
>> like it certainly would prevent an explicit alloca() call.
>
> Building with -Werror=vla is exciting. :)
>
> A lot of it is in crypto (which are relatively static sizes, just
> using function callbacks), but there is plenty more.

I meant to also paste an example (which is harmless, I haven't looked
extensively at other examples):

        unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
        unsigned int size = crypto_tfm_alg_blocksize(tfm);
        u8 buffer[size + alignmask];

Looking at all the places (and having tried to remove a few of these
in pstore), I think it might be quite frustrating to eliminate them
all and then declare VLAs dead. I'm not against trying, though. :)

-Kees

-- 
Kees Cook
Pixel Security
