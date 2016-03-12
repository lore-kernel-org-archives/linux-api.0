From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Fri, 11 Mar 2016 16:33:58 -0800
Message-ID: <CA+55aFyYpycTTJG-Re9NEVzcM1KaOQoyLUdVW3SyvRRmoNS4-Q@mail.gmail.com>
References: <20160303231050.GU29057@dastard>
	<CAC6JEv-HeAoRxSmVghGvbX7G92yH00k-5F-48qEW13vAB1Q99g@mail.gmail.com>
	<20160309230819.GB3949@thunk.org>
	<56E18B9B.5070503@gmail.com>
	<CA+55aFyw1nN4ze3-AGGE27evOZuXnkJC9C-W5QRUR=zKHqObGg@mail.gmail.com>
	<56E24CA5.3030702@redhat.com>
	<20160311135952.57a44931@lxorguk.ukuu.org.uk>
	<CA+55aFwX2GYYN53E9qaTym=gp1aRjSA5f1G+N5WEiRd1dOJhFA@mail.gmail.com>
	<CALCETrX5Hr6=yWPrNrh2u3YZNYmmv5ZdOQXcgNX5xr54N+Cfvw@mail.gmail.com>
	<CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com>
	<20160311223047.GZ30721@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160311223047.GZ30721@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 2:30 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> On Fri, Mar 11, 2016 at 10:25:30AM -0800, Linus Torvalds wrote:
>>
>> So you'd have to explicitly say "my setup is ok with hole punching".
>
> Except it's not hole punching that is the problem. [..]
> The problem here is
> preallocation of unwritten blocks that expose the stale data if the
> filesystem skips marking those blocks as unwritten.

Right you are.

> It's all well and good to restrict access to the fallocate() call to
> limit who can expose stale data, but it doesn't remove the fact it
> is easy for stale data to unintentionally escape the privileged
> group once it has been exposed because there is no record of the
> fact the file contains uninitialised blocks....

Good point.

It's not just that the user in question *couldn't* have exposed it
other ways by reading the raw device and then writing that info into a
file. You're right that the "don't initialize unwritten blocks" thing
has a more insidious problem of making it easy to unintentionally
expose such data just because you missed an error path (or the process
died without ever doing the proper over-write)..

It would be much better if we could somehow mitigate just _how_ easy
it is to screw up.

One way to do that would be to not just require that the user that
discards the initializing writes have read access to the underlying
device, but perhaps also have some strict requirement that you can
discard only if the file you are working with is legible only to you?

That would limit the damage, and keep the stale data "private" to the
user who is already able to read the raw data off the device. Sure,
you can then mark the file read-by-world by others later, but at that
point you're kind of *consciously* exposing that stale data (and at
that point, you have hopefully cleaned it all up and replaced the
stale data with real data).

But would that perhaps not be reasonable for the kind of use cases
that google has now?

            Linus
