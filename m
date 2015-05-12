From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 1/2] clone: Support passing tls argument via C rather
 than pt_regs magic
Date: Tue, 12 May 2015 14:22:50 -0700
Message-ID: <20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
References: <20150511192918.GA11361@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150511192918.GA11361@jtriplet-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 11 May 2015 12:29:19 -0700 Josh Triplett <josh@joshtriplett.org> wrote:

> Introduce a new CONFIG_HAVE_COPY_THREAD_TLS for architectures to opt
> into, and a new copy_thread_tls that accepts the tls parameter as an
> additional unsigned long (syscall-argument-sized) argument.
> Change sys_clone's tls argument to an unsigned long (which does
> not change the ABI), and pass that down to copy_thread_tls.
> 
> Architectures that don't opt into copy_thread_tls will continue to
> ignore the C argument to sys_clone in favor of the pt_regs captured at
> kernel entry, and thus will be unable to introduce new versions of the
> clone syscall.

What happens quite frequently is that we do something for x86 with the
expectation that other architectures will follow along, but this
doesn't happen.  The arch maintainers simply didn't know about it or
nobody nags them.  Nothing happens and inconsistencies hang around for
years.  eg, http://lkml.iu.edu/hypermail/linux/kernel/1504.2/04993.html

I'm thinking we should find a way to do this better.  One way might be
to maintain a Documentation/arch-todo which identifies each item, has a
little list of what-to-do instructions and perhaps a list of the
not-yet-done architectures.  Basically a way for everyone to
communicate at the arch maintainers.
