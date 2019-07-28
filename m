From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v7 10/16] fscrypt: v2 encryption policy support
Date: Sun, 28 Jul 2019 17:17:30 -0400
Message-ID: <20190728211730.GK6088@mit.edu>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-11-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190726224141.14044-11-ebiggers@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 26, 2019 at 03:41:35PM -0700, Eric Biggers wrote:
> @@ -319,6 +329,31 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
>  	if (!capable(CAP_SYS_ADMIN))
>  		goto out_wipe_secret;
>  
> +	if (arg.key_spec.type != FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR) {

This should be "== FSCRYPT_KEY_SPEC_TYPE_INDENTIFIER" instead.  That's
because you use the identifier part of the union:

> +		/* Calculate the key identifier and return it to userspace. */
> +		err = fscrypt_hkdf_expand(&secret.hkdf,
> +					  HKDF_CONTEXT_KEY_IDENTIFIER,
> +					  NULL, 0, arg.key_spec.u.identifier,

If we ever add a new key specifier type, and alternative in the union,
this is going to come back to bite us.

> +	if (policy->version == FSCRYPT_POLICY_V1) {
> +		/*
> +		 * The original encryption policy version provided no way of
> +		 * verifying that the correct master key was supplied, which was
> +		 * insecure in scenarios where multiple users have access to the
> +		 * same encrypted files (even just read-only access).

Which scenario do you have in mind?  With read-only access, Alice can
fetch the encryption policy for a directory, and introduce a key with
the same descriptor, but the "wrong" key, but that's only going to
affect Alice's use of the key.  It won't affect what key is used by
Bob, since Alice doesn't have write access to Bob's keyrings.

If what you mean is the risk when there is a single global
filesystem-specific keyring, where Alice could introduce a "wrong" key
identified with a specific descriptor, then sure, Alice could trick
Bob into encrypting his data with the wrong key (one known to Alice).
But we don't allow keys usable by V1 policies to be used in the
filesystem-specific keyring, do we?

						- Ted

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
