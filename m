From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Fri, 31 Jul 2015 21:32:37 -0700
Message-ID: <20150801043237.GA28660@x>
References: <CAHse=S-Wgv8JKu72FQaivou1PAwyexqjn_sjtMu3n=ezX0x-vg@mail.gmail.com>
 <CAGXu5j+5KHy68ELU6PmNWaj7mQBXTbRQGXqJFwsXHt9n0LPw8Q@mail.gmail.com>
 <20150730190434.GD16452@x>
 <CAGXu5jJwtVgPmmMHiR0M27he3ma7exfSH8OBNdLMFQcbbtzUfg@mail.gmail.com>
 <20150731010234.GA7265@x>
 <CAGXu5jLethUkiq1QEZg-uRkOzofa6M8WCT8T7qAByWy5L4xHBw@mail.gmail.com>
 <20150731205941.GA30362@cloud>
 <CALCETrUkMXvFRKdTH7ekY7FyGvbKDDJbf7L0shgs5R-Hep6bVA@mail.gmail.com>
 <20150731220828.GA30890@cloud>
 <CALCETrXwrf--FG+KdbG-oBixhG+odB7ukW_F7CkBGb0KQ7ZSVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXwrf--FG+KdbG-oBixhG+odB7ukW_F7CkBGb0KQ7ZSVA@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, David Drysdale <drysdale@google.com>, Ingo Molnar <mingo@kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>David
List-Id: linux-api@vger.kernel.org

On Fri, Jul 31, 2015 at 03:54:56PM -0700, Andy Lutomirski wrote:
> On Fri, Jul 31, 2015 at 3:08 PM,  <josh@joshtriplett.org> wrote:
> > On Fri, Jul 31, 2015 at 02:19:29PM -0700, Andy Lutomirski wrote:
> >> On Fri, Jul 31, 2015 at 1:59 PM,  <josh@joshtriplett.org> wrote:
> >> > Agreed.  I think the proposal above would be a net improvement, but
> >> > ideally you'd want something that's annotated and generates automatic
> >> > marshalling code.
> >> >
> >>
> >> I assume this is idle musing.  If, however, we were to actually do
> >> this, I'd suggest we seriously consider speaking the Cap'n Proto
> >> serialization format.  It's quite nice, it encodes and decodes *very*
> >> quickly and, unlike TLV schemes, you don't have to read it in order,
> >> making the read-side code less awkward.
> >
> > That seems like *massive* overkill for a kernel<->userspace syscall
> > interface.  I was more thinking about having a few standardized marshal
> > types, and incrementally adding more when more patterns show up.  For a
> > first pass, just automatically running copy_from_user and
> > copy_param_struct on appropriate sets of __user parameters identified as
> > such in a structured text file seems quite sufficient.  (Plus
> > automatically generating syscalls.h from that.)
> 
> If a param struct does the trick, then I agree.  It's when you start
> having lists and other variable-size stuff that it gets messier.

Sure, agreed.  But I really hope we don't create new kernel ABIs that
involve constructs like that.

- Josh Triplett
