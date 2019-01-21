From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4 1/3] fs: hoist EFSCORRUPTED definition into uapi header
Date: Mon, 21 Jan 2019 15:51:58 -0800
Message-ID: <20190121235158.GA4363@magnolia>
References: <20190118161440.220134-1-jannh@google.com>
 <20190121215454.GA12996@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190121215454.GA12996@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Jann Horn <jannh@google.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Pavel Machek <pavel@ucw.cz>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 21, 2019 at 04:54:54PM -0500, Theodore Y. Ts'o wrote:
> On Fri, Jan 18, 2019 at 05:14:38PM +0100, Jann Horn wrote:
> > Multiple filesystems can already return EFSCORRUPTED errors to userspace;
> > however, so far, definitions of EFSCORRUPTED were in filesystem-private
> > headers.
> > 
> > I wanted to use EUCLEAN to indicate data corruption in the VFS layer;
> > Dave Chinner says that I should instead hoist the definitions of
> > EFSCORRUPTED into the UAPI header and then use EFSCORRUPTED.
> > 
> > This patch is marked for stable backport because it is a prerequisite for
> > the following patch.
> > 
> > Cc: stable@vger.kernel.org
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Jann Horn <jannh@google.com>
> 
> Before we enshrine the overloading of EUCLEAN and EFSCORRUPTED, I
> wonder if we should at least consider the option of assigning a new
> error code number for EFSCORRUPTED.  The downside of doing this is
> that for a while, older versions glibc won't have strerror/perror
> translation for the new error code.  On the other hand, I'm not sure
> it will be that much more confusing to the average user than
> "Structure needs cleaning".  :-)
> 
> The upside of assigning a new error code is that in a year or two,
> we'll actually have an intelligible error message showing up in log
> files and in user's terminals.

Uh... Ted?  Back in ~2009 we had a discussion on the ext4 conference
call about what error codes to return for "metadata is garbage" and
"metadata crc doesn't validate".  Back then you said that it would have
been great if someone had thought of defining error codes for that so
that by the time we got around to merging metadata checksums for ext4,
we'd have some error codes ready to go.

I pointed out that "the XFS people" already returned EUCLEAN /
EFSCORRUPTED and EILSEQ / EBADFSCRC for those cases and that upstream
had been doing that for a couple of years already, so we decided that
we'd just make ext4 behave like XFS because they'd already started
training everyone and their pet search engines that these oddly phrased
error messages in the context of a filesystem means they need to run
some sort of fsck/repair tool.  We also decided that while the messaging
was weird, it would be less work for both of us than to try to push
disruptive changes through Linux uapi, glibc, man pages, strerror
localization catalogs, etc.

Now it's a *decade* later, and ext4 / XFS have both converged on more or
less the same behavioral patterns w.r.t. when they return EFSCORRUPTED
and EFSBADCRC.  btrfs, hpfs, jffs2, and ubifs seem to use EUCLEAN to
signal bad metadata just like XFS and ext4 do.

I disagree with upending 13 years of established precedent for user
visible behavior.  We possibly could've pulled this off ten years ago,
but it's waaaay too late now.  Too much work, too little gain.

--D

> 					- Ted
