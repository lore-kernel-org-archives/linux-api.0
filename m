From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Thu, 30 Jul 2015 09:45:23 -0700
Message-ID: <20150730164523.GA5364@kroah.com>
References: <1438242731-27756-1-git-send-email-drysdale@google.com>
 <1438242731-27756-2-git-send-email-drysdale@google.com>
 <20150730163007.GA10522@rei.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150730163007.GA10522@rei.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Cyril Hrubis <chrubis@suse.cz>
Cc: David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 30, 2015 at 06:30:07PM +0200, Cyril Hrubis wrote:
> Hi!
> > +Testing
> > +-------
> > +
> > +A new system call should obviously be tested; it is also useful to provide
> > +reviewers with a demonstration of how user space programs will use the system
> > +call.  A good way to combine these aims is to include a simple self-test
> > +program in a new directory under tools/testing/selftests/.
> 
> I know that this is a bit off topic, but since the selftest is now the
> official place to add kernel testcases to let me rant about it a bit.
> 
> It's a bit of a pain seeing people reinvent the wheel and trying to
> figure out consistent test interface while most of the problems has been
> solved in LTP[1] test library quite some time ago. Especially use of the
> SAFE_MACROS[2] would simplify writing test setups quite a lot.
> 
> I wonder if we can at least share the test library, pulling it out of
> LTP, or at least the interesting parts, wouldn't be hard at all.
> 
> [1]
> https://github.com/linux-test-project/ltp/wiki/Test-Writing-Guidelines#221-basic-test-structure
> 
> [2]
> https://github.com/linux-test-project/ltp/wiki/Test-Writing-Guidelines#224-safe-macros

That would be great, please send patches to do so to the linux-api
mailing list and the test maintainer.

thanks,

greg k-h
