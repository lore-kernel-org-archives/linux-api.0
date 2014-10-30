From: Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 12:52:00 +0100
Message-ID: <CAG-2HqX9RUQHiF1U_CXiDVVLS-7aUOQdYn7EVNSMZNdbe38cTA@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz> <20141029231106.GB16548@kroah.com>
 <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz> <20141029234001.GB16520@kroah.com>
 <CALCETrXY90YAXA9-GLc0EowmRCtWZzh8br8seiqrzOkmNn8_Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXY90YAXA9-GLc0EowmRCtWZzh8br8seiqrzOkmNn8_Hw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>, Simon McVittie <simon.mcvittie@collabora.co.uk>, Daniel Mack <daniel@zonque.org>, "alban.crequy" <alban.crequy@collabora.co.uk>, Javier Martinez Canillas <javier.martinez@collabora.co.uk>
List-Id: linux-api@vger.kernel.org

On 10/30/2014 12:55 AM, Andy Lutomirski wrote:> It's worth noting that:
>
>  - Proper credential passing could be added to UNIX sockets, and we
> may want to do that anyway.  Also, the current kdbus semantics seem to
> be "spew lots of credentials and other miscellaneous
> potentially-sensitive and sometime spoofable information all over the
> place", which isn't obviously an improvement.  (This is fixable, but
> it will almost certainly not be compatible with current systemd kdbus
> code if fixed.)

Care to elaborate on what you think is spoofable, and what needs to be fixed?

Anyway, the idea is that by simply connecting to the bus and sending a
message to some service, you implicitly agree to passing some metadata
along to the service (and to a lesser extent to the bus). It's not
that this information is leaked, or that the peer could actively
access any of the sender's private memory. Also note that this kind of
metadata information is also available via /proc/$PID, and via
SCM_CREDENTIALS/SO_PEERCRED and the socket seclabel APIs. What the
kdbus API allows users to do is to get a lot more of this information
in a race-free way. For example, if you want to get the audit identity
bits, you can now get this attached securely by the kernel, at the
time the message is sent, rather than having to firest get the peer's
$PID from SCM_CREDENTIALS and then read the audit identity bits racily
from /proc/$PID/loginuid and /proc/$PID/sessionid.

>  - The current kdbus patches seem to be worse than UNIX sockets from a
> namespace perspective, but maybe I'm misunderstanding how it's
> supposed to work.  UNIX sockets work quite nicely in containers.

kdbus is recusively stackable for containers. You can run
kdbus-enabled containers within kdbus-enabled containers within
kdbus-enabled containers, with the full functionality available for
each container, and each container isolated from each other.

When credential information is passed between processes of different
(PID) namespaces most of the attached metadata is suppressed. This
isn't too different from how SCM_CREDENTIALS works, which will zero
out the bits it cannot translate as well.

>  - There's an obvious interface to add timestamping to UNIX sockets
> (it could work exactly the way it does for UDP / PTP).

Timestamping on AF_UNIX/SOCK_DGRAM already exists, but that's not
enough for the use-cases we want to support.

>  - I'm unconvinced by this performance argument without numbers.  The
> kdbus credential code, at least, looks to be quite heavy on allocation
> and atomics.  This isn't to say that the current userspace D-Bus
> daemon doesn't also serialize everything, but it could be made
> multithreaded.

There are some major benefits regarding performance:

* fewer userspace context switches. For a full-duplex method call it's
down from five to two: instead of sender -> dbus daemon -> service ->
dbus daemon -> sender it's just sender -> service -> sender.
* fewer message copies in userspace. For a full-duplex method call
it's down from eight to two: instead of copying the method call data
into a socket, out of a socket, into a socket, out of a socket, and
the same for the method reply, we just copy one message directly to
the receiver, and the reply back.
* generally fewer syscalls involved. A synchronous method call is now
doable in a single ioctl on the sender side.
* memfds can be used for transport purposes of larger payload. This
way, we can cover substantial payload sizes instead of just small
control messages, with no extra copies. kdbus, in its transport layer,
makes sure only sealed memfds are passed in as payload, so the sender
cannot modify the contents while the receiver is already parsing it.

>  - Race-free?  What are the races that are inherent to UNIX sockets?

Does the above explain what we have in mind?

Note that the aim is not necessarily that kdbus should be better than
UNIX sockets in every way, nor that it should be favoured in all
cases. What we are trying to address is a common case in environments
where peers don't necessarily trust each other.

Cheers,

Tom
