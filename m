From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH v3 00/18] fscrypt: key management improvements
Date: Tue, 19 Feb 2019 23:54:05 -0800
Message-ID: <20190220075404.GA974@sol.localdomain>
References: <20190220065249.32099-1-ebiggers@kernel.org>
 <1660609D-3525-4485-9652-57976DB020F4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1660609D-3525-4485-9652-57976DB020F4@dilger.ca>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, Satya Tangirala <satyat@google.com>, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 19, 2019 at 11:18:21PM -0800, Andreas Dilger wrote:
> On Feb 19, 2019, at 10:52 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > Hello,
> > 
> > This patchset makes major improvements to how keys are added, removed,
> > and derived in fscrypt, aka ext4/f2fs/ubifs encryption.  It does this by
> > adding new ioctls that add and remove encryption keys directly to/from
> > the filesystem, and by adding a new encryption policy version ("v2")
> > where the user-provided keys are only used as input to HKDF-SHA512 and
> > are identified by their cryptographic hash.
> 
> Just to confirm for the layman reader - the fact that the crypto keys
> are registered with the filesystem and not with the user process doesn't
> prevent user(s) from having different crypto keys for different subdirs
> in a single filesystem?

Correct, that hasn't changed.  Different directories can use different keys.

> 
> Secondly, does this progress fscrypt toward allowing multiple master keys
> to decrypt a single per-file key?
> 

It's not a goal of this patchset as no one has really been asking for it yet.
Per-file keys are still derived from the master key.

Note that it's already possible to wrap the master keys in userspace.  Thus you
can already have multiple passwords that unlock the same encrypted directory.
You just can't do this with *individual files*.  Maybe that's good enough.

However, this patchset does fix the denial of service vulnerabilities that
currently exist when users share an encrypted directory.  Also, since it adds a
real KDF, it makes it much easier to derive a wrapping key to wrap the per-file
keys if that were to become a requirement.  (The master key could be used as the
wrapping key directly, but that's inflexible and more error-prone.)

- Eric

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
