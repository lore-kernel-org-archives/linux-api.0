From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 0/2] selftests/pstore: add pstore test script
Date: Tue, 08 Sep 2015 20:06:15 +0900
Message-ID: <20150908110615.9783.69477.stgit@arietta>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>, Shuah Khan <shuahkh@osg.samsung.com>, Mark Salyzyn <salyzyn@android.com>, Colin Cross <ccross@android.com>, Seiji Aguchi <seiji.aguchi@hds.com>
List-Id: linux-api@vger.kernel.org

These scripts include test cases which check pstore behavior. This
is useful to avoid regressions of pstore.

Pstore is used across kernel crash, so these test cases are split
into three parts.

 - pstore_tests: check pstore behavior before crash
 - pstore_post_reboot_tests: check pstore behavior after crash and reboot
 - pstore_crash_test: cause kernel crash and reboot

The pstore_test and the pstore_post_reboot_tests are the actual scripts
for testing pstore and are executed in usual selftest's "run_test" target.
On the other hand, the pstore_crash_test is to cause kernel panic and reboot,
so it is executed in new "run_pstore_crash" target which is specified ad-hoc
by users. In addition, there is a "common_tests" script which includes
utilities and test cases used commonly in these scripts.

When the pstore_crash_test is executed, it creates a file as a reboot flag.
The pstore_post_reboot_tests detects whether the file exists or not. If the
file doesn't exists, the test cases are skipped.

These scripts expect that one pstore backend is registered before the
scripts are executed.
Assumed use case is following.

# cd linux/tools/testing/selftests
# make run_tests -C pstore
make: Entering directory '/home/root/selftests/pstore'
=== Pstore unit tests (pstore_tests)===
Checking pstore backend is registered ... ok
Checking pstore console is registered ... ok
Checking /dev/pmsg0 exists ... ok
Writing TEST_STRING to /dev/pmsg0 ... ok
selftests: pstore_tests [PASS]
=== Pstore unit tests (pstore_post_reboot_tests)===
Checking pstore backend is registered ... ok
pstore_crash_test has not been executed yet. we skip further tests.
selftests: pstore_post_reboot_tests [PASS]
make: Leaving directory '/home/root/selftests/pstore'
# make run_pstore_crash
...
(kernel crash and reboot)
...
# make run_tests -C pstore
make: Entering directory '/home/root/selftests/pstore'
=== Pstore unit tests (pstore_tests)===
Checking pstore backend is registered ... ok
Checking pstore console is registered ... ok
Checking /dev/pmsg0 exists ... ok
Writing TEST_STRING to /dev/pmsg0 ... ok
selftests: pstore_tests [PASS]
=== Pstore unit tests (pstore_post_reboot_tests)===
Checking pstore backend is registered ... ok
Mounting pstore filesystem ... ok
Checking dmesg files exist in pstore filesystem ... ok
        dmesg-ramoops-0
        dmesg-ramoops-1
Checking console files exist in pstore filesystem ... ok
        console-ramoops-0
Checking pmsg files exist in pstore filesystem ... ok
        pmsg-ramoops-0
Checking dmesg files contains oops end marker
        dmesg-ramoops-0 ... ok
        dmesg-ramoops-1 ... ok
Checking console file contains oops end marker ... ok
Checking pmsg file contains TEST_STRING ... ok
Removing all files in pstore filesystem 
        console-ramoops-0 ... ok
        dmesg-ramoops-0 ... ok
        dmesg-ramoops-1 ... ok
        pmsg-ramoops-0 ... ok
selftests: pstore_post_reboot_tests [PASS]
make: Leaving directory '/home/root/selftests/pstore'


We can also see test logs later.

# cat pstore/logs/20150903-111158/pstore_tests.log
...

---

Hiraku Toyooka (2):
      selftests/pstore: add pstore test script for pre-reboot
      selftests/pstore: add pstore test scripts going with reboot


 tools/testing/selftests/Makefile                   |    1 
 tools/testing/selftests/pstore/Makefile            |   15 ++
 tools/testing/selftests/pstore/common_tests        |   46 +++++++
 tools/testing/selftests/pstore/pstore_crash_test   |   27 ++++
 .../selftests/pstore/pstore_post_reboot_tests      |  126 ++++++++++++++++++++
 tools/testing/selftests/pstore/pstore_tests        |   42 +++++++
 6 files changed, 257 insertions(+)
 create mode 100644 tools/testing/selftests/pstore/Makefile
 create mode 100755 tools/testing/selftests/pstore/common_tests
 create mode 100755 tools/testing/selftests/pstore/pstore_crash_test
 create mode 100755 tools/testing/selftests/pstore/pstore_post_reboot_tests
 create mode 100755 tools/testing/selftests/pstore/pstore_tests

--
Hiraku Toyooka
