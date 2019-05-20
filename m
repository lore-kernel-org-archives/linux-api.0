From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH v3 2/2] initramfs: introduce do_readxattrs()
Date: Mon, 20 May 2019 10:16:58 +0200
Message-ID: <cee53f00-a216-0666-0774-0f3ebf1b1292@huawei.com>
References: <20190517165519.11507-1-roberto.sassu@huawei.com>
 <20190517165519.11507-3-roberto.sassu@huawei.com>
 <CD9A4F89-7CA5-4329-A06A-F8DEB87905A5@zytor.com>
 <20190517210219.GA5998@rani.riverdale.lan>
 <20190517211014.GA9198@rani.riverdale.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190517211014.GA9198@rani.riverdale.lan>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: hpa@zytor.com, viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com, niveditas98@gmail.com
List-Id: linux-api@vger.kernel.org

On 5/17/2019 11:10 PM, Arvind Sankar wrote:
> On Fri, May 17, 2019 at 05:02:20PM -0400, Arvind Sankar wrote:
>> On Fri, May 17, 2019 at 01:18:11PM -0700, hpa@zytor.com wrote:
>>>
>>> Ok... I just realized this does not work for a modular initramfs, composed at load time from multiple files, which is a very real problem. Should be easy enough to deal with: instead of one large file, use one companion file per source file, perhaps something like filename..xattrs (suggesting double dots to make it less likely to conflict with a "real" file.) No leading dot, as it makes it more likely that archivers will sort them before the file proper.
>> This version of the patch was changed from the previous one exactly to deal with this case --
>> it allows for the bootloader to load multiple initramfs archives, each
>> with its own .xattr-list file, and to have that work properly.
>> Could you elaborate on the issue that you see?
> Roberto, are you missing a changelog entry for v2->v3 change?

The changelog for v1->v2 is missing.

Thanks

Roberto

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
