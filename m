From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] selftests: Add install, generate tar, and run_kselftest
 tools
Date: Wed, 04 Mar 2015 21:19:57 +1100
Message-ID: <1425464397.32154.1.camel@ellerman.id.au>
References: <1425358088-9667-1-git-send-email-shuahkh@osg.samsung.com>
	 <20150303144916.GA24111@codemonkey.org.uk>
	 <54F5EA38.4010306@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54F5EA38.4010306@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, mmarek@suse.cz
List-Id: linux-api@vger.kernel.org

On Tue, 2015-03-03 at 10:07 -0700, Shuah Khan wrote:
> On 03/03/2015 07:49 AM, Dave Jones wrote:
> > On Mon, Mar 02, 2015 at 09:48:08PM -0700, Shuah Khan wrote:
> >  > kselftest_install.sh tool adds support for installing selftests
> >  > at user specified location/kselftest. By default this tool
> >  > will install selftests in the selftests/kselftest directory.
> >  > For example, kselftest_install /tmp will install tests under
> >  > /tmp/kselftest
> >  
> > How is this an improvement over having each test install method isolated
> > to its own Makefile ?
> 
> Dave/Michael,
> 
> Makefile approach requires changes to all the existing test Makefiles.
> After looking at the churn to individual Makefiles, I have the following
> concerns.
> 
> I am concerned about maintenance and potential for mistakes in install
> logic in individual Makefiles when new tests get added. I keep seeing
> run_tests target breaking when new tests get added and also when
> existing tests get modified.

With most of the logic isolated in lib.mk I don't think this is a concern.

As an example here is the minimal Makefile required for a simple new test:

	$ cat tools/testing/selftests/hello-world/Makefile
	TEST_PROGS := hello-world
	
	all: $(TEST_PROGS)
	
	include ../lib.mk
	
	clean:
		rm -f $(TEST_PROGS)


That will build, work with run_tests and work with install.

In fact we can merge a template directory like the above with an example
Makefile to make it super easy for people to add new tests with the right
logic.


> That said, I looked at Michael's patches and Michael's work does address
> several of my concerns. Hence, the following plan:
> 
> I will take the following patches from Michael after requested
> changes are made:
> 
> - [PATCH 1/9] selftests: Introduce minimal shared logic for
>   running tests
>   This improves current run_tests logic. Will need changes to
>   account for duplicate cpu and memory hot-plug scripts. Both are
>   named on-off-test.sh - won't make a difference for this patch,
>   but will for install logic

The duplicate names don't matter because I put the installed tests in a sub
directory:

$ cd tools/testing/selftests
$ find install/ -name on-off-test.sh
install/memory-hotplug/on-off-test.sh
install/cpu-hotplug/on-off-test.sh


> Note: I am seeing failures when I run sudo make kselftest after
> applying this patch
> 
> /bin/sh: 1: ./run_netsocktests: Permission denied
> selftests: run_netsocktests [FAIL]
> /bin/sh: 1: ./run_afpackettests: Permission denied
> selftests: run_afpackettests [FAIL]
> 
> /bin/sh: 1: ./run_numerictests: Permission denied
> selftests: run_numerictests [FAIL]
> /bin/sh: 1: ./run_stringtests: Permission denied
> selftests: run_stringtests [FAIL]
> 
> /bin/sh: 1: ./run_vmtests: Permission denied

Ah sorry, I lost the change to the permission bits somewhere along the line.
Thanks for testing. Fixed in v3.


>   Please make sure make kselftest doesn't regress when run
>   as root as well as user. In addition, the following don't
>   regress:
> 
>   make -C tools/testing/selftests TARGETS=test1 run_tests
>   make -C tools/testing/selftests TARGETS="test1 test2" run_tests
>   make -C tools/testing/selftests run_hotplug
> 
>   Please see Documentation/kselftest.txt - don't want to regress
>   the current use-cases.

None of those have regressed as far as I can see.


> - [PATCH 2/9] selftests: Add install target
>   Looks like lib.mk logic is addressing some of my concerns about the
>   individual Makefile install logic.
>   I would like to see 1. the all script name changed to run_kselftest.sh

I don't see why it needs "kselftest" in the name, it's *inside* the install
directory, but I'll rename it because I don't care that much.


> - [PATCH 5/9] kbuild: Don't pass -rR to selftest makefiles
>   Drop kselftest_install from this patch. There is no need.
>   More on this below.

OK. That makes this patch orthogonal to the rest, and it's actually a bug fix,
so I'll send it separately and ideally you can merge it for 4.0.


> - [PATCH 7/9] selftests/timers: Use implicit rules
>   Please check John Stultz's timers test work to make sure there is no
>   conflict. Please see: [PATCH 01/19] selftests/timers: Cleanup
>   Makefile to make it easier to add future tests
>   https://lkml.org/lkml/2015/2/5/56

There will definitely be a conflict. As the maintainer you should either fixup
the conflict, or if you can't, merge one series and then ask the author of the
other series to base their work on top of the other.

In this case the two patches are very similar, so it probably doesn't matter
which you merge first. You'll just have to incorporate the CFLAGS changes from
John's patch into the final result.

> Drop these patches:
> - [PATCH 4/9] kbuild: add a new kselftest_install make target to install selftests
>   I am not seeing any value in adding install target to the main
>   Makefile.

Fine by me.


> I still want a wrapper script for install, so:
> 
> - I will change kselftest_install.sh to leverage the above work. It can
>   just invoke make install at the selftests directory after figuring
>   base directory logic etc. This will be based on the above patches.
> 
> - Keep  gen_kselftest_tar.sh as is - no changes need.
> 
> - I can drop run_kselftest tool completely, since emit logic in
>   Michael's work takes care of it.
> 
> Comments and questions? I am cc'ing Michal Marek to keep him in
> the loop.
> 
> Michael! Please let me know if you want to see responses to your
> individual patches, in addition to this email.

No that's fine.

I'll repost the series shortly.

cheers
