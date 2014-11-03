From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Mon, 3 Nov 2014 14:38:26 +0000
Message-ID: <20141103143826.7a28057b@alan.etchedpixels.co.uk>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz>
	<20141102012130.GA9335@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141102012130.GA9335-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, 1 Nov 2014 18:21:30 -0700
Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:

> Here's some reasons why I feel it is better to have kdbus in the kernel
> rather than trying to implement the same thing in a userspace daemon:

No - these are reasons to have *something* in the kernel. I think it
would be far more constructive to treat the current kdbus as a proof of
concept/prototype or even a draft requirements specification.

>   as the only trustworthy compoenent in the game is the kernel which
>   adds metadata and ensures that all data passed as payload is either
>   copied or sealed, so that the receiver can parse the data without

When the kernel adds metadata without being told to do so by one end of
the link you create a new set of security and privacy leaks. Far better
that the sender must choose what metadata is added and the receiver can
decide to bin stuff that's not acceptable. The job of the kernel is
really more like that of an auditor in a business transaction - to make
sure that the data they agree to pass is truthful.

(ie its the sender who must say "attach my user info", the receiver who
must say "no info, no play" and the kernel who must provide the info so
it can't be faked.

> - semantics for apps with heavy data payloads (media apps, for instance)
>   with optinal priority message dequeuing, and global message ordering.

Sounds like System 5 IPC ;-)

> Regarding binder: binder and kdbus follow very different design
> concepts. 

We know binder is broken but the Android guys are stuck in a special
kind of hell with it for some years to come. We need to make sure kdbus
isn't the same result.

Alan
