From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v4 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Mon, 3 Jun 2019 13:32:53 -0500
Message-ID: <541e9ea1-024f-5c22-0b58-f8692e6c1eb1@landley.net>
References: <20190523121803.21638-1-roberto.sassu@huawei.com>
 <cf9d08ca-74c7-c945-5bf9-7c3495907d1e@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cf9d08ca-74c7-c945-5bf9-7c3495907d1e@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>, viro@zeniv.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, bug-cpio@gnu.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, hpa@zytor.com, arnd@arndb.de, james.w.mcmechan@gmail.com, niveditas98@gmail.com
List-Id: linux-api@vger.kernel.org

On 6/3/19 4:31 AM, Roberto Sassu wrote:
>> This patch set aims at solving the following use case: appraise files from
>> the initial ram disk. To do that, IMA checks the signature/hash from the
>> security.ima xattr. Unfortunately, this use case cannot be implemented
>> currently, as the CPIO format does not support xattrs.
>>
>> This proposal consists in including file metadata as additional files named
>> METADATA!!!, for each file added to the ram disk. The CPIO parser in the
>> kernel recognizes these special files from the file name, and calls the
>> appropriate parser to add metadata to the previously extracted file. It has
>> been proposed to use bit 17:16 of the file mode as a way to recognize files
>> with metadata, but both the kernel and the cpio tool declare the file mode
>> as unsigned short.
>
> Any opinion on this patch set?
> 
> Thanks
> 
> Roberto

Sorry, I've had the window open since you posted it but haven't gotten around to
it. I'll try to build it later today.

It does look interesting, and I have no objections to the basic approach. I
should be able to add support to toybox cpio over a weekend once I've got the
kernel doing it to test against.

Rob
