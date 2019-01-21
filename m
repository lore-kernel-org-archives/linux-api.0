From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 1/3] fs: hoist EFSCORRUPTED definition into uapi header
Date: Tue, 22 Jan 2019 09:13:57 +1100
Message-ID: <20190121221357.GC4205@dastard>
References: <20190118161440.220134-1-jannh@google.com>
 <20190121215454.GA12996@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190121215454.GA12996@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Jann Horn <jannh@google.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
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
> error code number for EFSCORRUPTED. 

No.

We've exposed filesystem corruption errors to userspace as errno 117
for many years now, so people are already familiar with this error
as indicating a filesystem problem.

> The downside of doing this is
> that for a while, older versions glibc won't have strerror/perror
> translation for the new error code.

And everyone will end up asking "WTF is this undefined error the
application just received?" until glibc, man pages and enough
occurrences of the question have been asked that the search engines
develop enough of a history record that they return useful results.
Not only won't users have a clue, but the app developers the users
first ask "what's this error mean" won't have a clue, either.

> On the other hand, I'm not sure
> it will be that much more confusing to the average user than
> "Structure needs cleaning".  :-)

Go search for "XFS structure needs cleaning" on your preferred
search engine and will you get lots and lots of hits indicating what
you should do when you get that error. It's taken years to build up
that history such that it's extremely useful to the average user....

> The upside of assigning a new error code is that in a year or two,
> we'll actually have an intelligible error message showing up in log
> files and in user's terminals.

The downside is that it will take several years before people will
become familiar with the new error, and we'll have to deal with the
fallout repeatedly from it. Hence, IMO, there's no upside to
changing the errno of EFSCORRUPTED now that it is largely ubiquitous
in userspace.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
