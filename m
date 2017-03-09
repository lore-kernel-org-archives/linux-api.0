From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v2 1/4] syscalls: Restore address limit after a syscall
Date: Thu, 9 Mar 2017 19:39:12 +0900
Message-ID: <20170309103911.GA565@jagdpanzerIV.localdomain>
References: <20170309012456.5631-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-6964-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20170309012456.5631-1-thgarnie@google.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
List-Id: linux-api@vger.kernel.org

Hello,

On (03/08/17 17:24), Thomas Garnier wrote:
> This patch ensures a syscall does not return to user-mode with a kernel
> address limit. If that happened, a process can corrupt kernel-mode
> memory and elevate privileges.


I like the patch set.


a side note (perhaps a bit irrelevant), the WARN backtrace does not
really tell more than "incorrect get_fs() on user-mode return" message
does

 incorrect get_fs() on user-mode return
 ------------[ cut here ]------------
 kernel BUG at kernel/sys.c:2467!
 invalid opcode: 0000 [#1] PREEMPT SMP
 Modules linked in: FOO
 CPU: 2 PID: 355 Comm: BAR
 Hardware name: BUZ
 task: ffff8801329f4e00 task.stack: ffffc900005d8000
 RIP: 0010:verify_pre_usermode_state+0x31/0x34
 RSP: 0018:ffffc900005dbf48 EFLAGS: 00010096
 RAX: 0000000000000026 RBX: 0000000000000002 RCX: 0000000000000001
 RDX: 0000000000000046 RSI: ffff880130cead88 RDI: ffffffff81095594
 RBP: ffffc900005dbf48 R08: 0000000000000001 R09: 0000000000000001
 R10: ffffc900005dbd58 R11: ffff8801329f4e00 R12: 0000000000000002
 R13: 0000000000000001 R14: 00007fb6c6a7b5e0 R15: 0000000000000002
 FS:  00007fb6c70d3b40(0000) GS:ffff880137d00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007ffd9d94f8f8 CR3: 00000001295b2000 CR4: 00000000000006e0
 Call Trace:
  entry_SYSCALL_64_fastpath+0x3a/0xb2
 RIP: 0033:0x7fb6c67ba3c0
 RSP: 002b:00007ffd9d94f5c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
 RAX: 0000000000000002 RBX: 0000000000000000 RCX: 00007fb6c67ba3c0
 RDX: 0000000000000002 RSI: 0000000000ba7310 RDI: 0000000000000001
 RBP: 0000000000000001 R08: 00007fb6c6a7c740 R09: 00007fb6c70d3b40
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 Code: 48 8b 14 25 40 c5 00 00 48 b8 00 f0 ff ff ff 7f 00 00 48 39 82 28 11 00 00 74 12 55 48 c7 c7 9b f5 78 81 48 89 e5 e8 14 19 0b 00 <0f> 0b c3 66 66 66 66 90 55 48 89 e5 53 48 8b 47 50 48 89 fb 48 


may be some day someone would be interested in something like
    "incorrect get_fs() on user-mode return from %pS"
and set_fs() would save _RET_IP_.

just a side note.

	-ss
