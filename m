From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v2 0/3] initramfs: add support for xattrs in the initial
 ram disk
Date: Mon, 13 May 2019 08:08:33 -0400
Message-ID: <1557749313.10635.309.camel@linux.ibm.com>
References: <dca50ee1-62d8-2256-6fdb-9a786e6cea5a@landley.net>
         <20190512194322.GA71658@rani.riverdale.lan>
         <3fe0e74b-19ca-6081-3afe-e05921b1bfe6@huawei.com>
         <4f522e28-29c8-5930-5d90-e0086b503613@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4f522e28-29c8-5930-5d90-e0086b503613@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>, Roberto Sassu <roberto.sassu@huawei.com>, Arvind Sankar <niveditas98@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 2019-05-13 at 04:07 -0500, Rob Landley wrote:

> > Allowing a kernel with integrity enforcement to parse the CPIO image
> > without verifying it first is the weak point.
> 
> If you don't verify the CPIO image then in theory it could have anything in it,
> yes. You seem to believe that signing individual files is more secure than
> signing the archive. This is certainly a point of view.

Nobody is claiming that signing and verifying individual files is more
secure.  We are saying that in some environments BOTH are needed.  In
many environments today the initramfs IS being signed and verified.

Unfortunately not all environments can sign the initramfs today,
because the initramfs is not distributed with the kernel image, but
generated on the target system.

Mimi
