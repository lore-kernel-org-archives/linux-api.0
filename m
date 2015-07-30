From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Thu, 30 Jul 2015 11:22:05 -0700
Message-ID: <20150730182205.GB16452@x>
References: <1438242731-27756-1-git-send-email-drysdale@google.com>
 <1438242731-27756-2-git-send-email-drysdale@google.com>
 <20150730083831.GA22182@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150730083831.GA22182@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Theodore
List-Id: linux-api@vger.kernel.org

On Thu, Jul 30, 2015 at 10:38:31AM +0200, Ingo Molnar wrote:
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

Nit: it seems easier, rather than having the kernel check this, to have
userspace only use the minimum version of the structure that contains
the features they use, and then have older kernels reject sizes bigger
than they understand.  If you don't need param_4, don't use the version
of the structure that has param_4.  That also means the kernel doesn't
need to copy and read those values.  Either approach works, though.

- Josh Triplett
