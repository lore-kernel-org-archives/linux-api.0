From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Fri, 31 Jul 2015 15:08:28 -0700
Message-ID: <20150731220828.GA30890@cloud>
References: <1438242731-27756-2-git-send-email-drysdale@google.com>
 <20150730083831.GA22182@gmail.com>
 <CAHse=S-Wgv8JKu72FQaivou1PAwyexqjn_sjtMu3n=ezX0x-vg@mail.gmail.com>
 <CAGXu5j+5KHy68ELU6PmNWaj7mQBXTbRQGXqJFwsXHt9n0LPw8Q@mail.gmail.com>
 <20150730190434.GD16452@x>
 <CAGXu5jJwtVgPmmMHiR0M27he3ma7exfSH8OBNdLMFQcbbtzUfg@mail.gmail.com>
 <20150731010234.GA7265@x>
 <CAGXu5jLethUkiq1QEZg-uRkOzofa6M8WCT8T7qAByWy5L4xHBw@mail.gmail.com>
 <20150731205941.GA30362@cloud>
 <CALCETrUkMXvFRKdTH7ekY7FyGvbKDDJbf7L0shgs5R-Hep6bVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUkMXvFRKdTH7ekY7FyGvbKDDJbf7L0shgs5R-Hep6bVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>David
List-Id: linux-api@vger.kernel.org

On Fri, Jul 31, 2015 at 02:19:29PM -0700, Andy Lutomirski wrote:
> On Fri, Jul 31, 2015 at 1:59 PM,  <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> > Agreed.  I think the proposal above would be a net improvement, but
> > ideally you'd want something that's annotated and generates automatic
> > marshalling code.
> >
> 
> I assume this is idle musing.  If, however, we were to actually do
> this, I'd suggest we seriously consider speaking the Cap'n Proto
> serialization format.  It's quite nice, it encodes and decodes *very*
> quickly and, unlike TLV schemes, you don't have to read it in order,
> making the read-side code less awkward.

That seems like *massive* overkill for a kernel<->userspace syscall
interface.  I was more thinking about having a few standardized marshal
types, and incrementally adding more when more patterns show up.  For a
first pass, just automatically running copy_from_user and
copy_param_struct on appropriate sets of __user parameters identified as
such in a structured text file seems quite sufficient.  (Plus
automatically generating syscalls.h from that.)
