From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v8 08/10] tpm: Proxy driver for supporting multiple
 emulated TPMs
Date: Wed, 16 Mar 2016 11:49:04 -0600
Message-ID: <20160316174904.GA6127@obsidianresearch.com>
References: <1457909680-14085-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457909680-14085-9-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160316120916.GA14820@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160316120916.GA14820@intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, dhowells@redhat.com
List-Id: linux-api@vger.kernel.org

On Wed, Mar 16, 2016 at 02:09:16PM +0200, Jarkko Sakkinen wrote:
> On Sun, Mar 13, 2016 at 06:54:38PM -0400, Stefan Berger wrote:

> Alternative to this would be to have /dev/vtpmx create:
> 
> * /dev/vtpm0 for the server
> * /dev/tpm0 for the client
> 
> This is how David Howell's PoC worked and that's why I want
> to make this alternative visible.
> 
> The server could even respawn without container noticing it.
> This solution have better availability properties.

Seriously, no, that doesn't make any sense. TPM is stateful, you can't
respawn the server side.

If anyone is ever clever enough to make that workable then they just
go ahead and save the server fd with the other state. systemd for
instance already has everything needed to make that work.

We don't need to have a server dev node and we certainly don't need
the leaking problem that leaves us with.

Jason
