From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH] selftests: Add install, generate tar, and run_kselftest
 tools
Date: Tue, 03 Mar 2015 10:07:04 -0700
Message-ID: <54F5EA38.4010306@osg.samsung.com>
References: <1425358088-9667-1-git-send-email-shuahkh@osg.samsung.com> <20150303144916.GA24111@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150303144916.GA24111@codemonkey.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@codemonkey.org.uk>, mpe@ellerman.id.au
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, mmarek@suse.cz
List-Id: linux-api@vger.kernel.org

On 03/03/2015 07:49 AM, Dave Jones wrote:
> On Mon, Mar 02, 2015 at 09:48:08PM -0700, Shuah Khan wrote:
>  > kselftest_install.sh tool adds support for installing selftests
>  > at user specified location/kselftest. By default this tool
>  > will install selftests in the selftests/kselftest directory.
>  > For example, kselftest_install /tmp will install tests under
>  > /tmp/kselftest
>  
> How is this an improvement over having each test install method isolated
> to its own Makefile ?

Dave/Michael,

Makefile approach requires changes to all the existing test Makefiles.
After looking at the churn to individual Makefiles, I have the following
concerns.

I am concerned about maintenance and potential for mistakes in install
logic in individual Makefiles when new tests get added. I keep seeing
run_tests target breaking when new tests get added and also when
existing tests get modified.

That said, I looked at Michael's patches and Michael's work does address
several of my concerns. Hence, the following plan:

I will take the following patches from Michael after requested
changes are made:

- [PATCH 1/9] selftests: Introduce minimal shared logic for
  running tests
  This improves current run_tests logic. Will need changes to
  account for duplicate cpu and memory hot-plug scripts. Both are
  named on-off-test.sh - won't make a difference for this patch,
  but will for install logic

Note: I am seeing failures when I run sudo make kselftest after
applying this patch

/bin/sh: 1: ./run_netsocktests: Permission denied
selftests: run_netsocktests [FAIL]
/bin/sh: 1: ./run_afpackettests: Permission denied
selftests: run_afpackettests [FAIL]

/bin/sh: 1: ./run_numerictests: Permission denied
selftests: run_numerictests [FAIL]
/bin/sh: 1: ./run_stringtests: Permission denied
selftests: run_stringtests [FAIL]

/bin/sh: 1: ./run_vmtests: Permission denied

  Please make sure make kselftest doesn't regress when run
  as root as well as user. In addition, the following don't
  regress:

  make -C tools/testing/selftests TARGETS=test1 run_tests
  make -C tools/testing/selftests TARGETS="test1 test2" run_tests
  make -C tools/testing/selftests run_hotplug

  Please see Documentation/kselftest.txt - don't want to regress
  the current use-cases.

- [PATCH 2/9] selftests: Add install target
  Looks like lib.mk logic is addressing some of my concerns about the
  individual Makefile install logic.
  I would like to see 1. the all script name changed to run_kselftest.sh

- [PATCH 3/9] selftests: Add install support for the powerpc tests
  This is good as is.

- [PATCH 5/9] kbuild: Don't pass -rR to selftest makefiles
  Drop kselftest_install from this patch. There is no need.
  More on this below.

- PATCH 6/9] selftests: Set CC using CROSS_COMPILE once in lib.mk

- [PATCH 7/9] selftests/timers: Use implicit rules
  Please check John Stultz's timers test work to make sure there is no
  conflict. Please see: [PATCH 01/19] selftests/timers: Cleanup
  Makefile to make it easier to add future tests
  https://lkml.org/lkml/2015/2/5/56

- [PATCH 8/9] selftests/mqueue: Use implicit rules
  This is good as is.

- [PATCH 9/9] selftests/mount: Use implicit rules
  This is good as is.

Drop these patches:
- [PATCH 4/9] kbuild: add a new kselftest_install make target to install
selftests
  I am not seeing any value in adding install target to the main
  Makefile. Invoking test run makes sense as it allows user
  to run them from the git without install step which makes sense.
  Being able to invoke install from main Makefile really doesn't
  add any value. We can isolate install logic under selftests and
  also avoid adding one more target to the main Makefile.

I still want a wrapper script for install, so:

- I will change kselftest_install.sh to leverage the above work. It can
  just invoke make install at the selftests directory after figuring
  base directory logic etc. This will be based on the above patches.

- Keep  gen_kselftest_tar.sh as is - no changes need.

- I can drop run_kselftest tool completely, since emit logic in
  Michael's work takes care of it.

Comments and questions? I am cc'ing Michal Marek to keep him in
the loop.

Michael! Please let me know if you want to see responses to your
individual patches, in addition to this email.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
