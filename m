From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Wed, 29 Oct 2014 15:34:19 -0700
Message-ID: <CALCETrWjDnXtQXaPqVZ3xMFjD1-pED1dWj9LytLR0zt-=d0Yqw@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com> <20141029222729.GB8129@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141029222729.GB8129@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>, simon.mcvittie@collabora.co.uk, daniel@zonque.org, alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk, Tom Gundersen <teg@jklm.no>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 29, 2014 at 3:27 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Oct 29, 2014 at 03:15:51PM -0700, Andy Lutomirski wrote:
>> (reply 1/2 -- I'm replying twice to keep the threading sane)
>>
>> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > kdbus is a kernel-level IPC implementation that aims for resemblance to
>> > the the protocol layer with the existing userspace D-Bus daemon while
>> > enabling some features that couldn't be implemented before in userspace.
>> >
>>
>> >  * Support for multiple domains, completely separated from each other,
>> >    allowing multiple virtualized instances to be used at the same time.
>>
>> Given that there is no such thing as a device namespace, how does this work?
>
> See the document for the details.
>
>> The docs seem a bit confusing to me as to whether there's a hierarchy
>> of domains.  Do domains have a concept of a parent?
>
> Yes.

Why?  Aren't they completely isolated?  Confused.

>
>> What's "container-name"?
>
> Is that used in the documentation?

/dev/kdbus/domain/<container-name>/+ directory shows up inside the
domain as /dev/kdbus/.

I guess that's the thing that the creator requests.

--Andy

>
>> Given that domains have random IDs, how can they be checkpointed and restored?
>
> Good question, I don't know about checkpoint/restore, but I think that
> has been done.  Daniel would know more than I do about that.
>
> thanks,
>
> greg k-h



-- 
Andy Lutomirski
AMA Capital Management, LLC
