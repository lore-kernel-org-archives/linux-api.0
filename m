From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [PATCH 2/2] ipc: fix sparc64 ipc() wrapper
Date: Thu, 5 Sep 2019 23:38:39 +0300
Message-ID: <CADxRZqxkj+vdAOtZYmKtavy5nCtNFAUgfZ6k12nYeNcPYB+ssw@mail.gmail.com>
References: <20190905152155.1392871-1-arnd@arndb.de> <20190905152155.1392871-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190905152155.1392871-2-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, "Eric W. Biederman" <ebiederm@xmission.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Christian Brauner <christian@brauner.io>, Manfred Spraul <manfred@colorfullife.com>, Davidlohr Bueso <dave@stgolabs.net>, linux-arch@vger.kernel.org, y2038@lists.linaro.org, Dominik Brodowski <linux@dominikbrodowski.net>, Matt Turner <mattst88@gmail.com>, stable@vger.kernel.org, Sparc kernel list <sparclinux@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 5, 2019 at 9:39 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Matt bisected a sparc64 specific issue with semctl, shmctl and msgctl
> to a commit from my y2038 series in linux-5.1, as I missed the custom
> sys_ipc() wrapper that sparc64 uses in place of the generic version that
> I patched.
>
> The problem is that the sys_{sem,shm,msg}ctl() functions in the kernel
> now do not allow being called with the IPC_64 flag any more, resulting
> in a -EINVAL error when they don't recognize the command.
>
> Instead, the correct way to do this now is to call the internal
> ksys_old_{sem,shm,msg}ctl() functions to select the API version.
>
> As we generally move towards these functions anyway, change all of
> sparc_ipc() to consistently use those in place of the sys_*() versions,
> and move the required ksys_*() declarations into linux/syscalls.h
>
> Reported-by: Matt Turner <mattst88@gmail.com>
> Fixes: 275f22148e87 ("ipc: rename old-style shmctl/semctl/msgctl syscalls")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>


Not Matt,

but this patch fixes util-linux.git ipcs test-suite (make check)
regression for me on current sparc64 git kernel (5.3.0-rc7), which was
broken somewhere in between 4.19 (debian unstable kernel) and 5.3-rcX.

Thanks!

PS: wanted to bisect kernel, but Matt did it first.
