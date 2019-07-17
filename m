From: Palmer Dabbelt <palmer@sifive.com>
Subject: Re: [PATCH v2 2/4] Add fchmodat4(), a new syscall
Date: Tue, 16 Jul 2019 19:12:31 -0700 (PDT)
Message-ID: <mhng-07134298-232b-4472-ac6f-cf33862883c5@palmer-si-x1e>
References: <20190717014802.GS17978@ZenIV.linux.org.uk>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190717014802.GS17978@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org, James.Bottomley@hansenpartnership.com, deller@gmx.de, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, peterz@infradead.org, acme@kernel.org, alexand
List-Id: linux-api@vger.kernel.org

On Tue, 16 Jul 2019 18:48:02 PDT (-0700), viro@zeniv.linux.org.uk wrote:
> On Tue, Jul 16, 2019 at 06:27:17PM -0700, Palmer Dabbelt wrote:
>
>> -int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
>> +int do_fchmodat4(int dfd, const char __user *filename, umode_t mode, int flags)
>>  {
>>  	struct path path;
>>  	int error;
>> -	unsigned int lookup_flags = LOOKUP_FOLLOW;
>> +	unsigned int lookup_flags;
>> +
>> +	if (unlikely(flags & ~AT_SYMLINK_NOFOLLOW))
>> +		return -EINVAL;
>> +
>> +	lookup_flags = flags & AT_SYMLINK_NOFOLLOW ? 0 : LOOKUP_FOLLOW;
>> +
>
> 	Why not do that in sys_fchmodat4() itself, passing lookup_flags to
> do_fchmodat() and updating old callers to pass it 0 as extra argument?

Ya, that seems better -- passing LOOKUP_FOLLOW instead of 0, to keep the
behavior the same.  That way I could avoid the overhead of these checks for the
old syscalls, as we know they're not necessary.

I'll replace this patch with the following for a v3

    diff --git a/fs/open.c b/fs/open.c
    index b5b80469b93d..a5f99408af11 100644
    --- a/fs/open.c
    +++ b/fs/open.c
    @@ -569,11 +569,12 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
            return ksys_fchmod(fd, mode);
     }
    
    -int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
    +int do_fchmodat4(int dfd, const char __user *filename, umode_t mode,
    +                int lookup_flags)
     {
            struct path path;
            int error;
    -       unsigned int lookup_flags = LOOKUP_FOLLOW;
    +
     retry:
            error = user_path_at(dfd, filename, lookup_flags, &path);
            if (!error) {
    @@ -587,15 +588,28 @@ int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
            return error;
     }
    
    +SYSCALL_DEFINE4(fchmodat4, int, dfd, const char __user *, filename,
    +               umode_t, mode, int, flags)
    +{
    +       unsigned int lookup_flags;
    +
    +       if (unlikely(flags & ~AT_SYMLINK_NOFOLLOW))
    +               return -EINVAL;
    +
    +       lookup_flags = flags & AT_SYMLINK_NOFOLLOW ? 0 : LOOKUP_FOLLOW;
    +
    +       return do_fchmodat4(dfd, filename, mode, lookup_flags);
    +}
    +
     SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename,
                    umode_t, mode)
     {
    -       return do_fchmodat(dfd, filename, mode);
    +       return do_fchmodat4(dfd, filename, mode, LOOKUP_FOLLOW);
     }
    
     SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
     {
    -       return do_fchmodat(AT_FDCWD, filename, mode);
    +       return do_fchmodat4(AT_FDCWD, filename, mode, LOOKUP_FOLLOW);
     }
    
     static int chown_common(const struct path *path, uid_t user, gid_t group)
    diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
    index e1c20f1d0525..6676b1cc5485 100644
    --- a/include/linux/syscalls.h
    +++ b/include/linux/syscalls.h
    @@ -81,6 +81,7 @@ struct io_uring_params;
     #include <linux/quota.h>
     #include <linux/key.h>
     #include <linux/personality.h>
    +#include <linux/namei.h>
     #include <trace/syscall.h>
    
     #ifdef CONFIG_ARCH_HAS_SYSCALL_WRAPPER
    @@ -433,6 +434,8 @@ asmlinkage long sys_chroot(const char __user *filename);
     asmlinkage long sys_fchmod(unsigned int fd, umode_t mode);
     asmlinkage long sys_fchmodat(int dfd, const char __user *filename,
                                 umode_t mode);
    +asmlinkage long sys_fchmodat4(int dfd, const char __user *filename,
    +                            umode_t mode, int flags);
     asmlinkage long sys_fchownat(int dfd, const char __user *filename, uid_t user,
                                 gid_t group, int flag);
     asmlinkage long sys_fchown(unsigned int fd, uid_t user, gid_t group);
    @@ -1320,11 +1323,12 @@ static inline long ksys_link(const char __user *oldname,
            return do_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
     }
    
    -extern int do_fchmodat(int dfd, const char __user *filename, umode_t mode);
    +extern int do_fchmodat4(int dfd, const char __user *filename, umode_t mode,
    +                       int flags);
    
     static inline int ksys_chmod(const char __user *filename, umode_t mode)
     {
    -       return do_fchmodat(AT_FDCWD, filename, mode);
    +       return do_fchmodat4(AT_FDCWD, filename, mode, LOOKUP_FOLLOW);
     }
    
     extern long do_faccessat(int dfd, const char __user *filename, int mode);
