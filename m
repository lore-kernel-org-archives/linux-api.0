From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Mon, 11 May 2015 16:23:03 -0700
Message-ID: <CALAqxLVnv0Pp=eNxLaeAk00Bv=Y_mAWZjpaChp5SV-Sgk2FtPA@mail.gmail.com>
References: <cover.1431121818.git.dvhart@linux.intel.com>
	<57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com>
	<5550EF8D.8080403@osg.samsung.com>
	<D1763F31.CC237%dvhart@linux.intel.com>
	<5550FB2C.1000403@osg.samsung.com>
	<D17653E0.CC29F%dvhart@linux.intel.com>
	<5551164E.5080409@osg.samsung.com>
	<D17670E1.CC354%dvhart@linux.intel.com>
	<55512B54.50304@osg.samsung.com>
	<55512B86.2040900@osg.samsung.com>
	<D1767EA1.CC3DA%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D1767EA1.CC3DA%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 11, 2015 at 4:07 PM, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> On 5/11/15, 3:21 PM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
>
>>>>>No need for a new pull request. Have you seen these errors before:
>>>>>
>>>>>make[2]: Entering directory
>>>>>'/mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex'
>>>>>for DIR in functional; do make -C $DIR all ; done
>>>>>make[3]: Entering directory
>>>>>'/mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functiona
>>>>>l'
>>>>>gcc  -g -O2 -Wall -D_GNU_SOURCE -I../include -I../../   -lpthread -lrt
>>>>>futex_requeue_pi.c ../include/futextest.h   -o futex_requeue_pi
>>>>>/tmp/cc2UgUVs.o: In function `create_rt_thread':
>>>>>/mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functional
>>>>>/fu
>>>>>tex_requeue_pi.c:102:
>>>>>undefined reference to `pthread_create'
>>>>>/tmp/cc2UgUVs.o: In function `unit_test':
>>>>>/mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functional
>>>>>/fu
>>>>>tex_requeue_pi.c:342:
>>>>>undefined reference to `pthread_join'
>>>>>/mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functional
>>>>>/fu
>>>>>tex_requeue_pi.c:347:
>>>>>undefined reference to `pthread_join'
>>>>>/mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functional
>>>>>/fu
>>>>>tex_requeue_pi.c:346:
>>>>>undefined reference to `pthread_join'
>>>>>collect2: error: ld returned 1 exit status
>>>>><builtin>: recipe for target 'futex_requeue_pi' failed
>>>>>make[3]: *** [futex_requeue_pi] Error 1
>>>>>make[3]: Leaving directory
>>>>>'/mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functiona
>>>>>l'
>>>>>Makefile:7: recipe for target 'all' failed
>>>>>
>>>>>I am running make kselftest target when I saw the above build failures.
>>>>>kselftest run doesn't fail which is good, however futex tests won't
>>>>>run with this failure.
>>>>
>>>>I have not seen these errors whilst developing with futextest for the
>>>>kernel. That looks like you may be missing the pthread development
>>>>headers
>>>>from your build machine.
>>>>
>>>>Those are provided by libc6-dev on my Debian systems.
>>>>
>>>I do have lib6-dev installed. timers uses pthread compiles fine.
>>>So does mqueue. I am not sure what is going on with futex tests
>>>though. I am guessing it has to do with library link order.
>>>The following fixed it for me:
>>>-LDFLAGS := $(LDFLAGS) -lpthread -lrt
>>>+LDFLAGS := $(LDFLAGS) -pthread -lrt
>>>Could you please make this change and resend the patch series.
>>>I prefer patch series over pull request.
>>>thanks,
>>>-- Shuah
>>
>>Sorry full diff:
>>
>>
>>diff --git a/tools/testing/selftests/futex/functional/Makefile
>>b/tools/testing/selftests/futex/functional/Makefile
>>index e64d43b..b8a2e9b 100644
>>--- a/tools/testing/selftests/futex/functional/Makefile
>>+++ b/tools/testing/selftests/futex/functional/Makefile
>>@@ -1,6 +1,6 @@
>>INCLUDES := -I../include -I../../
>>CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE $(INCLUDES)
>>-LDFLAGS := $(LDFLAGS) -lpthread -lrt
>>+LDFLAGS := $(LDFLAGS) -pthread -lrt
>
>
> I'm happy to do that, but I would like to make sure I'm doing the right
> thing.
>
> I'm building with:
> $ gcc --version
> gcc (Debian 4.9.2-10) 4.9.2
>
>
> What's there now works for me:
>         LDFLAGS := $(LDFLAGS) -lpthread -lrt
>
>
> What you propose also works for me:
>         LDFLAGS := $(LDFLAGS) -pthread -lrt
>
>
> I notice that most other test cases list -lrt first, including timers:
>         LDFLAGS += -lrt -lpthread
>
> Which works for me for timers - does that work for you? I assume so. It
> also works for futexes for me. I've found references out there suggesting
> -lrt should always come before -lpthread.
>
> I suspect you are correct as -pthread provides flags for both the
> preprocessor and the linker, however, I'm still concerned about the
> ordering.
>
> John - did you deliberately choose to use "-lrt -lpthread" ?

Ooof. Possibly, but I can't say I really recall at this point.

I do remember somewhere around gcc 4.6 I had to change things around
since the linker arguments had to be at the end of the gcc string
(where as before I was throwing them in w/ the CFLAGS).  I think it
was then I added the "-Wl,-no-as-needed" bit after googling around.
You might look at that as well?

Sorry I'm not of much help.
-john
