From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: kdbus: add code for buses, domains and endpoints
Date: Thu, 30 Oct 2014 15:00:57 -0700
Message-ID: <CALCETrXbwFUR1fj8SnGMQ6VpTV9=5t+bWxWs3abx0XXORg0TAQ@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
 <8738a6w6kv.fsf@x220.int.ebiederm.org> <20141030095854.GA4716@dztty>
 <87wq7hiwjb.fsf@x220.int.ebiederm.org> <20141030144855.GA9705@dztty>
 <CALCETrXeNQUuwiyaJrbbbZUrSW3NTucRgpg0kKEuS3yszP-09w@mail.gmail.com>
 <20141030180813.GA11850@dztty> <CALCETrW27mdY1qG4nnxC3JvsDG+1C8kMv93WpHwO0xs0CiayVw@mail.gmail.com>
 <m2ublh$5h7$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <m2ublh$5h7$2@ger.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 2:47 PM, Alex Elsayed <eternaleye-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Andy Lutomirski wrote:
>
>> On Thu, Oct 30, 2014 at 11:08 AM, Djalal Harouni
>> <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org> wrote:
>>> Hi Andy,
>>>
>>> 2) To get the creds of the sender of the message during send time. This
>>> is specially relevent to authorize specific D-Bus method calls, by
>>> checking the creds of the caller, not the one who created the kdbus
>>> connection.
>>
>> Please humor me here: can you describe, concretely, a case where
>> authorization of the principal issuing a method call is more correct
>> than authorization of the principal who connected to the object being
>> acted on?
>>
>> I suspect that such examples are actually quite difficult to find.
>>
>> --Andy
>
> The simple answer is that this is a misaimed question - you don't connect to
> the object being acted on.
>
> You connect to the _same bus_ as other clients have connected to. You then
> act on objects they have made available on the bus.
>
> You might have connected to a restricted endpoint, which provides a narrowed
> view of the bus, but that's neither the same thing nor mandatory.

OK, but this doesn't answer the question.  It is not an example of a
case where checking credentials at the time of connection to the bus
is actually worse from a security standpoint than checking for
credentials at the time of the send.

--Andy
