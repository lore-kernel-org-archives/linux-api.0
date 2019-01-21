From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v4 1/3] fs: hoist EFSCORRUPTED definition into uapi header
Date: Mon, 21 Jan 2019 16:54:54 -0500
Message-ID: <20190121215454.GA12996@mit.edu>
References: <20190118161440.220134-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190118161440.220134-1-jannh@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Pavel Machek <pavel@ucw.cz>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 18, 2019 at 05:14:38PM +0100, Jann Horn wrote:
> Multiple filesystems can already return EFSCORRUPTED errors to userspace;
> however, so far, definitions of EFSCORRUPTED were in filesystem-private
> headers.
> 
> I wanted to use EUCLEAN to indicate data corruption in the VFS layer;
> Dave Chinner says that I should instead hoist the definitions of
> EFSCORRUPTED into the UAPI header and then use EFSCORRUPTED.
> 
> This patch is marked for stable backport because it is a prerequisite for
> the following patch.
> 
> Cc: stable@vger.kernel.org
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Jann Horn <jannh@google.com>

Before we enshrine the overloading of EUCLEAN and EFSCORRUPTED, I
wonder if we should at least consider the option of assigning a new
error code number for EFSCORRUPTED.  The downside of doing this is
that for a while, older versions glibc won't have strerror/perror
translation for the new error code.  On the other hand, I'm not sure
it will be that much more confusing to the average user than
"Structure needs cleaning".  :-)

The upside of assigning a new error code is that in a year or two,
we'll actually have an intelligible error message showing up in log
files and in user's terminals.

					- Ted
