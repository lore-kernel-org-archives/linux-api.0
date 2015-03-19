From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH] selftests: Fix kcmp build to not require headers install
Date: Thu, 19 Mar 2015 11:51:08 +1100
Message-ID: <1426726268.14101.5.camel@ellerman.id.au>
References: <1426297504-14432-1-git-send-email-shuahkh@osg.samsung.com>
	 <1426297504-14432-2-git-send-email-shuahkh@osg.samsung.com>
	 <1426503639.4716.7.camel@ellerman.id.au> <55099415.5060400@osg.samsung.com>
	 <1426723357.14101.1.camel@ellerman.id.au>
	 <550A15EB.1060900@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550A15EB.1060900-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, tranmanphong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2015-03-18 at 18:18 -0600, Shuah Khan wrote:
> On 03/18/2015 06:02 PM, Michael Ellerman wrote:
> > On Wed, 2015-03-18 at 09:04 -0600, Shuah Khan wrote:
> >> On 03/16/2015 05:00 AM, Michael Ellerman wrote:
> >>> On Fri, 2015-03-13 at 19:45 -0600, Shuah Khan wrote:
> >>>> Change CFLAGS to look in uapi to allow kcmp to be built without
> >>>> requiring headers install. This will make it easier to run tests
> >>>> without going through the headers install step.
> >>>>
> >>>> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> >>>> ---
> >>>>  tools/testing/selftests/kcmp/Makefile | 2 +-
> >>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
> >>>> index ff0eefd..d405ad4 100644
> >>>> --- a/tools/testing/selftests/kcmp/Makefile
> >>>> +++ b/tools/testing/selftests/kcmp/Makefile
> >>>> @@ -1,5 +1,5 @@
> >>>>  CC := $(CROSS_COMPILE)$(CC)
> >>>> -CFLAGS += -I../../../../usr/include/
> >>>> +CFLAGS += -I../../../../include/uapi -I../../../../usr/include/
> >>>
> >>> Hi Shuah,
> >>>
> >>> Sorry but this is wrong. The contents of include/uapi are not the same as the
> >>> exported kernel headers.
> >>>
> >>> Mixing the unprocessed kernel headers with user headers leads to all sorts of
> >>> mess, eg:
> >>>
> >>> $ cc -I../../../../include/uapi -I../../../../usr/include/ kcmp_test.c   -o kcmp_test
> >>
> >> Do you see this error when you run the compile using kcmp Makefile
> >> or using make ksefltest target?
> > 
> > $ cd tools/testing/selftests
> > $ make TARGETS=kcmp
> > for TARGET in kcmp; do \
> > 	make -C $TARGET; \
> > done;
> > make[1]: Entering directory '/home/michael/work/topics/powerpc-maint/src/misc-test/tools/testing/selftests/kcmp'
> > ppc64-cc -I../../../../include/uapi -I../../../../usr/include/    kcmp_test.c   -o kcmp_test
> > In file included from /usr/powerpc-linux-gnu/include/asm/ptrace.h:27:0,
> >                  from /usr/powerpc-linux-gnu/include/asm/sigcontext.h:11,
> >                  from /usr/powerpc-linux-gnu/include/bits/sigcontext.h:27,
> >                  from /usr/powerpc-linux-gnu/include/signal.h:332,
> >                  from kcmp_test.c:5:
> > ../../../../include/uapi/linux/types.h:9:2: warning: #warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders" [-Wcpp]
> >  #warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
> >   ^
> > 
> 
> Hmm..  I don't see this when I run it on x86
> 
> make TARGETS=kcmp
> for TARGET in kcmp; do \
> 	make -C $TARGET; \
> done;
> make[1]: Entering directory
> '/lkml/linux-kselftest/tools/testing/selftests/kcmp'
> cc -I../../../../include/uapi -I../../../../usr/include/    kcmp_test.c
>   -o kcmp_test
> make[1]: Leaving directory
> '/lkml/linux-kselftest/tools/testing/selftests/kcmp'

Yeah, but that's basically just luck.

