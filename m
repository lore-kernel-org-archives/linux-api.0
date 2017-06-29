From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 13:57:41 -0700
Message-ID: <CA+55aFyCMha0Q1=wRFP-Xa93SHvr97sa1bzJDsx0m3=GyiqADw@mail.gmail.com>
References: <20170614222017.14653-3-mcgrof@kernel.org> <20170629125402.GH26046@kroah.com>
 <alpine.DEB.2.20.1706291504570.1861@nanos> <20170629133530.GA14747@kroah.com>
 <alpine.DEB.2.20.1706291545320.1861@nanos> <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629174046.GC3954@linux-80c1.suse> <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
 <20170629183339.GD3954@linux-80c1.suse> <CA+55aFz8Mhx+A-g-5yOG-O1ZLRUR_fpeeA4iBNGH8EnDBZEdpA@mail.gmail.com>
 <20170629194015.GQ21846@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170629194015.GQ21846-B4tOwbsTzaBolqkO4TVVkw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel Grumbach <emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Coelho, Luciano" <luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Andrew Lutomirski <luto@kernel.>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 29, 2017 at 12:40 PM, Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Jun 29, 2017 at 11:59:29AM -0700, Linus Torvalds wrote:
>> > at a time... I'm probably missing your point here.
>>
>> The *reason* they wake up only one seems to be that there really is
>> just one. It's some per-cpu idle thread for kvm, and for RCU it's the
>> RCU workqueue thread.
>>
>> So the queue literally looks suspiciously pointless.
>>
>> But I might be wrong, and there can actually be multiple entries.
>
> Since this swake_up() --> swake_up_all() reportedly *fixed* the one wake up
> issue it would seem this does queue [0].

I'm not talking about the firmware code.

That thing never had an excuse to use swait in the first place.

I'm talking about kvm and rcu, which *do* have excuses to use it, but
where I argue that swait is _still_ a questionable interface for other
reasons.

                Linus
