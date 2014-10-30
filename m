From: Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: Re: kdbus: add code for buses, domains and endpoints
Date: Thu, 30 Oct 2014 18:46:48 +0000
Message-ID: <54528798.40107@collabora.co.uk>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org> <8738a6w6kv.fsf@x220.int.ebiederm.org> <20141030095854.GA4716@dztty> <87wq7hiwjb.fsf@x220.int.ebiederm.org> <20141030144855.GA9705@dztty> <CALCETrXeNQUuwiyaJrbbbZUrSW3NTucRgpg0kKEuS3yszP-09w@mail.gmail.com> <20141030180813.GA11850@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141030180813.GA11850@dztty>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 30/10/14 18:08, Djalal Harouni wrote:
> So, this is similar to AF_UNIX sockets. For them there's SCM_CREDENTIALS
> and SO_PEERCRED. The former uses credentials at the time of when
> messages are being sent, the latter uses the credentials at the time
> when when the connection was initially established.

Please note that dbus-daemon, the reference implementation of D-Bus,
does not actually ever use SCM_CREDENTIALS on its AF_UNIX sockets. We
prefer to use Linux's SO_PEERCRED, or the platform's closest available
equivalent if there is one. dbus-daemon has methods (RPC calls) to get a
specified peer's uid, pid or LSM data (e.g. SELinux context), but those
methods return the value that was true when the connection was opened or
shortly afterwards, not the value that is true right now. I believe the
plan is that kdbus has ioctls that are equivalent to those RPC calls,
but without needing to wait for asynchronous socket events to get an answer.

The reason I say "or shortly afterwards" is that for the benefit of
platforms where the "best" credentials transfer mechanism behaves like
Linux SCM_CREDENTIALS, such as FreeBSD's SCM_CREDS, the beginning of a
D-Bus protocol stream is that the client sends '\0' to dbus-daemon,
accompanied by SCM_CREDS or whatever if the platform needs it. On Linux
we just send a plain '\0' with no out-of-band data at that point.

The only out-of-band data we send with individual D-Bus RPC messages
later in the connection's lifetime is for fd-passing (SCM_RIGHTS).

It would be a perfectly reasonable feature request to have individual
D-Bus messages that contain proof that, *at the time of sending*, the
sender possessed a given uid/pid/gid/capability/whatever, but we do not
currently have that feature. It would be reasonable for kdbus to have
that feature even though traditional D-Bus doesn't, and it's entirely
possible that it is a feature that would be of benefit for e.g. systemd,
but it is not required for feature parity with traditional D-Bus over
AF_UNIX; it should be included in kdbus, or not, on its own merits.

    S
