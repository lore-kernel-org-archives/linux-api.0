From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCH RFC 0/1] Document how to add a new syscall
Date: Tue, 28 Jul 2015 17:02:06 +0100
Message-ID: <CAHse=S_h8c7Sg56V1UR2uW-0hqAMopqvEyvtdOx0hUH2c+8y2w@mail.gmail.com>
References: <1438083663-24814-1-git-send-email-drysdale@google.com>
 <55B78AB4.2010807@osg.samsung.com> <20150728141920.GC19282@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150728141920.GC19282@twins.programming.kicks-ass.net>
Sender: linux-doc-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Eric B Munson <emunson@akamai.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Miklos Szeredi <mszeredi@suse.cz>, Milosz
List-Id: linux-api@vger.kernel.org

On Tue, Jul 28, 2015 at 3:19 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jul 28, 2015 at 07:59:16AM -0600, Shuah Khan wrote:
>> On 07/28/2015 05:41 AM, David Drysdale wrote:
>> > Given that I've gotten some of the details wrong in the past (and I've
>> > seen others do likewise), I thought it might be helpful to collate the
>> > best practices for adding a new system call to the kernel.
>> >
>> > Apologies for the wide circulation -- I've tried to include folk who've
>> > recently added or proposed a system call, as they're most likely to
>> > have opinions on:
>> >  - whether this a useful addition to Documentation/
>> >  - whether the details of the advice are correct and complete.
>> >
>> > Shuah, is there anything more that should be added for the Testing
>> > section in particular?
>> >
>>
>> David,
>>
>> Looks good. You could add a one liner on in some cases, it might be
>> necessary to install headers before test compiles. Other than that,
>> the information looks good.
>
> For perf we still use the syscall() wrapper and we have hardcoded
> (fallback) syscall numbers in there in case they've not yet reached
> unistd.h.
>
> People update their kernels far more often than their userspace headers.

How about:

diff --git a/Documentation/adding-syscalls.txt
b/Documentation/adding-syscalls.txt
index 5f52edda8951..b274c3d01edb 100644
--- a/Documentation/adding-syscalls.txt
+++ b/Documentation/adding-syscalls.txt
@@ -389,6 +389,11 @@ reviewers with a demonstration of how user space
programs will use the system
 call.  A good way to combine these aims is to include a simple self-test
 program in a new directory under tools/testing/selftests/.

+For a new system call, there will obviously be no libc wrapper function and so
+the test will need to invoke it using syscall(); also, if the system call
+involves a new userspace-visible structure, the corresponding header will need
+to be installed to compile the test.
+
 Make sure the selftest runs successfully on all supported architectures.  For
 example, check that it works when compiled as an x86_64 (-m64), x86_32 (-m32)
 and x32 (-mx32) ABI program.
