From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] pipe: Notification queue preparation
Date: Thu, 5 Dec 2019 09:12:42 -0800
Message-ID: <CAHk-=wgwwJ+ZEtycujFdNmpS8TjwCYyT+oHfV7d-GekyaX91xg@mail.gmail.com>
References: <31452.1574721589@warthog.procyon.org.uk> <20191205125826.GK2734@twin.jikos.cz>
 <1593.1575554217@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1593.1575554217@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: David Sterba <dsterba@suse.cz>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 5, 2019 at 5:57 AM David Howells <dhowells@redhat.com> wrote:
>
> David Sterba <dsterba@suse.cz> wrote:
>
> > [<0>] pipe_write+0x1be/0x4b0
>
> Can you get me a line number of that?  Assuming you've built with -g, load
> vmlinux into gdb and do "i li pipe_write+0x1be".

If the kernel is built with debug info (which you need for the gdb
command anyway), it's much better to just use

   ./scripts/decode_stacktrace.sh

which gives all the information for the whole backtrace.

It would be interesting to hear if somebody else is waiting on the
read side too.

             Linus
