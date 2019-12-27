From: Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH v7 2/3] pid: Introduce pidfd_getfd syscall
Date: Thu, 26 Dec 2019 20:35:00 -0500
Message-ID: <CAMp4zn94deUbkXBrnX=Omw9-FmoZDANApqYUVsaV+VsXCX4Q-w@mail.gmail.com>
References: <20191226180334.GA29409@ircssh-2.c.rugged-nimbus-611.internal> <201912270545.TQnRs9kG%lkp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201912270545.TQnRs9kG%lkp@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@lists.01.org, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian.brauner@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>, Gian-Carlo Pascutto <gpascutto@mozilla.com>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <ealvarez@mozilla.com>, Florian Weimer <fweimer@redhat.com>, Jed Davis <jld@mozilla.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 26, 2019 at 5:20 PM kbuild test robot <lkp@intel.com> wrote:
>
> Hi Sargun,
>
> Thank you for the patch! Yet something to improve:
>
> All errors (new ones prefixed by >>):
>
>    arch/alpha/kernel/systbls.o: In function `sys_call_table':
> >> (.data+0x1120): undefined reference to `sys_pidfd'
This is a small typo. I'll fix this in the next respin.


>
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
