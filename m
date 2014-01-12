From: Rich Felker <dalias@aerifal.cx>
Subject: Deficiencies in kernel/compat.c for x32 timespec
Date: Sat, 11 Jan 2014 20:42:34 -0500
Message-ID: <20140112014234.GA27914@brightrain.aerifal.cx>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <musl-return-4476-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
Content-Disposition: inline
To: linux-api@vger.kernel.org
Cc: musl@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Hi,

We're working on adding x32 support in musl libc, and ran into a
pretty major obstacle that the glibc folks seem to have glossed over:
when the kernel reads timespec structures from x32 userspace, it
treats both tv_sec and tv_nsec as 64-bit values. This requires
userspace either to be non-conforming to ISO C11 and POSIX (both of
which require tv_nsec to have type long, not an implementation-defined
signed integer type) or to wrap syscalls with ugly x32-specific
wrappers to copy the input timespec to a temporary location where it
can be sign-extended to 64-bit for passing to the kernel.

glibc has (so far) taken the former approach, documented in this bug
report: https://sourceware.org/bugzilla/show_bug.cgi?id=16437

I'd like to see this fixed on the kernel side by having
kernel/compat.c modified to copy tv_sec and tv_nsec copied separately
as 64-bit and 32-bit values, respectively, rather than using
copy_from_user for the whole structure, when COMPAT_USE_64BIT_TIME is
true.

Note that copy_to_user still works for writing timespec results back
to userspace; the excess data just goes into padding bits, and it's
always necessarily zero because output tv_nsec values are never
outside the range [0,999999999].

Rich
