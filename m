From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 6/6] coresight-stm: adding driver for CoreSight STM component
Date: Mon, 1 Feb 2016 09:53:09 -0700
Message-ID: <CANLsYkz5soN-DKYf5V8ucYEpF1VKdx2cdu2yyVsrWLHiZBqxhA@mail.gmail.com>
References: <1454313529-8860-7-git-send-email-zhang.chunyan@linaro.org>
	<201602011753.FpQPQQPf%fengguang.wu@intel.com>
	<CAG2=9p_vBrgyzZohZ-LK2uoMRYEJFnyBQvUQJEgfTKCk+GvRwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAG2=9p_vBrgyzZohZ-LK2uoMRYEJFnyBQvUQJEgfTKCk+GvRwA@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chunyan Zhang <zhang.chunyan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>, robh@kernel.org, Mark Brown <broonie@kernel.org>, Pratik Patel <pratikp@codeaurora.org>, Nicolas GUION <nicolas.guion@st.com>, Jon Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, Lyra Zhang <zhang.lyra@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 1 February 2016 at 05:44, Chunyan Zhang <zhang.chunyan@linaro.org> wrote:
> Hi Mathieu,
>
> So sorry that I forgot this patch depends on [1] which hasn't been upstreamed.
> How about adding the definition of coresight_simple_func() like [1]
> does in the STM driver for the time being? It can be simply removed
> once [1] is upstreamed. If you agree with this idea, I'll add the
> definition of coresight_simple_func() in the next version of patches.

I'm fine with proceeding this way - with the Perf integration work
there is simply too much churn in the Coresight subsystem to deal with
that immediately.

Mathieu

