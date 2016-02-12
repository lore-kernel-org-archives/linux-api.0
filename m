From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v4 0/2] Create specific kconfig for kselftest
Date: Fri, 12 Feb 2016 09:10:23 -0700
Message-ID: <56BE03EF.70607@osg.samsung.com>
References: <1452238054-15482-1-git-send-email-bamvor.zhangjian@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452238054-15482-1-git-send-email-bamvor.zhangjian@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>, linux-api@vger.kernel.org, mmarek@suse.com, Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, yann.morin.1998@free.fr, khilman@linaro.org, tyler.baker@linaro.org, broonie@kernel.org, mpe@ellerman.id.au, dvhart@infradead.org
List-Id: linux-api@vger.kernel.org

On 01/08/2016 12:27 AM, Bamvor Jian Zhang wrote:
> There is a discussion about improving the usability of kselftest by
> creating test-specific kconfig in recent kernel Summit. The first
> three versions could be found at [1], [2], [3].
> 
> Patch 1 keep test-specific kconfig fragments inside each selftest so
> that merge_configs.sh could build up a kernel configuration that can
> test the specific or all feature(s).
> 
> Patch 2 add config option(kselftest-merge) in make file as a
> helper to merge all the test config dependecies to .config.

Hi Michal,

Are you okay with the changes to the second patch
in this series? Would you like to me to send the
second one up through linux-kselftest tree or do
you want to take this through your tree?

Please let me know.

thanks,
-- Shuah
> 
> Changes since v3:
> 1.  move the target kselftest-mergeconfig from scripts/kconfig/Makfile
>     to toplevel Makefile. And rename to kselftest-merge to avoid the
>     conflict with "%config" target.
> 
> Changes since v2:
> 1.  Fix the misuse of objtree and srctree in the
>     kselftest-mergeconfig target.
> 
> Changes since v1:
> 1.  Add kselftest-mergeconfig in scripts/kconfig/Makefile according
>     to the suggestion from Michael.
> 
> [1] http://www.spinics.net/lists/linux-api/msg15533.html
> [2] http://www.spinics.net/lists/linux-api/msg15593.html
> [3] http://comments.gmane.org/gmane.linux.kernel/2110565
> 
> Bamvor Jian Zhang (2):
>   selftests: create test-specific kconfig fragments
>   Makefile: add kselftest-merge
> 
>  Makefile                                      | 11 +++++++++++
>  tools/testing/selftests/cpu-hotplug/config    |  2 ++
>  tools/testing/selftests/firmware/config       |  1 +
>  tools/testing/selftests/ftrace/config         |  1 +
>  tools/testing/selftests/ipc/config            |  2 ++
>  tools/testing/selftests/memory-hotplug/config |  4 ++++
>  tools/testing/selftests/mount/config          |  2 ++
>  tools/testing/selftests/net/config            |  3 +++
>  tools/testing/selftests/pstore/config         |  4 ++++
>  tools/testing/selftests/seccomp/config        |  2 ++
>  tools/testing/selftests/static_keys/config    |  1 +
>  tools/testing/selftests/user/config           |  1 +
>  tools/testing/selftests/vm/config             |  1 +
>  tools/testing/selftests/zram/config           |  2 ++
>  14 files changed, 37 insertions(+)
>  create mode 100644 tools/testing/selftests/cpu-hotplug/config
>  create mode 100644 tools/testing/selftests/firmware/config
>  create mode 100644 tools/testing/selftests/ftrace/config
>  create mode 100644 tools/testing/selftests/ipc/config
>  create mode 100644 tools/testing/selftests/memory-hotplug/config
>  create mode 100644 tools/testing/selftests/mount/config
>  create mode 100644 tools/testing/selftests/net/config
>  create mode 100644 tools/testing/selftests/pstore/config
>  create mode 100644 tools/testing/selftests/seccomp/config
>  create mode 100644 tools/testing/selftests/static_keys/config
>  create mode 100644 tools/testing/selftests/user/config
>  create mode 100644 tools/testing/selftests/vm/config
>  create mode 100644 tools/testing/selftests/zram/config
> 


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
