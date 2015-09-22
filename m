From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 2/2] selftests/userfaultfd: improve syscall number
 definition
Date: Tue, 22 Sep 2015 18:15:12 +0100
Message-ID: <56018CA0.8050600@arm.com>
References: <1442918756-17892-1-git-send-email-andre.przywara@arm.com>
 <1442918756-17892-3-git-send-email-andre.przywara@arm.com>
 <56015C59.5010300@osg.samsung.com> <20150922140625.GH25412@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150922140625.GH25412@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>, Shuah Khan <shuahkh@osg.samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>, Will Deacon <Will.Deacon@arm.com>
List-Id: linux-api@vger.kernel.org

Hi Shuah, Andrea,

On 22/09/15 15:06, Andrea Arcangeli wrote:
> On Tue, Sep 22, 2015 at 07:49:13AM -0600, Shuah Khan wrote:
>> On 09/22/2015 04:45 AM, Andre Przywara wrote:
>>> At the moment the userfaultfd test program only supports x86 and an
>>> architecture called "powewrpc" ;-)
>>> Fix that typo and add the syscall numbers for other architectures as
>>> well.
>>> Also as in an ideal world a syscall number should come from the system
>>> header file <asm/unistd.h>, include that header and guard the explicit
>>> syscall number section below to avoid redefinitions.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  tools/testing/selftests/vm/userfaultfd.c | 13 ++++++++++++-
>>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
>>> index 2c7cca6..63be27f 100644
>>> --- a/tools/testing/selftests/vm/userfaultfd.c
>>> +++ b/tools/testing/selftests/vm/userfaultfd.c
>>> @@ -65,16 +65,27 @@
>>>  #include <sys/ioctl.h>
>>>  #include <pthread.h>
>>>  #include "../../../../include/uapi/linux/userfaultfd.h"
>>> +#include <asm/unistd.h>
>>>  
>>> +/* ideally the above user header provides that number, but ... */
>>> +#ifndef __NR_userfaultfd
>>>  #ifdef __x86_64__
>>>  #define __NR_userfaultfd 323
>>>  #elif defined(__i386__)
>>>  #define __NR_userfaultfd 374
>>> -#elif defined(__powewrpc__)
>>> +#elif defined(__powerpc__)
>>>  #define __NR_userfaultfd 364
>>> +#elif defined(__ia64__)
>>> +#define __NR_userfaultfd 1343
>>> +#elif defined(__arm__)
>>> +#define __NR_userfaultfd 388
>>> +#elif defined(__aarch64__)
>>> +/* this is from the generic syscall table, used also on other architectures */
>>> +#define __NR_userfaultfd 283
>>>  #else
>>>  #error "missing __NR_userfaultfd definition"
>>>  #endif
>>> +#endif /* !__NR_userfaultfd */
>>>  
>>>  static unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
>>>  
>>>
>>
>> This is not okay. User-space shouldn't be (re)defining/duplicating
>> syscall numbers. I can't take this patch.

While I agree that this isn't the right approach from a userland point
of view, I wonder how this is supposed to work for the next few months?
Is everybody required to overwrite their distribution-provided kernel
headers just for compiling this test program?

> -mm has already been updated to do exactly that. Syscall numbers end
> up hardcoded into userland binaries/libs somewhere, so it's not a
> bugfix but certainly it's a nice cleanup to remove the whole #ifdef block.
> 
> Andre, could you see if linux-next (which includes -mm) works for you
> by just running "cd tools/testing/selftests/vm/ && make"? If there's
> any further change required could you diff it against linux-next?

This doesn't compile now for me, because it looks into
/usr/include/asm/unistd.h, which I keep to the distribution copy of it.
Also linux/userfaultfd.h is missing, because it's brand new.

If that tool lives in the kernel repo, it should be able to either use
the uapi headers directly or hardcode the syscall numbers - strictly
it's not a sane userland program anymore, but for that kind of tools I
deem it's totally acceptable. I think this is one rationale for keeping
it inside the linux.git repo.

Obviously you were facing the same problem in the beginning (looking at
the original code), so I was just extending the original solution to
cover more architectures and prepare for the time when those symbols
start to appear in distributions.

I guess the right solution would be to hack the Makefile to set the
include path to the kernel's copy of include/uapi, though I am not sure
this works cleanly for different architectures and separate build
directories. I will give this a try ...

Cheers,
Andre.
