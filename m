From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH] selftests/vm: fix link error for transhuge-stress test
Date: Thu, 08 Jan 2015 08:55:25 -0700
Message-ID: <54AEA86D.60709@osg.samsung.com>
References: <1420655754-10076-1-git-send-email-Andrej.Skvortzov@gmail.com> <54AD872E.9060802@osg.samsung.com> <20150107201045.GA5704@yulia-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150107201045.GA5704@yulia-desktop>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <koct9i@gmail.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/07/2015 01:10 PM, Andrey Skvortsov wrote:
> On Wed, Jan 07, 2015 at 12:21:18PM -0700, Shuah Khan wrote:
>> On 01/07/2015 11:35 AM, Andrey Skvortsov wrote:
>>> add -lrt to fix undefined reference to `clock_gettime'
>>> 
>>> Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com> 
>>> --- tools/testing/selftests/vm/Makefile |    2 +- 1 file
>>> changed, 1 insertion(+), 1 deletion(-)
>>> 
>>> diff --git a/tools/testing/selftests/vm/Makefile
>>> b/tools/testing/selftests/vm/Makefile index 4c4b1f6..077828c
>>> 100644 --- a/tools/testing/selftests/vm/Makefile +++
>>> b/tools/testing/selftests/vm/Makefile @@ -7,7 +7,7 @@ BINARIES
>>> += transhuge-stress
>>> 
>>> all: $(BINARIES) %: %.c -	$(CC) $(CFLAGS) -o $@ $^ +	$(CC)
>>> $(CFLAGS) -o $@ $^ -lrt
>>> 
>>> run_tests: all @/bin/sh ./run_vmtests || (echo "vmtests:
>>> [FAIL]"; exit 1)
>>> 
>> 
>> Andrey,
>> 
>> I don't see any undefined references when I build. Curious if it
>> is specific to your env??
>> 
>> Please include the warning in the change log when you fix
>> warnings in the future.
>> 
> 
> thanks for the comment.
> 
> Here is what I get without a patch:
> 
> linux-next/tools/testing/selftests/vm $ make gcc -Wall -o
> hugepage-mmap hugepage-mmap.c gcc -Wall -o hugepage-shm
> hugepage-shm.c gcc -Wall -o map_hugetlb map_hugetlb.c gcc -Wall -o
> thuge-gen thuge-gen.c gcc -Wall -o hugetlbfstest hugetlbfstest.c 
> gcc -Wall -o transhuge-stress transhuge-stress.c /tmp/ccpWoqkG.o:
> In function `main': transhuge-stress.c:(.text+0x3a3): undefined
> reference to `clock_gettime' transhuge-stress.c:(.text+0x4dc):
> undefined reference to `clock_gettime' collect2: ld returned 1 exit
> status make: *** [transhuge-stress] Error 1
> 
> 
> $ gcc --version gcc (Ubuntu/Linaro 4.6.4-1ubuntu1~12.04) 4.6.4. The
> same error I get on my other Debian system.
> 
> man page for clock_gettime says 'Link with -lrt'. So I think the
> error message is correct.
> 

Thanks for fixing it. Applied to linux-kselftest fixes branch

- -- Shuah

- -- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrqhtAAoJEAsCRMQNDUMcVkgP/if69SGYILLnnj+7oBIuXJGl
8QZVJRHKdN/8Tny7PVBDmerv8kTxbDfaJpJyHg8nSSFRyTmOKChNkO9mcR7TIXcP
KxQn5BjYYUvcPM9jZESTAOIdEcaKbsMjj2Yknf49o7ij9YgCBPvFbDOZtfk/oMtF
no3wGSuZPF4cRBvhfHJQdLMc87VeLSdz4eDBWZ7LX6EXlfWc8QH8iJhbLzmPp3pJ
ofFKKeoaOrlcb/tQPdfSbWvVXZmWpJa8YdDGc2V+w6gahjPeWffe3ZTSyS4dwKZ+
Ayt4F2ptxu+/1fbOb9ZSFCrST2q+yavvXR5D/guK1EqIi1iRHJzq9QSNO8VJksG1
g+aCCTxI5qxHmmq2NandZ/UTttdxsUhPVO32IAFZcrq49gdPQqa/QuB0iI3fDevp
kqueiQj96wHr6zBFMgO6O+Vw/bmOjNdFOQUIv6iEJt1SbRtouBa4VVSRsbJijwGU
3jDZBmBhV/ntGuydqsPE1IAjQPO9nKk2rF7RZkx2OGx6Lc6kOk6BQ0eHnA/FgmcG
vZiHAIK99K9dEd926C+nV6pYK9UfPU/UKtmxIa/Z5At4oxN3SUKeZokmCFC7f2Ff
ueM0hLvEmfNTjSzGkx72RsdxE/6nU2kgYfNOGsJh4QuePrph9+orgHtb5qzZXmiA
Mf3pjHSWH0sqAXKfZZmF
=zsvn
-----END PGP SIGNATURE-----
