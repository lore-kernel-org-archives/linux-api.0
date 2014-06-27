From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v8 5/9] seccomp: split mode set routines
Date: Fri, 27 Jun 2014 13:08:20 -0700
Message-ID: <CALCETrUxGbTet--zJiKX4BqbOaw2MDBPqT18HaQOdf7zwWWtEw@mail.gmail.com>
References: <CAGXu5j+J11zJnuFR8bYKAXizAHhCx4R+uJE_QH6zC3q2udkpaQ@mail.gmail.com>
 <CALCETrVrs8sb19+UUqyFEpAFzTih5dkAwn-WpQjfgPcPJMpP5g@mail.gmail.com>
 <20140625173245.GA17695@redhat.com> <CALCETrUc65H+fn6dtMdYnB_xR39wcmgDdTbdR3fFRjyrndJhgA@mail.gmail.com>
 <20140625175136.GA18185@redhat.com> <CAGXu5jL17k6=GXju6x+eLU20FMwBHhnuRiHoQD1Bzj_EmpiKjg@mail.gmail.com>
 <CALCETrVNwhWSPNiBiZmgP1nD9zLJPTk6cH0yo=85rbxTPTYFRg@mail.gmail.com>
 <CAGXu5jLavA8FJD8m-1y4wO0uzh3qvvMmajAg0Lrr1Cn_Om3a3w@mail.gmail.com>
 <20140627192753.GA30752@redhat.com> <CALCETrVbJqfG6oBaZEjj7H3pPa1oVJx6QXAYc5zZ6o-niV=WKQ@mail.gmail.com>
 <20140627195559.GA31661@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140627195559.GA31661-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 27, 2014 at 12:55 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 06/27, Andy Lutomirski wrote:
>>
>> On Fri, Jun 27, 2014 at 12:27 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On 06/27, Kees Cook wrote:
>> >>
>> >> It looks like SMP ARM issues dsb for rmb, which seems a bit expensive.
>> >> http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0204g/CIHJFGFE.htm
>> >>
>> >> ...
>> >>
>> >> I really want to avoid adding anything to the secure_computing()
>> >> execution path. :(
>> >
>> > I must have missed something but I do not understand your concerns.
>> >
>> > __secure_computing() is not trivial, and we are going to execute the
>> > filters. Do you really think rmb() can add the noticeable difference?
>> >
>> > Not to mention that we can only get here if we take the slow syscall
>> > enter path due to TIF_SECCOMP...
>> >
>>
>> On my box, with my fancy multi-phase seccomp patches, the total
>> seccomp overhead for a very short filter is about 13ns.  Adding a full
>> barrier would add several ns, I think.
>
> I am just curious, does this 13ns overhead include the penalty from the
> slow syscall enter path triggered by TIF_SECCOMP ?

Yes, which is more or less the whole point of that patch series.  I
rewrote part of the TIF_SECCOMP-but-no-tracing case in assembly :)

I'm playing with rewriting it in C, but it's looking like it'll be a
bit more far-reaching than I was hoping.

--Andy
