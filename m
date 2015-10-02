From: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 0/2] selftests/pstore: add pstore test script
Date: Fri, 02 Oct 2015 20:46:37 +0900
Message-ID: <20151002114637.20957.61769.stgit@arietta>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Seiji Aguchi <seiji.aguchi.tr-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

These scripts include test cases which check pstore behavior. This
is useful to avoid regressions of pstore.

Changes since v1:
 * Exit with 1 in pstore/Makefile when pstore_crash_test failed.
 * Create helper functions to make the tests much more readable.
 * Use /sys/module/pstore/parameters/backend to check pstore backend is
   registered.
 * Show content of /sys/module/.../backend and /proc/cmdline for debug
 * Give UUID to each execution of test script.
 * Write unique test string with UUID into pmsg.
 * Check only one test string pattern appears in pmsg after crash.
 * Check UUID written to pmsg matches across crash.
 * Don't touch panic_on_oops because it is not necessary for reboot on crash

(v1: http://www.kernelhub.org/?msg=831044&p=2)

I also confirmed that these scripts work fine with kdump reboot with
kernel boot parameter 'crash_kexec_post_notifiers'.

---

Hiraku Toyooka (2):
      selftests/pstore: add pstore test script for pre-reboot
      selftests/pstore: add pstore test scripts going with reboot


 tools/testing/selftests/Makefile                   |    4 +
 tools/testing/selftests/pstore/Makefile            |   15 ++++
 tools/testing/selftests/pstore/common_tests        |   83 ++++++++++++++++++++
 tools/testing/selftests/pstore/pstore_crash_test   |   30 +++++++
 .../selftests/pstore/pstore_post_reboot_tests      |   77 +++++++++++++++++++
 tools/testing/selftests/pstore/pstore_tests        |   30 +++++++
 6 files changed, 239 insertions(+)
 create mode 100644 tools/testing/selftests/pstore/Makefile
 create mode 100755 tools/testing/selftests/pstore/common_tests
 create mode 100755 tools/testing/selftests/pstore/pstore_crash_test
 create mode 100755 tools/testing/selftests/pstore/pstore_post_reboot_tests
 create mode 100755 tools/testing/selftests/pstore/pstore_tests

--
Hiraku Toyooka
