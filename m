From: Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: Re: kdbus: add code to gather metadata
Date: Mon, 03 Nov 2014 12:00:08 +0000
Message-ID: <54576E48.40800@collabora.co.uk>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org> <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com> <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com> <5451FA9B.8070501@zonque.org> <CALCETrWjOS0AHF33zN0Vy1NC1441To7AgNPge3sKCz8bn2d8gg@mail.gmail.com> <54525F32.3040502@zonque.org> <CALCETrV6MLYUQN6mqZbH=FrLyrETVoemtdC05po8+X=6SKQ70A@mail.gmail.com> <5454BE6E.5040507@zonque.org> <CALCETrXxx4juUGA3mwOxq0BtErM0kj7_THxiO5LwCVLzCXnd2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXxx4juUGA3mwOxq0BtErM0kj7_THxiO5LwCVLzCXnd2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 01/11/14 16:19, Andy Lutomirski wrote:
> You can't justify logging fundamentally unverifiable things like the
> command line by saying that you want to know if someone tries to play
> (impossible-to-reliably-detect) games to obscure their command line.

I think kdbus might be mixing up two orthogonal things here.

It has an easy, kernel-checked, race-free way to determine
kernel-mediated credential-like information that cannot be faked or
interfered with (uid, primary gid, other gids?, security label,
capabilities) because these are usable for security decisions, but if
they are *not* received in a kernel-checked, race-free way, then they
are useless.

One concrete example of using non-ucred credential-like information is
that traditional D-Bus can only restrict sysadmin tasks to uid 0 (or a
root-equivalent uid in group sudo/admin/whatever), whereas when systemd
and systemd-logind are run on kdbus, many of their D-Bus methods require
specific capabilities(7): KillUser requires CAP_KILL, PowerOff requires
CAP_SYS_BOOT, and so on. If capabilities(7) are a good thing, then
that's surely a good thing too. (On the other hand, if you think
capabilities(7) are a waste of time, then so is this.)

It also uses the same mechanism as an easy, race-free, but *not*
kernel-checked way to determine bits and pieces that are valuable for
debugging (dbus-monitor etc.), but unsuitable for security decisions,
such as cmdline.

In traditional D-Bus, you can get the uid and pid of a remote process,
but in a debug log you would probably actually prefer to log the cmdline
in addition; yes a malicious user could fake the cmdline, but when
debugging a system problem, information that is known to be forgeable
seems better than no information at all. After all, ps(1) shows the
forgeable cmdline, not just the executable. You can get that by
rummaging in /proc/$pid, but there is a race: if the remote process
exits too soon (a "fire and forget" method call) then you'll never know
who it was. kdbus solves that race, but does not make cmdline unforgeable.

If client libraries wishing to attach their cmdline (or other debug
info) to messages for debugging were required to add it as an
out-of-band KDBUS_ITEM, or as a D-Bus message header inside the payload,
then that would be duplicating work in client libraries that could have
been done centrally, but would still solve the race.

    S
