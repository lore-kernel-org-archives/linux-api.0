From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Wed, 29 Oct 2014 16:55:57 -0700
Message-ID: <CALCETrXY90YAXA9-GLc0EowmRCtWZzh8br8seiqrzOkmNn8_Hw@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz> <20141029231106.GB16548@kroah.com>
 <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz> <20141029234001.GB16520@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141029234001.GB16520@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>, Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org, alban.crequy@collabora.co.uk, Javier Martinez Canillas <javier.martinez@collabora.co.uk>, Tom Gundersen <teg@jklm.no>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 29, 2014 at 4:40 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Oct 30, 2014 at 12:24:02AM +0100, Jiri Kosina wrote:
>> On Wed, 29 Oct 2014, Greg Kroah-Hartman wrote:
>>
>> > > > kdbus is a kernel-level IPC implementation that aims for resemblance to
>> > > > the the protocol layer with the existing userspace D-Bus daemon while
>> > > > enabling some features that couldn't be implemented before in userspace.
>> > >
>> > > I'd be interested in the features that can't be implemented in userspace
>> > > (and therefore would justify existence of kdbus in the kernel). Could you
>> > > please point me to such list / documentation?
>> >
>> > Lennart has given whole talks about this in the past, here's a recent
>> > talk going into the details:
>> >     https://www.youtube.com/watch?v=HPbQzm_iz_k
>>
>> I think it's a reasonable expectation that kernel patch submissions should
>> be reasonably self-contained though. We've always been very strict about
>> pushing everybody to provide extensive cover letters, changelogs and
>> explanations, so this shouldn't really be an exception, I think.
>
> There is a 1815 line documentation file in this series, so we aren't
> trying to not provide this type of information here at all.  But yes,
> more background, about why this can't be done in userspace (zero copy,
> less context switches, proper credential passing, timestamping, availble
> at early-boot, LSM hooks for security models to tie into, race-free
> interfaces, container/namespace support, etc.) should be added to the
> docs as well.

It's worth noting that:

 - Proper credential passing could be added to UNIX sockets, and we
may want to do that anyway.  Also, the current kdbus semantics seem to
be "spew lots of credentials and other miscellaneous
potentially-sensitive and sometime spoofable information all over the
place", which isn't obviously an improvement.  (This is fixable, but
it will almost certainly not be compatible with current systemd kdbus
code if fixed.)

 - The current kdbus patches seem to be worse than UNIX sockets from a
namespace perspective, but maybe I'm misunderstanding how it's
supposed to work.  UNIX sockets work quite nicely in containers.

 - There's an obvious interface to add timestamping to UNIX sockets
(it could work exactly the way it does for UDP / PTP).

 - I'm unconvinced by this performance argument without numbers.  The
kdbus credential code, at least, looks to be quite heavy on allocation
and atomics.  This isn't to say that the current userspace D-Bus
daemon doesn't also serialize everything, but it could be made
multithreaded.

 - Race-free?  What are the races that are inherent to UNIX sockets?

--Andy
