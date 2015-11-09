From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v4] keys, trusted: select hash algorithm for TPM2 chips
Date: Tue, 10 Nov 2015 00:00:25 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1511092359320.30224@namei.org>
References: <1446752588-3429-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <1446752588-3429-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Petko Manolov <petkan@mip-labs.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, "Mark D. Baushke" <mdb@juniper.net>, David Safford <safford@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, "open list:KEYS-TRUSTED" <linux-security-module@vger.kernel.org>, "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CRYPTO API" <linux-crypto@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.>
List-Id: linux-api@vger.kernel.org

On Thu, 5 Nov 2015, Jarkko Sakkinen wrote:

> v4:
> 
> * Added missing select CRYPTO_HASH_INFO in drivers/char/tpm/Kconfig
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>


Reviewed-by: James Morris <james.l.morris@oracle.com>


-- 
James Morris
<jmorris@namei.org>
