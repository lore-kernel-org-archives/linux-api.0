From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Wed, 29 Oct 2014 21:04:58 -0700
Message-ID: <87egtqurrp.fsf@x220.int.ebiederm.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<20141029221505.GA7812@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141029221505.GA7812-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> (Greg KH's message of "Wed, 29
	Oct 2014 15:15:05 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> writes:

> On Wed, Oct 29, 2014 at 03:00:44PM -0700, Greg Kroah-Hartman wrote:
>> kdbus is a kernel-level IPC implementation that aims for resemblance to
>> the the protocol layer with the existing userspace D-Bus daemon while
>> enabling some features that couldn't be implemented before in userspace.
>
> {sigh}
>
> I'll blame it on the jet-lag for the lack of [XX/12] markings on the
> patches.  I'll give it a day for review before resending if people
> really want to know the ordering.  It doesn't matter except for the
> final patch that adds the code to the build file.
>
> sorry about that,

For what it is worth these patches are also poorly split up.  Every
patch I looked at in detail had functions that were being introduced
that did not have callers.

That poor split up of the patches makes it difficult to see how
the functionality that is being introduced is being used.

Eric
