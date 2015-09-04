From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 2/3] selftests: add membarrier syscall test
Date: Fri, 04 Sep 2015 13:36:49 +1000
Message-ID: <1441337809.13721.1.camel@ellerman.id.au>
References: <1436561912-24365-1-git-send-email-mathieu.desnoyers@efficios.com>
	 <1436561912-24365-3-git-send-email-mathieu.desnoyers@efficios.com>
	 <1441004040.5735.7.camel@ellerman.id.au>
	 <1071313434.33305.1441127478843.JavaMail.zimbra@efficios.com>
	 <CALCETrWpSErLUES1Wgs5+Ov8F0c-ohUwkSHFMRMZPhx-E4o2cQ@mail.gmail.com>
	 <1441272839.26379.2.camel@ellerman.id.au>
	 <1734164155.35899.1441295233847.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1734164155.35899.1441295233847.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2015-09-03 at 15:47 +0000, Mathieu Desnoyers wrote:
> ----- On Sep 3, 2015, at 5:33 AM, Michael Ellerman mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org wrote:
> 
> > On Tue, 2015-09-01 at 11:32 -0700, Andy Lutomirski wrote:
> >> On Tue, Sep 1, 2015 at 10:11 AM, Mathieu Desnoyers
> >> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> >> > Just to make sure I understand: should we expect that
> >> > everyone will issue "make headers_install" on their system
> >> > before doing a make kselftest ?
> >> >
> >> > I see that a few selftests (e.g. memfd) are adding the
> >> > source tree include paths to the compiler include paths,
> >> > which I guess is to ensure that the kselftest will
> >> > work even if the system headers are not up to date.
> >> 
> >> It would be really nice if there were a clean way for selftests to
> >> include the kernel headers.
> > 
> > What's wrong with make headers_install?
> > 
> > Or do you mean when writing the tests? That we could fix by adding the
> > ../../../../usr/include path to CFLAGS in lib.mk. And fixing all the tests that
> > overwrite CFLAGS to append to CFLAGS.
> > 
> >> Perhaps make should build the exportable headers somewhere as a dependency of
> >> kselftests.
> > 
> > Yeah the top-level kselftest target could do that I think.
> > 
> > Folks who don't want the headers installed can just run the selftests Makefile
> > directly.
> > 
> > Does this work for you?
> > 
> > diff --git a/Makefile b/Makefile
> > index c361593..c8841d3 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1080,7 +1080,7 @@ headers_check: headers_install
> > # Kernel selftest
> > 
> > PHONY += kselftest
> > -kselftest:
> > +kselftest: headers_install
> >        $(Q)$(MAKE) -C tools/testing/selftests run_tests
> 
> My personal experience is that make headers_install does not necessarily play
> well with the distribution header file hierarchy, which requires some tweaks
> to be done by the users (e.g. asm vs x86_64-linux-gnu).

OK, I've never had issues. What exactly are you doing and how is it going wrong?

> Also, headers_install typically expects a INSTALL_HDR_PATH. 

You can specify it, but the default is just usr/, ie. in the kernel directory,
that is what I was proposing. (Actually it's $(objtree)/usr).

> It would be interesting if we could install the kernel headers into a
> specific location that is then re-used by kselftest, so using it without too
> much manual configuration does not require to overwrite the distribution
> header files to run tests.

I think we can do that now, ie:

  $ ls /usr/include/linux/membarrier.h
  ls: cannot access /usr/include/linux/membarrier.h: No such file or directory

  $ cd linux-next
  $ make mrproper
  $ make headers_install
  ...
  $ ls usr/include/linux/membarrier.h
  usr/include/linux/membarrier.h
  $ make -C tools/testing/selftests TARGETS=membarrier
  make: Entering directory '/home/michael/work/topics/selftests/linux-next/tools/testing/selftests'
  for TARGET in membarrier; do \
  	make -C $TARGET; \
  done;
  make[1]: Entering directory '/home/michael/work/topics/selftests/linux-next/tools/testing/selftests/membarrier'
  gcc -g -I../../../../usr/include/ membarrier_test.c -o membarrier_test
  make[1]: Leaving directory '/home/michael/work/topics/selftests/linux-next/tools/testing/selftests/membarrier'
  make: Leaving directory '/home/michael/work/topics/selftests/linux-next/tools/testing/selftests'

  $ ./tools/testing/selftests/membarrier/membarrier_test
  membarrier MEMBARRIER_CMD_QUERY failed. Function not implemented.
  $


So that seems to be working for me. Are you doing some different work flow, or
am I just missing something?

I guess it probably doesn't work if you're using O=.. ?

cheers
