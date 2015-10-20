From: Tycho Andersen <tycho.andersen@canonical.com>
Subject: Re: [PATCH v8] seccomp, ptrace: add support for dumping seccomp
 filters
Date: Tue, 20 Oct 2015 14:37:56 -0600
Message-ID: <20151020203756.GP3982@smitten>
References: <1445370612-18843-1-git-send-email-tycho.andersen@canonical.com>
 <1445370612-18843-2-git-send-email-tycho.andersen@canonical.com>
 <20151020202024.GA5772@redhat.com>
 <CAGXu5jLxioKseJ8TPyPqty1MwF5FMUsmkU3j=e66OZFCxFz53Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLxioKseJ8TPyPqty1MwF5FMUsmkU3j=e66OZFCxFz53Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Will Drewry <wad@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Daniel Borkmann <daniel@iogearbox.net>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2015 at 01:26:01PM -0700, Kees Cook wrote:
> On Tue, Oct 20, 2015 at 1:20 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Oh wait, I didn't notice this when I looked at v7.
> >
> > No, you can't do copy_to_user() from atomic context. You need to pin this
> > filter, drop the lock/irq, then copy_to_user().
> 
> Which CONFIGs would yell about this? CONFIG_DEBUG_ATOMIC_SLEEP?

Yep, it seems to,

Oct 20 14:35:55 kernel kernel: [   17.879492] BUG: sleeping function called from invalid context at ./arch/x86/include/asm/uaccess.h:732
Oct 20 14:35:55 kernel kernel: [   17.880925] in_atomic(): 1, irqs_disabled(): 1, pid: 2023, name: criu
Oct 20 14:35:55 kernel kernel: [   17.881913] CPU: 2 PID: 2023 Comm: criu Not tainted 4.3.0-rc3+ #11
Oct 20 14:35:55 kernel kernel: [   17.881915] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
Oct 20 14:35:55 kernel kernel: [   17.881916]  00000000000002dc ffff880078ca7dc8 ffffffff8133605d ffff880078819780
Oct 20 14:35:55 kernel kernel: [   17.881920]  ffff880078ca7de0 ffffffff81077b3f ffffffff81baf4a0 ffff880078ca7e08
Oct 20 14:35:55 kernel kernel: [   17.881922]  ffffffff81077bc4 00007ffe1570c420 ffff8800798bb460 0000000000000004
Oct 20 14:35:55 kernel kernel: [   17.881924] Call Trace:
Oct 20 14:35:55 kernel kernel: [   17.881932]  [<ffffffff8133605d>] dump_stack+0x4b/0x6e
Oct 20 14:35:55 kernel kernel: [   17.881940]  [<ffffffff81077b3f>] ___might_sleep+0xcf/0x110
Oct 20 14:35:55 kernel kernel: [   17.881943]  [<ffffffff81077bc4>] __might_sleep+0x44/0x80
Oct 20 14:35:55 kernel kernel: [   17.881950]  [<ffffffff8114b2f2>] __might_fault+0x32/0x40
Oct 20 14:35:55 kernel kernel: [   17.881956]  [<ffffffff810eadc5>] seccomp_get_filter+0x115/0x170
Oct 20 14:35:55 kernel kernel: [   17.881961]  [<ffffffff8105f483>] ptrace_request+0x73/0x5d0
Oct 20 14:35:55 kernel kernel: [   17.881969]  [<ffffffff81182698>] ? __fput+0x188/0x1f0
Oct 20 14:35:55 kernel kernel: [   17.881980]  [<ffffffff818ddf29>] ? _raw_spin_unlock_irqrestore+0x9/0x10
Oct 20 14:35:55 kernel kernel: [   17.881983]  [<ffffffff8107c30c>] ? wait_task_inactive+0xfc/0x1f0
Oct 20 14:35:55 kernel kernel: [   17.881986]  [<ffffffff810490ea>] ? __do_page_fault+0x1ca/0x410
Oct 20 14:35:55 kernel kernel: [   17.881990]  [<ffffffff81011d94>] arch_ptrace+0x2a4/0x320
Oct 20 14:35:55 kernel kernel: [   17.881993]  [<ffffffff8105f32a>] SyS_ptrace+0x7a/0x100
Oct 20 14:35:55 kernel kernel: [   17.881996]  [<ffffffff818de4ae>] entry_SYSCALL_64_fastpath+0x12/0x71

Thanks, Oleg. I'll make the change and re-send.

Tycho
