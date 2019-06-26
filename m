From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH v4 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Wed, 26 Jun 2019 10:15:10 +0200
Message-ID: <33cfb804-6a17-39f0-92b7-01d54e9c452d@huawei.com>
References: <20190523121803.21638-1-roberto.sassu@huawei.com>
 <cf9d08ca-74c7-c945-5bf9-7c3495907d1e@huawei.com>
 <541e9ea1-024f-5c22-0b58-f8692e6c1eb1@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <541e9ea1-024f-5c22-0b58-f8692e6c1eb1@landley.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>, viro@zeniv.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, bug-cpio@gnu.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, hpa@zytor.com, arnd@arndb.de, james.w.mcmechan@gmail.com, niveditas98@gmail.com
List-Id: linux-api@vger.kernel.org

On 6/3/2019 8:32 PM, Rob Landley wrote:
> On 6/3/19 4:31 AM, Roberto Sassu wrote:
>>> This patch set aims at solving the following use case: appraise files from
>>> the initial ram disk. To do that, IMA checks the signature/hash from the
>>> security.ima xattr. Unfortunately, this use case cannot be implemented
>>> currently, as the CPIO format does not support xattrs.
>>>
>>> This proposal consists in including file metadata as additional files named
>>> METADATA!!!, for each file added to the ram disk. The CPIO parser in the
>>> kernel recognizes these special files from the file name, and calls the
>>> appropriate parser to add metadata to the previously extracted file. It has
>>> been proposed to use bit 17:16 of the file mode as a way to recognize files
>>> with metadata, but both the kernel and the cpio tool declare the file mode
>>> as unsigned short.
>>
>> Any opinion on this patch set?
>>
>> Thanks
>>
>> Roberto
> 
> Sorry, I've had the window open since you posted it but haven't gotten around to
> it. I'll try to build it later today.
> 
> It does look interesting, and I have no objections to the basic approach. I
> should be able to add support to toybox cpio over a weekend once I've got the
> kernel doing it to test against.

Ok.

Let me give some instructions so that people can test this patch set.

To add xattrs to the ram disk embedded in the kernel it is sufficient
to set CONFIG_INITRAMFS_FILE_METADATA="xattr" and
CONFIG_INITRAMFS_SOURCE="<file with xattr>" in the kernel configuration.

To add xattrs to the external ram disk, it is necessary to patch cpio:

https://github.com/euleros/cpio/commit/531cabc88e9ecdc3231fad6e4856869baa9a91ef 
(xattr-v1 branch)

and dracut:

https://github.com/euleros/dracut/commit/a2dee56ea80495c2c1871bc73186f7b00dc8bf3b 
(digest-lists branch)

The same modification can be done for mkinitramfs (add '-e xattr' to the
cpio command line).

To simplify the test, it would be sufficient to replace only the cpio
binary and the dracut script with the modified versions. For dracut, the
patch should be applied to the local dracut (after it has been renamed
to dracut.sh).

Then, run:

dracut -e xattr -I <file with xattr> (add -f to overwrite the ram disk)

Xattrs can be seen by stopping the boot process for example by adding
rd.break to the kernel command line.

Roberto

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
