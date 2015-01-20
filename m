From: Johannes Stezenbach <js@sig21.net>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Tue, 20 Jan 2015 17:08:42 +0100
Message-ID: <20150120160842.GA9474@sig21.net>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com>
 <CANq1E4SjfZOKqTsdkt519vKc1Poeah5McVJBb_spdHjbKv4=7g@mail.gmail.com>
 <CA+5PVA46wVa-L9K1zgHzt=Fwn6YFBYhxJUjiozSH4XBY03WMVw@mail.gmail.com>
 <20150120145353.GA8124@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150120145353.GA8124@dztty>
Sender: linux-kernel-owner@vger.kernel.org
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, David Herrmann <dh.herrmann@gmail.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Daniel Mack <daniel@zonque.org>
List-Id: linux-api@vger.kernel.org

Hi all,

On Tue, Jan 20, 2015 at 03:53:53PM +0100, Djalal Harouni wrote:
> On Tue, Jan 20, 2015 at 09:42:59AM -0500, Josh Boyer wrote:
> > On Tue, Jan 20, 2015 at 9:31 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> > >
> > > If you run a 3.18 kernel, you can install kdbus.ko from our repository
> > > and boot a full Fedora system running Gnome3 with kdbus, given that
> > > you compiled systemd with --enable-kdbus (which is still
> > > experimental). No legacy dbus1 daemon is running. Instead, we have a
> > > bus-proxy that converts classic dbus1 to kdbus, so all
> > > bus-communication runs on kdbus.
> > 
> > FWIW, we've been building a "playground" repository for the kernel
> > that contains this already for Fedora.  If you have a stock Fedora 21
> > or rawhide install, you can use:
> > 
> > https://copr.fedoraproject.org/coprs/jwboyer/kernel-playground/
> > 
> > which has the kernel+kdbus and systemd built with --enable-kdbus
> > already.  Easy enough to throw in a VM for testing.
> 
> Another addition, if kdbus is installed and loaded, you could also use
> systemd-nspawn to boot a full system (systemd compiled with
> --enable-kdbus) in a container [1], kdbusfs will be mounted in the
> container.
> 
> There is also the busctl tool to query kdbus...
> 
> http://www.freedesktop.org/wiki/Software/systemd/VirtualizedTesting/

It is reassuring that kdbus actually works :)

However, let me repeat and rephrase my previous questions:
Is there a noticable or measurable improvement from using kdbus?
IOW, is the added complexity of kdbus worth the result?

I have stated my believe that current usage of D-Bus is not
performance sensitive and the number of messages exchanged
is low.  I would love it if you would prove me wrong.
Or if you could show that any D-Bus related bug in Gnome3
is fixed by kdbus.

I would sooo love it if someone would finally post some
data that proves kdbus is useful beyond systemd.


Thanks,
Johannes
