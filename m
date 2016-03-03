From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Thu, 03 Mar 2016 13:14:12 -0500
Message-ID: <yq14mcn8m4r.fsf@sermon.lab.mkp.net>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
	<20160302040947.16685.42926.stgit@birch.djwong.org>
	<CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
	<20160302225601.GB21890@birch.djwong.org>
	<CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
	<20160303170205.GD24012@thunk.org>
	<CA+55aFwPA1X8XGTdVZmP5uzkWMwj+X=bjkGVcEkZDme+qskrzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFwPA1X8XGTdVZmP5uzkWMwj+X=bjkGVcEkZDme+qskrzQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Linus Torvalds's message of "Thu, 3 Mar 2016 09:55:38 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>>>>> "Linus" == Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> writes:

Linus> On Thu, Mar 3, 2016 at 9:02 AM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
>> 
>> There is a massive bug in the SATA specs about trim, which is that it
>> is considered advisory.  So the storage device can throw it away
>> whenever it feels like it.  (In practice, when it's too busy doing
>> other things).

Linus> Ugh.

SCSI UNMAP provides similar semantics :(

Linus> But that essentially says that we shouldn't expose this interface
Linus> at all (unless we trust our white-lists - I'm sure they are
Linus> getting better, but if nobody has ever really _relied_ on the
Linus> zeroing behavior of trim, then I guess there could be tons of
Linus> bugs lurking).

We started out with the blacklist approach and it blew up. So now we're
down to a whitelist of drives that have been sanctioned by their
manufacturers to do the right thing.

Occasionally a new SSD model messes things up but we haven't updated it
since last summer. The drive vendors are much better at testing using
Linux than they used to be.

-- 
Martin K. Petersen	Oracle Linux Engineering
