From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 2/2] selftests/userfaultfd: improve syscall number
 definition
Date: Thu, 24 Sep 2015 12:04:40 +1000
Message-ID: <1443060280.21433.2.camel@ellerman.id.au>
References: <1442918756-17892-1-git-send-email-andre.przywara@arm.com>
	 <1442918756-17892-3-git-send-email-andre.przywara@arm.com>
	 <56015C59.5010300@osg.samsung.com> <20150922140625.GH25412@redhat.com>
	 <56018CA0.8050600@arm.com> <1443002109.9279.1.camel@ellerman.id.au>
	 <5602A505.8090804@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5602A505.8090804-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2015-09-23 at 14:11 +0100, Andre Przywara wrote:
> Hi Michael,
> 
> On 23/09/15 10:55, Michael Ellerman wrote:
> > On Tue, 2015-09-22 at 18:15 +0100, Andre Przywara wrote:
> >> On 22/09/15 15:06, Andrea Arcangeli wrote:
> >>> Andre, could you see if linux-next (which includes -mm) works for you
> >>> by just running "cd tools/testing/selftests/vm/ && make"? If there's
> >>> any further change required could you diff it against linux-next?
> >>
> >> This doesn't compile now for me, because it looks into
> >> /usr/include/asm/unistd.h, which I keep to the distribution copy of it.
> >> Also linux/userfaultfd.h is missing, because it's brand new.
> > ...
> >> I guess the right solution would be to hack the Makefile to set the
> >> include path to the kernel's copy of include/uapi, though I am not sure
> >> this works cleanly for different architectures and separate build
> >> directories. I will give this a try ...
> > 
> > Not that's not the right solution.
> > 
> > The right solution is to export the kernel headers, the Makefile will pick them
> > up (at least in linux-next):
> 
> Actually that was I was hoping for, I just missed the possibility of
> headers_install to put the files back into the kernel tree (I usually
> use it with INSTALL_HDR_PATH for packaging).

OK great.

It does seem that folks are struggling to work out how to do this, so maybe we
can come up with a way to have it automated.

> >   $ cd linux
> >   $ make headers_install
> >   $ ls usr/include/
> >   asm/  asm-generic/  drm/  linux/  misc/  mtd/  rdma/  scsi/  sound/  uapi/  video/  xen/
> >   $ make -C tools/testing/selftests TARGETS=vm
> >   ...
> >   $ ls tools/testing/selftests/vm/userfaultfd
> >   tools/testing/selftests/vm/userfaultfd*
> 
> Yes, that works. Now I have just to figure out how to arrange this with
> out-of-tree build directories.

Right, I think it doesn't work at the moment.

The makefiles that look for the kernel headers use ../../../../usr/include,
which probably isn't what you want for an out of tree build.

Maybe we should do something like the below.

It allows you to do:

  $ make O=~/work/build/ headers_install
  $ ls ~/work/build/usr/include/
  asm/  asm-generic/  drm/  linux/  misc/  mtd/  rdma/  scsi/  sound/  uapi/  video/  xen/
  $ ls usr/include
  ls: cannot access usr/include: No such file or directory
  $ make -C tools/testing/selftests KERNEL_HEADERS=~/work/build/usr/include/ TARGEST=vm
  $ ls tools/testing/selftests/vm/userfaultfd
  tools/testing/selftests/vm/userfaultfd*

cheers


diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 8922c2155a47..617a76be3889 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -41,6 +41,9 @@ override LDFLAGS =
 override MAKEFLAGS =
 endif
 
+KERNEL_HEADERS ?= $(abspath ../../../usr/include)
+export KERNEL_HEADERS
+
 all:
        for TARGET in $(TARGETS); do \
                make -C $$TARGET; \
diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index e4bb1de1d526..4f45b9c8dd75 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -1,6 +1,6 @@
 # Makefile for vm selftests
 
-CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
+CFLAGS = -Wall -I $(KERNEL_HEADERS) $(EXTRA_CFLAGS)
 BINARIES = compaction_test
 BINARIES += hugepage-mmap
 BINARIES += hugepage-shm
@@ -14,12 +14,9 @@ BINARIES += userfaultfd
 all: $(BINARIES)
 %: %.c
        $(CC) $(CFLAGS) -o $@ $^ -lrt
-userfaultfd: userfaultfd.c ../../../../usr/include/linux/kernel.h
+userfaultfd: userfaultfd.c $(KERNEL_HEADERS)/linux/kernel.h
        $(CC) $(CFLAGS) -O2 -o $@ $< -lpthread
 
-../../../../usr/include/linux/kernel.h:
-       make -C ../../../.. headers_install
-
 TEST_PROGS := run_vmtests
 TEST_FILES := $(BINARIES)
 