>
> Thanks,
> Chunyan
>
> [1] https://git.linaro.org/people/mathieu.poirier/coresight.git/blobdiff/59aadd3319527addcf8dbc6e6064b15f74b244fe..76dda3d0d313a4676d43adef52ad8faec0c61b61:/drivers/hwtracing/coresight/coresight-priv.h
>
> On Mon, Feb 1, 2016 at 6:01 PM, kbuild test robot <lkp@intel.com> wrote:
>> Hi Pratik,
>>
>> [auto build test ERROR on robh/for-next]
>> [also build test ERROR on v4.5-rc2 next-20160201]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>>
>> url:    https://github.com/0day-ci/linux/commits/Chunyan-Zhang/Introduce-CoreSight-STM-support/20160201-160437
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux for-next
>> config: arm-allmodconfig (attached as .config)
>> reproduce:
>>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         # save the attached .config to linux build tree
>>         make.cross ARCH=arm
>>
>> All errors (new ones prefixed by >>):
>>
>>>> drivers/hwtracing/coresight/coresight-stm.c:671:27: error: unknown type name 'tcsr'
>>     coresight_stm_simple_func(tcsr, STMTCSR);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:57:20: error: expected declaration specifiers or '...' before numeric constant
>>     #define STMTCSR    0xe80
>>                        ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:671:33: note: in expansion of macro 'STMTCSR'
>>     coresight_stm_simple_func(tcsr, STMTCSR);
>>                                     ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:672:27: error: unknown type name 'tsfreqr'
>>     coresight_stm_simple_func(tsfreqr, STMTSFREQR);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>    drivers/hwtracing/coresight/coresight-stm.c:59:22: error: expected declaration specifiers or '...' before numeric constant
>>     #define STMTSFREQR   0xe8c
>>                          ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:672:36: note: in expansion of macro 'STMTSFREQR'
>>     coresight_stm_simple_func(tsfreqr, STMTSFREQR);
>>                                        ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:673:27: error: unknown type name 'syncr'
>>     coresight_stm_simple_func(syncr, STMSYNCR);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>    drivers/hwtracing/coresight/coresight-stm.c:60:20: error: expected declaration specifiers or '...' before numeric constant
>>     #define STMSYNCR   0xe90
>>                        ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:673:34: note: in expansion of macro 'STMSYNCR'
>>     coresight_stm_simple_func(syncr, STMSYNCR);
>>                                      ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:674:27: error: unknown type name 'sper'
>>     coresight_stm_simple_func(sper, STMSPER);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>    drivers/hwtracing/coresight/coresight-stm.c:49:20: error: expected declaration specifiers or '...' before numeric constant
>>     #define STMSPER    0xe00
>>                        ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:674:33: note: in expansion of macro 'STMSPER'
>>     coresight_stm_simple_func(sper, STMSPER);
>>                                     ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:675:27: error: unknown type name 'spter'
>>     coresight_stm_simple_func(spter, STMSPTER);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>    drivers/hwtracing/coresight/coresight-stm.c:50:20: error: expected declaration specifiers or '...' before numeric constant
>>     #define STMSPTER   0xe20
>>                        ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:675:34: note: in expansion of macro 'STMSPTER'
>>     coresight_stm_simple_func(spter, STMSPTER);
>>                                      ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:676:27: error: unknown type name 'privmaskr'
>>     coresight_stm_simple_func(privmaskr, STMPRIVMASKR);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>    drivers/hwtracing/coresight/coresight-stm.c:51:24: error: expected declaration specifiers or '...' before numeric constant
>>     #define STMPRIVMASKR   0xe40
>>                            ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:676:38: note: in expansion of macro 'STMPRIVMASKR'
>>     coresight_stm_simple_func(privmaskr, STMPRIVMASKR);
>>                                          ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:677:27: error: unknown type name 'spscr'
>>     coresight_stm_simple_func(spscr, STMSPSCR);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>    drivers/hwtracing/coresight/coresight-stm.c:52:20: error: expected declaration specifiers or '...' before numeric constant
>>     #define STMSPSCR   0xe60
>>                        ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:677:34: note: in expansion of macro 'STMSPSCR'
>>     coresight_stm_simple_func(spscr, STMSPSCR);
>>                                      ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:678:27: error: unknown type name 'spmscr'
>>     coresight_stm_simple_func(spmscr, STMSPMSCR);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>    drivers/hwtracing/coresight/coresight-stm.c:53:21: error: expected declaration specifiers or '...' before numeric constant
>>     #define STMSPMSCR   0xe64
>>                         ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:678:35: note: in expansion of macro 'STMSPMSCR'
>>     coresight_stm_simple_func(spmscr, STMSPMSCR);
>>                                       ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:679:27: error: unknown type name 'spfeat1r'
>>     coresight_stm_simple_func(spfeat1r, STMSPFEAT1R);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>    drivers/hwtracing/coresight/coresight-stm.c:62:23: error: expected declaration specifiers or '...' before numeric constant
>>     #define STMSPFEAT1R   0xea0
>>                           ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:679:37: note: in expansion of macro 'STMSPFEAT1R'
>>     coresight_stm_simple_func(spfeat1r, STMSPFEAT1R);
>>                                         ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:680:27: error: unknown type name 'spfeat2r'
>>     coresight_stm_simple_func(spfeat2r, STMSPFEAT2R);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>    drivers/hwtracing/coresight/coresight-stm.c:63:23: error: expected declaration specifiers or '...' before numeric constant
>>     #define STMSPFEAT2R   0xea4
>>                           ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:680:37: note: in expansion of macro 'STMSPFEAT2R'
>>     coresight_stm_simple_func(spfeat2r, STMSPFEAT2R);
>>                                         ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:681:27: error: unknown type name 'spfeat3r'
>>     coresight_stm_simple_func(spfeat3r, STMSPFEAT3R);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>    drivers/hwtracing/coresight/coresight-stm.c:64:23: error: expected declaration specifiers or '...' before numeric constant
>>     #define STMSPFEAT3R   0xea8
>>                           ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:681:37: note: in expansion of macro 'STMSPFEAT3R'
>>     coresight_stm_simple_func(spfeat3r, STMSPFEAT3R);
>>                                         ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:682:27: error: unknown type name 'devid'
>>     coresight_stm_simple_func(devid, CORESIGHT_DEVID);
>>                               ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:44: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                ^
>>    drivers/hwtracing/coresight/coresight-priv.h:31:26: error: expected declaration specifiers or '...' before numeric constant
>>     #define CORESIGHT_DEVID  0xfc8
>>                              ^
>>    drivers/hwtracing/coresight/coresight-stm.c:669:50: note: in definition of macro 'coresight_stm_simple_func'
>>      coresight_simple_func(struct stm_drvdata, name, offset)
>>                                                      ^
>>    drivers/hwtracing/coresight/coresight-stm.c:682:34: note: in expansion of macro 'CORESIGHT_DEVID'
>>     coresight_stm_simple_func(devid, CORESIGHT_DEVID);
>>                                      ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:694:3: error: 'dev_attr_tcsr' undeclared here (not in a function)
>>      &dev_attr_tcsr.attr,
>>       ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:695:3: error: 'dev_attr_tsfreqr' undeclared here (not in a function)
>>      &dev_attr_tsfreqr.attr,
>>       ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:696:3: error: 'dev_attr_syncr' undeclared here (not in a function)
>>      &dev_attr_syncr.attr,
>>       ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:697:3: error: 'dev_attr_sper' undeclared here (not in a function)
>>      &dev_attr_sper.attr,
>>       ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:698:3: error: 'dev_attr_spter' undeclared here (not in a function)
>>      &dev_attr_spter.attr,
>>       ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:699:3: error: 'dev_attr_privmaskr' undeclared here (not in a function)
>>      &dev_attr_privmaskr.attr,
>>       ^
>>>> drivers/hwtracing/coresight/coresight-stm.c:700:3: error: 'dev_attr_spscr' undeclared here (not in a function)
>>      &dev_attr_spscr.attr,
>>       ^
>>
>> vim +/tcsr +671 drivers/hwtracing/coresight/coresight-stm.c
>>
>>    663          drvdata->traceid = val & 0x7f;
>>    664          return size;
>>    665  }
>>    666  static DEVICE_ATTR_RW(traceid);
>>    667
>>    668  #define coresight_stm_simple_func(name, offset) \
>>  > 669          coresight_simple_func(struct stm_drvdata, name, offset)
>>    670
>>  > 671  coresight_stm_simple_func(tcsr, STMTCSR);
>>  > 672  coresight_stm_simple_func(tsfreqr, STMTSFREQR);
>>  > 673  coresight_stm_simple_func(syncr, STMSYNCR);
>>  > 674  coresight_stm_simple_func(sper, STMSPER);
>>  > 675  coresight_stm_simple_func(spter, STMSPTER);
>>  > 676  coresight_stm_simple_func(privmaskr, STMPRIVMASKR);
>>  > 677  coresight_stm_simple_func(spscr, STMSPSCR);
>>  > 678  coresight_stm_simple_func(spmscr, STMSPMSCR);
>>  > 679  coresight_stm_simple_func(spfeat1r, STMSPFEAT1R);
>>  > 680  coresight_stm_simple_func(spfeat2r, STMSPFEAT2R);
>>  > 681  coresight_stm_simple_func(spfeat3r, STMSPFEAT3R);
>>  > 682  coresight_stm_simple_func(devid, CORESIGHT_DEVID);
>>    683
>>    684  static struct attribute *coresight_stm_attrs[] = {
>>    685          &dev_attr_hwevent_enable.attr,
>>    686          &dev_attr_hwevent_select.attr,
>>    687          &dev_attr_port_enable.attr,
>>    688          &dev_attr_port_select.attr,
>>    689          &dev_attr_traceid.attr,
>>    690          NULL,
>>    691  };
>>    692
>>    693  static struct attribute *coresight_stm_mgmt_attrs[] = {
>>  > 694          &dev_attr_tcsr.attr,
>>  > 695          &dev_attr_tsfreqr.attr,
>>  > 696          &dev_attr_syncr.attr,
>>  > 697          &dev_attr_sper.attr,
>>  > 698          &dev_attr_spter.attr,
>>  > 699          &dev_attr_privmaskr.attr,
>>  > 700          &dev_attr_spscr.attr,
>>  > 701          &dev_attr_spmscr.attr,
>>  > 702          &dev_attr_spfeat1r.attr,
>>  > 703          &dev_attr_spfeat2r.attr,
>>  > 704          &dev_attr_spfeat3r.attr,
>>  > 705          &dev_attr_devid.attr,
>>    706          NULL,
>>    707  };
>>    708
>>
>> ---
>> 0-DAY kernel test infrastructure                Open Source Technology Center
>> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
