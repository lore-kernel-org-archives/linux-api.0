From: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Tue, 20 Jan 2015 15:53:53 +0100
Message-ID: <20150120145353.GA8124@dztty>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com>
 <CANq1E4SjfZOKqTsdkt519vKc1Poeah5McVJBb_spdHjbKv4=7g@mail.gmail.com>
 <CA+5PVA46wVa-L9K1zgHzt=Fwn6YFBYhxJUjiozSH4XBY03WMVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+5PVA46wVa-L9K1zgHzt=Fwn6YFBYhxJUjiozSH4XBY03WMVw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

On Tue, Jan 20, 2015 at 09:42:59AM -0500, Josh Boyer wrote:
> On Tue, Jan 20, 2015 at 9:31 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Hi Michael
> >
> > On Tue, Jan 20, 2015 at 2:53 PM, Michael Kerrisk (man-pages)
> > <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> On 01/16/2015 08:16 PM, Greg Kroah-Hartman wrote:
> >>> From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
> >>>
> >>> kdbus is a system for low-latency, low-overhead, easy to use
> >>> interprocess communication (IPC).
> >>>
> >>> The interface to all functions in this driver is implemented via ioctls
> >>> on files exposed through a filesystem called 'kdbusfs'. The default
> >>> mount point of kdbusfs is /sys/fs/kdbus. This patch adds detailed
> >>> documentation about the kernel level API design.
> >>
> >> I have some details feedback on the contents of this file, and some
> >> bigger questions. I'll split them out into separate mails.
> >>
> >> So here, the bigger, general questions to start with. I've arrived late
> >> to this, so sorry if they've already been discussed, but the answers to
> >> some of the questions should actually be in this file, I would have
> >> expected.
> >>
> >> This is an enormous and complex API. Why is the API ioctl() based,
> >> rather than system-call-based? Have we learned nothing from the hydra
> >> that the futex() multiplexing syscall became? (And kdbus is an order
> >> of magnitude more complex, by the look of things.) At the very least,
> >> a *good* justification of why the API is ioctl()-based should be part
> >> of this documentation file.
> >>
> >> An observation: The documentation below is substantial, but this API is
> >> enormous, so the documentation still feels rather thin. What would
> >> really help would be some example code in the doc.
> >>
> >> And on the subject of code examples... Are there any (prototype)
> >> working user-space applications that exercise the current kdbus
> >> implementation? That is, can I install these kdbus patches, and
> >> then find a simple example application somewhere that does
> >> something to exercise kdbus?
> >
> > If you run a 3.18 kernel, you can install kdbus.ko from our repository
> > and boot a full Fedora system running Gnome3 with kdbus, given that
> > you compiled systemd with --enable-kdbus (which is still
> > experimental). No legacy dbus1 daemon is running. Instead, we have a
> > bus-proxy that converts classic dbus1 to kdbus, so all
> > bus-communication runs on kdbus.
> 
> FWIW, we've been building a "playground" repository for the kernel
> that contains this already for Fedora.  If you have a stock Fedora 21
> or rawhide install, you can use:
> 
> https://copr.fedoraproject.org/coprs/jwboyer/kernel-playground/
> 
> which has the kernel+kdbus and systemd built with --enable-kdbus
> already.  Easy enough to throw in a VM for testing.
> 
> josh
Yes thanks josh!

Another addition, if kdbus is installed and loaded, you could also use
systemd-nspawn to boot a full system (systemd compiled with
--enable-kdbus) in a container [1], kdbusfs will be mounted in the
container.

There is also the busctl tool to query kdbus...

http://www.freedesktop.org/wiki/Software/systemd/VirtualizedTesting/

-- 
Djalal Harouni
http://opendz.org
