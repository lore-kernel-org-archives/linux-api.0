From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 0/3] selftests: ptrace, kcmp, efivars build failure fixes
Date: Tue, 10 Mar 2015 16:00:56 -0600
Message-ID: <cover.1426022048.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tranmanphong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

ptrace, efivars, and kcmp Makefiles don't have explicit build rule.
As a result, build fails when make is run from top level Makefile
target kselftest. Without the explicit rule, make works only when
it is run in the current directory or from selftests directory.
Fxing the problems by adding an explicit build rule to fix the
problem.

Shuah Khan (3):
  selftests: ptrace build fails when invoked from kselftest target
  selftests: efivars build fails when invoked from kselftest target
  selftests: kcmp build fails when invoked from kselftest target

 tools/testing/selftests/efivarfs/Makefile | 2 ++
 tools/testing/selftests/kcmp/Makefile     | 5 +++--
 tools/testing/selftests/ptrace/Makefile   | 5 +++--
 3 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.1.0
