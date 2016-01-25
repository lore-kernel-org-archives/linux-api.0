From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 0/4] crypto: add algif_akcipher user space API
Date: Mon, 25 Jan 2016 22:34:53 +0100
Message-ID: <63219617.tVA5DWIBaO@positron.chronox.de>
References: <2602093.Yrp6nKrmX6@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2602093.Yrp6nKrmX6@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: tadeusz.struk@intel.com, marcel@holtmann.org, dwmw2@infradead.org, linux-api@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Am Freitag, 18. Dezember 2015, 00:49:57 schrieb Stephan Mueller:

Hi Herbert,

[...]

> Changes v3:
>  * fix hack in alg_setkey and alg_setsockopt by avoding branches for
>  setkey and setpubkey as pointed out by Marcel Holtmann
>  * removal of patch for fixing SGL handling as this is already included

I have ported the code to 4.5. Shall I wait for comments from you for the 
current code or shall I post v4 for the current cryptodev tree?


Ciao
Stephan
