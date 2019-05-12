From: Arvind Sankar <niveditas98@gmail.com>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Sun, 12 May 2019 15:43:25 -0400
Message-ID: <20190512194322.GA71658@rani.riverdale.lan>
References: <dca50ee1-62d8-2256-6fdb-9a786e6cea5a@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dca50ee1-62d8-2256-6fdb-9a786e6cea5a@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, May 12, 2019 at 05:05:48PM +0000, Rob Landley wrote:
> On 5/12/19 7:52 AM, Mimi Zohar wrote:
> > On Sun, 2019-05-12 at 11:17 +0200, Dominik Brodowski wrote:
> >> On Thu, May 09, 2019 at 01:24:17PM +0200, Roberto Sassu wrote:
> >>> This proposal consists in marshaling pathnames and xattrs in a file called
> >>> .xattr-list. They are unmarshaled by the CPIO parser after all files have
> >>> been extracted.
> >>
> >> Couldn't this parsing of the .xattr-list file and the setting of the xattrs
> >> be done equivalently by the initramfs' /init? Why is kernel involvement
> >> actually required here?
> > 
> > It's too late.  The /init itself should be signed and verified.
> 
> If the initramfs cpio.gz image was signed and verified by the extractor, how is
> the init in it _not_ verified?
> 
> Ro

Wouldn't the below work even before enforcing signatures on external
initramfs:
1. Create an embedded initramfs with an /init that does the xattr
parsing/setting. This will be verified as part of the kernel image
signature, so no new code required.
2. Add a config option/boot parameter to panic the kernel if an external
initramfs attempts to overwrite anything in the embedded initramfs. This
prevents overwriting the embedded /init even if the external initramfs
is unverified.
