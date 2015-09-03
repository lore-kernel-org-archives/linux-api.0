From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 2/3] selftests: add membarrier syscall test
Date: Thu, 03 Sep 2015 19:33:59 +1000
Message-ID: <1441272839.26379.2.camel@ellerman.id.au>
References: <1436561912-24365-1-git-send-email-mathieu.desnoyers@efficios.com>
	 <1436561912-24365-3-git-send-email-mathieu.desnoyers@efficios.com>
	 <1441004040.5735.7.camel@ellerman.id.au>
	 <1071313434.33305.1441127478843.JavaMail.zimbra@efficios.com>
	 <CALCETrWpSErLUES1Wgs5+Ov8F0c-ohUwkSHFMRMZPhx-E4o2cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWpSErLUES1Wgs5+Ov8F0c-ohUwkSHFMRMZPhx-E4o2cQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Pranith Kumar <bobby.prani@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, 2015-09-01 at 11:32 -0700, Andy Lutomirski wrote:
> On Tue, Sep 1, 2015 at 10:11 AM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> > Just to make sure I understand: should we expect that
> > everyone will issue "make headers_install" on their system
> > before doing a make kselftest ?
> >
> > I see that a few selftests (e.g. memfd) are adding the
> > source tree include paths to the compiler include paths,
> > which I guess is to ensure that the kselftest will
> > work even if the system headers are not up to date.
> 
> It would be really nice if there were a clean way for selftests to
> include the kernel headers.  

What's wrong with make headers_install?

Or do you mean when writing the tests? That we could fix by adding the
../../../../usr/include path to CFLAGS in lib.mk. And fixing all the tests that
overwrite CFLAGS to append to CFLAGS.

> Perhaps make should build the exportable headers somewhere as a dependency of
> kselftests.

Yeah the top-level kselftest target could do that I think.

Folks who don't want the headers installed can just run the selftests Makefile
directly.

Does this work for you?

diff --git a/Makefile b/Makefile
index c361593..c8841d3 100644
--- a/Makefile
+++ b/Makefile
@@ -1080,7 +1080,7 @@ headers_check: headers_install
 # Kernel selftest
 
 PHONY += kselftest
-kselftest:
+kselftest: headers_install
        $(Q)$(MAKE) -C tools/testing/selftests run_tests
 
 # ---------------------------------------------------------------------------

cheers
