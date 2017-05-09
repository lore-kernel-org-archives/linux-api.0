From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Tue, 9 May 2017 16:31:00 -0700
Message-ID: <CAGXu5jL6PeQmmdxh5h--fgrMK8DW_XZYpNfDOvvv_o9E3-Kxdw@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com> <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170509130250.GA11381@infradead.org> <20170509160322.GA15902@infradead.org>
 <CAGXu5jKHVMRMKDfn+=kkbm+JkWPhoEtDwKx=QXAYxg1p9bn7PQ@mail.gmail.com> <CALCETrV73=cDvaSLOMvb299yaGNJYME8LC-=P+N6p7R1NN97Yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrV73=cDvaSLOMvb299yaGNJYME8LC-=P+N6p7R1NN97Yg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, linux-s390 <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffene>
List-Id: linux-api@vger.kernel.org

On Tue, May 9, 2017 at 3:52 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Tue, May 9, 2017 at 9:50 AM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> On Tue, May 9, 2017 at 9:03 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>> On Tue, May 09, 2017 at 06:02:50AM -0700, Christoph Hellwig wrote:
>>>> On Tue, May 09, 2017 at 06:00:01AM -0700, Andy Lutomirski wrote:
>>>> > fs/splice.c has some, ahem, interesting uses that have been the source
>>>> > of nasty exploits in the past.  Converting them to use iov_iter
>>>> > properly would be really, really nice.  Christoph, I don't suppose
>>>> > you'd like to do that?
>>>>
>>>> I can take care of all the fs code including this one.
>>>
>>> I spent the afternoon hacking up where I'd like this to head.  It's
>>> completely untested as of now:
>>>
>>>         http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/setfs-elimination
>>
>> Ooooh yes! Nice work.
>>
>> I love this:
>> http://git.infradead.org/users/hch/vfs.git/commitdiff/51e83f50f824ca23f5584c172138e6b7c2ff786d
>> but I wonder what it'll cause out-of-tree code to do. I mean, I'd
>> rather nothing out-of-tree be calling these, but I'd hate 3rd party
>> hacks even more.
>>
>> http://git.infradead.org/users/hch/vfs.git/commitdiff/018e0e9030777121fe87e89d43066691e7366587
>> This accidentally(?) removes the kernel-doc comments.
>>
>> http://git.infradead.org/users/hch/vfs.git/commitdiff/78b62c730254fc39fa888cdbdca08fde6e09a798
>> Could this be made defensive? (Return 0 if ret wraps, for example?) I
>> see what the comment says, but not everyone will read that. :(
>>
>> http://git.infradead.org/users/hch/vfs.git/commitdiff/a106276ca0294be054bc89ce97219933fe543df1
>> Perhaps unconditionally set USER_DS on exit instead of retaining
>> whatever was there?
>
> I don't like silent fixups.  If we want to do this, we should BUG or
> at least WARN, not just change the addr limit.  But I'm also not
> convinced it's indicative of an actual bug here.

Nothing should enter that function with KERNEL_DS set, right?

BUG_ON(get_fs() != USER_DS);
set_fs(KERNEL_DS);
...
set_fs(USER_DS);

-Kees

-- 
Kees Cook
Pixel Security
