From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] syscalls: Fix references to filenames containing
 syscall defs
Date: Tue, 5 Nov 2019 10:34:07 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1911051033050.17054@nanos.tec.linutronix.de>
References: <20191105022928.517526-1-farnasirim@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191105022928.517526-1-farnasirim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mohammad Nasirifar <far.nasiri.m@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Mohammad Nasirifar <farnasirim@gmail.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Valdis Kletnieks <valdis.kletnieks@vt.edu>
List-Id: linux-api@vger.kernel.org

On Mon, 4 Nov 2019, Mohammad Nasirifar wrote:

> Fix stale references to files containing syscall definitions in
> 'include/linux/syscalls.h' and 'include/uapi/asm-generic/unistd.h',
> pointing to 'kernel/itimer.c', 'kernel/hrtimer.c', and 'kernel/time.c'.
> They are now under 'kernel/time'.
> 
> Also definitions of 'getpid', 'getppid', 'getuid', 'geteuid', 'getgid',
> 'getegid', 'gettid', and 'sysinfo' are now in 'kernel/sys.c'.

Can we please remove these file references completely. They are going to be
stale sooner than later again and they really do not provide any value.

Thanks,

	tglx
