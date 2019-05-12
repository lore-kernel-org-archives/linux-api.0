From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Sun, 12 May 2019 17:31:05 +0200
Message-ID: <20190512153105.GA25254@light.dominikbrodowski.net>
References: <1557665567.10635.222.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1557665567.10635.222.camel@linux.ibm.com>
 <4E92753A-04BD-4018-A3A4-5E3E4242D8B9@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com, Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>, viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com
List-Id: linux-api@vger.kernel.org

On Sun, May 12, 2019 at 03:18:16AM -0700, hpa@zytor.com wrote:
> > Couldn't this parsing of the .xattr-list file and the setting of the xattrs
> > be done equivalently by the initramfs' /init? Why is kernel involvement
> > actually required here?
> 
> There are a lot of things that could/should be done that way...

Indeed... so why not try to avoid adding more such "things", and keeping
them in userspace (or in a fork_usermode_blob)?


On Sun, May 12, 2019 at 08:52:47AM -0400, Mimi Zohar wrote:
> It's too late.  The /init itself should be signed and verified.

Could you elaborate a bit more about the threat model, and why deferring
this to the initramfs is too late?

Thanks,
	Dominik
