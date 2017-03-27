From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2] selftests: fix for KBUILD_OUTPUT
Date: Mon, 27 Mar 2017 05:45:59 +0000
Message-ID: <20170327054601.22415-1-bamvor.zhangjian@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

These patches fix the two compile failures in x86 and net subnet
repectively. Test the folowing build method successful:

make -C tools/testing/selftests TARGETS=xxx
make -C tools/testing/selftests TARGETS=xxx clean
make -C tools/testing/selftests/xxx
make -C tools/testing/selftests/xxx clean
make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE -C tools/testing/selftests TARGETS=xxx
make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE -C tools/testing/selftests TARGETS=xxx clean

Bamvor Jian Zhang (2):
  selftests: fix the broken individual test for x86
  selftests: net:  support KBUILD_OUTPUT for reuseport_bpf_numa

 Documentation/kselftest.txt          |  6 ++++++
 tools/testing/selftests/net/Makefile |  2 +-
 tools/testing/selftests/x86/Makefile | 23 ++++++++++++++---------
 3 files changed, 21 insertions(+), 10 deletions(-)

-- 
1.9.1
