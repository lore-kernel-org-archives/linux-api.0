From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: kdbus: add code for buses, domains and endpoints
Date: Thu, 30 Oct 2014 13:37:47 -0700
Message-ID: <CALCETrW27mdY1qG4nnxC3JvsDG+1C8kMv93WpHwO0xs0CiayVw@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
 <8738a6w6kv.fsf@x220.int.ebiederm.org> <20141030095854.GA4716@dztty>
 <87wq7hiwjb.fsf@x220.int.ebiederm.org> <20141030144855.GA9705@dztty>
 <CALCETrXeNQUuwiyaJrbbbZUrSW3NTucRgpg0kKEuS3yszP-09w@mail.gmail.com> <20141030180813.GA11850@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141030180813.GA11850@dztty>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 11:08 AM, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org> wrote:
> Hi Andy,
>
> On Thu, Oct 30, 2014 at 07:58:04AM -0700, Andy Lutomirski wrote:
>> On Thu, Oct 30, 2014 at 7:48 AM, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org> wrote:
>> > On Thu, Oct 30, 2014 at 05:15:04AM -0700, Eric W. Biederman wrote:
>> >> Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org> writes:
>> >> What others are doing makes it very hard to safely use allow those
>> >> ioctls in a tightly sandboxed application, as it is unpredictable
>> >> what the sandboxed ioctl can do with the file descriptor.
>> >>
>> >> Further an application that calls setresuid at different times during
>> >> it's application will behave differently.  Which makes ioctls that do
>> >> not have consistent behavior after open time inappropriate for use in
>> >> userspace libraries.
>> > We are consistent in our checks, you say that the application will
>> > behave differently when it calls setresuid() sure! If it changes its
>> > creds then regain of course it will behave differently! and the checks
>> > are here to make sure that setresuid() and alike work correctly when the
>> > application changes its creds and calls-in.
>> >
>>
>> Except that it isn't consistent.
>>
>> If I open a postgresql socket that wants me to be root and then I drop
>> privileges, I can keep talking to postresql.  This is a good thing,
>> because it means that I can keep talking to postgresql but I lose my
>> privilege to do other things.
> Yes, that's nice :-)
>
> But here you are not following about those capable() checks in ioctl(),
> here you are referring to the send (talking) logic! which is another
> thing. But hey we do not break that use case, we support it.

I don't understand.  If postgres starts checking the credentials of
the sender of a query (behind the sender's back, because the current
kdbus code does it implicitly), then this *doesn't work*.  Postgres
will see that the sender of the query has the wrong credentials, and
it will reject.

>
>
>> The new kdbus model breaks this.  If I start as root and drop
>> privileges to UID_PRIVSEP, then my attempts to communicate over
>> already-open connections shouldn't consider UID_PRIVSEP.  In the, they
>> shouldn't tell the other endpoints that UID_PRIVSEP exists at all
>> unless I've explicitly asked the kernel for this behavior.
> Yes, but kdbus tries to follow D-Bus which is primarily an RPC system,
> not just a stream of bytes.
>
> So we really want to be able to perform real time checks and authorise
> method calls on the bus, and not just connections. I mean yes we do our
> kdbus talk access checks on send (Talk) requests using creds of the
> connection at creation time, but in the other hand we also need and have
> to deal with D-Bus method requests which is the primary usecase here.

I'm sympathetic to this use case (RPC authorization).  I do think that
you can achieve it by making a new connection at the time at which
authorization is needed, since kdbus is supposed to be lightweight,
but that could be an annoying requirement.

*However*, if an RPC client is making an RPC call that needs
authorization, it should know that it needs authorization, and it
should know what authorization it needs, and it should send that
authorization explicitly.

If you need lots of data for logging, then have the process sending
the log message send that data to the logging daemon.  If the logging
daemon gets less data than it wants, then it can indicate that in the
logs or return an error.

[snip]

> 2) To get the creds of the sender of the message during send time. This
> is specially relevent to authorize specific D-Bus method calls, by
> checking the creds of the caller, not the one who created the kdbus
> connection.

Please humor me here: can you describe, concretely, a case where
authorization of the principal issuing a method call is more correct
than authorization of the principal who connected to the object being
acted on?

I suspect that such examples are actually quite difficult to find.

--Andy
