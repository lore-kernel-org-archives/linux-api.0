From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Fri, 31 Jul 2015 06:06:21 -0700
Message-ID: <20150731130620.GA16435@x>
References: <1438242731-27756-1-git-send-email-drysdale@google.com>
 <1438242731-27756-2-git-send-email-drysdale@google.com>
 <20150730185007.GC16452@x>
 <CAHse=S-jtynT-1Pk8+JMd98wViao-bJh3K8TtGKPk7RXWgy=rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHse=S-jtynT-1Pk8+JMd98wViao-bJh3K8TtGKPk7RXWgy=rg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Kees
List-Id: linux-api@vger.kernel.org

On Fri, Jul 31, 2015 at 10:48:32AM +0100, David Drysdale wrote:
> On Thu, Jul 30, 2015 at 7:50 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> > On Thu, Jul 30, 2015 at 08:52:11AM +0100, David Drysdale wrote:
> >> Add a document describing the process of adding a new system call,
> >> including the need for a flags argument for future compatibility, and
> >> covering 32-bit/64-bit concerns (albeit in an x86-centric way).
> >>
> >> Signed-off-by: David Drysdale <drysdale@google.com>
> >> Reviewed-by: Michael Kerrisk <mtk.manpages@gmail.com>
> >> Reviewed-by: Eric B Munson <emunson@akamai.com>
> >> Reviewed-by: Kees Cook <keescook@chromium.org>
> >> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> >
> > A few comments below.  I also agree with Ingo's comment about
> > documenting the param-structure approach in addition to flags.
> 
> Many thanks for looking through the doc in detail!
> 
> I'll send out an updated doc today; I'm then on vacation for the next
> week so I'll collate further feedback after I return.

Thanks for the quick response and for incorporating these changes.

> > Some things to add a this point, before talking about adding a new file
> > descriptor:
> >
> > If you want to provide userspace with a handle to a kernel object, do so
> > in the form of a file descriptor.  Do not invent a new type of userspace
> > object handle with its own namespace.  The kernel already has numerous
> > system calls and well-defined semantics for managing and passing around
> > file descriptors, as well as for cleaning up when the file descriptor is
> > no longer in use.
> >
> > If your new system call returns a file descriptor, think about what it
> > means to use the poll(2) family of syscalls on that file descriptor.  If
> > you want to send an event to userspace associated with your kernel
> > object, you should do so by making your file descriptor ready for
> > reading or writing.
> 
> Good points, I've added a couple of paragraphs along these lines:
> 
> "
> If your new system call allows userspace to refer to a kernel object, it
> should use a file descriptor as the handle for that object -- don't invent a
> new type of userspace object handle when the kernel already has mechanisms and
> well-defined semantics for using file descriptors.
> 
> [snip: existing text on CLOEXEC]
> 
> If your system call returns a new file descriptor, you should also consider
> what it means to use the poll(2) family of system calls on that file
> descriptor. Making a file descriptor ready for reading or writing is the
> normal way for the kernel to indicate to userspace that an event has
> occurred on the corresponding kernel object.
> "

These look good to me.

> >> +needs to be governed by the appropriate Linux capability bit (checked with a
> >> +call to capable()), as described in the capabilities(7) man page.
> >> +
> >> + - If there is an existing capability that governs related functionality, then
> >> +   use that.  However, avoid combining lots of only vaguely related functions
> >> +   together under the same bit, as this goes against capabilities' purpose of
> >> +   splitting the power of root.  In particular, avoid adding new uses of the
> >> +   already overly-general CAP_SYS_ADMIN capability.
> >> + - If there is no related capability, then consider adding a new capability
> >> +   bit -- but bear in mind that the numbering space is limited, and each new
> >> +   bit needs to be understood and administered by sysadmins.
> >
> > Many previous discussions on this topic seem to have concluded that it's
> > almost impossible to add a new capability without breaking existing
> > programs.  I would suggest not even mentioning this possibility.
> 
> I'm not particularly knowledgable about capabilities (at least, not the
> POSIX.1e/Linux kind), so I'll confess that I got this suggestion from
> Michael Kerrisk.
> 
> Michael, do you agree that we should just drop the possibility of adding
> new capability bits?
> 
> Also, Josh, do you have any references to the earlier discussions on the
> topic so I can update the Sources section?

No direct links handy at the moment without some searching, but one
iteration of it came up when Matthew Garrett suggested adding
CAP_COMPROMISE_KERNEL, and the ensuing discussion of capability
semantics suggested that the way the capability space was defined and
controlled by userspace meant that adding any new capability would
effectively break userspace ABI.  The userspace ABI for capabilities is
not clear; some applications drop all possible capabilities and could
get surprised by a new capability being dropped, while other
applications drop only capabilities they know about and could get
surprised by a new capability *not* being dropped.

- Josh Triplett
