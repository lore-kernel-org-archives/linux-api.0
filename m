From: Djalal Harouni <tixxdz@opendz.org>
Subject: Re: kdbus: add connection, queue handling and message validation code
Date: Thu, 30 Oct 2014 10:06:52 +0100
Message-ID: <20141030090652.GA2773@dztty>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-6-git-send-email-gregkh@linuxfoundation.org>
 <87k33iw759.fsf@x220.int.ebiederm.org>
 <CALCETrXm116+eRvYY7QNbHcrOpZYOCqvC_WPguPZm-G+UEHeGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXm116+eRvYY7QNbHcrOpZYOCqvC_WPguPZm-G+UEHeGw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org, alban.crequy@collabora.co.uk, Javier Martinez Canillas <javier.martinez@collabora.co.uk>, Tom Gundersen <teg@jklm.no>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 29, 2014 at 08:55:58PM -0700, Andy Lutomirski wrote:
> On Wed, Oct 29, 2014 at 8:47 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> >
> >> From: Daniel Mack <daniel@zonque.org>
> >>
> >> This patch adds code to create and destroy connections, to validate
> >> incoming messages and to maintain the queue of messages that are
> >> associated with a connection.
> >>
> >> Note that connection and queue have a 1:1 relation, the code is only
> >> split in two parts for cleaner separation and better readability.
> >
> > You are not performing capability checks at open time.
> >
> > As such this API is suceptible to a host of file descriptor passing attacks.
> 
> To be fair, write(2) doesn't work on these fds, so the usual attacks
> don't work.  But who knows what absurd things kdbus clients will do
> with fd passing?
Yes, we use ioctl() so we are safe here! if there is a a suid process
that does perform arbitrary ioctl() on intrusted passed fds,
then we are already in truble given all the already available ioctl()
(not only kdbus, all available ioctl()... we blame the client), so yes
usual write()/read() do not work here.

But we do perform the creds check against the cred of connection
creation time, if you open the fd you do not have the connection,
you still need a KDBUS_CMD_HELLO ioctl() on the fd, and during that time
we store the creds, and we perform all the TALK, SEE and OWN against
those creds (uid/gid). It is like a second connect() call, unless you
perform the KDBUS_CMD_HELLO you are not connected, and after turning
your fd to a connection, a service can restrict its access (TALK, OWN
and SEE) policies, not all connected peers can TALK (send messages) to
a service.


-- 
Djalal Harouni
http://opendz.org
