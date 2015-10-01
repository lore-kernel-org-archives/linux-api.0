From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] uapi: remove i2o header in uapi
Date: Thu, 1 Oct 2015 23:30:58 +0800
Message-ID: <201510012309.uy3aFTa1%fengguang.wu@intel.com>
References: <1443712510-6714-1-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443712510-6714-1-git-send-email-gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Gabriel,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

config: cris-etrax-100lx_v2_defconfig (attached as .config)
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout e8edc215dd1ecc5508a7dbcd62d3f2fed6be299c
        # save the attached .config to linux build tree
        make.cross ARCH=cris 

All error/warnings (new ones prefixed by >>):

>> scripts/Makefile.headersinst:55: *** Missing UAPI file include/uapi/linux/i2o-dev.h.  Stop.
--
>> scripts/Makefile.headersinst:55: *** Missing UAPI file include/uapi/linux/i2o-dev.h.  Stop.
   make[2]: *** [linux] Error 2
   make[2]: Target '__headersinst' not remade because of errors.
   make[1]: *** [headers_install] Error 2
   make: *** [sub-make] Error 2

vim +55 scripts/Makefile.headersinst

d8ecc5cd Sam Ravnborg    2011-04-27  39  
10b63956 David Howells   2012-10-02  40  srcdir        := $(srctree)/$(obj)
10b63956 David Howells   2012-10-02  41  gendir        := $(objtree)/$(gen)
10b63956 David Howells   2012-10-02  42  
10b63956 David Howells   2012-10-02  43  oldsrcdir     := $(srctree)/$(subst /uapi,,$(obj))
10b63956 David Howells   2012-10-02  44  
7712401a Sam Ravnborg    2008-06-15  45  # all headers files for this dir
d8ecc5cd Sam Ravnborg    2011-04-27  46  header-y      := $(filter-out $(generic-y), $(header-y))
40f1d4c2 David Howells   2012-10-02  47  all-files     := $(header-y) $(genhdr-y) $(wrapper-files)
10b63956 David Howells   2012-10-02  48  output-files  := $(addprefix $(installdir)/, $(all-files))
10b63956 David Howells   2012-10-02  49  
c0ff68f1 Nicolas Dichtel 2013-04-29  50  input-files1  := $(foreach hdr, $(header-y), \
c4619bc6 Sam Ravnborg    2013-03-04  51  		   $(if $(wildcard $(srcdir)/$(hdr)), \
c0ff68f1 Nicolas Dichtel 2013-04-29  52  			$(wildcard $(srcdir)/$(hdr))) \
c0ff68f1 Nicolas Dichtel 2013-04-29  53  		   )
c0ff68f1 Nicolas Dichtel 2013-04-29  54  input-files1-name := $(notdir $(input-files1))
c0ff68f1 Nicolas Dichtel 2013-04-29 @55  input-files2  := $(foreach hdr, $(header-y), \
c0ff68f1 Nicolas Dichtel 2013-04-29  56  		   $(if  $(wildcard $(srcdir)/$(hdr)),, \
c4619bc6 Sam Ravnborg    2013-03-04  57  			$(if $(wildcard $(oldsrcdir)/$(hdr)), \
10b63956 David Howells   2012-10-02  58  				$(wildcard $(oldsrcdir)/$(hdr)), \
c4619bc6 Sam Ravnborg    2013-03-04  59  				$(error Missing UAPI file $(srcdir)/$(hdr))) \
c0ff68f1 Nicolas Dichtel 2013-04-29  60  		   ))
c0ff68f1 Nicolas Dichtel 2013-04-29  61  input-files2-name := $(notdir $(input-files2))
c0ff68f1 Nicolas Dichtel 2013-04-29  62  input-files3  := $(foreach hdr, $(genhdr-y), \
c4619bc6 Sam Ravnborg    2013-03-04  63  		   $(if	$(wildcard $(gendir)/$(hdr)), \

:::::: The code at line 55 was first introduced by commit
:::::: c0ff68f1611d6855a06d672989ad5cfea160a4eb kbuild: fix make headers_install when path is too long

:::::: TO: Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
:::::: CC: Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--TB36FDmn/VVEgNH/
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
TdG/Iv8/Ha/P+Sh2AAA=

--TB36FDmn/VVEgNH/--
