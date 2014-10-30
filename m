From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 08:44:12 +0100
Message-ID: <5451EC4C.3010205@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <CALCETrUBegZ4F1sKq3LxUgANX3=syYOrqOp9=F--g9pkVHHgUA@mail.gmail.com> <20141029222531.GA8129@kroah.com> <CALCETrX6vf7cKy=XDhDtn9hn1W930MRxBa=pk93RnyuZ-EaNyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrX6vf7cKy=XDhDtn9hn1W930MRxBa=pk93RnyuZ-EaNyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/29/2014 11:28 PM, Andy Lutomirski wrote:
> On Wed, Oct 29, 2014 at 3:25 PM, Greg Kroah-Hartman

>> You do have to opt-in for this information at time of capture, so
>> I don't understand the issue here.  This is the same type of thing
>> that dbus does today, and I don't see the information leaks
>> happening there, do you?
> 
> The docs suggest that the *receiver* opts in.

Yes, that's true.

> I don't think that current dbus has severe information leaks because 
> the total scope for information transparently sent to dbus is rather 
> small (struct ucred only, presumably).

Which piece of credential information are you concerned about,
particularly? I might miss something, but AFAICS, all of that
information can be queried by a remote peer anyway, through /proc for
instance. The reason why we (optionally) attach them to messages is that
we want to let the other side know which information was authoritative,
precisely at the time the message was sent. Current implementation can't
do that in a race-free way.

Also note that we currently drop all such metadata whenever a message
crosses a PID or user namespace boundary. This is because we currently
don't know yet which information we would want to transport in such
cases, and how the translation in both directions would look like, from
a semantic perspective. Hence, we decided to leave that for later.

I'll go through your other replies during the day. Thanks for your input
on that RFC, everyone.


Daniel
