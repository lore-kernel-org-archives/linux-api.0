From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 08/11] tpm: Driver for supporting multiple emulated
 TPMs
Date: Fri, 11 Mar 2016 11:50:30 +0200
Message-ID: <20160311095030.GA10270@intel.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457545170-30120-9-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160310163915.GA4863@intel.com>
 <56E1AF44.9040807@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56E1AF44.9040807@linux.vnet.ibm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 10, 2016 at 12:30:44PM -0500, Stefan Berger wrote:
> > Some might want to use this in a way that the created virtual device
> > is not closed when /dev/vtpmx is closed.
> 
> I don't see that happening. If you want the device pair to stay around after
> an application terminates, you have to pass the file descriptor returned
> from the ioctl to an application.

Right, so it is. So the device pair dissappears either by closing the
returned fd (by the ioctl) or when application terminates. No extra
ioctls would be needed.

>     Stefan

/Jarkko
