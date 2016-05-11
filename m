From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH RESEND v5 0/6] crypto: algif - add akcipher
Date: Wed, 11 May 2016 15:25:21 +0100
Message-ID: <5123.1462976721@warthog.procyon.org.uk>
References: <20160505195048.1843.7817.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20160505195048.1843.7817.stgit@tstruk-mobl1>
Content-ID: <5122.1462976721.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> This is the same v5 version as before rebased on top of
> http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-asym-keyctl

I've just reposted this.  The interface you're using should be the same, I
think, but the details underneath have changed.

Also, you can now supply private keys to the kernel if they're PKCS#8 encoded
and keyctls are supplied that do encryption, decryption, signing and
verifying, e.g.:

	j=`openssl pkcs8 -in ~/pkcs7/firmwarekey2.priv -topk8 -nocrypt -outform DER | \
	    keyctl padd asymmetric foo @s`
	echo -n abcdefghijklmnopqrst >/tmp/data
	keyctl pkey_encrypt $j 0 /tmp/data enc=pkcs1 >/tmp/enc
	keyctl pkey_decrypt $j 0 /tmp/enc enc=pkcs1 >/tmp/dec
	cmp /tmp/data /tmp/dec
	keyctl pkey_sign $j 0 /tmp/data enc=pkcs1 hash=sha1 >/tmp/sig
	keyctl pkey_verify $j 0 /tmp/data /tmp/sig enc=pkcs1 hash=sha1

David
