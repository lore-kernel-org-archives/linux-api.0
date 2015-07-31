From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Thu, 30 Jul 2015 18:03:44 -0700
Message-ID: <20150731010344.GA8050@x>
References: <1438242731-27756-1-git-send-email-drysdale@google.com>
 <1438242731-27756-2-git-send-email-drysdale@google.com>
 <20150730083831.GA22182@gmail.com>
 <CAHse=S-Wgv8JKu72FQaivou1PAwyexqjn_sjtMu3n=ezX0x-vg@mail.gmail.com>
 <CAGXu5j+5KHy68ELU6PmNWaj7mQBXTbRQGXqJFwsXHt9n0LPw8Q@mail.gmail.com>
 <20150730190434.GD16452@x>
 <CAGXu5jJwtVgPmmMHiR0M27he3ma7exfSH8OBNdLMFQcbbtzUfg@mail.gmail.com>
 <20150731010234.GA7265@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150731010234.GA7265@x>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>David
List-Id: linux-api@vger.kernel.org

On Thu, Jul 30, 2015 at 06:02:34PM -0700, Josh Triplett wrote:
> On Thu, Jul 30, 2015 at 01:03:43PM -0700, Kees Cook wrote:
> > On Thu, Jul 30, 2015 at 12:04 PM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> > > On Thu, Jul 30, 2015 at 11:21:54AM -0700, Kees Cook wrote:
> > >> I like this, it's a good description of both options. I'm still biased
> > >> about the approach: I prefer flags, since pointers to user structures
> > >> complicate syscall filtering. ;)
> > >
> > > Seems like we should do two things to make that easier:
> > >
> > > 1) Create a standardized kernel mechanism for parameter-struct handling,
> > >    implementing the recommendations mentioned here.
> > 
> > It's been suggested in the past that nlmsg is appropriate for such a
> > thing, but I remain suspicious. :)
> 
> Likewise. :)
> 
> > > 2) Integrate into that mechanism a way to filter the resulting parameter
> > >    struct with BPF *after* it has been copied to kernel space (and thus
> > >    can no longer be tampered with).
> > 
> > Yeah, this is a irritating part: the structures operated on are copied
> > from userspace adhoc in each syscall. Doing argument checking would
> > mean double copies initially, and perhaps teaching syscalls about
> > optional "already copied" arguments or something as an optimization.
> 
> No, double copies can't work for security reasons.  Because otherwise
> you could race the kernel from another thread, substituting different
> values after the check and before the use.
> 
> I think the right API looks *roughly* like this:
> 
> int _copy_param_struct(size_t kernel_len, void *kernel_struct, size_t user_len, void __user *user_struct)
> {
> 	if (user_len > kernel_len)
> 		return -EINVAL;
> 	if (user_len && copy_from_user(kernel_struct, user_struct, user_len))
> 		return -EFAULT;
> 	if (user_len < kernel_len)
> 		memset(kernel_struct + user_len, 0, kernel_len - user_len);
> 	return 0;
> }
> 
> #define copy_param_struct(kernel_struct, user_len, user_struct) _copy_param_struct( \
> 		sizeof(*kernel_struct) + BUILD_BUG_ON_ZERO(!__same_type(*kernel_struct, *user_struct)), \
> 		kernel_struct, user_len, user_struct)
> 
> 
> Then the syscall looks like this:
> 
> SYSCALL_DEFINEn(xyzzy, ..., ..., size_t user_params_len, struct xyzzy_params __user *user_params)

Missed a couple of commas here (after the types and before the names).

> {
> 	int ret;
> 	struct xyzzy_params params;
> 
> 	ret = copy_param_struct(&params, user_params_len, user_params);
> 	if (ret)
> 		return ret;
> 	...
> 
> 
> And you could then hook copy_params_struct to add arbitrary additional
> syscall parameter validation.  Bonus if there's some way to make the
> copy and validation occur before the syscall is ever invoked, rather
> than inside the syscall, but that would require adding fancier syscall
> definition mechanisms that autogenerate such code.
> 
> - Josh Triplett
