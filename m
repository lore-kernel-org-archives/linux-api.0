From: Djalal Harouni <tixxdz@opendz.org>
Subject: Re: kdbus: add code for buses, domains and endpoints
Date: Thu, 30 Oct 2014 19:08:13 +0100
Message-ID: <20141030180813.GA11850@dztty>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
 <8738a6w6kv.fsf@x220.int.ebiederm.org>
 <20141030095854.GA4716@dztty>
 <87wq7hiwjb.fsf@x220.int.ebiederm.org>
 <20141030144855.GA9705@dztty>
 <CALCETrXeNQUuwiyaJrbbbZUrSW3NTucRgpg0kKEuS3yszP-09w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXeNQUuwiyaJrbbbZUrSW3NTucRgpg0kKEuS3yszP-09w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Simon McVittie <simon.mcvittie@collabora.co.uk>, Daniel Mack <daniel@zonque.org>, "alban.crequy" <alban.crequy@collabora.co.uk>, Javier Martinez Canillas <javier.martinez@collabora.co.uk>, Tom Gundersen <teg@jklm.no>
List-Id: linux-api@vger.kernel.org

Hi Andy,

On Thu, Oct 30, 2014 at 07:58:04AM -0700, Andy Lutomirski wrote:
> On Thu, Oct 30, 2014 at 7:48 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > On Thu, Oct 30, 2014 at 05:15:04AM -0700, Eric W. Biederman wrote:
> >> Djalal Harouni <tixxdz@opendz.org> writes:
> >> What others are doing makes it very hard to safely use allow those
> >> ioctls in a tightly sandboxed application, as it is unpredictable
> >> what the sandboxed ioctl can do with the file descriptor.
> >>
> >> Further an application that calls setresuid at different times during
> >> it's application will behave differently.  Which makes ioctls that do
> >> not have consistent behavior after open time inappropriate for use in
> >> userspace libraries.
> > We are consistent in our checks, you say that the application will
> > behave differently when it calls setresuid() sure! If it changes its
> > creds then regain of course it will behave differently! and the checks
> > are here to make sure that setresuid() and alike work correctly when the
> > application changes its creds and calls-in.
> >
> 
> Except that it isn't consistent.
>
> If I open a postgresql socket that wants me to be root and then I drop
> privileges, I can keep talking to postresql.  This is a good thing,
> because it means that I can keep talking to postgresql but I lose my
> privilege to do other things.
Yes, that's nice :-)

But here you are not following about those capable() checks in ioctl(),
here you are referring to the send (talking) logic! which is another
thing. But hey we do not break that use case, we support it.


> The new kdbus model breaks this.  If I start as root and drop
> privileges to UID_PRIVSEP, then my attempts to communicate over
> already-open connections shouldn't consider UID_PRIVSEP.  In the, they
> shouldn't tell the other endpoints that UID_PRIVSEP exists at all
> unless I've explicitly asked the kernel for this behavior.
Yes, but kdbus tries to follow D-Bus which is primarily an RPC system,
not just a stream of bytes.

So we really want to be able to perform real time checks and authorise
method calls on the bus, and not just connections. I mean yes we do our
kdbus talk access checks on send (Talk) requests using creds of the
connection at creation time, but in the other hand we also need and have
to deal with D-Bus method requests which is the primary usecase here.

So, this is similar to AF_UNIX sockets. For them there's SCM_CREDENTIALS
and SO_PEERCRED. The former uses credentials at the time of when
messages are being sent, the latter uses the credentials at the time
when when the connection was initially established. So to not break
things, we provide similar APIs for services:

1) To get the creds of the connection (when the connection was created).

2) To get the creds of the sender of the message during send time. This
is specially relevent to authorize specific D-Bus method calls, by
checking the creds of the caller, not the one who created the kdbus
connection.

Hmm, a comparison for this model can be made with the kernel's own
syscalls: the same way syscalls are authorized or refused based on the
caller's creds at the time of the syscall... you can't hide that
information. We follow the same semantics here, and use it to allow
inter-process method calls. Having an fd passed is just a detail, the
focus should be put on the methode calls and how to perform the correct
access checks against realtime creds.

Thank you Andy for your comments!


-- 
Djalal Harouni
http://opendz.org
