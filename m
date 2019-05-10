From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Fri, 10 May 2019 08:56:18 +0200
Message-ID: <bf0d02fc-d6ce-ef1d-bb7d-7ca14432c6fd@huawei.com>
References: <20190509112420.15671-1-roberto.sassu@huawei.com>
 <fca8e601-1144-1bb8-c007-518651f624a5@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fca8e601-1144-1bb8-c007-518651f624a5@landley.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>, viro@zeniv.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, hpa@zytor.com, arnd@arndb.de, james.w.mcmechan@gmail.com
List-Id: linux-api@vger.kernel.org

On 5/9/2019 8:34 PM, Rob Landley wrote:
> On 5/9/19 6:24 AM, Roberto Sassu wrote:
>> This patch set aims at solving the following use case: appraise files from
>> the initial ram disk. To do that, IMA checks the signature/hash from the
>> security.ima xattr. Unfortunately, this use case cannot be implemented
>> currently, as the CPIO format does not support xattrs.
>>
>> This proposal consists in marshaling pathnames and xattrs in a file called
>> .xattr-list. They are unmarshaled by the CPIO parser after all files have
>> been extracted.
> 
> So it's in-band signalling that has a higher peak memory requirement.

This can be modified. Now I allocate the memory necessary for the path
and all xattrs of a file (max: .xattr-list size - 10 bytes). I could
process each xattr individually (max: 255 + 1 + 65536 bytes).


>> The difference with another proposal
>> (https://lore.kernel.org/patchwork/cover/888071/) is that xattrs can be
>> included in an image without changing the image format, as opposed to
>> defining a new one. As seen from the discussion, if a new format has to be
>> defined, it should fix the issues of the existing format, which requires
>> more time.
> 
> So you've explicitly chosen _not_ to address Y2038 while you're there.

Can you be more specific?

Thanks

Roberto


> Rob
> 

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
