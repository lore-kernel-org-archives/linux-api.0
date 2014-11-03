From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: kdbus: add code to gather metadata
Date: Mon, 3 Nov 2014 09:05:14 -0800
Message-ID: <CALCETrXMZobdWkJz6mZHGMJU-asMJXc5+4JRisyACn=h9sOPtA@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
 <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com>
 <5451FA9B.8070501@zonque.org> <CALCETrWjOS0AHF33zN0Vy1NC1441To7AgNPge3sKCz8bn2d8gg@mail.gmail.com>
 <54525F32.3040502@zonque.org> <CALCETrV6MLYUQN6mqZbH=FrLyrETVoemtdC05po8+X=6SKQ70A@mail.gmail.com>
 <5454BE6E.5040507@zonque.org> <CALCETrXxx4juUGA3mwOxq0BtErM0kj7_THxiO5LwCVLzCXnd2A@mail.gmail.com>
 <54576E48.40800@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54576E48.40800-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 3, 2014 at 4:00 AM, Simon McVittie
<simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org> wrote:
> On 01/11/14 16:19, Andy Lutomirski wrote:
>> You can't justify logging fundamentally unverifiable things like the
>> command line by saying that you want to know if someone tries to play
>> (impossible-to-reliably-detect) games to obscure their command line.
>
> I think kdbus might be mixing up two orthogonal things here.
>
> It has an easy, kernel-checked, race-free way to determine
> kernel-mediated credential-like information that cannot be faked or
> interfered with (uid, primary gid, other gids?, security label,
> capabilities) because these are usable for security decisions, but if
> they are *not* received in a kernel-checked, race-free way, then they
> are useless.
>
> One concrete example of using non-ucred credential-like information is
> that traditional D-Bus can only restrict sysadmin tasks to uid 0 (or a
> root-equivalent uid in group sudo/admin/whatever), whereas when systemd
> and systemd-logind are run on kdbus, many of their D-Bus methods require
> specific capabilities(7): KillUser requires CAP_KILL, PowerOff requires
> CAP_SYS_BOOT, and so on. If capabilities(7) are a good thing, then
> that's surely a good thing too. (On the other hand, if you think
> capabilities(7) are a waste of time, then so is this.)

I think that capabilities(7) is largely a disaster.  That aside, I
don't think that all of these capabilities should refer to the
*kernel* privileges.  For example, CAP_SYS_BOOT should be, and remain,
the ability to reboot the system *yourself*.  For example, if someone
wants to implement Windows 7 (or Visa?  Or 2003?  I forget.) style
reboot auditing, then userspace specifically does not want programs
that can ask for a reboot to hold CAP_SYS_BOOT.

>
> It also uses the same mechanism as an easy, race-free, but *not*
> kernel-checked way to determine bits and pieces that are valuable for
> debugging (dbus-monitor etc.), but unsuitable for security decisions,
> such as cmdline.
>
> In traditional D-Bus, you can get the uid and pid of a remote process,
> but in a debug log you would probably actually prefer to log the cmdline
> in addition; yes a malicious user could fake the cmdline, but when
> debugging a system problem, information that is known to be forgeable
> seems better than no information at all. After all, ps(1) shows the
> forgeable cmdline, not just the executable. You can get that by
> rummaging in /proc/$pid, but there is a race: if the remote process
> exits too soon (a "fire and forget" method call) then you'll never know
> who it was. kdbus solves that race, but does not make cmdline unforgeable.
>

I would love to fix this race.  That opens the door to a lot more
debugging (maps, status, etc) while not pretending to offer a kernel
check that doesn't, and can't, exist.

Materializing some sort of pid fd on the receiving end would be one
solution.  Another would be to give the receiver some token that can
be used to check for pid recycling.

Can we give each task a pid-namespace-local 64-bit (or even longer)
number that is mostly guaranteed not to be reused for the lifetime of
the namespace?

For example, give each task a per-pidns tid_unique, and give each
pidns a next_tid_unique.  Creating a task assigns it
next_tid_unique++.  (On overflow, clone fails.)  For CRIU's benefit,
if you have CAP_SYS_ADMIN over the pidns's userns and you are not in
the pidns, then you can change tid_unique and next_tid_unique.  Doing
that carelessly will introduce races, but that's fine -- it should
only be done on restore when everything's frozen.

> If client libraries wishing to attach their cmdline (or other debug
> info) to messages for debugging were required to add it as an
> out-of-band KDBUS_ITEM, or as a D-Bus message header inside the payload,
> then that would be duplicating work in client libraries that could have
> been done centrally, but would still solve the race.
>

I much prefer that approach.  If a kernel feature is being added to
just to avoid duplication of a debugging aid in user code, then let's
leave it to user code.

--Andy
