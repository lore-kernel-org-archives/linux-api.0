From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v3 0/2] sysctl: handle overflow for file-max
Date: Wed, 17 Oct 2018 00:33:20 +0200
Message-ID: <20181016223322.16844-1-christian@brauner.io>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, mcgrof@kernel.org, akpm@linux-foundation.org, joe.lawrence@redhat.com, longman@redhat.com, linux@dominikbrodowski.net, viro@zeniv.linux.org.uk, adobriyan@gmail.com, linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

Hey,

Here is v3 of this patchset. Changelogs are in the individual commits.

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

Christian Brauner (2):
  sysctl: handle overflow in proc_get_long
  sysctl: handle overflow for file-max

 kernel/sysctl.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

-- 
2.17.1
