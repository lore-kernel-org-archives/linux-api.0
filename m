From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: fallocate mode flag for "unshare blocks"?
Date: Thu, 31 Mar 2016 09:31:23 -0600
Message-ID: <3E147309-67EA-4B29-B4E0-883BA03B7BFC@dilger.ca>
References: <20160302155007.GB7125@infradead.org> <20160330182755.GC2236@birch.djwong.org> <20160331003242.GA5813@localhost.localdomain> <20160331075529.GB4209@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_46939755-A74C-4C8F-A5DA-D821D2ACA486"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160331075529.GB4209-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Liu Bo <bo.li.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_46939755-A74C-4C8F-A5DA-D821D2ACA486
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Mar 31, 2016, at 1:55 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> On Wed, Mar 30, 2016 at 05:32:42PM -0700, Liu Bo wrote:
>> Well, btrfs fallocate doesn't allocate space if it's a shared one
>> because it thinks the space is already allocated.  So a later overwrite
>> over this shared extent may hit enospc errors.
> 
> And this makes it an incorrect implementation of posix_fallocate,
> which glibcs implements using fallocate if available.

It isn't really useful for a COW filesystem to implement fallocate()
to reserve blocks.  Even if it did allocate all of the blocks on the
initial fallocate() call, when it comes time to overwrite these blocks
new blocks need to be allocated as the old ones will not be overwritten.

Because of snapshots that could hold references to the old blocks,
there isn't even the guarantee that the previous fallocated blocks will
be released in a reasonable time to free up an equal amount of space.

Cheers, Andreas






--Apple-Mail=_46939755-A74C-4C8F-A5DA-D821D2ACA486
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVv1CzHKl2rkXzB/gAQhzHRAAjRF1pWkEl2czxpH+Uk1lmdZDoZYvi/pW
2QxYC6IL5H/a+usrR4r+wP2sZ1spLa8pQaoyLEcSU5EPEvVNHSH0ip7q3cX+I+/W
6BNc+Qm2eVWgrI9d/eYGFJF5ahlZ8K6+s2fj6KlxC39f1MD6qTFLq7bqZ5bOCorI
w/HIKuwclJgiQ34w/yZtHUFMICb1kwmjAYc/u18JkJ9zxXCfpZl54n71xFUWxqOM
Yuuwrz5YyTwxhUV+mVSmVNPwrUCQK1mq0DfNmIk1c5VihbDDevWuW6JIam1dBpd2
EGdajSQmGg9exwoHzrn/maWLtQrBBgMpXS81KfBK0+5fIZv8kxKJ2l6KTRs2etQu
9Mjwfrs+F2ecZtp7BWf4Yxu+fmjp8hQLeypgtpbZ8I+8nqh0sY64XLP3m5f46llI
K+9RGJ5VSdrCWfH5l7jh3pbJ/wpsUVn7i0YmomG91f0doLFT9vMLalkK262vfcIQ
zC9CmaLz7cqI77vFZ/G8BmHMH2yNT09oV4drXTqBsvmMR2JfQYT4Z19nYNgjv6zp
OZidH9SlwUPwN23y4AB9jaOe+ePtqFDrNiUZoQtbifWDozFLFTteK4Ip+w/mYpw3
Rj8771pSKhg89xj8DMl3ztq68QTVYj9vXwogVB8z/ugNyxwRXEWbvbaTzQ7FiaLk
OhZvegHPSyE=
=ZvYL
-----END PGP SIGNATURE-----

--Apple-Mail=_46939755-A74C-4C8F-A5DA-D821D2ACA486--
