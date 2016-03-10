From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v6 08/11] tpm: Driver for supporting multiple emulated
 TPMs
Date: Thu, 10 Mar 2016 15:12:20 -0700
Message-ID: <20160310221220.GB9735@obsidianresearch.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457545170-30120-9-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160310163915.GA4863@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160310163915.GA4863@intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 10, 2016 at 06:39:15PM +0200, Jarkko Sakkinen wrote:
> Some might want to use this in a way that the created virtual device
> is not closed when /dev/vtpmx is closed.

No, there is no reason to create an API like that - TPM's are
stateful, one cannot close the server side and re-connect and expect
things to continue to work.

Jason
