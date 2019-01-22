From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v4 1/3] fs: hoist EFSCORRUPTED definition into uapi header
Date: Mon, 21 Jan 2019 19:38:23 -0500
Message-ID: <20190122003823.GC19379@mit.edu>
References: <20190118161440.220134-1-jannh@google.com>
 <20190121215454.GA12996@mit.edu>
 <20190121235158.GA4363@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190121235158.GA4363@magnolia>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jann Horn <jannh@google.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Pavel Machek <pavel@ucw.cz>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 21, 2019 at 03:51:58PM -0800, Darrick J. Wong wrote:
> 
> I disagree with upending 13 years of established precedent for user
> visible behavior.  We possibly could've pulled this off ten years ago,
> but it's waaaay too late now.  Too much work, too little gain.

I remember the discussion; but now that we're adding it to uapi header
files, it's really going to be impossible.  And I have had some
regrets about that decision ten years ago.  I agree it would cause
confusion if we do it now, but it's basically the our last
opportunity.
 
How about this then?  We could ask glibc to change the string returned
by strerror for EUCLEAN/EFSCORRUPTED to be something like "File system
or block device corrupted".  This is how the errno is used in the
kernel; and if we don't want to change the error code, changing the
string returned by glibc should be less problematic.

					- Ted
