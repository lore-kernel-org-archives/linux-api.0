From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 17 Mar 2016 23:20:23 -0400
Message-ID: <20160318032023.GK23593@thunk.org>
References: <20160315225224.GD23848@thunk.org>
 <20160316015139.GC5826@birch.djwong.org>
 <7674C689-C07E-4D38-85EB-4FD9B55CBB35@dilger.ca>
 <20160317001502.GF23593@thunk.org>
 <56E9FB73.6040803@redhat.com>
 <CAC6JEv-CGaphHj6hVXUhFS+Dc4jS46nO1yOfKF5yA8AnDwqgOw@mail.gmail.com>
 <CA+55aFzbzXb9ApP5FnVZihWRpWGO1-YnJj_Giip5LfD6=uvf0w@mail.gmail.com>
 <20160317183512.GA76233@clm-mbp.thefacebook.com>
 <819F38A3-51A7-4874-8314-8A6004495716@dilger.ca>
 <20160317210018.GA78710@clm-mbp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160317210018.GA78710-HIXDwvFErZjFYCXBM6kdu7fOX0fSgVTm@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Martin Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 17, 2016 at 02:00:18PM -0700, Chris Mason wrote:
> 
> Thinking more, my guess is that google will just keep doing what they
> are already doing ;)  But there could be a flag in sysfs dedicated to
> trim-for-fallocate so admins can see what their devices are reporting.
> readonly in mainline, if someone wants to patch it in their large data
> center it wouldn't be hard.

That's true, because one of the major use cases is SATA drives where
trim isn't available.  Even for SAS drives where you have WRITE SAME,
you wouldn't want to use it for large fallocate regions.

So I see using reliable trim as a zeroing mechanism to be orthogonal
to the question of NO_HIIDE_STALE.

I do think that using TRIM in various causes where we are doing an
fallocate does make sense for non-rotational devices.  In general TRIM
should be fast enough that that I'd be surprised that people would be
complaining --- especially since most of the time, fallocate isn't on
the timing-critical path of most applications.

							- Ted
