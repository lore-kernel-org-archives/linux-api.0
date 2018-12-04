From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v9 2/4] seccomp: switch system call argument type to void
 *
Date: Mon, 3 Dec 2018 19:34:05 -0700
Message-ID: <20181204023405.GH3504@cisco>
References: <20181203032827.27978-3-tycho@tycho.ws>
 <201812041031.7kJxvTuh%fengguang.wu@intel.com>
 <20181204021726.GG3504@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181204021726.GG3504@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Dec 03, 2018 at 07:17:26PM -0700, Tycho Andersen wrote:
> On Tue, Dec 04, 2018 at 10:07:38AM +0800, kbuild test robot wrote:
> > Hi Tycho,
> > 
> > I love your patch! Yet something to improve:
> > 
> > [auto build test ERROR on linus/master]
> > [also build test ERROR on v4.20-rc5 next-20181203]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Tycho-Andersen/seccomp-hoist-struct-seccomp_data-recalculation-higher/20181204-013450
> > config: i386-randconfig-x005-201848 (attached as .config)
> > compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> > reproduce:
> >         # save the attached .config to linux build tree
> >         make ARCH=i386 
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    In file included from kernel/seccomp.c:28:0:
> > >> include/linux/syscalls.h:239:18: error: conflicting types for 'sys_seccomp'
> >      asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__)) \
> >                      ^
> >    include/linux/syscalls.h:225:2: note: in expansion of macro '__SYSCALL_DEFINEx'
> >      __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
> >      ^~~~~~~~~~~~~~~~~
> >    include/linux/syscalls.h:216:36: note: in expansion of macro 'SYSCALL_DEFINEx'
> >     #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
> >                                        ^~~~~~~~~~~~~~~
> >    kernel/seccomp.c:946:1: note: in expansion of macro 'SYSCALL_DEFINE3'
> >     SYSCALL_DEFINE3(seccomp, unsigned int, op, unsigned int, flags,
> >     ^~~~~~~~~~~~~~~
> >    In file included from kernel/seccomp.c:28:0:
> >    include/linux/syscalls.h:881:17: note: previous declaration of 'sys_seccomp' was here
> >     asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
> >                     ^~~~~~~~~~~
> 
> Huh, I have no idea why I don't see this, but even with the attached
> config it still doesn't cause a problem for me. Anyway, I'll fix it up
> and do some more investigating...

Oh, because it's "make ARCH=i386". Whoosh :)

Anyway, it's fixed for v10.

Tycho
