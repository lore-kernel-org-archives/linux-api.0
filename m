From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 01/10] security: Override creds in __fput() with last
 fputter's creds [ver #3]
Date: Thu, 6 Jun 2019 12:09:06 -0700
Message-ID: <e434a62a-d92a-c6e2-cda1-309ac99d4d5c@schaufler-ca.com>
References: <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk>
 <155981413016.17513.10540579988392555403.stgit@warthog.procyon.org.uk>
 <176F8189-3BE9-4B8C-A4D5-8915436338FB@amacapital.net>
 <11031.1559833574@warthog.procyon.org.uk>
 <CALCETrUukxNNhbBAifxz1EADzLOvYKoh9oqqZFJteU+MMhh1ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUukxNNhbBAifxz1EADzLOvYKoh9oqqZFJteU+MMhh1ig@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On 6/6/2019 10:18 AM, Andy Lutomirski wrote:
> On Thu, Jun 6, 2019 at 8:06 AM David Howells <dhowells@redhat.com> wrot=
e:
>> Andy Lutomirski <luto@amacapital.net> wrote:
>>
>>>> So that the LSM can see the credentials of the last process to do an=
 fput()
>>>> on a file object when the file object is being dismantled, do the fo=
llowing
>>>> steps:
>>>>
>>> I still maintain that this is a giant design error.
>> Yes, I know.  This was primarily a post so that Greg could play with t=
he USB
>> notifications stuff I added.  The LSM support isn't resolved and is un=
changed.
>>
>>> Can someone at least come up with a single valid use case that isn't
>>> entirely full of bugs?
>> "Entirely full of bugs"?
> I can say "hey, I have this policy that the person who triggered an
> event needs such-and-such permission, otherwise the event gets
> suppressed".  But this isn't a full use case, and it's buggy.  It's
> not a full use case because I haven't specified what my actual goal is
> and why this particular policy achieves my goals.  And it's entirely
> full of bugs because, as this patch so nicely illustrates, it's not
> well defined who triggered the event.  For example, if I exec a setuid
> process, who triggers the close?  What if I send the fd to systemd
> over a socket and immediately close my copy before systemd gets (and
> ignores) the message?  Or if I send it to Wayland, or to any other
> process?
>
> A file is closed when everyone is done with it.  Trying to figure out
> who the last intentional user of the file was seems little better than
> random guessing.  Defining a security policy based on it seems like a
> poor idea.
>
>> How would you propose I deal with Casey's requirement?  I'm getting th=
e
>> feeling you're going to nak it if I try to fulfil that and he's going =
to nak
>> it if I don't.
>>
> Casey, I think you need to state your requirement in a way that's well
> defined, and I think you need to make a compelling case that your
> requirement is indeed worth dictating the design of parts of the
> kernel outside LSM.

Err, no, I don't believe so. There's a whole lot more
going on in this discussion than just what's going on
within the LSMs. Using examples from the LSMs makes it
easier, because their policies are better defined than
the "legacy" policies are. The most important part of the
discussion is about ensuring that the event mechanism
doesn't circumvent the legacy policies. Yes, I understand
that you don't know what that means, or has to do with
anything.
