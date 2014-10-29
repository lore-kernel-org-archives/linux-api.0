From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Wed, 29 Oct 2014 15:28:25 -0700
Message-ID: <CALCETrX6vf7cKy=XDhDtn9hn1W930MRxBa=pk93RnyuZ-EaNyw@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrUBegZ4F1sKq3LxUgANX3=syYOrqOp9=F--g9pkVHHgUA@mail.gmail.com> <20141029222531.GA8129@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141029222531.GA8129@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>, simon.mcvittie@collabora.co.uk, daniel@zonque.org, alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk, Tom Gundersen <teg@jklm.no>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 29, 2014 at 3:25 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Oct 29, 2014 at 03:19:21PM -0700, Andy Lutomirski wrote:
>> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> >  * Attachment of trustable metadata to each message on demand, such as
>> >    the sending peer's timestamp, creds, auxgroups, comm, exe, cmdline,
>> >    cgroup path, capabilities, security label, audit information, etc,
>> >    each taken at the time the sender issued the ioctl to send the
>> >    message. Which of those are actually recorded and attached is
>> >    controlled by the receiving peer.
>>
>> I think that each piece of trustable metadata needs to be explicitly
>> opted-in to by the sender at the time of capture.  Otherwise you're
>> asking for lots of information leaks and privilege escalations.  This
>> is especially important given that some of the items in the current
>> list could be rather sensitive.
>
> You do have to opt-in for this information at time of capture, so I
> don't understand the issue here.  This is the same type of thing that
> dbus does today, and I don't see the information leaks happening there,
> do you?
>

The docs suggest that the *receiver* opts in.

I don't think that current dbus has severe information leaks because
the total scope for information transparently sent to dbus is rather
small (struct ucred only, presumably).

--Andy
