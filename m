From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 06/17] y2038: Change sys_utimensat() to use __kernel_timespec
Date: Tue, 17 Jul 2018 16:27:26 +0200
Message-ID: <CAK8P3a2eQJMDUpB7FdXYDm9LDD2puLCcW-XShBhhccsm9bbYrw@mail.gmail.com>
References: <20180716161103.16239-1-arnd@arndb.de> <20180716161103.16239-7-arnd@arndb.de>
 <20180717125243.GE25416@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180717125243.GE25416@infradead.org>
Sender: netdev-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, GNU C Library <libc-alpha@sourceware.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, Networking <netdev@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 17, 2018 at 2:52 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jul 16, 2018 at 06:10:52PM +0200, Arnd Bergmann wrote:
>> When 32-bit architectures get changed to support 64-bit time_t,
>> utimensat() needs to use the new __kernel_timespec structure as its
>> argument.
>>
>> The older utime(), utimes() and futimesat() system calls don't need a
>> corresponding change as they are no longer used on C libraries that have
>> 64-bit time support.
>>
>> As we do for the other syscalls that have timespec arguments, we reuse
>> the 'compat' syscall entry points to implement the traditional four
>> interfaces, and only leave the new utimensat() as a native handler,
>> so that the same code gets used on both 32-bit and 64-bit kernels
>> on each syscall.
>
> I wonder about the direction here:  wouldn't it be easier to just
> leave th existing syscall names as-is and introduce a new utimesat64
> which uses the new timespec?  We can then drop the old legacy utimesat
> for new architectures added after the cutover.

We have debated both approaches over several years, but for
most syscalls, we picked the approach described above, for multiple
reasons:

- For any system call that takes a time_t derived argument, we
  already have two implementations (native and compat), so adding a
  third one requires duplicating some code.

- I want to avoid adding an implementation that is not well tested
  if possible, to make it less likely to introduce security holes or
  subtle bugs that we can't fix later without breaking the ABI.
  Using the same implementation for the new 32-bit case that
  we have for the existing 64-bit case means that this code is
  much better exercised, while reusing the compat code for the
  traditional native syscall means it gets exercised by all current
  user space, which makes it more likely to catch bugs early.

- Looking at the end result, I find it more logical to have each
  of the converted syscalls implement the same binary interface
  on both 32-bit and 64-bit architectures with the same code,
  and have the old 32-bit implementation be similarly shared.
  This is even more important once we add new architectures
  that don't even provide the 32-bit time_t interfaces and just
  leave out the old entry points.

    Arnd