$ cc -w -H -I../../../../include/uapi -I../../../../usr/include/    kcmp_test.c   -o kcmp_test
. /usr/include/stdio.h
.. /usr/include/features.h
... /usr/include/x86_64-linux-gnu/sys/cdefs.h
.... /usr/include/x86_64-linux-gnu/bits/wordsize.h
... /usr/include/x86_64-linux-gnu/gnu/stubs.h
.... /usr/include/x86_64-linux-gnu/gnu/stubs-64.h
.. /usr/lib/gcc/x86_64-linux-gnu/4.9/include/stddef.h
.. /usr/include/x86_64-linux-gnu/bits/types.h
... /usr/include/x86_64-linux-gnu/bits/wordsize.h
... /usr/include/x86_64-linux-gnu/bits/typesizes.h
.. /usr/include/libio.h
... /usr/include/_G_config.h
.... /usr/lib/gcc/x86_64-linux-gnu/4.9/include/stddef.h
.... /usr/include/wchar.h
... /usr/lib/gcc/x86_64-linux-gnu/4.9/include/stdarg.h
.. /usr/include/x86_64-linux-gnu/bits/stdio_lim.h
.. /usr/include/x86_64-linux-gnu/bits/sys_errlist.h
. /usr/include/stdlib.h
.. /usr/lib/gcc/x86_64-linux-gnu/4.9/include/stddef.h
.. /usr/include/x86_64-linux-gnu/bits/waitflags.h
.. /usr/include/x86_64-linux-gnu/bits/waitstatus.h
... /usr/include/endian.h
.... /usr/include/x86_64-linux-gnu/bits/endian.h
.... /usr/include/x86_64-linux-gnu/bits/byteswap.h
..... /usr/include/x86_64-linux-gnu/bits/wordsize.h
..... /usr/include/x86_64-linux-gnu/bits/byteswap-16.h
.. /usr/include/xlocale.h
.. /usr/include/x86_64-linux-gnu/sys/types.h
... /usr/include/time.h
... /usr/lib/gcc/x86_64-linux-gnu/4.9/include/stddef.h
... /usr/include/x86_64-linux-gnu/sys/select.h
.... /usr/include/x86_64-linux-gnu/bits/select.h
..... /usr/include/x86_64-linux-gnu/bits/wordsize.h
.... /usr/include/x86_64-linux-gnu/bits/sigset.h
.... /usr/include/time.h
.... /usr/include/x86_64-linux-gnu/bits/time.h
... /usr/include/x86_64-linux-gnu/sys/sysmacros.h
... /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h
.... /usr/include/x86_64-linux-gnu/bits/wordsize.h
.. /usr/include/alloca.h
... /usr/lib/gcc/x86_64-linux-gnu/4.9/include/stddef.h
.. /usr/include/x86_64-linux-gnu/bits/stdlib-float.h
. /usr/include/signal.h
.. /usr/include/x86_64-linux-gnu/bits/sigset.h
.. /usr/include/x86_64-linux-gnu/bits/signum.h
.. /usr/include/time.h
.. /usr/include/x86_64-linux-gnu/bits/siginfo.h
... /usr/include/x86_64-linux-gnu/bits/wordsize.h
.. /usr/include/x86_64-linux-gnu/bits/sigaction.h
.. /usr/include/x86_64-linux-gnu/bits/sigcontext.h
.. /usr/lib/gcc/x86_64-linux-gnu/4.9/include/stddef.h
.. /usr/include/x86_64-linux-gnu/bits/sigstack.h
.. /usr/include/x86_64-linux-gnu/sys/ucontext.h
... /usr/include/signal.h
.. /usr/include/x86_64-linux-gnu/bits/sigthread.h
. /usr/lib/gcc/x86_64-linux-gnu/4.9/include-fixed/limits.h
.. /usr/lib/gcc/x86_64-linux-gnu/4.9/include-fixed/syslimits.h
... /usr/lib/gcc/x86_64-linux-gnu/4.9/include-fixed/limits.h
.... /usr/include/limits.h
..... /usr/include/x86_64-linux-gnu/bits/posix1_lim.h
...... /usr/include/x86_64-linux-gnu/bits/local_lim.h
....... ../../../../include/uapi/linux/limits.h
..... /usr/include/x86_64-linux-gnu/bits/posix2_lim.h
..... /usr/include/x86_64-linux-gnu/bits/xopen_lim.h
...... /usr/include/x86_64-linux-gnu/bits/stdio_lim.h
. /usr/include/unistd.h
.. /usr/include/x86_64-linux-gnu/bits/posix_opt.h
.. /usr/include/x86_64-linux-gnu/bits/environments.h
... /usr/include/x86_64-linux-gnu/bits/wordsize.h
.. /usr/lib/gcc/x86_64-linux-gnu/4.9/include/stddef.h
.. /usr/include/x86_64-linux-gnu/bits/confname.h
.. /usr/include/getopt.h
. /usr/include/errno.h
.. /usr/include/x86_64-linux-gnu/bits/errno.h
... ../../../../include/uapi/linux/errno.h
.... /usr/include/x86_64-linux-gnu/asm/errno.h
..... ../../../../include/uapi/asm-generic/errno.h
...... ../../../../include/uapi/asm-generic/errno-base.h
. /usr/include/string.h
.. /usr/lib/gcc/x86_64-linux-gnu/4.9/include/stddef.h
. /usr/include/fcntl.h
.. /usr/include/x86_64-linux-gnu/bits/fcntl.h
... /usr/include/x86_64-linux-gnu/bits/fcntl-linux.h
.... /usr/include/x86_64-linux-gnu/bits/uio.h
.. /usr/include/time.h
.. /usr/include/x86_64-linux-gnu/bits/stat.h
. ../../../../include/uapi/linux/unistd.h
.. /usr/include/x86_64-linux-gnu/asm/unistd.h
... /usr/include/x86_64-linux-gnu/asm/unistd_64.h
. ../../../../include/uapi/linux/kcmp.h
. /usr/include/x86_64-linux-gnu/sys/syscall.h
.. /usr/include/x86_64-linux-gnu/bits/syscall.h
. /usr/include/x86_64-linux-gnu/sys/stat.h
.. /usr/include/time.h
.. /usr/include/x86_64-linux-gnu/bits/stat.h
. /usr/include/x86_64-linux-gnu/sys/wait.h
.. /usr/include/x86_64-linux-gnu/bits/siginfo.h
... /usr/include/x86_64-linux-gnu/bits/wordsize.h
. ../kselftest.h
Multiple include guards may be useful for:
../../../../include/uapi/linux/errno.h
/usr/include/errno.h
/usr/include/limits.h
/usr/include/wchar.h
/usr/include/x86_64-linux-gnu/asm/errno.h
/usr/include/x86_64-linux-gnu/bits/byteswap-16.h
/usr/include/x86_64-linux-gnu/bits/byteswap.h
/usr/include/x86_64-linux-gnu/bits/confname.h
/usr/include/x86_64-linux-gnu/bits/endian.h
/usr/include/x86_64-linux-gnu/bits/environments.h
/usr/include/x86_64-linux-gnu/bits/errno.h
/usr/include/x86_64-linux-gnu/bits/fcntl-linux.h
/usr/include/x86_64-linux-gnu/bits/fcntl.h
/usr/include/x86_64-linux-gnu/bits/local_lim.h
/usr/include/x86_64-linux-gnu/bits/select.h
/usr/include/x86_64-linux-gnu/bits/sigaction.h
/usr/include/x86_64-linux-gnu/bits/signum.h
/usr/include/x86_64-linux-gnu/bits/sigstack.h
/usr/include/x86_64-linux-gnu/bits/stdlib-float.h
/usr/include/x86_64-linux-gnu/bits/sys_errlist.h
/usr/include/x86_64-linux-gnu/bits/syscall.h
/usr/include/x86_64-linux-gnu/bits/time.h
/usr/include/x86_64-linux-gnu/bits/typesizes.h
/usr/include/x86_64-linux-gnu/bits/uio.h
/usr/include/x86_64-linux-gnu/bits/waitflags.h
/usr/include/x86_64-linux-gnu/bits/waitstatus.h
/usr/include/x86_64-linux-gnu/gnu/stubs-64.h
/usr/include/x86_64-linux-gnu/gnu/stubs.h
/usr/lib/gcc/x86_64-linux-gnu/4.9/include-fixed/syslimits.h


