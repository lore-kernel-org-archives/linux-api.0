From: josh@joshtriplett.org
Subject: Re: [PATCHv2 1/1] Documentation: describe how to add a system call
Date: Fri, 31 Jul 2015 13:59:41 -0700
Message-ID: <20150731205941.GA30362@cloud>
References: <1438242731-27756-1-git-send-email-drysdale@google.com>
 <1438242731-27756-2-git-send-email-drysdale@google.com>
 <20150730083831.GA22182@gmail.com>
 <CAHse=S-Wgv8JKu72FQaivou1PAwyexqjn_sjtMu3n=ezX0x-vg@mail.gmail.com>
 <CAGXu5j+5KHy68ELU6PmNWaj7mQBXTbRQGXqJFwsXHt9n0LPw8Q@mail.gmail.com>
 <20150730190434.GD16452@x>
 <CAGXu5jJwtVgPmmMHiR0M27he3ma7exfSH8OBNdLMFQcbbtzUfg@mail.gmail.com>
 <20150731010234.GA7265@x>
 <CAGXu5jLethUkiq1QEZg-uRkOzofa6M8WCT8T7qAByWy5L4xHBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLethUkiq1QEZg-uRkOzofa6M8WCT8T7qAByWy5L4xHBw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Drysdale <drysdale@google.com>, Ingo Molnar <mingo@kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Shuah Khan <shuahkh@osg.samsung.com>, Jonathan Corbet <corbet@lwn.net>, Eric B Munson <emunson@akamai.com>, Randy Dunlap <rdunlap@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Alexei Starovoitov <ast@plumgrid.com>David
List-Id: linux-api@vger.kernel.org

On Fri, Jul 31, 2015 at 11:56:06AM -0700, Kees Cook wrote:
> On Thu, Jul 30, 2015 at 6:02 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> > On Thu, Jul 30, 2015 at 01:03:43PM -0700, Kees Cook wrote:
> >> On Thu, Jul 30, 2015 at 12:04 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> >> > On Thu, Jul 30, 2015 at 11:21:54AM -0700, Kees Cook wrote:
> >> >> I like this, it's a good description of both options. I'm still biased
> >> >> about the approach: I prefer flags, since pointers to user structures
> >> >> complicate syscall filtering. ;)
> >> >
> >> > Seems like we should do two things to make that easier:
> >> >
> >> > 1) Create a standardized kernel mechanism for parameter-struct handling,
> >> >    implementing the recommendations mentioned here.
> >>
> >> It's been suggested in the past that nlmsg is appropriate for such a
> >> thing, but I remain suspicious. :)
> >
> > Likewise. :)
> >
> >> > 2) Integrate into that mechanism a way to filter the resulting parameter
> >> >    struct with BPF *after* it has been copied to kernel space (and thus
> >> >    can no longer be tampered with).
> >>
> >> Yeah, this is a irritating part: the structures operated on are copied
> >> from userspace adhoc in each syscall. Doing argument checking would
> >> mean double copies initially, and perhaps teaching syscalls about
> >> optional "already copied" arguments or something as an optimization.
> >
> > No, double copies can't work for security reasons.  Because otherwise
> > you could race the kernel from another thread, substituting different
> > values after the check and before the use.
> 
> Right, the double copy method would require setting up a per-thread
> userspace memory mapping that was read-only from userspace but
> writable from kernel space.

Which seems like a lot more trouble than just copying it once.

> > I think the right API looks *roughly* like this:
> >
> > int _copy_param_struct(size_t kernel_len, void *kernel_struct, size_t user_len, void __user *user_struct)
> > {
> >         if (user_len > kernel_len)
> >                 return -EINVAL;
> >         if (user_len && copy_from_user(kernel_struct, user_struct, user_len))
> >                 return -EFAULT;
> >         if (user_len < kernel_len)
> >                 memset(kernel_struct + user_len, 0, kernel_len - user_len);
> >         return 0;
> > }
> >
> > #define copy_param_struct(kernel_struct, user_len, user_struct) _copy_param_struct( \
> >                 sizeof(*kernel_struct) + BUILD_BUG_ON_ZERO(!__same_type(*kernel_struct, *user_struct)), \
> >                 kernel_struct, user_len, user_struct)
> >
> >
> > Then the syscall looks like this:
> >
> > SYSCALL_DEFINEn(xyzzy, ..., ..., size_t user_params_len, struct xyzzy_params __user *user_params)
> > {
> >         int ret;
> >         struct xyzzy_params params;
> >
> >         ret = copy_param_struct(&params, user_params_len, user_params);
> >         if (ret)
> >                 return ret;
> >         ...
> >
> >
> > And you could then hook copy_params_struct to add arbitrary additional
> > syscall parameter validation.  Bonus if there's some way to make the
> > copy and validation occur before the syscall is ever invoked, rather
> > than inside the syscall, but that would require adding fancier syscall
> > definition mechanisms that autogenerate such code.
> 
> The trouble is that the hook for the syscall (both seccomp and ptrace)
> happens before the sys_* function executes. So the param extract
> suddenly becomes optional. As in, did ptrace/seccomp already extract
> the args? If so, use that copy, else copy them out myself now that I
> need them, etc.
> 
> It's entirely doable, but it's going to require some careful design.

Agreed.  I think the proposal above would be a net improvement, but
ideally you'd want something that's annotated and generates automatic
marshalling code.

- Josh Triplett
