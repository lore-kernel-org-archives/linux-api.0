From: Palmer Dabbelt <palmer@sifive.com>
Subject: Re: [PATCH 2/5] Add fchmodat4(), a new syscall
Date: Fri, 31 May 2019 16:36:41 -0700 (PDT)
Message-ID: <mhng-234d2802-9483-43be-af69-5bd04721b932@palmer-si-x1e>
References: <CAK8P3a3HPeVq29k3Zk5rSk4bddiUQFrdEgDZUgdNnYZK+8QpGw@mail.gmail.com>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3HPeVq29k3Zk5rSk4bddiUQFrdEgDZUgdNnYZK+8QpGw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
List-Id: linux-api@vger.kernel.org

On Fri, 31 May 2019 12:51:00 PDT (-0700), Arnd Bergmann wrote:
> On Fri, May 31, 2019 at 9:23 PM Palmer Dabbelt <palmer@sifive.com> wrote:
>>
>> man 3p says that fchmodat() takes a flags argument, but the Linux
>> syscall does not.  There doesn't appear to be a good userspace
>> workaround for this issue but the implementation in the kernel is pretty
>> straight-forward.  The specific use case where the missing flags came up
>> was WRT a fuse filesystem implemenation, but the functionality is pretty
>> generic so I'm assuming there would be other use cases.
>>
>> Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
>> ---
>>  fs/open.c                | 21 +++++++++++++++++++--
>>  include/linux/syscalls.h |  5 +++++
>>  2 files changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/open.c b/fs/open.c
>> index a00350018a47..cfad7684e8d3 100644
>> --- a/fs/open.c
>> +++ b/fs/open.c
>> @@ -568,11 +568,17 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
>>         return ksys_fchmod(fd, mode);
>>  }
>>
>> -int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
>> +int do_fchmodat4(int dfd, const char __user *filename, umode_t mode, int flags)
> ...
>> +
>> +int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
>> +{
>> +       return do_fchmodat4(dfd, filename, mode, 0);
>> +}
>> +
>
> There is only one external caller of do_fchmodat(), so just change that
> to pass the extra argument here, and keep a single do_fchmodat()
> function used by the sys_fchmod(), sys_fchmod4(), sys_chmod()
> and ksys_chmod().

OK, I'll roll that up into a v2.
