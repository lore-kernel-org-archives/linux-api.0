From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 00/14] Add kdbus implementation
Date: Tue, 17 Mar 2015 12:24:50 -0700
Message-ID: <CALCETrUjqTH14fZCeqU_OBoKX_6x4B=712WTeSqSAztpgXGiDw@mail.gmail.com>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 9, 2015 at 6:09 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> kdbus is a kernel-level IPC implementation that aims for resemblance to
> the the protocol layer with the existing userspace D-Bus daemon while
> enabling some features that couldn't be implemented before in userspace.
>

[...]

What changed from last time?

The discussion from last time about performance seems to have stalled.
kdbus is supposed to be fast -- that seems to be a large part of the
point.  Can anyone comment on how fast it actually is.  I'm curious
about:

 - The time it takes to do the ioctl to send a message

 - The time it takes to receive a message (poll + whatever ioctls)

 - The time it takes to transfer a memfd (I don't care about how long
it takes to create or map a memfd -- that's exactly the same between
kdbus and any other memfds user, I imagine)

 - The time it takes to connect

I'm also interested in whether the current design is actually amenable
to good performance.  I'm told that it is, but ISTM there's a lot of
heavyweight stuff going on with each send operation that will be hard
to remove.

--Andy
