From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Date: Wed, 12 Dec 2018 09:17:07 +0100
Message-ID: <20181212081712.32347-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-14679-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

The goal of this patch series is to control script interpretation.  A
new O_MAYEXEC flag used by sys_open() is added to enable userland script
interpreter to delegate to the kernel (and thus the system security
policy) the permission to interpret scripts or other files containing
what can be seen as commands.

The security policy is the responsibility of an LSM.  A basic
system-wide policy is implemented with Yama and configurable through a
sysctl.

The initial idea come from CLIP OS and the original implementation has
been used for more than 10 years:
https://github.com/clipos-archive/clipos4_doc

An introduction to O_MAYEXEC was given at the Linux Security Summit
Europe 2018 - Linux Kernel Security Contributions by ANSSI:
https://www.youtube.com/watch?v=chNjCRtPKQY&t=17m15s
The "write xor execute" principle was explained at Kernel Recipes 2018 -
CLIP OS: a defense-in-depth OS:
https://www.youtube.com/watch?v=PjRE0uBtkHU&t=11m14s

This patch series can be applied on top of v4.20-rc6.  This can be
tested with CONFIG_SECURITY_YAMA.  I would really appreciate
constructive comments on this RFC.

Regards,

Mickaël Salaün (5):
  fs: Add support for an O_MAYEXEC flag on sys_open()
  fs: Add a MAY_EXECMOUNT flag to infer the noexec mount propertie
  Yama: Enforces noexec mounts or file executability through O_MAYEXEC
  selftest/yama: Add tests for O_MAYEXEC enforcing
  doc: Add documentation for Yama's open_mayexec_enforce

 Documentation/admin-guide/LSM/Yama.rst       |  41 +++
 MAINTAINERS                                  |   1 +
 fs/fcntl.c                                   |   2 +-
 fs/namei.c                                   |   2 +
 fs/open.c                                    |   4 +
 include/linux/fcntl.h                        |   2 +-
 include/linux/fs.h                           |   4 +
 include/uapi/asm-generic/fcntl.h             |   3 +
 security/yama/Kconfig                        |   3 +-
 security/yama/yama_lsm.c                     |  82 +++++-
 tools/testing/selftests/Makefile             |   1 +
 tools/testing/selftests/yama/.gitignore      |   1 +
 tools/testing/selftests/yama/Makefile        |  19 ++
 tools/testing/selftests/yama/config          |   2 +
 tools/testing/selftests/yama/test_omayexec.c | 276 +++++++++++++++++++
 15 files changed, 439 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/yama/.gitignore
 create mode 100644 tools/testing/selftests/yama/Makefile
 create mode 100644 tools/testing/selftests/yama/config
 create mode 100644 tools/testing/selftests/yama/test_omayexec.c

-- 
2.20.0.rc2
