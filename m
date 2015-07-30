From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Thu, 30 Jul 2015 11:21:54 -0700
Message-ID: <CAGXu5j+5KHy68ELU6PmNWaj7mQBXTbRQGXqJFwsXHt9n0LPw8Q@mail.gmail.com>
References: <1438242731-27756-1-git-send-email-drysdale@google.com>
	<1438242731-27756-2-git-send-email-drysdale@google.com>
	<20150730083831.GA22182@gmail.com>
	<CAHse=S-Wgv8JKu72FQaivou1PAwyexqjn_sjtMu3n=ezX0x-vg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAHse=S-Wgv8JKu72FQaivou1PAwyexqjn_sjtMu3n=ezX0x-vg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>Th
List-Id: linux-api@vger.kernel.org

On Thu, Jul 30, 2015 at 4:10 AM, David Drysdale <drysdale@google.com> wrote:
> On Thu, Jul 30, 2015 at 9:38 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * David Drysdale <drysdale@google.com> wrote:
>>
>>> +Designing the API
>>> +-----------------
>>> +
>>> +A new system call forms part of the API of the kernel, and has to be supported
>>> +indefinitely.  As such, it's a very good idea to explicitly discuss the
>>> +interface on the kernel mailing list, and to plan for future extensions of the
>>> +interface.  In particular:
>>> +
>>> +  **Include a flags argument for every new system call**
>>
>> Sorry, but I think that's bad avice, because even a 'flags' field is inflexible
>> and stupid in many cases - it fosters an 'ioctl' kind of design.
>>
>>> +The syscall table is littered with historical examples where this wasn't done,
>>> +together with the corresponding follow-up system calls (eventfd/eventfd2,
>>> +dup2/dup3, inotify_init/inotify_init1, pipe/pipe2, renameat/renameat2), so
>>> +learn from the history of the kernel and include a flags argument from the
>>> +start.
>>
>> The syscall table is also littered with system calls that have an argument space
>> considerably larger than what 6 parameters can express, where various 'flags' are
>> used to bring in different parts of new APIs, in a rather messy way.
>>
>> The right approach IMHO is to think about how extensible a system call is expected
>> to be, and to plan accordingly.
>>
>> If you are anywhere close to 6 parameters, you should not introduce 'flags' but
>> you should _reduce_ the number of parameters to a clean essential of 2 or 3
>> parameters and should shuffle parameters out to a separate 'parameters/attributes'
>> structure that is passed in by pointer:
>>
>>         SYSCALL_DEFINE2(syscall, int, fd, struct params __user *, params);
>>
>> And it's the design of 'struct params' that determines future flexibility of the
>> interface. A very flexible approach is to not use flags but a 'size' argument:
>>
>>         struct params {
>>                 u32 size;
>>                 u32 param_1;
>>                 u64 param_2;
>>                 u64 param_3;
>>         };
>>
>> Where 'size' is set by user-space to the size of 'struct params' known to it at
>> build time:
>>
>>         params->size = sizeof(*params);
>>
>> In the normal case the kernel will get param->size == sizeof(*params) as known to
>> the kernel.
>>
>> When the system call is extended in the future on the kernel side, with 'u64
>> param_4', then the structure expands from an old size of 24 to a new size of 32
>> bytes. The following scenarios might occur:
>>
>>  - the common case: new user-space calls the new kernel code, ->size is 32 on both
>>    sides.
>>
>>  - old binaries might call the kernel with params->size == 24, in which case the
>>    kernel sets the new fields to 0. The new feature should be written
>>    accordingly, so that a value of 0 means the old behavior.
>>
>>  - new binaries might run on old kernels, with params->size == 32. In this case
>>    the old kernel will check that all the new fields it does not know about are
>>    set to 0 - if they are nonzero (if the new feature is used) it returns with
>>    -ENOSYS or -EINVAL.
>>
>> With this approach we have both backwards and forwards binary compatibility: new
>> binaries will run on old kernels just fine, even if they have ->size set to 32, as
>> long as they make use of the features.
>>
>> This design simplifies application design considerably: as new code can mostly
>> forget about old ABIs, there's no multiple versions to be taken care of, there's
>> just a single 'struct param' known to both sides, and there's no version skew.
>>
>> We are using such a design in perf_event_open(), see perf_copy_attr() in
>> kernel/events/core.c. And yes, ironically that system call still has a historic
>> 'flags' argument, but it's not used anymore for extension: we've made over 30
>> extensions to the ABI in the last 3 years, which would have been impossible with a
>> 'flags' approach.
>>
>> Thanks,
>>
>>         Ingo
>
> Fair point, there are other ways to ensure extendability that just the
> simple flags
> approach -- and as you say, for more sophisticated interfaces flags might hinder
> more than they help.
>
> How about the attached text as an attempt to cover both bases?
>
> Thanks,
> David
>
>
> ------------------
>
> Designing the API: Planning for Extension
> -----------------------------------------
>
> A new system call forms part of the API of the kernel, and has to be supported
> indefinitely.  As such, it's a very good idea to explicitly discuss the
> interface on the kernel mailing list, and it's important to plan for future
> extensions of the interface.
>
> (The syscall table is littered with historical examples where this wasn't done,
> together with the corresponding follow-up system calls -- eventfd/eventfd2,
> dup2/dup3, inotify_init/inotify_init1,  pipe/pipe2, renameat/renameat2 -- so
> learn from the history of the kernel and plan for extensions from the start.)
>
> For simpler system calls that only take a couple of arguments, the preferred way
> to allow for future extensibility is to include a flags argument to the system
> call.  To make sure that userspace programs can safely use flags between kernel
> versions, check whether the flags value holds any unknown flags, and reject the
> sycall (with EINVAL) if it does:
>
>     if (flags & ~(THING_FLAG1 | THING_FLAG2 | THING_FLAG3))
>         return -EINVAL;
>
> (If no flags values are used yet, check that the flags argument is zero.)
>
> For more sophisticated system calls that involve a larger number of arguments,
> it's preferred to encapsulate the majority of the arguments into a structure
> that is passed in by pointer.  Such a structure can cope with future extension
> by including a size argument in the structure:
>
>     struct xyzzy_params {
>         u32 size; /* userspace sets p->size = sizeof(struct xyzzy_params) */
>         u32 param_1;
>         u64 param_2;
>         u64 param_3;
>     };
>
> As long as any subsequently added field, say param_4, is designed so that a zero
> value gives the previous behaviour, then this allows both directions of version
> mismatch:
>
>  - To cope with a later userspace program calling an older kernel, the kernel
>    code should check that any memory beyond the size of the structure that it
>    expects is zero (effectively checking that param_4 == 0).
>  - To cope with an older userspace program calling a newer kernel, the kernel
>    code can zero-extend a smaller instance of the structure (effectively setting
>    param_4 = 0).
>
> See perf_event_open(2) and the perf_copy_attr() function (in
> kernel/events/core.c) for an example of this approach.

I like this, it's a good description of both options. I'm still biased
about the approach: I prefer flags, since pointers to user structures
complicate syscall filtering. ;)

-Kees

-- 
Kees Cook
Chrome OS Security
