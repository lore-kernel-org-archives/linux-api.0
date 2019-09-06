From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Why add the general notification queue and its sources
Date: Fri, 6 Sep 2019 10:14:17 -0700
Message-ID: <930B6F39-4174-46C2-B556-E98ED72E27F8@amacapital.net>
References: <156763534546.18676.3530557439501101639.stgit@warthog.procyon.org.uk> <CAHk-=wh5ZNE9pBwrnr5MX3iqkUP4nspz17rtozrSxs5-OGygNw@mail.gmail.com> <17703.1567702907@warthog.procyon.org.uk> <CAHk-=wjQ5Fpv0D7rxX0W=obx9xoOAxJ_Cr+pGCYOAi2S9FiCNg@mail.gmail.com> <CAKCoTu7ms_Mr-q08d9XB3uascpzwBa5LF9JTT2aq8uUsoFE8aQ@mail.gmail.com> <CAHk-=wjcsxQ8QB_v=cwBQw4pkJg7pp-bBsdWyPivFO_OeF-y+g@mail.gmail.com> <5396.1567719164@warthog.procyon.org.uk> <CAHk-=wgbCXea1a9OTWgMMvcsCGGiNiPp+ty-edZrBWn63NCYdw@mail.gmail.com> <14883.1567725508@warthog.procyon.org.uk> <CAHk-=wjt2Eb+yEDOcQwCa0SrZ4cWu967OtQG8Vz21c=n5ZP1Nw@mail.gmail.com> <27732.1567764557@warthog.procyon.org.uk> <CAHk-=wiR1fpahgKuxSOQY6OfgjWD+MKz8UF6qUQ6V_y2TC_V6w@mail.gmail.com> <CAHk-=wioHmz69394xKRqFkhK8si86P_704KgcwjKxawLAYAiug@mail.gmail.com>
  <8e60555e-9247-e03f-e8b4-1d31f70f1221@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8e60555e-9247-e03f-e8b4-1d31f70f1221@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Howells <dhowells@redhat.com>, Ray Strode <rstrode@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, Christian Brauner <christian@brauner.io>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "Ray, Debarshi" <debarshi.ray@gmail.com>, Robbie Harwood <rharwood@redhat.com>
List-Id: linux-api@vger.kernel.org



> On Sep 6, 2019, at 9:12 AM, Steven Whitehouse <swhiteho@redhat.com> wrote:=

>=20
> Hi,
>=20
>> On 06/09/2019 16:53, Linus Torvalds wrote:
>> On Fri, Sep 6, 2019 at 8:35 AM Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> This is why I like pipes. You can use them today. They are simple, and
>>> extensible, and you don't need to come up with a new subsystem and
>>> some untested ad-hoc thing that nobody has actually used.
>> The only _real_ complexity is to make sure that events are reliably parse=
able.
>>=20
>> That's where you really want to use the Linux-only "packet pipe"
>> thing, becasue otherwise you have to have size markers or other things
>> to delineate events. But if you do that, then it really becomes
>> trivial.
>>=20
>> And I checked, we made it available to user space, even if the
>> original reason for that code was kernel-only autofs use: you just
>> need to make the pipe be O_DIRECT.
>>=20
>> This overly stupid program shows off the feature:
>>=20
>>         #define _GNU_SOURCE
>>         #include <fcntl.h>
>>         #include <unistd.h>
>>=20
>>         int main(int argc, char **argv)
>>         {
>>                 int fd[2];
>>                 char buf[10];
>>=20
>>                 pipe2(fd, O_DIRECT | O_NONBLOCK);
>>                 write(fd[1], "hello", 5);
>>                 write(fd[1], "hi", 2);
>>                 read(fd[0], buf, sizeof(buf));
>>                 read(fd[0], buf, sizeof(buf));
>>                 return 0;
>>         }
>>=20
>> and it you strace it (because I was too lazy to add error handling or
>> printing of results), you'll see
>>=20
>>     write(4, "hello", 5)                    =3D 5
>>     write(4, "hi", 2)                       =3D 2
>>     read(3, "hello", 10)                    =3D 5
>>     read(3, "hi", 10)                       =3D 2
>>=20
>> note how you got packets of data on the reader side, instead of
>> getting the traditional "just buffer it as a stream".
>>=20
>> So now you can even have multiple readers of the same event pipe, and
>> packetization is obvious and trivial. Of course, I'm not sure why
>> you'd want to have multiple readers, and you'd lose _ordering_, but if
>> all events are independent, this _might_ be a useful thing in a
>> threaded environment. Maybe.
>>=20
>> (Side note: a zero-sized write will not cause a zero-sized packet. It
>> will just be dropped).
>>=20
>>                Linus
>=20
> The events are generally not independent - we would need ordering either i=
mplicit in the protocol or explicit in the messages. We also need to know in=
 case messages are dropped too - doesn't need to be anything fancy, just som=
e idea that since we last did a read, there are messages that got lost, most=
 likely due to buffer overrun.

This could be a bit fancier: if the pipe recorded the bitwise or of the firs=
t few bytes of dropped message, then the messages could set a bit in the hea=
der indicating the type, and readers could then learn which *types* of messa=
ges were dropped.

Or they could just use multiple pipes.

If this whole mechanism catches on, I wonder if implementing recvmmsg() on p=
ipes would be worthwhile.=
