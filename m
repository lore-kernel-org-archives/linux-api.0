From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: kdbus: add documentation
Date: Tue, 20 Jan 2015 09:25:58 +0100
Message-ID: <54BE1116.5060204@zonque.org>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>	<871tolysbb.fsf@mid.deneb.enyo.de>	<CANq1E4RjwCVEVT7031CeiKrNvRFkLBZc4-X1uKdrdzpf=EwJ+A@mail.gmail.com> <87vblwtxee.fsf@mid.deneb.enyo.de> <54BE0D56.5090301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54BE0D56.5090301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Michael,

On 01/20/2015 09:09 AM, Michael Kerrisk (man-pages) wrote:
> On 11/30/2014 06:23 PM, Florian Weimer wrote:
>> * David Herrmann:
>>
>>> On Sun, Nov 30, 2014 at 10:02 AM, Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>=
 wrote:
>>>> * Greg Kroah-Hartman:
>>>>
>>>>> +7.4 Receiving messages
>>
>>>> What happens if this is not possible because the file descriptor l=
imit
>>>> of the processes would be exceeded?  EMFILE, and the message will =
not
>>>> be received?
>>>
>>> The message is returned without installing the FDs. This is signale=
d
>>> by EMFILE, but a valid pool offset.
>>
>> Oh.  This is really surprising, so it needs documentation.  But it's
>> probably better than the alternative (return EMFILE and leave the
>> message stuck, so that you receive it immediately again=E2=80=94this=
 behavior
>> makes non-blocking accept rather difficult to use correctly).
>=20
> So, was this point in the end explicitly documented? I not
> obvious that it is documented in the revised kdbus.txt that
> Greg K-H sent out 4 days ago.

No, we've revisited this point and changed the kernel behavior again in
v3. We're no longer returning -EMFILE in this case, but rather set
KDBUS_RECV_RETURN_INCOMPLETE_FDS in a new field in the receive ioctl
struct called 'return_flags'. We believe that's a nicer way of signalin=
g
specific errors. The message will carry -1 for all FDs that failed to
get installed, so the user can actually see which one is missing.

That's also documented in kdbus.txt, but we missed putting it into the
Changelog - sorry for that.


Hope this helps,
Daniel
