From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Tue, 9 May 2017 18:59:41 -0700
Message-ID: <CALCETrX+CP6e8bfhWBpan=37fuK=V0gEm+zeHQOmCOhcfr7Bqg@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com> <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170509130250.GA11381@infradead.org> <20170509160322.GA15902@infradead.org>
 <CAGXu5jKHVMRMKDfn+=kkbm+JkWPhoEtDwKx=QXAYxg1p9bn7PQ@mail.gmail.com>
 <CALCETrV73=cDvaSLOMvb299yaGNJYME8LC-=P+N6p7R1NN97Yg@mail.gmail.com> <CAGXu5jL6PeQmmdxh5h--fgrMK8DW_XZYpNfDOvvv_o9E3-Kxdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jL6PeQmmdxh5h--fgrMK8DW_XZYpNfDOvvv_o9E3-Kxdw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <greg@kroah.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-s390 <linux-s390@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffene>
List-Id: linux-api@vger.kernel.org

On Tue, May 9, 2017 at 4:31 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, May 9, 2017 at 3:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Tue, May 9, 2017 at 9:50 AM, Kees Cook <keescook@chromium.org> wrote:
>>> On Tue, May 9, 2017 at 9:03 AM, Christoph Hellwig <hch@infradead.org> wrote:
>>>> On Tue, May 09, 2017 at 06:02:50AM -0700, Christoph Hellwig wrote:
>>>>> On Tue, May 09, 2017 at 06:00:01AM -0700, Andy Lutomirski wrote:
>>>>> > fs/splice.c has some, ahem, interesting uses that have been the source
>>>>> > of nasty exploits in the past.  Converting them to use iov_iter
>>>>> > properly would be really, really nice.  Christoph, I don't suppose
>>>>> > you'd like to do that?
>>>>>
>>>>> I can take care of all the fs code including this one.
>>>>
>>>> I spent the afternoon hacking up where I'd like this to head.  It's
>>>> completely untested as of now:
>>>>
>>>>         http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/setfs-elimination
>>>
>>> Ooooh yes! Nice work.
>>>
>>> I love this:
>>> http://git.infradead.org/users/hch/vfs.git/commitdiff/51e83f50f824ca23f5584c172138e6b7c2ff786d
>>> but I wonder what it'll cause out-of-tree code to do. I mean, I'd
>>> rather nothing out-of-tree be calling these, but I'd hate 3rd party
>>> hacks even more.
>>>
>>> http://git.infradead.org/users/hch/vfs.git/commitdiff/018e0e9030777121fe87e89d43066691e7366587
>>> This accidentally(?) removes the kernel-doc comments.
>>>
>>> http://git.infradead.org/users/hch/vfs.git/commitdiff/78b62c730254fc39fa888cdbdca08fde6e09a798
>>> Could this be made defensive? (Return 0 if ret wraps, for example?) I
>>> see what the comment says, but not everyone will read that. :(
>>>
>>> http://git.infradead.org/users/hch/vfs.git/commitdiff/a106276ca0294be054bc89ce97219933fe543df1
>>> Perhaps unconditionally set USER_DS on exit instead of retaining
>>> whatever was there?
>>
>> I don't like silent fixups.  If we want to do this, we should BUG or
>> at least WARN, not just change the addr limit.  But I'm also not
>> convinced it's indicative of an actual bug here.
>
> Nothing should enter that function with KERNEL_DS set, right?
>
> BUG_ON(get_fs() != USER_DS);
> set_fs(KERNEL_DS);
> ...
> set_fs(USER_DS);
>

It's not immediately obvious to me that this shouldn't happen.  Why
not do it the way Christoph did and then, once the rest of set_fs() is
tamed, consider this change (or trying to mass-convert file_operations
implementations to get rid of it entirely)?

--Andy
