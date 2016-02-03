From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH V2 2/6] stm class: adds a loop to extract the first valid
 STM device name
Date: Wed, 3 Feb 2016 18:05:22 +0800
Message-ID: <201602031758.BtqxFNRd%fengguang.wu@intel.com>
References: <1454487337-30184-3-git-send-email-zhang.chunyan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454487337-30184-3-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Chunyan Zhang <zhang.chunyan@linaro.org>
Cc: kbuild-all@01.org, mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com, robh@kernel.org, broonie@kernel.org, pratikp@codeaurora.org, nicolas.guion@st.com, corbet@lwn.net, mark.rutland@arm.com, mike.leach@arm.com, tor@ti.com, al.grant@arm.com, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Chunyan,

[auto build test WARNING on robh/for-next]
[also build test WARNING on v4.5-rc2 next-20160203]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Chunyan-Zhang/Introduce-CoreSight-STM-support/20160203-161836
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux for-next


coccinelle warnings: (new ones prefixed by >>)

>> drivers/hwtracing/stm/policy.c:341:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
