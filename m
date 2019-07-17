From: Palmer Dabbelt <palmer@sifive.com>
Subject: Add a new fchmodat4() syscall, v2
Date: Tue, 16 Jul 2019 18:27:15 -0700
Message-ID: <20190717012719.5524-1-palmer@sifive.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org, James.Bottomley@HansenPartnership.com, deller@gmx.de, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, peterz@infradead.org, acme@kernel.org, alexander.shishkin@linux.intel.com, jolsa@redhat.com, namhyung@kernel.org, Palmer Dabbelt <palm>
List-Id: linux-api@vger.kernel.org

This patch set adds fchmodat4(), a new syscall. The actual
implementation is super simple: essentially it's just the same as
fchmodat(), but LOOKUP_FOLLOW is conditionally set based on the flags.
I've attempted to make this match "man 2 fchmodat" as closely as
possible, which says EINVAL is returned for invalid flags (as opposed to
ENOTSUPP, which is currently returned by glibc for AT_SYMLINK_NOFOLLOW).
I have a sketch of a glibc patch that I haven't even compiled yet, but
seems fairly straight-forward:

    diff --git a/sysdeps/unix/sysv/linux/fchmodat.c b/sysdeps/unix/sysv/linux/fchmodat.c
    index 6d9cbc1ce9e0..b1beab76d56c 100644
    --- a/sysdeps/unix/sysv/linux/fchmodat.c
    +++ b/sysdeps/unix/sysv/linux/fchmodat.c
    @@ -29,12 +29,36 @@
     int
     fchmodat (int fd, const char *file, mode_t mode, int flag)
     {
    -  if (flag & ~AT_SYMLINK_NOFOLLOW)
    -    return INLINE_SYSCALL_ERROR_RETURN_VALUE (EINVAL);
    -#ifndef __NR_lchmod		/* Linux so far has no lchmod syscall.  */
    +  /* There are four paths through this code:
    +      - The flags are zero.  In this case it's fine to call fchmodat.
    +      - The flags are non-zero and glibc doesn't have access to
    +	__NR_fchmodat4.  In this case all we can do is emulate the error codes
    +	defined by the glibc interface from userspace.
    +      - The flags are non-zero, glibc has __NR_fchmodat4, and the kernel has
    +	fchmodat4.  This is the simplest case, as the fchmodat4 syscall exactly
    +	matches glibc's library interface so it can be called directly.
    +      - The flags are non-zero, glibc has __NR_fchmodat4, but the kernel does
    +	not.  In this case we must respect the error codes defined by the glibc
    +	interface instead of returning ENOSYS.
    +    The intent here is to ensure that the kernel is called at most once per
    +    library call, and that the error types defined by glibc are always
    +    respected.  */
    +
    +#ifdef __NR_fchmodat4
    +  long result;
    +#endif
    +
    +  if (flag == 0)
    +    return INLINE_SYSCALL (fchmodat, 3, fd, file, mode);
    +
    +#ifdef __NR_fchmodat4
    +  result = INLINE_SYSCALL (fchmodat4, 4, fd, file, mode, flag);
    +  if (result == 0 || errno != ENOSYS)
    +    return result;
    +#endif
    +
       if (flag & AT_SYMLINK_NOFOLLOW)
         return INLINE_SYSCALL_ERROR_RETURN_VALUE (ENOTSUP);
    -#endif

    -  return INLINE_SYSCALL (fchmodat, 3, fd, file, mode);
    +  return INLINE_SYSCALL_ERROR_RETURN_VALUE (EINVAL);
     }

I've never added a new syscall before so I'm not really sure what the
proper procedure to follow is.  Based on the feedback from my v1 patch
set it seems this is somewhat uncontroversial.  At this point I don't
think there's anything I'm missing, though note that I haven't gotten
around to testing it this time because the diff from v1 is trivial for
any platform I could reasonably test on.  The v1 patches suggest a
simple test case, but I didn't re-run it because I don't want to reboot
my laptop.

    $ touch test-file
    $ ln -s test-file test-link
    $ cat > test.c
    #include <fcntl.h>
    #include <stdio.h>
    #include <unistd.h>

    int main(int argc, char **argv)
    {
            long out;

            out = syscall(434, AT_FDCWD, "test-file", 0x888, AT_SYMLINK_NOFOLLOW);
            printf("fchmodat4(AT_FDCWD, \"test-file\", 0x888, AT_SYMLINK_NOFOLLOW): %ld\n", out);

            out = syscall(434, AT_FDCWD, "test-file", 0x888, 0);
            printf("fchmodat4(AT_FDCWD, \"test-file\", 0x888, 0): %ld\n", out);

            out = syscall(268, AT_FDCWD, "test-file", 0x888);
            printf("fchmodat(AT_FDCWD, \"test-file\", 0x888): %ld\n", out);

            out = syscall(434, AT_FDCWD, "test-link", 0x888, AT_SYMLINK_NOFOLLOW);
            printf("fchmodat4(AT_FDCWD, \"test-link\", 0x888, AT_SYMLINK_NOFOLLOW): %ld\n", out);

            out = syscall(434, AT_FDCWD, "test-link", 0x888, 0);
            printf("fchmodat4(AT_FDCWD, \"test-link\", 0x888, 0): %ld\n", out);

            out = syscall(268, AT_FDCWD, "test-link", 0x888);
            printf("fchmodat(AT_FDCWD, \"test-link\", 0x888): %ld\n", out);

            return 0;
    }
    $ gcc test.c -o test
    $ ./test
    fchmodat4(AT_FDCWD, "test-file", 0x888, AT_SYMLINK_NOFOLLOW): 0
    fchmodat4(AT_FDCWD, "test-file", 0x888, 0): 0
    fchmodat(AT_FDCWD, "test-file", 0x888): 0
    fchmodat4(AT_FDCWD, "test-link", 0x888, AT_SYMLINK_NOFOLLOW): -1
    fchmodat4(AT_FDCWD, "test-link", 0x888, 0): 0
    fchmodat(AT_FDCWD, "test-link", 0x888): 0

I've only built this on 64-bit x86.

Changes since v1 [20190531191204.4044-1-palmer@sifive.com]:

* All architectures are now supported, which support squashed into a
  single patch.
* The do_fchmodat() helper function has been removed, in favor of directly
  calling do_fchmodat4().
* The patches are based on 5.2 instead of 5.1.
