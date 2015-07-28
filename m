From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH RFC 0/1] Document how to add a new syscall
Date: Tue, 28 Jul 2015 10:41:05 -0600
Message-ID: <55B7B0A1.4080100@osg.samsung.com>
References: <1438083663-24814-1-git-send-email-drysdale@google.com> <55B78AB4.2010807@osg.samsung.com> <20150728141920.GC19282@twins.programming.kicks-ass.net> <CAHse=S_h8c7Sg56V1UR2uW-0hqAMopqvEyvtdOx0hUH2c+8y2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHse=S_h8c7Sg56V1UR2uW-0hqAMopqvEyvtdOx0hUH2c+8y2w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, Fam Zheng <famz@>
List-Id: linux-api@vger.kernel.org

On 07/28/2015 10:02 AM, David Drysdale wrote:
> On Tue, Jul 28, 2015 at 3:19 PM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> On Tue, Jul 28, 2015 at 07:59:16AM -0600, Shuah Khan wrote:
>>> On 07/28/2015 05:41 AM, David Drysdale wrote:
>>>> Given that I've gotten some of the details wrong in the past (and I've
>>>> seen others do likewise), I thought it might be helpful to collate the
>>>> best practices for adding a new system call to the kernel.
>>>>
>>>> Apologies for the wide circulation -- I've tried to include folk who've
>>>> recently added or proposed a system call, as they're most likely to
>>>> have opinions on:
>>>>  - whether this a useful addition to Documentation/
>>>>  - whether the details of the advice are correct and complete.
>>>>
>>>> Shuah, is there anything more that should be added for the Testing
>>>> section in particular?
>>>>
>>>
>>> David,
>>>
>>> Looks good. You could add a one liner on in some cases, it might be
>>> necessary to install headers before test compiles. Other than that,
>>> the information looks good.
>>
>> For perf we still use the syscall() wrapper and we have hardcoded
>> (fallback) syscall numbers in there in case they've not yet reached
>> unistd.h.
>>
>> People update their kernels far more often than their userspace headers.
> 
> How about:
> 
> diff --git a/Documentation/adding-syscalls.txt
> b/Documentation/adding-syscalls.txt
> index 5f52edda8951..b274c3d01edb 100644
> --- a/Documentation/adding-syscalls.txt
> +++ b/Documentation/adding-syscalls.txt
> @@ -389,6 +389,11 @@ reviewers with a demonstration of how user space
> programs will use the system
>  call.  A good way to combine these aims is to include a simple self-test
>  program in a new directory under tools/testing/selftests/.
> 
> +For a new system call, there will obviously be no libc wrapper function and so
> +the test will need to invoke it using syscall(); also, if the system call
> +involves a new userspace-visible structure, the corresponding header will need
> +to be installed to compile the test.
> +

This looks good.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
