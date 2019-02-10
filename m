From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v4 0/3]  sysctl: handle overflow for file-max
Date: Sun, 10 Feb 2019 21:39:40 +0100
Message-ID: <20190210203943.8227-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, mcgrof@kernel.org, joe.lawrence@redhat.com, longman@redhat.com, linux@dominikbrodowski.net, viro@zeniv.linux.org.uk, adobriyan@gmail.com, linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Hey Andrew,

You currently carry 
* sysctl-handle-overflow-in-proc_get_long.patch
* sysctl-handle-overflow-for-file-max.patch
in your http://www.ozlabs.org/~akpm/mmotm/ tree.

I recently pointed out that the current change can potentially lead to a
userspace facing change and asked you to please drop the second patch
(cf. [3]).
I think you might have missed that mail. This is the same patchset just
that the userspace facing change is split out into a separate commit.
Please take the first two commits as they fix the issue without any
userspace facing change. The third one is marked as RFC and we can
either take it now or punt on it until later.

Currently, when writing

echo 18446744073709551616 > /proc/sys/fs/file-max

/proc/sys/fs/file-max will overflow and be set to 0. That quickly
crashes the system.

The first version of this patch intended to detect the overflow and cap
at ULONG_MAX. However, we should not do this and rather return EINVAL on
overflow. The reasons are:
- this aligns with other sysctl handlers that simply reject overflows
  (cf. [1], [2], and a bunch of others)
- we already do a partial fail on overflow right now
  Namely, when the TMPBUFLEN is exceeded. So we already reject values
  such as 184467440737095516160 (21 chars) but accept values such as
  18446744073709551616 (20 chars) but both are overflows. So we should
  just always reject 64bit overflows and not special-case this based on
  the number of chars.

(This patchset is in reference to https://lkml.org/lkml/2018/10/11/585.)

Thanks!
Christian

[1]: fb910c42cceb ("sysctl: check for UINT_MAX before unsigned int min/max")
[2]: 196851bed522 ("s390/topology: correct topology mode proc handler")
[3]: https://lore.kernel.org/lkml/20190111145140.lbmiz3w2f255uf65@brauner.io/ 

Christian Brauner (3):
  sysctl: handle overflow in proc_get_long
  sysctl: handle overflow for file-max
  sysctl: return -EINVAL if val violates minmax

 kernel/sysctl.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

-- 
2.20.1
