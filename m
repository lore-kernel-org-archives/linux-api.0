From: David Sterba <dsterba@suse.cz>
Subject: Re: [GIT PULL] pipe: Notification queue preparation
Date: Thu, 5 Dec 2019 18:21:27 +0100
Message-ID: <20191205172127.GW2734@suse.cz>
References: <20191205125826.GK2734@twin.jikos.cz>
 <31452.1574721589@warthog.procyon.org.uk>
 <1593.1575554217@warthog.procyon.org.uk>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1593.1575554217@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 05, 2019 at 01:56:57PM +0000, David Howells wrote:
> David Sterba <dsterba@suse.cz> wrote:
> 
> > [<0>] pipe_write+0x1be/0x4b0
> 
> Can you get me a line number of that?  Assuming you've built with -g, load
> vmlinux into gdb and do "i li pipe_write+0x1be".

I built it with -g (DEBUG_INFO) but there's no output for the command (gdb 8.2):

(gdb) i li pipe_write+0x1be
Function "pipe_write+0x1be" not defined.

But the address can tell something:

(gdb) l *(pipe_write+0x1be)
0xffffffff81390b8e is in pipe_write (fs/pipe.c:509).
warning: Source file is more recent than executable.
504                             kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
505                             do_wakeup = 0;
506                     }
507                     pipe->waiting_writers++;
508                     pipe_wait(pipe);
509                     pipe->waiting_writers--;
510             }
511     out:
512             __pipe_unlock(pipe);
513             if (do_wakeup) {

I rerun the test again (with a different address where it's stuck), there's
nothing better I can get from the debug info, it always points to pipe_wait,
disassembly points to:

   0xffffffff81390b71 <+417>:   jne    0xffffffff81390c23 <pipe_write+595>
   0xffffffff81390b77 <+423>:   test   %ecx,%ecx
   0xffffffff81390b79 <+425>:   jne    0xffffffff81390b95 <pipe_write+453>
   0xffffffff81390b7b <+427>:   addl   $0x1,0x110(%rbx)
   0xffffffff81390b82 <+434>:   mov    %rbx,%rdi
   0xffffffff81390b85 <+437>:   callq  0xffffffff813908c0 <pipe_wait>
   0xffffffff81390b8a <+442>:   subl   $0x1,0x110(%rbx)

(pipe_write+0x1ba == 0xffffffff81390b8a)
