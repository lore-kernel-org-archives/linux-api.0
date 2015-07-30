From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Thu, 30 Jul 2015 10:38:31 +0200
Message-ID: <20150730083831.GA22182@gmail.com>
References: <1438242731-27756-1-git-send-email-drysdale@google.com>
 <1438242731-27756-2-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438242731-27756-2-git-send-email-drysdale@google.com>
Sender: linux-doc-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keesc>
List-Id: linux-api@vger.kernel.org


* David Drysdale <drysdale@google.com> wrote:

> +Designing the API
> +-----------------
> +
> +A new system call forms part of the API of the kernel, and has to be supported
> +indefinitely.  As such, it's a very good idea to explicitly discuss the
> +interface on the kernel mailing list, and to plan for future extensions of the
> +interface.  In particular:
> +
> +  **Include a flags argument for every new system call**

Sorry, but I think that's bad avice, because even a 'flags' field is inflexible 
and stupid in many cases - it fosters an 'ioctl' kind of design.

> +The syscall table is littered with historical examples where this wasn't done, 
> +together with the corresponding follow-up system calls (eventfd/eventfd2, 
> +dup2/dup3, inotify_init/inotify_init1, pipe/pipe2, renameat/renameat2), so 
> +learn from the history of the kernel and include a flags argument from the 
> +start.

The syscall table is also littered with system calls that have an argument space 
considerably larger than what 6 parameters can express, where various 'flags' are 
used to bring in different parts of new APIs, in a rather messy way.

The right approach IMHO is to think about how extensible a system call is expected 
to be, and to plan accordingly.

If you are anywhere close to 6 parameters, you should not introduce 'flags' but 
you should _reduce_ the number of parameters to a clean essential of 2 or 3 
parameters and should shuffle parameters out to a separate 'parameters/attributes' 
structure that is passed in by pointer:

	SYSCALL_DEFINE2(syscall, int, fd, struct params __user *, params);

And it's the design of 'struct params' that determines future flexibility of the 
interface. A very flexible approach is to not use flags but a 'size' argument:

	struct params {
		u32 size;
		u32 param_1;
		u64 param_2;
		u64 param_3;
	};

Where 'size' is set by user-space to the size of 'struct params' known to it at 
build time:

	params->size = sizeof(*params);

In the normal case the kernel will get param->size == sizeof(*params) as known to 
the kernel.

When the system call is extended in the future on the kernel side, with 'u64 
param_4', then the structure expands from an old size of 24 to a new size of 32 
bytes. The following scenarios might occur:

 - the common case: new user-space calls the new kernel code, ->size is 32 on both 
   sides.

 - old binaries might call the kernel with params->size == 24, in which case the 
   kernel sets the new fields to 0. The new feature should be written
   accordingly, so that a value of 0 means the old behavior.

 - new binaries might run on old kernels, with params->size == 32. In this case 
   the old kernel will check that all the new fields it does not know about are 
   set to 0 - if they are nonzero (if the new feature is used) it returns with 
   -ENOSYS or -EINVAL.

With this approach we have both backwards and forwards binary compatibility: new 
binaries will run on old kernels just fine, even if they have ->size set to 32, as 
long as they make use of the features.

This design simplifies application design considerably: as new code can mostly 
forget about old ABIs, there's no multiple versions to be taken care of, there's 
just a single 'struct param' known to both sides, and there's no version skew.

We are using such a design in perf_event_open(), see perf_copy_attr() in 
kernel/events/core.c. And yes, ironically that system call still has a historic 
'flags' argument, but it's not used anymore for extension: we've made over 30 
extensions to the ABI in the last 3 years, which would have been impossible with a 
'flags' approach.

Thanks,

	Ingo
