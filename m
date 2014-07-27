From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Sun, 27 Jul 2014 16:53:23 -0700
Message-ID: <87oawa740c.fsf@x220.int.ebiederm.org>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
	<20140727210617.GY6725@thunk.org>
	<CALCETrXfzOZEC3mOKkm3_GvitvkEu4kAa3LowRv-fjHnzrQnBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXfzOZEC3mOKkm3_GvitvkEu4kAa3LowRv-fjHnzrQnBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Sun, 27 Jul 2014 15:17:15 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Jul 27, 2014 5:06 PM, "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org> wrote:
>>
>> On Fri, Jul 25, 2014 at 11:30:48AM -0700, Andy Lutomirski wrote:
>> >
>> > There is recent interest in having a way to turn generally-available
>> > kernel features off.  Maybe we should add a good one so we can stop
>> > bikeshedding and avoid proliferating dumb interfaces.
>>
>> I believe the seccomp infrastructure (which is already upstream)
>> should be able to do most of what you want, at least with respect to
>> features which are exposed via system calls (which was most of your
>> list).
>
> Seccomp can't really restrict lookups of non-self pids.  In fact, this
> feature idea started out as a response to a patch adding a kind of
> nasty seccomp feature to make it sort of possible.
>
> I agree that that seccomp can turn off GRND_RANDOM, but how is it
> supposed to do it in such a way that the filtered software will fall
> back to something sensible?  -ENOSYS?  -EPERM?  Something else?
>
> I think that -ENOSYS is clearly wrong, but standardizing this would be
> nice.  Admittedly, adding something fancy like this for GRND_RANDOM
> may not be appropriate.

Andy you seem to be arguing here for two system calls.
get_urandom() and get_random().

Where get_urandom only blocks if there is not enough starting entropy,
and get_random(GRND_RANDOM) blocks if there is currently not enough
entropy.

That would allow -ENOSYS to be the right return value and it would
simply things for everyone.

Eric