As you can see it uses a few uapi headers, but not many, and we seem to get
away with it.

On powerpc instead we have:

$ ppc64-cc -w -H -I../../../../include/uapi -I../../../../usr/include/    kcmp_test.c   -o kcmp_test
. /usr/powerpc-linux-gnu/include/stdio.h
.. /usr/powerpc-linux-gnu/include/features.h
... /usr/powerpc-linux-gnu/include/sys/cdefs.h
.... /usr/powerpc-linux-gnu/include/bits/wordsize.h
... /usr/powerpc-linux-gnu/include/gnu/stubs.h
.... /usr/powerpc-linux-gnu/include/bits/wordsize.h
.... /usr/powerpc-linux-gnu/include/gnu/stubs-32.h
.. /usr/lib/gcc-cross/powerpc-linux-gnu/4.9/include/stddef.h
.. /usr/powerpc-linux-gnu/include/bits/types.h
... /usr/powerpc-linux-gnu/include/bits/wordsize.h
... /usr/powerpc-linux-gnu/include/bits/typesizes.h
.. /usr/powerpc-linux-gnu/include/libio.h
... /usr/powerpc-linux-gnu/include/_G_config.h
.... /usr/lib/gcc-cross/powerpc-linux-gnu/4.9/include/stddef.h
.... /usr/powerpc-linux-gnu/include/wchar.h
... /usr/lib/gcc-cross/powerpc-linux-gnu/4.9/include/stdarg.h
.. /usr/powerpc-linux-gnu/include/bits/stdio_lim.h
.. /usr/powerpc-linux-gnu/include/bits/sys_errlist.h
. /usr/powerpc-linux-gnu/include/stdlib.h
.. /usr/lib/gcc-cross/powerpc-linux-gnu/4.9/include/stddef.h
.. /usr/powerpc-linux-gnu/include/bits/waitflags.h
.. /usr/powerpc-linux-gnu/include/bits/waitstatus.h
... /usr/powerpc-linux-gnu/include/endian.h
.... /usr/powerpc-linux-gnu/include/bits/endian.h
.... /usr/powerpc-linux-gnu/include/bits/byteswap.h
..... /usr/powerpc-linux-gnu/include/bits/byteswap-16.h
.. /usr/powerpc-linux-gnu/include/xlocale.h
.. /usr/powerpc-linux-gnu/include/sys/types.h
... /usr/powerpc-linux-gnu/include/time.h
... /usr/lib/gcc-cross/powerpc-linux-gnu/4.9/include/stddef.h
... /usr/powerpc-linux-gnu/include/sys/select.h
.... /usr/powerpc-linux-gnu/include/bits/select.h
.... /usr/powerpc-linux-gnu/include/bits/sigset.h
.... /usr/powerpc-linux-gnu/include/time.h
.... /usr/powerpc-linux-gnu/include/bits/time.h
... /usr/powerpc-linux-gnu/include/sys/sysmacros.h
... /usr/powerpc-linux-gnu/include/bits/pthreadtypes.h
.... /usr/powerpc-linux-gnu/include/bits/wordsize.h
.. /usr/powerpc-linux-gnu/include/alloca.h
... /usr/lib/gcc-cross/powerpc-linux-gnu/4.9/include/stddef.h
.. /usr/powerpc-linux-gnu/include/bits/stdlib-float.h
. /usr/powerpc-linux-gnu/include/signal.h
.. /usr/powerpc-linux-gnu/include/bits/sigset.h
.. /usr/powerpc-linux-gnu/include/bits/signum.h
.. /usr/powerpc-linux-gnu/include/time.h
.. /usr/powerpc-linux-gnu/include/bits/siginfo.h
... /usr/powerpc-linux-gnu/include/bits/wordsize.h
.. /usr/powerpc-linux-gnu/include/bits/sigaction.h
.. /usr/powerpc-linux-gnu/include/bits/sigcontext.h
... /usr/powerpc-linux-gnu/include/asm/sigcontext.h
.... /usr/powerpc-linux-gnu/include/asm/ptrace.h
..... ../../../../include/uapi/linux/types.h
...... /usr/powerpc-linux-gnu/include/asm/types.h
....... ../../../../include/uapi/asm-generic/int-ll64.h
........ /usr/powerpc-linux-gnu/include/asm/bitsperlong.h
......... ../../../../include/uapi/asm-generic/bitsperlong.h
...... ../../../../include/uapi/linux/posix_types.h
....... ../../../../include/uapi/linux/stddef.h
In file included from ../../../../include/uapi/linux/posix_types.h:4:0,
                 from ../../../../include/uapi/linux/types.h:13,
                 from /usr/powerpc-linux-gnu/include/asm/ptrace.h:27,
                 from /usr/powerpc-linux-gnu/include/asm/sigcontext.h:11,
                 from /usr/powerpc-linux-gnu/include/bits/sigcontext.h:27,
                 from /usr/powerpc-linux-gnu/include/signal.h:332,
                 from kcmp_test.c:5:
../../../../include/uapi/linux/stddef.h:1:28: fatal error: linux/compiler.h: No such file or directory
 #include <linux/compiler.h>
                            ^
compilation terminated.


So things start to go badly when we include asm/sigcontext.h. It just comes
down to the exact sequence the headers are included, and we can't do much about
that.

cheers
