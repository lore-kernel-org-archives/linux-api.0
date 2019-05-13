From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Sun, 12 May 2019 20:02:30 -0400
Message-ID: <1557705750.10635.264.camel@linux.ibm.com>
References: <20190512153105.GA25254@light.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190512153105.GA25254@light.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>, hpa@zytor.com
Cc: Roberto Sassu <roberto.sassu@huawei.com>, viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com
List-Id: linux-api@vger.kernel.org

On Sun, 2019-05-12 at 17:31 +0200, Dominik Brodowski wrote:
> On Sun, May 12, 2019 at 08:52:47AM -0400, Mimi Zohar wrote:


> > It's too late.  The /init itself should be signed and verified.
> 
> Could you elaborate a bit more about the threat model, and why deferring
> this to the initramfs is too late?

The IMA policy defines a number of different methods of identifying
which files to measure, appraise, audit.[1]  Without xattrs, the
granularity of the policy rules is severely limited.  Without xattrs,
a filesystem is either in policy, or not.

With an IMA policy rule requiring rootfs (tmpfs) files to be verified,
then /init needs to be properly labeled, otherwise /init will fail to
execute.

Mimi

[1] Documentation/ABI/testing/ima_policy
