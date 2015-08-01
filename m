From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Fri, 31 Jul 2015 23:18:06 -0700
Message-ID: <20150801061806.GA31819@x>
References: <20150730190434.GD16452@x>
 <CAGXu5jJwtVgPmmMHiR0M27he3ma7exfSH8OBNdLMFQcbbtzUfg@mail.gmail.com>
 <20150731010234.GA7265@x>
 <CAGXu5jLethUkiq1QEZg-uRkOzofa6M8WCT8T7qAByWy5L4xHBw@mail.gmail.com>
 <20150731205941.GA30362@cloud>
 <CALCETrUkMXvFRKdTH7ekY7FyGvbKDDJbf7L0shgs5R-Hep6bVA@mail.gmail.com>
 <20150731220828.GA30890@cloud>
 <CALCETrXwrf--FG+KdbG-oBixhG+odB7ukW_F7CkBGb0KQ7ZSVA@mail.gmail.com>
 <20150801043237.GA28660@x>
 <55BC518E.4010102@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55BC518E.4010102-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>Dav
List-Id: linux-api@vger.kernel.org

On Fri, Jul 31, 2015 at 09:56:46PM -0700, H. Peter Anvin wrote:
> On 07/31/2015 09:32 PM, Josh Triplett wrote:
> > 
> > Sure, agreed.  But I really hope we don't create new kernel ABIs that
> > involve constructs like that.
> > 
> 
> It's worth noting I have pushed for auto-marshalling in general for a
> long time, not the least to get rid of the awful syscall(3) wrapper.  I
> even built a prototype but didn't have time to productize it.

Interesting!  Can you post the prototype?

- Josh Triplett
