From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 01/17] y2038: asm-generic: Extend sysvipc data structures
Date: Thu, 19 Apr 2018 17:51:23 +0200
Message-ID: <CAK8P3a0psMUhA-wzNmTnrcgrhmHY=n-u9kp23aEKVQ9wxcf3zg@mail.gmail.com>
References: <20180419143737.606138-1-arnd@arndb.de> <20180419143737.606138-2-arnd@arndb.de>
 <CAKCAbMiaX31mpfEMRQrQbPO+kTfowA6=_KhBSs56=zZ1s0aXhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKCAbMiaX31mpfEMRQrQbPO+kTfowA6=_KhBSs56=zZ1s0aXhw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zack Weinberg <zackw@panix.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, GNU C Library <libc-alpha@sourceware.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 19, 2018 at 5:30 PM, Zack Weinberg <zackw@panix.com> wrote:
> On Thu, Apr 19, 2018 at 10:37 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> Most architectures now use the asm-generic copy of the sysvipc data
>> structures (msqid64_ds, semid64_ds, shmid64_ds), which use 32-bit
>> __kernel_time_t on 32-bit architectures but have padding behind them to
>> allow extending the type to 64-bit.
>>
>> Unfortunately, that fails on all big-endian architectures, which have the
>> padding on the wrong side. As so many of them get it wrong, we decided to
>> not bother even trying to fix it up when we introduced the asm-generic
>> copy. Instead we always use the padding word now to provide the upper
>> 32 bits of the seconds value, regardless of the endianess.
>>
>> A libc implementation on a typical big-endian system can deal with
>> this by providing its own copy of the structure definition to user
>> space, and swapping the two 32-bit words before returning from the
>> semctl/shmctl/msgctl system calls.
>
> This seems generally like a sound approach, but I need to ask whether
> any of the structures involved can ever appear in a sendmsg() control
> message (that is, in the data pointed to by msg_control), or an
> AF_NETLINK message, or any other situation where the kernel
> communicates a structured message of arbitrary size to user space or
> vice versa.  libc can't munge those messages, because new message
> types can be added faster than libc can keep up with them, and because
> I/O primitives like sendmsg() generally aren't allowed to allocate
> arbitrarily-large scratch buffers.

I'm fairly sure that the sysvipc data structures are entirely distinct from
the structures that get passed over sockets, so the question of socket
data is unrelated to this series and will be addressed in a separate
series.

To give some background on what needs to be done for sockets, the
only incompatibility I'm aware of are socket timestamps that
get enabled with SO_TIMESTAMP, SO_TIMESTAMPNS or
SO_TIMESTAMPING and get passed from kernel to user space
as SCM_TIMESTAMP/SCM_TIMESTAMPNS/SCM_TIMESTAMPING
cmsg data.

We already have code for handling 32-bit compat applications
on 64-bit kernels, but that cannot work for 32-bit applications
if the kernel has no idea whether the application uses 32-bit or
64-bit time_t, and we don't have a function like in_compat_syscall()
that we can use to find that out.

Our plan here is to change asm/socket.h to have three additional
timestamp flags that correspond to the existing SO_TIMESTAMP*
flags but signify that user space expects the new structure layout
(which is compatible with the existing layout on 64-bit kernels).
For each flag, the kernel then defines a wrapper that (on 32-bit
user space) looks like

#define SO_TIMESTAMP (sizeof(time_t) > sizeof(__kernel_long_t) ? \
             SO_TIMESTAMP_TIME64 : SO_TIMESTAMP_OLD)

Any application asking for SO_TIMESTAMP_OLD will get the
traditional behavior, while applications that are built with a
64-bit time_t will pass SO_TIMESTAMP_TIME64 into
setsockopts, causing the kernel to use the new behavior.
In 64-bit tasks, we probably want to define both to have existing
behavior even though one would never see the new macro.

         Arnd
