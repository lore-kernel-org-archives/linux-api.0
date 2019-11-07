From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 1/4] statx: define STATX_ATTR_VERITY
Date: Thu, 7 Nov 2019 14:12:56 -0800
Message-ID: <20191107221255.GB1160@gmail.com>
References: <20191029204141.145309-1-ebiggers@kernel.org>
 <20191029204141.145309-2-ebiggers@kernel.org>
 <20191107014420.GD15212@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20191107014420.GD15212@magnolia>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 06, 2019 at 05:44:20PM -0800, Darrick J. Wong wrote:
> On Tue, Oct 29, 2019 at 01:41:38PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add a statx attribute bit STATX_ATTR_VERITY which will be set if the
> > file has fs-verity enabled.  This is the statx() equivalent of
> > FS_VERITY_FL which is returned by FS_IOC_GETFLAGS.
> > 
> > This is useful because it allows applications to check whether a file is
> > a verity file without opening it.  Opening a verity file can be
> > expensive because the fsverity_info is set up on open, which involves
> > parsing metadata and optionally verifying a cryptographic signature.
> > 
> > This is analogous to how various other bits are exposed through both
> > FS_IOC_GETFLAGS and statx(), e.g. the encrypt bit.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  include/linux/stat.h      | 3 ++-
> >  include/uapi/linux/stat.h | 2 +-
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/stat.h b/include/linux/stat.h
> > index 765573dc17d659..528c4baad09146 100644
> > --- a/include/linux/stat.h
> > +++ b/include/linux/stat.h
> > @@ -33,7 +33,8 @@ struct kstat {
> >  	 STATX_ATTR_IMMUTABLE |				\
> >  	 STATX_ATTR_APPEND |				\
> >  	 STATX_ATTR_NODUMP |				\
> > -	 STATX_ATTR_ENCRYPTED				\
> > +	 STATX_ATTR_ENCRYPTED |				\
> > +	 STATX_ATTR_VERITY				\
> >  	 )/* Attrs corresponding to FS_*_FL flags */
> >  	u64		ino;
> >  	dev_t		dev;
> > diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> > index 7b35e98d3c58b1..ad80a5c885d598 100644
> > --- a/include/uapi/linux/stat.h
> > +++ b/include/uapi/linux/stat.h
> > @@ -167,8 +167,8 @@ struct statx {
> >  #define STATX_ATTR_APPEND		0x00000020 /* [I] File is append-only */
> >  #define STATX_ATTR_NODUMP		0x00000040 /* [I] File is not to be dumped */
> >  #define STATX_ATTR_ENCRYPTED		0x00000800 /* [I] File requires key to decrypt in fs */
> > -
> >  #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
> > +#define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
> 
> Any reason why this wasn't 0x2000?

Yes, as Andreas pointed out, the value is chosen to match the corresponding
FS_IOC_GETFLAGS bit, like the other bits above marked [I].

> 
> If there's a manpage update that goes with this, then...
> Acked-by: Darrick J. Wong <darrick.wong@oracle.com>
> 

It's pretty trivial to add it to the statx(2) man page.
I've sent out a patch for comment:
https://lkml.kernel.org/linux-fscrypt/20191107220248.32025-1-ebiggers@kernel.org/

- Eric
