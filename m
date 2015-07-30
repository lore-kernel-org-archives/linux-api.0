From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Thu, 30 Jul 2015 12:10:58 +0100
Message-ID: <CAHse=S-Wgv8JKu72FQaivou1PAwyexqjn_sjtMu3n=ezX0x-vg@mail.gmail.com>
References: <1438242731-27756-1-git-send-email-drysdale@google.com>
 <1438242731-27756-2-git-send-email-drysdale@google.com> <20150730083831.GA22182@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730083831.GA22182-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Kee
List-Id: linux-api@vger.kernel.org

On Thu, Jul 30, 2015 at 9:38 AM, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
>> +Designing the API
>> +-----------------
>> +
>> +A new system call forms part of the API of the kernel, and has to be supported
>> +indefinitely.  As such, it's a very good idea to explicitly discuss the
>> +interface on the kernel mailing list, and to plan for future extensions of the
>> +interface.  In particular:
>> +
>> +  **Include a flags argument for every new system call**
>
> Sorry, but I think that's bad avice, because even a 'flags' field is inflexible
> and stupid in many cases - it fosters an 'ioctl' kind of design.
>
>> +The syscall table is littered with historical examples where this wasn't done,
>> +together with the corresponding follow-up system calls (eventfd/eventfd2,
>> +dup2/dup3, inotify_init/inotify_init1, pipe/pipe2, renameat/renameat2), so
>> +learn from the history of the kernel and include a flags argument from the
>> +start.
>
> The syscall table is also littered with system calls that have an argument space
> considerably larger than what 6 parameters can express, where various 'flags' are
> used to bring in different parts of new APIs, in a rather messy way.
>
> The right approach IMHO is to think about how extensible a system call is expected
> to be, and to plan accordingly.
>
> If you are anywhere close to 6 parameters, you should not introduce 'flags' but
> you should _reduce_ the number of parameters to a clean essential of 2 or 3
> parameters and should shuffle parameters out to a separate 'parameters/attributes'
> structure that is passed in by pointer:
>
>         SYSCALL_DEFINE2(syscall, int, fd, struct params __user *, params);
>
> And it's the design of 'struct params' that determines future flexibility of the
> interface. A very flexible approach is to not use flags but a 'size' argument:
>
>         struct params {
>                 u32 size;
>                 u32 param_1;
>                 u64 param_2;
>                 u64 param_3;
>         };
>
> Where 'size' is set by user-space to the size of 'struct params' known to it at
> build time:
>
>         params->size = sizeof(*params);
>
> In the normal case the kernel will get param->size == sizeof(*params) as known to
> the kernel.
>
> When the system call is extended in the future on the kernel side, with 'u64
> param_4', then the structure expands from an old size of 24 to a new size of 32
> bytes. The following scenarios might occur:
>
>  - the common case: new user-space calls the new kernel code, ->size is 32 on both
>    sides.
>
>  - old binaries might call the kernel with params->size == 24, in which case the
>    kernel sets the new fields to 0. The new feature should be written
>    accordingly, so that a value of 0 means the old behavior.
>
>  - new binaries might run on old kernels, with params->size == 32. In this case
>    the old kernel will check that all the new fields it does not know about are
>    set to 0 - if they are nonzero (if the new feature is used) it returns with
>    -ENOSYS or -EINVAL.
>
> With this approach we have both backwards and forwards binary compatibility: new
> binaries will run on old kernels just fine, even if they have ->size set to 32, as
> long as they make use of the features.
>
> This design simplifies application design considerably: as new code can mostly
> forget about old ABIs, there's no multiple versions to be taken care of, there's
> just a single 'struct param' known to both sides, and there's no version skew.
>
> We are using such a design in perf_event_open(), see perf_copy_attr() in
> kernel/events/core.c. And yes, ironically that system call still has a historic
> 'flags' argument, but it's not used anymore for extension: we've made over 30
> extensions to the ABI in the last 3 years, which would have been impossible with a
> 'flags' approach.
>
> Thanks,
>
>         Ingo

Fair point, there are other ways to ensure extendability that just the
simple flags
approach -- and as you say, for more sophisticated interfaces flags might hinder
more than they help.

How about the attached text as an attempt to cover both bases?

Thanks,
David


------------------

Designing the API: Planning for Extension
-----------------------------------------

A new system call forms part of the API of the kernel, and has to be supported
indefinitely.  As such, it's a very good idea to explicitly discuss the
interface on the kernel mailing list, and it's important to plan for future
extensions of the interface.

(The syscall table is littered with historical examples where this wasn't done,
together with the corresponding follow-up system calls -- eventfd/eventfd2,
dup2/dup3, inotify_init/inotify_init1,  pipe/pipe2, renameat/renameat2 -- so
learn from the history of the kernel and plan for extensions from the start.)

For simpler system calls that only take a couple of arguments, the preferred way
to allow for future extensibility is to include a flags argument to the system
call.  To make sure that userspace programs can safely use flags between kernel
versions, check whether the flags value holds any unknown flags, and reject the
sycall (with EINVAL) if it does:

    if (flags & ~(THING_FLAG1 | THING_FLAG2 | THING_FLAG3))
        return -EINVAL;

(If no flags values are used yet, check that the flags argument is zero.)

For more sophisticated system calls that involve a larger number of arguments,
it's preferred to encapsulate the majority of the arguments into a structure
that is passed in by pointer.  Such a structure can cope with future extension
by including a size argument in the structure:

    struct xyzzy_params {
        u32 size; /* userspace sets p->size = sizeof(struct xyzzy_params) */
        u32 param_1;
        u64 param_2;
        u64 param_3;
    };

As long as any subsequently added field, say param_4, is designed so that a zero
value gives the previous behaviour, then this allows both directions of version
mismatch:

 - To cope with a later userspace program calling an older kernel, the kernel
   code should check that any memory beyond the size of the structure that it
   expects is zero (effectively checking that param_4 == 0).
 - To cope with an older userspace program calling a newer kernel, the kernel
   code can zero-extend a smaller instance of the structure (effectively setting
   param_4 = 0).

See perf_event_open(2) and the perf_copy_attr() function (in
kernel/events/core.c) for an example of this approach.
