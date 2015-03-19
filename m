From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH] selftests: Fix kcmp build to not require headers install
Date: Thu, 19 Mar 2015 11:02:37 +1100
Message-ID: <1426723357.14101.1.camel@ellerman.id.au>
References: <1426297504-14432-1-git-send-email-shuahkh@osg.samsung.com>
	 <1426297504-14432-2-git-send-email-shuahkh@osg.samsung.com>
	 <1426503639.4716.7.camel@ellerman.id.au> <55099415.5060400@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55099415.5060400-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, tranmanphong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2015-03-18 at 09:04 -0600, Shuah Khan wrote:
> On 03/16/2015 05:00 AM, Michael Ellerman wrote:
> > On Fri, 2015-03-13 at 19:45 -0600, Shuah Khan wrote:
> >> Change CFLAGS to look in uapi to allow kcmp to be built without
> >> requiring headers install. This will make it easier to run tests
> >> without going through the headers install step.
> >>
> >> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> >> ---
> >>  tools/testing/selftests/kcmp/Makefile | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
> >> index ff0eefd..d405ad4 100644
> >> --- a/tools/testing/selftests/kcmp/Makefile
> >> +++ b/tools/testing/selftests/kcmp/Makefile
> >> @@ -1,5 +1,5 @@
> >>  CC := $(CROSS_COMPILE)$(CC)
> >> -CFLAGS += -I../../../../usr/include/
> >> +CFLAGS += -I../../../../include/uapi -I../../../../usr/include/
> > 
> > Hi Shuah,
> > 
> > Sorry but this is wrong. The contents of include/uapi are not the same as the
> > exported kernel headers.
> > 
> > Mixing the unprocessed kernel headers with user headers leads to all sorts of
> > mess, eg:
> > 
> > $ cc -I../../../../include/uapi -I../../../../usr/include/ kcmp_test.c   -o kcmp_test
> 
> Do you see this error when you run the compile using kcmp Makefile
> or using make ksefltest target?

$ cd tools/testing/selftests
$ make TARGETS=kcmp
for TARGET in kcmp; do \
	make -C $TARGET; \
done;
make[1]: Entering directory '/home/michael/work/topics/powerpc-maint/src/misc-test/tools/testing/selftests/kcmp'
ppc64-cc -I../../../../include/uapi -I../../../../usr/include/    kcmp_test.c   -o kcmp_test
In file included from /usr/powerpc-linux-gnu/include/asm/ptrace.h:27:0,
                 from /usr/powerpc-linux-gnu/include/asm/sigcontext.h:11,
                 from /usr/powerpc-linux-gnu/include/bits/sigcontext.h:27,
                 from /usr/powerpc-linux-gnu/include/signal.h:332,
                 from kcmp_test.c:5:
../../../../include/uapi/linux/types.h:9:2: warning: #warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders" [-Wcpp]
 #warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
  ^

etc.

I don't use the kselftest target, because I'm cross compiling, and it assumes
you are running natively (it runs the tests). (And it doesn't work at the
moment because of -rR and LDFLAGS).

> Do you consider running cc directly isn't a valid use-case for
> this test?

Running cc directly is completely legitimate. It makes no difference anyway.

> I see your point that kernel headers shouldn't be included from user
> space. 

Good!

> But kcmp_test isn't really a regular use space app. It is
> intended for testing kernel. 

It is 100% a regular user space app. It tests the kernel using syscalls, just
like every other user space app.

> There are other tests that do include uapi headers.

They are also wrong and should be fixed.
 
> Requiring header install is a big hammer. Thinking about a developer
> use-case, if a developer is building and testing several kernels, it
> is tedious install headers each time and remembering to cleanup headers.

But if you are testing a kernel without installing the headers for that
kernel, you are not actually testing that kernel. You're testing that kernel
with some other kernel's headers, which is something different.

Because we are (generally) careful not to break the userspace API, it usually
works to build things with one kernels headers and run them on another kernel.
But if you're interested in testing a particular kernel version properly then
you absolutely must install that kernel's headers before building the tests.

cheers
