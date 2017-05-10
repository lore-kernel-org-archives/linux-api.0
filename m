From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Wed, 10 May 2017 09:37:04 +0200
Message-ID: <CAK8P3a2j6h2MAx3h2NCtadcFsNuFcf158F5OV1e2SK37acZRRg@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com> <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>K
List-Id: linux-api@vger.kernel.org

On Tue, May 9, 2017 at 3:00 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, May 9, 2017 at 1:56 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> On Tue, May 09, 2017 at 08:45:22AM +0200, Ingo Molnar wrote:
>>> We only have ~115 code blocks in the kernel that set/restore KERNEL_DS, it would
>>> be a pity to add a runtime check to every system call ...
>>
>> I think we should simply strive to remove all of them that aren't
>> in core scheduler / arch code.  Basically evetyytime we do the
>>
>>         oldfs = get_fs();
>>         set_fs(KERNEL_DS);
>>         ..
>>         set_fs(oldfs);
>>
>> trick we're doing something wrong, and there should always be better
>> ways to archive it.  E.g. using iov_iter with a ITER_KVEC type
>> consistently would already remove most of them.
>
> How about trying to remove all of them?  If we could actually get rid
> of all of them, we could drop the arch support, and we'd get faster,
> simpler, shorter uaccess code throughout the kernel.
>
> The ones in kernel/compat.c are generally garbage.  They should be
> using compat_alloc_user_space().  Ditto for kernel/power/user.c.

compat_alloc_user_space() has some problems too, it adds
complexity to a rarely-tested code path and can add some noticeable
overhead in cases where user space access is slow because of
extra checks.

It's clearly better than set_fs(), but the way I prefer to convert the
code is to avoid both and instead move compat handlers next to
the native code, and splitting out the common code between native
and compat mode into a helper that takes a regular kernel pointer.

I think that's what both Al has done in the past on compat_ioctl()
and select() and what Christoph does in his latest series, but
it seems worth pointing out for others that decide to help out here.

     Arnd
