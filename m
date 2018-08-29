From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 03/14] y2038: Globally rename compat_time to old_time32
Date: Wed, 29 Aug 2018 20:50:51 +0800
Message-ID: <201808292023.n7IP8zK3%fengguang.wu@intel.com>
References: <20180827194531.3796559-4-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180827194531.3796559-4-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, tglx@linutronix.de, y2038@lists.linaro.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, deepa.kernel@gmail.com, linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

Hi Arnd,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.19-rc1 next-20180829]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Arnd-Bergmann/y2038-syscall-changes-for-4-20/20180828-035049
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/uapi/linux/perf_event.h:147:56: sparse: cast truncates bits from constant value (8000000000000000 becomes 0)
>> kernel/time/time.c:866:5: sparse: symbol '__get_old_timespec32' was not declared. Should it be static?
>> kernel/time/time.c:882:5: sparse: symbol '__put_old_timespec32' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
