From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 6/6] crypto: AF_ALG - add support for key_id
Date: Fri, 15 Apr 2016 14:32:47 -0700
Message-ID: <57115DFF.4030605@intel.com>
References: <201604160521.QBqFNMI6%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201604160521.QBqFNMI6%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/15/2016 02:32 PM, kbuild test robot wrote:
> Hi Tadeusz,
> 
> [auto build test ERROR on cryptodev/master]
> [also build test ERROR on v4.6-rc3 next-20160415]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Tadeusz-Struk/crypto-algif-add-akcipher/20160416-043207
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: i386-allmodconfig (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 

Hi,
It's is for https://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-next
plus this:
https://patchwork.kernel.org/patch/8843381/
Thanks,
-- 
TS
