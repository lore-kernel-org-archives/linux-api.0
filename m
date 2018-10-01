From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC 0/2] ns: introduce binfmt_misc namespace
Date: Mon, 01 Oct 2018 09:21:41 +0200
Message-ID: <874le63zei.fsf@xmission.com>
References: <20180930234628.25528-1-laurent@vivier.eu>
        <CALCETrWcQtLTVJU14ytWxu_gqoLuAYZJpyAvRsKwwgYZz7FEFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWcQtLTVJU14ytWxu_gqoLuAYZJpyAvRsKwwgYZz7FEFg@mail.gmail.com>
        (Andy Lutomirski's message of "Sun, 30 Sep 2018 21:45:44 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: laurent@vivier.eu, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Dmitry Safonov <dima@arista.com>, Andrey Vagin <avagin@openvz.org>, Linux Containers <containers@lists.linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@kernel.org> writes:

> On Sun, Sep 30, 2018 at 4:47 PM Laurent Vivier <laurent@vivier.eu> wrote:
>>
>> This series introduces a new namespace for binfmt_misc.
>>
>
> This seems conceptually quite reasonable, but I'm wondering if the
> number of namespace types is getting out of hand given the current
> API.  Should we be considering whether we need a new set of namespace
> creation APIs that scale better to larger numbers of namespace types?

I would rather encourage a way to make this part of an existing
namespace or find a way to make a mount of binfmt_misc control this.

Hmm.  This looks like something that can be very straight forwardly be
made part of the user namespace.  If you ever mount binfmt_misc in the
user namespace you get the new behavior.  Otherwise you get the existing
behavior.

A user namespace will definitely be required, as otherwise you run the
risk of confusing root (and suid root exectuables0 by being able to
change the behavior of executables.

What is the motivation for this?  My impression is that very few people
tweak binfmt_misc.

I also don't think this raises to the level where it makes sense to
create a new namespace for this.

Eric
