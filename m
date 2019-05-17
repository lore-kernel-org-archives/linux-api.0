From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 0/2] initramfs: add support for xattrs in the initial ram disk
Date: Fri, 17 May 2019 18:55:17 +0200
Message-ID: <20190517165519.11507-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, hpa@zytor.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com, niveditas98@gmail.com, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: linux-api@vger.kernel.org

This patch set aims at solving the following use case: appraise files from
the initial ram disk. To do that, IMA checks the signature/hash from the
security.ima xattr. Unfortunately, this use case cannot be implemented
currently, as the CPIO format does not support xattrs.

This proposal consists in marshaling pathnames and xattrs in a file called
.xattr-list. They are unmarshaled by the CPIO parser after all files have
been extracted, or before the next ram disk is processed.

The difference from v1 (https://lkml.org/lkml/2018/11/22/1182) is that all
xattrs are stored in a single file and not per file (solves the file name
limitation issue, as it is not necessary to add a suffix to files
containing xattrs).

The difference with another proposal
(https://lore.kernel.org/patchwork/cover/888071/) is that xattrs can be
included in an image without changing the image format, as opposed to
defining a new one. As seen from the discussion, if a new format has to be
defined, it should fix the issues of the existing format, which requires
more time.

To fulfill both requirements, adding support for xattrs in a short time and
defining a new image format properly, this patch set takes an incremental
approach: it introduces a parser of xattrs that can be used either if
xattrs are in a regular file or directly added to the image (this patch set
reuses patch 9/15 of the existing proposal); in addition, it introduces a
wrapper of the xattr parser, to read xattrs from a file.

The changes introduced by this patch set don't cause any compatibility
issue: kernels without the xattr parser simply extracts .xattr-list and
don't unmarshal xattrs; kernels with the xattr parser don't unmarshal
xattrs if .xattr-list is not found in the image.

>From the kernel space perspective, backporting this functionality to older
kernels should be very easy. It is sufficient to add two calls to the new
function do_readxattrs(). From the user space perspective, no change is
required for the use case. A new dracut module (module-setup.sh) will
execute:

getfattr --absolute-names -d -h -R -e hex -m security.ima \
    <file list> | xattr.awk -b > ${initdir}/.xattr-list

where xattr.awk is the script that marshals xattrs (see patch 3/3). The
same can be done with the initramfs-tools ram disk generator.

Changelog

v2:
- replace ksys_lsetxattr() with kern_path() and vfs_setxattr()
  (suggested by Jann Horn)
- replace ksys_open()/ksys_read()/ksys_close() with
  filp_open()/kernel_read()/fput()
  (suggested by Jann Horn)
- use path variable instead of name_buf in do_readxattrs()
- set last byte of str to 0 in do_readxattrs()
- call do_readxattrs() in do_name() before replacing an existing
  .xattr-list
- pass pathname to do_setxattrs()


Mimi Zohar (1):
  initramfs: set extended attributes

Roberto Sassu (1):
  initramfs: introduce do_readxattrs()

 init/initramfs.c | 170 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 168 insertions(+), 2 deletions(-)

-- 
2.17.1
