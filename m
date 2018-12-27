From: Florian Weimer <fw@deneb.enyo.de>
Subject: d_off field in struct dirent and 32-on-64 emulation
Date: Thu, 27 Dec 2018 18:18:19 +0100
Message-ID: <87bm56vqg4.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-98800-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, libc-alpha@sourceware.org, qemu-devel@nongnu.org, ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net, hpa@zytor.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

We have a bit of an interesting problem with respect to the d_off
field in struct dirent.

When running a 64-bit kernel on certain file systems, notably ext4,
this field uses the full 63 bits even for small directories (strace -v
output, wrapped here for readability):

getdents(3, [
  {d_ino=1494304, d_off=3901177228673045825, d_reclen=40, d_name="authorized_keys", d_type=DT_REG},
  {d_ino=1494277, d_off=7491915799041650922, d_reclen=24, d_name=".", d_type=DT_DIR},
  {d_ino=1314655, d_off=9223372036854775807, d_reclen=24, d_name="..", d_type=DT_DIR}
], 32768) = 88

When running in 32-bit compat mode, this value is somehow truncated to
31 bits, for both the getdents and the getdents64 (!) system call (at
least on i386).

In an effort to simplify support for future architectures which only
have the getdents64 system call, we changed glibc 2.28 to use the
getdents64 system call unconditionally, and perform translation if
necessary.  This translation is noteworthy because it includes
overflow checking for the d_ino and d_off members of struct dirent.
We did not initially observe a regression because the kernel performs
consistent d_off truncation (with the ext4 file system; small
directories do not show this issue on XFS), so the overflow check does
not fire.

However, both qemu-user and the 9p file system can run in such a way
that the kernel is entered from a 64-bit process, but the actual usage
is from a 32-bit process:

  <https://sourceware.org/bugzilla/show_bug.cgi?id=23960>

I think diagrammatically, this looks like this:

  guest process  (32-bit)
    | getdents64, 32-bit UAPI
  qemu-user (64-bit)
    | getdents, 64-bit UAPI
  host kernel (64-bit)

Or:

  guest process 
    | getdents64, 32-bit UAPI
  guest kernel (64-bit)
    | 9p over virtio (64-bit d_off in struct p9_dirent)
  qemu
    | getdents, 64-bit UAPI
  host kernel (64-bit)

Back when we still called getdents, in the first case, the 32-bit
getdents system call emulation in a 64-bit qemu-user process would
just silently truncate the d_off field as part of the translation, not
reporting an error.  The second case is more complicated, and I have
not figured out where the truncation happens.

This truncation has always been a bug; it breaks telldir/seekdir at
least in some cases.  But use of telldir/seekdir is comparatively
rare.  In contrast, now that we detect d_off overflow in glibc,
readdir will always fail in the sketched configurations, which is bad.
(glibc exposes the d_off field to applications, and it cannot know
whether the application will use it or not, so there is no direct way
to restrict the overflow error to the telldir/seekdir use case.)

We could switch glibc to call getdents again if the system call is
available.  But that merely relies on the existence of the truncation
bug somewhere else in the file system stack.  This is why I don't
think it's the right solution, just the path of least resistance.

I don't want to reimplement the ext4 truncation behavior in glibc (it
doesn't look like a straightforward truncation), and it wouldn't work
for the second scenario where we see the 9p file system in the 32-bit
glibc, not the ext4 file system.  So that's not a good solution.

There is another annoying aspect: The standards expose d_off through
the telldir function, and that returns long int on all architectures
(not off_t, so unchanged by _FILE_OFFSET_BITS).  That's mostly a
userspace issue and thus needing different steps to resolve (possibly
standards action).

Any suggestions how to solve this?  Why does the kernel return
different d_off values for 32-bit and 64-bit processes even when using
getdents64, for the same directory?
