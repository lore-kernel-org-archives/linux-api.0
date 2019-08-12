From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v8 05/20] fscrypt: rename fscrypt_master_key to
 fscrypt_direct_key
Date: Mon, 12 Aug 2019 18:20:03 -0400
Message-ID: <20190812222003.GD28705@mit.edu>
References: <20190805162521.90882-1-ebiggers@kernel.org>
 <20190805162521.90882-6-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190805162521.90882-6-ebiggers@kernel.org>
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
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 05, 2019 at 09:25:06AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In preparation for introducing a filesystem-level keyring which will
> contain fscrypt master keys, rename the existing 'struct
> fscrypt_master_key' to 'struct fscrypt_direct_key'.  This is the
> structure in the existing table of master keys that's maintained to
> deduplicate the crypto transforms for v1 DIRECT_KEY policies.
> 
> I've chosen to keep this table as-is rather than make it automagically
> add/remove the keys to/from the filesystem-level keyring, since that
> would add a lot of extra complexity to the filesystem-level keyring.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good.  You can add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

						- Ted

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
