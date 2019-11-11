From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 23/23] y2038: allow disabling time32 system calls
Date: Mon, 11 Nov 2019 13:31:18 +0100
Message-ID: <20191111123116.upuqpdetbxdmfp3i@wittgenstein>
References: <20191108210236.1296047-1-arnd@arndb.de>
 <20191108211323.1806194-14-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191108211323.1806194-14-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Christian Brauner <christian@brauner.io>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 08, 2019 at 10:12:22PM +0100, Arnd Bergmann wrote:
> At the moment, the compilation of the old time32 system calls depends
> purely on the architecture. As systems with new libc based on 64-bit
> time_t are getting deployed, even architectures that previously supported
> these (notably x86-32 and arm32 but also many others) no longer depend on
> them, and removing them from a kernel image results in a smaller kernel
> binary, the same way we can leave out many other optional system calls.
> 
> More importantly, on an embedded system that needs to keep working
> beyond year 2038, any user space program calling these system calls
> is likely a bug, so removing them from the kernel image does provide
> an extra debugging help for finding broken applications.
> 
> I've gone back and forth on hiding this option unless CONFIG_EXPERT
> is set. This version leaves it visible based on the logic that
> eventually it will be turned off indefinitely.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
