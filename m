From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: kdbus: add documentation
Date: Wed, 26 Nov 2014 07:39:22 -0800
Message-ID: <CALCETrWB2ZBnqRtf=1VU9urYxgtgPYNfXy-y=BmhGXi032mhFg@mail.gmail.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
 <1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWUekPq6pquuiVperBihQHgcvCF=WzVJTZziHhUJYsh4Q@mail.gmail.com>
 <CANq1E4QA53-L8vPOWJfjhzXaYVQnNvgvR6AcYev0EaP6SfOjQQ@mail.gmail.com>
 <CALCETrUfNG=YwwM2m78Ua4fUr9daE1omQwOSJQMKC6CTCa28fQ@mail.gmail.com>
 <CANq1E4TOe5SNmAvnjs1LCx9EGrGWxqX8qPUy26n8RzGo2kvThg@mail.gmail.com> <CALCETrV1vChd9m_AtFjPfddqvPK3z3cjROozWJ8HQHSGm5KWJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrV1vChd9m_AtFjPfddqvPK3z3cjROozWJ8HQHSGm5KWJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 26, 2014 at 7:30 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> Then find a clean way that's gated on having the right /proc access,
> which is not guaranteed to exist on all of your eventual users'
> systems, and, if that access doesn't exist because the admin or
> sandbox designer has sensibly revoked it, then kdbus shouldn't
> override them.

One idea: add a sysctl that defaults to off that enables these
metadata items, and keep it disabled on production systems.  Then you
get your debugging and everyone else gets unsurprising behavior.

--Andy

>
> --Andy



-- 
Andy Lutomirski
AMA Capital Management, LLC
