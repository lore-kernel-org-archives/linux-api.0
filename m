From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 0/6] CLONE_FD: Task exit notification via file descriptor
Date: Fri, 13 Mar 2015 14:33:44 -0700
Message-ID: <CALCETrXH+Ui1XqVZjFB=8vDpJLCYeVf+XNUPGWNfwDsNKi_nKg@mail.gmail.com>
References: <CAHse=S9hnGm=Z8FR4f+z_TFwnrjBLkcV4wVwjDYgKuOSemdVrA@mail.gmail.com>
 <20150313194252.GA10317@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150313194252.GA10317@cloud>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Thiago Macieira <thiago.macieira@intel.com>, Michael Kerrisk <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 12:42 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Fri, Mar 13, 2015 at 04:05:29PM +0000, David Drysdale wrote:
>> On Fri, Mar 13, 2015 at 1:40 AM, Josh Triplett <josh@joshtriplett.org> wrote:
>> > This patch series introduces a new clone flag, CLONE_FD, which lets the caller
>> > handle child process exit notification via a file descriptor rather than
>> > SIGCHLD.  CLONE_FD makes it possible for libraries to safely launch and manage
>> > child processes on behalf of their caller, *without* taking over process-wide
>> > SIGCHLD handling (either via signal handler or signalfd).
>>
>> Hi Josh,
>>
>> From the overall description (i.e. I haven't looked at the code yet)
>> this looks very interesting.  However, it seems to cover a lot of the
>> same ground as the process descriptor feature that was added to FreeBSD
>> in 9.x/10.x:
>>   https://www.freebsd.org/cgi/man.cgi?query=pdfork&sektion=2
>
> Interesting.
>
>> I think it would ideally be nice for a userspace library developer to be
>> able to do subprocess management (without SIGCHLD) in a similar way
>> across both platforms, without lots of complicated autoconf shenanigans.
>>
>> So could we look at the overlap and seeing if we can come up with
>> something that covers your requirements and also allows for something
>> that looks like FreeBSD's process descriptors?
>
> Agreed; however, I think it's reasonable to provide appropriate Linux
> system calls, and then let glibc or libbsd or similar provide the
> BSD-compatible calls on top of those.  I don't think the kernel
> interface needs to exactly match FreeBSD's, as long as it's a superset
> of the functionality.

We need to be careful with things like read(2), though.  It's hard to
write a glibc function that makes read(2) do something other than what
the kernel thinks.  Similarly, poll(2) is defined by the kernel.  It
would be really nice to be consistent here.

--Andy
