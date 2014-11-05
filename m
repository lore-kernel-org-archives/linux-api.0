From: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Subject: Re: kdbus: add code for buses, domains and endpoints
Date: Wed, 5 Nov 2014 20:59:30 +0100
Message-ID: <20141105195929.GA3624@dztty>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
 <8738a6w6kv.fsf@x220.int.ebiederm.org>
 <20141030095854.GA4716@dztty>
 <87wq7hiwjb.fsf@x220.int.ebiederm.org>
 <20141030144855.GA9705@dztty>
 <CALCETrXeNQUuwiyaJrbbbZUrSW3NTucRgpg0kKEuS3yszP-09w@mail.gmail.com>
 <20141030180813.GA11850@dztty>
 <54528798.40107@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54528798.40107-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 06:46:48PM +0000, Simon McVittie wrote:
> On 30/10/14 18:08, Djalal Harouni wrote:
> > So, this is similar to AF_UNIX sockets. For them there's SCM_CREDENTIALS
> > and SO_PEERCRED. The former uses credentials at the time of when
> > messages are being sent, the latter uses the credentials at the time
> > when when the connection was initially established.
> 
> Please note that dbus-daemon, the reference implementation of D-Bus,
> does not actually ever use SCM_CREDENTIALS on its AF_UNIX sockets. We
> prefer to use Linux's SO_PEERCRED, or the platform's closest available
> equivalent if there is one. dbus-daemon has methods (RPC calls) to get a
> specified peer's uid, pid or LSM data (e.g. SELinux context), but those
> methods return the value that was true when the connection was opened or
> shortly afterwards, not the value that is true right now. I believe the
> plan is that kdbus has ioctls that are equivalent to those RPC calls,
> but without needing to wait for asynchronous socket events to get an answer.
Correct, we are compatible to SO_PEERCRED and every peer can request
that using KDBUS_CMD_CONN_INFO ioctl(), no need for asynchronous
operations.

Thank you Simon for your feedback!

-- 
Djalal Harouni
http://opendz.org
