From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 06:59:57 -0700
Message-ID: <CALCETrXv_CevG7166++ZHBok0ae7mNhF83VjrRVQ2AKF22Vf_g@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz> <20141029231106.GB16548@kroah.com>
 <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz> <20141029234001.GB16520@kroah.com>
 <CALCETrXY90YAXA9-GLc0EowmRCtWZzh8br8seiqrzOkmNn8_Hw@mail.gmail.com> <CAG-2HqX9RUQHiF1U_CXiDVVLS-7aUOQdYn7EVNSMZNdbe38cTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG-2HqX9RUQHiF1U_CXiDVVLS-7aUOQdYn7EVNSMZNdbe38cTA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Gundersen <teg@jklm.no>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>, Simon McVittie <simon.mcvittie@collabora.co.uk>, Daniel Mack <daniel@zonque.org>, "alban.crequy" <alban.crequy@collabora.co.uk>, Javier Martinez Canillas <javier.martinez@collabora.co.uk>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 4:52 AM, Tom Gundersen <teg@jklm.no> wrote:
> On 10/30/2014 12:55 AM, Andy Lutomirski wrote:> It's worth noting that:
>>
>>  - Proper credential passing could be added to UNIX sockets, and we
>> may want to do that anyway.  Also, the current kdbus semantics seem to
>> be "spew lots of credentials and other miscellaneous
>> potentially-sensitive and sometime spoofable information all over the
>> place", which isn't obviously an improvement.  (This is fixable, but
>> it will almost certainly not be compatible with current systemd kdbus
>> code if fixed.)
>
> Care to elaborate on what you think is spoofable, and what needs to be fixed?

cmd and comm are trivially replaceable by any sender.

>
> Anyway, the idea is that by simply connecting to the bus and sending a
> message to some service, you implicitly agree to passing some metadata
> along to the service (and to a lesser extent to the bus). It's not
> that this information is leaked, or that the peer could actively
> access any of the sender's private memory.

To me, this smells like bad design.  By using kdbus, I implicitly
agree to send everyone my command line?!?  If I'm in a cgroup that
policy decrees should be privileged, then I should invoke that
privilege by specifically asking, *at the time of capture*, to send
that cgroup.  Otherwise it becomes unclear what things convey
privilege when, and that will lead immediately to incomprehensible
security models, and that will lead to exploits.

<snark>Sorry, but "implicitly agree" sounds a lot like using my
esteemed cellphone carrier.  When I use it, some argue that I
implicitly agree to have my identity prepended to all outgoing HTTP
requests.  This is *not* a good thing.</snark>

> Also note that this kind of
> metadata information is also available via /proc/$PID, and via
> SCM_CREDENTIALS/SO_PEERCRED and the socket seclabel APIs.

Not if you have a sensible LSM policy or if you use hidepid.  And,
once you've fixed the namespacing issues, not if the sender and
receiver are in different PID namespaces or if they don't have /proc
mounted at all.

>
> When credential information is passed between processes of different
> (PID) namespaces most of the attached metadata is suppressed.

This is a bug.  It prevents users from usefully sandboxing themselves
in a kdbus world.  If you create and enter a user namespace, then your
outside identity (which should be unchanged) is suppressed.  (Note
that anything that captures credentials other than at open time is
also an issue for sandboxes in the other direction: it may interfere
with selective privilege dropping.)

> This
> isn't too different from how SCM_CREDENTIALS works, which will zero
> out the bits it cannot translate as well.

SCM_CREDENTIALS translates the translatable parts.

> There are some major benefits regarding performance:
>
> * fewer userspace context switches. For a full-duplex method call it's
> down from five to two: instead of sender -> dbus daemon -> service ->
> dbus daemon -> sender it's just sender -> service -> sender.
> * fewer message copies in userspace. For a full-duplex method call
> it's down from eight to two: instead of copying the method call data
> into a socket, out of a socket, into a socket, out of a socket, and
> the same for the method reply, we just copy one message directly to
> the receiver, and the reply back.
> * generally fewer syscalls involved. A synchronous method call is now
> doable in a single ioctl on the sender side.
> * memfds can be used for transport purposes of larger payload. This
> way, we can cover substantial payload sizes instead of just small
> control messages, with no extra copies. kdbus, in its transport layer,
> makes sure only sealed memfds are passed in as payload, so the sender
> cannot modify the contents while the receiver is already parsing it.

There should be a number measured in, say, nanoseconds in here
somewhere.  The actual extent of the speedup is unmeasurable here.
Also, it's worth reading at least one of Linus' many rants about
zero-copy.  It's not an automatic win.

--Andy
