From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 14/15] arch: add split IPC system calls where needed
Date: Mon, 14 Jan 2019 20:58:52 +1100
Message-ID: <87muo31rxf.fsf@concordia.ellerman.id.au>
References: <20190110162435.309262-1-arnd@arndb.de> <20190110162435.309262-15-arnd@arndb.de> <87pnsz28k2.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87pnsz28k2.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, firoz.khan@linaro.org, ebiederm@xmission.com, deepa.kernel@gmail.com, linux@dominikbrodowski.net, akpm@linux-foundation.org, dave@stgolabs.net, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.orgl
List-Id: linux-api@vger.kernel.org

Michael Ellerman <mpe@ellerman.id.au> writes:
> Hi Arnd,
>
> Arnd Bergmann <arnd@arndb.de> writes:
>> The IPC system call handling is highly inconsistent across architectures,
>> some use sys_ipc, some use separate calls, and some use both.  We also
>> have some architectures that require passing IPC_64 in the flags, and
>> others that set it implicitly.
...
>
> We already have a gap at 366-377 from when we tried to add the split IPC
> calls a few years back.
>
> I guess I don't mind leaving that gap and using the common numbers as
> you've done here.
>
> But it would be good to add a comment pointing out that we have room
> at 366 for more arch specific syscalls as well.
>
> cheers

Guess I sent that one twice. 🤦

cheers
