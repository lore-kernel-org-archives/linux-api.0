From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: kdbus: add code for buses, domains and endpoints
Date: Thu, 30 Oct 2014 07:58:04 -0700
Message-ID: <CALCETrXeNQUuwiyaJrbbbZUrSW3NTucRgpg0kKEuS3yszP-09w@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
 <8738a6w6kv.fsf@x220.int.ebiederm.org> <20141030095854.GA4716@dztty>
 <87wq7hiwjb.fsf@x220.int.ebiederm.org> <20141030144855.GA9705@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141030144855.GA9705@dztty>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 7:48 AM, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Oct 30, 2014 at 05:15:04AM -0700, Eric W. Biederman wrote:
>> Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org> writes:
>> What others are doing makes it very hard to safely use allow those
>> ioctls in a tightly sandboxed application, as it is unpredictable
>> what the sandboxed ioctl can do with the file descriptor.
>>
>> Further an application that calls setresuid at different times during
>> it's application will behave differently.  Which makes ioctls that do
>> not have consistent behavior after open time inappropriate for use in
>> userspace libraries.
> We are consistent in our checks, you say that the application will
> behave differently when it calls setresuid() sure! If it changes its
> creds then regain of course it will behave differently! and the checks
> are here to make sure that setresuid() and alike work correctly when the
> application changes its creds and calls-in.
>

Except that it isn't consistent.

If I open a postgresql socket that wants me to be root and then I drop
privileges, I can keep talking to postresql.  This is a good thing,
because it means that I can keep talking to postgresql but I lose my
privilege to do other things.

The new kdbus model breaks this.  If I start as root and drop
privileges to UID_PRIVSEP, then my attempts to communicate over
already-open connections shouldn't consider UID_PRIVSEP.  In the, they
shouldn't tell the other endpoints that UID_PRIVSEP exists at all
unless I've explicitly asked the kernel for this behavior.

I suggest reading up on the object capability model.  Linux isn't one,
but large deviations (like kdbus') from an object capability model are
rarely a good thing.

--Andy
