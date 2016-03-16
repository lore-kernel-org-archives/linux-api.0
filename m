From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v5 2/6] module: preserve Elf information for livepatch
 modules
Date: Thu, 17 Mar 2016 05:31:59 +0800
Message-ID: <201603170532.SlWp2D1w%fengguang.wu@intel.com>
References: <1458157628-8264-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458157628-8264-3-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
Cc: kbuild-all@01.org, Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org, Jessica Yu <jeyu@redhat.com>
List-Id: linux-api@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jessica,

[auto build test WARNING on s390/features]
[also build test WARNING on v4.5 next-20160316]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Jessica-Yu/mostly-Arch-independent-livepatch/20160317-035230
base:   https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
config: openrisc-or1ksim_defconfig (attached as .config)
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=openrisc 

All warnings (new ones prefixed by >>):

   kernel/module.c: In function 'find_livepatch_modinfo':
   kernel/module.c:2766:3: error: expected ')' before 'mod'
>> kernel/module.c:2766:3: warning: too few arguments for format

vim +2766 kernel/module.c

  2750			len -= n;
  2751		} while (len);
  2752		return 0;
  2753	}
  2754	
  2755	#ifdef CONFIG_LIVEPATCH
  2756	static int find_livepatch_modinfo(struct module *mod, struct load_info *info)
  2757	{
  2758		mod->klp = get_modinfo(info, "livepatch") ? true : false;
  2759	
  2760		return 0;
  2761	}
  2762	#else /* !CONFIG_LIVEPATCH */
  2763	static int find_livepatch_modinfo(struct module *mod, struct load_info *info)
  2764	{
  2765		if (get_modinfo(info, "livepatch")) {
> 2766			pr_err("%s: module is marked as livepatch module, but livepatch support is disabled"
  2767			       mod->name);
  2768			return -ENOEXEC;
  2769		}
  2770	
  2771		return 0;
  2772	}
  2773	#endif /* CONFIG_LIVEPATCH */
  2774	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--/04w6evG8XlLl3ft
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--/04w6evG8XlLl3ft--
