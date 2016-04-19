From: Philip Li <philip.li@intel.com>
Subject: Re: [PATCH v5 6/6] crypto: AF_ALG - add support for key_id
Date: Tue, 19 Apr 2016 18:25:17 +0800
Message-ID: <20160419102517.GE8836@intel.com>
References: <201604160521.QBqFNMI6%fengguang.wu@intel.com>
 <57115DFF.4030605@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57115DFF.4030605@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>, xiaolong.ye@intel.com
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, dhowells@redhat.com, herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

On Fri, Apr 15, 2016 at 02:32:47PM -0700, Tadeusz Struk wrote:
> On 04/15/2016 02:32 PM, kbuild test robot wrote:
> > Hi Tadeusz,
> > 
> > [auto build test ERROR on cryptodev/master]
> > [also build test ERROR on v4.6-rc3 next-20160415]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Tadeusz-Struk/crypto-algif-add-akcipher/20160416-043207
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> > config: i386-allmodconfig (attached as .config)
> > reproduce:
> >         # save the attached .config to linux build tree
> >         make ARCH=i386 
> 
> Hi,
> It's is for https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-next
> plus this:
> https://patchwork.kernel.org/patch/8843381/

Thanks Tadeusz for the feedback.

hi Xiaolong, anything we can do in 0day side to detect the base for this case?

> Thanks,
> -- 
> TS
> 
