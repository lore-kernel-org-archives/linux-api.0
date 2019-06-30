From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v4 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Sun, 30 Jun 2019 11:39:59 -0400
Message-ID: <1561909199.3985.33.camel@linux.ibm.com>
References: <20190523121803.21638-1-roberto.sassu@huawei.com>
         <cf9d08ca-74c7-c945-5bf9-7c3495907d1e@huawei.com>
         <541e9ea1-024f-5c22-0b58-f8692e6c1eb1@landley.net>
         <33cfb804-6a17-39f0-92b7-01d54e9c452d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <33cfb804-6a17-39f0-92b7-01d54e9c452d@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>, Rob Landley <rob@landley.net>, viro@zeniv.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, bug-cpio@gnu.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, hpa@zytor.com, arnd@arndb.de, james.w.mcmechan@gmail.com, niveditas98@gmail.com
List-Id: linux-api@vger.kernel.org

On Wed, 2019-06-26 at 10:15 +0200, Roberto Sassu wrote:
> On 6/3/2019 8:32 PM, Rob Landley wrote:
> > On 6/3/19 4:31 AM, Roberto Sassu wrote:
> >>> This patch set aims at solving the following use case: appraise files from
> >>> the initial ram disk. To do that, IMA checks the signature/hash from the
> >>> security.ima xattr. Unfortunately, this use case cannot be implemented
> >>> currently, as the CPIO format does not support xattrs.
> >>>
> >>> This proposal consists in including file metadata as additional files named
> >>> METADATA!!!, for each file added to the ram disk. The CPIO parser in the
> >>> kernel recognizes these special files from the file name, and calls the
> >>> appropriate parser to add metadata to the previously extracted file. It has
> >>> been proposed to use bit 17:16 of the file mode as a way to recognize files
> >>> with metadata, but both the kernel and the cpio tool declare the file mode
> >>> as unsigned short.
> >>
> >> Any opinion on this patch set?
> >>
> >> Thanks
> >>
> >> Roberto
> > 
> > Sorry, I've had the window open since you posted it but haven't gotten around to
> > it. I'll try to build it later today.
> > 
> > It does look interesting, and I have no objections to the basic approach. I
> > should be able to add support to toybox cpio over a weekend once I've got the
> > kernel doing it to test against.
> 
> Ok.
> 
> Let me give some instructions so that people can test this patch set.
> 
> To add xattrs to the ram disk embedded in the kernel it is sufficient
> to set CONFIG_INITRAMFS_FILE_METADATA="xattr" and
> CONFIG_INITRAMFS_SOURCE="<file with xattr>" in the kernel configuration.
> 
> To add xattrs to the external ram disk, it is necessary to patch cpio:
> 
> https://github.com/euleros/cpio/commit/531cabc88e9ecdc3231fad6e4856869baa9a91ef 
> (xattr-v1 branch)
> 
> and dracut:
> 
> https://github.com/euleros/dracut/commit/a2dee56ea80495c2c1871bc73186f7b00dc8bf3b 
> (digest-lists branch)
> 
> The same modification can be done for mkinitramfs (add '-e xattr' to the
> cpio command line).
> 
> To simplify the test, it would be sufficient to replace only the cpio
> binary and the dracut script with the modified versions. For dracut, the
> patch should be applied to the local dracut (after it has been renamed
> to dracut.sh).
> 
> Then, run:
> 
> dracut -e xattr -I <file with xattr> (add -f to overwrite the ram disk)
> 
> Xattrs can be seen by stopping the boot process for example by adding
> rd.break to the kernel command line.

A simple way of testing, without needing any changes other than the
kernel patches, is to save the dracut temporary directory by supplying
"--keep" on the dracut command line, calling
usr/gen_initramfs_list.sh, followed by usr/gen_init_cpio with the "-e
xattr" option.

If your filesystem already has and copied the security xattrs to the
dracut temporary directory, the script, below, will include them in
the initramfs file.  Otherwise, you'll need to write the desired
security xattrs on the files, using setfattr, in the temporary dracut
directory, before creating the initramfs.

Remember to make sure that the initramfs_list includes "getfattr",
otherwise you'll need to wait until real root is mounted as /sysroot
to see the security xattrs for the rootfs files.

The following script has not been tested on a recent version of
dracut.  Some changes might be needed, as well as some code cleanup.

#!/bin/bash

initramfs_name=/boot/initramfs-`uname -r`.img
initramfs_output_name=${initramfs_name/.img/.test.img}

if [ $# -eq 1 ]; then
        initramfs_name=$1
fi

if [ ! -f "$initramfs_name" ]; then
        echo "Usage; $0 <initramfs pathanem>"
        exit 1
fi

tmp=$(dracut -H -f "$initramfs_name" --keep --noprelink --nostrip 2>&1)
suffix=$(echo $tmp | cut -d ' ' -f 3 | cut -d '.' -f 2)

tmpdir="/var/tmp/dracut.$suffix/initramfs"

if [ ! -d "$tmpdir" ]; then
        echo "$tmpdir does not exist"
        exit 1
fi

usr/gen_initramfs_list.sh ${tmpdir} > usr/initramfs_list
usr/gen_init_cpio -e xattr usr/initramfs_list > usr/initramfs_data.cpio
gzip usr/initramfs_data.cpio

echo "Copying usr/initramfs_data.cpio to $initramfs_output_name"
cp usr/initramfs_data.cpio.gz "$initramfs_output_name"

Mimi
