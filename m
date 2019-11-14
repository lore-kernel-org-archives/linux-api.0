From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: For review: documentation of clone3() system call
Date: Thu, 14 Nov 2019 13:15:58 +0100
Message-ID: <090860a8-e57f-d4ea-88d4-086ea32e37d9@gmail.com>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
 <20191107151941.dw4gtul5lrtax4se@wittgenstein>
 <2eb2ab4c-b177-29aa-cdc4-420b24cfd7b3@gmail.com>
 <CAG48ez2of684J6suPZpko7JFV6hg5KQsrP0KAn8B8-C3PM9OfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez2of684J6suPZpko7JFV6hg5KQsrP0KAn8B8-C3PM9OfQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: mtk.manpages@gmail.com, Christian Brauner <christian.brauner@ubuntu.com>, Florian Weimer <fweimer@redhat.com>, Christian Brauner <christian@brauner.io>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
List-Id: linux-api@vger.kernel.org

Hello Jann, Christian,

On 11/11/19 3:55 PM, Jann Horn wrote:
> On Sat, Nov 9, 2019 at 9:10 AM Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
> [...]
>> On 11/7/19 4:19 PM, Christian Brauner wrote:
>>> On Fri, Oct 25, 2019 at 06:59:31PM +0200, Michael Kerrisk (man-pages) wrote:
> [...]
>>>>        The stack argument specifies the location of the stack used by the
>>>>        child process.  Since the child and calling process may share mem‐
>>>>        ory,  it  is  not possible for the child process to execute in the
>>>>        same stack as the  calling  process.   The  calling  process  must
>>>>        therefore  set  up  memory  space  for  the child stack and pass a
>>>>        pointer to this space to clone().  Stacks  grow  downward  on  all
>>>
>>> It might be a good idea to advise people to use mmap() to create a
>>> stack. The "canonical" way of doing this would usually be something like
>>>
>>> #define DEFAULT_STACK_SIZE (4 * 1024 * 1024) /* 8 MB usually on Linux */
>>> void *stack = mmap(NULL, DEFAULT_STACK_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
>>>
>>> (Yes, the MAP_STACK is usally a noop but people should always include it
>>>  in case some arch will have weird alignment requirement in which case
>>>  this flag can be changed to actually do something...)
>>
>> So, I'm getting a little bit of an education here, and maybe you are
>> going to further educate me. Long ago, I added the documentation of
>> MAP_STACK to mmap(2), but I never quite connected the dots.
>>
>> However, you say MAP_STACK is *usually* a noop. As far as I can see,
>> in current kernels it is *always* a noop. And AFAICS, since it was first
>> added in 2.6.27 (2008), it has always been a noop.
>>
>> I wonder if it will always be a noop.
> [...]
>> So, my understanding from the above is that MAP_STACK was added to
>> allow a possible fix on some old architectures, should anyone decide it
>> was worth doing the work of implementing it. But so far, after 12 years,
>> no one did. It kind of looks like no one ever will (since those old
>> architectures become less and less relevant).
>>
>> So, AFAICT, while it's not wrong to tell people to use mmap(MAP_STACKED),
>> it doesn't provide any benefit (and perhaps never will), and it is a
>> more clumsy than plain old malloc().
>>
>> But, it could well be that there's something I still don't know here,
>> and I'd be interested to get further education.
> 
> Not on Linux, but on OpenBSD, they do use MAP_STACK now AFAIK; this
> was announced here:
> <http://openbsd-archive.7691.n7.nabble.com/stack-register-checking-td338238.html>.

Indeed, thank you for that pointer. The OpenBSD mmap(2) manual
page also says:

    MAP_STACK
        Indicate that the mapping is used as a stack. This
        flag must be used in combination with MAP_ANON and
        MAP_PRIVATE.

> Basically they periodically check whether the userspace stack pointer
> points into a MAP_STACK region, and if not, they kill the process.

And I now see that FreeBSD also has MAP_STACK (already since FreeBSD 3.1,
by the look of things!):

     MAP_STACK       
         MAP_STACK implies MAP_ANON, ando ffset of 0.  The fd
         argument must be -1 and prot must include at least
         PROT_READ and PROT_WRITE.

         This option creates a memory region that grows to at
         most len bytes in size, starting from the stack top
         and growing down.  The stack top is the starting ad-
         dress returned by the call, plus len bytes.  The bot-
         tom of the stack at maximum growth is the starting ad-
         dress returned by the call.

         Stacks created with MAP_STACK automatically grow.
         Guards prevent inadvertent use of the regions into
         which those stacks can grow without requiring mapping
         the whole stack in advance.

And on DragonflyBSD:

    MAP_STACK
        Map the area as a stack.  MAP_ANON is implied.
        Offset should be 0, fd must be -1, and prot should
        include at least PROT_READ and PROT_WRITE.  This
        option creates a memory region that grows to at
        most len bytes in size, starting from the stack 
        top and growing down.  The stack top is the start‐
        ing address returned by the call, plus len bytes.
        The bottom of the stack at maximum growth is the
        starting address returned by the call.

        The entire area is reserved from the point of view
        of other mmap() calls, even if not faulted in yet.

        WARNING!  We currently allow MAP_STACK mappings to
        provide a hint that points within an existing
        MAP_STACK mapping's space, and this will succeed
        as long as no page have been faulted in the area
        specified, but this behavior is no longer sup‐ 
        ported unless you also specify the MAP_TRYFIXED
        flag.

        Note that unless MAP_FIXED or MAP_TRYFIXED is
        used, you cannot count on the returned address
        matching the hint you have provided. 

> So
> even if it's a no-op on Linux, it might make sense to advise people to
> use the flag to improve portability? I'm not sure if that's something
> that belongs in Linux manpages.

Actually, the Linux manual pages frequently carry such hints, so
this is a good point.

> Another reason against malloc() is that when setting up thread stacks
> in proper, reliable software, you'll probably want to place a guard
> page (in other words, a 4K PROT_NONE VMA) at the bottom of the stack
> to reliably catch stack overflows; and you probably don't want to do
> that with malloc, in particular with non-page-aligned allocations.

Ahh yes, another good point.

I've fixed the example code in the manual page to use
mmap(MAP_STACK), rather than malloc(), to allocate the stack.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
