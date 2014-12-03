From: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
Subject: Re: [PATCH v5] selftest: size: Add size test for Linux kernel
Date: Wed, 3 Dec 2014 08:29:11 -0800
Message-ID: <547F3A57.7000106@sonymobile.com>
References: <547E854E.5060101@sonymobile.com> <1417578191.16722.11.camel@concordia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417578191.16722.11.camel@concordia>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 12/02/2014 07:43 PM, Michael Ellerman wrote:
> On Tue, 2014-12-02 at 19:36 -0800, Tim Bird wrote:
>> This test shows the amount of memory used by the system.
>> Note that this is dependent on the user-space that is loaded
>> when this program runs.  Optimally, this program would be
>> run as the init program itself.
> 
> Sorry to only chime in at v5.
> 
>> diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
>> new file mode 100644
>> index 0000000..47f8e9c
>> --- /dev/null
>> +++ b/tools/testing/selftests/size/Makefile
>> @@ -0,0 +1,15 @@
>> +#ifndef CC
>> +	CC = $(CROSS_COMPILE)gcc
>> +#endif
> 
> I think the following is preferable:
> 
>   CC := $(CROSS_COMPILE)$(CC)
> 
> 
> It allows optionally setting a custom CC, as well as optionally CROSS_COMPILE.

I'm not sure I follow this.

If CC is unset, you get only the CROSS_COMPILE prefix.
If CC is set to e.g. 'gcc', then you get a nicely formatted toolchain string.
But if CC already has the prefix applied, then this will result in
  having it duplicated, which surely won't work correctly.

In the long run, I would hope that a higher level Makefile or environment setting
will be setting the toolchain string appropriately (as well as handling build flags)
which is why I wanted to use an ifndef (which Thomas correctly pointed out is just
wrong).

Actually, after getting this tiny program accepted, my next task was working on a
proper fix for handling cross compilation in a more generic (not case-by-case) way.

CROSS_COMPILE prefix usage looks a bit uncoordinated in the tools directory, but most
tests seem to be favoring $(CROSS_COMPILE)gcc.

 $ cd tools ; mgrep CROSS
./vm/Makefile:CC = $(CROSS_COMPILE)gcc
./usb/Makefile:CC = $(CROSS_COMPILE)gcc
./testing/selftests/net/Makefile:CC = $(CROSS_COMPILE)gcc
./testing/selftests/vm/Makefile:CC = $(CROSS_COMPILE)gcc
./testing/selftests/efivarfs/Makefile:CC = $(CROSS_COMPILE)gcc
./testing/selftests/size/Makefile:	CC = $(CROSS_COMPILE)gcc
./testing/selftests/powerpc/Makefile:CC := $(CROSS_COMPILE)$(CC)
./hv/Makefile:CC = $(CROSS_COMPILE)gcc
./perf/config/feature-checks/Makefile:CC := $(CROSS_COMPILE)gcc -MD
./perf/config/feature-checks/Makefile:PKG_CONFIG := $(CROSS_COMPILE)pkg-config
./lib/api/Makefile:CC = $(CROSS_COMPILE)gcc
./lib/api/Makefile:AR = $(CROSS_COMPILE)ar
./lib/lockdep/Makefile:# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
./lib/lockdep/Makefile:$(call allow-override,CC,$(CROSS_COMPILE)gcc)
./lib/lockdep/Makefile:$(call allow-override,AR,$(CROSS_COMPILE)ar)
./lib/lockdep/Makefile:TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):$(ARCH):$(CROSS_COMPILE)
./lib/traceevent/Makefile:# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
./lib/traceevent/Makefile:$(call allow-override,CC,$(CROSS_COMPILE)gcc)
./lib/traceevent/Makefile:$(call allow-override,AR,$(CROSS_COMPILE)ar)
./lib/traceevent/Makefile:TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):$(ARCH):$(CROSS_COMPILE)
./cgroup/Makefile:CC = $(CROSS_COMPILE)gcc
./power/acpi/Makefile:CROSS = #/usr/i386-linux-uclibc/usr/bin/i386-uclibc-
./power/acpi/Makefile:CC = $(CROSS)gcc
./power/acpi/Makefile:LD = $(CROSS)gcc
./power/acpi/Makefile:STRIP = $(CROSS)strip
./power/cpupower/Makefile:CROSS = #/usr/i386-linux-uclibc/usr/bin/i386-uclibc-
./power/cpupower/Makefile:CC = $(CROSS)gcc
./power/cpupower/Makefile:LD = $(CROSS)gcc
./power/cpupower/Makefile:AR = $(CROSS)ar
./power/cpupower/Makefile:STRIP = $(CROSS)strip
./power/cpupower/Makefile:RANLIB = $(CROSS)ranlib
./power/cpupower/Makefile:export CROSS CC AR STRIP RANLIB CFLAGS LDFLAGS LIB_OBJS
./power/x86/turbostat/Makefile:CC		= $(CROSS_COMPILE)gcc

I agree it's desirable not to hardcode gcc, but we seem to be doing it all over
the place already.
 -- Tim
