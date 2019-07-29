From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v7 05/16] fscrypt: refactor v1 policy key setup into
 keysetup_legacy.c
Date: Mon, 29 Jul 2019 12:37:42 -0700
Message-ID: <20190729193740.GD169027@gmail.com>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-6-ebiggers@kernel.org>
 <20190728154032.GE6088@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190728154032.GE6088@mit.edu>
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

Hi Ted, thanks for the review!

On Sun, Jul 28, 2019 at 11:40:32AM -0400, Theodore Y. Ts'o wrote:
> On Fri, Jul 26, 2019 at 03:41:30PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > In preparation for introducing v2 encryption policies which will find
> > and derive encryption keys differently from the current v1 encryption
> > policies, refactor the v1 policy-specific key setup code from keyinfo.c
> > into keysetup_legacy.c.  Then rename keyinfo.c to keysetup.c.
> 
> I'd use keysetup_v1.c, myself.  We can hope that we've gotten it right
> with v2 and we'll never need to do another version, but *something* is
> going to come up eventually which will require a v3 keysetup , whether
> it's post-quantuum cryptography or something else we can't anticipate
> right now.
> 
> For an example of the confusion that can result, one good example is
> in the fs/quota subsystem, where QFMT_VFS_OLD, QFMT_VFS_V0, and
> QFMT_VFS_V1 maps to quota_v1 and quota_v2 in an amusing and
> non-obvious way.  (Go ahead, try to guess before you go look at the
> code.  :-)
> 
> Other than that, looks good.  We can always move code around or rename
> files in the future, so I'm not going to insist on doing it now (but
> it would be my preference).
> 
> Reviewed-by: Theodore Ts'o <tytso@mit.edu>
> 

Agreed, I'll call it keysetup_v1.c instead.

- Eric

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
