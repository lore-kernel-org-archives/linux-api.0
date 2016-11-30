From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 0/6] enable O and KBUILD_OUTPUT for kselftest
Date: Wed, 30 Nov 2016 07:17:57 -0700
Message-ID: <01b97008-3311-7b5b-4424-76bd3d560b40@osg.samsung.com>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129115552.8148-1-bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/29/2016 04:55 AM, bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org wrote:
> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Here is my second version for enabling the KBUILD_OUTPUT for kselftest.
> The first version could be found here[1]. I fix and test all the TARGET
> in tools/testing/selftest/Makefile. For ppc, I test through fake target.
> 
> There are six patches in these series. And five of them clean up the
> existing code. I split the clean up patches into five, hope it is easy
> to review.
> 
>   selftests: remove duplicated all and clean target
>   selftests: remove useless TEST_DIRS
> a selftests: add pattern rules
> A selftests: remove CROSS_COMPILE in dedicated Makefile
> A selftests: add EXTRA_CLEAN for clean target
>   selftests: enable O and KBUILD_OUTPUT
> 
> Notes:
>   A: Ack by Michael.
>   a: ack by Michael. Minor update after rebase.

Bamovar/Michael,

Are these rebased to linux-next? Michael was concerned about
conflicts with powerpc tree. Would rebasing to linux-next help
avoiding conflicts?

Still looking to get them into 4.10 if possible.

thanks,
-- Shuah

> 
> In the first patch, I split the test files into two types:
> TEST_GEN_XXX means such file is generated during compiling. TEST_XXX
> means there is no need to compile before use. The main reason of this
> is the enablement of KBUILD_OUTPUT only need to care about TEST_GEN_XXX.
> I wanted to copy all the TEST_XXX with TEST_GEN_XXX, but I give up this
> idea in the end. Because people may puzzle why copy the file before
> installation.
> 
> Because of the introducing of TEST_GEN_XXX, I update the top-level
> Makefile and lib.mk selftests directory. After introduce TEST_GEN_XXX, I
> could remove all the unnecessary all and clean targets.
> 
> The second patch remove TEST_DIRS variable. And third patch add the
> pattern for compiling the c sourc code. The fourth patch remove the
> useless CROSS_COMPILE variable as it aleady exists in
> "tools/testing/selftests/lib.mk".
> 
> Further more, The fifth patch add the EXTRA_CLEAN variable to clean up
> the duplicated clean target
> 
> The last patch introduce the KBUILD_OUTPUT and O for kselftest instead
> using the existing kbuild system because user may compile kselftest
> directly (make -C tools/testing/selftests).
> 
> Changes:
> 1.  remove the useless *.o target in the following file suggested by
>     Michael:
>     tools/testing/selftests/powerpc/benchmarks/Makefile
>     tools/testing/selftests/powerpc/copyloops/Makefile
>     tools/testing/selftests/powerpc/dscr/Makefile
>     tools/testing/selftests/powerpc/math/Makefile
>     tools/testing/selftests/powerpc/primitives/Makefile
>     tools/testing/selftests/powerpc/stringloops/Makefile
>     tools/testing/selftests/powerpc/syscalls/Makefile
>     tools/testing/selftests/powerpc/tm/Makefile
> 
> 2.  remove the useless "all" and "clean" target in bpf and nsfs which
>     are added after my previous patch.
> 
> 3.  Improve the commit message.
> 
> [1] http://www.spinics.net/lists/linux-api/msg20789.html
> 
> Bamvor Jian Zhang (6):
>   selftests: remove duplicated all and clean target
>   selftests: remove useless TEST_DIRS
>   selftests: add default rules for c source file
>   selftests: remove CROSS_COMPILE in dedicated Makefile
>   selftests: add EXTRA_CLEAN for clean target
>   selftests: enable O and KBUILD_OUTPUT
> 
>  Documentation/kselftest.txt                        | 12 +++++++
>  tools/testing/selftests/Makefile                   | 36 ++++++++++++++-----
>  tools/testing/selftests/bpf/Makefile               | 10 ++----
>  tools/testing/selftests/breakpoints/Makefile       | 10 ++----
>  tools/testing/selftests/capabilities/Makefile      | 11 ++----
>  tools/testing/selftests/efivarfs/Makefile          |  8 +----
>  tools/testing/selftests/exec/Makefile              | 32 ++++++++---------
>  tools/testing/selftests/ftrace/Makefile            |  6 ++--
>  tools/testing/selftests/futex/Makefile             | 21 ++++++++---
>  tools/testing/selftests/futex/functional/Makefile  | 12 ++-----
>  tools/testing/selftests/ipc/Makefile               |  7 +---
>  tools/testing/selftests/kcmp/Makefile              |  6 ++--
>  tools/testing/selftests/lib.mk                     | 36 +++++++++++++++----
>  tools/testing/selftests/membarrier/Makefile        |  6 +---
>  tools/testing/selftests/memfd/Makefile             | 15 ++------
>  tools/testing/selftests/mount/Makefile             |  7 +---
>  tools/testing/selftests/mqueue/Makefile            |  6 +---
>  tools/testing/selftests/net/Makefile               | 15 +++-----
>  tools/testing/selftests/nsfs/Makefile              |  9 +----
>  tools/testing/selftests/powerpc/Makefile           | 15 ++++----
>  tools/testing/selftests/powerpc/alignment/Makefile |  9 ++---
>  .../testing/selftests/powerpc/benchmarks/Makefile  | 15 +++-----
>  .../selftests/powerpc/context_switch/Makefile      |  9 ++---
>  tools/testing/selftests/powerpc/copyloops/Makefile | 19 ++++------
>  tools/testing/selftests/powerpc/dscr/Makefile      | 13 +++----
>  tools/testing/selftests/powerpc/math/Makefile      | 25 ++++++-------
>  tools/testing/selftests/powerpc/mm/Makefile        | 18 ++++------
>  tools/testing/selftests/powerpc/pmu/Makefile       | 26 +++++++-------
>  tools/testing/selftests/powerpc/pmu/ebb/Makefile   | 15 +++-----
>  .../testing/selftests/powerpc/primitives/Makefile  |  9 ++---
>  .../testing/selftests/powerpc/stringloops/Makefile |  9 ++---
>  .../selftests/powerpc/switch_endian/Makefile       | 17 ++++-----
>  tools/testing/selftests/powerpc/syscalls/Makefile  |  9 ++---
>  tools/testing/selftests/powerpc/tm/Makefile        | 17 ++++-----
>  tools/testing/selftests/powerpc/vphn/Makefile      | 10 ++----
>  tools/testing/selftests/pstore/Makefile            |  4 +--
>  tools/testing/selftests/ptrace/Makefile            |  8 +----
>  tools/testing/selftests/seccomp/Makefile           |  6 +---
>  tools/testing/selftests/sigaltstack/Makefile       |  5 +--
>  tools/testing/selftests/size/Makefile              | 10 ++----
>  tools/testing/selftests/timers/Makefile            | 10 ++----
>  tools/testing/selftests/vm/Makefile                | 41 +++++++++-------------
>  tools/testing/selftests/x86/Makefile               | 17 +++++----
>  tools/testing/selftests/zram/Makefile              |  3 +-
>  44 files changed, 247 insertions(+), 357 deletions(-)
> 
