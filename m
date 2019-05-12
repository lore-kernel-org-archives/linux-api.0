From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Sun, 12 May 2019 08:52:47 -0400
Message-ID: <1557665567.10635.222.camel@linux.ibm.com>
References: <20190509112420.15671-1-roberto.sassu@huawei.com>
         <20190512091748.s6fvy2f5p2a2o6ja@isilmar-4.linta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190512091748.s6fvy2f5p2a2o6ja@isilmar-4.linta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>, Roberto Sassu <roberto.sassu@huawei.com>
Cc: viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, hpa@zytor.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com
List-Id: linux-api@vger.kernel.org

On Sun, 2019-05-12 at 11:17 +0200, Dominik Brodowski wrote:
> On Thu, May 09, 2019 at 01:24:17PM +0200, Roberto Sassu wrote:
> > This proposal consists in marshaling pathnames and xattrs in a file called
> > .xattr-list. They are unmarshaled by the CPIO parser after all files have
> > been extracted.
> 
> Couldn't this parsing of the .xattr-list file and the setting of the xattrs
> be done equivalently by the initramfs' /init? Why is kernel involvement
> actually required here?

It's too late.  The /init itself should be signed and verified.

Mimi
