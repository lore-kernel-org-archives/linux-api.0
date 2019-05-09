From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Thu, 9 May 2019 13:34:13 -0500
Message-ID: <fca8e601-1144-1bb8-c007-518651f624a5@landley.net>
References: <20190509112420.15671-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190509112420.15671-1-roberto.sassu@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>, viro@zeniv.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, hpa@zytor.com, arnd@arndb.de, james.w.mcmechan@gmail.com
List-Id: linux-api@vger.kernel.org

On 5/9/19 6:24 AM, Roberto Sassu wrote:
> This patch set aims at solving the following use case: appraise files from
> the initial ram disk. To do that, IMA checks the signature/hash from the
> security.ima xattr. Unfortunately, this use case cannot be implemented
> currently, as the CPIO format does not support xattrs.
> 
> This proposal consists in marshaling pathnames and xattrs in a file called
> .xattr-list. They are unmarshaled by the CPIO parser after all files have
> been extracted.

So it's in-band signalling that has a higher peak memory requirement.

> The difference with another proposal
> (https://lore.kernel.org/patchwork/cover/888071/) is that xattrs can be
> included in an image without changing the image format, as opposed to
> defining a new one. As seen from the discussion, if a new format has to be
> defined, it should fix the issues of the existing format, which requires
> more time.

So you've explicitly chosen _not_ to address Y2038 while you're there.

Rob
