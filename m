From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Date: Thu, 24 Jul 2014 16:27:36 -0700
Message-ID: <CALCETrVgKMVnBuzE+bCXaUPRrqhVxwv4AXmJrUJSYws5rZxhJw@mail.gmail.com>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
 <20140724151814.GE32421@khazad-dum.debian.net> <CALCETrXAA=UzS-pRCo5tKSjSCOP9xfu66BG9QbRefVrovkavhQ@mail.gmail.com>
 <20140724190206.GL6673@thunk.org> <20140724203019.GA20737@khazad-dum.debian.net>
 <20140724232434.GN6673@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20140724232434.GN6673@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Andy Lutomirski <luto@amacapital.net>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 24, 2014 at 4:24 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 24, 2014 at 05:30:19PM -0300, Henrique de Moraes Holschuh wrote:
>> > I wouldn't add the error to the man page until we actually modify the
>> > kernel to add such a restriction.
>>
>> By then, it might be too late.  It would be really sad to find ourselves
>> forced to return ENOSYS to getrandom(GRND_RANDOM) when we actually wanted to
>> return EPERM/EACCES.
>
> I wouldn't worry about.  The reality is that anyone using GRND_RANDOM
> has to be checking for error codes anyway, and if they do something
> stupid because the system call returns EPERM/EACCESS when they weren't
> expecting it, again, they are much more likely to be making many other
> fatal mistakes anyway.
>
> In general, all system calls can return errno's other than the ones
> documented in the man page.  This is certainly true for open(2), and
> read(2) if you are using a network file system such as NFS.  Someone
> who assumes that the only errors that they have to handle is the list
> in the man page, and assumes that this list is an exhaustive listing
> of all possible errors, is going to be in a *world* of hurt.
>
> I don't think it's necessary to add a sentence that other errors can
> be returned in the future, and users much check for other errors, but
> if you really think people are that stupid that we need to say
> something which is true for every single system call in Linux, we can
> do that....

I think that people might do:

try getrandom(GRND_RANDOM)
fall back to /dev/random
fall back to something intensely stupid

We want them to at least attempt the fallback from GRND_RANDOM to !GRND_RANDOM.

--Andy
