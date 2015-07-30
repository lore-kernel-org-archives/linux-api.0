From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Thu, 30 Jul 2015 13:03:43 -0700
Message-ID: <CAGXu5jJwtVgPmmMHiR0M27he3ma7exfSH8OBNdLMFQcbbtzUfg@mail.gmail.com>
References: <1438242731-27756-1-git-send-email-drysdale@google.com>
	<1438242731-27756-2-git-send-email-drysdale@google.com>
	<20150730083831.GA22182@gmail.com>
	<CAHse=S-Wgv8JKu72FQaivou1PAwyexqjn_sjtMu3n=ezX0x-vg@mail.gmail.com>
	<CAGXu5j+5KHy68ELU6PmNWaj7mQBXTbRQGXqJFwsXHt9n0LPw8Q@mail.gmail.com>
	<20150730190434.GD16452@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150730190434.GD16452@x>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: David Drysdale <drysdale@google.com>, Ingo Molnar <mingo@kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>David
List-Id: linux-api@vger.kernel.org

On Thu, Jul 30, 2015 at 12:04 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Thu, Jul 30, 2015 at 11:21:54AM -0700, Kees Cook wrote:
>> I like this, it's a good description of both options. I'm still biased
>> about the approach: I prefer flags, since pointers to user structures
>> complicate syscall filtering. ;)
>
> Seems like we should do two things to make that easier:
>
> 1) Create a standardized kernel mechanism for parameter-struct handling,
>    implementing the recommendations mentioned here.

It's been suggested in the past that nlmsg is appropriate for such a
thing, but I remain suspicious. :)

> 2) Integrate into that mechanism a way to filter the resulting parameter
>    struct with BPF *after* it has been copied to kernel space (and thus
>    can no longer be tampered with).

Yeah, this is a irritating part: the structures operated on are copied
from userspace adhoc in each syscall. Doing argument checking would
mean double copies initially, and perhaps teaching syscalls about
optional "already copied" arguments or something as an optimization.

-Kees

-- 
Kees Cook
Chrome OS Security
