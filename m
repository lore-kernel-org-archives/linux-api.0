From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 1/2] CLONE_PIDFD: do not use the value pointed by
 parent_tidptr
Date: Mon, 24 Jun 2019 15:49:22 +0200
Message-ID: <20190624134921.mvgabuz3mgmpuu3n@brauner.io>
References: <20190620103105.cdxgqfelzlnkmblv@brauner.io>
 <20190620110037.GA4998@altlinux.org>
 <20190620111036.asi3mbcv4ax5ekrw@brauner.io>
 <20190621170613.GA26182@altlinux.org>
 <20190621221339.6yj4vg4zexv4y2j7@brauner.io>
 <20190623112717.GA20697@altlinux.org>
 <20190624094940.24qrteybbcp25wq7@brauner.io>
 <20190624115942.g6vyis3zy4ptt3fc@brauner.io>
 <20190624134531.GB6010@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190624134531.GB6010@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 24, 2019 at 04:45:31PM +0300, Dmitry V. Levin wrote:
> On Mon, Jun 24, 2019 at 01:59:43PM +0200, Christian Brauner wrote:
> > On Mon, Jun 24, 2019 at 11:49:40AM +0200, Christian Brauner wrote:
> > > On Sun, Jun 23, 2019 at 02:27:17PM +0300, Dmitry V. Levin wrote:
> > > > Userspace needs a cheap and reliable way to tell whether CLONE_PIDFD
> > > > is supported by the kernel or not.
> > > > 
> > > > While older kernels without CLONE_PIDFD support just leave unchanged
> > > > the value pointed by parent_tidptr, current implementation fails with
> > > > EINVAL if that value is non-zero.
> > > > 
> > > > If CLONE_PIDFD is supported and fd 0 is closed, then mandatory pidfd == 0
> > > > pointed by parent_tidptr also remains unchanged, which effectively
> > > > means that userspace must either check CLONE_PIDFD support beforehand
> > > > or ensure that fd 0 is not closed when invoking CLONE_PIDFD.
> > > > 
> > > > The check for pidfd == 0 was introduced during v5.2 release cycle
> > > > by commit b3e583825266 ("clone: add CLONE_PIDFD") to ensure that
> > > > CLONE_PIDFD could be potentially extended by passing in flags through
> > > > the return argument.
> > > > 
> > > > However, that extension would look horrendous, and with introduction of
> > > > clone3 syscall in v5.3 there is no need to extend legacy clone syscall
> > > > this way.
> > > > 
> > > > So remove the pidfd == 0 check.  Userspace that needs to be portable
> > > > to kernels without CLONE_PIDFD support is advised to initialize pidfd
> > > > with -1 and check the pidfd value returned by CLONE_PIDFD.
> > > > 
> > > > Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
> > > 
> > > Reviewed-by: Christian Brauner <christian@brauner.io>
> > > 
> > > Thank you Dmitry, queueing this up for rc7.
> > 
> > This is now sitting in
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/commit/?h=fixes&id=43754d05f235dd1b6c7f8ab9f42007770d721f10
> > 
> > I reformulated the commit message a bit and gave it a Fixes tag. Dmitry,
> > if you want you can take a look and tell me if that's acceptable to you.
> 
> s/Old kernel that only support/Old kernels that only support/

Fixed.

Thanks!
Christian
