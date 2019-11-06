From: Mohammad Nasirifar <far.nasiri.m@gmail.com>
Subject: Re: [PATCH 1/1] syscalls: Fix references to filenames containing
 syscall defs
Date: Wed, 6 Nov 2019 11:47:56 -0500
Message-ID: <20191106164756.GA558585@gmail.com>
References: <20191105022928.517526-1-farnasirim@gmail.com>
 <alpine.DEB.2.21.1911051033050.17054@nanos.tec.linutronix.de>
 <CAK8P3a0wyw=CwhiU34t1zBiSesf+HGBLeaV+=JVko_TjnvATHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a0wyw=CwhiU34t1zBiSesf+HGBLeaV+=JVko_TjnvATHQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Mohammad Nasirifar <farnasirim@gmail.com>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Valdis Kletnieks <valdis.kletnieks@vt.edu>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 05, 2019 at 10:49:12AM +0100, Arnd Bergmann wrote:
>On Tue, Nov 5, 2019 at 10:34 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Mon, 4 Nov 2019, Mohammad Nasirifar wrote:
>> > Fix stale references to files containing syscall definitions in
>> > 'include/linux/syscalls.h' and 'include/uapi/asm-generic/unistd.h',
>> > pointing to 'kernel/itimer.c', 'kernel/hrtimer.c', and 'kernel/time.c'.
>> > They are now under 'kernel/time'.
>> >
>> > Also definitions of 'getpid', 'getppid', 'getuid', 'geteuid', 'getgid',
>> > 'getegid', 'gettid', and 'sysinfo' are now in 'kernel/sys.c'.
>>
>> Can we please remove these file references completely. They are going to be
>> stale sooner than later again and they really do not provide any value.
I actually refer to them a lot when locating syscall implementations,
which is how I found out that they were stale in the first place.
>
>+1
>
>Good idea!
>
>In the long run, I'd prefer to have a parsable format that can be used to
>generate both the header file and the stubs that we currently provide
>using SYSCALL_DEFINEx(), but before that I'd like the remaining two
>unistd.h files to be converted to syscall.tbl format (Nitesh is still working
>on that).
Sorry I didn't understand, is there anything I can do to follow up on this?
>
>      Arnd
