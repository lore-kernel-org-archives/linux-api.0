From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: utimensat EACCES vs. EPERM in 4.8+
Date: Tue, 17 Jan 2017 13:04:38 +1300
Message-ID: <CAKgNAkjTkBMY0wrj3wsH39YF=bHp=8mbYrXkSPzn0X4ezfso1w@mail.gmail.com>
References: <18a5b416-ad6a-e679-d993-af7ffa0dcc10@redhat.com> <CAOssrKfb1-C8c=9bAPiairh+Lyf=w28r+RjSXTLQcQZ-=eWMRA@mail.gmail.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOssrKfb1-C8c=9bAPiairh+Lyf=w28r+RjSXTLQcQZ-=eWMRA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Jan Stancek <jstancek@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, viro <viro@zeniv.linux.org.uk>, guaneryu@gmail.com, Cyril Hrubis <chrubis@suse.cz>, ltp@lists.linux.it, Linux API <linux-api@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>
List-Id: linux-api@vger.kernel.org

[CC += linux-api + Dave Chinner]

On 17 January 2017 at 04:53, Miklos Szeredi <mszeredi@redhat.com> wrote:
> On Mon, Jan 16, 2017 at 4:46 PM, Jan Stancek <jstancek@redhat.com> wrote:
>> Hi,
>>
>> we seem to have a conflict between kernel and man pages.

Jan, thanks for spotting this.

>> From utimensat man page:
>>
>> EACCES times is NULL, or both tv_nsec values are UTIME_NOW, and either:
>>        *  the effective user ID of the caller does not match the owner of the
>>           file, the caller does not  have  write  access  to  the file, and the
>>           caller is not privileged (Linux: does not have either the CAP_FOWNER
>>           or the CAP_DAC_OVERRIDE capability); or,
>>        *  the file is marked immutable (see chattr(1)).
>>
>> But following 2 commits gradually replaced EACCES with EPERM.
>>
>> commit 337684a1746f93ae107e05d90977b070bb7e39d8
>> Author: Eryu Guan <guaneryu@gmail.com>
>> Date:   Tue Aug 2 19:58:28 2016 +0800
>>     fs: return EPERM on immutable inode
>
> I agree with Eryu that consistently returning EPERM for immutable is
> better than sometimes returning EACCESS and sometimes EPERM.

I'm not so sure about that. In Eryu's patch (which *really, really*
should have CCed linux-api@, and it would be kind if subsystem
maintainers reminded patch submitters about that), there was this
change:

[[
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -402,23 +402,23 @@ static inline int do_inode_permission(struct
inode *inode, int mask)
  * inode_permission().
  */
 int __inode_permission(struct inode *inode, int mask)
 {
        int retval;

        if (unlikely(mask & MAY_WRITE)) {
                /*
                 * Nobody gets write access to an immutable file.
                 */
                if (IS_IMMUTABLE(inode))
-                       return -EACCES;
+                       return -EPERM;

                /*
                 * Updating mtime will likely cause i_uid and i_gid to be
                 * written back improperly if their true value is unknown
                 * to the vfs.
                 */
                if (HAS_UNMAPPED_ID(inode))
                        return -EACCES;
        }

        retval = do_inode_permission(inode, mask);
]]

[1] The effects of that change are pretty wide ranging, affecting
open(2)/openat(2) (of an existing file for writing),
access(2)/faccessat(2) (W_OK), and [f]truncate(2). In addition, there
is the observed change (from another part of the patch) in
utimensat(2) (and friends). Those cases formerly gave EACCES for
immutable files, now they give EPERM.

[2] By contrast, the following always gave EPERM: fallocate(2),
setxattr(2), unlink(2), link(2) [in certain cases], chown(2),
chmod(2), and some per-filesystem cases of operations such as
truncate.

> So I think the man page should be fixed.

I agree that the inconsistency in the error return for immutable files
is unfortunate. But, consider the following:

* Although the set of calls in [1] is shorter, they (in particular,
  open(2)) are probably much more commonly used than
  the system calls in [2]. (That is, Eryu's statement "In most cases,
  EPERM is returned on immutable inode" that accompanied the
  kernel patch isn't correct.)
* For access(W_OK), we introduced a new error (EPERM) that
  previously never previously occurred. If there are applications
  that use access() and check specific error returns, they'll be
  confused. (I acknowledge there may be few such applications.)
* We changed the carefully documented behavior of utimensat(2)
  (and friends). [Read the man page!]
* EACCES is the typical error for "file not writable" (because of file
  permissions or other reasons such as immutability). It's long
  been the behavior for open(O_WRONLY/O_RDWR) on immutable
  files; now that has changed.
* Now various man pages need to document two different (kernel
  version dependent) errors for immutable files (for the syscalls in [1],
  above), and applications may need to deal with those two errors.

Summary of the above list: there's a nontrivial risk that something in
userspace got broken. (And just because we didn't hear about it yet
doesn't mean it didn't happen; sometimes these reports only arrive
many months or even years later.)

So, (1) I'm struggling to see the rationale for this change (I don't
think "consistency" is enough) and (2) if "consistency" is the
argument then (because the set of system calls in [1] are more
frequently used than those in [2]), there's a reasonable argument that
the change should have gone the other way: changing all IS_IMMUTABLE
cases to fail with EACCES.

Summary: I think there's an argument for reverting the kernel patch.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
