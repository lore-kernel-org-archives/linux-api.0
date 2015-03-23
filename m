From: David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH v4 00/14] Add kdbus implementation
Date: Mon, 23 Mar 2015 16:28:51 +0100
Message-ID: <CANq1E4TtXq02Ug22fsTr8j0X6+vJKvyryALiTEMbT4SMQB1j3g@mail.gmail.com>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrUjqTH14fZCeqU_OBoKX_6x4B=712WTeSqSAztpgXGiDw@mail.gmail.com>
	<CANq1E4Tf_6Cn+sxY=BPEbRpEr5WY+-rRX5gipz-_=4PNLa9bnQ@mail.gmail.com>
	<CALCETrVWbz7YudNQXQD_2PjC1HR0P0cB_1ea8NiYoQPDfQxERg@mail.gmail.com>
	<CANq1E4RA1ok=3Z5W2LkzqaUOKtbMVX_Joxe7_LRbLnQgfRUEYA@mail.gmail.com>
	<CALCETrWCBYzbzG3xZznG4AvVf67E_d8BVmBi1bZsDx7x_2Bh5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWCBYzbzG3xZznG4AvVf67E_d8BVmBi1bZsDx7x_2Bh5g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
List-Id: linux-api@vger.kernel.org

Hi

On Thu, Mar 19, 2015 at 4:48 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Mar 19, 2015 at 4:26 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> metadata handling is local to the connection that sends the message.
>> It does not affect the overall performance of other bus operations in
>> parallel.
>
> Sure it does if it writes to shared cachelines.  Given that you're
> incrementing refcounts, I'm reasonable sure that you're touching lots
> of shared cachelines.

Ok, sure, but it's still mostly local to the sending task. We take
locks and ref-counts on the task-struct and mm, which is for most
parts local to the CPU the task runs on. But this is inherent to
accessing this kind of data, which is the fundamental difference in
our views here, as seen below..

>> Furthermore, it's way faster than collecting the "same" data
>> via /proc, so I don't think it slows down the overall transaction at
>> all. If a receiver doesn't want metadata, it should not request it (by
>> setting the receiver-metadata-mask). If a sender doesn't like the
>> overhead, it should not send the metadata (by setting the
>> sender-metadata-mask). Only if both peers set the metadata mask, it
>> will be transmitted.
>
> But you're comparing to the wrong thing, IMO.  Of course it's much
> faster than /proc hackery, but it's probably much slower to do the
> metadata operation once per message than to do it when you connect to
> the endpoint.  (Gah!  It's a "bus" that could easily have tons of
> users but a single "endpoint".  I'm still not used to it.)

Yes, of course your assumption is right if you compare against
per-connection caches, instead of per-message metadata. But we do
support _both_ use-cases, so we don't impose any policy.
We still believe "live"-metadata is a crucial feature of kdbus,
despite the known performance penalties.

Thanks
David
