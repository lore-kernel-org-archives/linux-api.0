From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v7 09/16] fscrypt: add an HKDF-SHA512 implementation
Date: Mon, 29 Jul 2019 13:29:52 -0700
Message-ID: <20190729202951.GG169027@gmail.com>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-10-ebiggers@kernel.org>
 <20190728193949.GI6088@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190728193949.GI6088@mit.edu>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

On Sun, Jul 28, 2019 at 03:39:49PM -0400, Theodore Y. Ts'o wrote:
> On Fri, Jul 26, 2019 at 03:41:34PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add an implementation of HKDF (RFC 5869) to fscrypt, for the purpose of
> > deriving additional key material from the fscrypt master keys for v2
> > encryption policies.  HKDF is a key derivation function built on top of
> > HMAC.  We choose SHA-512 for the underlying unkeyed hash, and use an
> > "hmac(sha512)" transform allocated from the crypto API.
> > 
> > We'll be using this to replace the AES-ECB based KDF currently used to
> > derive the per-file encryption keys.  While the AES-ECB based KDF is
> > believed to meet the original security requirements, it is nonstandard
> > and has problems that don't exist in modern KDFs such as HKDF:
> > 
> > 1. It's reversible.  Given a derived key and nonce, an attacker can
> >    easily compute the master key.  This is okay if the master key and
> >    derived keys are equally hard to compromise, but now we'd like to be
> >    more robust against threats such as a derived key being compromised
> >    through a timing attack, or a derived key for an in-use file being
> >    compromised after the master key has already been removed.
> > 
> > 2. It doesn't evenly distribute the entropy from the master key; each 16
> >    input bytes only affects the corresponding 16 output bytes.
> > 
> > 3. It isn't easily extensible to deriving other values or keys, such as
> >    a public hash for securely identifying the key, or per-mode keys.
> >    Per-mode keys will be immediately useful for Adiantum encryption, for
> >    which fscrypt currently uses the master key directly, introducing
> >    unnecessary usage constraints.  Per-mode keys will also be useful for
> >    hardware inline encryption, which is currently being worked on.
> > 
> > HKDF solves all the above problems.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Unless I missed something there's nothing here which is fscrypt
> specific.  Granted that it's somewhat unlikely that someone would want
> to implement (the very bloated) IKE from IPSEC in the kernel, I wonder
> if there might be other users of HKDF, and whether this would be
> better placed in lib/ or crypto/ instead of fs/crypto?
> 

This is standard HKDF-SHA512; only the choice of parameters is fscrypt-specific.
So it could indeed use a common implementation of HKDF if one were available.

However, I don't think there are any other HKDF users in the kernel currently.
Also, while there was a patch to support HKDF via the crypto_rng API, there was
no consensus about whether this was actually the best way to add KDF support:
https://lore.kernel.org/linux-crypto/2423373.Zd5ThvQH5g@positron.chronox.de

So for now, to avoid unnecessarily blocking this patchset I think we should just
go with this implementation in fs/crypto/.  It can always be changed later, once
we decide on the best way to add KDFs to the crypto API.

[To be clear: this patch already uses "hmac(sha512)" from the crypto API.  It's
only the actual HKDF part that we're talking about here.

Also, its correctness is tested by the ciphertext verification xfstests.]

- Eric

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
