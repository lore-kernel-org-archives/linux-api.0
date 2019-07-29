From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v7 09/16] fscrypt: add an HKDF-SHA512 implementation
Date: Mon, 29 Jul 2019 14:42:34 -0700
Message-ID: <1564436554.12726.38.camel@HansenPartnership.com>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-10-ebiggers@kernel.org>
 <20190728193949.GI6088@mit.edu> <20190729202951.GG169027@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20190729202951.GG169027@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, 2019-07-29 at 13:29 -0700, Eric Biggers wrote:
> On Sun, Jul 28, 2019 at 03:39:49PM -0400, Theodore Y. Ts'o wrote:
> > On Fri, Jul 26, 2019 at 03:41:34PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
[...]
> > > HKDF solves all the above problems.
> > > 
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > 
> > Unless I missed something there's nothing here which is fscrypt
> > specific.  Granted that it's somewhat unlikely that someone would
> > want to implement (the very bloated) IKE from IPSEC in the kernel,
> > I wonder if there might be other users of HKDF, and whether this
> > would be better placed in lib/ or crypto/ instead of fs/crypto?
> 
> This is standard HKDF-SHA512; only the choice of parameters is
> fscrypt-specific. So it could indeed use a common implementation of
> HKDF if one were available.
> 
> However, I don't think there are any other HKDF users in the kernel
> currently.

Well, I'm still trying to add the TPM ones, but they're based on SP800-
108 for arbitrary keys and SP800-56A for elliptic curve ones.  These
are similar to the RFC5869 except that they do extract/expand in a
single operation.  Plus, of course, the TPM mandates we use the name
algorithm (usually sha256, which is what I hardcoded) as the hash.

Note: since you don't use the extract step either in your
implementation, effectively you're equivalent to SP800-108 as well. 
This is effectively the same reason as the TPM: we need deterministic
keys, so we've nowhere to get the salt from that would persist.

> Also, while there was a patch to support HKDF via the crypto_rng API,
> there was no consensus about whether this was actually the best way
> to add KDF support:
> https://lore.kernel.org/linux-crypto/2423373.Zd5ThvQH5g@positron.chro
> nox.de
> 
> So for now, to avoid unnecessarily blocking this patchset I think we
> should just go with this implementation in fs/crypto/.  It can always
> be changed later, once we decide on the best way to add KDFs to the
> crypto API.
> 
> [To be clear: this patch already uses "hmac(sha512)" from the crypto
> API.  It's only the actual HKDF part that we're talking about here.

Right, once you have the hmac + hash available, the rest is easy, so
this is what we have for the TPM KDFa:

static void KDFa(u8 *key, int keylen, const char *label, u8 *u,
		 u8 *v, int bytes, u8 *out)
{
	u32 counter;
	const __be32 bits = cpu_to_be32(bytes * 8);

	for (counter = 1; bytes > 0; bytes -= SHA256_DIGEST_SIZE, counter++,
		     out += SHA256_DIGEST_SIZE) {
		SHASH_DESC_ON_STACK(desc, sha256_hash);
		__be32 c = cpu_to_be32(counter);

		hmac_init(desc, key, keylen);
		crypto_shash_update(desc, (u8 *)&c, sizeof(c));
		crypto_shash_update(desc, label, strlen(label)+1);
		crypto_shash_update(desc, u, SHA256_DIGEST_SIZE);
		crypto_shash_update(desc, v, SHA256_DIGEST_SIZE);
		crypto_shash_update(desc, (u8 *)&bits, sizeof(bits));
		hmac_final(desc, key, keylen, out);
	}
}

I honestly think these things are so simplistic with the correct hmac
that it would make it more confusing to try to produce a general KDF
than it would simply to hard code them where we need them.

James



______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
